Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668Ab0JTUVN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 16:21:13 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:36245 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175Ab0JTUVL (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 20 Oct 2010 16:21:11 -0400
Date: Wed, 20 Oct 2010 16:20:06 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: hpa@linux.intel.com, fujita.tomonori@lab.ntt.co.jp, JBeulich@novell.com,
        jeremy@goop.org, linux-kernel@vger.kernel.org
Subject: Modularizing IOMMUs (devel/iommu-0.4)
Message-ID: <20101020202006.GA30096@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Peter, Tomo-san, Jan and Jeremy, and LKML:

I was wondering if I could run this idea by you guys. One of the things that
Peter proposed was in some ways to "modularize" the IOMMUs (and potentially
later on use that framework to "modularize" other built-in components). For details:
http://lkml.org/lkml/2010/8/2/282 and the follow-on threads.

If you want to look at code right away, I've some beginnings at:

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/swiotlb-2.6.git devel/iommu-0.4
(look at patches past swiotlb-xen: Remove the unnecessary EXPORT_SYMBOL_GPL macros)

The 10,000 ft view is that during bootup, we want to jettison those IOMMUs
that are built-in, but actually aren't used b/c the machine does not have it.
Once it is identified which one we don't want, we mark those sections as available
for the kernel memory subsystem and we can shed some kilobytes.

So the first step is to identify the functions for the IOMMUs. And also
group them tightly together. The path I pursued was to stick all of the
executable sections in clearly identifiable sections that can be
easily identified.

The first idea I had that was to define in vmlinux.ld.S this little macro:

.PAGE_ALIGN(PAGE_SIZE) = .;
.iommu_text: {
   PROVIDE_HIDDEN(__iommu_swiotlb_start) := .;
   swiotlb*.o(*.text)
   PROVIDE_HIDDEN(__iommu_gart_start) := .;
   pci-gart_64.o(*.text)
   .. 
} = 0x9090

So essentially renaming .text section of specific object files to be 
instead .iommu_text section.

Well, that did not work as during linking GCC makes the object files in /tmp, so
instead of pci-gart_64.o we get /tmp/f892343.o. So question #1: Do you know of any
mechanism to enforce the naming of the object files? Or perhaps another way
to identify in the linker script file the <object-file><.text section> ?

Another way, less elegant was to manually enforce each function to be stuck
in the .iommu_text section. For that I made a macro: __iommu that would
force the function to be stuck in section specific for the IOMMU. So all
functions in pci-gart_64.c would be funneled in .iommu.gart.text. For calgary:
.iommu.calgary.text., and so on. This is accomplished by having at the beginning
of the the file the name of the IOMMU section, as so:

#define IOMMU_MODULE "gart"

And all of the functions would get stuck in .iommu.gart.text. This actually
worked out (hadn't tried to boot yet) and based on the compilation these are
the sizes:

1 .iommu.gart.text 00000be4  ..sip.  0000000001436fe2  00636fe2  2**0
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
  2 .iommu.calgary.text 00000c94  ..snip..  0000000001437bc6  00637bc6  2**0
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
  3 .iommu.amdvi.text 00002d74  ..snip..  000000000143885a  0063885a  2**0
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
  4 .iommu.dmar.text 00004ff7  ..snip..  000000000143b5ce  0063b5ce  2**0
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
  5 .iommu.xen-swiotlb.text 000005f3  ..snip.  00000000014405c5  006405c5  2**0

For those that can't read nativly hexadecimal, here are the sizes:
  Xen-SWIOTLB: 1523
  GART: 3044 bytes
  Calgary: 3220 bytes
  AMD V-I: 11636
  Intel DMAR: 20471.

Roughly it comes out to 40kB of executable. I haven't run the math, but
estimating this it looks as if on AMD machine we can dump about eight pages
(VT-D, Calgary, Xen-SWIOTBL), while on Intel with VT-D we can dump six pages
(GART, Calgary, AMD VI, Xen-SWIOTLB), and on Intel with non-VT, around eleven
pages (all IOMMUs, just stitch with the bare-metal SWIOTLB). Each .iommu.<x>.text
would be PAGE_ALIGN-ed of course.

The next stage (not yet written) would have to:
 - scan the EXPORT_SYMBOL definitions and see if any of them map within
   the sections that are to be discarded. If so, either neuter them
   or don't discard the IOMMU.
 - Mark the discarded sections to be freed. And utilize the framework for
   doing so.
 - Give the same treatment as the _stext -> _etext sections have. So
   setting of the various flags, etc.

But the Question #2 I have is: is it worth it? We can save on average around
eight pages (6+7+11/3), which is not exactly earth-shattering. This could be
become more generic so in the long run it could jettison more code and not
just IOMMUs, but lets start small first.

And then Question  #3): Is there a better way?
