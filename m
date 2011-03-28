Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab1C1XE1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 19:04:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2785 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752330Ab1C1XEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 19:04:25 -0400
Date: Mon, 28 Mar 2011 19:03:20 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@suse.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: Please revert a91a2785b20
Message-ID: <20110328230319.GA12790@redhat.com>
References: <alpine.LFD.2.00.1103290006070.2774@localhost6.localdomain6>
 <alpine.LFD.2.00.1103290040300.2774@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1103290040300.2774@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28 2011 at  6:43pm -0400,
Thomas Gleixner <tglx@linutronix.de> wrote:

> Forgot to cc Jens and fixed up the borked mail address of Mike which
> I took from the changelog :(
> 
> On Tue, 29 Mar 2011, Thomas Gleixner wrote:
> 
> > Out of the blue all my perfectly fine working test machines which use
> > RAID stopped working with the very helpful error message:
> > 
> > 	md/raid1:md1: active with 2 out of 2 mirrors
> > 	md: pers->run() failed ...
> > 
> > Reverting a91a2785b20 fixes the problem.
> > 
> > Neither the subject line:
> > 
> >  block: Require subsystems to explicitly allocate bio_set integrity mempool
> > 
> > nor the changelog have any hint why that wreckage is in any way
> > sensible.
> > 
> > The wreckage happens due to:
> > 
> > -       md_integrity_register(mddev);
> > -       return 0;
> > +       return md_integrity_register(mddev);

Right, a kernel.org BZ was filed on this here:
https://bugzilla.kernel.org/show_bug.cgi?id=32062

Martin is working to "conjure up a patch" to fix the common case where
no devices in the MD have DIF/DIX capabilities.

> > But the changelog does not give the courtesy of explaining these
> > changes. Also there is no fcking reason why the kernel cannot deal
> > with the missing integrity capabilities of a drive just by emitting a
> > warning msg and dealing gracefully with the outcome.
> > 
> > All my RAID setups have been working perfectly fine until now, so
> > what's the rationale to break this?
> > 
> > Did anyone test this shite on a non enterprise class hardware with a
> > distro default config ? Obviously _NOT_.

Seems not.  I didn't even look at the MD changes when I ack'd the DM
changes.  But I clearly stated as much and also cc'd neilb:
http://www.redhat.com/archives/dm-devel/2011-March/msg00066.html
and again for the final version that got committed:
http://www.redhat.com/archives/dm-devel/2011-March/msg00098.html

I should've just looked at the MD changes too!  As Neil would say, that
damn DM/MD walled garden... luckily that wall is slowly crumbling!

> > FYI, the config files of those machines are based off a fedora default
> > config, so this would hit all raid users based on popular distro
> > configs sooner than later.
> > 
> > Thanks for stealing my time,

Sorry this screwed you, the following patch is the stop-gap I suggested
in the kernel.org BZ (it just reverts the MD error propagation, keeping
the good aspects of Martin's commit):

---
 drivers/md/linear.c    |    3 ++-
 drivers/md/multipath.c |    7 ++-----
 drivers/md/raid0.c     |    3 ++-
 drivers/md/raid1.c     |    5 +++--
 drivers/md/raid10.c    |    7 ++-----
 5 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index abfb59a..338804f8 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -210,7 +210,8 @@ static int linear_run (mddev_t *mddev)
 	blk_queue_merge_bvec(mddev->queue, linear_mergeable_bvec);
 	mddev->queue->backing_dev_info.congested_fn = linear_congested;
 	mddev->queue->backing_dev_info.congested_data = mddev;
-	return md_integrity_register(mddev);
+	md_integrity_register(mddev);
+	return 0;
 }
 
 static void free_conf(struct rcu_head *head)
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index c358909..5e694b1 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -315,7 +315,7 @@ static int multipath_remove_disk(mddev_t *mddev, int number)
 			p->rdev = rdev;
 			goto abort;
 		}
-		err = md_integrity_register(mddev);
+		md_integrity_register(mddev);
 	}
 abort:
 
@@ -489,10 +489,7 @@ static int multipath_run (mddev_t *mddev)
 
 	mddev->queue->backing_dev_info.congested_fn = multipath_congested;
 	mddev->queue->backing_dev_info.congested_data = mddev;
-
-	if (md_integrity_register(mddev))
-		goto out_free_conf;
-
+	md_integrity_register(mddev);
 	return 0;
 
 out_free_conf:
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index e86bf36..95916fd 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -379,7 +379,8 @@ static int raid0_run(mddev_t *mddev)
 
 	blk_queue_merge_bvec(mddev->queue, raid0_mergeable_bvec);
 	dump_zones(mddev);
-	return md_integrity_register(mddev);
+	md_integrity_register(mddev);
+	return 0;
 }
 
 static int raid0_stop(mddev_t *mddev)
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index c2a21ae..8f34ad5 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1132,7 +1132,7 @@ static int raid1_remove_disk(mddev_t *mddev, int number)
 			p->rdev = rdev;
 			goto abort;
 		}
-		err = md_integrity_register(mddev);
+		md_integrity_register(mddev);
 	}
 abort:
 
@@ -2017,7 +2017,8 @@ static int run(mddev_t *mddev)
 
 	mddev->queue->backing_dev_info.congested_fn = raid1_congested;
 	mddev->queue->backing_dev_info.congested_data = mddev;
-	return md_integrity_register(mddev);
+	md_integrity_register(mddev);
+	return 0;
 }
 
 static int stop(mddev_t *mddev)
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index f7b6237..c0d0f5f 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1188,7 +1188,7 @@ static int raid10_remove_disk(mddev_t *mddev, int number)
 			p->rdev = rdev;
 			goto abort;
 		}
-		err = md_integrity_register(mddev);
+		md_integrity_register(mddev);
 	}
 abort:
 
@@ -2343,10 +2343,7 @@ static int run(mddev_t *mddev)
 
 	if (conf->near_copies < conf->raid_disks)
 		blk_queue_merge_bvec(mddev->queue, raid10_mergeable_bvec);
-
-	if (md_integrity_register(mddev))
-		goto out_free_conf;
-
+	md_integrity_register(mddev);
 	return 0;
 
 out_free_conf:
