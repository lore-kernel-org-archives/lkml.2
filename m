Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760302Ab0JGLTy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 07:19:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:39871 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752307Ab0JGLTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 07:19:53 -0400
Message-ID: <4CADAB97.4020500@kernel.org>
Date: Thu, 07 Oct 2010 13:14:31 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Torsten Kaiser <just.for.lkml@googlemail.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: -mm: xfs lockdep warning
References: <201009161546.16909.ruirui.r.yang@tieto.com>	<20100917005227.GJ24409@dastard>	<20100920191355.GA28443@infradead.org>	<AANLkTi=45J+=ytj=NC4bYTVJFRakNQQiFd35K7mrf+Gq@mail.gmail.com>	<4CA997DF.5030008@kernel.org>	<20101004092107.GJ4681@dastard>	<AANLkTi=3jjoCtYoK0endt8OM=omygO284WN2ZQZ=jceo@mail.gmail.com>	<4CAB5779.5020901@kernel.org>	<AANLkTineNfy+hfnK-sjHNB+h05oC4qbJ+81pg95Bmn=b@mail.gmail.com>	<4CAC366E.7070609@kernel.org>	<4CAC38D9.8020407@kernel.org>	<AANLkTikw=ObzgWu35fsuriC-jVrzDRHRfFJeT8-4-ndY@mail.gmail.com>	<4CAC934E.2030807@kernel.org> <AANLkTinrBeMDyQJaYJFALTPpOgEaAy7yoPdyQ0Gpay3G@mail.gmail.com> <4CACC0CD.5000001@kernel.org>
In-Reply-To: <4CACC0CD.5000001@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 07 Oct 2010 11:19:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(restoring cc to lkml)
Hello,

On 10/06/2010 08:32 PM, Tejun Heo wrote:
> On 10/06/2010 07:20 PM, Torsten Kaiser wrote:
>>> It seems the system isn't completely stuck yet.  The above process is
>>> still trying to free memory.  Maybe memory reclaim is just extremely
>>> slow for some reason?
>>
>> How can I check this? With the hund -rc3 I repeatedly hit SysRq+M
>> every time waiting 10..60 seconds.
>> Can you see from these outputs if reclaim ins making any progress?
> 
> I think I have an idea of what's going on.  I'll prep a patch and send
> it to you tomorrow.

Can you test whether the following patch fix the issue?

Thanks.

diff --git a/block/blk-core.c b/block/blk-core.c
index 32a1c12..622602b 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2584,7 +2584,7 @@ int __init blk_dev_init(void)
 	BUILD_BUG_ON(__REQ_NR_BITS > 8 *
 			sizeof(((struct request *)0)->cmd_flags));

-	kblockd_workqueue = create_workqueue("kblockd");
+	kblockd_workqueue = alloc_workqueue("kblockd", WQ_MEM_RECLAIM, 1);
 	if (!kblockd_workqueue)
 		panic("Failed to create kblockd\n");

diff --git a/crypto/crypto_wq.c b/crypto/crypto_wq.c
index fdcf624..4c893a1 100644
--- a/crypto/crypto_wq.c
+++ b/crypto/crypto_wq.c
@@ -20,7 +20,7 @@ EXPORT_SYMBOL_GPL(kcrypto_wq);

 static int __init crypto_wq_init(void)
 {
-	kcrypto_wq = create_workqueue("crypto");
+	kcrypto_wq = alloc_workqueue("crypto", WQ_MEM_RECLAIM, 1);
 	if (unlikely(!kcrypto_wq))
 		return -ENOMEM;
 	return 0;
diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index de30782..2ee6ba2 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -455,7 +455,7 @@ static int pcrypt_init_padata(struct padata_pcrypt *pcrypt,

 	get_online_cpus();

-	pcrypt->wq = create_workqueue(name);
+	pcrypt->wq = alloc_workqueue(name, WQ_MEM_RECLAIM, 1);
 	if (!pcrypt->wq)
 		goto err;

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 64e0903..2631930 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -3804,7 +3804,7 @@ static int __init ib_cm_init(void)
 	if (ret)
 		return -ENOMEM;

-	cm.wq = create_workqueue("ib_cm");
+	cm.wq = alloc_workqueue("ib_cm", WQ_MEM_RECLAIM, 1);
 	if (!cm.wq) {
 		ret = -ENOMEM;
 		goto error1;
diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index f1d16d3..0f559f2 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -1053,7 +1053,7 @@ static int __init qlogic_ib_init(void)
 	 * so flush_scheduled_work() can deadlock during device
 	 * removal.
 	 */
-	qib_wq = create_workqueue("qib");
+	qib_wq = alloc_workqueue("qib", WQ_MEM_RECLAIM, 1);
 	if (!qib_wq) {
 		ret = -ENOMEM;
 		goto bail_dev;
diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
index baa1191..1f8d1e4 100644
--- a/drivers/md/dm-delay.c
+++ b/drivers/md/dm-delay.c
@@ -352,7 +352,7 @@ static int __init dm_delay_init(void)
 {
 	int r = -ENOMEM;

-	kdelayd_wq = create_workqueue("kdelayd");
+	kdelayd_wq = alloc_workqueue("kdelayd", WQ_MEM_RECLAIM, 1);
 	if (!kdelayd_wq) {
 		DMERR("Couldn't start kdelayd");
 		goto bad_queue;
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 487ecda..e60f22d 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1687,7 +1687,7 @@ static int __init dm_multipath_init(void)
 		return -EINVAL;
 	}

-	kmultipathd = create_workqueue("kmpathd");
+	kmultipathd = alloc_workqueue("kmpathd", WQ_MEM_RECLAIM, 1);
 	if (!kmultipathd) {
 		DMERR("failed to create workqueue kmpathd");
 		dm_unregister_target(&multipath_target);
diff --git a/drivers/message/i2o/driver.c b/drivers/message/i2o/driver.c
index a0421ef..8a5b2d8 100644
--- a/drivers/message/i2o/driver.c
+++ b/drivers/message/i2o/driver.c
@@ -84,7 +84,8 @@ int i2o_driver_register(struct i2o_driver *drv)
 	osm_debug("Register driver %s\n", drv->name);

 	if (drv->event) {
-		drv->event_queue = create_workqueue(drv->name);
+		drv->event_queue = alloc_workqueue(drv->name,
+						   WQ_MEM_RECLAIM, 1);
 		if (!drv->event_queue) {
 			osm_err("Could not initialize event queue for driver "
 				"%s\n", drv->name);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 1e4bff6..a6dd94d 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -351,7 +351,7 @@ static int qla25xx_setup_mode(struct scsi_qla_host *vha)
 				"Can't create request queue\n");
 			goto fail;
 		}
-		ha->wq = create_workqueue("qla2xxx_wq");
+		ha->wq = alloc_workqueue("qla2xxx_wq", WQ_MEM_RECLAIM, 1);
 		vha->req = ha->req_q_map[req];
 		options |= BIT_1;
 		for (ques = 1; ques < ha->max_rsp_queues; ques++) {
diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index 4d0ff5e..b37653f 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -782,7 +782,7 @@ void __init bio_integrity_init(void)
 {
 	unsigned int i;

-	kintegrityd_wq = create_workqueue("kintegrityd");
+	kintegrityd_wq = alloc_workqueue("kintegrityd", WQ_MEM_RECLAIM, 1);
 	if (!kintegrityd_wq)
 		panic("Failed to create kintegrityd\n");

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 2614774..5efccc6 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3038,7 +3038,8 @@ no_journal:
 		goto failed_mount_wq;
 	}

-	EXT4_SB(sb)->dio_unwritten_wq = create_workqueue("ext4-dio-unwritten");
+	EXT4_SB(sb)->dio_unwritten_wq = alloc_workqueue("ext4-dio-unwritten",
+							WQ_MEM_RECLAIM, 1);
 	if (!EXT4_SB(sb)->dio_unwritten_wq) {
 		printk(KERN_ERR "EXT4-fs: failed to create DIO workqueue\n");
 		goto failed_mount_wq;
diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index 812e2c0..03275f1 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -2950,7 +2950,7 @@ int journal_init(struct super_block *sb, const char *j_dev_name,
 	reiserfs_mounted_fs_count++;
 	if (reiserfs_mounted_fs_count <= 1) {
 		reiserfs_write_unlock(sb);
-		commit_wq = create_workqueue("reiserfs");
+		commit_wq = alloc_workqueue("reiserfs", WQ_MEM_RECLAIM, 1);
 		reiserfs_write_lock(sb);
 	}

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 25e02c9..77cb9d9 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -247,6 +247,8 @@ enum {
 	WQ_HIGHPRI		= 1 << 4, /* high priority */
 	WQ_CPU_INTENSIVE	= 1 << 5, /* cpu instensive workqueue */

+	WQ_MEM_RECLAIM		= WQ_RESCUER | WQ_HIGHPRI,
+
 	WQ_DYING		= 1 << 6, /* internal: workqueue is dying */

 	WQ_MAX_ACTIVE		= 512,	  /* I like 512, better ideas? */
