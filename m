Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932855Ab1CWNIR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 09:08:17 -0400
Received: from smtp.nokia.com ([147.243.128.24]:61145 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932830Ab1CWNIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 09:08:15 -0400
Date: Wed, 23 Mar 2011 15:05:40 +0200 (EET)
From: Aaro Koskinen <aaro.koskinen@nokia.com>
X-X-Sender: aakoskin@esdhcp041196.research.nokia.com
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: tsc2005: fix locking issue
In-Reply-To: <20110322154202.GA24772@core.coreip.homeip.net>
Message-ID: <alpine.DEB.1.10.1103231452530.2634@esdhcp041196.research.nokia.com>
References: <1300724650-6641-1-git-send-email-aaro.koskinen@nokia.com> <20110322061958.GA7990@core.coreip.homeip.net> <alpine.DEB.1.10.1103221655370.2634@esdhcp041196.research.nokia.com> <20110322154202.GA24772@core.coreip.homeip.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 22 Mar 2011, Dmitry Torokhov wrote:
> On Tue, Mar 22, 2011 at 04:59:02PM +0200, Aaro Koskinen wrote:
>> Hi,
>>
>> On Mon, 21 Mar 2011, Dmitry Torokhov wrote:
>>> On Mon, Mar 21, 2011 at 06:24:10PM +0200, Aaro Koskinen wrote:
>>>> Commit 0b950d3 (Input: tsc2005 - add open/close) introduced a
>>>> locking issue with the ESD watchdog: __tsc2005_disable() is calling
>>>> cancel_delayed_work_sync() with mutex held, and the work also needs the
>>>> same mutex.
>>>>
>>>> Fix the problem by using cancel_delayed_work() on disable. If
>>>> the ESD work was running it will check if the device is closed
>>>> or suspended, and in that case it will do nothing and skip
>>>> re-arming. cancel_delayed_work_sync() is still needed when the module
>>>> is removed.
>>>
>>> Hmm, indeed. However, instead of moving cancel_delayed_work_sync() to
>>> remove maybe we should use mutex_trylock() in tsc2005_esd_work()?
>>> If trylock fails that means that device is in the middle of open/close
>>> transition. We should just reschedule the work and get out of there.
>>
>> But I guess the reschedule should not happen if we are in the middle of
>> close/disable? And without the mutex we cannot know that.
>
> It should be OK to reschedule even as we enabling/disabling because
> cancel_delayed_work_sync() handles re-arming works so even if ESD work
> is being executed at the time we closing the device it will be killed
> off completely.

Ok, so here's an updated version:

From: Aaro Koskinen <aaro.koskinen@nokia.com>
Subject: [PATCH] input: tsc2005: fix locking issue

Commit 0b950d3 (Input: tsc2005 - add open/close) introduced a
locking issue with the ESD watchdog: __tsc2005_disable() is calling
cancel_delayed_work_sync() with mutex held, and the work also needs the
same mutex.

Fix the problem by using mutex_trylock() in tsc2005_esd_work(). If the
mutex is taken, we know we are in the middle of disable or enable and
the watchdog check can be skipped.

Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
---
  drivers/input/touchscreen/tsc2005.c |   12 +++++++++++-
  1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/input/touchscreen/tsc2005.c b/drivers/input/touchscreen/tsc2005.c
index 03e4968..cf244be 100644
--- a/drivers/input/touchscreen/tsc2005.c
+++ b/drivers/input/touchscreen/tsc2005.c
@@ -477,7 +477,17 @@ static void tsc2005_esd_work(struct work_struct *work)
  	int error;
  	u16 r;

-	mutex_lock(&ts->mutex);
+	if (!mutex_trylock(&ts->mutex)) {
+		/*
+		 * If the mutex is taken, it means that disable or enable is in
+		 * progress. In that case just reschedule the work. If the work
+		 * is not needed, it will be canceled by disable.
+		 */
+		schedule_delayed_work(&ts->esd_work,
+			round_jiffies_relative(
+				msecs_to_jiffies(ts->esd_timeout)));
+		return;
+	}

  	if (time_is_after_jiffies(ts->last_valid_interrupt +
  				  msecs_to_jiffies(ts->esd_timeout)))
-- 
1.5.6.5

