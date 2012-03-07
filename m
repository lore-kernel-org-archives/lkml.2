Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758810Ab2CGRBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 12:01:46 -0500
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:47131
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758534Ab2CGRBp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 12:01:45 -0500
X-SpamScore: -9
X-BigFish: VPS-9(zz9371I936eK542Mzz1202hzz8275dhz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M0IX9L-01-EQ2-02
X-M-MSG: 
From: "Chen, Dennis (SRDC SW)" <Dennis1.Chen@amd.com>
To: "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] Refine mutex and rcu method in module.c,
 kernel<3.2.9>
Thread-Topic: [PATCH 1/2] Refine mutex and rcu method in module.c,
 kernel<3.2.9>
Thread-Index: Acz8cbLg6k3HMRVqQxaI2PGzwf9WcQAD+uJA
Date: Wed, 7 Mar 2012 16:46:27 +0000
Message-ID: <491D6B4EAD0A714894D8AD22F4BDE043032906@SCYBEXDAG04.amd.com>
References: <491D6B4EAD0A714894D8AD22F4BDE04303289D@SCYBEXDAG04.amd.com>
In-Reply-To: <491D6B4EAD0A714894D8AD22F4BDE04303289D@SCYBEXDAG04.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.74.102]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding kernel module maintainer -- Rusty Russell

-----Original Message-----
From: Chen, Dennis (SRDC SW) 
Sent: Wednesday, March 07, 2012 10:51 PM
To: linux-kernel@vger.kernel.org
Cc: Chen, Dennis (SRDC SW)
Subject: [PATCH 1/2] Refine mutex and rcu method in module.c, kernel<3.2.9>

1. Narrow down the granularity of mutex_lock/ mutex_unlock
2. Replace some unnecessary mutex_lock/mutex_unlock pairs with RCU
3. Refine the consistent calling style of RCU functioan 

--- kernel/module.ori.c        2012-03-07 19:59:07.890900147 +0800
+++ kernel/module.c    2012-03-07 22:12:44.982738729 +0800
@@ -419,11 +419,14 @@
 struct module *find_module(const char *name)
 {
        struct module *mod;
-
-       list_for_each_entry(mod, &modules, list) {
-               if (strcmp(mod->name, name) == 0)
+       rcu_read_lock(); 
+       list_for_each_entry_rcu(mod, &modules, list) {
+               if (strcmp(mod->name, name) == 0) {
+                       rcu_read_unlock();
                        return mod;
+                }
        }
+       rcu_read_unlock();
        return NULL;
 }
 EXPORT_SYMBOL_GPL(find_module);
@@ -488,7 +491,7 @@
        struct module *mod;
        unsigned int cpu;
 
-       preempt_disable();
+       rcu_read_lock();
 
        list_for_each_entry_rcu(mod, &modules, list) {
                if (!mod->percpu_size)
@@ -498,13 +501,13 @@
 
                        if ((void *)addr >= start &&
                            (void *)addr < start + mod->percpu_size) {
-                               preempt_enable();
+                               rcu_read_unlock();
                                return true;
                        }
                }
        }
 
-       preempt_enable();
+       rcu_read_unlock();
        return false;
 }
 
@@ -876,11 +879,11 @@
 {
        struct module *owner;
 
-       preempt_disable();
+       rcu_read_lock();
        if (!find_symbol(symbol, &owner, NULL, true, false))
                BUG();
        module_put(owner);
-       preempt_enable();
+       rcu_read_unlock();
 }
 EXPORT_SYMBOL(__symbol_put);
 
@@ -1598,8 +1601,11 @@
 static int __unlink_module(void *_mod)
 {
        struct module *mod = _mod;
-       list_del(&mod->list);
-       module_bug_cleanup(mod);
+       mutex_lock(&module_mutex);
+       list_del_rcu(&mod->list);
+       module_bug_cleanup(mod);
+       mutex_unlock(&module_mutex);
+
        return 0;
 }
 
@@ -1672,7 +1678,7 @@
 {
        struct module *mod;
 
-       mutex_lock(&module_mutex);
+       rcu_read_lock();
        list_for_each_entry_rcu(mod, &modules, list) {
                if ((mod->module_core) && (mod->core_text_size)) {
                        set_page_attributes(mod->module_core,
@@ -1685,7 +1691,7 @@
                                                set_memory_rw);
                }
        }
-       mutex_unlock(&module_mutex);
+       rcu_read_unlock();
 }
 
 /* Iterate through all modules and set each module's text as RO */
@@ -1693,7 +1699,7 @@
 {
        struct module *mod;
 
-       mutex_lock(&module_mutex);
+       rcu_read_lock();
        list_for_each_entry_rcu(mod, &modules, list) {
                if ((mod->module_core) && (mod->core_text_size)) {
                        set_page_attributes(mod->module_core,
@@ -1706,7 +1712,7 @@
                                                set_memory_ro);
                }
        }
-       mutex_unlock(&module_mutex);
+       rcu_read_unlock();
 }
 #else
 static inline void set_section_ro_nx(void *base, unsigned long text_size, unsigned long ro_size, unsigned long total_size) { }
@@ -1729,9 +1735,7 @@
        trace_module_free(mod);
 
        /* Delete from various lists */
-       mutex_lock(&module_mutex);
        stop_machine(__unlink_module, mod, NULL);
-       mutex_unlock(&module_mutex);
        mod_sysfs_teardown(mod);
 
        /* Remove dynamic debug info */
@@ -1769,11 +1773,11 @@
        struct module *owner;
        const struct kernel_symbol *sym;
 
-       preempt_disable();
+       rcu_read_lock();
        sym = find_symbol(symbol, &owner, NULL, true, true);
        if (sym && strong_try_module_get(owner))
                sym = NULL;
-       preempt_enable();
+       rcu_read_unlock();
 
        return sym ? (void *)sym->value : NULL;
 }
@@ -2866,20 +2870,13 @@
 
        /* Mark state as coming so strong_try_module_get() ignores us. */
        mod->state = MODULE_STATE_COMING;
-
-       /* Now sew it into the lists so we can get lockdep and oops
-        * info during argument parsing.  No one should access us, since
-        * strong_try_module_get() will fail.
-        * lockdep/oops can run asynchronous, so use the RCU list insertion
-        * function to insert in a way safe to concurrent readers.
-        * The mutex protects against concurrent writers.
-        */
-       mutex_lock(&module_mutex);
+        
+        /* Concurrent writers for the global modules list are protected by RCU*/
        if (find_module(mod->name)) {
                err = -EEXIST;
                goto unlock;
        }
-
+        
        /* This has to be done once we're sure module name is unique. */
        dynamic_debug_setup(info.debug, info.num_debug);
 
@@ -2889,7 +2886,9 @@
                goto ddebug;
 
        module_bug_finalize(info.hdr, info.sechdrs, mod);
-       list_add_rcu(&mod->list, &modules);
+
+       mutex_lock(&module_mutex);
+       list_add_rcu(&mod->list, &modules);
        mutex_unlock(&module_mutex);
 
        /* Module is ready to execute: parsing args may do that. */
@@ -2915,11 +2914,10 @@
        /* Unlink carefully: kallsyms could be walking list. */
        list_del_rcu(&mod->list);
        module_bug_cleanup(mod);
-
+       mutex_unlock(&module_mutex);
  ddebug:
        dynamic_debug_remove(info.debug);
  unlock:
-       mutex_unlock(&module_mutex);
        synchronize_sched();
        kfree(mod->args);
  free_arch_cleanup:
@@ -3102,7 +3100,7 @@
        struct module *mod;
        const char *ret = NULL;
 
-       preempt_disable();
+       rcu_read_lock();
        list_for_each_entry_rcu(mod, &modules, list) {
                if (within_module_init(addr, mod) ||
                    within_module_core(addr, mod)) {
@@ -3117,7 +3115,7 @@
                strncpy(namebuf, ret, KSYM_NAME_LEN - 1);
                ret = namebuf;
        }
-       preempt_enable();
+       rcu_read_unlock();
        return ret;
 }
 
@@ -3125,7 +3123,7 @@
 {
        struct module *mod;
 
-       preempt_disable();
+       rcu_read_lock();
        list_for_each_entry_rcu(mod, &modules, list) {
                if (within_module_init(addr, mod) ||
                    within_module_core(addr, mod)) {
@@ -3135,12 +3133,12 @@
                        if (!sym)
                                goto out;
                        strlcpy(symname, sym, KSYM_NAME_LEN);
-                       preempt_enable();
+                       rcu_read_unlock();
                        return 0;
                }
        }
 out:
-       preempt_enable();
+       rcu_read_unlock();
        return -ERANGE;
 }
 
@@ -3149,7 +3147,7 @@
 {
        struct module *mod;
 
-       preempt_disable();
+       rcu_read_lock();
        list_for_each_entry_rcu(mod, &modules, list) {
                if (within_module_init(addr, mod) ||
                    within_module_core(addr, mod)) {
@@ -3162,12 +3160,12 @@
                                strlcpy(modname, mod->name, MODULE_NAME_LEN);
                        if (name)
                                strlcpy(name, sym, KSYM_NAME_LEN);
-                       preempt_enable();
+                       rcu_read_unlock();
                        return 0;
                }
        }
 out:
-       preempt_enable();
+       rcu_read_unlock();
        return -ERANGE;
 }
 
@@ -3176,7 +3174,7 @@
 {
        struct module *mod;
 
-       preempt_disable();
+       rcu_read_lock();
        list_for_each_entry_rcu(mod, &modules, list) {
                if (symnum < mod->num_symtab) {
                        *value = mod->symtab[symnum].st_value;
@@ -3185,12 +3183,12 @@
                                KSYM_NAME_LEN);
                        strlcpy(module_name, mod->name, MODULE_NAME_LEN);
                        *exported = is_exported(name, *value, mod);
-                       preempt_enable();
+                       rcu_read_unlock();
                        return 0;
                }
                symnum -= mod->num_symtab;
        }
-       preempt_enable();
+       rcu_read_unlock();
        return -ERANGE;
 }
 
@@ -3212,19 +3210,18 @@
        char *colon;
        unsigned long ret = 0;
 
-       /* Don't lock: we're in enough trouble already. */
-       preempt_disable();
        if ((colon = strchr(name, ':')) != NULL) {
                *colon = '\0';
                if ((mod = find_module(name)) != NULL)
                        ret = mod_find_symname(mod, colon+1);
                *colon = ':';
        } else {
+               rcu_read_lock();
                list_for_each_entry_rcu(mod, &modules, list)
                        if ((ret = mod_find_symname(mod, name)) != 0)
                                break;
+               rcu_read_unlock();
        }
-       preempt_enable();
        return ret;
 }
 
@@ -3236,14 +3233,18 @@
        unsigned int i;
        int ret;
 
-       list_for_each_entry(mod, &modules, list) {
+       rcu_read_lock();
+       list_for_each_entry_rcu(mod, &modules, list) {
                for (i = 0; i < mod->num_symtab; i++) {
                        ret = fn(data, mod->strtab + mod->symtab[i].st_name,
                                 mod, mod->symtab[i].st_value);
-                       if (ret != 0)
+                       if (ret != 0) {
+                               rcu_read_unlock();
                                return ret;
+                        }
                }
        }
+       rcu_read_unlock();
        return 0;
 }
 #endif /* CONFIG_KALLSYMS */
@@ -3364,7 +3365,7 @@
        const struct exception_table_entry *e = NULL;
        struct module *mod;
 
-       preempt_disable();
+       rcu_read_lock();
        list_for_each_entry_rcu(mod, &modules, list) {
                if (mod->num_exentries == 0)
                        continue;
@@ -3375,7 +3376,7 @@
                if (e)
                        break;
        }
-       preempt_enable();
+       rcu_read_unlock();
 
        /* Now, if we found one, we are running inside it now, hence
           we cannot unload the module, hence no refcnt needed. */
@@ -3393,9 +3394,9 @@
 {
        bool ret;
 
-       preempt_disable();
+       rcu_read_lock();
        ret = __module_address(addr) != NULL;
-       preempt_enable();
+       rcu_read_unlock();
 
        return ret;
 }
@@ -3434,9 +3435,9 @@
 {
        bool ret;
 
-       preempt_disable();
+       rcu_read_lock();
        ret = __module_text_address(addr) != NULL;
-       preempt_enable();
+       rcu_read_unlock();
 
        return ret;
 }
@@ -3469,10 +3470,10 @@
 
        printk(KERN_DEFAULT "Modules linked in:");
        /* Most callers should already have preempt disabled, but make sure */
-       preempt_disable();
+       rcu_read_lock();
        list_for_each_entry_rcu(mod, &modules, list)
                printk(" %s%s", mod->name, module_flags(mod, buf));
-       preempt_enable();
+       rcu_read_unlock();
        if (last_unloaded_module[0])
                printk(" [last unloaded: %s]", last_unloaded_module);
        printk("\n");

