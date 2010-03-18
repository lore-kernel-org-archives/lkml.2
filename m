Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab0CRUr0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 16:47:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60374 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204Ab0CRUrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 16:47:25 -0400
Date: Thu, 18 Mar 2010 21:47:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Avi Kivity <avi@redhat.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
Message-ID: <20100318204710.GA4821@elte.hu>
References: <20100316130840.GA24808@elte.hu>
 <4B9FBA8B.8020200@codemonkey.ws>
 <20100316173940.GA23859@elte.hu>
 <4BA00F1F.1090907@codemonkey.ws>
 <20100317081041.GC16374@elte.hu>
 <4BA1E24B.6090904@redhat.com>
 <20100318092232.GC2157@elte.hu>
 <4BA20153.5060409@redhat.com>
 <20100318182048.GC5103@nowhere>
 <y0mk4t9xvci.fsf@fche.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <y0mk4t9xvci.fsf@fche.csb>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frank Ch. Eigler <fche@redhat.com> wrote:

> Frederic Weisbecker <fweisbec@gmail.com> writes:
> 
> > [...]  It is actually because both kernel and user side are sync in this 
> > scheme.  [...]
> 
> This argues that co-evolution of an interface is easiest on the developers 
> if they own both sides of that interface.  No quarrel.

Correct, that's a big advantage.

> This does not argue that that the preservation of a stable ABI is best done 
> this way.  If anything, it makes it too easy to change both the provider and 
> the preferred user of the interface without noticing unintentional breakage 
> to forlorn out-of-your-tree clients.

Your concern is valid, and this issue has been raised in the past as one of 
the main counter-arguments against tools/perf/. (there was a big flamewar 
about it on lkml when it was introduced)

Our roughly 1 year experience with perf is that, somewhat pradoxially, this 
scheme not only works as well as classic ABI schemes but actually brings a 
_better_ ABI than the classic "let the kernel define an ABI" single-sided 
solution.

I know the difference first hand, i've written various syscalls ABIs in the 
past 10+ years before perf and know how they interact with their user space 
counterparts.

Why did it work out better with tools/perf/? It turns out that there's an 
immediate, direct, actionable test feedback effect on the ABI, and much closer 
relation to the ABI. Typically the same developer implements the kernel bits 
and the user-space bits (because it's so easy to do co-development), so the 
ABI aspects are ingrained in the developer much more deeply. Once you see the 
kind of havoc ABI breakage can cause during development you avoid it in the 
future.

So developers find that a good, stable ABI helps development. It turns out 
that developers dont actually _want_ to break the ABI and are careful about it 
- and having the app next to the kernel ABI and co-developing it makes it sure 
there's never any true mismatch.

Also, we can do ABI improvements at a far higher rate than any other kernel 
subsystem. I checked the git logs, we've done over three dozen ABI extensions 
since the first version, and all were forwards _and_ backwards compatible.

A higher rate of change gives developers more experience and lets them do a 
better ABI, and makes them more ABI-conscious. I think if all kernel ABIs had 
such a healthy rate of change we'd fill in all the missing kernel features 
very quickly.

With detached packages ABI features are often done by a kernel developer (who 
is familar with the kernel subsystem in question) and a separate user-space 
developer (who is familar with the user-space project in question), and the 
ABI consciousness is less strong.

So you are right that there's a danger of accidental ABI breakage, but it's 
not an issue in practice. There are external apps making use of the ABI as 
well, not just tools/perf/.

In a more abstract sense this is kind of a classic case of game theory: that a 
assume-trust strategy pays off in the long run.

Thanks,

	Ingo
