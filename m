Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab0CVUGh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 16:06:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59878 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259Ab0CVUGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 16:06:35 -0400
Date: Mon, 22 Mar 2010 21:06:17 +0100
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
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
Message-ID: <20100322200617.GD3306@elte.hu>
References: <20100322143212.GE14201@elte.hu>
 <4BA7821C.7090900@codemonkey.ws>
 <20100322155505.GA18796@elte.hu>
 <4BA796DF.7090005@redhat.com>
 <20100322165107.GD18796@elte.hu>
 <4BA7A406.9050203@redhat.com>
 <20100322173400.GB15795@elte.hu>
 <4BA7AF2D.7060306@redhat.com>
 <20100322192033.GC21919@elte.hu>
 <4BA7C885.5010901@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA7C885.5010901@redhat.com>
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

> On 03/22/2010 09:20 PM, Ingo Molnar wrote:
> >* Avi Kivity<avi@redhat.com>  wrote:
> >
> >>>Lets look at the ${HOME}/.qemu/qmp/ enumeration method suggested by
> >>>Anthony. There's numerous ways that this can break:
> >>I don't like it either.  We have libvirt for enumerating guests.
> >Which has pretty much the same problems to the ${HOME}/.qemu/qmp/ solution,
> >obviously.
> 
> It doesn't follow.  The libvirt daemon could/should own guests from all 
> users.  I don't know if it does so now, but nothing is preventing it 
> technically.

It's hard for me to argue against a hypothetical implementation, but all 
user-space driven solutions for resource enumeration i've seen so far had 
weaknesses that kernel-based solutions dont have.

> >>>  - Those special files can get corrupted, mis-setup, get out of sync, or can
> >>>    be hard to discover.
> >>>
> >>>  - The ${HOME}/.qemu/qmp/ solution suggested by Anthony has a very obvious
> >>>    design flaw: it is per user. When i'm root i'd like to query _all_ current
> >>>    guest images, not just the ones started by root. A system might not even
> >>>    have a notion of '${HOME}'.
> >>>
> >>>  - Apps might start KVM vcpu instances without adhering to the
> >>>    ${HOME}/.qemu/qmp/ access method.
> >>- it doesn't work with nfs.
> >So out of a list of 4 disadvantages your reply is that you agree with 3?
> 
> I agree with 1-3, disagree with 4, and add 5.  Yes.
> 
> >>>  - There is no guarantee for the Qemu process to reply to a request - while
> >>>    the kernel can always guarantee an enumeration result. I dont want 'perf
> >>>    kvm' to hang or misbehave just because Qemu has hung.
> >>If qemu doesn't reply, your guest is dead anyway.
> >Erm, but i'm talking about a dead tool here. There's a world of a difference
> >between 'kvm top' not showing new entries (because the guest is dead), and
> >'perf kvm top' hanging due to Qemu hanging.
> 
> If qemu hangs, the guest hangs a few milliseconds later.

I think you didnt understand my point. I am talking about 'perf kvm top' 
hanging if Qemu hangs.

With a proper in-kernel enumeration the kernel would always guarantee the 
functionality, even if the vcpu does not make progress (i.e. it's "hung").

With this implemented in Qemu we lose that kind of robustness guarantee.

And especially during development (when developers use instrumentation the 
most) is it important to have robust instrumentation that does not hang along 
with the Qemu process.

> If qemu fails, you lose your guest.  If libvirt forgets about a
> guest, you can't do anything with it any more.  These are more
> serious problems than 'perf kvm' not working. [...]

How on earth can you justify a bug ("perf kvm top" hanging) with that there 
are other bugs as well?

Basically you are arguing the equivalent that a gdb session would be fine to 
become unresponsive if the debugged task hangs. Fortunately ptrace is 
kernel-based and it never 'hangs' if the user-space process hangs somewhere.

This is an essential property of good instrumentation.

So the enumeration method you suggested is a poor, sub-part solution, simple 
as that.

> [...] Qemu and libvirt have to be robust anyway, we can rely on them.  Like 
> we have to rely on init, X, sshd, and a zillion other critical tools.

We can still profile any of those tools without the profiler breaking if the 
debugged tool breaks ...

> > By your argument it would be perfectly fine to implement /proc purely via 
> > user-space, correct?
> 
> I would have preferred /proc to be implemented via syscalls called directly 
> from tools, and good tools written to expose the information in it.  When 
> computers were slower 'top' would spend tons of time opening and closing all 
> those tiny files and parsing them.  Of course the kernel needs to provide 
> the information.

(Then you'll be enjoyed to hear that perf has enabled exactly that, and that we 
are working towards that precise usecase.)

	Ingo
