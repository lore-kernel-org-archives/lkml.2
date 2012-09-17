Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612Ab2IQOf4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 10:35:56 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:46962 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756348Ab2IQOfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 10:35:55 -0400
Date: Mon, 17 Sep 2012 10:25:02 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Is: [PATCH 11/10] xen/swiotlb: For early initialization, return zero
 on success. Was: Re: [PATCH 10/10] xen/swiotlb: Depending on after_bootmem
 is not correct.
Message-ID: <20120917142502.GB12541@phenom.dumpdata.com>
References: <1347306367-28669-1-git-send-email-konrad.wilk@oracle.com>
 <1347306367-28669-11-git-send-email-konrad.wilk@oracle.com>
 <alpine.DEB.2.02.1209141709580.29232@kaball.uk.xensource.com>
 <20120917142315.GA12541@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120917142315.GA12541@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 10:23:15AM -0400, Konrad Rzeszutek Wilk wrote:
> > >  	start_dma_addr = xen_virt_to_bus(xen_io_tlb_start);
> > > -	if (!after_bootmem)
> > > +	rc = 0;
> >      ^
> > why does this change belong to this patch?
> > 
> > 
> 
> I took that out of the this patch, so it is now:
> 

..and spun out another patch to address the rc=0:

>From f85175ce01ba722cd4612230e7331dc0d4c8666f Mon Sep 17 00:00:00 2001
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Mon, 17 Sep 2012 10:20:09 -0400
Subject: [PATCH 2/2] xen/swiotlb: For early initialization, return zero on
 success.

If everything is setup properly we would return -ENOMEM since
rc by default is set to that value. Lets not do that and return
a proper return code.

Note: The reason the early code needs this special treatment
is that it SWIOTLB library call does not return anything (and
had it failed it would call panic()) - but our function does.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/swiotlb-xen.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index 02a52f3..ab4c66c 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -230,9 +230,10 @@ retry:
 		goto error;
 	}
 	start_dma_addr = xen_virt_to_bus(xen_io_tlb_start);
-	if (early)
+	if (early) {
 		swiotlb_init_with_tbl(xen_io_tlb_start, xen_io_tlb_nslabs, verbose);
-	else
+		rc = 0;
+	} else
 		rc = swiotlb_late_init_with_tbl(xen_io_tlb_start, xen_io_tlb_nslabs);
 	return rc;
 error:
-- 
1.7.7.6

