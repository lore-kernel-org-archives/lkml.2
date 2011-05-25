Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932862Ab1EYOVE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 10:21:04 -0400
Received: from mx1.vsecurity.com ([209.67.252.12]:64743 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932176Ab1EYOVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 10:21:02 -0400
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tony Luck <tony.luck@gmail.com>, linux-kernel@vger.kernel.org,
        davej@redhat.com, kees.cook@canonical.com, davem@davemloft.net,
        eranian@google.com, torvalds@linux-foundation.org, adobriyan@gmail.com,
        penberg@kernel.org, hpa@zytor.com,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu
In-Reply-To: <20110525112339.GC30983@elte.hu>
References: <1306269105.21443.20.camel@dan> <20110524211644.GJ27634@elte.hu>
	 <1306278038.1921.5.camel@dan>  <20110525112339.GC30983@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 May 2011 10:20:51 -0400
Message-ID: <1306333251.2211.22.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-25 at 13:23 +0200, Ingo Molnar wrote:
> * Dan Rosenberg <drosenberg@vsecurity.com> wrote:
> 
> > > No, the right solution is what i suggested a few mails ago: 
> > > /proc/kallsyms (and other RIP printing places) should report the 
> > > non-randomized RIP.
> > > 
> > > That way we do not have to change the kptr_restrict default and 
> > > tools will continue to work ...
> > 
> > Ok, I'll do it this way, and leave the kptr_restrict default to 0.  
> > But I still think having the dmesg_restrict default depend on 
> > randomization makes sense, since kernel .text is explicitly 
> > revealed in the syslog.
> 
> Hm, where is it revealed beyond intcall addresses, which ought to be 
> handled if they are printed via %pK?
> 
> All such information leaks need to be fixed. (This will be the 
> slowest part of the process i suspect - there's many channels.)
> 
> in the syslog we obviously want any RIPs converted to the canonical 
> 'unrandomized' address, so that it can be matched against 
> /proc/kallsyms, etc. Their randomized value isnt very useful. That 
> will also protect the randomization secret as a side effect.
> 

%pK doesn't seem like the right thing to do in many cases, since the
capability check doesn't have proper meaning if the caller isn't in
process context.  If I'm understanding you right (correct if I'm wrong),
you're looking for kptr_restrict to be completely separate from this
randomization, and when randomization is enabled, all pointers are
unconditionally de-randomized.  It seems like the right way to do this
is to include code in vsprintf.c for all %p-type specifiers that would
normally print the actual pointer (as opposed to some of the specialized
cases that print other data) that does something like this:

if((unsigned long)ptr >= (unsigned long)_stext &&
   (unsigned long)ptr <= (unsigned long)_end)
	ptr -= (_text - (CONFIG_PHYSICAL_START + PAGE_OFFSET));

This way, we don't have to go tracking down every printk caller and
convert them to %pK, which isn't usable anyway in some cases.

> The only thorny issue AFAICS are oopses. There's real value in having 
> 'raw' data from a crash (interpreting crashes is hard enough even 
> without randomization!), OTOH we could keep most of the value of them 
> by converting them back to canonical addresses.
> 
> This would be more or less easy to do for the RIP and the registers, 
> but less obvious for the stack: a kernel pointer can lie on the stack 
> at arbitrary alignment. On 64-bit we could probably detect them 
> rather reliably based on the randomized prefix of kernel addresses:
> 
> [   32.946003] Stack:
> [   32.946003]  0000000000000202 0000000000000002 0000000000000001 0000000000000000
> [   32.946003]  0000000000000198 0000000000000002 0000000000000000 00000000002ca5b0
> [   32.946003]  0000000000000000 ffff88003e5533e0 ffff88003f977c00 ffffffff802225e3
> 
> the ffffffff8 prefix (assuming we end up randomizing the address 
> within the 2GB window available to a RIP-relative addressed kernel) 
> would be easy to detect even if it's not word aligned. There *would* 
> be false positives (a 32-bit value of -7 is common), but as long as 
> we marked any unrandomization clearly with an asterix:
> 
> [   32.946003] Stack:
> [   32.946003]  0000000000000202 0000000000000002 0000000000000001 0000000000000000
> [   32.946003]  0000000000000198 0000000000000002 0000000000000000 00000000002ca5b0
> [   32.946003]  0000000000000000*ffff88003e5533e0*ffff88003f977c00*ffffffff802225e3
> 
> we'd be informed that the stack content was slighly different. If we 
> fixed up register values, say the raw value is:
> 
> [   32.946003] RDX: 0000000000000000 RSI: ffffffff80ce0100 RDI: 0000000000000000
> 
> and randomization is -0x100000 then we'd print the normalized value 
> for 'RSI':
> 
> [   32.946003] RDX: 0000000000000000 RSI:*ffffffff80de0100 RDI: 0000000000000000
> 
> And the '*' tells us that this value got normalized.
> 
> On 32-bit systems the rate of false positive is probably higher, he 
> '0xc0' byte pattern is pretty common.
> 
> Now, theoretically there's still a tiny information hole here: if an 
> attacker can crash a kernel in a non-fatal way that puts some known 
> data on the kernel stack, then the unrandomization will reveal the 
> secret ...
> 
> I guess we'll have to live with that: really paranoid places will 
> disable dmesg access to unprivileged users.

I'm tempted to just say "leave OOPS alone", and if you want to preserve
secrecy past an OOPS, you should be disabling dmesg access anyway.  But
I'll think more about this.

> 
> [ They might also want to have a knob to not log kernel crashes at 
>   all - best protection is if *no one* (not even root) has a way to 
>   figure out the secret. That needs to go hand in hand with forced 
>   use of signed modules, sanitized /dev/mem, no root-controllable DMA 
>   access to any device, no ioperm() and iopl(), etc. - so a very 
>   locked down kernel that protects even root from being able to 
>   execute kernel code. Such systems are still useful btw even if root 
>   otherwise has access to all disks and has access to the kernel 
>   image and can install its own image: a reboot will generally set 
>   off an alarm. ]
> 
> > Thanks very much for the feedback.
> 
> Hey, thanks for taking up on implementing this rather non-trivial 
> security feature!
> 

What can I say, I like a challenge. :)

-Dan

> Thanks,
> 
> 	Ingo


