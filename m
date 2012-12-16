Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab2LPR0p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 12:26:45 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:43780 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab2LPRY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 12:24:58 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: Hideki EIRAKU <hdk@igel.co.jp>
Cc: Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Katsuya MATSUBARA <matsu@igel.co.jp>,
        Damian Hobson-Garcia <dhobsong@igel.co.jp>
Subject: [PATCH/WIP/RFC 08/14] shmobile-iommu: Rename shmobile_iommu_priv to shmobile_iommu_domain
Date: Sun, 16 Dec 2012 18:25:54 +0100
Message-Id: <1355678760-27357-9-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1355678760-27357-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1350290093-998-1-git-send-email-hdk@igel.co.jp>
 <1355678760-27357-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/iommu/shmobile-iommu.c |  152 ++++++++++++++++++++--------------------
 1 files changed, 76 insertions(+), 76 deletions(-)

diff --git a/drivers/iommu/shmobile-iommu.c b/drivers/iommu/shmobile-iommu.c
index 463da32..1a37be2 100644
--- a/drivers/iommu/shmobile-iommu.c
+++ b/drivers/iommu/shmobile-iommu.c
@@ -35,13 +35,13 @@
 #define L2_LEN (L2_SIZE / 4)
 #define L2_ALIGN L2_SIZE
 
-struct shmobile_iommu_priv_pgtable {
+struct shmobile_iommu_domain_pgtable {
 	uint32_t *pgtable;
 	dma_addr_t handle;
 };
 
-struct shmobile_iommu_priv {
-	struct shmobile_iommu_priv_pgtable l1, l2[L1_LEN];
+struct shmobile_iommu_domain {
+	struct shmobile_iommu_domain_pgtable l1, l2[L1_LEN];
 	spinlock_t map_lock;
 	atomic_t active;
 };
@@ -51,64 +51,64 @@ static struct device *ipmmu_devices;
 static struct dma_pool *l1pool, *l2pool;
 static spinlock_t lock;
 static DEFINE_SPINLOCK(lock_add);
-static struct shmobile_iommu_priv *attached;
+static struct shmobile_iommu_domain *attached;
 static int num_attached_devices;
 static struct device *ipmmu_access_device;
 
 static int shmobile_iommu_domain_init(struct iommu_domain *domain)
 {
-	struct shmobile_iommu_priv *priv;
+	struct shmobile_iommu_domain *sh_domain;
 	int i;
 
-	priv = kmalloc(sizeof(*priv), GFP_KERNEL);
-	if (!priv)
+	sh_domain = kmalloc(sizeof(*sh_domain), GFP_KERNEL);
+	if (!sh_domain)
 		return -ENOMEM;
-	priv->l1.pgtable = dma_pool_alloc(l1pool, GFP_KERNEL,
-					  &priv->l1.handle);
-	if (!priv->l1.pgtable) {
-		kfree(priv);
+	sh_domain->l1.pgtable = dma_pool_alloc(l1pool, GFP_KERNEL,
+					       &sh_domain->l1.handle);
+	if (!sh_domain->l1.pgtable) {
+		kfree(sh_domain);
 		return -ENOMEM;
 	}
 	for (i = 0; i < L1_LEN; i++)
-		priv->l2[i].pgtable = NULL;
-	memset(priv->l1.pgtable, 0, L1_SIZE);
-	spin_lock_init(&priv->map_lock);
-	atomic_set(&priv->active, 0);
-	domain->priv = priv;
+		sh_domain->l2[i].pgtable = NULL;
+	memset(sh_domain->l1.pgtable, 0, L1_SIZE);
+	spin_lock_init(&sh_domain->map_lock);
+	atomic_set(&sh_domain->active, 0);
+	domain->priv = sh_domain;
 	return 0;
 }
 
 static void shmobile_iommu_domain_destroy(struct iommu_domain *domain)
 {
-	struct shmobile_iommu_priv *priv = domain->priv;
+	struct shmobile_iommu_domain *sh_domain = domain->priv;
 	int i;
 
 	for (i = 0; i < L1_LEN; i++) {
-		if (priv->l2[i].pgtable)
-			dma_pool_free(l2pool, priv->l2[i].pgtable,
-				      priv->l2[i].handle);
+		if (sh_domain->l2[i].pgtable)
+			dma_pool_free(l2pool, sh_domain->l2[i].pgtable,
+				      sh_domain->l2[i].handle);
 	}
-	dma_pool_free(l1pool, priv->l1.pgtable, priv->l1.handle);
-	kfree(priv);
+	dma_pool_free(l1pool, sh_domain->l1.pgtable, sh_domain->l1.handle);
+	kfree(sh_domain);
 	domain->priv = NULL;
 }
 
 static int shmobile_iommu_attach_device(struct iommu_domain *domain,
 					struct device *dev)
 {
-	struct shmobile_iommu_priv *priv = domain->priv;
+	struct shmobile_iommu_domain *sh_domain = domain->priv;
 	int ret = -EBUSY;
 
 	spin_lock(&lock);
-	if (attached != priv) {
+	if (attached != sh_domain) {
 		if (attached)
 			goto err;
-		atomic_set(&priv->active, 1);
-		ipmmu_tlb_set(ipmmu_access_device, priv->l1.handle, L1_SIZE,
+		atomic_set(&sh_domain->active, 1);
+		ipmmu_tlb_set(ipmmu_access_device, sh_domain->l1.handle, L1_SIZE,
 			      0);
 		wmb();
 		ipmmu_tlb_flush(ipmmu_access_device);
-		attached = priv;
+		attached = sh_domain;
 		num_attached_devices = 0;
 	}
 	num_attached_devices++;
@@ -121,10 +121,10 @@ err:
 static void shmobile_iommu_detach_device(struct iommu_domain *domain,
 					 struct device *dev)
 {
-	struct shmobile_iommu_priv *priv = domain->priv;
+	struct shmobile_iommu_domain *sh_domain = domain->priv;
 
 	spin_lock(&lock);
-	atomic_set(&priv->active, 0);
+	atomic_set(&sh_domain->active, 0);
 	num_attached_devices--;
 	if (!num_attached_devices) {
 		ipmmu_tlb_set(ipmmu_access_device, 0, 0, 0);
@@ -135,34 +135,34 @@ static void shmobile_iommu_detach_device(struct iommu_domain *domain,
 }
 
 static int
-l2alloc(struct shmobile_iommu_priv *priv, unsigned int l1index)
+l2alloc(struct shmobile_iommu_domain *sh_domain, unsigned int l1index)
 {
-	if (!priv->l2[l1index].pgtable) {
-		priv->l2[l1index].pgtable = dma_pool_alloc(l2pool, GFP_KERNEL,
-						&priv->l2[l1index].handle);
-		if (!priv->l2[l1index].pgtable)
+	if (!sh_domain->l2[l1index].pgtable) {
+		sh_domain->l2[l1index].pgtable = dma_pool_alloc(l2pool, GFP_KERNEL,
+						&sh_domain->l2[l1index].handle);
+		if (!sh_domain->l2[l1index].pgtable)
 			return -ENOMEM;
-		memset(priv->l2[l1index].pgtable, 0, L2_SIZE);
+		memset(sh_domain->l2[l1index].pgtable, 0, L2_SIZE);
 	}
-	priv->l1.pgtable[l1index] = priv->l2[l1index].handle | 0x1;
+	sh_domain->l1.pgtable[l1index] = sh_domain->l2[l1index].handle | 0x1;
 	return 0;
 }
 
 static void
-l2realfree(struct shmobile_iommu_priv_pgtable *l2)
+l2realfree(struct shmobile_iommu_domain_pgtable *l2)
 {
 	if (l2->pgtable)
 		dma_pool_free(l2pool, l2->pgtable, l2->handle);
 }
 
 static int
-l2free(struct shmobile_iommu_priv *priv, unsigned int l1index,
-	struct shmobile_iommu_priv_pgtable *l2)
+l2free(struct shmobile_iommu_domain *sh_domain, unsigned int l1index,
+	struct shmobile_iommu_domain_pgtable *l2)
 {
-	priv->l1.pgtable[l1index] = 0;
-	if (priv->l2[l1index].pgtable) {
-		*l2 = priv->l2[l1index];
-		priv->l2[l1index].pgtable = NULL;
+	sh_domain->l1.pgtable[l1index] = 0;
+	if (sh_domain->l2[l1index].pgtable) {
+		*l2 = sh_domain->l2[l1index];
+		sh_domain->l2[l1index].pgtable = NULL;
 	}
 	return 0;
 }
@@ -170,8 +170,8 @@ l2free(struct shmobile_iommu_priv *priv, unsigned int l1index,
 static int shmobile_iommu_map(struct iommu_domain *domain, unsigned long iova,
 			      phys_addr_t paddr, size_t size, int prot)
 {
-	struct shmobile_iommu_priv_pgtable l2 = { .pgtable = NULL };
-	struct shmobile_iommu_priv *priv = domain->priv;
+	struct shmobile_iommu_domain_pgtable l2 = { .pgtable = NULL };
+	struct shmobile_iommu_domain *sh_domain = domain->priv;
 	unsigned int l1index, l2index, i;
 	int ret;
 
@@ -179,34 +179,34 @@ static int shmobile_iommu_map(struct iommu_domain *domain, unsigned long iova,
 	switch (size) {
 	case 0x1000:
 		l2index = (iova >> 12) & 0xff;
-		spin_lock(&priv->map_lock);
-		ret = l2alloc(priv, l1index);
+		spin_lock(&sh_domain->map_lock);
+		ret = l2alloc(sh_domain, l1index);
 		if (!ret)
-			priv->l2[l1index].pgtable[l2index] = paddr | 0xff2;
-		spin_unlock(&priv->map_lock);
+			sh_domain->l2[l1index].pgtable[l2index] = paddr | 0xff2;
+		spin_unlock(&sh_domain->map_lock);
 		break;
 	case 0x10000:
 		l2index = (iova >> 12) & 0xf0;
-		spin_lock(&priv->map_lock);
-		ret = l2alloc(priv, l1index);
+		spin_lock(&sh_domain->map_lock);
+		ret = l2alloc(sh_domain, l1index);
 		if (!ret) {
 			for (i = 0; i < 0x10; i++)
-				priv->l2[l1index].pgtable[l2index + i] =
+				sh_domain->l2[l1index].pgtable[l2index + i] =
 					paddr | 0xff1;
 		}
-		spin_unlock(&priv->map_lock);
+		spin_unlock(&sh_domain->map_lock);
 		break;
 	case 0x100000:
-		spin_lock(&priv->map_lock);
-		l2free(priv, l1index, &l2);
-		priv->l1.pgtable[l1index] = paddr | 0xc02;
-		spin_unlock(&priv->map_lock);
+		spin_lock(&sh_domain->map_lock);
+		l2free(sh_domain, l1index, &l2);
+		sh_domain->l1.pgtable[l1index] = paddr | 0xc02;
+		spin_unlock(&sh_domain->map_lock);
 		ret = 0;
 		break;
 	default:
 		ret = -EINVAL;
 	}
-	if (!ret && atomic_read(&priv->active)) {
+	if (!ret && atomic_read(&sh_domain->active)) {
 		wmb();
 		ipmmu_tlb_flush(ipmmu_access_device);
 		l2realfree(&l2);
@@ -217,40 +217,40 @@ static int shmobile_iommu_map(struct iommu_domain *domain, unsigned long iova,
 static size_t shmobile_iommu_unmap(struct iommu_domain *domain,
 				   unsigned long iova, size_t size)
 {
-	struct shmobile_iommu_priv_pgtable l2 = { .pgtable = NULL };
-	struct shmobile_iommu_priv *priv = domain->priv;
+	struct shmobile_iommu_domain_pgtable l2 = { .pgtable = NULL };
+	struct shmobile_iommu_domain *sh_domain = domain->priv;
 	unsigned int l1index, l2index, i;
 	uint32_t l2entry = 0;
 	size_t ret = 0;
 
 	l1index = iova >> 20;
 	if (!(iova & 0xFFFFF) && size >= 0x100000) {
-		spin_lock(&priv->map_lock);
-		l2free(priv, l1index, &l2);
-		spin_unlock(&priv->map_lock);
+		spin_lock(&sh_domain->map_lock);
+		l2free(sh_domain, l1index, &l2);
+		spin_unlock(&sh_domain->map_lock);
 		ret = 0x100000;
 		goto done;
 	}
 	l2index = (iova >> 12) & 0xff;
-	spin_lock(&priv->map_lock);
-	if (priv->l2[l1index].pgtable)
-		l2entry = priv->l2[l1index].pgtable[l2index];
+	spin_lock(&sh_domain->map_lock);
+	if (sh_domain->l2[l1index].pgtable)
+		l2entry = sh_domain->l2[l1index].pgtable[l2index];
 	switch (l2entry & 3) {
 	case 1:
 		if (l2index & 0xf)
 			break;
 		for (i = 0; i < 0x10; i++)
-			priv->l2[l1index].pgtable[l2index + i] = 0;
+			sh_domain->l2[l1index].pgtable[l2index + i] = 0;
 		ret = 0x10000;
 		break;
 	case 2:
-		priv->l2[l1index].pgtable[l2index] = 0;
+		sh_domain->l2[l1index].pgtable[l2index] = 0;
 		ret = 0x1000;
 		break;
 	}
-	spin_unlock(&priv->map_lock);
+	spin_unlock(&sh_domain->map_lock);
 done:
-	if (ret && atomic_read(&priv->active)) {
+	if (ret && atomic_read(&sh_domain->active)) {
 		wmb();
 		ipmmu_tlb_flush(ipmmu_access_device);
 		l2realfree(&l2);
@@ -261,18 +261,18 @@ done:
 static phys_addr_t shmobile_iommu_iova_to_phys(struct iommu_domain *domain,
 					       unsigned long iova)
 {
-	struct shmobile_iommu_priv *priv = domain->priv;
+	struct shmobile_iommu_domain *sh_domain = domain->priv;
 	uint32_t l1entry = 0, l2entry = 0;
 	unsigned int l1index, l2index;
 
 	l1index = iova >> 20;
 	l2index = (iova >> 12) & 0xff;
-	spin_lock(&priv->map_lock);
-	if (priv->l2[l1index].pgtable)
-		l2entry = priv->l2[l1index].pgtable[l2index];
+	spin_lock(&sh_domain->map_lock);
+	if (sh_domain->l2[l1index].pgtable)
+		l2entry = sh_domain->l2[l1index].pgtable[l2index];
 	else
-		l1entry = priv->l1.pgtable[l1index];
-	spin_unlock(&priv->map_lock);
+		l1entry = sh_domain->l1.pgtable[l1index];
+	spin_unlock(&sh_domain->map_lock);
 	switch (l2entry & 3) {
 	case 1:
 		return (l2entry & ~0xffff) | (iova & 0xffff);
-- 
1.7.8.6

