Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883Ab0IAKhp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 06:37:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54662 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754758Ab0IAKhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 06:37:08 -0400
Message-ID: <4C7E2CB1.20705@cn.fujitsu.com>
Date: Wed, 01 Sep 2010 18:36:33 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Chris Mason <chris.mason@oracle.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Linux Ext4 <linux-ext4@vger.kernel.org>
Subject: [PATCH 3/3] x86_64/lib: improve the performance of memmove
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch improved the performance of memmove on x86_64 by using mem_copy_bwd()
instead of byte copy. But x86_64's memcpy is quite fast, so I didn't change it.

I have tested this patchset by doing 500 bytes memory copy for 50000 times
on my x86_64 box:
			memmove
2.6.36-rc1		2s 610445us	
2.6.36-rc1 + patch	0s 257358us

After appling this patchset, the performance of the file creation and deletion
on some filesystem become better. I have tested it with the following benchmark
tool on my x86_64 box.
  http://marc.info/?l=linux-btrfs&m=128212635122920&q=p3

Test steps:
# ./creat_unlink 50000

The result(Total time):
Ext4:
		2.6.36-rc1	2.6.36-rc1 + patchset
file creation	0.771240	0.698983		9.4%UP
file deletion	0.459065	0.425530		7.3%UP


Btrfs:
		2.6.36-rc1	2.6.36-rc1 + patchset
file creation	0.966807	0.947592		1.9%UP
file deletion	1.355671	1.217787		10.2%UP 

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 arch/x86/lib/memmove_64.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/lib/memmove_64.c b/arch/x86/lib/memmove_64.c
index 0a33909..3640232 100644
--- a/arch/x86/lib/memmove_64.c
+++ b/arch/x86/lib/memmove_64.c
@@ -4,17 +4,17 @@
 #define _STRING_C
 #include <linux/string.h>
 #include <linux/module.h>
+#include <linux/memcopy.h>
 
 #undef memmove
 void *memmove(void *dest, const void *src, size_t count)
 {
-	if (dest < src) {
+	if (dest - src >= count) {	/* *Unsigned* compare! */
 		return memcpy(dest, src, count);
 	} else {
-		char *p = dest + count;
-		const char *s = src + count;
-		while (count--)
-			*--p = *--s;
+		unsigned long dstp = (unsigned long)dest;
+		unsigned long srcp = (unsigned long)src;
+		mem_copy_bwd(dstp, srcp, count);
 	}
 	return dest;
 }
-- 
1.7.0.1
