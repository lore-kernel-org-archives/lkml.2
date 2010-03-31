Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932627Ab0CaRVX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 13:21:23 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:43516 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757920Ab0CaRVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 13:21:20 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nikolaus Schulz <microschulz@web.de>, Al Viro <viro@zeniv.linux.org.uk>,
       Marton Balint <cus@fazekas.hu>, Alexey Dobriyan <adobriyan@gmail.com>,
       Kevin Dankwardt <k@kcomputing.com>, Christoph Hellwig <hch@lst.de>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] fat: fix buffer overflow in vfat_create_shortname()
References: <20100325035010.GA3242@penelope.zusammrottung.local>
	<8739zp6k9s.fsf@devron.myhome.or.jp>
	<20100325122419.GA8896@luigi.zusammrottung.local>
	<87y6hg60nw.fsf@devron.myhome.or.jp>
	<87bpec4l8j.fsf@devron.myhome.or.jp>
	<20100331120816.GA3430@penelope.zusammrottung.local>
Date: Thu, 01 Apr 2010 02:21:10 +0900
In-Reply-To: <20100331120816.GA3430@penelope.zusammrottung.local> (Nikolaus
	Schulz's message of "Wed, 31 Mar 2010 14:08:16 +0200")
Message-ID: <87wrwsh0ft.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nikolaus Schulz <microschulz@web.de> writes:

> Ping?
>
> I really think this should go into 2.6.34 and the next stable kernel
> updates.

I was testing a bit.

OK, please apply.


From: Nikolaus Schulz <microschulz@web.de>

When using the string representation of a random counter as part of the base
name, ensure that it is no longer than 4 bytes.

Since we are repeatedly decrementing the counter in a loop until we have found a
unique base name, the counter may wrap around zero; therefore, it is not enough
to mask its higher bits before entering the loop, this must be done inside the
loop.

[hirofumi@mail.parknet.co.jp: use snprintf()]
Signed-off-by: Nikolaus Schulz <microschulz@web.de>
Cc: stable@kernel.org
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fat/namei_vfat.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/fat/namei_vfat.c~fat-fix-numtail-logic fs/fat/namei_vfat.c
--- linux-2.6/fs/fat/namei_vfat.c~fat-fix-numtail-logic	2010-03-25 22:10:45.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/namei_vfat.c	2010-03-25 22:17:52.000000000 +0900
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
_

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
