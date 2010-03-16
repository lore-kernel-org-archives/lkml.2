Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966543Ab0CPRkO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 13:40:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43121 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933221Ab0CPRkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 13:40:12 -0400
Date: Tue, 16 Mar 2010 18:39:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Avi Kivity <avi@redhat.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?unknown-8bit?B?RnLDqWTDqXJpYw==?= Weisbecker 
	<fweisbec@gmail.com>
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from
 host side
Message-ID: <20100316173940.GA23859@elte.hu>
References: <20100316102052.GC10069@elte.hu>
 <4B9F603B.4080004@redhat.com>
 <20100316105021.GA14344@elte.hu>
 <4B9F671D.5060001@redhat.com>
 <20100316112500.GA5337@elte.hu>
 <4B9F77E7.2060101@redhat.com>
 <20100316122903.GA8831@elte.hu>
 <4B9F7C6A.3070207@redhat.com>
 <20100316130840.GA24808@elte.hu>
 <4B9FBA8B.8020200@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B9FBA8B.8020200@codemonkey.ws>
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


* Anthony Liguori <anthony@codemonkey.ws> wrote:

> On 03/16/2010 08:08 AM, Ingo Molnar wrote:
> >* Avi Kivity<avi@redhat.com>  wrote:
> >
> >>On 03/16/2010 02:29 PM, Ingo Molnar wrote:
> >>>I mean, i can trust a kernel service and i can trust /proc/kallsyms.
> >>>
> >>>Can perf trust a random process claiming to be Qemu? What's the trust
> >>>mechanism here?
> >>Obviously you can't trust anything you get from a guest, no matter how you
> >>get it.
> >I'm not talking about the symbol strings and addresses, and the object
> >contents for allocation (or debuginfo). I'm talking about the basic protocol
> >of establishing which guest is which.
> >
> >I.e. we really want to be able users to:
> >
> >  1) have it all working with a single guest, without having to specify 'which'
> >     guest (qemu PID) to work with. That is the dominant usecase both for
> >     developers and for a fair portion of testers.
> 
> You're making too many assumptions.
> 
> There is no list of guests anymore than there is a list of web browsers.
> 
> You can have a multi-tenant scenario where you have distinct groups of 
> virtual machines running as unprivileged users.

"multi-tenant" and groups is not a valid excuse at all for giving crappy 
technology in the simplest case: when there's a single VM. Yes, eventually it 
can be supported and any sane scheme will naturally support it too, but it's 
by no means what we care about primarily when it comes to these tools.

I thought everyone learned the lesson behind SystemTap's failure (and to a 
certain degree this was behind Oprofile's failure as well): when it comes to 
tooling/instrumentation we dont want to concentrate on the fancy complex 
setups and abstract requirements drawn up by CIOs, as development isnt being 
done there. Concentrate on our developers today, and provide no-compromises 
usability to those who contribute stuff.

If we dont help make the simplest (and most common) use-case convenient then 
we are failing on a fundamental level.

> >  2) Have some reasonable symbolic identification for guests. For example a
> >     usable approach would be to have 'perf kvm list', which would list all
> >     currently active guests:
> >
> >      $ perf kvm list
> >        [1] Fedora
> >        [2] OpenSuse
> >        [3] Windows-XP
> >        [4] Windows-7
> >
> >     And from that point on 'perf kvm -g OpenSuse record' would do the obvious
> >     thing. Users will be able to just use the 'OpenSuse' symbolic name for
> >     that guest, even if the guest got restarted and switched its main PID.
> 
> Does "perf kvm list" always run as root?  What if two unprivileged users 
> both have a VM named "Fedora"?

Again, the single-VM case is the most important case, by far. If you have 
multiple VMs running and want to develop the kernel on multiple VMs (sounds 
rather messy if you think it through ...), what would happen is similar to 
what happens when we have two probes for example:

 # perf probe schedule
 Added new event:
   probe:schedule                           (on schedule+0)

 You can now use it on all perf tools, such as:

 	perf record -e probe:schedule -a sleep 1

 # perf probe -f schedule   
 Added new event:
   probe:schedule_1                         (on schedule+0)

 You can now use it on all perf tools, such as:

 	perf record -e probe:schedule_1 -a sleep 1

 # perf probe -f schedule
 Added new event:
   probe:schedule_2                         (on schedule+0)

 You can now use it on all perf tools, such as:

 	perf record -e probe:schedule_2 -a sleep 1

Something similar could be used for KVM/Qemu: whichever got created first is 
named 'Fedora', the second is named 'Fedora-2'.

> If we look at the use-case, it's going to be something like, a user is 
> creating virtual machines and wants to get performance information about 
> them.
> 
> Having to run a separate tool like perf is not going to be what they would 
> expect they had to do.  Instead, they would either use their existing GUI 
> tool (like virt-manager) or they would use their management interface 
> (either QMP or libvirt).
> 
> The complexity of interaction is due to the fact that perf shouldn't be a 
> stand alone tool.  It should be a library or something with a programmatic 
> interface that another tool can make use of.

But ... a GUI interface/integration is of course possible too, and it's being 
worked on.

perf is mainly a kernel developer tool, and kernel developers generally dont 
use GUIs to do their stuff: which is the (sole) reason why its first ~850 
commits of tools/perf/ were done without a GUI. We go where our developers 
are.

In any case it's not an excuse to have no proper command-line tooling. In fact 
if you cannot get simpler, more atomic command-line tooling right then you'll 
probably doubly suck at doing a GUI as well.

	Ingo
