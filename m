Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624Ab1JNVvo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 17:51:44 -0400
Received: from claw.goop.org ([74.207.240.146]:53376 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932246Ab1JNVvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 17:51:40 -0400
Message-ID: <4E98AEDD.4010503@goop.org>
Date: Fri, 14 Oct 2011 14:51:25 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Steven Rostedt <rostedt@goodmis.org>,
        "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>, Jason Baron <jbaron@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH RFC V4 10/10] jump-label: initialize jump-label subsystem
 much earlier
References: <cover.1318464169.git.jeremy.fitzhardinge@citrix.com>  <c133180533d7e520bb1e818e987117811a666fbc.1318464413.git.jeremy.fitzhardinge@citrix.com> <1318502628.24856.10.camel@twins>
In-Reply-To: <1318502628.24856.10.camel@twins>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2011 03:43 AM, Peter Zijlstra wrote:
> On Wed, 2011-10-12 at 17:08 -0700, Jeremy Fitzhardinge wrote:
>> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>>
>> Initialize jump_labels much earlier, we can use them.
> We can use them, where? how? what?, that sentence just begs for more.

How about this?  Proper comment and much earlier init.

    J

>From 62720522d512ffce8f4be9140f73fefbdfd2872e Mon Sep 17 00:00:00 2001
From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Date: Wed, 12 Oct 2011 16:17:54 -0700
Subject: [PATCH] jump-label: initialize jump-label subsystem much earlier

Initialize jump_labels much, much earlier, so they're available for use
during system setup.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index 56594e4..388b0d4 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -16,7 +16,7 @@ struct jump_label_key {
 
 # include <asm/jump_label.h>
 # define HAVE_JUMP_LABEL
-#endif
+#endif	/* CC_HAVE_ASM_GOTO && CONFIG_JUMP_LABEL */
 
 enum jump_label_type {
 	JUMP_LABEL_DISABLE = 0,
@@ -41,6 +41,7 @@ static __always_inline bool static_branch(struct jump_label_key *key)
 extern struct jump_entry __start___jump_table[];
 extern struct jump_entry __stop___jump_table[];
 
+extern void jump_label_init(void);
 extern void jump_label_lock(void);
 extern void jump_label_unlock(void);
 extern void arch_jump_label_transform(struct jump_entry *entry,
@@ -53,7 +54,7 @@ extern void jump_label_dec(struct jump_label_key *key);
 extern bool jump_label_enabled(struct jump_label_key *key);
 extern void jump_label_apply_nops(struct module *mod);
 
-#else
+#else  /* !HAVE_JUMP_LABEL */
 
 #include <linux/atomic.h>
 
@@ -63,6 +64,10 @@ struct jump_label_key {
 	atomic_t enabled;
 };
 
+static __always_inline void jump_label_init(void)
+{
+}
+
 static __always_inline bool static_branch(struct jump_label_key *key)
 {
 	if (unlikely(atomic_read(&key->enabled)))
@@ -97,7 +102,6 @@ static inline int jump_label_apply_nops(struct module *mod)
 {
 	return 0;
 }
+#endif	/* HAVE_JUMP_LABEL */
 
-#endif
-
-#endif
+#endif	/* _LINUX_JUMP_LABEL_H */
diff --git a/init/main.c b/init/main.c
index 2a9b88a..29d8d84 100644
--- a/init/main.c
+++ b/init/main.c
@@ -515,6 +515,9 @@ asmlinkage void __init start_kernel(void)
 	parse_args("Booting kernel", static_command_line, __start___param,
 		   __stop___param - __start___param,
 		   &unknown_bootoption);
+
+	jump_label_init();
+
 	/*
 	 * These use large bootmem allocations and must precede
 	 * kmem_cache_init()
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index ff2028f..bbdfe2a 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -133,7 +133,7 @@ static void __jump_label_update(struct jump_label_key *key,
 	}
 }
 
-static __init int jump_label_init(void)
+void __init jump_label_init(void)
 {
 	struct jump_entry *iter_start = __start___jump_table;
 	struct jump_entry *iter_stop = __stop___jump_table;
@@ -159,10 +159,7 @@ static __init int jump_label_init(void)
 #endif
 	}
 	jump_label_unlock();
-
-	return 0;
 }
-early_initcall(jump_label_init);
 
 #ifdef CONFIG_MODULES
 


