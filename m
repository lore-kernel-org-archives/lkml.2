Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab2C0XDO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 19:03:14 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:13417 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072Ab2C0XDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 19:03:12 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6662"; a="174065685"
Message-ID: <4F724722.2000202@codeaurora.org>
Date: Tue, 27 Mar 2012 16:02:58 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        alan@lxorguk.ukuu.org.uk,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 2/2] firmware_class: Move request_firmware_nowait() to
 workqueues
References: <201203260000.34377.rjw@sisk.pl> <201203280021.27582.rjw@sisk.pl> <20120327224837.GC22371@google.com> <201203280055.06624.rjw@sisk.pl>
In-Reply-To: <201203280055.06624.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/12 15:55, Rafael J. Wysocki wrote:
> On Wednesday, March 28, 2012, Tejun Heo wrote:
>> On Wed, Mar 28, 2012 at 12:21:27AM +0200, Rafael J. Wysocki wrote:
>>> On Wednesday, March 28, 2012, Tejun Heo wrote:
>>>> On Tue, Mar 27, 2012 at 02:28:30PM -0700, Stephen Boyd wrote:
>>>>> Oddly enough a work_struct was already part of the firmware_work
>>>>> structure but nobody was using it. Instead of creating a new
>>>>> kthread for each request_firmware_nowait() call just schedule the
>>>>> work on the long system workqueue. This should avoid some overhead
>>>>> in forking new threads when they're not strictly necessary.
>>>>>
>>>>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>>>>> ---
>>>>>
>>>>> Is it better to use alloc_workqueue() and not put these on the system
>>>>> long workqueue?
>>>> No, just use schedule_work() unless there are specific requirements
>>>> which can't be fulfilled that way (e.g. it's on memory allocation
>>>> path, may consume large amount of cpu cycles, ...)
>>> It may wait quite long.
>> That shouldn't matter.  system_long_wq's name is a bit misleading at
>> this point.  The only reason it's used currently is to avoid cyclic
>> dependency involving flush_workqueue(), which calls for clearer
>> solution anyway.  So, yeap, using system_wq should be fine here.
> Good, thanks for the explanation.
>
> Stephen, care to respin?
>

Sure. We want system_wq instead of system_long_wq? If so let's use this
patch.

-----8<-- cut here -->8------

Subject: [PATCH] firmware_class: Move request_firmware_nowait() to workqueues

Oddly enough a work_struct was already part of the firmware_work
structure but nobody was using it. Instead of creating a new
kthread for each request_firmware_nowait() call just schedule the
work on the system workqueue. This should avoid some overhead
in forking new threads when they're not strictly necessary.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/base/firmware_class.c |   27 +++++++--------------------
 1 file changed, 7 insertions(+), 20 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index ae00a2f..5401814 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -16,10 +16,11 @@
 #include <linux/interrupt.h>
 #include <linux/bitops.h>
 #include <linux/mutex.h>
-#include <linux/kthread.h>
+#include <linux/workqueue.h>
 #include <linux/highmem.h>
 #include <linux/firmware.h>
 #include <linux/slab.h>
+#include <linux/sched.h>
 
 #define to_dev(obj) container_of(obj, struct device, kobj)
 
@@ -630,19 +631,15 @@ struct firmware_work {
 	bool uevent;
 };
 
-static int request_firmware_work_func(void *arg)
+static void request_firmware_work_func(struct work_struct *work)
 {
-	struct firmware_work *fw_work = arg;
+	struct firmware_work *fw_work;
 	const struct firmware *fw;
 	struct firmware_priv *fw_priv;
 	long timeout;
 	int ret;
 
-	if (!arg) {
-		WARN_ON(1);
-		return 0;
-	}
-
+	fw_work = container_of(work, struct firmware_work, work);
 	fw_priv = _request_firmware_prepare(&fw, fw_work->name, fw_work->device,
 			fw_work->uevent, true);
 	if (IS_ERR_OR_NULL(fw_priv)) {
@@ -667,8 +664,6 @@ static int request_firmware_work_func(void *arg)
 
 	module_put(fw_work->module);
 	kfree(fw_work);
-
-	return ret;
 }
 
 /**
@@ -694,7 +689,6 @@ request_firmware_nowait(
 	const char *name, struct device *device, gfp_t gfp, void *context,
 	void (*cont)(const struct firmware *fw, void *context))
 {
-	struct task_struct *task;
 	struct firmware_work *fw_work;
 
 	fw_work = kzalloc(sizeof (struct firmware_work), gfp);
@@ -713,15 +707,8 @@ request_firmware_nowait(
 		return -EFAULT;
 	}
 
-	task = kthread_run(request_firmware_work_func, fw_work,
-			    "firmware/%s", name);
-	if (IS_ERR(task)) {
-		fw_work->cont(NULL, fw_work->context);
-		module_put(fw_work->module);
-		kfree(fw_work);
-		return PTR_ERR(task);
-	}
-
+	INIT_WORK(&fw_work->work, request_firmware_work_func);
+	schedule_work(&fw_work->work);
 	return 0;
 }
 

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

