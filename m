Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab1EYLX7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 07:23:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47404 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755256Ab1EYLX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 07:23:56 -0400
Date: Wed, 25 May 2011 13:23:39 +0200
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
Message-ID: <20110525112339.GC30983@elte.hu>
References: <1306269105.21443.20.camel@dan>
 <20110524211644.GJ27634@elte.hu>
 <1306278038.1921.5.camel@dan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306278038.1921.5.camel@dan>
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

> > No, the right solution is what i suggested a few mails ago: 
> > /proc/kallsyms (and other RIP printing places) should report the 
> > non-randomized RIP.
> > 
> > That way we do not have to change the kptr_restrict default and 
> > tools will continue to work ...
> 
> Ok, I'll do it this way, and leave the kptr_restrict default to 0.  
> But I still think having the dmesg_restrict default depend on 
> randomization makes sense, since kernel .text is explicitly 
> revealed in the syslog.

Hm, where is it revealed beyond intcall addresses, which ought to be 
handled if they are printed via %pK?

All such information leaks need to be fixed. (This will be the 
slowest part of the process i suspect - there's many channels.)

in the syslog we obviously want any RIPs converted to the canonical 
'unrandomized' address, so that it can be matched against 
/proc/kallsyms, etc. Their randomized value isnt very useful. That 
will also protect the randomization secret as a side effect.

The only thorny issue AFAICS are oopses. There's real value in having 
'raw' data from a crash (interpreting crashes is hard enough even 
without randomization!), OTOH we could keep most of the value of them 
by converting them back to canonical addresses.

This would be more or less easy to do for the RIP and the registers, 
but less obvious for the stack: a kernel pointer can lie on the stack 
at arbitrary alignment. On 64-bit we could probably detect them 
rather reliably based on the randomized prefix of kernel addresses:

[   32.946003] Stack:
[   32.946003]  0000000000000202 0000000000000002 0000000000000001 0000000000000000
[   32.946003]  0000000000000198 0000000000000002 0000000000000000 00000000002ca5b0
[   32.946003]  0000000000000000 ffff88003e5533e0 ffff88003f977c00 ffffffff802225e3

the ffffffff8 prefix (assuming we end up randomizing the address 
within the 2GB window available to a RIP-relative addressed kernel) 
would be easy to detect even if it's not word aligned. There *would* 
be false positives (a 32-bit value of -7 is common), but as long as 
we marked any unrandomization clearly with an asterix:

[   32.946003] Stack:
[   32.946003]  0000000000000202 0000000000000002 0000000000000001 0000000000000000
[   32.946003]  0000000000000198 0000000000000002 0000000000000000 00000000002ca5b0
[   32.946003]  0000000000000000*ffff88003e5533e0*ffff88003f977c00*ffffffff802225e3

we'd be informed that the stack content was slighly different. If we 
fixed up register values, say the raw value is:

[   32.946003] RDX: 0000000000000000 RSI: ffffffff80ce0100 RDI: 0000000000000000

and randomization is -0x100000 then we'd print the normalized value 
for 'RSI':

[   32.946003] RDX: 0000000000000000 RSI:*ffffffff80de0100 RDI: 0000000000000000

And the '*' tells us that this value got normalized.

On 32-bit systems the rate of false positive is probably higher, he 
'0xc0' byte pattern is pretty common.

Now, theoretically there's still a tiny information hole here: if an 
attacker can crash a kernel in a non-fatal way that puts some known 
data on the kernel stack, then the unrandomization will reveal the 
secret ...

I guess we'll have to live with that: really paranoid places will 
disable dmesg access to unprivileged users.

[ They might also want to have a knob to not log kernel crashes at 
  all - best protection is if *no one* (not even root) has a way to 
  figure out the secret. That needs to go hand in hand with forced 
  use of signed modules, sanitized /dev/mem, no root-controllable DMA 
  access to any device, no ioperm() and iopl(), etc. - so a very 
  locked down kernel that protects even root from being able to 
  execute kernel code. Such systems are still useful btw even if root 
  otherwise has access to all disks and has access to the kernel 
  image and can install its own image: a reboot will generally set 
  off an alarm. ]

> Thanks very much for the feedback.

Hey, thanks for taking up on implementing this rather non-trivial 
security feature!

Thanks,

	Ingo
