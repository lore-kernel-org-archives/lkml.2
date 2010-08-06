Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761857Ab0HFSnw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 14:43:52 -0400
Received: from kroah.org ([198.145.64.141]:48550 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761689Ab0HFSfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 14:35:19 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Aug  6 11:32:00 2010
Message-Id: <20100806183200.310072309@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 06 Aug 2010 11:30:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>
Subject: [03/38] block_dev: always serialize exclusive open attempts
In-Reply-To: <20100806183250.GA23019@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <htejun@gmail.com>

commit e75aa85892b2ee78c79edac720868cbef16e62eb upstream.

bd_prepare_to_claim() incorrectly allowed multiple attempts for
exclusive open to progress in parallel if the attempting holders are
identical.  This triggered BUG_ON() as reported in the following bug.

  https://bugzilla.kernel.org/show_bug.cgi?id=16393

__bd_abort_claiming() is used to finish claiming blocks and doesn't
work if multiple openers are inside a claiming block.  Allowing
multiple parallel open attempts to continue doesn't gain anything as
those are serialized down in the call chain anyway.  Fix it by always
allowing only single open attempt in a claiming block.

This problem can easily be reproduced by adding a delay after
bd_prepare_to_claim() and attempting to mount two partitions of a
disk.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/block_dev.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -681,8 +681,8 @@ retry:
 	if (!bd_may_claim(bdev, whole, holder))
 		return -EBUSY;
 
-	/* if someone else is claiming, wait for it to finish */
-	if (whole->bd_claiming && whole->bd_claiming != holder) {
+	/* if claiming is already in progress, wait for it to finish */
+	if (whole->bd_claiming) {
 		wait_queue_head_t *wq = bit_waitqueue(&whole->bd_claiming, 0);
 		DEFINE_WAIT(wait);
 


