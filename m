Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966234Ab0CPS2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 14:28:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38385 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753321Ab0CPS2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 14:28:19 -0400
Date: Tue, 16 Mar 2010 19:28:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Anthony Liguori <aliguori@linux.vnet.ibm.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, Avi Kivity <avi@redhat.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from
 host side
Message-ID: <20100316182809.GA26602@elte.hu>
References: <20100316122903.GA8831@elte.hu>
 <4B9F7C6A.3070207@redhat.com>
 <20100316130840.GA24808@elte.hu>
 <4B9F84C0.70706@redhat.com>
 <20100316133114.GB575@elte.hu>
 <y0mbpeo1f1y.fsf@fche.csb>
 <20100316155221.GA19699@elte.hu>
 <4B9FC11A.1070507@linux.vnet.ibm.com>
 <20100316175243.GC23859@elte.hu>
 <4B9FC8B2.6070404@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B9FC8B2.6070404@linux.vnet.ibm.com>
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


* Anthony Liguori <aliguori@linux.vnet.ibm.com> wrote:

> On 03/16/2010 12:52 PM, Ingo Molnar wrote:
> >* Anthony Liguori<aliguori@linux.vnet.ibm.com>  wrote:
> >
> >>On 03/16/2010 10:52 AM, Ingo Molnar wrote:
> >>>You are quite mistaken: KVM isnt really a 'random unprivileged application' in
> >>>this context, it is clearly an extension of system/kernel services.
> >>>
> >>>( Which can be seen from the simple fact that what started the discussion was
> >>>   'how do we get /proc/kallsyms from the guest'. I.e. an extension of the
> >>>   existing host-space /proc/kallsyms was desired. )
> >>Random tools (like perf) should not be able to do what you describe. It's a
> >>security nightmare.
> >A security nightmare exactly how? Mind to go into details as i dont understand
> >your point.
> 
> Assume you're using SELinux to implement mandatory access control.
> How do you label this file system?
>
> Generally speaking, we don't know the difference between /proc/kallsyms vs. 
> /dev/mem if we do generic passthrough.  While it might be safe to have a 
> relaxed label of kallsyms (since it's read only), it's clearly not safe to 
> do that for /dev/mem, /etc/shadow, or any file containing sensitive 
> information.

What's your _point_? Please outline a threat model, a vector of attack, 
_anything_ that substantiates your "it's a security nightmare" claim.

> Rather, we ought to expose a higher level interface that we have more 
> confidence in with respect to understanding the ramifications of exposing 
> that guest data.

Exactly, we want something that has a flexible namespace and works well with 
Linux tools in general. Preferably that namespace should be human readable, 
and it should be hierarchic, and it should have a well-known permission model.

This concept exists in Linux and is generally called a 'filesystem'.

> >> No way.  The guest has sensitive data and exposing it widely on the host 
> >> is a bad thing to do. [...]
> >
> > Firstly, you are putting words into my mouth, as i said nothing about 
> > 'exposing it widely'. I suggest exposing it under the privileges of 
> > whoever has access to the guest image.
> 
> That doesn't work as nicely with SELinux.
> 
> It's completely reasonable to have a user that can interact in a read only 
> mode with a VM via libvirt but cannot read the guest's disk images or the 
> guest's memory contents.

If a user cannot read the image file then the user has no access to its 
contents via other namespaces either. That is, of course, a basic security 
aspect.

( That is perfectly true with a non-SELinux Unix permission model as well, and
  is true in the SELinux case as well. )

> > Secondly, regarding confidentiality, and this is guest security 101: whoever
> > can access the image on the host _already_ has access to all the guest data!
> >
> > A Linux image can generally be loopback mounted straight away:
> >
> >   losetup -o 32256 /dev/loop0 ./guest-image.img
> >   mount -o ro /dev/loop0 /mnt-guest
> >
> >(Or, if you are an unprivileged user who cannot mount, it can be read via ext2
> >tools.)
> >
> > There's nothing the guest can do about that. The host is in total control of
> > guest image data for heaven's sake!
> 
> It's not that simple in a MAC environment.

Erm. Please explain to me, what exactly is 'not that simple' in a MAC 
environment?

Also, i'd like to note that the 'restrictive SELinux setups' usecases are 
pretty secondary.

To demonstrate that, i'd like every KVM developer on this list who reads this 
mail and who has their home development system where they produce their 
patches set up in a restrictive MAC environment, in that you cannot even read 
the images you are using, to chime in with a "I'm doing that" reply.

If there's just a _single_ KVM developer amongst dozens and dozens of 
developers on this list who develops in an environment like that i'd be 
surprised. That result should pretty much tell you where the weight of 
instrumentation focus should lie - and it isnt on restrictive MAC environments 
...

	Ingo
