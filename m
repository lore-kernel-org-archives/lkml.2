Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092Ab0CYDuT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 23:50:19 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:52966 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430Ab0CYDuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 23:50:17 -0400
Date: Thu, 25 Mar 2010 04:50:13 +0100
From: Nikolaus Schulz <microschulz@web.de>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Marton Balint <cus@fazekas.hu>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Kevin Dankwardt <k@kcomputing.com>, Christoph Hellwig <hch@lst.de>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] fat: fix buffer overflow in vfat_create_shortname()
Message-ID: <20100325035010.GA3242@penelope.zusammrottung.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Provags-ID: V01U2FsdGVkX1/fREHnXxuYZ3D7UhySelqbe+5LKyNATuBpqPms
	ZCCmCSf6KoHV25f1D+VYgUaI+XlG3Lf1BKuEHqnoEePOW+1TBp
	/UUnWvxKM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using the string representation of a random counter as part of the base
name, ensure that it is no longer than 4 bytes.

Since we are repeatedly decrementing the counter in a loop until we have found a
unique base name, the counter may wrap around zero; therefore, it is not enough
to mask its higher bits before entering the loop, this must be done inside the
loop.

Signed-off-by: Nikolaus Schulz <microschulz@web.de>
Cc: stable@kernel.org
---
 fs/fat/namei_vfat.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index c1ef501..a448ee5 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -309,7 +309,7 @@ static int vfat_create_shortname(struct inode *dir, struct nls_table *nls,
 {
 	struct fat_mount_options *opts = &MSDOS_SB(dir->i_sb)->options;
 	wchar_t *ip, *ext_start, *end, *name_start;
-	unsigned char base[9], ext[4], buf[8], *p;
+	unsigned char base[9], ext[4], buf[5], *p;
 	unsigned char charbuf[NLS_MAX_CHARSET_SIZE];
 	int chl, chi;
 	int sz = 0, extlen, baselen, i, numtail_baselen, numtail2_baselen;
@@ -467,7 +467,7 @@ static int vfat_create_shortname(struct inode *dir, struct nls_table *nls,
 			return 0;
 	}
 
-	i = jiffies & 0xffff;
+	i = jiffies;
 	sz = (jiffies >> 16) & 0x7;
 	if (baselen > 2) {
 		baselen = numtail2_baselen;
@@ -476,7 +476,7 @@ static int vfat_create_shortname(struct inode *dir, struct nls_table *nls,
 	name_res[baselen + 4] = '~';
 	name_res[baselen + 5] = '1' + sz;
 	while (1) {
-		sprintf(buf, "%04X", i);
+		sprintf(buf, "%04X", i & 0xffff);
 		memcpy(&name_res[baselen], buf, 4);
 		if (vfat_find_form(dir, name_res) < 0)
 			break;
-- 
1.7.0
