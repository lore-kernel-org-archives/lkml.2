Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932900Ab2GMBYY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 21:24:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:44142 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753271Ab2GMBYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 21:24:19 -0400
Message-ID: <1342142646.25597.367.camel@deadeye.wl.decadent.org.uk>
Subject: Re: Linux 3.2.23
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
        stable@vger.kernel.org, lwn@lwn.net
Date: Fri, 13 Jul 2012 02:24:06 +0100
In-Reply-To: <1342142571.25597.366.camel@deadeye.wl.decadent.org.uk>
References: <1342142571.25597.366.camel@deadeye.wl.decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-RlaR+Kr5l+wq61ic9Bpv"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-RlaR+Kr5l+wq61ic9Bpv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

diff --git a/Makefile b/Makefile
index 9a7d921..40d1e3b 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION =3D 3
 PATCHLEVEL =3D 2
-SUBLEVEL =3D 22
+SUBLEVEL =3D 23
 EXTRAVERSION =3D
 NAME =3D Saber-toothed Squirrel
=20
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index e10e59a..1d1710e 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -471,9 +471,7 @@ static DEFINE_PER_CPU(struct clock_event_device, percpu=
_clockevent);
 static void ipi_timer(void)
 {
 	struct clock_event_device *evt =3D &__get_cpu_var(percpu_clockevent);
-	irq_enter();
 	evt->event_handler(evt);
-	irq_exit();
 }
=20
 #ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
@@ -572,7 +570,9 @@ void handle_IPI(int ipinr, struct pt_regs *regs)
=20
 	switch (ipinr) {
 	case IPI_TIMER:
+		irq_enter();
 		ipi_timer();
+		irq_exit();
 		break;
=20
 	case IPI_RESCHEDULE:
@@ -580,15 +580,21 @@ void handle_IPI(int ipinr, struct pt_regs *regs)
 		break;
=20
 	case IPI_CALL_FUNC:
+		irq_enter();
 		generic_smp_call_function_interrupt();
+		irq_exit();
 		break;
=20
 	case IPI_CALL_FUNC_SINGLE:
+		irq_enter();
 		generic_smp_call_function_single_interrupt();
+		irq_exit();
 		break;
=20
 	case IPI_CPU_STOP:
+		irq_enter();
 		ipi_cpu_stop(cpu);
+		irq_exit();
 		break;
=20
 	default:
diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/boo=
k3s_hv_rmhandlers.S
index 44d8829..5e8dc08 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -763,7 +763,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_ARCH_201)
 	lwz	r3,VCORE_NAPPING_THREADS(r5)
 	lwz	r4,VCPU_PTID(r9)
 	li	r0,1
-	sldi	r0,r0,r4
+	sld	r0,r0,r4
 	andc.	r3,r3,r0		/* no sense IPI'ing ourselves */
 	beq	43f
 	mulli	r4,r4,PACA_SIZE		/* get paca for thread 0 */
diff --git a/arch/powerpc/xmon/xmon.c b/arch/powerpc/xmon/xmon.c
index 03a217a..b7e63d8 100644
--- a/arch/powerpc/xmon/xmon.c
+++ b/arch/powerpc/xmon/xmon.c
@@ -975,7 +975,7 @@ static int cpu_cmd(void)
 		/* print cpus waiting or in xmon */
 		printf("cpus stopped:");
 		count =3D 0;
-		for (cpu =3D 0; cpu < NR_CPUS; ++cpu) {
+		for_each_possible_cpu(cpu) {
 			if (cpumask_test_cpu(cpu, &cpus_in_xmon)) {
 				if (count =3D=3D 0)
 					printf(" %x", cpu);
diff --git a/drivers/block/umem.c b/drivers/block/umem.c
index aa27120..9a72277 100644
--- a/drivers/block/umem.c
+++ b/drivers/block/umem.c
@@ -513,6 +513,44 @@ static void process_page(unsigned long data)
 	}
 }
=20
+struct mm_plug_cb {
+	struct blk_plug_cb cb;
+	struct cardinfo *card;
+};
+
+static void mm_unplug(struct blk_plug_cb *cb)
+{
+	struct mm_plug_cb *mmcb =3D container_of(cb, struct mm_plug_cb, cb);
+
+	spin_lock_irq(&mmcb->card->lock);
+	activate(mmcb->card);
+	spin_unlock_irq(&mmcb->card->lock);
+	kfree(mmcb);
+}
+
+static int mm_check_plugged(struct cardinfo *card)
+{
+	struct blk_plug *plug =3D current->plug;
+	struct mm_plug_cb *mmcb;
+
+	if (!plug)
+		return 0;
+
+	list_for_each_entry(mmcb, &plug->cb_list, cb.list) {
+		if (mmcb->cb.callback =3D=3D mm_unplug && mmcb->card =3D=3D card)
+			return 1;
+	}
+	/* Not currently on the callback list */
+	mmcb =3D kmalloc(sizeof(*mmcb), GFP_ATOMIC);
+	if (!mmcb)
+		return 0;
+
+	mmcb->card =3D card;
+	mmcb->cb.callback =3D mm_unplug;
+	list_add(&mmcb->cb.list, &plug->cb_list);
+	return 1;
+}
+
 static void mm_make_request(struct request_queue *q, struct bio *bio)
 {
 	struct cardinfo *card =3D q->queuedata;
@@ -523,6 +561,8 @@ static void mm_make_request(struct request_queue *q, st=
ruct bio *bio)
 	*card->biotail =3D bio;
 	bio->bi_next =3D NULL;
 	card->biotail =3D &bio->bi_next;
+	if (bio->bi_rw & REQ_SYNC || !mm_check_plugged(card))
+		activate(card);
 	spin_unlock_irq(&card->lock);
=20
 	return;
diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dm=
a.c
index c4da951..ca67338 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1890,6 +1890,27 @@ ips_ping_for_i915_load(void)
 	}
 }
=20
+static void i915_kick_out_firmware_fb(struct drm_i915_private *dev_priv)
+{
+	struct apertures_struct *ap;
+	struct pci_dev *pdev =3D dev_priv->dev->pdev;
+	bool primary;
+
+	ap =3D alloc_apertures(1);
+	if (!ap)
+		return;
+
+	ap->ranges[0].base =3D dev_priv->dev->agp->base;
+	ap->ranges[0].size =3D
+		dev_priv->mm.gtt->gtt_mappable_entries << PAGE_SHIFT;
+	primary =3D
+		pdev->resource[PCI_ROM_RESOURCE].flags & IORESOURCE_ROM_SHADOW;
+
+	remove_conflicting_framebuffers(ap, "inteldrmfb", primary);
+
+	kfree(ap);
+}
+
 /**
  * i915_driver_load - setup chip and create an initial config
  * @dev: DRM device
@@ -1927,6 +1948,15 @@ int i915_driver_load(struct drm_device *dev, unsigne=
d long flags)
 		goto free_priv;
 	}
=20
+	dev_priv->mm.gtt =3D intel_gtt_get();
+	if (!dev_priv->mm.gtt) {
+		DRM_ERROR("Failed to initialize GTT\n");
+		ret =3D -ENODEV;
+		goto put_bridge;
+	}
+
+	i915_kick_out_firmware_fb(dev_priv);
+
 	/* overlay on gen2 is broken and can't address above 1G */
 	if (IS_GEN2(dev))
 		dma_set_coherent_mask(&dev->pdev->dev, DMA_BIT_MASK(30));
@@ -1950,13 +1980,6 @@ int i915_driver_load(struct drm_device *dev, unsigne=
d long flags)
 		goto put_bridge;
 	}
=20
-	dev_priv->mm.gtt =3D intel_gtt_get();
-	if (!dev_priv->mm.gtt) {
-		DRM_ERROR("Failed to initialize GTT\n");
-		ret =3D -ENODEV;
-		goto out_rmmap;
-	}
-
 	agp_size =3D dev_priv->mm.gtt->gtt_mappable_entries << PAGE_SHIFT;
=20
 	dev_priv->mm.gtt_mapping =3D
diff --git a/drivers/md/persistent-data/dm-space-map-checker.c b/drivers/md=
/persistent-data/dm-space-map-checker.c
index 50ed53b..fc90c11 100644
--- a/drivers/md/persistent-data/dm-space-map-checker.c
+++ b/drivers/md/persistent-data/dm-space-map-checker.c
@@ -8,6 +8,7 @@
=20
 #include <linux/device-mapper.h>
 #include <linux/export.h>
+#include <linux/vmalloc.h>
=20
 #ifdef CONFIG_DM_DEBUG_SPACE_MAPS
=20
@@ -89,13 +90,23 @@ static int ca_create(struct count_array *ca, struct dm_=
space_map *sm)
=20
 	ca->nr =3D nr_blocks;
 	ca->nr_free =3D nr_blocks;
-	ca->counts =3D kzalloc(sizeof(*ca->counts) * nr_blocks, GFP_KERNEL);
-	if (!ca->counts)
-		return -ENOMEM;
+
+	if (!nr_blocks)
+		ca->counts =3D NULL;
+	else {
+		ca->counts =3D vzalloc(sizeof(*ca->counts) * nr_blocks);
+		if (!ca->counts)
+			return -ENOMEM;
+	}
=20
 	return 0;
 }
=20
+static void ca_destroy(struct count_array *ca)
+{
+	vfree(ca->counts);
+}
+
 static int ca_load(struct count_array *ca, struct dm_space_map *sm)
 {
 	int r;
@@ -126,12 +137,14 @@ static int ca_load(struct count_array *ca, struct dm_=
space_map *sm)
 static int ca_extend(struct count_array *ca, dm_block_t extra_blocks)
 {
 	dm_block_t nr_blocks =3D ca->nr + extra_blocks;
-	uint32_t *counts =3D kzalloc(sizeof(*counts) * nr_blocks, GFP_KERNEL);
+	uint32_t *counts =3D vzalloc(sizeof(*counts) * nr_blocks);
 	if (!counts)
 		return -ENOMEM;
=20
-	memcpy(counts, ca->counts, sizeof(*counts) * ca->nr);
-	kfree(ca->counts);
+	if (ca->counts) {
+		memcpy(counts, ca->counts, sizeof(*counts) * ca->nr);
+		ca_destroy(ca);
+	}
 	ca->nr =3D nr_blocks;
 	ca->nr_free +=3D extra_blocks;
 	ca->counts =3D counts;
@@ -151,11 +164,6 @@ static int ca_commit(struct count_array *old, struct c=
ount_array *new)
 	return 0;
 }
=20
-static void ca_destroy(struct count_array *ca)
-{
-	kfree(ca->counts);
-}
-
 /*----------------------------------------------------------------*/
=20
 struct sm_checker {
@@ -343,25 +351,25 @@ struct dm_space_map *dm_sm_checker_create(struct dm_s=
pace_map *sm)
 	int r;
 	struct sm_checker *smc;
=20
-	if (!sm)
-		return NULL;
+	if (IS_ERR_OR_NULL(sm))
+		return ERR_PTR(-EINVAL);
=20
 	smc =3D kmalloc(sizeof(*smc), GFP_KERNEL);
 	if (!smc)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
=20
 	memcpy(&smc->sm, &ops_, sizeof(smc->sm));
 	r =3D ca_create(&smc->old_counts, sm);
 	if (r) {
 		kfree(smc);
-		return NULL;
+		return ERR_PTR(r);
 	}
=20
 	r =3D ca_create(&smc->counts, sm);
 	if (r) {
 		ca_destroy(&smc->old_counts);
 		kfree(smc);
-		return NULL;
+		return ERR_PTR(r);
 	}
=20
 	smc->real_sm =3D sm;
@@ -371,7 +379,7 @@ struct dm_space_map *dm_sm_checker_create(struct dm_spa=
ce_map *sm)
 		ca_destroy(&smc->counts);
 		ca_destroy(&smc->old_counts);
 		kfree(smc);
-		return NULL;
+		return ERR_PTR(r);
 	}
=20
 	r =3D ca_commit(&smc->old_counts, &smc->counts);
@@ -379,7 +387,7 @@ struct dm_space_map *dm_sm_checker_create(struct dm_spa=
ce_map *sm)
 		ca_destroy(&smc->counts);
 		ca_destroy(&smc->old_counts);
 		kfree(smc);
-		return NULL;
+		return ERR_PTR(r);
 	}
=20
 	return &smc->sm;
@@ -391,25 +399,25 @@ struct dm_space_map *dm_sm_checker_create_fresh(struc=
t dm_space_map *sm)
 	int r;
 	struct sm_checker *smc;
=20
-	if (!sm)
-		return NULL;
+	if (IS_ERR_OR_NULL(sm))
+		return ERR_PTR(-EINVAL);
=20
 	smc =3D kmalloc(sizeof(*smc), GFP_KERNEL);
 	if (!smc)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
=20
 	memcpy(&smc->sm, &ops_, sizeof(smc->sm));
 	r =3D ca_create(&smc->old_counts, sm);
 	if (r) {
 		kfree(smc);
-		return NULL;
+		return ERR_PTR(r);
 	}
=20
 	r =3D ca_create(&smc->counts, sm);
 	if (r) {
 		ca_destroy(&smc->old_counts);
 		kfree(smc);
-		return NULL;
+		return ERR_PTR(r);
 	}
=20
 	smc->real_sm =3D sm;
diff --git a/drivers/md/persistent-data/dm-space-map-disk.c b/drivers/md/pe=
rsistent-data/dm-space-map-disk.c
index fc469ba..3d0ed53 100644
--- a/drivers/md/persistent-data/dm-space-map-disk.c
+++ b/drivers/md/persistent-data/dm-space-map-disk.c
@@ -290,7 +290,16 @@ struct dm_space_map *dm_sm_disk_create(struct dm_trans=
action_manager *tm,
 				       dm_block_t nr_blocks)
 {
 	struct dm_space_map *sm =3D dm_sm_disk_create_real(tm, nr_blocks);
-	return dm_sm_checker_create_fresh(sm);
+	struct dm_space_map *smc;
+
+	if (IS_ERR_OR_NULL(sm))
+		return sm;
+
+	smc =3D dm_sm_checker_create_fresh(sm);
+	if (IS_ERR(smc))
+		dm_sm_destroy(sm);
+
+	return smc;
 }
 EXPORT_SYMBOL_GPL(dm_sm_disk_create);
=20
diff --git a/drivers/md/persistent-data/dm-transaction-manager.c b/drivers/=
md/persistent-data/dm-transaction-manager.c
index 6f8d387..ba54aac 100644
--- a/drivers/md/persistent-data/dm-transaction-manager.c
+++ b/drivers/md/persistent-data/dm-transaction-manager.c
@@ -138,6 +138,9 @@ EXPORT_SYMBOL_GPL(dm_tm_create_non_blocking_clone);
=20
 void dm_tm_destroy(struct dm_transaction_manager *tm)
 {
+	if (!tm->is_clone)
+		wipe_shadow_table(tm);
+
 	kfree(tm);
 }
 EXPORT_SYMBOL_GPL(dm_tm_destroy);
@@ -342,8 +345,10 @@ static int dm_tm_create_internal(struct dm_block_manag=
er *bm,
 		}
=20
 		*sm =3D dm_sm_checker_create(inner);
-		if (!*sm)
+		if (IS_ERR(*sm)) {
+			r =3D PTR_ERR(*sm);
 			goto bad2;
+		}
=20
 	} else {
 		r =3D dm_bm_write_lock(dm_tm_get_bm(*tm), sb_location,
@@ -362,8 +367,10 @@ static int dm_tm_create_internal(struct dm_block_manag=
er *bm,
 		}
=20
 		*sm =3D dm_sm_checker_create(inner);
-		if (!*sm)
+		if (IS_ERR(*sm)) {
+			r =3D PTR_ERR(*sm);
 			goto bad2;
+		}
 	}
=20
 	return 0;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index b219449..7a9eef6 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1919,7 +1919,7 @@ static void fix_read_error(struct r10conf *conf, stru=
ct mddev *mddev, struct r10
 			if (r10_sync_page_io(rdev,
 					     r10_bio->devs[sl].addr +
 					     sect,
-					     s<<9, conf->tmppage, WRITE)
+					     s, conf->tmppage, WRITE)
 			    =3D=3D 0) {
 				/* Well, this device is dead */
 				printk(KERN_NOTICE
@@ -1956,7 +1956,7 @@ static void fix_read_error(struct r10conf *conf, stru=
ct mddev *mddev, struct r10
 			switch (r10_sync_page_io(rdev,
 					     r10_bio->devs[sl].addr +
 					     sect,
-					     s<<9, conf->tmppage,
+					     s, conf->tmppage,
 						 READ)) {
 			case 0:
 				/* Well, this device is dead */
@@ -2119,7 +2119,7 @@ read_more:
 	rdev =3D conf->mirrors[mirror].rdev;
 	printk_ratelimited(
 		KERN_ERR
-		"md/raid10:%s: %s: redirecting"
+		"md/raid10:%s: %s: redirecting "
 		"sector %llu to another mirror\n",
 		mdname(mddev),
 		bdevname(rdev->bdev, b),
@@ -2436,6 +2436,12 @@ static sector_t sync_request(struct mddev *mddev, se=
ctor_t sector_nr,
 			/* want to reconstruct this device */
 			rb2 =3D r10_bio;
 			sect =3D raid10_find_virt(conf, sector_nr, i);
+			if (sect >=3D mddev->resync_max_sectors) {
+				/* last stripe is not complete - don't
+				 * try to recover this sector.
+				 */
+				continue;
+			}
 			/* Unless we are doing a full sync, we only need
 			 * to recover the block if it is set in the bitmap
 			 */
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 858fdbb..6ba4954 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -542,6 +542,12 @@ static void ops_run_io(struct stripe_head *sh, struct =
stripe_head_state *s)
 					 * a chance*/
 					md_check_recovery(conf->mddev);
 				}
+				/*
+				 * Because md_wait_for_blocked_rdev
+				 * will dec nr_pending, we must
+				 * increment it first.
+				 */
+				atomic_inc(&rdev->nr_pending);
 				md_wait_for_blocked_rdev(rdev, conf->mddev);
 			} else {
 				/* Acknowledged bad block - skip the write */
@@ -3621,7 +3627,6 @@ static int chunk_aligned_read(struct mddev *mddev, st=
ruct bio * raid_bio)
 		raid_bio->bi_next =3D (void*)rdev;
 		align_bi->bi_bdev =3D  rdev->bdev;
 		align_bi->bi_flags &=3D ~(1 << BIO_SEG_VALID);
-		align_bi->bi_sector +=3D rdev->data_offset;
=20
 		if (!bio_fits_rdev(align_bi) ||
 		    is_badblock(rdev, align_bi->bi_sector, align_bi->bi_size>>9,
@@ -3632,6 +3637,9 @@ static int chunk_aligned_read(struct mddev *mddev, st=
ruct bio * raid_bio)
 			return 0;
 		}
=20
+		/* No reshape active, so we can trust rdev->data_offset */
+		align_bi->bi_sector +=3D rdev->data_offset;
+
 		spin_lock_irq(&conf->device_lock);
 		wait_event_lock_irq(conf->wait_for_stripe,
 				    conf->quiesce =3D=3D 0,
diff --git a/drivers/mtd/nand/cafe_nand.c b/drivers/mtd/nand/cafe_nand.c
index 72d3f23..68ecf48 100644
--- a/drivers/mtd/nand/cafe_nand.c
+++ b/drivers/mtd/nand/cafe_nand.c
@@ -102,7 +102,7 @@ static const char *part_probes[] =3D { "cmdlinepart", "=
RedBoot", NULL };
 static int cafe_device_ready(struct mtd_info *mtd)
 {
 	struct cafe_priv *cafe =3D mtd->priv;
-	int result =3D !!(cafe_readl(cafe, NAND_STATUS) | 0x40000000);
+	int result =3D !!(cafe_readl(cafe, NAND_STATUS) & 0x40000000);
 	uint32_t irqs =3D cafe_readl(cafe, NAND_IRQ);
=20
 	cafe_writel(cafe, irqs, NAND_IRQ);
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_mai=
n.c
index f65e0b9..1a88e38 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -77,6 +77,7 @@
 #include <net/route.h>
 #include <net/net_namespace.h>
 #include <net/netns/generic.h>
+#include <net/pkt_sched.h>
 #include "bonding.h"
 #include "bond_3ad.h"
 #include "bond_alb.h"
@@ -382,8 +383,6 @@ struct vlan_entry *bond_next_vlan(struct bonding *bond,=
 struct vlan_entry *curr)
 	return next;
 }
=20
-#define bond_queue_mapping(skb) (*(u16 *)((skb)->cb))
-
 /**
  * bond_dev_queue_xmit - Prepare skb for xmit.
  *
@@ -396,7 +395,9 @@ int bond_dev_queue_xmit(struct bonding *bond, struct sk=
_buff *skb,
 {
 	skb->dev =3D slave_dev;
=20
-	skb->queue_mapping =3D bond_queue_mapping(skb);
+	BUILD_BUG_ON(sizeof(skb->queue_mapping) !=3D
+		     sizeof(qdisc_skb_cb(skb)->bond_queue_mapping));
+	skb->queue_mapping =3D qdisc_skb_cb(skb)->bond_queue_mapping;
=20
 	if (unlikely(netpoll_tx_running(slave_dev)))
 		bond_netpoll_send_skb(bond_get_slave_by_dev(bond, slave_dev), skb);
@@ -4151,7 +4152,7 @@ static u16 bond_select_queue(struct net_device *dev, =
struct sk_buff *skb)
 	/*
 	 * Save the original txq to restore before passing to the driver
 	 */
-	bond_queue_mapping(skb) =3D skb->queue_mapping;
+	qdisc_skb_cb(skb)->bond_queue_mapping =3D skb->queue_mapping;
=20
 	if (unlikely(txq >=3D dev->real_num_tx_queues)) {
 		do {
diff --git a/drivers/net/dummy.c b/drivers/net/dummy.c
index eeac9ca..68fe73c 100644
--- a/drivers/net/dummy.c
+++ b/drivers/net/dummy.c
@@ -37,6 +37,7 @@
 #include <linux/rtnetlink.h>
 #include <net/rtnetlink.h>
 #include <linux/u64_stats_sync.h>
+#include <linux/sched.h>
=20
 static int numdummies =3D 1;
=20
@@ -186,8 +187,10 @@ static int __init dummy_init_module(void)
 	rtnl_lock();
 	err =3D __rtnl_link_register(&dummy_link_ops);
=20
-	for (i =3D 0; i < numdummies && !err; i++)
+	for (i =3D 0; i < numdummies && !err; i++) {
 		err =3D dummy_init_one();
+		cond_resched();
+	}
 	if (err < 0)
 		__rtnl_link_unregister(&dummy_link_ops);
 	rtnl_unlock();
diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethe=
rnet/emulex/benet/be_main.c
index bf266a0..36c7c4e 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -696,6 +696,8 @@ static netdev_tx_t be_xmit(struct sk_buff *skb,
=20
 	copied =3D make_tx_wrbs(adapter, txq, skb, wrb_cnt, dummy_wrb);
 	if (copied) {
+		int gso_segs =3D skb_shinfo(skb)->gso_segs;
+
 		/* record the sent skb in the sent_skb table */
 		BUG_ON(txo->sent_skb_list[start]);
 		txo->sent_skb_list[start] =3D skb;
@@ -713,8 +715,7 @@ static netdev_tx_t be_xmit(struct sk_buff *skb,
=20
 		be_txq_notify(adapter, txq->id, wrb_cnt);
=20
-		be_tx_stats_update(txo, wrb_cnt, copied,
-				skb_shinfo(skb)->gso_segs, stopped);
+		be_tx_stats_update(txo, wrb_cnt, copied, gso_segs, stopped);
 	} else {
 		txq->head =3D start;
 		dev_kfree_skb_any(skb);
diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/mar=
vell/sky2.c
index 65c51ff..11ddd838 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -4361,10 +4361,12 @@ static int sky2_set_features(struct net_device *dev=
, u32 features)
 	struct sky2_port *sky2 =3D netdev_priv(dev);
 	u32 changed =3D dev->features ^ features;
=20
-	if (changed & NETIF_F_RXCSUM) {
-		u32 on =3D features & NETIF_F_RXCSUM;
-		sky2_write32(sky2->hw, Q_ADDR(rxqaddr[sky2->port], Q_CSR),
-			     on ? BMU_ENA_RX_CHKSUM : BMU_DIS_RX_CHKSUM);
+	if ((changed & NETIF_F_RXCSUM) &&
+	    !(sky2->hw->flags & SKY2_HW_NEW_LE)) {
+		sky2_write32(sky2->hw,
+			     Q_ADDR(rxqaddr[sky2->port], Q_CSR),
+			     (features & NETIF_F_RXCSUM)
+			     ? BMU_ENA_RX_CHKSUM : BMU_DIS_RX_CHKSUM);
 	}
=20
 	if (changed & NETIF_F_RXHASH)
diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.=
h
index 0f9ee46..4cc4a8b 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -143,6 +143,7 @@ struct ath_common {
 	u32 keymax;
 	DECLARE_BITMAP(keymap, ATH_KEYMAX);
 	DECLARE_BITMAP(tkip_keymap, ATH_KEYMAX);
+	DECLARE_BITMAP(ccmp_keymap, ATH_KEYMAX);
 	enum ath_crypt_caps crypt_caps;
=20
 	unsigned int clockrate;
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath=
/ath9k/hw.c
index 6973620..7f97164 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -557,7 +557,7 @@ static int __ath9k_hw_init(struct ath_hw *ah)
=20
 	if (ah->config.serialize_regmode =3D=3D SER_REG_MODE_AUTO) {
 		if (ah->hw_version.macVersion =3D=3D AR_SREV_VERSION_5416_PCI ||
-		    ((AR_SREV_9160(ah) || AR_SREV_9280(ah)) &&
+		    ((AR_SREV_9160(ah) || AR_SREV_9280(ah) || AR_SREV_9287(ah)) &&
 		     !ah->is_pciexpress)) {
 			ah->config.serialize_regmode =3D
 				SER_REG_MODE_ON;
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/a=
th/ath9k/recv.c
index 2f3aeac..e6d791c 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -829,7 +829,8 @@ static bool ath9k_rx_accept(struct ath_common *common,
 	 * descriptor does contain a valid key index. This has been observed
 	 * mostly with CCMP encryption.
 	 */
-	if (rx_stats->rs_keyix =3D=3D ATH9K_RXKEYIX_INVALID)
+	if (rx_stats->rs_keyix =3D=3D ATH9K_RXKEYIX_INVALID ||
+	    !test_bit(rx_stats->rs_keyix, common->ccmp_keymap))
 		rx_stats->rs_status &=3D ~ATH9K_RXERR_KEYMISS;
=20
 	if (!rx_stats->rs_datalen)
diff --git a/drivers/net/wireless/ath/key.c b/drivers/net/wireless/ath/key.=
c
index 4cf7c5e..1ec3fa5 100644
--- a/drivers/net/wireless/ath/key.c
+++ b/drivers/net/wireless/ath/key.c
@@ -556,6 +556,9 @@ int ath_key_config(struct ath_common *common,
 		return -EIO;
=20
 	set_bit(idx, common->keymap);
+	if (key->cipher =3D=3D WLAN_CIPHER_SUITE_CCMP)
+		set_bit(idx, common->ccmp_keymap);
+
 	if (key->cipher =3D=3D WLAN_CIPHER_SUITE_TKIP) {
 		set_bit(idx + 64, common->keymap);
 		set_bit(idx, common->tkip_keymap);
@@ -582,6 +585,7 @@ void ath_key_delete(struct ath_common *common, struct i=
eee80211_key_conf *key)
 		return;
=20
 	clear_bit(key->hw_key_idx, common->keymap);
+	clear_bit(key->hw_key_idx, common->ccmp_keymap);
 	if (key->cipher !=3D WLAN_CIPHER_SUITE_TKIP)
 		return;
=20
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wir=
eless/mwifiex/11n_rxreorder.c
index 7aa9aa0..39fd4d5 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -267,7 +267,8 @@ mwifiex_11n_create_rx_reorder_tbl(struct mwifiex_privat=
e *priv, u8 *ta,
 	else
 		last_seq =3D priv->rx_seq[tid];
=20
-	if (last_seq >=3D new_node->start_win)
+	if (last_seq !=3D MWIFIEX_DEF_11N_RX_SEQ_NUM &&
+	    last_seq >=3D new_node->start_win)
 		new_node->start_win =3D last_seq + 1;
=20
 	new_node->win_size =3D win_size;
@@ -611,5 +612,5 @@ void mwifiex_11n_cleanup_reorder_tbl(struct mwifiex_pri=
vate *priv)
 	spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
=20
 	INIT_LIST_HEAD(&priv->rx_reorder_tbl_ptr);
-	memset(priv->rx_seq, 0, sizeof(priv->rx_seq));
+	mwifiex_reset_11n_rx_seq_num(priv);
 }
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.h b/drivers/net/wir=
eless/mwifiex/11n_rxreorder.h
index 033c8ad..7128baa 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.h
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.h
@@ -37,6 +37,13 @@
=20
 #define ADDBA_RSP_STATUS_ACCEPT 0
=20
+#define MWIFIEX_DEF_11N_RX_SEQ_NUM	0xffff
+
+static inline void mwifiex_reset_11n_rx_seq_num(struct mwifiex_private *pr=
iv)
+{
+	memset(priv->rx_seq, 0xff, sizeof(priv->rx_seq));
+}
+
 int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *,
 			       u16 seqNum,
 			       u16 tid, u8 *ta,
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless=
/mwifiex/cfg80211.c
index 462c710..01dcb1a 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1177,11 +1177,11 @@ struct net_device *mwifiex_add_virtual_intf(struct =
wiphy *wiphy,
 	void *mdev_priv;
=20
 	if (!priv)
-		return NULL;
+		return ERR_PTR(-EFAULT);
=20
 	adapter =3D priv->adapter;
 	if (!adapter)
-		return NULL;
+		return ERR_PTR(-EFAULT);
=20
 	switch (type) {
 	case NL80211_IFTYPE_UNSPECIFIED:
@@ -1190,7 +1190,7 @@ struct net_device *mwifiex_add_virtual_intf(struct wi=
phy *wiphy,
 		if (priv->bss_mode) {
 			wiphy_err(wiphy, "cannot create multiple"
 					" station/adhoc interfaces\n");
-			return NULL;
+			return ERR_PTR(-EINVAL);
 		}
=20
 		if (type =3D=3D NL80211_IFTYPE_UNSPECIFIED)
@@ -1208,14 +1208,15 @@ struct net_device *mwifiex_add_virtual_intf(struct =
wiphy *wiphy,
 		break;
 	default:
 		wiphy_err(wiphy, "type not supported\n");
-		return NULL;
+		return ERR_PTR(-EINVAL);
 	}
=20
 	dev =3D alloc_netdev_mq(sizeof(struct mwifiex_private *), name,
 			      ether_setup, 1);
 	if (!dev) {
 		wiphy_err(wiphy, "no memory available for netdevice\n");
-		goto error;
+		priv->bss_mode =3D NL80211_IFTYPE_UNSPECIFIED;
+		return ERR_PTR(-ENOMEM);
 	}
=20
 	dev_net_set(dev, wiphy_net(wiphy));
@@ -1240,7 +1241,9 @@ struct net_device *mwifiex_add_virtual_intf(struct wi=
phy *wiphy,
 	/* Register network device */
 	if (register_netdevice(dev)) {
 		wiphy_err(wiphy, "cannot register virtual network device\n");
-		goto error;
+		free_netdev(dev);
+		priv->bss_mode =3D NL80211_IFTYPE_UNSPECIFIED;
+		return ERR_PTR(-EFAULT);
 	}
=20
 	sema_init(&priv->async_sem, 1);
@@ -1252,12 +1255,6 @@ struct net_device *mwifiex_add_virtual_intf(struct w=
iphy *wiphy,
 	mwifiex_dev_debugfs_init(priv);
 #endif
 	return dev;
-error:
-	if (dev && (dev->reg_state =3D=3D NETREG_UNREGISTERED))
-		free_netdev(dev);
-	priv->bss_mode =3D NL80211_IFTYPE_UNSPECIFIED;
-
-	return NULL;
 }
 EXPORT_SYMBOL_GPL(mwifiex_add_virtual_intf);
=20
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwif=
iex/wmm.c
index 6c239c3..06fcf1e 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -406,6 +406,8 @@ mwifiex_wmm_init(struct mwifiex_adapter *adapter)
 		priv->add_ba_param.tx_win_size =3D MWIFIEX_AMPDU_DEF_TXWINSIZE;
 		priv->add_ba_param.rx_win_size =3D MWIFIEX_AMPDU_DEF_RXWINSIZE;
=20
+		mwifiex_reset_11n_rx_seq_num(priv);
+
 		atomic_set(&priv->wmm.tx_pkts_queued, 0);
 		atomic_set(&priv->wmm.highest_queued_prio, HIGH_PRIO_TID);
 	}
@@ -1209,10 +1211,12 @@ mwifiex_dequeue_tx_packet(struct mwifiex_adapter *a=
dapter)
 		return 0;
 	}
=20
-	if (!ptr->is_11n_enabled || mwifiex_is_ba_stream_setup(priv, ptr, tid)
-	    || ((priv->sec_info.wpa_enabled
-		  || priv->sec_info.wpa2_enabled) && !priv->wpa_is_gtk_set)
-		) {
+	if (!ptr->is_11n_enabled ||
+	    mwifiex_is_ba_stream_setup(priv, ptr, tid) ||
+	    priv->wps.session_enable ||
+	    ((priv->sec_info.wpa_enabled ||
+	      priv->sec_info.wpa2_enabled) &&
+	     !priv->wpa_is_gtk_set)) {
 		mwifiex_send_single_packet(priv, ptr, ptr_index, flags);
 		/* ra_list_spinlock has been freed in
 		   mwifiex_send_single_packet() */
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c b/drivers/net/wire=
less/rtlwifi/rtl8192cu/sw.c
index 94a3e17..0302148 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
@@ -311,9 +311,11 @@ static struct usb_device_id rtl8192c_usb_ids[] =3D {
 	{RTL_USB_DEVICE(0x07b8, 0x8188, rtl92cu_hal_cfg)}, /*Abocom - Abocom*/
 	{RTL_USB_DEVICE(0x07b8, 0x8189, rtl92cu_hal_cfg)}, /*Funai - Abocom*/
 	{RTL_USB_DEVICE(0x0846, 0x9041, rtl92cu_hal_cfg)}, /*NetGear WNA1000M*/
+	{RTL_USB_DEVICE(0x0bda, 0x5088, rtl92cu_hal_cfg)}, /*Thinkware-CC&C*/
 	{RTL_USB_DEVICE(0x0df6, 0x0052, rtl92cu_hal_cfg)}, /*Sitecom - Edimax*/
 	{RTL_USB_DEVICE(0x0df6, 0x005c, rtl92cu_hal_cfg)}, /*Sitecom - Edimax*/
 	{RTL_USB_DEVICE(0x0eb0, 0x9071, rtl92cu_hal_cfg)}, /*NO Brand - Etop*/
+	{RTL_USB_DEVICE(0x4856, 0x0091, rtl92cu_hal_cfg)}, /*NetweeN - Feixun*/
 	/* HP - Lite-On ,8188CUS Slim Combo */
 	{RTL_USB_DEVICE(0x103c, 0x1629, rtl92cu_hal_cfg)},
 	{RTL_USB_DEVICE(0x13d3, 0x3357, rtl92cu_hal_cfg)}, /* AzureWave */
@@ -355,6 +357,7 @@ static struct usb_device_id rtl8192c_usb_ids[] =3D {
 	{RTL_USB_DEVICE(0x07b8, 0x8178, rtl92cu_hal_cfg)}, /*Funai -Abocom*/
 	{RTL_USB_DEVICE(0x0846, 0x9021, rtl92cu_hal_cfg)}, /*Netgear-Sercomm*/
 	{RTL_USB_DEVICE(0x0b05, 0x17ab, rtl92cu_hal_cfg)}, /*ASUS-Edimax*/
+	{RTL_USB_DEVICE(0x0bda, 0x8186, rtl92cu_hal_cfg)}, /*Realtek 92CE-VAU*/
 	{RTL_USB_DEVICE(0x0df6, 0x0061, rtl92cu_hal_cfg)}, /*Sitecom-Edimax*/
 	{RTL_USB_DEVICE(0x0e66, 0x0019, rtl92cu_hal_cfg)}, /*Hawking-Edimax*/
 	{RTL_USB_DEVICE(0x2001, 0x3307, rtl92cu_hal_cfg)}, /*D-Link-Cameo*/
diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_s=
ess.c
index 3269213..64ddb63 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -61,7 +61,8 @@ static struct ft_tport *ft_tport_create(struct fc_lport *=
lport)
 	struct ft_tport *tport;
 	int i;
=20
-	tport =3D rcu_dereference(lport->prov[FC_TYPE_FCP]);
+	tport =3D rcu_dereference_protected(lport->prov[FC_TYPE_FCP],
+					  lockdep_is_held(&ft_lport_lock));
 	if (tport && tport->tpg)
 		return tport;
=20
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 3568374..19b127c 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -692,6 +692,8 @@ static noinline int drop_one_dir_item(struct btrfs_tran=
s_handle *trans,
 	kfree(name);
=20
 	iput(inode);
+
+	btrfs_run_delayed_items(trans, root);
 	return ret;
 }
=20
@@ -897,6 +899,7 @@ again:
 				ret =3D btrfs_unlink_inode(trans, root, dir,
 							 inode, victim_name,
 							 victim_name_len);
+				btrfs_run_delayed_items(trans, root);
 			}
 			kfree(victim_name);
 			ptr =3D (unsigned long)(victim_ref + 1) + victim_name_len;
@@ -1477,6 +1480,9 @@ again:
 			ret =3D btrfs_unlink_inode(trans, root, dir, inode,
 						 name, name_len);
 			BUG_ON(ret);
+
+			btrfs_run_delayed_items(trans, root);
+
 			kfree(name);
 			iput(inode);
=20
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 9e0675a..b21670c 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2975,18 +2975,15 @@ cifs_negotiate_rsize(struct cifs_tcon *tcon, struct=
 smb_vol *pvolume_info)
 	 * MS-CIFS indicates that servers are only limited by the client's
 	 * bufsize for reads, testing against win98se shows that it throws
 	 * INVALID_PARAMETER errors if you try to request too large a read.
+	 * OS/2 just sends back short reads.
 	 *
-	 * If the server advertises a MaxBufferSize of less than one page,
-	 * assume that it also can't satisfy reads larger than that either.
-	 *
-	 * FIXME: Is there a better heuristic for this?
+	 * If the server doesn't advertise CAP_LARGE_READ_X, then assume that
+	 * it can't handle a read request larger than its MaxBufferSize either.
 	 */
 	if (tcon->unix_ext && (unix_cap & CIFS_UNIX_LARGE_READ_CAP))
 		defsize =3D CIFS_DEFAULT_IOSIZE;
 	else if (server->capabilities & CAP_LARGE_READ_X)
 		defsize =3D CIFS_DEFAULT_NON_POSIX_RSIZE;
-	else if (server->maxBuf >=3D PAGE_CACHE_SIZE)
-		defsize =3D CIFSMaxBufSize;
 	else
 		defsize =3D server->maxBuf - sizeof(READ_RSP);
=20
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 6e39668..07ee5b4 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2422,8 +2422,10 @@ out_dio:
 		unaligned_dio =3D 0;
 	}
=20
-	if (unaligned_dio)
+	if (unaligned_dio) {
+		ocfs2_iocb_clear_unaligned_aio(iocb);
 		atomic_dec(&OCFS2_I(inode)->ip_unaligned_aio);
+	}
=20
 out:
 	if (rw_level !=3D -1)
diff --git a/fs/open.c b/fs/open.c
index 22c41b5..e2b5d51 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -396,10 +396,10 @@ SYSCALL_DEFINE1(fchdir, unsigned int, fd)
 {
 	struct file *file;
 	struct inode *inode;
-	int error;
+	int error, fput_needed;
=20
 	error =3D -EBADF;
-	file =3D fget(fd);
+	file =3D fget_raw_light(fd, &fput_needed);
 	if (!file)
 		goto out;
=20
@@ -413,7 +413,7 @@ SYSCALL_DEFINE1(fchdir, unsigned int, fd)
 	if (!error)
 		set_fs_pwd(current->fs, &file->f_path);
 out_putf:
-	fput(file);
+	fput_light(file, fput_needed);
 out:
 	return error;
 }
diff --git a/fs/splice.c b/fs/splice.c
index 6d0dfb8..014fcb4 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -274,13 +274,16 @@ void spd_release_page(struct splice_pipe_desc *spd, u=
nsigned int i)
  * Check if we need to grow the arrays holding pages and partial page
  * descriptions.
  */
-int splice_grow_spd(struct pipe_inode_info *pipe, struct splice_pipe_desc =
*spd)
+int splice_grow_spd(const struct pipe_inode_info *pipe, struct splice_pipe=
_desc *spd)
 {
-	if (pipe->buffers <=3D PIPE_DEF_BUFFERS)
+	unsigned int buffers =3D ACCESS_ONCE(pipe->buffers);
+
+	spd->nr_pages_max =3D buffers;
+	if (buffers <=3D PIPE_DEF_BUFFERS)
 		return 0;
=20
-	spd->pages =3D kmalloc(pipe->buffers * sizeof(struct page *), GFP_KERNEL)=
;
-	spd->partial =3D kmalloc(pipe->buffers * sizeof(struct partial_page), GFP=
_KERNEL);
+	spd->pages =3D kmalloc(buffers * sizeof(struct page *), GFP_KERNEL);
+	spd->partial =3D kmalloc(buffers * sizeof(struct partial_page), GFP_KERNE=
L);
=20
 	if (spd->pages && spd->partial)
 		return 0;
@@ -290,10 +293,9 @@ int splice_grow_spd(struct pipe_inode_info *pipe, stru=
ct splice_pipe_desc *spd)
 	return -ENOMEM;
 }
=20
-void splice_shrink_spd(struct pipe_inode_info *pipe,
-		       struct splice_pipe_desc *spd)
+void splice_shrink_spd(struct splice_pipe_desc *spd)
 {
-	if (pipe->buffers <=3D PIPE_DEF_BUFFERS)
+	if (spd->nr_pages_max <=3D PIPE_DEF_BUFFERS)
 		return;
=20
 	kfree(spd->pages);
@@ -316,6 +318,7 @@ __generic_file_splice_read(struct file *in, loff_t *ppo=
s,
 	struct splice_pipe_desc spd =3D {
 		.pages =3D pages,
 		.partial =3D partial,
+		.nr_pages_max =3D PIPE_DEF_BUFFERS,
 		.flags =3D flags,
 		.ops =3D &page_cache_pipe_buf_ops,
 		.spd_release =3D spd_release_page,
@@ -327,7 +330,7 @@ __generic_file_splice_read(struct file *in, loff_t *ppo=
s,
 	index =3D *ppos >> PAGE_CACHE_SHIFT;
 	loff =3D *ppos & ~PAGE_CACHE_MASK;
 	req_pages =3D (len + loff + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
-	nr_pages =3D min(req_pages, pipe->buffers);
+	nr_pages =3D min(req_pages, spd.nr_pages_max);
=20
 	/*
 	 * Lookup the (hopefully) full range of pages we need.
@@ -498,7 +501,7 @@ fill_it:
 	if (spd.nr_pages)
 		error =3D splice_to_pipe(pipe, &spd);
=20
-	splice_shrink_spd(pipe, &spd);
+	splice_shrink_spd(&spd);
 	return error;
 }
=20
@@ -599,6 +602,7 @@ ssize_t default_file_splice_read(struct file *in, loff_=
t *ppos,
 	struct splice_pipe_desc spd =3D {
 		.pages =3D pages,
 		.partial =3D partial,
+		.nr_pages_max =3D PIPE_DEF_BUFFERS,
 		.flags =3D flags,
 		.ops =3D &default_pipe_buf_ops,
 		.spd_release =3D spd_release_page,
@@ -609,8 +613,8 @@ ssize_t default_file_splice_read(struct file *in, loff_=
t *ppos,
=20
 	res =3D -ENOMEM;
 	vec =3D __vec;
-	if (pipe->buffers > PIPE_DEF_BUFFERS) {
-		vec =3D kmalloc(pipe->buffers * sizeof(struct iovec), GFP_KERNEL);
+	if (spd.nr_pages_max > PIPE_DEF_BUFFERS) {
+		vec =3D kmalloc(spd.nr_pages_max * sizeof(struct iovec), GFP_KERNEL);
 		if (!vec)
 			goto shrink_ret;
 	}
@@ -618,7 +622,7 @@ ssize_t default_file_splice_read(struct file *in, loff_=
t *ppos,
 	offset =3D *ppos & ~PAGE_CACHE_MASK;
 	nr_pages =3D (len + offset + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
=20
-	for (i =3D 0; i < nr_pages && i < pipe->buffers && len; i++) {
+	for (i =3D 0; i < nr_pages && i < spd.nr_pages_max && len; i++) {
 		struct page *page;
=20
 		page =3D alloc_page(GFP_USER);
@@ -666,7 +670,7 @@ ssize_t default_file_splice_read(struct file *in, loff_=
t *ppos,
 shrink_ret:
 	if (vec !=3D __vec)
 		kfree(vec);
-	splice_shrink_spd(pipe, &spd);
+	splice_shrink_spd(&spd);
 	return res;
=20
 err:
@@ -1616,6 +1620,7 @@ static long vmsplice_to_pipe(struct file *file, const=
 struct iovec __user *iov,
 	struct splice_pipe_desc spd =3D {
 		.pages =3D pages,
 		.partial =3D partial,
+		.nr_pages_max =3D PIPE_DEF_BUFFERS,
 		.flags =3D flags,
 		.ops =3D &user_page_pipe_buf_ops,
 		.spd_release =3D spd_release_page,
@@ -1631,13 +1636,13 @@ static long vmsplice_to_pipe(struct file *file, con=
st struct iovec __user *iov,
=20
 	spd.nr_pages =3D get_iovec_page_array(iov, nr_segs, spd.pages,
 					    spd.partial, flags & SPLICE_F_GIFT,
-					    pipe->buffers);
+					    spd.nr_pages_max);
 	if (spd.nr_pages <=3D 0)
 		ret =3D spd.nr_pages;
 	else
 		ret =3D splice_to_pipe(pipe, &spd);
=20
-	splice_shrink_spd(pipe, &spd);
+	splice_shrink_spd(&spd);
 	return ret;
 }
=20
diff --git a/fs/udf/super.c b/fs/udf/super.c
index 87cb24a..270e135 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -56,6 +56,7 @@
 #include <linux/seq_file.h>
 #include <linux/bitmap.h>
 #include <linux/crc-itu-t.h>
+#include <linux/log2.h>
 #include <asm/byteorder.h>
=20
 #include "udf_sb.h"
@@ -1217,16 +1218,65 @@ out_bh:
 	return ret;
 }
=20
+static int udf_load_sparable_map(struct super_block *sb,
+				 struct udf_part_map *map,
+				 struct sparablePartitionMap *spm)
+{
+	uint32_t loc;
+	uint16_t ident;
+	struct sparingTable *st;
+	struct udf_sparing_data *sdata =3D &map->s_type_specific.s_sparing;
+	int i;
+	struct buffer_head *bh;
+
+	map->s_partition_type =3D UDF_SPARABLE_MAP15;
+	sdata->s_packet_len =3D le16_to_cpu(spm->packetLength);
+	if (!is_power_of_2(sdata->s_packet_len)) {
+		udf_err(sb, "error loading logical volume descriptor: "
+			"Invalid packet length %u\n",
+			(unsigned)sdata->s_packet_len);
+		return -EIO;
+	}
+	if (spm->numSparingTables > 4) {
+		udf_err(sb, "error loading logical volume descriptor: "
+			"Too many sparing tables (%d)\n",
+			(int)spm->numSparingTables);
+		return -EIO;
+	}
+
+	for (i =3D 0; i < spm->numSparingTables; i++) {
+		loc =3D le32_to_cpu(spm->locSparingTable[i]);
+		bh =3D udf_read_tagged(sb, loc, loc, &ident);
+		if (!bh)
+			continue;
+
+		st =3D (struct sparingTable *)bh->b_data;
+		if (ident !=3D 0 ||
+		    strncmp(st->sparingIdent.ident, UDF_ID_SPARING,
+			    strlen(UDF_ID_SPARING)) ||
+		    sizeof(*st) + le16_to_cpu(st->reallocationTableLen) >
+							sb->s_blocksize) {
+			brelse(bh);
+			continue;
+		}
+
+		sdata->s_spar_map[i] =3D bh;
+	}
+	map->s_partition_func =3D udf_get_pblock_spar15;
+	return 0;
+}
+
 static int udf_load_logicalvol(struct super_block *sb, sector_t block,
 			       struct kernel_lb_addr *fileset)
 {
 	struct logicalVolDesc *lvd;
-	int i, j, offset;
+	int i, offset;
 	uint8_t type;
 	struct udf_sb_info *sbi =3D UDF_SB(sb);
 	struct genericPartitionMap *gpm;
 	uint16_t ident;
 	struct buffer_head *bh;
+	unsigned int table_len;
 	int ret =3D 0;
=20
 	bh =3D udf_read_tagged(sb, block, block, &ident);
@@ -1234,15 +1284,20 @@ static int udf_load_logicalvol(struct super_block *=
sb, sector_t block,
 		return 1;
 	BUG_ON(ident !=3D TAG_IDENT_LVD);
 	lvd =3D (struct logicalVolDesc *)bh->b_data;
-
-	i =3D udf_sb_alloc_partition_maps(sb, le32_to_cpu(lvd->numPartitionMaps))=
;
-	if (i !=3D 0) {
-		ret =3D i;
+	table_len =3D le32_to_cpu(lvd->mapTableLength);
+	if (sizeof(*lvd) + table_len > sb->s_blocksize) {
+		udf_err(sb, "error loading logical volume descriptor: "
+			"Partition table too long (%u > %lu)\n", table_len,
+			sb->s_blocksize - sizeof(*lvd));
 		goto out_bh;
 	}
=20
+	ret =3D udf_sb_alloc_partition_maps(sb, le32_to_cpu(lvd->numPartitionMaps=
));
+	if (ret)
+		goto out_bh;
+
 	for (i =3D 0, offset =3D 0;
-	     i < sbi->s_partitions && offset < le32_to_cpu(lvd->mapTableLength);
+	     i < sbi->s_partitions && offset < table_len;
 	     i++, offset +=3D gpm->partitionMapLength) {
 		struct udf_part_map *map =3D &sbi->s_partmaps[i];
 		gpm =3D (struct genericPartitionMap *)
@@ -1277,38 +1332,9 @@ static int udf_load_logicalvol(struct super_block *s=
b, sector_t block,
 			} else if (!strncmp(upm2->partIdent.ident,
 						UDF_ID_SPARABLE,
 						strlen(UDF_ID_SPARABLE))) {
-				uint32_t loc;
-				struct sparingTable *st;
-				struct sparablePartitionMap *spm =3D
-					(struct sparablePartitionMap *)gpm;
-
-				map->s_partition_type =3D UDF_SPARABLE_MAP15;
-				map->s_type_specific.s_sparing.s_packet_len =3D
-						le16_to_cpu(spm->packetLength);
-				for (j =3D 0; j < spm->numSparingTables; j++) {
-					struct buffer_head *bh2;
-
-					loc =3D le32_to_cpu(
-						spm->locSparingTable[j]);
-					bh2 =3D udf_read_tagged(sb, loc, loc,
-							     &ident);
-					map->s_type_specific.s_sparing.
-							s_spar_map[j] =3D bh2;
-
-					if (bh2 =3D=3D NULL)
-						continue;
-
-					st =3D (struct sparingTable *)bh2->b_data;
-					if (ident !=3D 0 || strncmp(
-						st->sparingIdent.ident,
-						UDF_ID_SPARING,
-						strlen(UDF_ID_SPARING))) {
-						brelse(bh2);
-						map->s_type_specific.s_sparing.
-							s_spar_map[j] =3D NULL;
-					}
-				}
-				map->s_partition_func =3D udf_get_pblock_spar15;
+				if (udf_load_sparable_map(sb, map,
+				    (struct sparablePartitionMap *)gpm) < 0)
+					goto out_bh;
 			} else if (!strncmp(upm2->partIdent.ident,
 						UDF_ID_METADATA,
 						strlen(UDF_ID_METADATA))) {
diff --git a/include/linux/aio.h b/include/linux/aio.h
index 2314ad8..b1a520e 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -140,6 +140,7 @@ struct kiocb {
 		(x)->ki_dtor =3D NULL;			\
 		(x)->ki_obj.tsk =3D tsk;			\
 		(x)->ki_user_data =3D 0;                  \
+		(x)->private =3D NULL;			\
 	} while (0)
=20
 #define AIO_RING_MAGIC			0xa10a10a1
diff --git a/include/linux/splice.h b/include/linux/splice.h
index 26e5b61..09a545a 100644
--- a/include/linux/splice.h
+++ b/include/linux/splice.h
@@ -51,7 +51,8 @@ struct partial_page {
 struct splice_pipe_desc {
 	struct page **pages;		/* page map */
 	struct partial_page *partial;	/* pages[] may not be contig */
-	int nr_pages;			/* number of pages in map */
+	int nr_pages;			/* number of populated pages in map */
+	unsigned int nr_pages_max;	/* pages[] & partial[] arrays size */
 	unsigned int flags;		/* splice flags */
 	const struct pipe_buf_operations *ops;/* ops associated with output pipe =
*/
 	void (*spd_release)(struct splice_pipe_desc *, unsigned int);
@@ -85,9 +86,8 @@ extern ssize_t splice_direct_to_actor(struct file *, stru=
ct splice_desc *,
 /*
  * for dynamic pipe sizing
  */
-extern int splice_grow_spd(struct pipe_inode_info *, struct splice_pipe_de=
sc *);
-extern void splice_shrink_spd(struct pipe_inode_info *,
-				struct splice_pipe_desc *);
+extern int splice_grow_spd(const struct pipe_inode_info *, struct splice_p=
ipe_desc *);
+extern void splice_shrink_spd(struct splice_pipe_desc *);
 extern void spd_release_page(struct splice_pipe_desc *, unsigned int);
=20
 extern const struct pipe_buf_operations page_cache_pipe_buf_ops;
diff --git a/include/net/cipso_ipv4.h b/include/net/cipso_ipv4.h
index 9808877..a7a683e 100644
--- a/include/net/cipso_ipv4.h
+++ b/include/net/cipso_ipv4.h
@@ -42,6 +42,7 @@
 #include <net/netlabel.h>
 #include <net/request_sock.h>
 #include <linux/atomic.h>
+#include <asm/unaligned.h>
=20
 /* known doi values */
 #define CIPSO_V4_DOI_UNKNOWN          0x00000000
@@ -285,7 +286,33 @@ static inline int cipso_v4_skbuff_getattr(const struct=
 sk_buff *skb,
 static inline int cipso_v4_validate(const struct sk_buff *skb,
 				    unsigned char **option)
 {
-	return -ENOSYS;
+	unsigned char *opt =3D *option;
+	unsigned char err_offset =3D 0;
+	u8 opt_len =3D opt[1];
+	u8 opt_iter;
+
+	if (opt_len < 8) {
+		err_offset =3D 1;
+		goto out;
+	}
+
+	if (get_unaligned_be32(&opt[2]) =3D=3D 0) {
+		err_offset =3D 2;
+		goto out;
+	}
+
+	for (opt_iter =3D 6; opt_iter < opt_len;) {
+		if (opt[opt_iter + 1] > (opt_len - opt_iter)) {
+			err_offset =3D opt_iter + 1;
+			goto out;
+		}
+		opt_iter +=3D opt[opt_iter + 1];
+	}
+
+out:
+	*option =3D opt + err_offset;
+	return err_offset;
+
 }
 #endif /* CONFIG_NETLABEL */
=20
diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 55ce96b..9d7d54a 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -220,13 +220,16 @@ struct tcf_proto {
=20
 struct qdisc_skb_cb {
 	unsigned int		pkt_len;
-	unsigned char		data[24];
+	u16			bond_queue_mapping;
+	u16			_pad;
+	unsigned char		data[20];
 };
=20
 static inline void qdisc_cb_private_validate(const struct sk_buff *skb, in=
t sz)
 {
 	struct qdisc_skb_cb *qcb;
-	BUILD_BUG_ON(sizeof(skb->cb) < sizeof(unsigned int) + sz);
+
+	BUILD_BUG_ON(sizeof(skb->cb) < offsetof(struct qdisc_skb_cb, data) + sz);
 	BUILD_BUG_ON(sizeof(qcb->data) < sz);
 }
=20
diff --git a/kernel/relay.c b/kernel/relay.c
index b6f803a..a535fc9 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -1235,6 +1235,7 @@ static ssize_t subbuf_splice_actor(struct file *in,
 	struct splice_pipe_desc spd =3D {
 		.pages =3D pages,
 		.nr_pages =3D 0,
+		.nr_pages_max =3D PIPE_DEF_BUFFERS,
 		.partial =3D partial,
 		.flags =3D flags,
 		.ops =3D &relay_pipe_buf_ops,
@@ -1302,8 +1303,8 @@ static ssize_t subbuf_splice_actor(struct file *in,
                 ret +=3D padding;
=20
 out:
-	splice_shrink_spd(pipe, &spd);
-        return ret;
+	splice_shrink_spd(&spd);
+	return ret;
 }
=20
 static ssize_t relay_file_splice_read(struct file *in,
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 697e49d..5638104 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2541,10 +2541,12 @@ tracing_cpumask_write(struct file *filp, const char=
 __user *ubuf,
 		if (cpumask_test_cpu(cpu, tracing_cpumask) &&
 				!cpumask_test_cpu(cpu, tracing_cpumask_new)) {
 			atomic_inc(&global_trace.data[cpu]->disabled);
+			ring_buffer_record_disable_cpu(global_trace.buffer, cpu);
 		}
 		if (!cpumask_test_cpu(cpu, tracing_cpumask) &&
 				cpumask_test_cpu(cpu, tracing_cpumask_new)) {
 			atomic_dec(&global_trace.data[cpu]->disabled);
+			ring_buffer_record_enable_cpu(global_trace.buffer, cpu);
 		}
 	}
 	arch_spin_unlock(&ftrace_max_lock);
@@ -3456,6 +3458,7 @@ static ssize_t tracing_splice_read_pipe(struct file *=
filp,
 		.pages		=3D pages_def,
 		.partial	=3D partial_def,
 		.nr_pages	=3D 0, /* This gets updated below. */
+		.nr_pages_max	=3D PIPE_DEF_BUFFERS,
 		.flags		=3D flags,
 		.ops		=3D &tracing_pipe_buf_ops,
 		.spd_release	=3D tracing_spd_release_pipe,
@@ -3527,7 +3530,7 @@ static ssize_t tracing_splice_read_pipe(struct file *=
filp,
=20
 	ret =3D splice_to_pipe(pipe, &spd);
 out:
-	splice_shrink_spd(pipe, &spd);
+	splice_shrink_spd(&spd);
 	return ret;
=20
 out_err:
@@ -4017,6 +4020,7 @@ tracing_buffers_splice_read(struct file *file, loff_t=
 *ppos,
 	struct splice_pipe_desc spd =3D {
 		.pages		=3D pages_def,
 		.partial	=3D partial_def,
+		.nr_pages_max	=3D PIPE_DEF_BUFFERS,
 		.flags		=3D flags,
 		.ops		=3D &buffer_pipe_buf_ops,
 		.spd_release	=3D buffer_spd_release,
@@ -4104,7 +4108,7 @@ tracing_buffers_splice_read(struct file *file, loff_t=
 *ppos,
 	}
=20
 	ret =3D splice_to_pipe(pipe, &spd);
-	splice_shrink_spd(pipe, &spd);
+	splice_shrink_spd(&spd);
 out:
 	return ret;
 }
diff --git a/mm/madvise.c b/mm/madvise.c
index 74bf193..23d3a6b 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -13,6 +13,7 @@
 #include <linux/hugetlb.h>
 #include <linux/sched.h>
 #include <linux/ksm.h>
+#include <linux/file.h>
=20
 /*
  * Any behaviour which results in changes to the vma->vm_flags needs to
@@ -197,14 +198,16 @@ static long madvise_remove(struct vm_area_struct *vma=
,
 	struct address_space *mapping;
 	loff_t offset, endoff;
 	int error;
+	struct file *f;
=20
 	*prev =3D NULL;	/* tell sys_madvise we drop mmap_sem */
=20
 	if (vma->vm_flags & (VM_LOCKED|VM_NONLINEAR|VM_HUGETLB))
 		return -EINVAL;
=20
-	if (!vma->vm_file || !vma->vm_file->f_mapping
-		|| !vma->vm_file->f_mapping->host) {
+	f =3D vma->vm_file;
+
+	if (!f || !f->f_mapping || !f->f_mapping->host) {
 			return -EINVAL;
 	}
=20
@@ -218,9 +221,16 @@ static long madvise_remove(struct vm_area_struct *vma,
 	endoff =3D (loff_t)(end - vma->vm_start - 1)
 			+ ((loff_t)vma->vm_pgoff << PAGE_SHIFT);
=20
-	/* vmtruncate_range needs to take i_mutex */
+	/*
+	 * vmtruncate_range may need to take i_mutex.  We need to
+	 * explicitly grab a reference because the vma (and hence the
+	 * vma's reference to the file) can go away as soon as we drop
+	 * mmap_sem.
+	 */
+	get_file(f);
 	up_read(&current->mm->mmap_sem);
 	error =3D vmtruncate_range(mapping->host, offset, endoff);
+	fput(f);
 	down_read(&current->mm->mmap_sem);
 	return error;
 }
diff --git a/mm/shmem.c b/mm/shmem.c
index 6c253f7..7a82174 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1359,6 +1359,7 @@ static ssize_t shmem_file_splice_read(struct file *in=
, loff_t *ppos,
 	struct splice_pipe_desc spd =3D {
 		.pages =3D pages,
 		.partial =3D partial,
+		.nr_pages_max =3D PIPE_DEF_BUFFERS,
 		.flags =3D flags,
 		.ops =3D &page_cache_pipe_buf_ops,
 		.spd_release =3D spd_release_page,
@@ -1447,7 +1448,7 @@ static ssize_t shmem_file_splice_read(struct file *in=
, loff_t *ppos,
 	if (spd.nr_pages)
 		error =3D splice_to_pipe(pipe, &spd);
=20
-	splice_shrink_spd(pipe, &spd);
+	splice_shrink_spd(&spd);
=20
 	if (error > 0) {
 		*ppos +=3D error;
diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index f603e5b..f3f75ad 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -240,6 +240,7 @@ int br_add_bridge(struct net *net, const char *name)
 		return -ENOMEM;
=20
 	dev_net_set(dev, net);
+	dev->rtnl_link_ops =3D &br_link_ops;
=20
 	res =3D register_netdev(dev);
 	if (res)
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index a1daf82..cbf9ccd 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -211,7 +211,7 @@ static int br_validate(struct nlattr *tb[], struct nlat=
tr *data[])
 	return 0;
 }
=20
-static struct rtnl_link_ops br_link_ops __read_mostly =3D {
+struct rtnl_link_ops br_link_ops __read_mostly =3D {
 	.kind		=3D "bridge",
 	.priv_size	=3D sizeof(struct net_bridge),
 	.setup		=3D br_dev_setup,
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 93264df..b9bba8f 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -536,6 +536,7 @@ extern int (*br_fdb_test_addr_hook)(struct net_device *=
dev, unsigned char *addr)
 #endif
=20
 /* br_netlink.c */
+extern struct rtnl_link_ops br_link_ops;
 extern int br_netlink_init(void);
 extern void br_netlink_fini(void);
 extern void br_ifinfo_notify(int event, struct net_bridge_port *port);
diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index 2b587ec..2367246 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -1672,6 +1672,7 @@ int dev_ethtool(struct net *net, struct ifreq *ifr)
 	case ETHTOOL_GRXCSUM:
 	case ETHTOOL_GTXCSUM:
 	case ETHTOOL_GSG:
+	case ETHTOOL_GSSET_INFO:
 	case ETHTOOL_GSTRINGS:
 	case ETHTOOL_GTSO:
 	case ETHTOOL_GPERMADDR:
diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index ab0633f..db4bb7a 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -351,22 +351,23 @@ EXPORT_SYMBOL(netpoll_send_skb_on_dev);
=20
 void netpoll_send_udp(struct netpoll *np, const char *msg, int len)
 {
-	int total_len, eth_len, ip_len, udp_len;
+	int total_len, ip_len, udp_len;
 	struct sk_buff *skb;
 	struct udphdr *udph;
 	struct iphdr *iph;
 	struct ethhdr *eth;
=20
 	udp_len =3D len + sizeof(*udph);
-	ip_len =3D eth_len =3D udp_len + sizeof(*iph);
-	total_len =3D eth_len + ETH_HLEN + NET_IP_ALIGN;
+	ip_len =3D udp_len + sizeof(*iph);
+	total_len =3D ip_len + LL_RESERVED_SPACE(np->dev);
=20
-	skb =3D find_skb(np, total_len, total_len - len);
+	skb =3D find_skb(np, total_len + np->dev->needed_tailroom,
+		       total_len - len);
 	if (!skb)
 		return;
=20
 	skb_copy_to_linear_data(skb, msg, len);
-	skb->len +=3D len;
+	skb_put(skb, len);
=20
 	skb_push(skb, sizeof(*udph));
 	skb_reset_transport_header(skb);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 2ec200de..af9c3c6 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1663,6 +1663,7 @@ int skb_splice_bits(struct sk_buff *skb, unsigned int=
 offset,
 	struct splice_pipe_desc spd =3D {
 		.pages =3D pages,
 		.partial =3D partial,
+		.nr_pages_max =3D MAX_SKB_FRAGS,
 		.flags =3D flags,
 		.ops =3D &sock_pipe_buf_ops,
 		.spd_release =3D sock_spd_release,
@@ -1709,7 +1710,7 @@ done:
 		lock_sock(sk);
 	}
=20
-	splice_shrink_spd(pipe, &spd);
+	splice_shrink_spd(&spd);
 	return ret;
 }
=20
diff --git a/net/core/sock.c b/net/core/sock.c
index b23f174..8d095b9 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1497,6 +1497,11 @@ struct sk_buff *sock_alloc_send_pskb(struct sock *sk=
, unsigned long header_len,
 	gfp_t gfp_mask;
 	long timeo;
 	int err;
+	int npages =3D (data_len + (PAGE_SIZE - 1)) >> PAGE_SHIFT;
+
+	err =3D -EMSGSIZE;
+	if (npages > MAX_SKB_FRAGS)
+		goto failure;
=20
 	gfp_mask =3D sk->sk_allocation;
 	if (gfp_mask & __GFP_WAIT)
@@ -1515,14 +1520,12 @@ struct sk_buff *sock_alloc_send_pskb(struct sock *s=
k, unsigned long header_len,
 		if (atomic_read(&sk->sk_wmem_alloc) < sk->sk_sndbuf) {
 			skb =3D alloc_skb(header_len, gfp_mask);
 			if (skb) {
-				int npages;
 				int i;
=20
 				/* No pages, we're done... */
 				if (!data_len)
 					break;
=20
-				npages =3D (data_len + (PAGE_SIZE - 1)) >> PAGE_SHIFT;
 				skb->truesize +=3D data_len;
 				skb_shinfo(skb)->nr_frags =3D npages;
 				for (i =3D 0; i < npages; i++) {
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 059b9d9..2e21751 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2881,10 +2881,6 @@ static int __net_init ip6_route_net_init(struct net =
*net)
 	net->ipv6.sysctl.ip6_rt_mtu_expires =3D 10*60*HZ;
 	net->ipv6.sysctl.ip6_rt_min_advmss =3D IPV6_MIN_MTU - 20 - 40;
=20
-#ifdef CONFIG_PROC_FS
-	proc_net_fops_create(net, "ipv6_route", 0, &ipv6_route_proc_fops);
-	proc_net_fops_create(net, "rt6_stats", S_IRUGO, &rt6_stats_seq_fops);
-#endif
 	net->ipv6.ip6_rt_gc_expire =3D 30*HZ;
=20
 	ret =3D 0;
@@ -2905,10 +2901,6 @@ out_ip6_dst_ops:
=20
 static void __net_exit ip6_route_net_exit(struct net *net)
 {
-#ifdef CONFIG_PROC_FS
-	proc_net_remove(net, "ipv6_route");
-	proc_net_remove(net, "rt6_stats");
-#endif
 	kfree(net->ipv6.ip6_null_entry);
 #ifdef CONFIG_IPV6_MULTIPLE_TABLES
 	kfree(net->ipv6.ip6_prohibit_entry);
@@ -2917,11 +2909,33 @@ static void __net_exit ip6_route_net_exit(struct ne=
t *net)
 	dst_entries_destroy(&net->ipv6.ip6_dst_ops);
 }
=20
+static int __net_init ip6_route_net_init_late(struct net *net)
+{
+#ifdef CONFIG_PROC_FS
+	proc_net_fops_create(net, "ipv6_route", 0, &ipv6_route_proc_fops);
+	proc_net_fops_create(net, "rt6_stats", S_IRUGO, &rt6_stats_seq_fops);
+#endif
+	return 0;
+}
+
+static void __net_exit ip6_route_net_exit_late(struct net *net)
+{
+#ifdef CONFIG_PROC_FS
+	proc_net_remove(net, "ipv6_route");
+	proc_net_remove(net, "rt6_stats");
+#endif
+}
+
 static struct pernet_operations ip6_route_net_ops =3D {
 	.init =3D ip6_route_net_init,
 	.exit =3D ip6_route_net_exit,
 };
=20
+static struct pernet_operations ip6_route_net_late_ops =3D {
+	.init =3D ip6_route_net_init_late,
+	.exit =3D ip6_route_net_exit_late,
+};
+
 static struct notifier_block ip6_route_dev_notifier =3D {
 	.notifier_call =3D ip6_route_dev_notify,
 	.priority =3D 0,
@@ -2971,19 +2985,25 @@ int __init ip6_route_init(void)
 	if (ret)
 		goto xfrm6_init;
=20
+	ret =3D register_pernet_subsys(&ip6_route_net_late_ops);
+	if (ret)
+		goto fib6_rules_init;
+
 	ret =3D -ENOBUFS;
 	if (__rtnl_register(PF_INET6, RTM_NEWROUTE, inet6_rtm_newroute, NULL, NUL=
L) ||
 	    __rtnl_register(PF_INET6, RTM_DELROUTE, inet6_rtm_delroute, NULL, NUL=
L) ||
 	    __rtnl_register(PF_INET6, RTM_GETROUTE, inet6_rtm_getroute, NULL, NUL=
L))
-		goto fib6_rules_init;
+		goto out_register_late_subsys;
=20
 	ret =3D register_netdevice_notifier(&ip6_route_dev_notifier);
 	if (ret)
-		goto fib6_rules_init;
+		goto out_register_late_subsys;
=20
 out:
 	return ret;
=20
+out_register_late_subsys:
+	unregister_pernet_subsys(&ip6_route_net_late_ops);
 fib6_rules_init:
 	fib6_rules_cleanup();
 xfrm6_init:
@@ -3002,6 +3022,7 @@ out_kmem_cache:
 void ip6_route_cleanup(void)
 {
 	unregister_netdevice_notifier(&ip6_route_dev_notifier);
+	unregister_pernet_subsys(&ip6_route_net_late_ops);
 	fib6_rules_cleanup();
 	xfrm6_fini();
 	fib6_gc_cleanup();
diff --git a/net/l2tp/l2tp_eth.c b/net/l2tp/l2tp_eth.c
index d2726a7..3c55f63 100644
--- a/net/l2tp/l2tp_eth.c
+++ b/net/l2tp/l2tp_eth.c
@@ -167,6 +167,7 @@ static void l2tp_eth_delete(struct l2tp_session *sessio=
n)
 		if (dev) {
 			unregister_netdev(dev);
 			spriv->dev =3D NULL;
+			module_put(THIS_MODULE);
 		}
 	}
 }
@@ -254,6 +255,7 @@ static int l2tp_eth_create(struct net *net, u32 tunnel_=
id, u32 session_id, u32 p
 	if (rc < 0)
 		goto out_del_dev;
=20
+	__module_get(THIS_MODULE);
 	/* Must be done after register_netdev() */
 	strlcpy(session->ifname, dev->name, IFNAMSIZ);
=20
diff --git a/net/l2tp/l2tp_ip.c b/net/l2tp/l2tp_ip.c
index 2fbbe1f..6c7e609 100644
--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
@@ -515,10 +515,12 @@ static int l2tp_ip_sendmsg(struct kiocb *iocb, struct=
 sock *sk, struct msghdr *m
 					   sk->sk_bound_dev_if);
 		if (IS_ERR(rt))
 			goto no_route;
-		if (connected)
+		if (connected) {
 			sk_setup_caps(sk, &rt->dst);
-		else
-			dst_release(&rt->dst); /* safe since we hold rcu_read_lock */
+		} else {
+			skb_dst_set(skb, &rt->dst);
+			goto xmit;
+		}
 	}
=20
 	/* We dont need to clone dst here, it is guaranteed to not disappear.
@@ -526,6 +528,7 @@ static int l2tp_ip_sendmsg(struct kiocb *iocb, struct s=
ock *sk, struct msghdr *m
 	 */
 	skb_dst_set_noref(skb, &rt->dst);
=20
+xmit:
 	/* Queue the packet to IP for output */
 	rc =3D ip_queue_xmit(skb, &inet->cork.fl);
 	rcu_read_unlock();
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 064d20f..cda4875 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2389,7 +2389,7 @@ ieee80211_rx_h_action_return(struct ieee80211_rx_data=
 *rx)
 	 * frames that we didn't handle, including returning unknown
 	 * ones. For all other modes we will return them to the sender,
 	 * setting the 0x80 bit in the action category, as required by
-	 * 802.11-2007 7.3.1.11.
+	 * 802.11-2012 9.24.4.
 	 * Newer versions of hostapd shall also use the management frame
 	 * registration mechanisms, but older ones still use cooked
 	 * monitor interfaces so push all frames there.
@@ -2399,6 +2399,9 @@ ieee80211_rx_h_action_return(struct ieee80211_rx_data=
 *rx)
 	     sdata->vif.type =3D=3D NL80211_IFTYPE_AP_VLAN))
 		return RX_DROP_MONITOR;
=20
+	if (is_multicast_ether_addr(mgmt->da))
+		return RX_DROP_MONITOR;
+
 	/* do not return rejected action frames */
 	if (mgmt->u.action.category & 0x80)
 		return RX_DROP_UNUSABLE;
diff --git a/net/nfc/nci/ntf.c b/net/nfc/nci/ntf.c
index 96633f5..12b6a80 100644
--- a/net/nfc/nci/ntf.c
+++ b/net/nfc/nci/ntf.c
@@ -86,7 +86,7 @@ static int nci_rf_activate_nfca_passive_poll(struct nci_d=
ev *ndev,
 	nfca_poll->sens_res =3D __le16_to_cpu(*((__u16 *)data));
 	data +=3D 2;
=20
-	nfca_poll->nfcid1_len =3D *data++;
+	nfca_poll->nfcid1_len =3D min_t(__u8, *data++, sizeof(nfca_poll->nfcid1))=
;
=20
 	nfc_dbg("sens_res 0x%x, nfcid1_len %d",
 		nfca_poll->sens_res,
@@ -111,7 +111,7 @@ static int nci_rf_activate_nfca_passive_poll(struct nci=
_dev *ndev,
=20
 	switch (ntf->rf_interface_type) {
 	case NCI_RF_INTERFACE_ISO_DEP:
-		nfca_poll_iso_dep->rats_res_len =3D *data++;
+		nfca_poll_iso_dep->rats_res_len =3D min_t(__u8, *data++, 20);
 		if (nfca_poll_iso_dep->rats_res_len > 0) {
 			memcpy(nfca_poll_iso_dep->rats_res,
 				data,
diff --git a/net/nfc/rawsock.c b/net/nfc/rawsock.c
index ee7b2b3..7a167fc 100644
--- a/net/nfc/rawsock.c
+++ b/net/nfc/rawsock.c
@@ -52,7 +52,10 @@ static int rawsock_release(struct socket *sock)
 {
 	struct sock *sk =3D sock->sk;
=20
-	nfc_dbg("sock=3D%p", sock);
+	nfc_dbg("sock=3D%p sk=3D%p", sock, sk);
+
+	if (!sk)
+		return 0;
=20
 	sock_orphan(sk);
 	sock_put(sk);
diff --git a/sound/pci/hda/patch_sigmatel.c b/sound/pci/hda/patch_sigmatel.=
c
index 7b7a516..2b973f5 100644
--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -4457,7 +4457,7 @@ static int stac92xx_init(struct hda_codec *codec)
 					 AC_PINCTL_IN_EN);
 	for (i =3D 0; i < spec->num_pwrs; i++)  {
 		hda_nid_t nid =3D spec->pwr_nids[i];
-		int pinctl, def_conf;
+		unsigned int pinctl, def_conf;
=20
 		/* power on when no jack detection is available */
 		/* or when the VREF is used for controlling LED */
@@ -4484,7 +4484,7 @@ static int stac92xx_init(struct hda_codec *codec)
 		def_conf =3D get_defcfg_connect(def_conf);
 		/* skip any ports that don't have jacks since presence
  		 * detection is useless */
-		if (def_conf !=3D AC_JACK_PORT_NONE &&
+		if (def_conf !=3D AC_JACK_PORT_COMPLEX ||
 		    !is_jack_detectable(codec, nid)) {
 			stac_toggle_power_map(codec, nid, 1);
 			continue;
diff --git a/sound/soc/codecs/tlv320aic3x.c b/sound/soc/codecs/tlv320aic3x.=
c
index 87d5ef1..8b48801 100644
--- a/sound/soc/codecs/tlv320aic3x.c
+++ b/sound/soc/codecs/tlv320aic3x.c
@@ -963,9 +963,7 @@ static int aic3x_hw_params(struct snd_pcm_substream *su=
bstream,
 	}
=20
 found:
-	data =3D snd_soc_read(codec, AIC3X_PLL_PROGA_REG);
-	snd_soc_write(codec, AIC3X_PLL_PROGA_REG,
-		      data | (pll_p << PLLP_SHIFT));
+	snd_soc_update_bits(codec, AIC3X_PLL_PROGA_REG, PLLP_MASK, pll_p);
 	snd_soc_write(codec, AIC3X_OVRF_STATUS_AND_PLLR_REG,
 		      pll_r << PLLR_SHIFT);
 	snd_soc_write(codec, AIC3X_PLL_PROGB_REG, pll_j << PLLJ_SHIFT);
diff --git a/sound/soc/codecs/tlv320aic3x.h b/sound/soc/codecs/tlv320aic3x.=
h
index 06a1978..16d9999 100644
--- a/sound/soc/codecs/tlv320aic3x.h
+++ b/sound/soc/codecs/tlv320aic3x.h
@@ -166,6 +166,7 @@
=20
 /* PLL registers bitfields */
 #define PLLP_SHIFT		0
+#define PLLP_MASK		7
 #define PLLQ_SHIFT		3
 #define PLLR_SHIFT		0
 #define PLLJ_SHIFT		2


--=20
Ben Hutchings
The generation of random numbers is too important to be left to chance.
                                                            - Robert Coveyo=
u

--=-RlaR+Kr5l+wq61ic9Bpv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT/94t+e/yOyVhhEJAQoWvBAAmgrwv+rAUPjkMRXuMW2HRP2v45PuGrND
9Vkfy1eKxmJJUkVc3ppQBntUczj5syIyo2SxpYU3AzGtdVXeXuINGZKSvU1KA7Zx
2SCC3dveGvR9q6JHWquwm7suGxPWy9VNT66ozZFMOnrwOptdTp0yNot4/vP4O7yQ
uStcABwxrFfUiBn2pF4tIZPKfhmy4tuGlx+2UQ14gjy8R15id5InmD2Y4JjBMR1O
his7A1tqcEeyrbHdBZxQcHLM1mXXkSwD+prDXzXwSjQMpclTUHAhHmvFD0pJlrDt
srOsWl+5z9kvGhThDuJAm8UyYm6GTg5Q1WgYJah0wZ5fz0cNB/QgKxoyOZbzoxUz
WFhd2mlDUERo+cnb/kMDf6P3utvx+FwiNdZlM61sG/OcGfKMYea4GqHodeRhm+/0
TClWHspmJnL7UoqC/HCaWuQneC/Dn9eh1GjthoxU4jDRXXyU3mxtKR4MjdfSc6Fn
vG+UqE0kKTmiD/qltVoneOo0/En+XgVbKeNNQ88vmlHwdkkCT1QFVyfmV49NjagY
kyp8JtpEPeLEo5KMkfMmSIIva0p+vpw+ad6wt66NRrwt8+FNgYxJBoPS/bSWKnGu
uQjg0o4dtJdx7XvfSm7hsR7OmqtTYV/CQocFNI/jUF+fMYvUP0tdjusn+at+tqyH
E3jQsUOTYW4=
=XCgT
-----END PGP SIGNATURE-----

--=-RlaR+Kr5l+wq61ic9Bpv--
