Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751483Ab2JARdx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 13:33:53 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:51281 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab2JARdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 13:33:51 -0400
Date: Mon, 1 Oct 2012 19:33:30 +0200
From: Daniel Kiper <daniel.kiper@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: andrew.cooper3@citrix.com, xen-devel <xen-devel@lists.xen.org>,
        konrad.wilk@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/11] x86/xen: Add i386 kexec/kdump implementation
Message-ID: <20121001173330.GA3120@host-192-168-1-59.local.net-space.pl>
References: <1348769198-29580-1-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-2-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-3-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-4-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-5-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-6-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-7-git-send-email-daniel.kiper@oracle.com>
 <506577E3020000780009E65B@nat28.tlf.novell.com>
 <20121001125252.GB2942@host-192-168-1-59.local.net-space.pl>
 <5069BCD5020000780009EC7D@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5069BCD5020000780009EC7D@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 02:55:01PM +0100, Jan Beulich wrote:
> >>> On 01.10.12 at 14:52, Daniel Kiper <daniel.kiper@oracle.com> wrote:
> > On Fri, Sep 28, 2012 at 09:11:47AM +0100, Jan Beulich wrote:
> >> Finally, as noticed in an earlier patch already, you appear to
> >> re-introduce stuff long dropped from the kernel - the forward
> >> ported kernels get away with just setting PA_CONTROL_PAGE,
> >> PA_PGD, and PA_SWAP_PAGE in the page list. Since the number
> >> and purpose of the pages is established entirely by the guest
> >> kernel, all you need to obey is that the hypervisor expects
> >> alternating PA_/VA_ pairs (where the VA_ ones can be left
> >> unpopulated). Perhaps taking a look at a recent SLES kernel
> >> would help...
> >
> > I have got ftp://ftp.suse.com/pub/projects/kernel/kotd/SLE11-SP2/src/kernel-source-3.0.43-6.1.src.rpm.
> > Does kexec/kdump work in your environment? In my it does not.
>
> While I never ran it myself, I know kdump has been working on
> SLE for quite a long while (leaving aside hardware or firmware
> quirks requiring extra workarounds).

It should work on baremetal without any issue. However,
I am almost sure that it does not work on Xen dom0
in any way. But maybe I missed something.

> > At least there is wrong assumption that
> > vaddr = (unsigned long)relocate_kernel
> > gets virtual address of relocate_kernel in Xen
>
> Where did you spot that? Afaics the only thing done with
> relocate_kernel is that it gets copied into the control page.

arch/x86/kernel/machine_kexec_64.c:270
There is also similar thing in i386 code.

> > (I have tested only x86_64 implementation but
> > as I saw i386 has similar problem). In real it is
> > fix mapped in hypervisor which is completely
> > different than address calculated in dom0 kernel.
> > Virtual address of control page (and others) is
> > only known by hypervisor kexec/kdump functions.
> > It means that transition page table could be
> > established by relocate_kernel code only.
> > If you would like to do optimistation as you
> > mentioned above you must reintroduce code
> > for page table establishment into generic
> > relocate_kernel_??.S. However, another
> > problem arises. New generic code utilizes
> > additional arguments such as swap page
> > (and potentially could use others in the future).
> > As I saw it is not possible to pass extra addresses
> > through page_list[] in struct xen_kexec_image
> > because its has insufficient size (I mean
> > x86_64 because i386 is a bit different story).
>
> No - there's no meaning assigned by Xen to any of the slots,
> except for said assumption about them representing alternating

I know that.

> PA_/VA_ pairs. Hence, as long as old entries get removed, new
> slots can easily be added (and the number of slots currently
> needed is far lower than what was used originally [2.6.18]).

As I said in other email I will try to optimize page table code.
We will see what could be done.

Daniel
