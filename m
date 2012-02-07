Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288Ab2BGS2g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 13:28:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755706Ab2BGS2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 13:28:35 -0500
Date: Tue, 7 Feb 2012 10:28:28 -0800
From: Chris Wright <chrisw@redhat.com>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Avi Kivity <avi@redhat.com>, Scott Wood <scottwood@freescale.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Eric Northup <digitaleric@google.com>, KVM list <kvm@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>, Chris Wright <chrisw@redhat.com>
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
Message-ID: <20120207182828.GA7229@x200.localdomain>
References: <4F2AB552.2070909@redhat.com>
 <CAG7+5M0s_F93G3dPrRQaFMVv_hPzpd-wYEPApJUDGhh3vJuy-A@mail.gmail.com>
 <4F2C6517.3040203@codemonkey.ws>
 <4F302E0D.20302@freescale.com>
 <4F3118EA.7040302@codemonkey.ws>
 <4F311BBD.5050600@redhat.com>
 <4F311E64.10604@codemonkey.ws>
 <4F31249D.1040700@redhat.com>
 <4F314000.6060401@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F314000.6060401@codemonkey.ws>
User-Agent: Mutt/1.5.21+46 (b01d63af6fea) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Anthony Liguori (anthony@codemonkey.ws) wrote:
> On 02/07/2012 07:18 AM, Avi Kivity wrote:
> >On 02/07/2012 02:51 PM, Anthony Liguori wrote:
> >>On 02/07/2012 06:40 AM, Avi Kivity wrote:
> >>>On 02/07/2012 02:28 PM, Anthony Liguori wrote:
> >>>>
> >>>>>It's a potential source of exploits
> >>>>>(from bugs in KVM or in hardware). I can see people wanting to be
> >>>>>selective with access because of that.
> >>>>
> >>>>As is true of the rest of the kernel.
> >>>>
> >>>>If you want finer grain access control, that's exactly why we have things like
> >>>>LSM and SELinux. You can add the appropriate LSM hooks into the KVM
> >>>>infrastructure and setup default SELinux policies appropriately.
> >>>
> >>>LSMs protect objects, not syscalls. There isn't an object to protect here
> >>>(except the fake /dev/kvm object).
> >>
> >>A VM can be an object.
> >
> >Not really, it's not accessible in a namespace. How would you label it?

A VM, vcpu, etc are all objects.  The labelling can be implicit based on
the security context of the process creating the object.  You could create
simplistic rules such as a process may have the ability KVM__VM_CREATE
(this is roughly analogous to the PROC__EXECMEM policy control that
allows some processes to create executable writable memory mappings, or
SHM__CREATE for a process that can create a shared memory segment).
Adding some label mgmt to the object (add ->security and some callbacks to
do ->alloc/init/free), and then checks on the object itself would allow
for finer grained protection.  If there was any VM lookup (although the
original example explicitly ties a process to a vm and a thread to a
vcpu) the finer grained check would certainly be useful to verify that
the process can access the VM.

> Labels can originate from userspace, IIUC, so I think it's possible for QEMU
> (or whatever the userspace is) to set the label for the VM while it's
> creating it. I think this is how most of the labeling for X and things of
> that nature works.

For X, the policy enforcement is done in the X server.  There is
assistance from the kernel for doing policy server queries (can foo do
bar?), but it's up to the X server to actually care enough to ask and
then fail a request that doesn't comply.  I'm not sure that's the model
here.

thanks,
-chris
