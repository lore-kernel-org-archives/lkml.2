Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab0FXAaT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 20:30:19 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:36572 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab0FXAaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 20:30:17 -0400
From: Tao Ma <tao.ma@oracle.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, hch@lst.de,
       axboe@kernel.dk, linux-fsdevel@vger.kernel.org,
       Tao Ma <tao.ma@oracle.com>
Subject: [PATCH v2] block: Don't count_vm_events for discard bio in submit_bio.
Date: Thu, 24 Jun 2010 08:28:15 +0800
Message-Id: <1277339295-6524-1-git-send-email-tao.ma@oracle.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <20100623124046.4dec96d1.akpm@linux-foundation.org>
References: <20100623124046.4dec96d1.akpm@linux-foundation.org>
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090202.4C22A6D9.0146:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,
> Yes, that's a buglet.
>
> Note that Christoph's "[PATCH, RFC] block: don't allocate a payload for
> discard request" will fix it in a better way.  That patch is in
> linux-next now, but I expect it will be taken out again (quickly,
> please) because Mike has found a number of problems with it.  
ok, I haven't noticed that. thanks for the info.
>
> Your patch looks like a decent temporary fix for mainline, and a
> permanent one for -stable.
I am sorry, but I made a mistake. BIO_RW_DISCARD is a enum for bit offset.
So the right check should be rw & (1 << BIO_RW_DISCARD).
I have regenerated the patch. Sorry for the inconvenience.

Regards,
Tao

>From 060630d842a987a518c648ff65160639100c9a1b Mon Sep 17 00:00:00 2001
From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 24 Jun 2010 07:43:57 +0800
Subject: [PATCH v2] block: Don't count_vm_events for discard bio in submit_bio.

In submit_bio, we count vm events by check READ/WRITE.
But actually DISCARD_NOBARRIER also has the WRITE flag set.
It looks as if in blkdev_issue_discard, we also add a
page as the payload and the bio_has_data check isn't enough.
So add another check for discard bio.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 block/blk-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index f84cce4..26aa542 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1586,7 +1586,7 @@ void submit_bio(int rw, struct bio *bio)
 	 * If it's a regular read/write or a barrier with data attached,
 	 * go through the normal accounting stuff before submission.
 	 */
-	if (bio_has_data(bio)) {
+	if (bio_has_data(bio) && !(rw & (1 << BIO_RW_DISCARD))) {
 		if (rw & WRITE) {
 			count_vm_events(PGPGOUT, count);
 		} else {
-- 
1.5.5

