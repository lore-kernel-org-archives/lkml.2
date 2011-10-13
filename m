Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948Ab1JMP3z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 11:29:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:43734 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755903Ab1JMP3x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 11:29:53 -0400
Subject: Re: [PATCH RFC V4 06/10] jump_label: add
 arch_jump_label_transform_static() to optimise non-live code updates
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Baron <jbaron@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Date: Thu, 13 Oct 2011 17:29:17 +0200
In-Reply-To: <20111013135439.GA2455@redhat.com>
References: <cover.1318464169.git.jeremy.fitzhardinge@citrix.com>
	 <16f652166605c973e9817177b6ba6a081e3e5b3f.1318464413.git.jeremy.fitzhardinge@citrix.com>
	 <1318501954.24856.5.camel@twins> <20111013135439.GA2455@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1318519758.27731.15.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-13 at 09:54 -0400, Jason Baron wrote:
> 
> > So I got myself a little confused wrt the early jump_label_apply_nops()
> > call and the MODULE_COMING notifiers.
> > 
> > It looks to me like jump_label_apply_nops() is called way early and is
> > in fact called before _any_ of the module code has had a chance of
> > running. However it simply NOPs out all jump_labels.
> > 
> 
> yes.
> 
> > The jump_label_add_module() thing, which is ran on the MODULE_COMING
> > callback will then set up stuff and do the proper patch-up.
> > 
> 
> yes, only for the enabled ones.

But we could make it nop out the disabled ones quite trivially.

> > Now the only bit of the module text that can be ran between those two
> > calls appears to be the module argument parsing stuff, but since
> > jump_labels are non-functional it can't rely on them, so why do we do
> > the early patch up again?
> > 
> > 
> 
> The 'early patch' is for putting in the 'ideal' no-ops into the module
> code. These 'ideal' no-ops are discovered at run-time, not boot-time.

Sure, but since we can't use static_branch() and friends from very early
module code (arg parsing) anyway, it doesn't matter what NOP they
encounter, so we might as well do something like the below, right?

> The code is optimized (hopefully) for the most common case. The
> jump labels are by nature expected to be off, 

I actually need them to be either way.. no preference between on or off
just a means of very _very_ infrequent runtime change in behaviour.

If we can push jump_label init to before sched_init() all I need is a
static_branch() without the unlikely() in to avoid GCC out-of-lining the
branch.

> and by patching them early
> like this, at least for x86, we can avoid the stop machine calls. So its
> the combination of most are expected to be off and no sense to call extra
> stop machines that lead the code to its present state.

But we could use arch_jump_label_transform_static because its before we
actually execute any module text (sans the arg crap) which is
stomp-machine free, removing that obstacle.

Or am I confused more?

---
 arch/mips/kernel/module.c  |    3 ---
 arch/sparc/kernel/module.c |    3 ---
 arch/x86/kernel/module.c   |    3 ---
 include/linux/jump_label.h |    6 ------
 kernel/jump_label.c        |   22 +++++++++++++---------
 5 files changed, 13 insertions(+), 24 deletions(-)

Index: linux-2.6/arch/mips/kernel/module.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/module.c
+++ linux-2.6/arch/mips/kernel/module.c
@@ -368,9 +368,6 @@ int module_finalize(const Elf_Ehdr *hdr,
 	const Elf_Shdr *s;
 	char *secstrings = (void *)hdr + sechdrs[hdr->e_shstrndx].sh_offset;
 
-	/* Make jump label nops. */
-	jump_label_apply_nops(me);
-
 	INIT_LIST_HEAD(&me->arch.dbe_list);
 	for (s = sechdrs; s < sechdrs + hdr->e_shnum; s++) {
 		if (strcmp("__dbe_table", secstrings + s->sh_name) != 0)
Index: linux-2.6/arch/sparc/kernel/module.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/module.c
+++ linux-2.6/arch/sparc/kernel/module.c
@@ -207,9 +207,6 @@ int module_finalize(const Elf_Ehdr *hdr,
 		    const Elf_Shdr *sechdrs,
 		    struct module *me)
 {
-	/* make jump label nops */
-	jump_label_apply_nops(me);
-
 	/* Cheetah's I-cache is fully coherent.  */
 	if (tlb_type == spitfire) {
 		unsigned long va;
Index: linux-2.6/arch/x86/kernel/module.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/module.c
+++ linux-2.6/arch/x86/kernel/module.c
@@ -194,9 +194,6 @@ int module_finalize(const Elf_Ehdr *hdr,
 		apply_paravirt(pseg, pseg + para->sh_size);
 	}
 
-	/* make jump label nops */
-	jump_label_apply_nops(me);
-
 	return 0;
 }
 
Index: linux-2.6/include/linux/jump_label.h
===================================================================
--- linux-2.6.orig/include/linux/jump_label.h
+++ linux-2.6/include/linux/jump_label.h
@@ -52,7 +52,6 @@ extern int jump_label_text_reserved(void
 extern void jump_label_inc(struct jump_label_key *key);
 extern void jump_label_dec(struct jump_label_key *key);
 extern bool jump_label_enabled(struct jump_label_key *key);
-extern void jump_label_apply_nops(struct module *mod);
 
 #else  /* !HAVE_JUMP_LABEL */
 
@@ -97,11 +96,6 @@ static inline bool jump_label_enabled(st
 {
 	return !!atomic_read(&key->enabled);
 }
-
-static inline int jump_label_apply_nops(struct module *mod)
-{
-	return 0;
-}
 #endif	/* HAVE_JUMP_LABEL */
 
 #endif	/* _LINUX_JUMP_LABEL_H */
Index: linux-2.6/kernel/jump_label.c
===================================================================
--- linux-2.6.orig/kernel/jump_label.c
+++ linux-2.6/kernel/jump_label.c
@@ -116,9 +116,15 @@ void __weak arch_jump_label_transform_st
 	arch_jump_label_transform(entry, type);	
 }
 
+static inline enum jump_label_type jump_label_dyn_type(struct jump_label_key *key)
+{
+	return jump_label_enabled(key) ? JUMP_LABEL_ENABLE : JUMP_LABEL_DISABLE;
+}
+
 static void __jump_label_update(struct jump_label_key *key,
 				struct jump_entry *entry,
-				struct jump_entry *stop, int enable)
+				struct jump_entry *stop, int enable,
+				void (*transform)(struct jump_entry *, enum jump_label_type))
 {
 	for (; (entry < stop) &&
 	      (entry->key == (jump_label_t)(unsigned long)key);
@@ -129,7 +135,7 @@ static void __jump_label_update(struct j
 		 * init code, see jump_label_invalidate_module_init().
 		 */
 		if (entry->code && kernel_text_address(entry->code))
-			arch_jump_label_transform(entry, enable);
+			transform(entry, enable);
 	}
 }
 
@@ -147,8 +153,7 @@ void __init jump_label_init(void)
 		struct jump_label_key *iterk;
 
 		iterk = (struct jump_label_key *)(unsigned long)iter->key;
-		arch_jump_label_transform_static(iter, jump_label_enabled(iterk) ?
-						 JUMP_LABEL_ENABLE : JUMP_LABEL_DISABLE);
+		arch_jump_label_transform_static(iter, jump_label_dyn_type(iterk));
 		if (iterk == key)
 			continue;
 
@@ -193,7 +198,7 @@ static void __jump_label_mod_update(stru
 
 		__jump_label_update(key, mod->entries,
 				    m->jump_entries + m->num_jump_entries,
-				    enable);
+				    enable, arch_jump_label_transform);
 		mod = mod->next;
 	}
 }
@@ -256,9 +261,8 @@ static int jump_label_add_module(struct
 		jlm->next = key->next;
 		key->next = jlm;
 
-		if (jump_label_enabled(key))
-			__jump_label_update(key, iter, iter_stop,
-					    JUMP_LABEL_ENABLE);
+		__jump_label_update(key, iter, iter_stop, jump_label_dyn_type(key),
+				arch_jump_label_transform_static);
 	}
 
 	return 0;
@@ -392,7 +396,7 @@ static void jump_label_update(struct jum
 #endif
 	/* if there are no users, entry can be NULL */
 	if (entry)
-		__jump_label_update(key, entry, stop, enable);
+		__jump_label_update(key, entry, stop, enable, arch_jump_label_transform);
 }
 
 #endif

