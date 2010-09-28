Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354Ab0I1BH0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 21:07:26 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53238 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751373Ab0I1BHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 21:07:25 -0400
Date: Tue, 28 Sep 2010 09:06:28 +0800
From: Hu Tao <hutao@cn.fujitsu.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?utf-8?Q?Am=A8=A6rico?= Wang <xiyou.wangcong@gmail.com>
Subject: [PATCH resend] Update num_symtab, symtab and strtab right after
 setup of core_num_syms, core_symtab and core_strtab.
Message-ID: <20100928010628.GA6923@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

symtab/strtab refer to memory that will be vfreed when load_module() is
done. So update them early.

Signed-off-by: Hu Tao <hutao@cn.fujitsu.com>
---
 kernel/module.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index d0b5f8d..d5dc98b 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2029,6 +2029,10 @@ static void add_kallsyms(struct module *mod, const struct load_info *info)
 	for (*s = 0, i = 1; i < info->sechdrs[info->index.str].sh_size; ++i)
 		if (test_bit(i, info->strmap))
 			*++s = mod->strtab[i];
+
+	mod->num_symtab = mod->core_num_syms;
+	mod->symtab = mod->core_symtab;
+	mod->strtab = mod->core_strtab;
 }
 #else
 static inline void layout_symtab(struct module *mod, struct load_info *info)
@@ -2738,11 +2742,6 @@ SYSCALL_DEFINE3(init_module, void __user *, umod,
 	/* Drop initial reference. */
 	module_put(mod);
 	trim_init_extable(mod);
-#ifdef CONFIG_KALLSYMS
-	mod->num_symtab = mod->core_num_syms;
-	mod->symtab = mod->core_symtab;
-	mod->strtab = mod->core_strtab;
-#endif
 	module_free(mod, mod->module_init);
 	mod->module_init = NULL;
 	mod->init_size = 0;
-- 
1.7.3

