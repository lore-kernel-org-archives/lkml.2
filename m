Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960Ab0G3GPE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 02:15:04 -0400
Received: from sh.osrg.net ([192.16.179.4]:37355 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945Ab0G3GPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 02:15:00 -0400
Date: Fri, 30 Jul 2010 15:14:27 +0900
To: linux@arm.linux.org.uk
Cc: arnd@arndb.de, linux-arm-kernel@lists.infradead.org,
        fujita.tomonori@lab.ntt.co.jp, linux-arm-msm@vger.kernel.org,
        dwalker@codeaurora.org, stepanm@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/2] arm: msm: Add System MMU support.
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100729114726.GA17991@n2100.arm.linux.org.uk>
References: <20100728212156.GA6729@n2100.arm.linux.org.uk>
	<201007291012.05986.arnd@arndb.de>
	<20100729114726.GA17991@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100730151345W.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 30 Jul 2010 15:14:29 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jul 2010 12:47:26 +0100
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Thu, Jul 29, 2010 at 10:12:05AM +0200, Arnd Bergmann wrote:
> > On Wednesday 28 July 2010 23:21:56 Russell King - ARM Linux wrote:
> > > On Wed, Jul 28, 2010 at 07:50:20PM +0200, Arnd Bergmann wrote:
> > > > The DMA API is extremely flexible, it works just fine with all the
> > > > IOMMUs that I've seen so far. Please take a look at
> > > > include/asm-generic/dma-mapping-common.h and its users to see how
> > > > to use multiple IOMMUs depending on the device.
> > > 
> > > We don't yet use those DMA API interface extensions because we haven't
> > > had the need.  If someone who has the need wants to put the effort in
> > > though...
> > 
> > Right, it shouldn't be hard now that the groundwork for that is done.
> > Also, it's only really needed if you have IOMMUs of different types in the
> > same system. If msm doesn't have any swiotlb or dmabounce devices,
> > it could always use the same implementation for all devices.
> > 
> > > One of the problems with it though is the abstraction of the sync*
> > > operations is the wrong way around for stuff like dmabounce - we want
> > > to be passed the base address of the buffer (so we can look this up),
> > > plus offset and length.  We don't want to know just the region which
> > > is affected.
> > 
> > Yes, but that is an unrelated (dmabounce specific) problem that seems to
> > be fixed by an existing patch.
> 
> It's not unrelated because it stands in the way of using that interface.
> The patch also seems to be buggy in that it doesn't fix the for_device
> case - it leaves 'off' as zero.

Ah, sorry about the bug. Surely, the for_device needs to do the same
as the for_cpu. I've attached the updated patch.

We need to fix dmabounce.c anyway (even if we keep the sync_range API)
because drivers use the sync API to do a partial sync.


> I'm also not sold on this idea that the sync_range API is being obsoleted.
> It seems to me to be a step in the wrong direction.  The range API is a
> natural subset of the 'normal' sync API, yet people are trying to shoehorn
> the range API into the 'norma' API.  If anything it's the 'normal' API
> which should be obsoleted as it provides reduced information to
> implementations, which then have to start fuzzy-matching the passed
> address.

It would have been nice if you had opposed when this issue was
discussed...

commit 8127bfc5645db0e050468e0ff971b4081f73ddcf
Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date:   Wed Mar 10 15:23:18 2010 -0800

    DMA-API.txt: remove dma_sync_single_range description


As you said, the range API might be safer (since it requires more
information). However, there were already drivers using the
dma_sync_single_for API to do a partial sync (i.e. do a sync on
range).

Inspecting all the usage of the dma_sync_single_for API to see which
drivers to do a partial sync looks unrealistic. So keeping the
dma_sync_single_range_for API is pointless since drivers keep using 
dma_sync_single_for API.

And the majority of implementations doesn't use 'range' information,
i.e., the implementation of dma_sync_single_for and
dma_sync_single_range_for API is identical.


> If we're going to start fuzzy-matching the passed address, then I think
> we also need to add detection of overlapping mappings and BUG() on such
> cases - otherwise we risk the possibility of having multiple overlapping
> mappings and hitting the wrong mapping with this reduced-information sync
> API.

Strict checking would be nice. If architectures can do such easily, we
had better to do so.

However, I'm not sure we need to take special care for the
dma_sync_single_for API. In general, misuse of the majority of the DMA
functions is deadly.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] ARM: dmabounce: fix partial sync in dma_sync_single_* API

Some network drivers do a partial sync with
dma_sync_single_for_{device|cpu}. The dma_addr argument might not be
the same as one as passed into the mapping API.

This adds some tricks to find_safe_buffer() for
dma_sync_single_for_{device|cpu}.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/arm/common/dmabounce.c |   32 +++++++++++++++++++++++---------
 1 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/arch/arm/common/dmabounce.c b/arch/arm/common/dmabounce.c
index cc0a932..dbd30dc 100644
--- a/arch/arm/common/dmabounce.c
+++ b/arch/arm/common/dmabounce.c
@@ -163,7 +163,8 @@ alloc_safe_buffer(struct dmabounce_device_info *device_info, void *ptr,
 
 /* determine if a buffer is from our "safe" pool */
 static inline struct safe_buffer *
-find_safe_buffer(struct dmabounce_device_info *device_info, dma_addr_t safe_dma_addr)
+find_safe_buffer(struct dmabounce_device_info *device_info, dma_addr_t safe_dma_addr,
+		 int for_sync)
 {
 	struct safe_buffer *b, *rb = NULL;
 	unsigned long flags;
@@ -171,9 +172,17 @@ find_safe_buffer(struct dmabounce_device_info *device_info, dma_addr_t safe_dma_
 	read_lock_irqsave(&device_info->lock, flags);
 
 	list_for_each_entry(b, &device_info->safe_buffers, node)
-		if (b->safe_dma_addr == safe_dma_addr) {
-			rb = b;
-			break;
+		if (for_sync) {
+			if (b->safe_dma_addr <= safe_dma_addr &&
+			    safe_dma_addr < b->safe_dma_addr + b->size) {
+				rb = b;
+				break;
+			}
+		} else {
+			if (b->safe_dma_addr == safe_dma_addr) {
+				rb = b;
+				break;
+			}
 		}
 
 	read_unlock_irqrestore(&device_info->lock, flags);
@@ -205,7 +214,8 @@ free_safe_buffer(struct dmabounce_device_info *device_info, struct safe_buffer *
 /* ************************************************** */
 
 static struct safe_buffer *find_safe_buffer_dev(struct device *dev,
-		dma_addr_t dma_addr, const char *where)
+						dma_addr_t dma_addr, const char *where,
+						int for_sync)
 {
 	if (!dev || !dev->archdata.dmabounce)
 		return NULL;
@@ -216,7 +226,7 @@ static struct safe_buffer *find_safe_buffer_dev(struct device *dev,
 			pr_err("unknown device: Trying to %s invalid mapping\n", where);
 		return NULL;
 	}
-	return find_safe_buffer(dev->archdata.dmabounce, dma_addr);
+	return find_safe_buffer(dev->archdata.dmabounce, dma_addr, for_sync);
 }
 
 static inline dma_addr_t map_single(struct device *dev, void *ptr, size_t size,
@@ -286,7 +296,7 @@ static inline dma_addr_t map_single(struct device *dev, void *ptr, size_t size,
 static inline void unmap_single(struct device *dev, dma_addr_t dma_addr,
 		size_t size, enum dma_data_direction dir)
 {
-	struct safe_buffer *buf = find_safe_buffer_dev(dev, dma_addr, "unmap");
+	struct safe_buffer *buf = find_safe_buffer_dev(dev, dma_addr, "unmap", 0);
 
 	if (buf) {
 		BUG_ON(buf->size != size);
@@ -398,7 +408,7 @@ int dmabounce_sync_for_cpu(struct device *dev, dma_addr_t addr,
 	dev_dbg(dev, "%s(dma=%#x,off=%#lx,sz=%zx,dir=%x)\n",
 		__func__, addr, off, sz, dir);
 
-	buf = find_safe_buffer_dev(dev, addr, __func__);
+	buf = find_safe_buffer_dev(dev, addr, __func__, 1);
 	if (!buf)
 		return 1;
 
@@ -411,6 +421,8 @@ int dmabounce_sync_for_cpu(struct device *dev, dma_addr_t addr,
 	DO_STATS(dev->archdata.dmabounce->bounce_count++);
 
 	if (dir == DMA_FROM_DEVICE || dir == DMA_BIDIRECTIONAL) {
+		if (addr != buf->safe_dma_addr)
+			off = addr - buf->safe_dma_addr;
 		dev_dbg(dev, "%s: copy back safe %p to unsafe %p size %d\n",
 			__func__, buf->safe + off, buf->ptr + off, sz);
 		memcpy(buf->ptr + off, buf->safe + off, sz);
@@ -427,7 +439,7 @@ int dmabounce_sync_for_device(struct device *dev, dma_addr_t addr,
 	dev_dbg(dev, "%s(dma=%#x,off=%#lx,sz=%zx,dir=%x)\n",
 		__func__, addr, off, sz, dir);
 
-	buf = find_safe_buffer_dev(dev, addr, __func__);
+	buf = find_safe_buffer_dev(dev, addr, __func__, 1);
 	if (!buf)
 		return 1;
 
@@ -440,6 +452,8 @@ int dmabounce_sync_for_device(struct device *dev, dma_addr_t addr,
 	DO_STATS(dev->archdata.dmabounce->bounce_count++);
 
 	if (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL) {
+		if (addr != buf->safe_dma_addr)
+			off = addr - buf->safe_dma_addr;
 		dev_dbg(dev, "%s: copy out unsafe %p to safe %p, size %d\n",
 			__func__,buf->ptr + off, buf->safe + off, sz);
 		memcpy(buf->safe + off, buf->ptr + off, sz);
-- 
1.6.5


