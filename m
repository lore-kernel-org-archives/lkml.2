Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab2IQQvG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 12:51:06 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:28184 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356Ab2IQQvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 12:51:04 -0400
Message-ID: <505754EB.8060907@oracle.com>
Date: Mon, 17 Sep 2012 11:50:51 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120910 Thunderbird/15.0.1
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Tino Reichardt <list-jfs@mcmilk.de>
Subject: Re: linux-next: Tree for Sept 17 (jfs)
References: <20120917215938.11c456c113ac3b015cb2d5ae@canb.auug.org.au> <505745CF.8040202@xenotime.net>
In-Reply-To: <505745CF.8040202@xenotime.net>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2012 10:46 AM, Randy Dunlap wrote:
> On 09/17/2012 04:59 AM, Stephen Rothwell wrote:
> 
>> Hi all,
>>
>> OK, so this was a bad one :-(
>>
>> Changes since 201209014:
>>
>> New tree: jfs
>>
> 
> 
> 
> on i386:
> 
> modular build:
> ERROR: "__divdi3" [fs/jfs/jfs.ko] undefined!
> 
> or builtin:
> fs/built-in.o: In function `dbDiscardAG':
> (.text+0x12988b): undefined reference to `__divdi3'

Thanks Randy.

This should fix it. I'll integrate it back into the proper patch in the
jfs tree for the next pull.

jfs: fix i386 build error. Replace 64-bit division with do_div()

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>

diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index eb988a9..174feb6 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -1640,13 +1640,15 @@ s64 dbDiscardAG(struct inode *ip, int agno, s64 minlen)
 	} *totrim, *tt;
 
 	/* max blkno / nblocks pairs to trim */
-	int count = 0, range_cnt = 32 * 1024;
+	int count = 0, range_cnt;
 
 	/* prevent others from writing new stuff here, while trimming */
 	IWRITE_LOCK(ipbmap, RDWRLOCK_DMAP);
 
 	nblocks = bmp->db_agfree[agno];
-	range_cnt = min_t(int, range_cnt, nblocks / minlen + 1);
+	range_cnt = nblocks;
+	do_div(range_cnt, (int)minlen);
+	range_cnt = min(range_cnt + 1, 32 * 1024);
 	totrim = kmalloc(sizeof(struct range2trim) * range_cnt, GFP_NOFS);
 	if (totrim == NULL) {
 		jfs_error(bmp->db_ipbmap->i_sb,

