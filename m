Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab0CVNGY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 09:06:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753581Ab0CVNGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 09:06:22 -0400
Date: Mon, 22 Mar 2010 13:05:13 +0000
From: "Daniel P. Berrange" <berrange@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
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
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single project
Message-ID: <20100322130513.GJ21874@redhat.com>
Reply-To: "Daniel P. Berrange" <berrange@redhat.com>
References: <4BA67F12.6030501@nagafix.co.uk> <4BA68063.2050800@redhat.com> <4BA68234.1060804@nagafix.co.uk> <4BA68997.60406@redhat.com> <20100321212009.GE30194@elte.hu> <4BA70F9A.8030304@redhat.com> <20100322114824.GF3483@elte.hu> <84144f021003220531p391975f2p5a2e0cfd3a2af6d@mail.gmail.com> <20100322123726.GH21874@redhat.com> <20100322125440.GB12475@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100322125440.GB12475@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 01:54:40PM +0100, Ingo Molnar wrote:
> 
> * Daniel P. Berrange <berrange@redhat.com> wrote:
> > 
> > FYI, for offline guests, you can use libguestfs[1] to access & change files 
> > inside the guest, and read-only access to running guests files. It provides 
> > access via a interactive shell, APIs in all major languages, and also has a 
> > FUSE mdule to expose it directly in the host VFS.  It could probably be made 
> > to work read-write for running guests too if its agent were installed inside 
> > the guest & leverage the new Virtio-Serial channel for comms (avoiding any 
> > network setup requirements).
> > 
> > Regards,
> > Daniel
> > 
> > [1] http://libguestfs.org/
> 
> Yes, this is the kind of functionality i'm suggesting.
> 
> I'd suggest a different implementation for live guests: to drive this from 
> within the live guest side of KVM, i.e. basically a paravirt driver for 
> guestfs. You'd pass file API guests to the guest directly, via the KVM ioctl 
> or so - and get responses from the guest.
> 
> That will give true read-write access and completely coherent (and still 
> transparent) VFS integration, with no host-side knowledge needed for the 
> guest's low level (raw) filesystem structure. That's a big advantage.
> 
> Yes, it needs an 'aware' guest kernel - but that is a one-off transition 
> overhead whose cost is zero in the long run. (i.e. all KVM kernels beyond a 
> given version would have this ability - otherwise it's guest side distribution 
> transparent)
> 
> Even 'offline' read-only access could be implemented by booting a minimal 
> kernel via qemu -kernel and using a 'ro' boot option. That way you could 
> eliminate all lowlevel filesystem knowledge from libguestfs. You could run 
> ext4 or btrfs guest filesystems and FAT ones as well - with no restriction.
> 
> This would allow 'offline' access to Windows images as well: a FAT or ntfs 
> enabled mini-kernel could be booted in read-only mode.

This is close to the way libguestfs already works. It boots QEMU/KVM pointing
to a minimal stripped down appliance linux OS image, containing a small agent
it talks to over some form of vmchannel/serial/virtio-serial device. Thus the
kernel in the appliance it runs is the only thing that needs to know about the
filesystem/lvm/dm on-disk formats - libguestfs definitely does not want to be
duplicating this detailed knowledge of on disk format itself. It is doing
full read-write access to the guest filesystem in offline mode - one of the
major use cases is disaster recovery from a unbootable guest OS image.

Regards,
Daniel
-- 
|: Red Hat, Engineering, London    -o-   http://people.redhat.com/berrange/ :|
|: http://libvirt.org -o- http://virt-manager.org -o- http://deltacloud.org :|
|: http://autobuild.org        -o-         http://search.cpan.org/~danberr/ :|
|: GnuPG: 7D3B9505  -o-   F3C9 553F A1DA 4AC2 5648 23C1 B3DF F742 7D3B 9505 :|
