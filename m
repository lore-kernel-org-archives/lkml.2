Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596Ab2JXFww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 01:52:52 -0400
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:56200 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab2JXFwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 01:52:51 -0400
X-AuditID: b753bd60-96850ba000002f78-5c-508781aec572
Message-ID: <508781AD.80902@hitachi.com>
Date: Wed, 24 Oct 2012 14:50:37 +0900
From: Masaki Kimura <masaki.kimura.kz@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121005 Thunderbird/16.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>
Subject: [RESEND PATCH] module: Fix kallsyms to show the last symbol properly
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a bug that the last symbol in the .symtab section of
kernel modules is not displayed with /proc/kallsyms. This happens
because the first symbol is processed twice before and inside the loop
without incrementing "src".

This bug exists since the following commit was introduced.
   module: reduce symbol table for loaded modules (v2)
   commit: 4a4962263f07d14660849ec134ee42b63e95ea9a

This patch is tested on 3.7-rc2 kernel with the simple test module by the
below steps, to check if all the core symbols appear in /proc/kallsyms.

[Test steps]
1. Compile the test module, like below.
   (My compiler tends to put a function named with 18 charactors, 
    like zzzzzzzzzzzzzzzzzz, at the end of .symtab section. 
    I don't know why, though.)

# cat tp.c
#include <linux/module.h>
#include <linux/kernel.h>

void zzzzzzzzzzzzzzzzzz(void) {}

static int init_tp(void)
{
        return 0;
}

static void exit_tp(void) {}

module_init(init_tp);
module_exit(exit_tp);
MODULE_LICENSE("GPL");

# cat Makefile
KERNEL_RELEASE=$(shell uname -r)
BUILDDIR := /lib/modules/$(KERNEL_RELEASE)/source

obj-m := tp.o

all:
        $(MAKE) -C $(BUILDDIR) M=$(PWD) V=1 modules
clean:
        $(MAKE) -C $(BUILDDIR) M=$(PWD) V=1 clean

# make

2. Check if the target symbol, zzzzzzzzzzzzzzzzzz in this case, 
   is located at the last entry.

# readelf -s tp.ko | tail
    18: 0000000000000020    11 FUNC    LOCAL  DEFAULT    2 exit_tp
    19: 0000000000000000    12 OBJECT  LOCAL  DEFAULT    4 __mod_license15
    20: 0000000000000000     0 FILE    LOCAL  DEFAULT  ABS tp.mod.c
    21: 000000000000000c     9 OBJECT  LOCAL  DEFAULT    4 __module_depends
    22: 0000000000000015    45 OBJECT  LOCAL  DEFAULT    4 __mod_vermagic5
    23: 0000000000000000   600 OBJECT  GLOBAL DEFAULT    8 __this_module
    24: 0000000000000020    11 FUNC    GLOBAL DEFAULT    2 cleanup_module
    25: 0000000000000010    13 FUNC    GLOBAL DEFAULT    2 init_module
    26: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT  UND mcount
    27: 0000000000000000    11 FUNC    GLOBAL DEFAULT    2 zzzzzzzzzzzzzzzzzz

3. Load the module.
# insmod tp.ko

4. Check if all the core symbols are shown /proc/kallsyms properly.

[Before my patch applied]
# grep "\[tp\]" /proc/kallsyms
ffffffffa0135010 t init_tp      [tp]
ffffffffa0135020 t exit_tp      [tp]
ffffffffa0137000 d __this_module        [tp]
ffffffffa0135020 t cleanup_module       [tp]
ffffffffa0135010 t init_module  [tp]

(The last entry, or zzzzzzzzzzzzzzzzzz, is not shown.)

[After my patch applied]
# grep "\[tp\]" /proc/kallsyms
ffffffffa0135010 t init_tp      [tp]
ffffffffa0135020 t exit_tp      [tp]
ffffffffa0137000 d __this_module        [tp]
ffffffffa0135020 t cleanup_module       [tp]
ffffffffa0135010 t init_module  [tp]
ffffffffa0135000 t zzzzzzzzzzzzzzzzzz   [tp]

(The last entry, or zzzzzzzzzzzzzzzzzz, is shown properly.)


Signed-off-by: Masaki Kimura <masaki.kimura.kz@hitachi.com>
---
 kernel/module.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/module.c b/kernel/module.c
index 6085f5e..1a48ffe 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2293,7 +2293,11 @@ static void layout_symtab(struct module *mod, struct load_info *info)
 	src = (void *)info->hdr + symsect->sh_offset;
 	nsrc = symsect->sh_size / sizeof(*src);
 
-	/* Compute total space required for the core symbols' strtab. */
+	/* 
+ 	 * Compute total space required for the core symbols' strtab.
+	 * We start searching core symbols from the second entry.
+	 */
+	src++;
 	for (ndst = i = strtab_size = 1; i < nsrc; ++i, ++src)
 		if (is_core_symbol(src, info->sechdrs, info->hdr->e_shnum)) {
 			strtab_size += strlen(&info->strtab[src->st_name]) + 1;
@@ -2334,6 +2338,8 @@ static void add_kallsyms(struct module *mod, const struct load_info *info)
 	src = mod->symtab;
 	*dst = *src;
 	*s++ = 0;
+	/* We start searching core symbols from the second entry. */
+	src++;
 	for (ndst = i = 1; i < mod->num_symtab; ++i, ++src) {
 		if (!is_core_symbol(src, info->sechdrs, info->hdr->e_shnum))
 			continue;
-- 
1.7.10.1
