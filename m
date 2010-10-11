Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334Ab0JKV15 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 17:27:57 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:38257 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756236Ab0JKV14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 17:27:56 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 11 Oct 2010 23:27:42 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] firewire: sbp2: parallelize login/inquiry, reconnect, and
 shutdown
To: Tejun Heo <tj@kernel.org>
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <4CB3148C.5040902@kernel.org>
Message-ID: <tkrat.1386de42b88d7218@s5r6.in-berlin.de>
References: <tkrat.06dc43b96f9ab9bf@s5r6.in-berlin.de>
 <tkrat.1433473bc081daa9@s5r6.in-berlin.de> <4CB3148C.5040902@kernel.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> On 10/10/2010 04:57 PM, Stefan Richter wrote:
> ...
>> Simply swap out the driver workqueue by system_nrt_wq.  It provides all
>> the parallelism we will ever need, accepts long-running work, and
>> provides the here necessary guarantee of non-reentrance across all CPUs.
>                ^^^^
>                this probably should go away?
> 
>> (The work items are scheduled from firewire-core's fw_device work items
>> which themselves may change CPUs.)

Yep.

[...]
>> --- a/drivers/firewire/sbp2.c
>> +++ b/drivers/firewire/sbp2.c
>> @@ -835,8 +835,6 @@ static void sbp2_target_put(struct sbp2_
>>  	kref_put(&tgt->kref, sbp2_release_target);
>>  }
>>  
>> -static struct workqueue_struct *sbp2_wq;
>> -
>>  /*
>>   * Always get the target's kref when scheduling work on one its units.
>>   * Each workqueue job is responsible to call sbp2_target_put() upon return.
>> @@ -844,7 +842,7 @@ static struct workqueue_struct *sbp2_wq;
>>  static void sbp2_queue_work(struct sbp2_logical_unit *lu, unsigned long delay)
>>  {
>>  	sbp2_target_get(lu->tgt);
>> -	if (!queue_delayed_work(sbp2_wq, &lu->work, delay))
>> +	if (!queue_delayed_work(system_nrt_wq, &lu->work, delay))
>>  		sbp2_target_put(lu->tgt);
>>  }
>>  
>> @@ -1656,17 +1654,12 @@ MODULE_ALIAS("sbp2");
>>  
>>  static int __init sbp2_init(void)
>>  {
>> -	sbp2_wq = create_singlethread_workqueue(KBUILD_MODNAME);
>> -	if (!sbp2_wq)
>> -		return -ENOMEM;
>> -
>>  	return driver_register(&sbp2_driver.driver);
>>  }
>>  
>>  static void __exit sbp2_cleanup(void)
>>  {
>>  	driver_unregister(&sbp2_driver.driver);
>> -	destroy_workqueue(sbp2_wq);
> 
> Hmmm... from glancing the code, there doesn't seem to anything which
> can guarantee sbp2_release_target/reconnect() are finished before
> sbp2_cleanup() returns, so the code section might go away with code
> still running.  It seems like the right thing to do here would be
> using alloc_workqueue(KBUILD_MODNAME, WQ_NON_REENTRANT, 0).  Am I
> missing something?

There are indeed situations where the last module reference was already
put down before the work is run for the last time.  Thanks for the hint.

What is preferable, an own workqueue instance whose destroy_workqueue()
lets sbp2_cleanup wait for unfinished work, or module ref-counting like
below?

. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

[PATCH] firewire: sbp2: hold a reference for workqueue jobs

which can be run after sbp2_release.  While SCSI core usually still
holds a reference to the firewire-sbp2 module at that point, it might
not do so anymore in some special cases where the scsi_device was
dropped earlier.

Reported-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/sbp2.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

Index: b/drivers/firewire/sbp2.c
===================================================================
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -821,8 +821,9 @@ static void sbp2_release_target(struct k
 	fw_notify("released %s, target %d:0:0\n", tgt->bus_id, shost->host_no);
 
 	fw_unit_put(tgt->unit);
-	scsi_host_put(shost);
 	fw_device_put(device);
+	scsi_host_put(shost);
+	module_put(THIS_MODULE);
 }
 
 static void sbp2_target_get(struct sbp2_target *tgt)
@@ -1139,13 +1140,17 @@ static int sbp2_probe(struct device *dev
 	struct Scsi_Host *shost;
 	u32 model, firmware_revision;
 
+	/* Take a reference for late workqueue jobs. */
+	if (!try_module_get(THIS_MODULE))
+		return -ECANCELED;
+
 	if (dma_get_max_seg_size(device->card->device) > SBP2_MAX_SEG_SIZE)
 		BUG_ON(dma_set_max_seg_size(device->card->device,
 					    SBP2_MAX_SEG_SIZE));
 
 	shost = scsi_host_alloc(&scsi_driver_template, sizeof(*tgt));
 	if (shost == NULL)
-		return -ENOMEM;
+		goto fail;
 
 	tgt = (struct sbp2_target *)shost->hostdata;
 	dev_set_drvdata(&unit->device, tgt);
@@ -1200,6 +1205,8 @@ static int sbp2_probe(struct device *dev
 
  fail_shost_put:
 	scsi_host_put(shost);
+ fail:
+	module_put(THIS_MODULE);
 	return -ENOMEM;
 }
 


-- 
Stefan Richter
-=====-==-=- =-=- -=-==
http://arcgraph.de/sr/

