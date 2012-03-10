Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab2CJOUh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 09:20:37 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60096 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917Ab2CJOUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 09:20:34 -0500
From: Cong Wang <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 1/2] module: use rcu to protect module list read
Date: Sat, 10 Mar 2012 22:20:02 +0800
Message-Id: <1331389203-3309-1-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now the read of module list is protected by preempt disable + *_rcu
list operations, this is odd, as RCU read lock should be able to
protect it directly. This patch makes the read of module list
protected by RCU read lock and the write still protected by
module_mutex.

I tested it with the following test case:

	#!/bin/bash
	i=0
	while [ $i -lt $1 ];
	do
		modprobe dummy && echo success
		modprobe bonding miimon=1000 && echo success
		let i=i+1
	done &

	i=0
	while [ $i -lt $1 ];
	do
		rmmod dummy && echo success
		rmmod bonding && echo success
		let i=i+1
	done
	echo done
	exit 0

for thousands of times, no problems.

Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Reported-by: <Dennis1.Chen@amd.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 kernel/module.c |   89 +++++++++++++++++++++++++++++-------------------------
 1 files changed, 48 insertions(+), 41 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 2c93276..e0b12f7 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -91,7 +91,7 @@
 
 /*
  * Mutex protects:
- * 1) List of modules (also safely readable with preempt_disable),
+ * 1) List of modules (also safely readable with rcu_read_lock),
  * 2) module_use links,
  * 3) module_addr_min/module_addr_max.
  * (delete uses stop_machine/add uses RCU list operations). */
@@ -382,7 +382,7 @@ static bool find_symbol_in_section(const struct symsearch *syms,
 }
 
 /* Find a symbol and return it, along with, (optional) crc and
- * (optional) module which owns it.  Needs preempt disabled or module_mutex. */
+ * (optional) module which owns it.  Needs rcu_read_lock. */
 const struct kernel_symbol *find_symbol(const char *name,
 					struct module **owner,
 					const unsigned long **crc,
@@ -413,7 +413,7 @@ struct module *find_module(const char *name)
 {
 	struct module *mod;
 
-	list_for_each_entry(mod, &modules, list) {
+	list_for_each_entry_rcu(mod, &modules, list) {
 		if (strcmp(mod->name, name) == 0)
 			return mod;
 	}
@@ -481,7 +481,7 @@ bool is_module_percpu_address(unsigned long addr)
 	struct module *mod;
 	unsigned int cpu;
 
-	preempt_disable();
+	rcu_read_lock();
 
 	list_for_each_entry_rcu(mod, &modules, list) {
 		if (!mod->percpu_size)
@@ -491,13 +491,13 @@ bool is_module_percpu_address(unsigned long addr)
 
 			if ((void *)addr >= start &&
 			    (void *)addr < start + mod->percpu_size) {
-				preempt_enable();
+				rcu_read_unlock();
 				return true;
 			}
 		}
 	}
 
-	preempt_enable();
+	rcu_read_unlock();
 	return false;
 }
 
@@ -869,11 +869,11 @@ void __symbol_put(const char *symbol)
 {
 	struct module *owner;
 
-	preempt_disable();
+	rcu_read_lock();
 	if (!find_symbol(symbol, &owner, NULL, true, false))
 		BUG();
 	module_put(owner);
-	preempt_enable();
+	rcu_read_unlock();
 }
 EXPORT_SYMBOL(__symbol_put);
 
@@ -1639,7 +1639,7 @@ static void mod_sysfs_teardown(struct module *mod)
 static int __unlink_module(void *_mod)
 {
 	struct module *mod = _mod;
-	list_del(&mod->list);
+	list_del_rcu(&mod->list);
 	module_bug_cleanup(mod);
 	return 0;
 }
@@ -1713,7 +1713,7 @@ void set_all_modules_text_rw(void)
 {
 	struct module *mod;
 
-	mutex_lock(&module_mutex);
+	rcu_read_lock();
 	list_for_each_entry_rcu(mod, &modules, list) {
 		if ((mod->module_core) && (mod->core_text_size)) {
 			set_page_attributes(mod->module_core,
@@ -1726,7 +1726,7 @@ void set_all_modules_text_rw(void)
 						set_memory_rw);
 		}
 	}
-	mutex_unlock(&module_mutex);
+	rcu_read_unlock();
 }
 
 /* Iterate through all modules and set each module's text as RO */
@@ -1734,7 +1734,7 @@ void set_all_modules_text_ro(void)
 {
 	struct module *mod;
 
-	mutex_lock(&module_mutex);
+	rcu_read_lock();
 	list_for_each_entry_rcu(mod, &modules, list) {
 		if ((mod->module_core) && (mod->core_text_size)) {
 			set_page_attributes(mod->module_core,
@@ -1747,7 +1747,7 @@ void set_all_modules_text_ro(void)
 						set_memory_ro);
 		}
 	}
-	mutex_unlock(&module_mutex);
+	rcu_read_unlock();
 }
 #else
 static inline void set_section_ro_nx(void *base, unsigned long text_size, unsigned long ro_size, unsigned long total_size) { }
@@ -1810,11 +1810,11 @@ void *__symbol_get(const char *symbol)
 	struct module *owner;
 	const struct kernel_symbol *sym;
 
-	preempt_disable();
+	rcu_read_lock();
 	sym = find_symbol(symbol, &owner, NULL, true, true);
+	rcu_read_unlock();
 	if (sym && strong_try_module_get(owner))
 		sym = NULL;
-	preempt_enable();
 
 	return sym ? (void *)sym->value : NULL;
 }
@@ -1844,6 +1844,7 @@ static int verify_export_symbols(struct module *mod)
 #endif
 	};
 
+	rcu_read_lock();
 	for (i = 0; i < ARRAY_SIZE(arr); i++) {
 		for (s = arr[i].sym; s < arr[i].sym + arr[i].num; s++) {
 			if (find_symbol(s->name, &owner, NULL, true, false)) {
@@ -1851,10 +1852,12 @@ static int verify_export_symbols(struct module *mod)
 				       "%s: exports duplicate symbol %s"
 				       " (owned by %s)\n",
 				       mod->name, s->name, module_name(owner));
+				rcu_read_unlock();
 				return -ENOEXEC;
 			}
 		}
 	}
+	rcu_read_unlock();
 	return 0;
 }
 
@@ -3130,7 +3133,7 @@ const char *module_address_lookup(unsigned long addr,
 	struct module *mod;
 	const char *ret = NULL;
 
-	preempt_disable();
+	rcu_read_lock();
 	list_for_each_entry_rcu(mod, &modules, list) {
 		if (within_module_init(addr, mod) ||
 		    within_module_core(addr, mod)) {
@@ -3145,7 +3148,7 @@ const char *module_address_lookup(unsigned long addr,
 		strncpy(namebuf, ret, KSYM_NAME_LEN - 1);
 		ret = namebuf;
 	}
-	preempt_enable();
+	rcu_read_unlock();
 	return ret;
 }
 
@@ -3153,7 +3156,7 @@ int lookup_module_symbol_name(unsigned long addr, char *symname)
 {
 	struct module *mod;
 
-	preempt_disable();
+	rcu_read_lock();
 	list_for_each_entry_rcu(mod, &modules, list) {
 		if (within_module_init(addr, mod) ||
 		    within_module_core(addr, mod)) {
@@ -3163,12 +3166,12 @@ int lookup_module_symbol_name(unsigned long addr, char *symname)
 			if (!sym)
 				goto out;
 			strlcpy(symname, sym, KSYM_NAME_LEN);
-			preempt_enable();
+			rcu_read_unlock();
 			return 0;
 		}
 	}
 out:
-	preempt_enable();
+	rcu_read_unlock();
 	return -ERANGE;
 }
 
@@ -3177,7 +3180,7 @@ int lookup_module_symbol_attrs(unsigned long addr, unsigned long *size,
 {
 	struct module *mod;
 
-	preempt_disable();
+	rcu_read_lock();
 	list_for_each_entry_rcu(mod, &modules, list) {
 		if (within_module_init(addr, mod) ||
 		    within_module_core(addr, mod)) {
@@ -3190,12 +3193,12 @@ int lookup_module_symbol_attrs(unsigned long addr, unsigned long *size,
 				strlcpy(modname, mod->name, MODULE_NAME_LEN);
 			if (name)
 				strlcpy(name, sym, KSYM_NAME_LEN);
-			preempt_enable();
+			rcu_read_unlock();
 			return 0;
 		}
 	}
 out:
-	preempt_enable();
+	rcu_read_unlock();
 	return -ERANGE;
 }
 
@@ -3204,7 +3207,7 @@ int module_get_kallsym(unsigned int symnum, unsigned long *value, char *type,
 {
 	struct module *mod;
 
-	preempt_disable();
+	rcu_read_lock();
 	list_for_each_entry_rcu(mod, &modules, list) {
 		if (symnum < mod->num_symtab) {
 			*value = mod->symtab[symnum].st_value;
@@ -3213,12 +3216,12 @@ int module_get_kallsym(unsigned int symnum, unsigned long *value, char *type,
 				KSYM_NAME_LEN);
 			strlcpy(module_name, mod->name, MODULE_NAME_LEN);
 			*exported = is_exported(name, *value, mod);
-			preempt_enable();
+			rcu_read_unlock();
 			return 0;
 		}
 		symnum -= mod->num_symtab;
 	}
-	preempt_enable();
+	rcu_read_unlock();
 	return -ERANGE;
 }
 
@@ -3241,7 +3244,7 @@ unsigned long module_kallsyms_lookup_name(const char *name)
 	unsigned long ret = 0;
 
 	/* Don't lock: we're in enough trouble already. */
-	preempt_disable();
+	rcu_read_lock();
 	if ((colon = strchr(name, ':')) != NULL) {
 		*colon = '\0';
 		if ((mod = find_module(name)) != NULL)
@@ -3252,7 +3255,7 @@ unsigned long module_kallsyms_lookup_name(const char *name)
 			if ((ret = mod_find_symname(mod, name)) != 0)
 				break;
 	}
-	preempt_enable();
+	rcu_read_unlock();
 	return ret;
 }
 
@@ -3264,14 +3267,18 @@ int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
 	unsigned int i;
 	int ret;
 
+	rcu_read_lock();
 	list_for_each_entry(mod, &modules, list) {
 		for (i = 0; i < mod->num_symtab; i++) {
 			ret = fn(data, mod->strtab + mod->symtab[i].st_name,
 				 mod, mod->symtab[i].st_value);
-			if (ret != 0)
+			if (ret != 0) {
+				rcu_read_unlock();
 				return ret;
+			}
 		}
 	}
+	rcu_read_unlock();
 	return 0;
 }
 #endif /* CONFIG_KALLSYMS */
@@ -3302,7 +3309,7 @@ static char *module_flags(struct module *mod, char *buf)
 /* Called by the /proc file system to return a list of modules. */
 static void *m_start(struct seq_file *m, loff_t *pos)
 {
-	mutex_lock(&module_mutex);
+	rcu_read_lock();
 	return seq_list_start(&modules, *pos);
 }
 
@@ -3313,7 +3320,7 @@ static void *m_next(struct seq_file *m, void *p, loff_t *pos)
 
 static void m_stop(struct seq_file *m, void *p)
 {
-	mutex_unlock(&module_mutex);
+	rcu_read_unlock();
 }
 
 static int m_show(struct seq_file *m, void *p)
@@ -3379,7 +3386,7 @@ const struct exception_table_entry *search_module_extables(unsigned long addr)
 	const struct exception_table_entry *e = NULL;
 	struct module *mod;
 
-	preempt_disable();
+	rcu_read_lock();
 	list_for_each_entry_rcu(mod, &modules, list) {
 		if (mod->num_exentries == 0)
 			continue;
@@ -3390,7 +3397,7 @@ const struct exception_table_entry *search_module_extables(unsigned long addr)
 		if (e)
 			break;
 	}
-	preempt_enable();
+	rcu_read_unlock();
 
 	/* Now, if we found one, we are running inside it now, hence
 	   we cannot unload the module, hence no refcnt needed. */
@@ -3408,9 +3415,9 @@ bool is_module_address(unsigned long addr)
 {
 	bool ret;
 
-	preempt_disable();
+	rcu_read_lock();
 	ret = __module_address(addr) != NULL;
-	preempt_enable();
+	rcu_read_unlock();
 
 	return ret;
 }
@@ -3419,7 +3426,7 @@ bool is_module_address(unsigned long addr)
  * __module_address - get the module which contains an address.
  * @addr: the address.
  *
- * Must be called with preempt disabled or module mutex held so that
+ * Must be called with rcu_read_lock or module mutex held so that
  * module doesn't get freed during this.
  */
 struct module *__module_address(unsigned long addr)
@@ -3449,9 +3456,9 @@ bool is_module_text_address(unsigned long addr)
 {
 	bool ret;
 
-	preempt_disable();
+	rcu_read_lock();
 	ret = __module_text_address(addr) != NULL;
-	preempt_enable();
+	rcu_read_unlock();
 
 	return ret;
 }
@@ -3460,7 +3467,7 @@ bool is_module_text_address(unsigned long addr)
  * __module_text_address - get the module whose code contains an address.
  * @addr: the address.
  *
- * Must be called with preempt disabled or module mutex held so that
+ * Must be called with rcu_read_lock or module mutex held so that
  * module doesn't get freed during this.
  */
 struct module *__module_text_address(unsigned long addr)
@@ -3484,10 +3491,10 @@ void print_modules(void)
 
 	printk(KERN_DEFAULT "Modules linked in:");
 	/* Most callers should already have preempt disabled, but make sure */
-	preempt_disable();
+	rcu_read_lock();
 	list_for_each_entry_rcu(mod, &modules, list)
 		printk(" %s%s", mod->name, module_flags(mod, buf));
-	preempt_enable();
+	rcu_read_unlock();
 	if (last_unloaded_module[0])
 		printk(" [last unloaded: %s]", last_unloaded_module);
 	printk("\n");
-- 
1.7.7.6

