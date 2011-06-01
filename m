Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759424Ab1FATZd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 15:25:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51590 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759165Ab1FATZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 15:25:31 -0400
X-Authority-Analysis: v=1.1 cv=PfPQ8rIoTcZsncbPZjVSZ7K0hy8Zc4hmL68r4VPNpKE= c=1 sm=0 a=d88QCcuEb48A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=eGxn8NsGF4j246Sm9tkA:9 a=k0jZ_ipI3ftJ49lo6Z0A:7 a=PUjeQqilurYA:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [PATCH] ide: Fix bug caused by git merge
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: axboe <axboe@kernel.dk>, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Junio C Hamano <gitster@pobox.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 01 Jun 2011 15:25:28 -0400
Message-ID: <1306956328.10135.36.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running ktest.pl randconfig on an older box of mine that has an ide cd,
I found a config that caused the machine not to boot. Doing a ktest
config bisect, I found that if I have CONFIG_BLK_DEV_PIIX set, it caused
the bug.

Then I took that same config and found that 2.6.39 boots fine. So I
kicked off ktest to do a git bisect, and this is where everything went
to hell. The bisect came to a point where it wouldn't boot from a branch
that was based off of v2.6.39-rc4. But then I found v2.6.39-rc4 didn't
boot either. Something fixed this bug between rc4 and 39, but this
branch didn't have it.

I than ran a reverse git bisect with ktest (where good is bad and bad is
good) between v2.6.39 and v2.6.39-rc4 to find what fixed this bug, and
it found:

commit 7eec77a1816a7042591a6cbdb4820e9e7ebffe0e
Author: Tejun Heo <tj@kernel.org>
ide: unexport DISK_EVENT_MEDIA_CHANGE for ide-gd and ide-cd

Great I thought, and then applied this patch to my git bisect again
(modified ktest for v3.1) to find the other bug. But instead I found
that this was the same bug, but it reappeared. The culprit was a line in
drivers/ide/ide-cd.c.  What happened was that a git merge brought back
some code that was deleted.

The merge 0eb8e885726a3a93206510092bbc7e39e272f6ef that merged the
commits:

 af75cd3c67845ebe31d2df9a780889a5ebecef11

and

 0a58e077eb600d1efd7e54ad9926a75a39d7f8ae

had an issue.

If I did a:

 git blame af75cd3c67845ebe31d2df9a780889a5ebecef11 drivers/ide/ide-cd.c

I would find:

 5b03a1b1 (Tejun Heo                 2011-03-09 19:54:27 +0100 1785)     g->events = DISK_EVENT_MEDIA_CHANGE;

But if I did a:

  git blame 0a58e077eb600d1efd7e54ad9926a75a39d7f8ae drivers/ide/ide-cd.c

Which contains the commit 7eec77a1816a7042591a6cbdb4820e9e7ebffe0e which
removes this line, it does not exist.

The issue here is that the commit 5b03a1b1 is a common ancestor to both
commits. But even though the commit 7eec77a1 removed that line, for some
reason, the merge put that line back. No other commit added that line to
the code.

By simply removing that line, my machine now boots again with the bad
config.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 6e5123b..144d272 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1782,7 +1782,6 @@ static int ide_cd_probe(ide_drive_t *drive)
 	ide_cd_read_toc(drive, &sense);
 	g->fops = &idecd_ops;
 	g->flags |= GENHD_FL_REMOVABLE | GENHD_FL_BLOCK_EVENTS_ON_EXCL_WRITE;
-	g->events = DISK_EVENT_MEDIA_CHANGE;
 	add_disk(g);
 	return 0;
 


