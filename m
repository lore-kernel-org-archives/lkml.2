Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935234Ab0KQSHb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 13:07:31 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38428 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934809Ab0KQSH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 13:07:28 -0500
Date: Wed, 17 Nov 2010 11:07:23 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: dirk.brandewie@gmail.com, Michal Marek <mmarek@suse.cz>,
        devicetree-discuss@lists.ozlabs.org, sodaville@linutronix.de,
        arjan@linux.intel.com, linuxppc-dev@lists.ozlabs.org,
        microblaze-uclinux@itee.uq.edu.au, linux-arch@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] of: Add support for linking device tree blobs into
 vmlinux
Message-ID: <20101117180723.GA7550@angua.secretlab.ca>
References: <cover.1289943240.git.dirk.brandewie@gmail.com>
 <9129f0a21ea48fb2dcb89cea290e88f3e8c0d8a2.1289943240.git.dirk.brandewie@gmail.com>
 <20101117092751.GA19781@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117092751.GA19781@merkur.ravnborg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 10:27:51AM +0100, Sam Ravnborg wrote:
> On Tue, Nov 16, 2010 at 02:41:36PM -0800, dirk.brandewie@gmail.com wrote:
> > From: Dirk Brandewie <dirk.brandewie@gmail.com>
> > 
> > This patch adds support for linking device tree blobs into
> > vmlinux. Modifies asm-generic/vmlinux.lds.h to add linking
> > .dtb.init.rodata sections into the .init.data section of the vmlinux
> > image. Modifies scripts/Makefile.lib to add a kbuild command to
> > compile DTS files to device tree blobs and a rule to create objects to
> > wrap the blobs for linking.
> > 
> > The DTB's are placed on 32 byte boundries to allow parsing the blob
> > with driver/of/fdt.c during early boot without having to copy the blob
> > to get the structure alignment GCC expects.
> > 
> > A DTB is linked in by adding the DTB object to the list of objects to
> > be linked into vmlinux in the archtecture specific Makefile using
> >    obj-y += foo.dtb.o
> > 
> > Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
> > ---
> >  include/asm-generic/vmlinux.lds.h |   19 +++++++++++++++++--
> >  scripts/Makefile.lib              |   20 ++++++++++++++++++++
> >  2 files changed, 37 insertions(+), 2 deletions(-)
> 
> When you touch Makefiles in scripts/* it is always a good idea to cc:
> kbuild maintainer on the patch - I have added Michal.
> 
> Support functionality in Makefile.lib is documented in
> Documentation/kbuild/* - please add documentation there.
> 
> > 
> > diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> > index bd69d79..ea671e7 100644
> > --- a/include/asm-generic/vmlinux.lds.h
> > +++ b/include/asm-generic/vmlinux.lds.h
> > @@ -67,7 +67,14 @@
> >   * Align to a 32 byte boundary equal to the
> >   * alignment gcc 4.5 uses for a struct
> >   */
> > -#define STRUCT_ALIGN() . = ALIGN(32)
> > +#define STRUCT_ALIGNMENT 32
> > +#define STRUCT_ALIGN() . = ALIGN(STRUCT_ALIGNMENT)
> > +
> > +/* Device tree blobs linked into the kernel need to have proper
> > + * structure alignment to be parsed by the flat device tree library
> > + * used in early boot
> > +*/
> > +#define DTB_ALIGNMENT STRUCT_ALIGNMENT
> 
> It has been discussed in another thread some time ago to move
> to a general 32 byte alignment for everything in vmlinux.lds.h
> So there is not much need for the specific DTB alignment.
> 
> > diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
> > index 4c72c11..29db062 100644
> > --- a/scripts/Makefile.lib
> > +++ b/scripts/Makefile.lib
> > @@ -200,6 +200,26 @@ quiet_cmd_gzip = GZIP    $@
> >  cmd_gzip = (cat $(filter-out FORCE,$^) | gzip -f -9 > $@) || \
> >  	(rm -f $@ ; false)
> >  
> > +# DTC
> > +#  ---------------------------------------------------------------------------
> > +$(obj)/%.dtb.S: $(obj)/%.dtb FORCE
> > +	@echo '#include <asm-generic/vmlinux.lds.h>' > $@
> > +	@echo '.section .dtb.init.rodata,"a"' >> $@
> > +	@echo '.balign DTB_ALIGNMENT' >> $@
> > +	@echo '.global __dtb_$(*F)_begin' >> $@
> > +	@echo '__dtb_$(*F)_begin:' >> $@
> > +	@echo '.incbin "$<" ' >> $@
> > +	@echo '__dtb_$(*F)_end:' >> $@
> > +	@echo '.global __dtb_$(*F)_end' >> $@
> > +	@echo '.balign DTB_ALIGNMENT' >> $@
> 
> 
> This will be noisy during build. Please use proper macors to supress output.
> 
> 
> > +
> > +DTC = $(objtree)/scripts/dtc/dtc
> > +
> > +quiet_cmd_dtc = DTC	$@
> Please avoid tabs in the output - all other uses spaces. (There is a tab between DTC and $@)
> 
> > +      cmd_dtc = $(DTC) -O dtb -o $(obj)/$*.dtb -b 0 $(DTS_FLAGS) $(src)/dts/$*.dts
> 
> Looks strange. How about:
>       cmd_dtc = $(DTC) -O dtb -o $@ -b 0 $(DTS_FLAGS) $<
> 
> Then you avoid the hardcoded path in the rule too.
> 
> 
> > +
> > +$(obj)/%.dtb: $(src)/dts/%.dts
> > +	$(call if_changed,dtc)

The rule should be generic (not depend on the presence of a dts
subdirectory.  Basically, the .dtb really should be generated in the
same directory as the .dts file.  There is no reason for this rule to
have special behaviour.

> 
> This snippet belong in the file that uses this.
> This is how we do for other rules like bzip etc.

This rule is intended to be generic and usable anywhere in the tree.

g.

