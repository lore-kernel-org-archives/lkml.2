Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500Ab1FPHFk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:05:40 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:49450 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756227Ab1FPHF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:05:29 -0400
X-Sasl-enc: z7LGThUCEccIFLj277BNzSzL1QRw6IhzudXFHQJf8KJ9 1308207929
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:16:11 2011
Message-Id: <20110616001611.276726107@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:15:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Timo Warns <warns@pre-sense.de>
Subject: [20/91] Fix for buffer overflow in ldm_frag_add not sufficient
In-Reply-To: <20110616001900.GA25375@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Timo Warns <Warns@pre-sense.de>

commit cae13fe4cc3f24820ffb990c09110626837e85d4 upstream.

As Ben Hutchings discovered [1], the patch for CVE-2011-1017 (buffer
overflow in ldm_frag_add) is not sufficient.  The original patch in
commit c340b1d64000 ("fs/partitions/ldm.c: fix oops caused by corrupted
partition table") does not consider that, for subsequent fragments,
previously allocated memory is used.

[1] http://lkml.org/lkml/2011/5/6/407

Reported-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Timo Warns <warns@pre-sense.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/partitions/ldm.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/partitions/ldm.c
+++ b/fs/partitions/ldm.c
@@ -1335,6 +1335,11 @@ static bool ldm_frag_add (const u8 *data
 
 	list_add_tail (&f->list, frags);
 found:
+	if (rec >= f->num) {
+		ldm_error("REC value (%d) exceeds NUM value (%d)", rec, f->num);
+		return false;
+	}
+
 	if (f->map & (1 << rec)) {
 		ldm_error ("Duplicate VBLK, part %d.", rec);
 		f->map &= 0x7F;			/* Mark the group as broken */


