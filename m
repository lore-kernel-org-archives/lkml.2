Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933064Ab1EMN3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 09:29:18 -0400
Received: from mx1.vsecurity.com ([209.67.252.12]:63856 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932345Ab1EMN3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 09:29:17 -0400
Subject: Re: [BUG] perf: bogus correlation of kernel symbols
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: linux-kernel@vger.kernel.org
Cc: davej@redhat.com, kees.cook@canonical.com, davem@davemloft.net,
        eranian@google.com, mingo@elte.hu, torvalds@linux-foundation.org,
        adobriyan@gmail.com, penberg@kernel.org
In-Reply-To: <1305292059.1949.0.camel@dan>
References: <1305292059.1949.0.camel@dan>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 May 2011 09:29:05 -0400
Message-ID: <1305293345.1949.22.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I would have appreciated a CC on this one, as the author of the feature
that got disabled.

> * Dave Jones <davej@redhat.com> wrote:
> 
> > On Thu, May 12, 2011 at 11:50:23PM +0200, Ingo Molnar wrote:
> >  
> >  > Dunno, i would not couple them necessarily - certain users might still have 
> >  > access to kernel symbols via some other channel - for example the System.map.
> >  
> > That always made this security by obscurity feature seem pointless for the bulk
> > of users to me. Given the majority are going to be running distro kernels,
> > anyone can find those addresses easily no matter how hard we hide them on the
> > running system.
> 
> I certainly agree and made that argument as well, in the original thread(s) 
> about /proc/kallsyms.
> 

I agree about the fact that kptr_restrict is an incomplete security
feature.  However, I disagree that it lacks usefulness entirely.
Virtually every public kernel exploit in the past year
leverages /proc/kallsyms or other kernel address leakage to target an
attack.  I'm not ignorant of the fact that it's trivial to fingerprint
distribution kernels in the absence of this information, but the reality
is, a huge portion of real life exploit attempts leverage pre-fabricated
exploits and are conducted by people who lack the ability to adjust
exploits to target a specific running kernel.  Even though this is
trivial to sidestep if you know what you're doing, this extra little
step may mean some script kiddie can't root some poor sysadmin's
machine, and that's a win.  In addition, when more powerful
randomization is hopefully introduced, blocking access to these pointers
will be more essential in preserving the lack of knowledge of the
location of kernel internals.

But this is all just for the record I suppose, since it seems that ship
has sailed.

> > Unless we were somehow introduced randomness into where we unpack the kernel 
> > each boot, and using System.map as a table of offsets instead of absolute 
> > addresses.
> 
> Correct. This security feature is IMO only solving a tiny fraction of the 
> problem and is thus in fact hindering the implementation of a *real* layer
> of protection of kernel absolute addresses:
> 
> The x86 kernel is relocatable, so slightly randomizing the position of the 
> kernel would be feasible with no overhead on the vast majority of exising 
> distro installs, with just an updated kernel.
> 
> When exposing randomized RIPs to user-space we could recalculate all RIPs back 
> to the 0xffffffff80000000 base, so oopses would have the usual non-randomized 
> form:
> 
> [   32.946003] IP: [<ffffffff80222521>] get_cur_val+0xcc/0x106
> [   32.946003] PGD 0 
> [   32.946003] Oops: 0002 [#1] SMP DEBUG_PAGEALLOC
> [   32.946003] last sysfs file: 
> [   32.946003] CPU 1 
> [   32.946003] Pid: 1, comm: swapper Tainted: G        W  2.6.29-rc1-00190-g37a76bd #10
> [   32.946003] RIP: 0010:[<ffffffff80222521>]  [<ffffffff80222521>] get_cur_val+0xcc/0x106
> [   32.946003] RSP: 0018:ffff88003f977b80  EFLAGS: 00010202
> [   32.946003] RAX: 0000000000000001 RBX: ffff8800029c8c80 RCX: 0000000000000008
> [   32.946003] RDX: 0000000000000000 RSI: ffffffff80ce0100 RDI: 0000000000000000
> [   32.946003] RBP: ffff88003f977bd0 R08: 0000000000000004 R09: 0000000000000040
> [   32.946003] R10: 0000000000000060 R11: 0000000081363fa8 R12: ffffffff81c4f0e0
> [   32.946003] R13: ffffffff80ce0100 R14: ffff88003c888a00 R15: 0000000000000000
> [   32.946003] FS:  0000000000000000(0000) GS:ffff88003f802c00(0000) knlGS:0000000000000000
> [   32.946003] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> [   32.946003] CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006e0
> [   32.946003] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   32.946003] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [   32.946003] Process swapper (pid: 1, threadinfo ffff88003f976000, task ffff88003f978000)
> [   32.946003] Stack:
> 
> Likewise, /proc/kallsyms could pass these addresses as well and the perf 
> call-chain code and other places that sample RIPs could easily convert them to 
> the constant address as well.
> 
> We'd still leak some information like the relative position of symbols from 
> each other (this can be useful to certain classes of attacks), but we could 
> pretty effectively hide the absolute location of the kernel - which is the most 
> valuable piece of information -.
> 
> Then the random base has to be protected: i.e. all information leaks of raw 
> kernel RIPs have to be plugged. The nice thing is that this will happen as 
> *bugfixes*: randomized RIPs will not be useful for anything, so any 
> tools/people who rely on them will notice it immediately.
> 
> I think *that* would be a maintainable and complete security feature to truly 
> hide the exact location of the kernel image. kptr_restrict is not.
> 

I want this feature, as I think it is far more useful and important.
This has been mentioned before, but no one has stepped up to actually do
it.  Unfortunately, I lack the necessary knowledge of the relevant code
to do it properly.  What's the best way to make this feature a reality?

Regards,
Dan


> Thanks,
> 
> 	Ingo


