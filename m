Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab0CUUbi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 16:31:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39697 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753261Ab0CUUbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 16:31:36 -0400
Date: Sun, 21 Mar 2010 21:31:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
Message-ID: <20100321203121.GA30194@elte.hu>
References: <4BA256FE.5080501@codemonkey.ws>
 <84144f021003180951s5207de16p1cdf4b9b04040222@mail.gmail.com>
 <20100318170223.GB9756@elte.hu>
 <4BA25E66.2050800@redhat.com>
 <20100318172805.GB26067@elte.hu>
 <4BA32E1A.2060703@redhat.com>
 <20100319085346.GG12576@elte.hu>
 <4BA3747F.60401@codemonkey.ws>
 <20100321191742.GD25922@elte.hu>
 <4BA67B2F.4030101@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA67B2F.4030101@redhat.com>
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


* Avi Kivity <avi@redhat.com> wrote:

> On 03/21/2010 09:17 PM, Ingo Molnar wrote:
> >
> > Adding any new daemon to an existing guest is a deployment and usability
> > nightmare.
> 
> The logical conclusion of that is that everything should be built into the 
> kernel. [...]

Only if you apply it as a totalitarian rule.

Furthermore, the logical conclusion of _your_ line of argument (applied in a 
totalitarian manner) is that 'nothing should be built into the kernel'.

I.e. you are arguing for microkernel Linux, while you see me as arguing for a 
monolithic kernel.

Reality is that we are somewhere inbetween, we are neither black nor white:
it's shades of grey.

If we want to do a good job with all this then we observe subsystems, we see 
how they relate to the physical world and decide about how to shape them. We 
identify long-term changes and re-design modularization boundaries in 
hindsight - when we got them wrong initially. We dont try to rationalize the 
status-quo.

Lets see one example of that thought process in action: Oprofile.

We saw that the modularization of oprofile was a total nightmare: a separate 
kernel-space and a separate user-space component, which was in constant 
version friction. The ABI between them was stiffling: it was hard to change it 
(you needed to trickle that through the tool as well which was on a different 
release schedule, etc.e tc.)

The result was sucky usability that never went beyond some basic 'you can do 
profiling' threshold. The subsystem worked well within that design box, and it 
was worked on by highly competent people - but it was still far, far away from 
the potential it could have achieved.

So we observed those problems and decided to do something about it:

 - We unified the two parts into a single maintenance domain. There's
   the kernel-side in kernel/perf_event.c and arch/*/*/perf_event.c,
   plus the user-side in tools/perf/. The two are connected by a very
   flexible, forwards and backwards compatible ABI.

 - We moved much more code into the kernel, realizing that transparent
   and robust instrumentation should be offered instead of punting
   abstractions into user-space (which is in a disadvantaged position
   to implement system-wide abstractions).

 - We created a no-bullsh*t approach to usability. perf is by no means 
   perfect, but it's written by developers for developers and if you report a 
   bug to us we'll act on it before anything else. Furthermore the kernel
   developers do the user-space coding as well, so there's no chinese
   wall separating them. Kernel-space becomes aware of the intricacies of
   user-space and user-space developers become aware of the difficulties of
   kernel-space as well. It's a good mix in our experience.

The thing is (and i doubt you are surprised that i say that), i see a similar 
situation with KVM. The basic parameters are comparable to Oprofile: it has a 
kernel-space component and a KVM-specific user-space. By all practical means 
the two are one and the same, but are maintained as different projects.

I have followed KVM since its inception with great interest. I saw its good 
initial design, i tried it early on and even wrote various patches for it. So 
i care more about KVM than a random observer would, but this preference and 
passion for KVM's good technical sides does not cloud my judgement when it 
comes to its weaknesses.

In fact the weaknesses are far more important to identify and express 
publicly, so i tend to concentrate on them. Dont take this as me blasting KVM, 
we both know the many good aspects of KVM.

So, as i explained it earlier in greater detail the modularization of KVM into 
a separate kernel-space and user-space component is one of its worst current 
weaknesses, and it has become the main stiffling force in the way of a better 
KVM experience to users.

That, IMO, is the 'weakest link' of KVM today and no matter how well the rest 
of KVM gets improved those nice bits all get unfairly ignored when the user 
cannot have a usable and good desktop experience and thinks that KVM is 
crappy.

I think you should think outside the initial design box you have created 4 
years ago, you should consider iterating the model and you should consider the 
alternative i suggested: move (or create) KVM tooling to tools/kvm/ and treat 
it as a single project from there on.

Thanks,

	Ingo
