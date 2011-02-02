Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002Ab1BBTm3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 14:42:29 -0500
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:25734 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751297Ab1BBTm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 14:42:27 -0500
Date: Wed, 2 Feb 2011 11:42:27 -0800
From: Dmitry Torokhov <dtor@vmware.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: Early crash (was: Re: module: show version information for
 built-in modules in sysfs)
Message-ID: <20110202194227.GA13794@dtor-ws.eng.vmware.com>
References: <AANLkTin4gOnEMruLDM=TkNYsNf5S370WqbcDVJzT7_Z4@mail.gmail.com>
 <20110201210944.GA12348@dtor-ws.eng.vmware.com>
 <AANLkTimv=KqtuR36dMNa+=OMi0mgd8JK4qsb_SpmKmhs@mail.gmail.com>
 <20110201222637.GA17521@dtor-ws.eng.vmware.com>
 <AANLkTikWVt8NEyHN+=yD4EWSXUQt0gt5nLJtKQDw397M@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikWVt8NEyHN+=yD4EWSXUQt0gt5nLJtKQDw397M@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 02, 2011 at 06:48:50AM -0800, Geert Uytterhoeven wrote:
> On Tue, Feb 1, 2011 at 23:26, Dmitry Torokhov <dtor@vmware.com> wrote:
> > On Tue, Feb 01, 2011 at 02:03:23PM -0800, Geert Uytterhoeven wrote:
> >> On Tue, Feb 1, 2011 at 22:09, Dmitry Torokhov <dtor@vmware.com> wrote:
> >> > On Tue, Feb 01, 2011 at 12:33:29PM -0800, Geert Uytterhoeven wrote:
> >> >> On Mon, Jan 24, 2011 at 11:59, Linux Kernel Mailing List
> >> >> <linux-kernel@vger.kernel.org> wrote:
> >> >> > Gitweb:     http://git.kernel.org/linus/e94965ed5beb23c6fabf7ed31f625e66d7ff28de
> >> >>
> >> >> >    module: show version information for built-in modules in sysfs
> >> >> >
> >> >> >    Currently only drivers that are built as modules have their versions
> >> >> >    shown in /sys/module/<module_name>/version, but this information might
> >> >> >    also be useful for built-in drivers as well. This especially important
> >> >> >    for drivers that do not define any parameters - such drivers, if
> >> >> >    built-in, are completely invisible from userspace.
> >> >> >
> >> >> >    This patch changes MODULE_VERSION() macro so that in case when we are
> >> >> >    compiling built-in module, version information is stored in a separate
> >> >> >    section. Kernel then uses this data to create 'version' sysfs attribute
> >> >> >    in the same fashion it creates attributes for module parameters.
> >> >>
> >> >> This commit causes the crash below on m68k (ARAnyM).
> >> >> Reverting this commit and its dependency
> >> >> 3b90a5b292321b2acac3921f77046ae195aef53f
> >> >> ("module: fix linker error for MODULE_VERSION when !MODULE and CONFIG_SYSFS=n")
> >> >> makes it boot again.
> >> >>
> >> >
> >> > Hi Geert,
> >> >
> >> > Does the follwing help by any chance?
> >> >
> >> > From d6fd4a6e0fc2d3f0a74962d4a6f663a46d230ecd Mon Sep 17 00:00:00 2001
> >> > diff --git a/arch/m68knommu/kernel/vmlinux.lds.S b/arch/m68knommu/kernel/vmlinux.lds.S
> >> > index ef33213..47e15eb 100644
> >> > --- a/arch/m68knommu/kernel/vmlinux.lds.S
> >> > +++ b/arch/m68knommu/kernel/vmlinux.lds.S
> >>
> >> The crash happened on m68k with MMU, not m68knommu.
> >>
> >
> > Hmm, OK then. Could you please see if the crash happens if you return
> > early in kernel/params.c::version_sysfs_builtin() ? Also, do you see
> 
> It does not crash if version_sysfs_builtin() returns early.
> 
> > anything in __modev section of your build?
> 
> "objdump -h" says:
> 
> | Sections:
> | Idx Name          Size      VMA       LMA       File off  Algn
> |   7 __modver      0000007c  002e0f84  002e0f84  002e0f84  2**2
> |                   CONTENTS, ALLOC, LOAD, DATA
> 
> "nm vmlinux | grep __modver" says:
> 
> | 002e0f84 d __modver_version_attr
> | 002e0fa8 d __modver_version_attr
> | 00039026 T __modver_version_show
> | 002e0f84 D __start___modver
> | 002e0fca D __stop___modver
> 
> The section size (0x7c) is larger than __stop___modver -
> __start___modver (0x46)?
> 
> Adding some debugging code (which increases the section size even more?) shows:
> 
> vattr = 002e1004
> vattr->module_name = xz_dec
>     mk = 00c2ee50
>     err = 0
>     kobject_uevent done
>     kobject_put done
> vattr = 002e1026
> vattr->module_name = (null)
> Unable to handle kernel NULL pointer dereference at virtual address 0000002c
> 
> So the second module in the list has no name. Why?
> Aha, it's not NULL, but just < PAGE_SIZE (0x2c).
> 
> sizeof(struct module_version_attribute) = 34, which you can see from
> the 2 consecutive vattr
> pointers above. But the "aligned(sizeof(void *))" in the definition of
> MODULE_VERSION() puts
> the next module_version_attribute struct in the array at offset 36,
> not offset 34!
> On m68k, the alignment of 32-bit integrals is 2 bytes, not 4.

But why is it aligned on 2-byte boundary and why m64k is not happy with
module_version_attribute but is happy with kernel_param which is also
aligned similarly?

If we unroll module_version_attribute it woud look like this:

struct module_version_attribute {

	struct module_attribute {

		struct attribute {
			const char *name;
			mode_t mode;
		} attr;
		...

	} mattr;

	const char *module_name;
	const char *version;
};

So I would expect it be aligned on (char *) boundary which should be the
same as (void *).

Will it help if we rearrange module_version_attribute definition to
explicitly have first field being a pointer so it is more like
kernel_param, like this:

struct module_version_attribute {
	const char *module_name;
	const char *version;
	struct module_attribute mattr;
};

Thanks,
Dmitry

