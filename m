Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab0LFVuw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 16:50:52 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:31993
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753281Ab0LFVuu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 16:50:50 -0500
X-SpamScore: -29
X-BigFish: VPS-29(zzbb2dK542N1432N98dN9371Pzz1202hzzz2dh95h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] of/fdt: add kernel command line option for dtb_compat string
Date: Mon, 6 Dec 2010 13:50:47 -0800
In-Reply-To: <4CFD3371.3080807@gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] of/fdt: add kernel command line option for dtb_compat string
Thread-Index: AcuVeEDxiMlk8MG9TaC4FqjYFa5/XQAFWhCA
References: <1291658059-383-1-git-send-email-dirk.brandewie@gmail.com> <4bb36a12-8d95-4d4e-936c-c1c74a9372cc@VA3EHSMHS025.ehs.local> <4CFD3322.1000503@gmail.com> <4CFD3371.3080807@gmail.com>
From: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
To: Dirk Brandewie <dirk.brandewie@gmail.com>
CC: <linux-kernel@vger.kernel.org>, Randy Dunlap <rdunlap@xenotime.net>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <grant.likely@secretlab.ca>
X-OriginalArrivalTime: 06 Dec 2010 21:50:42.0635 (UTC) FILETIME=[A12109B0:01CB958F]
X-RCIS-Action: ALLOW
Message-ID: <805e9139-7c09-45f5-a5a9-0ed0cbf64f2f@VA3EHSMHS025.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Dirk Brandewie [mailto:dirk.brandewie@gmail.com]
> Sent: Monday, December 06, 2010 11:03 AM
> To: Stephen Neuendorffer
> Cc: linux-kernel@vger.kernel.org; Randy Dunlap;
devicetree-discuss@lists.ozlabs.org; linux-
> doc@vger.kernel.org; grant.likely@secretlab.ca
> Subject: Re: [PATCH] of/fdt: add kernel command line option for
dtb_compat string
> 
> On 12/06/2010 11:01 AM, Dirk Brandewie wrote:
> > On 12/06/2010 10:37 AM, Stephen Neuendorffer wrote:
> >>
> >>
> >>> diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
> >>> index c1360e0..ca1318c 100644
> >>> --- a/drivers/of/fdt.c
> >>> +++ b/drivers/of/fdt.c
> >>> @@ -15,6 +15,8 @@
> >>> #include<linux/of_fdt.h>
> >>> #include<linux/string.h>
> >>> #include<linux/errno.h>
> >>> +#include<asm-generic/vmlinux.lds.h>
> >>> +
> >>>
> >>> #ifdef CONFIG_PPC
> >>> #include<asm/machdep.h>
> >>> @@ -604,3 +606,49 @@ void __init unflatten_device_tree(void)
> >>>
> >>> pr_debug("<- unflatten_device_tree()\n");
> >>> }
> >>> +
> >>> +extern uint8_t __dtb_start[];
> >>> +extern uint8_t __dtb_end[];
> >>> +static void __init *of_flat_dt_find_compatible_dtb(char *name)
> >>> +{
> >>> + void *rc = NULL;
> >>> + unsigned long root, size;
> >>> + struct boot_param_header *orig_initial_boot_params;
> >>> + uint8_t *blob;
> >>> +
> >>> + orig_initial_boot_params = initial_boot_params;
> >>> + blob = __dtb_start;
> >>> + initial_boot_params = (struct boot_param_header *)blob;
> >>
> >> Oy... can you avoid the pointer dance by using
of_fdt_is_compatible()
> >> from my recent set of patches?
> >
> > I would like to get rid of the pointer dance. Is your patch set
going to make it
> > into .37? I didn't see any acks.
> >
> Obviously I meant .38 :-)

I'd like it too, but that's up to Grant.  I imagine some of the
bottleneck is that I don't have
an easy way to test on powerpc or microblaze at the moment, so it's not
clear that the code doesn't
break anything.

> >> It takes a blob argument. Then the loop below goes away.
> >>
> >
> > The loop will still be needed since multiple DTBs may be linked into
the image.
> > using your of_fdt_is_compatible() will make the loop a lot more
readable though.

Yeah, right.  Is the format just the binary concatenation of the device
trees?  part of why I ask
is the PTR_ALIGN code: It seems like different blob functions make
different assumptions about the 
location of the blob. In some cases, it is assumed to be the passed
pointer, in others, 
the pointer is scanned for OF_DT_BEGIN_NODE (using of_get_flat_dt_root).
Is the concern about
STRUCT_ALIGNMENT necessary if you call of_get_flat_dt_root() afterwards?
Would it make sense to
always call of_get_flat_dt_root in the 'generic' functions I added or
not?

BTW, PTR_ALIGN should probably be ALIGN.

Steve

This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


