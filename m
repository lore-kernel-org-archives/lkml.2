Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997Ab0KPQjG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 11:39:06 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46106 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551Ab0KPQjE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 11:39:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=fNfakpBXwc4mzTyEYhS5XY+ZEIyye0Fqgp2VWm0YKs7uxth6weXSrRaIO7NYB/GulK
         sy1Ttr0ctkXWDUVhH6CN4/Axk5kHHS8WV5FOgsXIkK01aTuyOdxIzllqTE44apw6h3oc
         xefGA5LevkATNSJrr607pt9+pYxpEq+LZj5cY=
MIME-Version: 1.0
Date: Tue, 16 Nov 2010 16:38:36 +0000
Message-ID: <AANLkTi=BEkybzx4=cJoboXQbKsUb62Yrqz6RLoxd-Qyb@mail.gmail.com>
Subject: [PATCH 1/1] LogFS: Deadlock in logfs_get_wblocks, hold and wait on super->s_write_mutex
From: Prasad Joshi <prasadjoshi124@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>, linux-fsdevel@kernel.org,
        Joern <joern@logfs.org>, florian@mickler.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_logfs_journal_wl_pass() should use GFP_NOFS for memory allocation
GC code calls btree_insert32 with GFP_KERNEL while holding a mutex
super->s_write_mutex. The same mutex is used in
address_space_operations->writepage(). Call to writepage() could be triggered
as a result of memory allocation in btree_insert32, causing a deadlock.


Signed-off-by: Prasad Joshi <prasadjoshi124@gmail.com>
---
diff --git a/fs/logfs/journal.c b/fs/logfs/journal.c
index f46ee8b..9da2970 100644
--- a/fs/logfs/journal.c
+++ b/fs/logfs/journal.c
@@ -828,7 +828,7 @@ void do_logfs_journal_wl_pass(struct super_block *sb)
         super->s_journal_seg[i] = segno;
         super->s_journal_ec[i] = ec;
         logfs_set_segment_reserved(sb, segno);
-        err = btree_insert32(head, segno, (void *)1, GFP_KERNEL);
+        err = btree_insert32(head, segno, (void *)1, GFP_NOFS);
         BUG_ON(err); /* mempool should prevent this */
         err = logfs_erase_segment(sb, segno, 1);
         BUG_ON(err); /* FIXME: remount-ro would be nicer */


---------- Forwarded message ----------
From: <bugzilla-daemon@bugzilla.kernel.org>
Date: Tue, Nov 16, 2010 at 3:28 PM
Subject: [Bug 20342] [LogFS] [2.6.36-rc7] Deadlock in
logfs_get_wblocks, hold and wait on same lock super->s_write_mutex
To: prasadjoshi124@gmail.com


https://bugzilla.kernel.org/show_bug.cgi?id=20342


Florian Mickler <florian@mickler.org> changed:

          What    |Removed                     |Added
----------------------------------------------------------------------------
                CC|                            |florian@mickler.org




--- Comment #2 from Florian Mickler <florian@mickler.org>  2010-11-16
15:27:59 ---
Please submit this patch on lkml and the logfs mailinglist for review. The
logfs maintainers seem to not be aware of the bugzilla.

( Documentation/SubmittingPatches )

--
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are on the CC list for the bug.
