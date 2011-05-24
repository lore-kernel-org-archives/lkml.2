Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757167Ab1EXVQ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 17:16:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37199 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177Ab1EXVQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 17:16:56 -0400
Date: Tue, 24 May 2011 23:16:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: Tony Luck <tony.luck@gmail.com>, linux-kernel@vger.kernel.org,
        davej@redhat.com, kees.cook@canonical.com, davem@davemloft.net,
        eranian@google.com, torvalds@linux-foundation.org, adobriyan@gmail.com,
        penberg@kernel.org, hpa@zytor.com,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
Message-ID: <20110524211644.GJ27634@elte.hu>
References: <1306269105.21443.20.camel@dan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306269105.21443.20.camel@dan>
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

> Comments/Questions:
> 
> * Since RDRAND is relatively new, only the most recent version of
> binutils supports assembling it.  To avoid breaking builds for people
> who use older toolchains but want this feature, I hardcoded the opcodes.
> If anyone has a better approach, please let me know.

This is generally the best approach. Maybe mention it here:

> +	/* rdrand %eax */
> +	.byte	0x0f, 0xc7, 0xf0

... that this is done to work on older GAS as well. Putting that into 
changelogs is good, putting it into comments is better.

> * I chose to mimic the F00F bugfix behavior for moving the IDT, since it
> required very little code and has the additional benefit of making the
> IDT read-only. Ingo Molnar's suggestion of allocating per-cpu IDTs
> instead is still on the table, and I'd like to get feedback on this.

ok, good for an RFC patch.

> * In order to increase the entropy for the randomized base, I changed
> the default value of CONFIG_PHYSICAL_ALIGN back to 2mb.  It had
> previously been raised to 16mb as a hack so that relocatable kernels
> wouldn't load below that minimum.  I address this by changing the
> meaning of CONFIG_PHYSICAL_START such that it now represents a minimum
> address that relocatable kernels can be loaded at (rather than being
> ignored by relocatable kernels).  So, if a relocatable kernel determines
> it should be loaded at an address below CONFIG_PHYSICAL_START (which
> defaults to 16mb), I just bump it up.

This would need a real fix, right? The PHYSICAL_ALIGN hack looks worth fixing 
in its own right.

> * I would appreciate guidance on safe values for the highest addresses
> we can safely load the kernel at, on both 32-bit and 64-bit. This
> version uses 64mb (0x4000000) for 32-bit, and worked well in testing.

This depends on the memory map. In practice most x86 systems start with a big 
chunk of RAM up to end of RAM or 3GB, whichever comes first. Holes typically 
start at 3GB or higher.

On some systems holes can be pretty low as well - you'd have to research e820 
maps submitted to lkml to see how common this is - but it's not terribly 
common.

Some really old systems might have a hole between 15MB-16MB - but that's not an 
issue if we load at 16 MB or higher.

> * CONFIG_RANDOMIZE_BASE automatically sets the default value of kptr_restrict 
> and dmesg_restrict to 1, since it's nonsensical to use this without the other 
> two.  I considered removing CONFIG_SECURITY_DMESG_RESTRICT altogether (it 
> currently sets the default value for dmesg_restrict), but just in case 
> distros want to keep the CONFIG as a toggle switch but don't want to use 
> CONFIG_RANDOMIZE_BASE, I kept it around.  So, now CONFIG_RANDOMIZE_BASE sets 
> the default value for CONFIG_SECURITY_DMESG_RESTRICT.

No, the right solution is what i suggested a few mails ago: /proc/kallsyms (and 
other RIP printing places) should report the non-randomized RIP.

That way we do not have to change the kptr_restrict default and tools will 
continue to work ...

> * x86-64 is still "to-do". Because it calculates the kernel text address 
> twice, this may be a little trickier.

Note that 64-bit is obviously a must-have condition for the eventual acceptance 
of this patch.

> * Finding a middle ground instead of the current "all-or-nothing" behavior of 
> kptr_restrict that allows perf users to use this feature is future work.

Well, for perf we need to transform back the RIPs that get passed along in the 
stack-dump/call-chain code, see:

 arch/x86/kernel/dumpstack_64.c
 arch/x86/kernel/dumpstack.c
 arch/x86/kernel/dumpstack_32.c

That, combined with /proc/kallsyms unrandomization makes 'perf top' will just 
work and produce non-randomized RIPs.

The canonical RIP to report is the one that the kernel would have if it was 
loaded non-randomized.

> * Tested by repeatedly booting and observing kallsyms output on both i386.  
> Passed the "looks random to me" test, and saw no bad behavior. Tested that 
> changing CONFIG_PHYSICAL_ALIGN to 2mb still boots and runs fine on amd64.

Please run it over rngtest to measure how much true randomness is in it, on 
your testbox.

> * Is it worth bothering to look for alternate sources of entropy if
> RDTSC isn't available?

No, if you do the system-specific BIOS signature trick i think it's adequate.

> * Could use testing of CPU hotplugging and suspend/resume.

and kexec/crashdump. and perf ;-)

Thanks,

	Ingo
