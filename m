Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217Ab1EPPfw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 11:35:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60509 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755999Ab1EPPfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 11:35:51 -0400
Date: Mon, 16 May 2011 17:35:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: linux-kernel@vger.kernel.org, davej@redhat.com, kees.cook@canonical.com,
        davem@davemloft.net, eranian@google.com, torvalds@linux-foundation.org,
        adobriyan@gmail.com, penberg@kernel.org
Subject: Re: [BUG] perf: bogus correlation of kernel symbols
Message-ID: <20110516153527.GC21107@elte.hu>
References: <1305292059.1949.0.camel@dan>
 <1305293345.1949.22.camel@dan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305293345.1949.22.camel@dan>
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

> Hi all,
> 
> I would have appreciated a CC on this one, as the author of the feature
> that got disabled.

That's true and sorry about it: i could have sworn the author was Cc:-ed but 
confused you with Kees ...

> > * Dave Jones <davej@redhat.com> wrote:
> > 
> > > On Thu, May 12, 2011 at 11:50:23PM +0200, Ingo Molnar wrote:
> > >  
> > >  > Dunno, i would not couple them necessarily - certain users might still have 
> > >  > access to kernel symbols via some other channel - for example the System.map.
> > >  
> > > That always made this security by obscurity feature seem pointless for the bulk
> > > of users to me. Given the majority are going to be running distro kernels,
> > > anyone can find those addresses easily no matter how hard we hide them on the
> > > running system.
> > 
> > I certainly agree and made that argument as well, in the original thread(s) 
> > about /proc/kallsyms.
> 
> I agree about the fact that kptr_restrict is an incomplete security feature.  
> However, I disagree that it lacks usefulness entirely. Virtually every public 
> kernel exploit in the past year leverages /proc/kallsyms or other kernel 
> address leakage to target an attack.  I'm not ignorant of the fact that it's 
> trivial to fingerprint distribution kernels in the absence of this 
> information, but the reality is, a huge portion of real life exploit attempts 
> leverage pre-fabricated exploits and are conducted by people who lack the 
> ability to adjust exploits to target a specific running kernel.  Even though 
> this is trivial to sidestep if you know what you're doing, this extra little 
> step may mean some script kiddie can't root some poor sysadmin's machine, and 
> that's a win.  In addition, when more powerful randomization is hopefully 
> introduced, blocking access to these pointers will be more essential in 
> preserving the lack of knowledge of the location of kernel internals.

Well, but lets think it through further: what happens when we do such a change? 

 - Script kiddies get thwarted for a few weeks.

 - Script authors will laugh and will update their scripts to query rpmfind.net 
   or other package servers for symbol info.

 - After that transition all the exploits will continue to work. They might in 
   fact be more robust because they can specifically target only package 
   versions that are known to be exploitable.

 - *Useful* tools that do not try to harm the system will stay less useful 
   forever and that's permanent collateral damage.

I.e. we would have driven the development of *attack* tools to be even more 
harmful and will have hurt *useful* tools. Is this really what we want?

> But this is all just for the record I suppose, since it seems that ship has 
> sailed.

We can still revert the revert as well although indeed it is not very common.

> > > Unless we were somehow introduced randomness into where we unpack the kernel 
> > > each boot, and using System.map as a table of offsets instead of absolute 
> > > addresses.
> > 
> > Correct. This security feature is IMO only solving a tiny fraction of the 
> > problem and is thus in fact hindering the implementation of a *real* layer
> > of protection of kernel absolute addresses:
> > 
> > The x86 kernel is relocatable, so slightly randomizing the position of the 
> > kernel would be feasible with no overhead on the vast majority of exising 
> > distro installs, with just an updated kernel.
> > 
> > When exposing randomized RIPs to user-space we could recalculate all RIPs back 
> > to the 0xffffffff80000000 base, so oopses would have the usual non-randomized 
> > form:
> > 
> > [   32.946003] IP: [<ffffffff80222521>] get_cur_val+0xcc/0x106
> > [   32.946003] PGD 0 
> > [   32.946003] Oops: 0002 [#1] SMP DEBUG_PAGEALLOC
> > [   32.946003] last sysfs file: 
> > [   32.946003] CPU 1 
> > [   32.946003] Pid: 1, comm: swapper Tainted: G        W  2.6.29-rc1-00190-g37a76bd #10
> > [   32.946003] RIP: 0010:[<ffffffff80222521>]  [<ffffffff80222521>] get_cur_val+0xcc/0x106
> > [   32.946003] RSP: 0018:ffff88003f977b80  EFLAGS: 00010202
> > [   32.946003] RAX: 0000000000000001 RBX: ffff8800029c8c80 RCX: 0000000000000008
> > [   32.946003] RDX: 0000000000000000 RSI: ffffffff80ce0100 RDI: 0000000000000000
> > [   32.946003] RBP: ffff88003f977bd0 R08: 0000000000000004 R09: 0000000000000040
> > [   32.946003] R10: 0000000000000060 R11: 0000000081363fa8 R12: ffffffff81c4f0e0
> > [   32.946003] R13: ffffffff80ce0100 R14: ffff88003c888a00 R15: 0000000000000000
> > [   32.946003] FS:  0000000000000000(0000) GS:ffff88003f802c00(0000) knlGS:0000000000000000
> > [   32.946003] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> > [   32.946003] CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006e0
> > [   32.946003] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > [   32.946003] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > [   32.946003] Process swapper (pid: 1, threadinfo ffff88003f976000, task ffff88003f978000)
> > [   32.946003] Stack:
> > 
> > Likewise, /proc/kallsyms could pass these addresses as well and the perf 
> > call-chain code and other places that sample RIPs could easily convert them to 
> > the constant address as well.
> > 
> > We'd still leak some information like the relative position of symbols from 
> > each other (this can be useful to certain classes of attacks), but we could 
> > pretty effectively hide the absolute location of the kernel - which is the most 
> > valuable piece of information -.
> > 
> > Then the random base has to be protected: i.e. all information leaks of raw 
> > kernel RIPs have to be plugged. The nice thing is that this will happen as 
> > *bugfixes*: randomized RIPs will not be useful for anything, so any 
> > tools/people who rely on them will notice it immediately.
> > 
> > I think *that* would be a maintainable and complete security feature to truly 
> > hide the exact location of the kernel image. kptr_restrict is not.
> > 
> 
> I want this feature, as I think it is far more useful and important. This has 
> been mentioned before, but no one has stepped up to actually do it.  
> Unfortunately, I lack the necessary knowledge of the relevant code to do it 
> properly.  What's the best way to make this feature a reality?

Agreed, it would be a very useful feature.

I'd suggest to implement it along the lines of:

 - First check whether grsecurity or PAX has this implemented already via the
   relocation facility - they are pretty good at being paranoid so i'd be 
   surprised if they didnt think of this already! :-)

 - If not then have a look at CONFIG_RELOCATABLE and to relocate the kernel 
   binary intentionally via a hardcoded parameter. Just see whether you can do 
   it and whether it works as you expect it. Check /proc/kallsyms changing 
   after your patch. Enjoy the kernel still working ;-)

 - Then promote it to a boot parameter - this way you'll be able to tell 
   whether there's any hidden build-time assumptions about relocation position. 
   (there really shouldnt be any given that kexec works just fine - but i'd 
    suggest this step just in case.)

 - Then promote that hack to be a randomized parameter. Marvel at a different,
   randomized /proc/kallsyms output at every bootup and enjoy the still working 
   kernel!

 - Then look at all RIP outputs (thanks to your prior efforts they are now 
   mostly concentrated in the vprints code!) and reverse apply the random 
   offset before it's exported into user-space. wchan, etc. Marvel at the 
   constant /proc/kallsyms output, fully knowing that the *real* addresses
   are randomized.

 - Please do not forget to transfer perf RIPs and callchains and marvel at the
   well working 'perf top' output.

At that point the feature will be highly useful already IMO. Remaining work 
will be to think through and close down all remaining avenues of RIP leakage. 

At this point kptr_restrict will be a lot less relevant - the symbols will 
expose offsets (so it's not totally unhelpful to attackers) but not the real 
absolute addresses.

Unless i'm missing some particularly difficult roadblock, which is possible.

If you try this then please keep us posted at every step above, even if your 
patches are not fully working and useful yet. Maybe some other 
details/ideas/suggestions will arise at that point.

Thanks,

	Ingo
