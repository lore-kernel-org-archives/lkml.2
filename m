Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610Ab1C2AJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 20:09:42 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:50350 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322Ab1C2AJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 20:09:41 -0400
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Mike Snitzer <snizer@redhat.com>,
        James Bottomley <James.Bottomley@suse.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
        Giacomo Catenazzi <cate@cateee.net>
Subject: Re: [Regression] Please revert a91a2785b20
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <alpine.LFD.2.00.1103290006070.2774@localhost6.localdomain6>
	<yq1hbamkgoe.fsf@sermon.lab.mkp.net>
	<alpine.LFD.2.00.1103290049330.2774@localhost6.localdomain6>
Date: Mon, 28 Mar 2011 20:09:12 -0400
In-Reply-To: <alpine.LFD.2.00.1103290049330.2774@localhost6.localdomain6>
	(Thomas Gleixner's message of "Tue, 29 Mar 2011 01:03:17 +0200
	(CEST)")
Message-ID: <yq1d3lakct3.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.110013 (No Gnus v0.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4D91232E.002A,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Thomas" == Thomas Gleixner <tglx@linutronix.de> writes:

Thomas> Why didn't you send a revert to Linus right away?

Simply didn't think of it. Didn't get the bug report until this
afternoon and few people build with BLK_DEV_INTEGRITY enabled. But I
guess Fedora has it on by default.


Thomas> So for your thing, it was already in Linus tree. Though if you
Thomas> get aware of it and it's revertable w/o creating lots of mess,
Thomas> then it's the right thing to revert it immediately. Do not drag
Thomas> out regressions longer than necessary, please.

Noted.

Patch below...

-- 
Martin K. Petersen	Oracle Linux Engineering


[PATCH] md: Fix integrity registration error when no devices are capable

We incorrectly returned -EINVAL when none of the devices in the array
had an integrity profile. This in turn prevented mdadm from starting the
metadevice. Fix this so we only return errors on mismatched profiles and
memory allocation failures.

Reported-by: Giacomo Catenazzi <cate@cateee.net>
Reported-by: Thomas Gleixner <tglx@linutronix.de>

diff --git a/drivers/md/md.c b/drivers/md/md.c
index f11e0bc..aab112f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1778,12 +1778,6 @@ int md_integrity_register(mddev_t *mddev)
 			continue;
 		if (rdev->raid_disk < 0)
 			continue;
-		/*
-		 * If at least one rdev is not integrity capable, we can not
-		 * enable data integrity for the md device.
-		 */
-		if (!bdev_get_integrity(rdev->bdev))
-			return -EINVAL;
 		if (!reference) {
 			/* Use the first rdev as the reference */
 			reference = rdev;
@@ -1794,6 +1788,8 @@ int md_integrity_register(mddev_t *mddev)
 				rdev->bdev->bd_disk) < 0)
 			return -EINVAL;
 	}
+	if (!reference || !bdev_get_integrity(reference->bdev))
+		return 0;
 	/*
 	 * All component devices are integrity capable and have matching
 	 * profiles, register the common profile for the md device.
