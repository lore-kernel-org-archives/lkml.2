Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665Ab0CRI4W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 04:56:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53858 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080Ab0CRI4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 04:56:19 -0400
Date: Thu, 18 Mar 2010 09:56:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>,
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
Message-ID: <20100318085607.GB2157@elte.hu>
References: <20100316112500.GA5337@elte.hu>
 <4B9F77E7.2060101@redhat.com>
 <20100316122903.GA8831@elte.hu>
 <4B9F7C6A.3070207@redhat.com>
 <20100316130840.GA24808@elte.hu>
 <4B9FBA8B.8020200@codemonkey.ws>
 <20100316173940.GA23859@elte.hu>
 <4BA00F1F.1090907@codemonkey.ws>
 <20100317081041.GC16374@elte.hu>
 <4BA1E24B.6090904@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA1E24B.6090904@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> On 03/17/2010 10:10 AM, Ingo Molnar wrote:
> >
> >> It's about who owns the user interface.
> >>
> >> If qemu owns the user interface, than we can satisfy this in a very 
> >> simple way by adding a perf monitor command.  If we have to support third 
> >> party tools, then it significantly complicates things.
> >
> > Of course illogical modularization complicates things 'significantly'.
> 
> Who should own the user interface then?

If qemu was in tools/kvm/ then we wouldnt have such issues. A single patch (or 
series of patches) could modify tools/kvm/, arch/x86/kvm/, virt/ and 
tools/perf/.

Numerous times did we have patches to kernel/perf_event.c that fixed some 
detail, also accompanied by a tools/perf/ patch fixing another detail. Having 
a single 'culture of contribution' is a powerful way to develop.

It turns out kernel developers can be pretty good user-space developers as 
well and user-space developers can be pretty good kernel developers as well. 
Some like to do both - as long as it's all within a single project.

The moment any change (be it as trivial as fixing a GUI detail or as complex 
as a new feature) involves two or more packages, development speed slows down 
to a crawl - while the complexity of the change might be very low!

Also, there's the harmful process that people start categorizing themselves 
into 'I am a kernel developer' and 'I am a user space programmer' stereotypes, 
which limits the scope of contributions artificially.

> > Fast forward to 2010. The kernel side of KVM is maximum goodness - by far 
> > the worst-quality remaining aspects of KVM are precisely in areas that you 
> > mention: 'if we have to support third party tools, then it significantly 
> > complicates things'. You kept Qemu as an external 'third party' entity to 
> > KVM, and KVM is clearly hurting from that - just see the recent KVM 
> > usability thread for examples about suckage.
> 
> Any qemu usability problems are because developers (or their employers) are 
> not interested in fixing them, not because of the repository location.  Most 
> kvm developer interest is in server-side deployment (even for desktop 
> guests), so there is limited effort in implementing a virtualbox-style GUI.

The same has been said of oprofile as well: 'it somewhat sucks because we are 
too server centric', 'nobody is interested in good usability and oprofile is 
fine for the enterprises'. Ironically, the same has been said of Xen usability 
as well, up to the point KVM came around.

What was the core of the problem was a bad design and a split kernel-side 
user-side tool landscape.

In fact i think saying that 'our developers only care about the server' is 
borderline dishonest, when at the same time you are making it doubly sure (by 
inaction) that it stays so: by leaving an artificial package wall between 
kernel-side KVM and user-side KVM and not integrating the two technologies.

You'll never know what heights you could achieve if you leave that wall there 
...

Furthermore, what should be realized is that bad usability hurts "server 
features" just as much. Most of the day-to-day testing is done on the desktop 
by desktop oriented testers/developers. _Not_ by enterprise shops - they tend 
to see the code years down the line to begin with ...

Yes, a particular feature might be server oriented, but a good portion of our 
testing is on the desktop and everyone is hurting from bad usability and this 
puts limits on contribution efficiency.

As the patch posted in _this very thread demonstrates it_, it is doubly more 
difficult to contribute a joint KVM+Qemu feature, because it's two separate 
code bases, two contribution guidelines, two release schedules. While to the 
user it really is just one and the same thing. It should be so for the 
developer as well.

Put in another way: KVM's current split design is making it easy to contribute 
server features (because the kernel side is clean and cool), but also makes it 
artificially hard to contribute desktop features: because the tooling side 
(Qemu) is 'just another package', is separated by a package and maintenance 
wall and is made somewhat uncool by a (as some KVM developers have pointed out 
in this thread) quirky codebase.

(the rest of your points are really a function of this fundamental 
disagreement)

Thanks,

	Ingo
