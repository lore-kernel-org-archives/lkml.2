Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab1KAQml (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 12:42:41 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35198 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab1KAQmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 12:42:40 -0400
Date: Tue, 1 Nov 2011 09:42:35 -0700
From: Tejun Heo <tj@kernel.org>
To: Andrew Watts <akwatts@ymail.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        dmitry.torokhov@gmail.com
Subject: Re: [REGRESSION]: hibernate/sleep regression w/ bisection
Message-ID: <20111101164235.GS18855@google.com>
References: <20111101124759.GA1326@zeus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111101124759.GA1326@zeus>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 01, 2011 at 07:48:19AM -0500, Andrew Watts wrote:
> Hi.
> 
> Hibernate/sleep (echo disk/mem > /sys/power/state) has presented problems
> for me starting with 2.6.39. Kernel 2.6.37.6 was the last completely bug-free
> version I used (I skipped the 2.6.38 branch entirely).
> 
> The symptoms are that upon resume (from sleep/hibernate) there is no video
> nor any keyboard input with the exception of sysrq.
> 
> It has been a frustrating bug to hunt down because it is not easily
> reproduced; sometimes the bug doesn't pop up until after a long sequence of
> hibernate/sleep cycles.
> 
> I successfully bisected the problem to: 8ee294cd9def000.
> 
> =======
> Commit: 8ee294cd9def0004887da7f44b80563493b0a097
> Author: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Date:   Mon Nov 15 01:39:57 2010 -0800
> Input: serio - convert to common workqueue instead of a thread
> =======
> 
> Backing out 8ee294cd9def000 (which requires reversing part of
> 1d64b655dc083df also) fixes this particular problem on 2.6.39.4,
> 3.0.8, and 3.1.
> 
> Unfortunately, in 3.0.8 and 3.1 I have other suspend/hibernate problems
> that I will investigate next and detail in a different regression report.

Does the following patch fix the problem?

Thanks.

diff --git a/drivers/input/serio/serio.c b/drivers/input/serio/serio.c
index ba70058..95aeebd 100644
--- a/drivers/input/serio/serio.c
+++ b/drivers/input/serio/serio.c
@@ -949,6 +949,7 @@ static int serio_resume(struct device *dev)
 	 * deal with it.
 	 */
 	serio_queue_event(serio, NULL, SERIO_RECONNECT_PORT);
+	queue_work(system_long_wq, &serio_event_work);
 
 	return 0;
 }
