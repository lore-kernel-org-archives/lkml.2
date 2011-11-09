Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881Ab1KIIZO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 03:25:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49689 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291Ab1KIIZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 03:25:12 -0500
Date: Wed, 9 Nov 2011 09:23:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Ted Ts'o" <tytso@mit.edu>, Anthony Liguori <anthony@codemonkey.ws>,
        Pekka Enberg <penberg@kernel.org>, Vince Weaver <vince@deater.net>,
        Avi Kivity <avi@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [F.A.Q.] the advantages of a shared tool/kernel Git repository,
 tools/perf/ and tools/kvm/
Message-ID: <20111109082321.GA11473@elte.hu>
References: <alpine.DEB.2.02.1111071156230.28615@pianoman.cluster.toy>
 <CAOJsxLEfapPPU8cEfeCMq9_oG6858YzFS_fkWQEo_fxs+xde9A@mail.gmail.com>
 <20111107203255.GF24234@thunk.org>
 <CAOJsxLEKx5M5L_N42pQpo2hcNhseQKhUo6CXAyQHesJRWFASKQ@mail.gmail.com>
 <4EB85969.2010108@codemonkey.ws>
 <12F471C8-2CF3-4CD7-B417-C8CC898669E6@mit.edu>
 <20111108093225.GB32533@elte.hu>
 <EDBAFB6F-4E3B-42B0-93E6-DF162B9859A6@mit.edu>
 <20111108125509.GB1022@elte.hu>
 <20111108163331.GJ24234@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111108163331.GJ24234@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Ted Ts'o <tytso@mit.edu> wrote:

> On Tue, Nov 08, 2011 at 01:55:09PM +0100, Ingo Molnar wrote:
>
> > I guess you can do well with a split project as well - my main 
> > claim is that good compatibility comes *naturally* with 
> > integration.
> 
> Here I have to disagree; my main worry is that integration makes it 
> *naturally* easy for people to skip the hard work needed to keep a 
> stable kernel/userspace interface.

There's two observations i have:

Firstly, how come that this has not actually happened in practice in 
the case of perf? Looks like the (random) version compatibility 
experiment i conducted yesterday should have failed spectacularly.

Secondly, within the kernel we don't have a stable ABI - we don't 
even have stable APIs, and still it's a 15 MLOC project that is 
thriving.

I argue that it is thriving in large part *BECAUSE* we don't have a 
stable API of any sort: if stuff is broken and the whole world needs 
to be fixed then we fix the whole world.

One could even make the argument that in the special case of deeply 
kernel integrated tools a stable kernel/userspace interface for those 
special, Linux-specific ABIs is *too expensive* and results in an 
inferior end result.

I'd really love it if people started thinking outside the box a bit. 
Why do people assume that *all* of the kernel project's code *has* to 
run in kernel mode? It's not a valid technical restriction *at all*.

"It has been done like this for 30 years" is not a valid technical 
restriction. Splitting deeply kernel related tools away from the 
kernel was a valid decision 15 years ago due to kernel image size and 
similar resource considerations. Today it's less and less true and we 
are *actively hurting* from tools being split away from the kernel 
proper.

Graphics, storage and user-space suspend are good examples i think of 
separation gone bad: and the resulting mess has cost Linux distros 
*the desktop market*. Think about it, the price we pay for this 
inferior end result is huge.

ext4tools is an example of separation gone good. I think it's the 
exception that strengthens the rule.

Why was the 2.4 to 2.6 migration so difficult? I can tell you the 
distro side story: mainly because the release took too long and tools 
broke left and right which created stop-ship situations. We had a 
much larger ABI cross section than we could sanely handle with the 
testing power we had. So we got into a negative feedback loop: the 
reduction in 2.3 testers further delayed the release, which moved the 
(independently evolving ...) tools further away from the to-be-2.6 
kernel, which further reduced the effective testing. It was not a 
sustainable. We addressed many of the problems by shortening the 
release cycle to 3 months, but IMHO we have not addressed the 
underlying problem of lack of integration.

Responsible release engineering is actually *easier* if you don't 
have a moving target and if you have the ability to fix stuff that 
breaks without being bound to an external project.

Deeply kernel integrated tools could come in the initrd and could be 
offered by the kernel, statically linked images made available via 
/proc/sbin or such. We could even swap them out on demand so there's 
no RAM overhead. There's no technical barrier.

I'd even argue that that C library is obviously something the kernel 
should offer as well - so klibc is the way to go and would help us 
further streamline this and keep Linux quality high.

We could actually keep the kernel and such tools tightly integrated, 
reducing the compatibility matrix. The kernel would upgrade with 
these tools but it *already* upgrades with some user-space components 
like the vdso so it's not a true technical barrier.

> The other worry which I've mentioned, but which I haven't seen 
> addressed, is that the even if you can use a perf from a newer 
> kernel with an older kernel, this causes distributions a huge 
> amount of pain, since they have to package two different kernel 
> source packages, and only compile perf from the newer kernel source 
> package.  This leads to all sorts of confusion from a distribution 
> packaging point of view.
> 
> For example, assume that RHEL 5, which is using 2.6.32 or something 
> like that, wants to use a newer e2fsck that does a better job 
> fixing file system corruptions. [...]

Firstly, it's not a big issue: if a tool comes with the kernel 
package then it's part of the regular backporting flow: if you 
backport a new tool to an old kernel then you do the same as if you 
backported a new kernel feature to an older enterprise kernel. 
Happens all the time, it's a technological problem with technological 
solutions. Enterprise distros explicitly do not support 
cross-distro-version package installs, so backporting will be done 
anyway.

Secondly, i actually think that the obsession with using obsolete 
kernel versions is silly technologically - and it has evolved that 
way partly *BECAUSE* we are not integrated enough and distros fear 
kernel upgrades because it had the bad habit of *breaking tools*.

The answer to that problem is to reduce the external cross section of 
the kernel and make sure that tools upgrade nicely together with the 
kernel - and integrating tools is a valid way to achieve that.

> > Did you consider it a possibility that out of tree projects that 
> > have deep ties to the kernel technically seem to be at a relative 
> > disadvantage to in-kernel projects because separation is 
> > technically costly with the costs of separation being larger than 
> > the advantages of separation?
> 
> As the e2fsprogs developer, I live with the costs all the time; I 
> can testify to the facy that they are very slight. [...]

Seriously, how can you tell that: you've never tried the integrated 
approach. I testified to the fact from the first hand experience of 
having tried both models of development.

> > But note that there are several OS projects that succeeded doing 
> > the equivalent of a 'whole world' single Git repo, so i don't 
> > think we have the basis to claim that it *cannot* work.
> 
> There have indeed, and there has speculation that this was one of 
> many contributions to why they lost out in the popularity and 
> adoption competition with Linux. [...]

I don't see Android having "lost out" in any way, do you? I actually 
see Android as being an obviously more successful approach to Linux 
on the desktop than anything else seen so far. We should at minimum 
stop and think about that fact, observe it, learn and adapt.

iOS also has not 'lost out' to Linux in any way.

> > But why do you have to think in absolutes and extremes all the 
> > time? Why not excercise some good case by case judgement about 
> > the merits of integration versus separation?
> 
> I agree that there are tradeoffs to both approaches, and I agree 
> that case by case judgement is something that should be done.  One 
> of the reasons why I've spent a lot of time pointing out the 
> downsides of integration and the shortcomings in the integration 
> position is that I've seen advocates claiming that the fact that 
> was perf was integrated was a precedent that meant that choice for 
> kvm-tool was something that should not be questioned since 
> tools/perf justified anything they wanted to do, and that if we 
> wanted to argue about whether kvm-tool should have been bundled 
> into the kernel, we should made different decisions about perf.

I don't think Pekka claimed 'anything goes' at all when he asked 
tools/kvm to be merged upstream - why are you using that strawman 
argument? He listed numerous valid technological reasons why they 
decided to work in the tools/kvm/ space and the results speak for 
themselves.

> [...] (Specifically, the reasoning goes that the need to package up 
> the kernel plus userspace meant that we had distributions in the 
> Linux ecosystem, and the competition kept everyone honest.  If one 
> distribution started making insane decisions, whether it's forcing 
> Unity on everyone, or forcing GNOME 3 on everyone, it's always 
> possible to switch to another distribution.  The *BSD systems 
> didn't have that safety valve....)

I don't think your argument makes much sense: how come Linux, a 15 
MLOC monster project running for 20 years has not been destroyed by 
the "lack of the safety valve" problem? Why would adding the at most 
1 MLOC deeply kernel related Linux tool and library space to the 
kernel repo affect the dynamics negatively? We added more code to the 
kernel last year alone.

Fact is, competition thrives within the Linux kernel as well. Why is 
a coherent, unified, focused project management an impediment to a 
good technological result? Especially when it comes to desktop 
computers / tablets / smartphones, where having a unified project is 
a *must*, so extreme are the requirements of users to get a coherent 
experience.

Think about this plain fact: there's not a single successful 
smartphone OS on the market that does not have unified project 
management. Yes, correlation is not causation and such, but still, 
think about it for a moment.

Thanks,

	Ingo
