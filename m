Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758753Ab0DVUtb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:49:31 -0400
Received: from kroah.org ([198.145.64.141]:37111 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754019Ab0DVT12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:27:28 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:07 2010
Message-Id: <20100422190907.784405691@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:07:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Nikolaus Schulz <microschulz@web.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: [004/197] fat: fix buffer overflow in vfat_create_shortname()
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Nikolaus Schulz <microschulz@web.de>

commit 30d1872d9eb3663b4cf7bdebcbf5cd465674cced upstream.

When using the string representation of a random counter as part of the base
name, ensure that it is no longer than 4 bytes.

Since we are repeatedly decrementing the counter in a loop until we have found a
unique base name, the counter may wrap around zero; therefore, it is not enough
to mask its higher bits before entering the loop, this must be done inside the
loop.

[hirofumi@mail.parknet.co.jp: use snprintf()]
Signed-off-by: Nikolaus Schulz <microschulz@web.de>
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/fat/namei_vfat.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -309,7 +309,7 @@ static int vfat_create_shortname(struct
 {
 	struct fat_mount_options *opts = &MSDOS_SB(dir->i_sb)->options;
 	wchar_t *ip, *ext_start, *end, *name_start;
-	unsigned char base[9], ext[4], buf[8], *p;
+	unsigned char base[9], ext[4], buf[5], *p;
 	unsigned char charbuf[NLS_MAX_CHARSET_SIZE];
 	int chl, chi;
 	int sz = 0, extlen, baselen, i, numtail_baselen, numtail2_baselen;
@@ -467,7 +467,7 @@ static int vfat_create_shortname(struct
 			return 0;
 	}
 
-	i = jiffies & 0xffff;
+	i = jiffies;
 	sz = (jiffies >> 16) & 0x7;
 	if (baselen > 2) {
 		baselen = numtail2_baselen;
@@ -476,7 +476,7 @@ static int vfat_create_shortname(struct
 	name_res[baselen + 4] = '~';
 	name_res[baselen + 5] = '1' + sz;
 	while (1) {
-		sprintf(buf, "%04X", i);
+		snprintf(buf, sizeof(buf), "%04X", i & 0xffff);
 		memcpy(&name_res[baselen], buf, 4);
 		if (vfat_find_form(dir, name_res) < 0)
 			break;


