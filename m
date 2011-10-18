Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889Ab1JRItm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 04:49:42 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:9891 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038Ab1JRItk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 04:49:40 -0400
X-IronPort-AV: E=Sophos;i="4.69,364,1315180800"; 
   d="scan'208";a="8438326"
Subject: Re: [PATCH] mm: add a "struct page_frag" type containing a page,
 offset and length
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Miller <davem@davemloft.net>,
        "rientjes@google.com" <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "jaxboe@fusionio.com" <jaxboe@fusionio.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Date: Tue, 18 Oct 2011 09:49:38 +0100
In-Reply-To: <1318575363.11016.8.camel@dagon.hellion.org.uk>
References: <alpine.DEB.2.00.1110131327470.24853@chino.kir.corp.google.com>
	 <20111013.163708.1319779926961023813.davem@davemloft.net>
	 <alpine.DEB.2.00.1110131348310.24853@chino.kir.corp.google.com>
	 <20111013.165148.64222593458932960.davem@davemloft.net>
	 <20111013142201.355f9afc.akpm@linux-foundation.org>
	 <1318575363.11016.8.camel@dagon.hellion.org.uk>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1318927778.16132.52.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-14 at 07:56 +0100, Ian Campbell wrote:
> On Thu, 2011-10-13 at 22:22 +0100, Andrew Morton wrote:
> > Looks OK to me.  I'm surprised we don't already have such a thing.
> > 
> > Review comments:
> > 
> > 
> > > +struct page_frag {
> > > +	struct page *page;
> > > +#if (BITS_PER_LONG > 32) || (PAGE_SIZE >= 65536)
> > 
> > It does add risk that people will add compile warnings and bugs by
> > failing to consider or test the other case.
> >
> > We could reduce that risk by doing
> > 
> >    #if (PAGE_SIZE >= 65536)
> > 
> > but then the 32-bit version would hardly ever be tested at all.
> 
> Indeed. The first variant has the benefit that most 32-bit arches will
> test one case and most 64-bit ones the other.
> 
> Perhaps the need to keep this struct small is not so acute as it is for
> the skb_frag_t I nicked it from and just using __u32 unconditionally is
> sufficient?

I wasn't sure what to do here so I left it as it was, so the only change
here is s/page_offset/offset/. Switching to a u32 only version is
something we can easily do in the future if this scheme turns out to be
problematic.

Ian.

8<---------------------------------------------------------------

>From 806b74572ad63e2ed3ca69bb5640a55dc4475e73 Mon Sep 17 00:00:00 2001
From: Ian Campbell <ian.campbell@citrix.com>
Date: Mon, 3 Oct 2011 16:46:54 +0100
Subject: [PATCH] mm: add a "struct page_frag" type containing a page, offset and length

A few network drivers currently use skb_frag_struct for this purpose but I have
patches which add additional fields and semantics there which these other uses
do not want.

A structure for reference sub-page regions seems like a generally useful thing
so do so instead of adding a network subsystem specific structure.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Acked-by: Jens Axboe <jaxboe@fusionio.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David Miller <davem@davemloft.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
[since v1: s/struct subpage/struct page_frag/ on advice from Christoph]
[since v2: s/page_offset/offset/ on advice from Andrew]
---
 include/linux/mm_types.h |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 774b895..29971a5 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -135,6 +135,17 @@ struct page {
 #endif
 ;
 
+struct page_frag {
+	struct page *page;
+#if (BITS_PER_LONG > 32) || (PAGE_SIZE >= 65536)
+	__u32 offset;
+	__u32 size;
+#else
+	__u16 offset;
+	__u16 size;
+#endif
+};
+
 typedef unsigned long __nocast vm_flags_t;
 
 /*
-- 
1.7.2.5



