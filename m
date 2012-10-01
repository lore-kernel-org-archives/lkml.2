Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab2JAMxL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 08:53:11 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:45911 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab2JAMxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 08:53:10 -0400
Date: Mon, 1 Oct 2012 14:52:52 +0200
From: Daniel Kiper <daniel.kiper@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: andrew.cooper3@citrix.com, xen-devel <xen-devel@lists.xen.org>,
        konrad.wilk@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/11] x86/xen: Add i386 kexec/kdump implementation
Message-ID: <20121001125252.GB2942@host-192-168-1-59.local.net-space.pl>
References: <1348769198-29580-1-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-2-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-3-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-4-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-5-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-6-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-7-git-send-email-daniel.kiper@oracle.com>
 <506577E3020000780009E65B@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506577E3020000780009E65B@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 09:11:47AM +0100, Jan Beulich wrote:
> >>> On 27.09.12 at 20:06, Daniel Kiper <daniel.kiper@oracle.com> wrote:
> > Add i386 kexec/kdump implementation.
>
> So this as well as the subsequent patch introduces quite a bit of
> duplicate code. The old 2.6.18 kernel had an initial pair of cleanup
> patches (attached in their forward ported form for 3.6-rc6) that
> would allow reducing the amount of duplication, particularly by
> eliminating the need to clone relocate_kernel_??.S altogether.

Thanks. Please look below for more details.

> Additionally, in the PAE case (which is the only relevant one for
> a 32-bit Xen kernel) I'm missing the address restriction
> enforcement for the PGD, without which the __ma() conversion
> result may not fit into the field it gets stored into.

Right.

> Finally, as noticed in an earlier patch already, you appear to
> re-introduce stuff long dropped from the kernel - the forward
> ported kernels get away with just setting PA_CONTROL_PAGE,
> PA_PGD, and PA_SWAP_PAGE in the page list. Since the number
> and purpose of the pages is established entirely by the guest
> kernel, all you need to obey is that the hypervisor expects
> alternating PA_/VA_ pairs (where the VA_ ones can be left
> unpopulated). Perhaps taking a look at a recent SLES kernel
> would help...

I have got ftp://ftp.suse.com/pub/projects/kernel/kotd/SLE11-SP2/src/kernel-source-3.0.43-6.1.src.rpm.
Does kexec/kdump work in your environment? In my it does not.
At least there is wrong assumption that
vaddr = (unsigned long)relocate_kernel
gets virtual address of relocate_kernel in Xen
(I have tested only x86_64 implementation but
as I saw i386 has similar problem). In real it is
fix mapped in hypervisor which is completely
different than address calculated in dom0 kernel.
Virtual address of control page (and others) is
only known by hypervisor kexec/kdump functions.
It means that transition page table could be
established by relocate_kernel code only.
If you would like to do optimistation as you
mentioned above you must reintroduce code
for page table establishment into generic
relocate_kernel_??.S. However, another
problem arises. New generic code utilizes
additional arguments such as swap page
(and potentially could use others in the future).
As I saw it is not possible to pass extra addresses
through page_list[] in struct xen_kexec_image
because its has insufficient size (I mean
x86_64 because i386 is a bit different story).
That is why relocate kernel code for Xen
should stay (sadly) in separate files.

Daniel
