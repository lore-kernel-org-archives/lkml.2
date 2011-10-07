Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab1JGTVx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 15:21:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:54245 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017Ab1JGTVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 15:21:52 -0400
X-Authority-Analysis: v=1.1 cv=agqPq5NoKwAPC9P66H7dbYUCjxvmT73as08i4x3aqAA= c=1 sm=0 a=gxfjmhR6zbwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=meVymXHHAAAA:8 a=KfiAD8111wU19YO4z_cA:9 a=xDXKTUQFG9w3g_tP3PoA:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [PATCH][RFC] jump_labels/x86: Use either 5 byte or 2 byte jumps
From: Steven Rostedt <rostedt@goodmis.org>
To: Jason Baron <jbaron@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Richard Henderson <rth@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        peterz@infradead.org
Date: Fri, 07 Oct 2011 15:21:49 -0400
In-Reply-To: <20111007185214.GD2978@redhat.com>
References: <4E8CF385.2080804@zytor.com> <4E8DEB19.1050509@goop.org>
	 <20111006181055.GA2505@redhat.com>
	 <1317925615.4729.14.camel@gandalf.stny.rr.com>
	 <4E8DF870.6010000@redhat.com>
	 <1317929321.4729.17.camel@gandalf.stny.rr.com> <4E8E20CD.5030207@goop.org>
	 <1317938775.4729.29.camel@gandalf.stny.rr.com> <4E8E275F.6010801@goop.org>
	 <1318007374.4729.58.camel@gandalf.stny.rr.com>
	 <20111007185214.GD2978@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1318015311.4729.69.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-07 at 14:52 -0400, Jason Baron wrote:
> On Fri, Oct 07, 2011 at 01:09:32PM -0400, Steven Rostedt wrote:
> > Note, this is just hacked together and needs to be cleaned up. Please do
> > not comment on formatting or other sloppiness of this patch. I know it's
> > sloppy and I left debug statements in. I want the comments to be on the
> > idea of the patch.
> > 
> > I created a new file called scripts/update_jump_label.[ch] based on some
> > of the work of recordmcount.c. This is executed at build time on all
> > object files just like recordmcount is. But it does not add any new
> > sections, it just modifies the code at build time to convert all jump
> > labels into nops.
> > 
> > The idea is in arch/x86/include/asm/jump_label.h to not place a nop, but
> > instead to insert a jmp to the label. Depending on how gcc optimizes the
> > code, the jmp will be either end up being a 2 byte or 5 byte jump.
> > 
> > After an object is compiled, update_jump_label is executed on this file
> > and it reads the ELF relocation table to find the jump label locations
> > and examines what jump was used. It then converts the jump into either a
> > 2 byte or 5 byte nop that is appropriate.
> > 
> > At boot time, the jump labels no longer need to be converted (although
> > we may do so in the future to use better nops depending on the machine
> > that is used). When jump labels are enabled, the code is examined to see
> > if a two byte or 5 byte version was used, and the appropriate update is
> > made.
> > 
> > I just booted this patch and it worked. I was able to enable and disable
> > trace points using jump labels. Benchmarks are welcomed :)
> > 
> > Comments and thoughts?
> > 
> 
> Generally, I really like it, I guess b/c I suggested it :)

Yeah, I saw your suggestion about using jump for the asm. I didn't read
carefully enough if you suggested the build time changes or not. I
thought about recordmcount at that moment, and decided to try it ;)

>  I'll try and
> run some workloads on it - A real simple one, I used recently was putting
> a single jump label in 'getppid()' and then calling it in a loop - I
> wonder if the short nop vs long nop would show up there, as a baseline
> test. (fwiw, the jump label vs. no jump label for this test was anywhere
> b/w 1-5% improvement).
> 
> Anyways, some comments below.  
> 
> > -- Steve
> > 
> > Sloppy-signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > 
> > diff --git a/Makefile b/Makefile
> > index 31f967c..8368f42 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -245,7 +245,7 @@ CONFIG_SHELL := $(shell if [ -x "$$BASH" ]; then echo $$BASH; \
> >  
> >  HOSTCC       = gcc
> >  HOSTCXX      = g++
> > -HOSTCFLAGS   = -Wall -Wmissing-prototypes -Wstrict-prototypes -O2 -fomit-frame-pointer
> > +HOSTCFLAGS   = -Wall -Wmissing-prototypes -Wstrict-prototypes -g -fomit-frame-pointer
> >  HOSTCXXFLAGS = -O2
> >  
> >  # Decide whether to build built-in, modular, or both.
> > @@ -611,6 +611,13 @@ ifdef CONFIG_DYNAMIC_FTRACE
> >  endif
> >  endif
> >  
> > +ifdef CONFIG_JUMP_LABEL
> > +	ifdef CONFIG_HAVE_BUILD_TIME_JUMP_LABEL
> > +		BUILD_UPDATE_JUMP_LABEL := y
> > +		export BUILD_UPDATE_JUMP_LABEL
> > +	endif
> > +endif
> > +
> >  # We trigger additional mismatches with less inlining
> >  ifdef CONFIG_DEBUG_SECTION_MISMATCH
> >  KBUILD_CFLAGS += $(call cc-option, -fno-inline-functions-called-once)
> > diff --git a/arch/Kconfig b/arch/Kconfig
> > index 4b0669c..8fa6934 100644
> > --- a/arch/Kconfig
> > +++ b/arch/Kconfig
> > @@ -169,6 +169,12 @@ config HAVE_PERF_EVENTS_NMI
> >  	  subsystem.  Also has support for calculating CPU cycle events
> >  	  to determine how many clock cycles in a given period.
> >  
> > +config HAVE_BUILD_TIME_JUMP_LABEL
> > +       bool
> > +       help
> > +	If an arch uses scripts/update_jump_label to patch in jump nops
> > +	at build time, then it must enable this option.
> > +
> >  config HAVE_ARCH_JUMP_LABEL
> >  	bool
> >  
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index 6a47bb2..6de726a 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -61,6 +61,7 @@ config X86
> >  	select HAVE_ARCH_KMEMCHECK
> >  	select HAVE_USER_RETURN_NOTIFIER
> >  	select HAVE_ARCH_JUMP_LABEL
> > +	select HAVE_BUILD_TIME_JUMP_LABEL
> >  	select HAVE_TEXT_POKE_SMP
> >  	select HAVE_GENERIC_HARDIRQS
> >  	select HAVE_SPARSE_IRQ
> > diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
> > index a32b18c..872b3e1 100644
> > --- a/arch/x86/include/asm/jump_label.h
> > +++ b/arch/x86/include/asm/jump_label.h
> > @@ -14,7 +14,7 @@
> >  static __always_inline bool arch_static_branch(struct jump_label_key *key)
> >  {
> >  	asm goto("1:"
> > -		JUMP_LABEL_INITIAL_NOP
> > +		"jmp %l[l_yes]\n"
> >  		".pushsection __jump_table,  \"aw\" \n\t"
> >  		_ASM_ALIGN "\n\t"
> >  		_ASM_PTR "1b, %l[l_yes], %c0 \n\t"
> > diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
> > index 3fee346..1f7f88f 100644
> > --- a/arch/x86/kernel/jump_label.c
> > +++ b/arch/x86/kernel/jump_label.c
> > @@ -16,34 +16,75 @@
> >  
> >  #ifdef HAVE_JUMP_LABEL
> >  
> > +static unsigned char nop_short[] = { P6_NOP2 };
> > +
> >  union jump_code_union {
> >  	char code[JUMP_LABEL_NOP_SIZE];
> >  	struct {
> >  		char jump;
> >  		int offset;
> >  	} __attribute__((packed));
> > +	struct {
> > +		char jump_short;
> > +		char offset_short;
> > +	} __attribute__((packed));
> >  };
> >  
> >  void arch_jump_label_transform(struct jump_entry *entry,
> >  			       enum jump_label_type type)
> >  {
> >  	union jump_code_union code;
> > +	unsigned char op;
> > +	unsigned size;
> > +	unsigned char nop;
> > +
> > +	/* Use probe_kernel_read()? */
> > +	op = *(unsigned char *)entry->code;
> > +	nop = ideal_nops[NOP_ATOMIC5][0];
> >  
> >  	if (type == JUMP_LABEL_ENABLE) {
> > -		code.jump = 0xe9;
> > -		code.offset = entry->target -
> > -				(entry->code + JUMP_LABEL_NOP_SIZE);
> > -	} else
> > -		memcpy(&code, ideal_nops[NOP_ATOMIC5], JUMP_LABEL_NOP_SIZE);
> > +		if (op == 0xe9 || op == 0xeb)
> > +			/* Already enabled. Warn? */
> > +			return;
> > +
> 
> Using the jump_label_inc/dec interface this shouldn't happen, I would
> have it be BUG
> 
> 
> > +		/* FIXME for all archs */
> > +		if (op == nop_short[0]) {
> > +			size = 2;
> > +			code.jump_short = 0xeb;
> > +			code.offset = entry->target -
> > +				(entry->code + 2);
> > +			/* Check for overflow ? */
> > +		} else if (op == nop) {
> > +			size = JUMP_LABEL_NOP_SIZE;
> > +			code.jump = 0xe9;
> > +			code.offset = entry->target - (entry->code + size);
> > +		} else
> > +			return; /* WARN ? */
> 
> same here, at least WARN, more likely BUG()

I just don't like using BUG(). BUG() means that if we continue we will
corrupt the filesystem or make you go blind. WARN and returning here
should not cause any harm and will even let those with X terminals see
oops in /var/log/messages.

> 
> > +
> > +	} else {
> > +		if (op == nop_short[0] || nop)
> > +			/* Already disabled, warn? */
> > +			return;
> > +
> 
> same here.
> 
> > +		if (op == 0xe9) {
> > +			size = JUMP_LABEL_NOP_SIZE;
> > +			memcpy(&code, ideal_nops[NOP_ATOMIC5], size);
> > +		} else if (op == 0xeb) {
> > +			size = 2;
> > +			memcpy(&code, nop_short, size);
> > +		} else
> > +			return; /* WARN ? */
> 
> same here

WARN is better.

> 
> > +	}
> >  	get_online_cpus();
> >  	mutex_lock(&text_mutex);
> > -	text_poke_smp((void *)entry->code, &code, JUMP_LABEL_NOP_SIZE);
> > +	text_poke_smp((void *)entry->code, &code, size);
> >  	mutex_unlock(&text_mutex);
> >  	put_online_cpus();
> >  }
> >  
> >  void arch_jump_label_text_poke_early(jump_label_t addr)
> >  {
> > +	return;
> >  	text_poke_early((void *)addr, ideal_nops[NOP_ATOMIC5],
> >  			JUMP_LABEL_NOP_SIZE);
> >  }
> 
> hmmm...we spent a bunch of time selecting the 'ideal' run-time noops I
> wouldn't want to drop that work.

Read my change log again :)


> 
> > diff --git a/scripts/Makefile b/scripts/Makefile
> > index df7678f..738b65c 100644
> > --- a/scripts/Makefile
> > +++ b/scripts/Makefile
> > @@ -13,6 +13,7 @@ hostprogs-$(CONFIG_LOGO)         += pnmtologo
> >  hostprogs-$(CONFIG_VT)           += conmakehash
> >  hostprogs-$(CONFIG_IKCONFIG)     += bin2c
> >  hostprogs-$(BUILD_C_RECORDMCOUNT) += recordmcount
> > +hostprogs-$(BUILD_UPDATE_JUMP_LABEL) += update_jump_label
> >  
> >  always		:= $(hostprogs-y) $(hostprogs-m)
> >  
> > diff --git a/scripts/Makefile.build b/scripts/Makefile.build
> > index a0fd502..bc0d89b 100644
> > --- a/scripts/Makefile.build
> > +++ b/scripts/Makefile.build
> > @@ -258,6 +258,15 @@ cmd_modversions =								\
> >  	fi;
> >  endif
> >  
> > +ifdef BUILD_UPDATE_JUMP_LABEL
> > +update_jump_label_source := $(srctree)/scripts/update_jump_label.c \
> > +			$(srctree)/scripts/update_jump_label.h
> > +cmd_update_jump_label =						\
> > +	if [ $(@) != "scripts/mod/empty.o" ]; then		\
> > +		$(objtree)/scripts/update_jump_label "$(@)";	\
> > +	fi;
> > +endif
> > +
> >  ifdef CONFIG_FTRACE_MCOUNT_RECORD
> >  ifdef BUILD_C_RECORDMCOUNT
> >  ifeq ("$(origin RECORDMCOUNT_WARN)", "command line")
> > @@ -294,6 +303,7 @@ define rule_cc_o_c
> >  	$(cmd_modversions)						  \
> >  	$(call echo-cmd,record_mcount)					  \
> >  	$(cmd_record_mcount)						  \
> > +	$(cmd_update_jump_label)					  \
> >  	scripts/basic/fixdep $(depfile) $@ '$(call make-cmd,cc_o_c)' >    \
> >  	                                              $(dot-target).tmp;  \
> >  	rm -f $(depfile);						  \
> > @@ -301,13 +311,14 @@ define rule_cc_o_c
> >  endef
> >  
> >  # Built-in and composite module parts
> > -$(obj)/%.o: $(src)/%.c $(recordmcount_source) FORCE
> > +$(obj)/%.o: $(src)/%.c $(recordmcount_source) $(update_jump_label_source) FORCE
> >  	$(call cmd,force_checksrc)
> >  	$(call if_changed_rule,cc_o_c)
> >  
> >  # Single-part modules are special since we need to mark them in $(MODVERDIR)
> >  
> > -$(single-used-m): $(obj)/%.o: $(src)/%.c $(recordmcount_source) FORCE
> > +$(single-used-m): $(obj)/%.o: $(src)/%.c $(recordmcount_source) \
> > +		  $(update_jump_label_source) FORCE
> >  	$(call cmd,force_checksrc)
> >  	$(call if_changed_rule,cc_o_c)
> >  	@{ echo $(@:.o=.ko); echo $@; } > $(MODVERDIR)/$(@F:.o=.mod)
> > diff --git a/scripts/update_jump_label.c b/scripts/update_jump_label.c
> > new file mode 100644
> > index 0000000..86e17bc

> > +	/*
> > +	 * This is specific to x86. The jump_table is stored in three
> > +	 * long words. The first is the location of the jmp target we
> > +	 * must update.
> > +	 */
> > +	cnt = size / sizeof(uint_t);
> > +
> > +	for (i = 0; i < cnt; i += 3)
> > +		if (0)make_nop((void *)ehdr, *(uint_t *)(data + i * sizeof(uint_t)));
> > +
> 
> hmmmm, isn't this the line that actually writes in the no-ops? why isn't
> it disabled?


*DOH!*

Oh crap! I added that to dump more debug info. Let me make sure it
actually works ;)


> 
> > +	free(data);
> > +}
> > 
> > 
> 
> Thanks again for doing this...I was still understanding recordmcount.c ;)

And after this, I plan on giving recordmcount.c an overhaul so it is
easier to read. Right now it is written with lots of
micro-optimizations, with the sacrifice to simplicity. Modifying this
code is nasty, and it needs to be read by mere mortals.

I'll go and test with actual modifications and see if it still works.

-- Steve


