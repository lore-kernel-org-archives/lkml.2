Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740Ab1DURq0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 13:46:26 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:35298 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887Ab1DURqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 13:46:23 -0400
X-ASG-Debug-ID: 1303407980-01de284cf8179890001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DB06D68.8050102@fusionio.com>
Date: Thu, 21 Apr 2011 19:46:16 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Tejun Heo <tj@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Neil Brown <neilb@suse.de>, "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "kay.sievers@vrfy.org" <kay.sievers@vrfy.org>
Subject: Re: [PATCH 1/2] block: don't propagate unlisted DISK_EVENTs to  userland
References: <20110421170826.GC15988@htj.dyndns.org> <BANLkTinwPt=aRSsh_Ppb8hLOaURh6mL2GQ@mail.gmail.com> <4DB06A06.7030208@fusionio.com>
X-ASG-Orig-Subj: Re: [PATCH 1/2] block: don't propagate unlisted DISK_EVENTs to  userland
In-Reply-To: <4DB06A06.7030208@fusionio.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1303407980
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.61522
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-21 19:31, Jens Axboe wrote:
> On 2011-04-21 19:25, Linus Torvalds wrote:
>> Should I take these as patches, or through Jens/David/Who?
>>
>> I'll happily take them as patches, but I'd also like to hear
>> confirmation from the people who saw the lock-up that it's gone now..
> 
> I'm pulling them in now, with the elevator patch referenced in the IO
> scheduler switch email. I've verified that it fixes the ide-cd bug for
> me.

- Fix the oops on IO scheduler switch. Verified locally that the patch I
  proposed does fix the issue.

- The ide notification fixes from Tejun. Also verified locally to fix
  the boot hang on UP && !CONFIG_PREEMPT.

Please pull.


  git://git.kernel.dk/linux-2.6-block.git for-linus

Jens Axboe (1):
      elevator: check for ELEVATOR_INSERT_SORT_MERGE in !elvpriv case too

Tejun Heo (2):
      block: don't propagate unlisted DISK_EVENTs to userland
      ide: unexport DISK_EVENT_MEDIA_CHANGE for ide-gd and ide-cd

 block/elevator.c           |    3 ++-
 block/genhd.c              |    8 ++++++--
 drivers/ide/ide-cd.c       |    1 -
 drivers/ide/ide-cd_ioctl.c |    6 ++++++
 drivers/ide/ide-gd.c       |    7 ++++++-
 5 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/block/elevator.c b/block/elevator.c
index 6f6abc0..45ca1e3 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -671,7 +671,8 @@ void __elv_add_request(struct request_queue *q, struct request *rq, int where)
 			q->boundary_rq = rq;
 		}
 	} else if (!(rq->cmd_flags & REQ_ELVPRIV) &&
-		    where == ELEVATOR_INSERT_SORT)
+		    (where == ELEVATOR_INSERT_SORT ||
+		     where == ELEVATOR_INSERT_SORT_MERGE))
 		where = ELEVATOR_INSERT_BACK;
 
 	switch (where) {
diff --git a/block/genhd.c b/block/genhd.c
index b364bd0..2dd9887 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1588,9 +1588,13 @@ static void disk_events_workfn(struct work_struct *work)
 
 	spin_unlock_irq(&ev->lock);
 
-	/* tell userland about new events */
+	/*
+	 * Tell userland about new events.  Only the events listed in
+	 * @disk->events are reported.  Unlisted events are processed the
+	 * same internally but never get reported to userland.
+	 */
 	for (i = 0; i < ARRAY_SIZE(disk_uevents); i++)
-		if (events & (1 << i))
+		if (events & disk->events & (1 << i))
 			envp[nr_events++] = disk_uevents[i];
 
 	if (nr_events)
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index fd1e117..a5ec5a7 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1782,7 +1782,6 @@ static int ide_cd_probe(ide_drive_t *drive)
 	ide_cd_read_toc(drive, &sense);
 	g->fops = &idecd_ops;
 	g->flags |= GENHD_FL_REMOVABLE;
-	g->events = DISK_EVENT_MEDIA_CHANGE;
 	add_disk(g);
 	return 0;
 
diff --git a/drivers/ide/ide-cd_ioctl.c b/drivers/ide/ide-cd_ioctl.c
index 2a6bc50..02caa7d 100644
--- a/drivers/ide/ide-cd_ioctl.c
+++ b/drivers/ide/ide-cd_ioctl.c
@@ -79,6 +79,12 @@ int ide_cdrom_drive_status(struct cdrom_device_info *cdi, int slot_nr)
 	return CDS_DRIVE_NOT_READY;
 }
 
+/*
+ * ide-cd always generates media changed event if media is missing, which
+ * makes it impossible to use for proper event reporting, so disk->events
+ * is cleared to 0 and the following function is used only to trigger
+ * revalidation and never propagated to userland.
+ */
 unsigned int ide_cdrom_check_events_real(struct cdrom_device_info *cdi,
 					 unsigned int clearing, int slot_nr)
 {
diff --git a/drivers/ide/ide-gd.c b/drivers/ide/ide-gd.c
index c4ffd48..70ea876 100644
--- a/drivers/ide/ide-gd.c
+++ b/drivers/ide/ide-gd.c
@@ -298,6 +298,12 @@ static unsigned int ide_gd_check_events(struct gendisk *disk,
 		return 0;
 	}
 
+	/*
+	 * The following is used to force revalidation on the first open on
+	 * removeable devices, and never gets reported to userland as
+	 * genhd->events is 0.  This is intended as removeable ide disk
+	 * can't really detect MEDIA_CHANGE events.
+	 */
 	ret = drive->dev_flags & IDE_DFLAG_MEDIA_CHANGED;
 	drive->dev_flags &= ~IDE_DFLAG_MEDIA_CHANGED;
 
@@ -413,7 +419,6 @@ static int ide_gd_probe(ide_drive_t *drive)
 	if (drive->dev_flags & IDE_DFLAG_REMOVABLE)
 		g->flags = GENHD_FL_REMOVABLE;
 	g->fops = &ide_gd_ops;
-	g->events = DISK_EVENT_MEDIA_CHANGE;
 	add_disk(g);
 	return 0;
 
> 


-- 
Jens Axboe

