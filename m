Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477Ab2BHVkJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 16:40:09 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:48102 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab2BHVkG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 16:40:06 -0500
MIME-Version: 1.0
Message-ID: <52f90b19-84b5-4e97-952a-373bdfeaa77d@default>
Date: Wed, 8 Feb 2012 13:39:52 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Nitin Gupta <ngupta@vflare.org>, Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>, Greg KH <greg@kroah.com>,
        Brian King <brking@linux.vnet.ibm.com>,
        Konrad Wilk <konrad.wilk@oracle.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: RE: [PATCH 1/5] staging: zsmalloc: zsmalloc memory allocation library
References: <1326149520-31720-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <1326149520-31720-2-git-send-email-sjenning@linux.vnet.ibm.com>
 <4F21A5AF.6010605@linux.vnet.ibm.com> <4F300D41.5050105@linux.vnet.ibm.com>
 <4F32A55E.8010401@linux.vnet.ibm.com> <4F32B6A4.8030702@vflare.org>
 <4F32BEDC.6030502@linux.vnet.ibm.com> <4F32E1D2.4010809@vflare.org>
In-Reply-To: <4F32E1D2.4010809@vflare.org>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090204.4F32EBAE.004B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing the _real_ GregKH to avoid further bounces... Greg, if
you care, the whole thread is on the various lists)

> From: Nitin Gupta [mailto:ngupta@vflare.org]
> Subject: Re: [PATCH 1/5] staging: zsmalloc: zsmalloc memory allocation library
> 
> On 02/08/2012 01:28 PM, Dave Hansen wrote:
> 
> > On 02/08/2012 09:53 AM, Nitin Gupta wrote:
> >> vmap() is not just slower but also does memory allocations at various
> >> places. Under memory pressure, this may cause failure in reading a
> >> stored object just because we failed to map it. Also, it allocates VA
> >> region each time its called which is a real big waste when we can simply
> >> pre-allocate 2 * PAGE_SIZE'ed VA regions (per-cpu).
> >
> > Yeah, vmap() is a bit heavy-handed.  I'm just loathe to go mucking
> > around in the low-level pagetables too much.  Just seems like there'll
> > be a ton of pitfalls, like arch-specific TLB flushing, and it _seems_
> > like one of the existing kernel mechanisms should work.
> >
> > I guess if you've exhaustively explored all of the existing kernel
> > mapping mechanisms and found none of them to work, and none of them to
> > be in any way suitably adaptable to your use, you should go ahead and
> > roll your own.  I guess you do at least use alloc_vm_area().  What made
> > map_vm_area() unsuitable for your needs?  If you're remapping, you
> > should at least be guaranteed not to have to allocate pte pages.
> 
> map_vm_area() needs 'struct vm_struct' parameter but for mapping kernel
> allocated pages within kernel, what should we pass here?  I think we can
> instead use map_kernel_range_noflush() -- surprisingly
> unmap_kernel_range_noflush() is exported but this one is not.

Creating a dependency on a core kernel change (even just an EXPORT_SYMBOL)
is probably not a good idea.  Unless Dave vehemently objects, I'd suggest
implementing it both ways, leaving the method that relies on the
kernel change ifdef'd out, and add this to "the list of things that
need to be done before zcache can be promoted out of staging".
