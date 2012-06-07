Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932950Ab2FGVVV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 17:21:21 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:17529 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932257Ab2FGVVT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 17:21:19 -0400
MIME-Version: 1.0
Message-ID: <06bd08dd-b8b4-4c7d-b8f3-f74f6270e51b@default>
Date: Thu, 7 Jun 2012 14:20:40 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>
Subject: RE: [PATCH 2/2] zram: clean up handle
References: <1338881031-19662-1-git-send-email-minchan@kernel.org>
 <1338881031-19662-2-git-send-email-minchan@kernel.org>
 <4FCEE4E0.6030707@vflare.org> <4FD015FE.7070906@kernel.org>
 <dfc7087d-6826-4429-8063-d47d05cd2d26@default> <4FD11A3C.801@vflare.org>
In-Reply-To: <4FD11A3C.801@vflare.org>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Nitin Gupta [mailto:ngupta@vflare.org]
> > Nitin, can zsmalloc allow full page allocation by assigning
> > an actual physical pageframe (which is what zram does now)?
> > Or will it allocate PAGE_SIZE bytes which zsmalloc will allocate
> > crossing a page boundary which, presumably, will have much worse
> > impact on page allocator availability when these pages are
> > "reclaimed" via your swap notify callback.
> 
> zsmalloc does not add any object headers, so when allocating PAGE_SIZE
> you get a separate page from as if you did alloc_page(). So, it does not
> span page boundaries.
> 
> > Though this may be rare across all workloads, it may turn out
> > to be very common for certain workloads (e.g. if the workload
> > has many dirty anonymous pages that are already compressed
> > by userland).
> >
> > It may not be worth cleaning up the code if it causes
> > performance issues with this case.
> >
> > And anyway can zsmalloc handle and identify to the caller pages
> > that are both compressed and "native" (uncompressed)?  It
> > certainly has to handle both if you remove ZRAM_UNCOMPRESSED
> > as compressing some pages actually results in more than
> > PAGE_SIZE bytes.  So you need to record somewhere that
> > this "compressed page" is special and that must somehow
> > be communicated to the caller of your "get" routine.
> >
> > (Just trying to save Minchan from removing all that code but
> > then needing to add it back again.)
> 
> zsmalloc cannot identify compressed vs uncompressed pages. However, in
> zram, we can tell if the page is uncompressed using table[i]->size which
> is set to PAGE_SIZE for uncompressed pages.   Pages that compress to
> more than PAGE_SIZE (i.e. expand on compression) are stored
> as-is/uncompressed and thus will have size field set to PAGE_SIZE.
> 
> Thus, we do not require ZRAM_UNCOMPRESSED flag when using zsmalloc for
> both compressed and uncompressed pages.

Good to know.  Nice work in zsmalloc and zram!

Dan
