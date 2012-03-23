Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112Ab2CWXzJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 19:55:09 -0400
Received: from mga07.intel.com ([143.182.124.22]:47751 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754903Ab2CWXzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 19:55:07 -0400
Subject: Re: ioatdma: Boot process hangs then reboots when using Xen + Linux
 3.2
From: Dan Williams <dan.j.williams@intel.com>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: Thomas Goirand <zigo@debian.org>, xen-devel@lists.xensource.com,
        Dave Jiang <dave.jiang@intel.com>,
        pkg-xen-devel@lists.alioth.debian.org,
        Maciej Sosnowski <maciej.sosnowski@intel.com>,
        linux-kernel@vger.kernel.org, William Dauchy <wdauchy@gmail.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>
Date: Fri, 23 Mar 2012 16:55:02 -0700
In-Reply-To: <20120311220648.GA8120@burratino>
References: <20120302055715.GA692@burratino>
	 <CABE8wwt8Lngy=-iL7QGCofy0nW5-q4VJDS_ovEr96fGdYm72ew@mail.gmail.com>
	 <20120302162159.GB31683@wavehammer.waldi.eu.org>
	 <CABE8wwtrMEAMw3sJgb8XWQWn_N=YOPzhNbLL0kzMKLhv7xt5=A@mail.gmail.com>
	 <20120302175719.GA1468@wavehammer.waldi.eu.org>
	 <CABE8wwvd-R1VkyFL-eZYDB9O05zyWkVQ8pXuMb8GcdAW=5qT3A@mail.gmail.com>
	 <4F54DB1F.3080000@debian.org>
	 <CABE8wwtOwgiYwb-_g-3Fg_QH6ph7LEPdkcOff94inDFvs9kwxA@mail.gmail.com>
	 <4F55D6F6.2040906@debian.org>
	 <CABE8wwsPA2PUx45EbY3w3BAHaHbUMWo7+giK=uU8gx9mbBkRpQ@mail.gmail.com>
	 <20120311220648.GA8120@burratino>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15)
Content-Transfer-Encoding: 7bit
Message-ID: <1332546904.23830.8.camel@ultramagnus.opencreations.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: ioat: fix size of 'completion' for Xen

From: Dan Williams <dan.j.williams@intel.com>

Starting with v3.2 Jonathan reports that Xen crashes loading the ioatdma
driver.  A debug run shows:

  ioatdma 0000:00:16.4: desc[0]: (0x300cc7000->0x300cc7040) cookie: 0 flags: 0x2 ctl: 0x29 (op: 0 int_en: 1 compl: 1)
  ...
  ioatdma 0000:00:16.4: ioat_get_current_completion: phys_complete: 0xcc7000

...which shows that in this environment GFP_KERNEL memory may be backed
by a 64-bit dma address.  This breaks the driver's assumption that an
unsigned long should be able to contain the physical address for
descriptor memory.  Switch to dma_addr_t which beyond being the right
size, is the true type for the data i.e. an io-virtual address
indicating the engine's last processed descriptor.

[stable: 3.2+]
Cc: <stable@vger.kernel.org>
Reported-by: Jonathan Nieder <jrnieder@gmail.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

On Sun, 2012-03-11 at 17:06 -0500, Jonathan Nieder wrote:
Hi Dan,
> 
> Dan Williams wrote:
> 
> > Before you had mentioned that non-xen 32-bit builds don't fail.  Can
> > you send me the .config from those two cases (offlist if they are too
> > large)?
> 
> The failing and non-failing kernels are identical.  It is the
> environment in which they are run that is different.
> 
> Running the kernel on bare metal works fine, while booting as a dom0
> from the xen hypervisor triggers the assertion failure.[1]
> 
> .config: [2]
> 
> Hope that helps,
> Jonathan

Thanks for the debug help, does this patch fix the issue for you?

 drivers/dma/ioat/dma.c    |   16 ++++++++--------
 drivers/dma/ioat/dma.h    |    6 +++---
 drivers/dma/ioat/dma_v2.c |    8 ++++----
 drivers/dma/ioat/dma_v3.c |    8 ++++----
 4 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/dma/ioat/dma.c b/drivers/dma/ioat/dma.c
index a4d6cb0..6595180 100644
--- a/drivers/dma/ioat/dma.c
+++ b/drivers/dma/ioat/dma.c
@@ -548,9 +548,9 @@ void ioat_dma_unmap(struct ioat_chan_common *chan, enum dma_ctrl_flags flags,
 			   PCI_DMA_TODEVICE, flags, 0);
 }
 
-unsigned long ioat_get_current_completion(struct ioat_chan_common *chan)
+dma_addr_t ioat_get_current_completion(struct ioat_chan_common *chan)
 {
-	unsigned long phys_complete;
+	dma_addr_t phys_complete;
 	u64 completion;
 
 	completion = *chan->completion;
@@ -571,7 +571,7 @@ unsigned long ioat_get_current_completion(struct ioat_chan_common *chan)
 }
 
 bool ioat_cleanup_preamble(struct ioat_chan_common *chan,
-			   unsigned long *phys_complete)
+			   dma_addr_t *phys_complete)
 {
 	*phys_complete = ioat_get_current_completion(chan);
 	if (*phys_complete == chan->last_completion)
@@ -582,14 +582,14 @@ bool ioat_cleanup_preamble(struct ioat_chan_common *chan,
 	return true;
 }
 
-static void __cleanup(struct ioat_dma_chan *ioat, unsigned long phys_complete)
+static void __cleanup(struct ioat_dma_chan *ioat, dma_addr_t phys_complete)
 {
 	struct ioat_chan_common *chan = &ioat->base;
 	struct list_head *_desc, *n;
 	struct dma_async_tx_descriptor *tx;
 
-	dev_dbg(to_dev(chan), "%s: phys_complete: %lx\n",
-		 __func__, phys_complete);
+	dev_dbg(to_dev(chan), "%s: phys_complete: %llx\n",
+		 __func__, (unsigned long long) phys_complete);
 	list_for_each_safe(_desc, n, &ioat->used_desc) {
 		struct ioat_desc_sw *desc;
 
@@ -655,7 +655,7 @@ static void __cleanup(struct ioat_dma_chan *ioat, unsigned long phys_complete)
 static void ioat1_cleanup(struct ioat_dma_chan *ioat)
 {
 	struct ioat_chan_common *chan = &ioat->base;
-	unsigned long phys_complete;
+	dma_addr_t phys_complete;
 
 	prefetch(chan->completion);
 
@@ -701,7 +701,7 @@ static void ioat1_timer_event(unsigned long data)
 		mod_timer(&chan->timer, jiffies + COMPLETION_TIMEOUT);
 		spin_unlock_bh(&ioat->desc_lock);
 	} else if (test_bit(IOAT_COMPLETION_PENDING, &chan->state)) {
-		unsigned long phys_complete;
+		dma_addr_t phys_complete;
 
 		spin_lock_bh(&ioat->desc_lock);
 		/* if we haven't made progress and we have already
diff --git a/drivers/dma/ioat/dma.h b/drivers/dma/ioat/dma.h
index 5216c8a..8bebddd 100644
--- a/drivers/dma/ioat/dma.h
+++ b/drivers/dma/ioat/dma.h
@@ -88,7 +88,7 @@ struct ioatdma_device {
 struct ioat_chan_common {
 	struct dma_chan common;
 	void __iomem *reg_base;
-	unsigned long last_completion;
+	dma_addr_t last_completion;
 	spinlock_t cleanup_lock;
 	dma_cookie_t completed_cookie;
 	unsigned long state;
@@ -333,7 +333,7 @@ int __devinit ioat_dma_self_test(struct ioatdma_device *device);
 void __devexit ioat_dma_remove(struct ioatdma_device *device);
 struct dca_provider * __devinit ioat_dca_init(struct pci_dev *pdev,
 					      void __iomem *iobase);
-unsigned long ioat_get_current_completion(struct ioat_chan_common *chan);
+dma_addr_t ioat_get_current_completion(struct ioat_chan_common *chan);
 void ioat_init_channel(struct ioatdma_device *device,
 		       struct ioat_chan_common *chan, int idx);
 enum dma_status ioat_dma_tx_status(struct dma_chan *c, dma_cookie_t cookie,
@@ -341,7 +341,7 @@ enum dma_status ioat_dma_tx_status(struct dma_chan *c, dma_cookie_t cookie,
 void ioat_dma_unmap(struct ioat_chan_common *chan, enum dma_ctrl_flags flags,
 		    size_t len, struct ioat_dma_descriptor *hw);
 bool ioat_cleanup_preamble(struct ioat_chan_common *chan,
-			   unsigned long *phys_complete);
+			   dma_addr_t *phys_complete);
 void ioat_kobject_add(struct ioatdma_device *device, struct kobj_type *type);
 void ioat_kobject_del(struct ioatdma_device *device);
 extern const struct sysfs_ops ioat_sysfs_ops;
diff --git a/drivers/dma/ioat/dma_v2.c b/drivers/dma/ioat/dma_v2.c
index 5d65f83..cb8864d 100644
--- a/drivers/dma/ioat/dma_v2.c
+++ b/drivers/dma/ioat/dma_v2.c
@@ -126,7 +126,7 @@ static void ioat2_start_null_desc(struct ioat2_dma_chan *ioat)
 	spin_unlock_bh(&ioat->prep_lock);
 }
 
-static void __cleanup(struct ioat2_dma_chan *ioat, unsigned long phys_complete)
+static void __cleanup(struct ioat2_dma_chan *ioat, dma_addr_t phys_complete)
 {
 	struct ioat_chan_common *chan = &ioat->base;
 	struct dma_async_tx_descriptor *tx;
@@ -178,7 +178,7 @@ static void __cleanup(struct ioat2_dma_chan *ioat, unsigned long phys_complete)
 static void ioat2_cleanup(struct ioat2_dma_chan *ioat)
 {
 	struct ioat_chan_common *chan = &ioat->base;
-	unsigned long phys_complete;
+	dma_addr_t phys_complete;
 
 	spin_lock_bh(&chan->cleanup_lock);
 	if (ioat_cleanup_preamble(chan, &phys_complete))
@@ -259,7 +259,7 @@ int ioat2_reset_sync(struct ioat_chan_common *chan, unsigned long tmo)
 static void ioat2_restart_channel(struct ioat2_dma_chan *ioat)
 {
 	struct ioat_chan_common *chan = &ioat->base;
-	unsigned long phys_complete;
+	dma_addr_t phys_complete;
 
 	ioat2_quiesce(chan, 0);
 	if (ioat_cleanup_preamble(chan, &phys_complete))
@@ -274,7 +274,7 @@ void ioat2_timer_event(unsigned long data)
 	struct ioat_chan_common *chan = &ioat->base;
 
 	if (test_bit(IOAT_COMPLETION_PENDING, &chan->state)) {
-		unsigned long phys_complete;
+		dma_addr_t phys_complete;
 		u64 status;
 
 		status = ioat_chansts(chan);
diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index f519c93..2dbf32b 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -256,7 +256,7 @@ static bool desc_has_ext(struct ioat_ring_ent *desc)
  * The difference from the dma_v2.c __cleanup() is that this routine
  * handles extended descriptors and dma-unmapping raid operations.
  */
-static void __cleanup(struct ioat2_dma_chan *ioat, unsigned long phys_complete)
+static void __cleanup(struct ioat2_dma_chan *ioat, dma_addr_t phys_complete)
 {
 	struct ioat_chan_common *chan = &ioat->base;
 	struct ioat_ring_ent *desc;
@@ -314,7 +314,7 @@ static void __cleanup(struct ioat2_dma_chan *ioat, unsigned long phys_complete)
 static void ioat3_cleanup(struct ioat2_dma_chan *ioat)
 {
 	struct ioat_chan_common *chan = &ioat->base;
-	unsigned long phys_complete;
+	dma_addr_t phys_complete;
 
 	spin_lock_bh(&chan->cleanup_lock);
 	if (ioat_cleanup_preamble(chan, &phys_complete))
@@ -333,7 +333,7 @@ static void ioat3_cleanup_event(unsigned long data)
 static void ioat3_restart_channel(struct ioat2_dma_chan *ioat)
 {
 	struct ioat_chan_common *chan = &ioat->base;
-	unsigned long phys_complete;
+	dma_addr_t phys_complete;
 
 	ioat2_quiesce(chan, 0);
 	if (ioat_cleanup_preamble(chan, &phys_complete))
@@ -348,7 +348,7 @@ static void ioat3_timer_event(unsigned long data)
 	struct ioat_chan_common *chan = &ioat->base;
 
 	if (test_bit(IOAT_COMPLETION_PENDING, &chan->state)) {
-		unsigned long phys_complete;
+		dma_addr_t phys_complete;
 		u64 status;
 
 		status = ioat_chansts(chan);



