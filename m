Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab1E0HPq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 03:15:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51521 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274Ab1E0HPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 03:15:45 -0400
Date: Fri, 27 May 2011 09:15:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: Tony Luck <tony.luck@gmail.com>, linux-kernel@vger.kernel.org,
        kees.cook@canonical.com, davej@redhat.com,
        torvalds@linux-foundation.org, adobriyan@gmail.com, eranian@google.com,
        penberg@kernel.org, davem@davemloft.net,
        Arjan van de Ven <arjan@infradead.org>, hpa@zytor.com,
        Valdis.Kletnieks@vt.edu, Andrew Morton <akpm@linux-foundation.org>,
        pageexec@freemail.hu, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
Message-ID: <20110527071519.GD9260@elte.hu>
References: <1306269105.21443.20.camel@dan>
 <1306442367.2279.25.camel@dan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306442367.2279.25.camel@dan>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dan Rosenberg <drosenberg@vsecurity.com> wrote:

> 5. I'll be switching to per-cpu IDTs, basing my work on the 
> following patch:
> 
> http://marc.info/?l=linux-kernel&m=112767117501231&w=2
> 
> Any review or comments on the above patch would be helpful.  I'm 
> considering submitting this portion separately, as it may provide 
> performance and scalability benefits regardless of randomization.

Yeah.

Note that you do not have to do the MSI thing in Zwane's patch, nor 
do i think do you need to touch the boot IDT, but instead go for the 
easiest route:

There are two main places that set up the IDT:

  trap_init();
  init_IRQ()

The IDT is fully set up at this point and i don't think we change it 
later on. So all the fancy changes to set_intr_gate() et al in 
Zwane's patch seem unnecessary to me.

Most of the complexity Zwane's patch has comes from the fact that he 
tries to use per CPU IDTs to create *assymetric* IDTs between CPUs - 
but we do not want nor need to do that with your patch, which 
simplifies things enormously.

Note that both of the above init functions execute only on the boot 
CPU, well before SMP is initialized. So it is an easy environment to 
work in from an IDT switcheroo POV and we should be able to switch to 
the percpu IDT there without much fuss.

Note that setup_per_cpu_areas() is called well before trap_init(), so 
at the end of init_IRQ() you can rely on percpu facilities such as 
percpu_alloc() as well.

I'd suggest these rough steps to implement it:

 - turn off CONFIG_SMP in the .config

 - first add the new init function call to the end of arch/x86/'s 
   init_IRQ(), put the percpu_alloc() into that function, copy
   the old IDT into the new IDT (but do not load it!) and boot test 
   the patch.

   At this point you wont have any change to the IDT yet, but you
   have tested all the boot CPU init order assumptions: is 
   percpu_alloc() really available, did you do the copying right, 
   etc. You might want to print-dump the new IDT in hexdump format
   and check whether it looks like an IDT you'd like the CPU to load.

 - then add the one extra line that loads the new IDT into the CPU.

   If the kernel does not crash then you will have a randomized UP
   kernel that does not leak the randomization secret to user-space 
   via the SIDT instructon. Test this in user-space, marvel at the
   non-kernel-image address you get! :-)

 - turn on CONFIG_SMP=y and boot the kernel.

   The kernel should not crash: you will have the boot CPU with
   the percpu IDT, and all secondary CPUs with the bootup IDT
   still referenced. Check via your user-space SIDT test-code
   and:

             taskset 0 ./test-sidt
             taskset 1 ./test-sidt
             taskset 2 ./test-sidt

   That indeed CPU#0 has a different IDT address from all the other
   CPUs. Marvel at the incomplete but still fully working IDT setup! 
   :-)

 - Figure out where a new secondary CPU loads the boot IDT. Figure 
   out where it sets up its percpu area. Find the spot where both
   facilities are available already and add the percpu_alloc()+copy 
   routine to it. Do the hex printout and boot the kernel - do the 
   dumped IDTs look sane visually?

 - If they looked fine then add the one extra line that loads the
   new IDT into the secondary CPU(s). Boot and check the IDTs:

             taskset 0 ./test-sidt
             taskset 1 ./test-sidt
             taskset 2 ./test-sidt

   Now you should have different results on all different CPUs!
   Marvel at having completed the patch!

 - Please check whether the IDT has alignment requirements: we could 
   actually benefit from coloring the percpu IDTs a bit, as each 
   hyperthread (and core) has a separate IDT so we can spread out any 
   cache and RAM accesses a bit better amongst the cache/memory 
   ports.

 - Please check how fast SIDT is, how many cycles does it take? If 
   it's faster than CPUID then you have also created another nice 
   scalability feature: a user-space instruction that emits the 
   current CPU ID! [we could encode the CPU ID in the address - this 
   will also give us the cache coloring.]

Note that using the percpu area will also avoid the 4K mapping TLB 
problem Linus referred to: the percpu area is mapped in a 2MB data 
TLB.

What this stage wont allow yet is a read-only IDT. That should be yet 
another patch on top of this: the percpu IDT will already allow the 
protection of the kernel image randomization secret.

The read-only IDT will bring in the 4K TLB cost but maybe that's 
acceptable (because the security advantages of a read-only IDT are 
real). It will be a relatively easy patch on top of the percpu IDT 
patch: where you load the percpu IDT into the CPU with the LIDT 
instruction, you'd first fixmap it into a readonly page:

	__set_fixmap(FIX_IDT, __pa(percpu_idt_ptr), PAGE_KERNEL_RO);

And use __fix_to_virt(FIX_IDT) as the load_IDT() address.

If you do it as two patches on top of each other i'll try to figure 
out a way to measure the performance impact of the readonly IDT via 
perf. It won't be easy as the expected effect is very, very small.

Thanks,

	Ingo
