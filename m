Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab0CVMzH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 08:55:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44124 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754765Ab0CVMzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 08:55:05 -0400
Date: Mon, 22 Mar 2010 13:54:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Daniel P. Berrange" <berrange@redhat.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Avi Kivity <avi@redhat.com>,
       Antoine Martin <antoine@nagafix.co.uk>,
       Olivier Galibert <galibert@pobox.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
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
Message-ID: <20100322125440.GB12475@elte.hu>
References: <4BA67D75.8060809@redhat.com>
 <4BA67F12.6030501@nagafix.co.uk>
 <4BA68063.2050800@redhat.com>
 <4BA68234.1060804@nagafix.co.uk>
 <4BA68997.60406@redhat.com>
 <20100321212009.GE30194@elte.hu>
 <4BA70F9A.8030304@redhat.com>
 <20100322114824.GF3483@elte.hu>
 <84144f021003220531p391975f2p5a2e0cfd3a2af6d@mail.gmail.com>
 <20100322123726.GH21874@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100322123726.GH21874@redhat.com>
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


* Daniel P. Berrange <berrange@redhat.com> wrote:

> On Mon, Mar 22, 2010 at 02:31:49PM +0200, Pekka Enberg wrote:
> > On Mon, Mar 22, 2010 at 1:48 PM, Ingo Molnar <mingo@elte.hu> wrote:
> > >> What about line number information? ?And the source? ?Into the kernel with
> > >> them as well?
> > >
> > > Sigh. Please read the _very first_ suggestion i made, which solves all that. I
> > > rarely go into discussions without suggesting technical solutions - i'm not
> > > interested in flaming, i'm interested in real solutions.
> > >
> > > Here it is, repeated for the Nth time:
> > >
> > > Allow a guest to (optionally) integrate its VFS namespace with the host side
> > > as well. An example scheme would be:
> > >
> > > ? /guests/Fedora-G1/
> > > ? /guests/Fedora-G1/proc/
> > > ? /guests/Fedora-G1/usr/
> > > ? /guests/Fedora-G1/.../
> > > ? /guests/OpenSuse-G2/
> > > ? /guests/OpenSuse-G2/proc/
> > > ? /guests/OpenSuse-G2/usr/
> > > ? /guests/OpenSuse-G2/.../
> > >
> > > ?( This feature would be configurable and would be default-off, to maintain
> > > ? ?the current status quo. )
> > 
> > Heh, funny. That would also solve my number one gripe with virtualization 
> > these days: how to get files in and out of guests without having to 
> > install extra packages on the guest side and fiddling with mount points on 
> > every single guest image I want to play with.
> 
> FYI, for offline guests, you can use libguestfs[1] to access & change files 
> inside the guest, and read-only access to running guests files. It provides 
> access via a interactive shell, APIs in all major languages, and also has a 
> FUSE mdule to expose it directly in the host VFS.  It could probably be made 
> to work read-write for running guests too if its agent were installed inside 
> the guest & leverage the new Virtio-Serial channel for comms (avoiding any 
> network setup requirements).
> 
> Regards,
> Daniel
> 
> [1] http://libguestfs.org/

Yes, this is the kind of functionality i'm suggesting.

I'd suggest a different implementation for live guests: to drive this from 
within the live guest side of KVM, i.e. basically a paravirt driver for 
guestfs. You'd pass file API guests to the guest directly, via the KVM ioctl 
or so - and get responses from the guest.

That will give true read-write access and completely coherent (and still 
transparent) VFS integration, with no host-side knowledge needed for the 
guest's low level (raw) filesystem structure. That's a big advantage.

Yes, it needs an 'aware' guest kernel - but that is a one-off transition 
overhead whose cost is zero in the long run. (i.e. all KVM kernels beyond a 
given version would have this ability - otherwise it's guest side distribution 
transparent)

Even 'offline' read-only access could be implemented by booting a minimal 
kernel via qemu -kernel and using a 'ro' boot option. That way you could 
eliminate all lowlevel filesystem knowledge from libguestfs. You could run 
ext4 or btrfs guest filesystems and FAT ones as well - with no restriction.

This would allow 'offline' access to Windows images as well: a FAT or ntfs 
enabled mini-kernel could be booted in read-only mode.

Thanks,

	Ingo
