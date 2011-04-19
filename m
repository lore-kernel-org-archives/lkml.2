Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527Ab1DSURE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:17:04 -0400
Received: from kroah.org ([198.145.64.141]:47616 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754356Ab1DSURA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:17:00 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:10:44 2011
Message-Id: <20110419201044.873669769@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:08:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [16/70] UBIFS: fix assertion warnings
In-Reply-To: <20110419201501.GA8865@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

commit c88ac00c5af70c2a0741da14b22cdcf8507ddd92 upstream.

This patch fixes UBIFS assertion warnings like:

UBIFS assert failed in ubifs_leb_unmap at 135 (pid 29365)
Pid: 29365, comm: integck Tainted: G          I 2.6.37-ubi-2.6+ #34
Call Trace:
 [<ffffffffa047c663>] ubifs_lpt_init+0x95e/0x9ee [ubifs]
 [<ffffffffa04623a7>] ubifs_remount_fs+0x2c7/0x762 [ubifs]
 [<ffffffff810f066e>] do_remount_sb+0xb6/0x101
 [<ffffffff81106ff4>] ? do_mount+0x191/0x78e
 [<ffffffff811070bb>] do_mount+0x258/0x78e
 [<ffffffff810da1e8>] ? alloc_pages_current+0xa2/0xc5
 [<ffffffff81107674>] sys_mount+0x83/0xbd
 [<ffffffff81009a12>] system_call_fastpath+0x16/0x1b

They happen when we re-mount from R/O mode to R/W mode. While
re-mounting, we write to the media, but we still have the c->ro_mount
flag set. The fix is very simple - just clear the flag before
starting re-mounting R/W.

These warnings are caused by the following commit:
2ef13294d29bcfb306e0d360f1b97f37b647b0c0

For -stable guys: this bug was introduced in 2.6.38, this is materieal
for 2.6.38-stable.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ubifs/super.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -1543,6 +1543,7 @@ static int ubifs_remount_rw(struct ubifs
 	mutex_lock(&c->umount_mutex);
 	dbg_save_space_info(c);
 	c->remounting_rw = 1;
+	c->ro_mount = 0;
 	c->always_chk_crc = 1;
 
 	err = check_free_space(c);
@@ -1648,7 +1649,6 @@ static int ubifs_remount_rw(struct ubifs
 	}
 
 	dbg_gen("re-mounted read-write");
-	c->ro_mount = 0;
 	c->remounting_rw = 0;
 	c->always_chk_crc = 0;
 	err = dbg_check_space_info(c);
@@ -1656,6 +1656,7 @@ static int ubifs_remount_rw(struct ubifs
 	return err;
 
 out:
+	c->ro_mount = 1;
 	vfree(c->orph_buf);
 	c->orph_buf = NULL;
 	if (c->bgt) {


