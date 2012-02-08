Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049Ab2BHRP4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 12:15:56 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:20666 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754336Ab2BHRPx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 12:15:53 -0500
MIME-Version: 1.0
Message-ID: <409797c4-a6e7-493d-9681-4166a9473ab8@default>
Date: Wed, 8 Feb 2012 09:15:36 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Nitin Gupta <ngupta@vflare.org>,
        Brian King <brking@linux.vnet.ibm.com>,
        Konrad Wilk <konrad.wilk@oracle.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: RE: [PATCH 1/5] staging: zsmalloc: zsmalloc memory allocation library
References: <1326149520-31720-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <1326149520-31720-2-git-send-email-sjenning@linux.vnet.ibm.com>
 <4F21A5AF.6010605@linux.vnet.ibm.com> <4F300D41.5050105@linux.vnet.ibm.com>
 <4F32A55E.8010401@linux.vnet.ibm.com>
In-Reply-To: <4F32A55E.8010401@linux.vnet.ibm.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090206.4F32ADC0.0004,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Dave Hansen [mailto:dave@linux.vnet.ibm.com]
> Subject: Re: [PATCH 1/5] staging: zsmalloc: zsmalloc memory allocation library
> 
> On 02/06/2012 09:26 AM, Seth Jennings wrote:
> > On 01/26/2012 01:12 PM, Dave Hansen wrote:
> >> void *kmap_atomic_prot(struct page *page, pgprot_t prot)
> >> {
> >> ...
> >>         type = kmap_atomic_idx_push();
> >>         idx = type + KM_TYPE_NR*smp_processor_id();
> >>         vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
> >>
> >> I think if you do a get_cpu()/put_cpu() or just a preempt_disable()
> >> across the operations you'll be guaranteed to get two contiguous addresses.
> >
> > I'm not quite following here.  kmap_atomic() only does this for highmem pages.
> > For normal pages (all pages for 64-bit), it doesn't do any mapping at all.  It
> > just returns the virtual address of the page since it is in the kernel's address
> > space.
> >
> > For this design, the pages _must_ be mapped, even if the pages are directly
> > reachable in the address space, because they must be virtually contiguous.
> 
> I guess you could use vmap() for that.  It's just going to be slower
> than kmap_atomic().  I'm really not sure it's worth all the trouble to
> avoid order-1 allocations, though.

Seth, Nitin, please correct me if I am wrong, but...

Dave, your comment makes me wonder if maybe you might be missing
the key value of the new allocator.  The zsmalloc allocator can grab
any random* page "A" with X unused bytes at the END of the page,
and any random page "B" with Y unused bytes at the BEGINNING of the page
and "coalesce" them to store any byte sequence with a length** Z
not exceeding X+Y.  Presumably this markedly increases
the density of compressed-pages-stored-per-physical-page***.  I don't 
see how allowing order-1 allocations helps here but if I am missing
something clever, please explain further.

(If anyone missed Jonathan Corbet's nice lwn.net article, see:
https://lwn.net/Articles/477067/ )

* Not really ANY random page, just any random page that has been
  previously get_free_page'd by the allocator and hasn't been
  free'd yet.
** X, Y and Z are all rounded to a multiple of 16 so there
  is still some internal fragmentation cost.
*** Would be interesting to see some random and real workload data
  comparing density for zsmalloc and xvmalloc.  And also zbud
  too as a goal is to replace zbud with zsmalloc too.
