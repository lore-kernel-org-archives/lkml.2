Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab1BIWiz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 17:38:55 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:3544 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738Ab1BIWix convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 17:38:53 -0500
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
From: "Ray Jui" <rjui@broadcom.com>
To: "Tejun Heo" <tj@kernel.org>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ray Jui" <rjui@broadcom.com>
Date: Wed, 9 Feb 2011 14:38:36 -0800
Subject: RE: Questions about Linux workqueue in 2.6.36
Thread-Topic: Questions about Linux workqueue in 2.6.36
Thread-Index: AcvIRDLMDm0/noK5QtWMe9lQj3/HKQAY1PZA
Message-ID: <8628FE4E7912BF47A96AE7DD7BAC0AADDDF02C3163@SJEXCHCCR02.corp.ad.broadcom.com>
References: <8628FE4E7912BF47A96AE7DD7BAC0AADDDF02C2EAC@SJEXCHCCR02.corp.ad.broadcom.com>
 <20110209102847.GE3770@htj.dyndns.org>
In-Reply-To: <20110209102847.GE3770@htj.dyndns.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 614DC86E3DG4958995-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

Thanks for your quick response.

You are right. The problem with the rescuer is that when it is leaving a gcwq,
it does not check to see whether it needs to wake up a worker to process subsequent work items. After applying your patch, I see pid 26 getting waken up by the rescuer and work items from mmc1 and mmc2 are now being processed properly.

I also did a quick profiling on the amount of time it takes to create a new worker on our system. It takes 15 ~ 20 ms. This is not surprising as it's an embedded system and it was during kernel boot up and the system was getting quite busy. Regardless, the current 10 ms initial mayday timeout has resolution issues on a lot of embedded systems with worse timer resolutions (e.g., 10 ms on our system).

Thanks for your help on this issue.

Ray Jui
Staff Software Engineer
604-233-9371
rjui@broadcom.com
Broadcom Canada

-----Original Message-----
From: Tejun Heo [mailto:htejun@gmail.com] On Behalf Of Tejun Heo
Sent: Wednesday, February 09, 2011 2:29 AM
To: Ray Jui
Subject: Re: Questions about Linux workqueue in 2.6.36

Hello,

Would you mind cc'ing linux-kernel@vger.kernel.org when replying?  I'm
quoting the whole message.  If you cc lkml when replying, please do
likewise so that the context isn't lost.

On Tue, Feb 08, 2011 at 10:30:47AM -0800, Ray Jui wrote:
> We recently upgraded our system to 2.6.36.3 and are seeing a
> potential workqueue related issue that affects the SD card
> detection. Just wonder if you can provide some help here and that
> will be much appreciated. By the way, we are running 2.6.36.3 on an
> embedded system with ARM cortex A9.
> 
> Here's some background information: Our system uses SD/MMC for 3
> different devices: 1) eMMC that contains the root file system
> (mmc0); 2) standard SD card for mass storage (mmc1); 3) WiFi through
> the SDIO interface (mmc2). We use the open source SDHCI driver with
> some mods which we believe have nothing to do with the problem that
> we are experiencing.
> 
> Quick summary of the problem The SDHCI driver calls
> mmc_detect_change at the driver probe for initial card detection and
> initialization, and that eventually calls queue_delayed_work to
> submit the card detection work item to the workqueue created in the
> MMC core with API create_singlethread_workqueue, which now calls the
> new API alloc_workqueue with the two flags WQ_UNBOUND and WQ_RESUER
> set. What we are seeing is that the first work item (mmc0) gets
> queued up and processed properly. The 2nd and 3rd work items (mmc1
> and mmc2) also got queued up but were never processed. Note that 1)
> queue_delayed_work is called with a delay of zero, so it calls
> queue_work to queue the work directly instead of setting up a timer
> to queue it in the future; 2) work items from mmc0, mmc1, and mmc2
> are different work items (with different addresses) although they
> end up using the same function when the work is eventually being
> processed (i.e., mmc_rescan).
> 
> Worker thread information:
> pid 4 root     [kworker/0:0]
> pid 5 root     [kworker/u:0]
> pid 26 root   [kworker/u:1]
> pid 37 root   [kworker/0:1]

Weird, there should be more workers during boot.

> Detailed work flow:
> 
> 1. First mmc0 work is queued and kworker/u:0 (pid 5) is waken up
> 
> 2. 2nd mmc0 work is submitted before the first one is processed, the
>    kernel detects it (with bit WORK_STRUCT_PENDING_BIT) and drops
>    the 2nd work
> 
> 3. Somehow kworker/u:0 is put to sleep by the scheduler in the
>    middle, now the system calls mayday and the rescuer thread kicks
>    in to process the first mmc0 work

It's a bit weird.  Unless something is already going wrong, the
manager should be able to create a new worker.  Rescuers are called
iff the worker assuming the manager role can't create a new worker in
certain amount of time.  Maybe timer isn't working properly or
something.

> 4. While the first mmc0 work is being processed, kworker/u:0 (pid 5)
>    is waken up again, but then it found the work is being processed
>    by the rescuer, so it goes back to sleep

Yeah, this looks like a proper bug.  When rescuer is leaving a gcwq,
it should wake up a worker; otherwise, the execution slot that the
rescuer was occupying could get lost.

> 5. kworker/u:1 (pid 26) is being created
> 
> 6. mmc1 work is queued, pid 26 waken up but then goes back to sleep
> 
> 7. mmc2 work is queued, pid 26 waken up but then goes back to sleep
>
> 8. First mmc0 work is done and the rescuer goes back to sleep

Yeah, so, the rescuer should kick pid 26 at this point.

> 9. Pid 5 and 26 sleep forever and never wake up
> 
> As you can see from the detailed work flow, mmc1 and mmc2 work items
> were never processed. After this happens, if I submit a new work
> item or flush the workqueue, that would wake up pid 26 which will
> process the queued work items for mmc1 and mmc2.
> 
> Here are my questions:
> 
> 1. This happens during kernel boot up, is that why the mmc0 work
>    item is being processed on the rescuer thread? According to the
>    workqueue documentation, rescuer is supposed to be used only when
>    there's a "memory pressure" on the system. I have a feeling that
>    the problem has something to do with the first work item being
>    processed on the rescuer thread. If it is being processed on the
>    normal kworker thread, then it likely be fine

I don't know why it's behaving like that.  As I wrote above, rescuer
is summoned iff the manager (any worker can assume the role) can't
create another worker in some amount of time.  It's currently set at
10ms.  Hmm... if CONFIG_HZ is 100, this means that the timer can
trigger almost any time depending on where in the 10ms window the
allocation starts.  This should probably be updated to somthing like
max(HZ / 100, 2).

> 2. Do you see any obvious cause of this problem? If not, would you
> please make some suggestions on how I should proceed with debugging
> this issue?

Yeah, please try the patch at the end.  Please let me know if this
resolves the execution stall.

Thanks for the detailed analysis.

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 11869fa..90a17ca 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2047,6 +2047,15 @@ repeat:
 				move_linked_works(work, scheduled, &n);
 
 		process_scheduled_works(rescuer);
+
+		/*
+		 * Leave this gcwq.  If keep_working() is %true, notify a
+		 * regular worker; otherwise, we end up with 0 concurrency
+		 * and stalling the execution.
+		 */
+		if (keep_working(gcwq))
+			wake_up_worker(gcwq);
+
 		spin_unlock_irq(&gcwq->lock);
 	}
 

-- 
tejun


