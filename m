Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063Ab1CVOb5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 10:31:57 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:54318 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab1CVObz (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 22 Mar 2011 10:31:55 -0400
Date: Tue, 22 Mar 2011 10:31:37 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Thomas Hellstrom <thomas@shipmail.org>
Cc: linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
        dri-devel@lists.freedesktop.org, Alex Deucher <alexdeucher@gmail.com>,
        Jerome Glisse <j.glisse@gmail.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: Re: [PATCH] cleanup: Add 'struct dev' in the TTM layer to be
 passed in for DMA API calls.
Message-ID: <20110322143137.GA25113@dumpdata.com>
References: <1299598789-20402-1-git-send-email-konrad.wilk@oracle.com>
 <4D769726.2030307@shipmail.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D769726.2030307@shipmail.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4D88B2CC.0042,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 08, 2011 at 09:52:54PM +0100, Thomas Hellstrom wrote:
> Hi, Konrad,
> 
> Is passing a struct device to the DMA api really *strictly* necessary?

Soo.. it seems it is on PowerPC, which I sadly didn't check for, does require
this.
> 
> I'd like to avoid that at all cost, since we don't want pages that
> are backing buffer objects
> (coherent pages) to be associated with a specific device.
> 
> The reason for this is that we probably soon will want to move ttm
> buffer objects between devices, and that should ideally be a simple
> operation: If the memory type the buffer object currently resides in
> is not shared between two devices, then move it out to system memory
> and change its struct bo_device pointer.

I was thinking about this a bit after I found that the PowerPC requires
the 'struct dev'. But I got a question first, what do you with pages
that were allocated to a device that can do 64-bit DMA and then
move it to a device than can 32-bit DMA? Obviously the 32-bit card would
set the TTM_PAGE_FLAG_DMA32 flag, but the 64-bit would not. What is the
process then? Allocate a new page from the 32-bit device and then copy over the
page from the 64-bit TTM and put the 64-bit TTM page?

> 
> If pages are associated with a specific device, this will become
> much harder. Basically we need to change backing pages and copy all

what if you track it. Right now you need to track two things:
'struct page *' and 'dma_addr_t'. What if you had also to track
'struct dev *' with the page in question? Something like this:

diff --git a/include/drm/ttm/ttm_bo_driver.h b/include/drm/ttm/ttm_bo_driver.h
index efed082..1986761 100644
--- a/include/drm/ttm/ttm_bo_driver.h
+++ b/include/drm/ttm/ttm_bo_driver.h
@@ -158,9 +158,14 @@ enum ttm_caching_state {
  * memory.
  */
 
+struct ttm_tt_page {
+	struct page *page;
+	dma_addr_t *dma_addr;
+	struct dev *dev;
+}
 struct ttm_tt {
 	struct page *dummy_read_page;
-	struct page **pages;
+	struct ttm_tt_page **pages;
 	long first_himem_page;
 	long last_lomem_page;
 	uint32_t page_flags;
@@ -176,7 +181,6 @@ struct ttm_tt {
 		tt_unbound,
 		tt_unpopulated,
 	} state;
-	dma_addr_t *dma_address;
 };
 
 #define TTM_MEMTYPE_FLAG_FIXED         (1 << 0)	/* Fixed (on-card) PCI memory */

could do it. And when you pass the 'page' to the other TTM, it is just the matter
of passing in the 'struct ttm_tt_page' now.
