Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab0HBTDu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 15:03:50 -0400
Received: from kroah.org ([198.145.64.141]:37004 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754294Ab0HBTDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 15:03:13 -0400
Date: Mon, 2 Aug 2010 12:00:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.27.49
Message-ID: <20100802190030.GB17098@kroah.com>
References: <20100802190010.GA17098@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100802190010.GA17098@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 6411139..382a8dd 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 27
-EXTRAVERSION = .48
+EXTRAVERSION = .49
 NAME = Trembling Tortoise
 
 # *DOCUMENTATION*
diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index 34bc987..d8a4dc6 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -102,11 +102,16 @@ int use_calgary __read_mostly = 0;
 #define PMR_SOFTSTOPFAULT	0x40000000
 #define PMR_HARDSTOP		0x20000000
 
-#define MAX_NUM_OF_PHBS		8 /* how many PHBs in total? */
-#define MAX_NUM_CHASSIS		8 /* max number of chassis */
-/* MAX_PHB_BUS_NUM is the maximal possible dev->bus->number */
-#define MAX_PHB_BUS_NUM		(MAX_NUM_OF_PHBS * MAX_NUM_CHASSIS * 2)
-#define PHBS_PER_CALGARY	4
+/*
+ * The maximum PHB bus number.
+ * x3950M2 (rare): 8 chassis, 48 PHBs per chassis = 384
+ * x3950M2: 4 chassis, 48 PHBs per chassis        = 192
+ * x3950 (PCIE): 8 chassis, 32 PHBs per chassis   = 256
+ * x3950 (PCIX): 8 chassis, 16 PHBs per chassis   = 128
+ */
+#define MAX_PHB_BUS_NUM		256
+
+#define PHBS_PER_CALGARY	  4
 
 /* register offsets in Calgary's internal register space */
 static const unsigned long tar_offsets[] = {
@@ -1092,8 +1097,6 @@ static int __init calgary_init_one(struct pci_dev *dev)
 	struct iommu_table *tbl;
 	int ret;
 
-	BUG_ON(dev->bus->number >= MAX_PHB_BUS_NUM);
-
 	bbar = busno_to_bbar(dev->bus->number);
 	ret = calgary_setup_tar(dev, bbar);
 	if (ret)
diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
index 7495c52..e144ad8 100644
--- a/drivers/char/agp/amd64-agp.c
+++ b/drivers/char/agp/amd64-agp.c
@@ -491,6 +491,10 @@ static int __devinit agp_amd64_probe(struct pci_dev *pdev,
 	u8 cap_ptr;
 	int err;
 
+	/* The Highlander principle */
+	if (agp_bridges_found)
+		return -ENODEV;
+
 	cap_ptr = pci_find_capability(pdev, PCI_CAP_ID_AGP);
 	if (!cap_ptr)
 		return -ENODEV;
@@ -554,6 +558,8 @@ static void __devexit agp_amd64_remove(struct pci_dev *pdev)
 			   amd64_aperture_sizes[bridge->aperture_size_idx].size);
 	agp_remove_bridge(bridge);
 	agp_put_bridge(bridge);
+
+	agp_bridges_found--;
 }
 
 #ifdef CONFIG_PM
@@ -701,6 +707,11 @@ static struct pci_device_id agp_amd64_pci_table[] = {
 
 MODULE_DEVICE_TABLE(pci, agp_amd64_pci_table);
 
+static DEFINE_PCI_DEVICE_TABLE(agp_amd64_pci_promisc_table) = {
+	{ PCI_DEVICE_CLASS(0, 0) },
+	{ }
+};
+
 static struct pci_driver agp_amd64_pci_driver = {
 	.name		= "agpgart-amd64",
 	.id_table	= agp_amd64_pci_table,
@@ -725,7 +736,6 @@ int __init agp_amd64_init(void)
 		return err;
 
 	if (agp_bridges_found == 0) {
-		struct pci_dev *dev;
 		if (!agp_try_unsupported && !agp_try_unsupported_boot) {
 			printk(KERN_INFO PFX "No supported AGP bridge found.\n");
 #ifdef MODULE
@@ -741,17 +751,10 @@ int __init agp_amd64_init(void)
 			return -ENODEV;
 
 		/* Look for any AGP bridge */
-		dev = NULL;
-		err = -ENODEV;
-		for_each_pci_dev(dev) {
-			if (!pci_find_capability(dev, PCI_CAP_ID_AGP))
-				continue;
-			/* Only one bridge supported right now */
-			if (agp_amd64_probe(dev, NULL) == 0) {
-				err = 0;
-				break;
-			}
-		}
+		agp_amd64_pci_driver.id_table = agp_amd64_pci_promisc_table;
+		err = driver_attach(&agp_amd64_pci_driver.driver);
+		if (err == 0 && agp_bridges_found == 0)
+			err = -ENODEV;
 	}
 	return err;
 }
diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 2b8f439..a7f98c9 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -52,6 +52,7 @@ struct coretemp_data {
 	struct mutex update_lock;
 	const char *name;
 	u32 id;
+	u16 core_id;
 	char valid;		/* zero until following fields are valid */
 	unsigned long last_updated;	/* in jiffies */
 	int temp;
@@ -74,7 +75,7 @@ static ssize_t show_name(struct device *dev, struct device_attribute
 	if (attr->index == SHOW_NAME)
 		ret = sprintf(buf, "%s\n", data->name);
 	else	/* show label */
-		ret = sprintf(buf, "Core %d\n", data->id);
+		ret = sprintf(buf, "Core %d\n", data->core_id);
 	return ret;
 }
 
@@ -216,6 +217,9 @@ static int __devinit coretemp_probe(struct platform_device *pdev)
 	}
 
 	data->id = pdev->id;
+#ifdef CONFIG_SMP
+	data->core_id = c->cpu_core_id;
+#endif
 	data->name = "coretemp";
 	mutex_init(&data->update_lock);
 
@@ -313,6 +317,10 @@ struct pdev_entry {
 	struct list_head list;
 	struct platform_device *pdev;
 	unsigned int cpu;
+#ifdef CONFIG_SMP
+	u16 phys_proc_id;
+	u16 cpu_core_id;
+#endif
 };
 
 static LIST_HEAD(pdev_list);
@@ -323,6 +331,22 @@ static int __cpuinit coretemp_device_add(unsigned int cpu)
 	int err;
 	struct platform_device *pdev;
 	struct pdev_entry *pdev_entry;
+#ifdef CONFIG_SMP
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
+#endif
+
+	mutex_lock(&pdev_list_mutex);
+
+#ifdef CONFIG_SMP
+	/* Skip second HT entry of each core */
+	list_for_each_entry(pdev_entry, &pdev_list, list) {
+		if (c->phys_proc_id == pdev_entry->phys_proc_id &&
+		    c->cpu_core_id == pdev_entry->cpu_core_id) {
+			err = 0;	/* Not an error */
+			goto exit;
+		}
+	}
+#endif
 
 	pdev = platform_device_alloc(DRVNAME, cpu);
 	if (!pdev) {
@@ -346,7 +370,10 @@ static int __cpuinit coretemp_device_add(unsigned int cpu)
 
 	pdev_entry->pdev = pdev;
 	pdev_entry->cpu = cpu;
-	mutex_lock(&pdev_list_mutex);
+#ifdef CONFIG_SMP
+	pdev_entry->phys_proc_id = c->phys_proc_id;
+	pdev_entry->cpu_core_id = c->cpu_core_id;
+#endif
 	list_add_tail(&pdev_entry->list, &pdev_list);
 	mutex_unlock(&pdev_list_mutex);
 
@@ -357,6 +384,7 @@ exit_device_free:
 exit_device_put:
 	platform_device_put(pdev);
 exit:
+	mutex_unlock(&pdev_list_mutex);
 	return err;
 }
 
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index e9ca3cb..fb97c42 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1158,7 +1158,7 @@ static ssize_t create_child(struct device *dev,
 
 	return ret ? ret : count;
 }
-static DEVICE_ATTR(create_child, S_IWUGO, NULL, create_child);
+static DEVICE_ATTR(create_child, S_IWUSR, NULL, create_child);
 
 static ssize_t delete_child(struct device *dev,
 			    struct device_attribute *attr,
@@ -1178,7 +1178,7 @@ static ssize_t delete_child(struct device *dev,
 	return ret ? ret : count;
 
 }
-static DEVICE_ATTR(delete_child, S_IWUGO, NULL, delete_child);
+static DEVICE_ATTR(delete_child, S_IWUSR, NULL, delete_child);
 
 int ipoib_add_pkey_attr(struct net_device *dev)
 {
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 598d2e9..b91eb58 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1705,6 +1705,7 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev)
 	case BOND_MODE_ALB:
 		new_slave->state = BOND_STATE_ACTIVE;
 		bond_set_slave_inactive_flags(new_slave);
+		bond_select_active_slave(bond);
 		break;
 	default:
 		dprintk("This slave is always active in trunk mode\n");
diff --git a/drivers/net/cpmac.c b/drivers/net/cpmac.c
index ec6b0af..5cbdd37 100644
--- a/drivers/net/cpmac.c
+++ b/drivers/net/cpmac.c
@@ -1174,7 +1174,8 @@ static int __devinit cpmac_probe(struct platform_device *pdev)
 		if (netif_msg_drv(priv))
 			printk(KERN_ERR "%s: Could not attach to PHY\n",
 			       dev->name);
-		return PTR_ERR(priv->phy);
+		rc = PTR_ERR(priv->phy);
+		goto fail;
 	}
 
 	if ((rc = register_netdev(dev))) {
diff --git a/drivers/net/sky2.c b/drivers/net/sky2.c
index aa9ff46..50e32df 100644
--- a/drivers/net/sky2.c
+++ b/drivers/net/sky2.c
@@ -688,11 +688,24 @@ static void sky2_phy_power_down(struct sky2_hw *hw, unsigned port)
 	sky2_write8(hw, B2_TST_CTRL1, TST_CFG_WRITE_OFF);
 }
 
+/* Enable Rx/Tx */
+static void sky2_enable_rx_tx(struct sky2_port *sky2)
+{
+	struct sky2_hw *hw = sky2->hw;
+	unsigned port = sky2->port;
+	u16 reg;
+
+	reg = gma_read16(hw, port, GM_GP_CTRL);
+	reg |= GM_GPCR_RX_ENA | GM_GPCR_TX_ENA;
+	gma_write16(hw, port, GM_GP_CTRL, reg);
+}
+
 /* Force a renegotiation */
 static void sky2_phy_reinit(struct sky2_port *sky2)
 {
 	spin_lock_bh(&sky2->phy_lock);
 	sky2_phy_init(sky2->hw, sky2->port);
+	sky2_enable_rx_tx(sky2);
 	spin_unlock_bh(&sky2->phy_lock);
 }
 
@@ -1862,7 +1875,6 @@ static void sky2_link_up(struct sky2_port *sky2)
 {
 	struct sky2_hw *hw = sky2->hw;
 	unsigned port = sky2->port;
-	u16 reg;
 	static const char *fc_name[] = {
 		[FC_NONE]	= "none",
 		[FC_TX]		= "tx",
@@ -1870,10 +1882,7 @@ static void sky2_link_up(struct sky2_port *sky2)
 		[FC_BOTH]	= "both",
 	};
 
-	/* enable Rx/Tx */
-	reg = gma_read16(hw, port, GM_GP_CTRL);
-	reg |= GM_GPCR_RX_ENA | GM_GPCR_TX_ENA;
-	gma_write16(hw, port, GM_GP_CTRL, reg);
+	sky2_enable_rx_tx(sky2);
 
 	gm_phy_write(hw, port, PHY_MARV_INT_MASK, PHY_M_DEF_MSK);
 
diff --git a/drivers/net/wireless/hostap/hostap_cs.c b/drivers/net/wireless/hostap/hostap_cs.c
index 3b4e55c..055e991 100644
--- a/drivers/net/wireless/hostap/hostap_cs.c
+++ b/drivers/net/wireless/hostap/hostap_cs.c
@@ -557,6 +557,7 @@ static int prism2_config(struct pcmcia_device *link)
 	config_info_t conf;
 	cistpl_cftable_entry_t dflt = { 0 };
 	struct hostap_cs_priv *hw_priv;
+	unsigned long flags;
 
 	PDEBUG(DEBUG_FLOW, "prism2_config()\n");
 
@@ -688,6 +689,12 @@ static int prism2_config(struct pcmcia_device *link)
 	link->dev_node = &hw_priv->node;
 
 	/*
+	 * Make sure the IRQ handler cannot proceed until at least
+	 * dev->base_addr is initialized.
+	 */
+	spin_lock_irqsave(&local->irq_init_lock, flags);
+
+	/*
 	 * Allocate an interrupt line.  Note that this does not assign a
 	 * handler to the interrupt, unless the 'Handler' member of the
 	 * irq structure is initialized.
@@ -712,6 +719,8 @@ static int prism2_config(struct pcmcia_device *link)
 	dev->irq = link->irq.AssignedIRQ;
 	dev->base_addr = link->io.BasePort1;
 
+	spin_unlock_irqrestore(&local->irq_init_lock, flags);
+
 	/* Finally, report what we've done */
 	printk(KERN_INFO "%s: index 0x%02x: ",
 	       dev_info, link->conf.ConfigIndex);
@@ -742,6 +751,7 @@ static int prism2_config(struct pcmcia_device *link)
 	return ret;
 
  cs_failed:
+	spin_unlock_irqrestore(&local->irq_init_lock, flags);
 	cs_error(link, last_fn, last_ret);
 
  failed:
diff --git a/drivers/net/wireless/hostap/hostap_hw.c b/drivers/net/wireless/hostap/hostap_hw.c
index 3153fe9..04b890f 100644
--- a/drivers/net/wireless/hostap/hostap_hw.c
+++ b/drivers/net/wireless/hostap/hostap_hw.c
@@ -2631,6 +2631,18 @@ static irqreturn_t prism2_interrupt(int irq, void *dev_id)
 	iface = netdev_priv(dev);
 	local = iface->local;
 
+	/* Detect early interrupt before driver is fully configued */
+	spin_lock(&local->irq_init_lock);
+	if (!dev->base_addr) {
+		if (net_ratelimit()) {
+			printk(KERN_DEBUG "%s: Interrupt, but dev not configured\n",
+			       dev->name);
+		}
+		spin_unlock(&local->irq_init_lock);
+		return IRQ_HANDLED;
+	}
+	spin_unlock(&local->irq_init_lock);
+
 	prism2_io_debug_add(dev, PRISM2_IO_DEBUG_CMD_INTERRUPT, 0, 0);
 
 	if (local->func->card_present && !local->func->card_present(local)) {
@@ -3187,6 +3199,7 @@ prism2_init_local_data(struct prism2_helper_functions *funcs, int card_idx,
 	spin_lock_init(&local->cmdlock);
 	spin_lock_init(&local->baplock);
 	spin_lock_init(&local->lock);
+	spin_lock_init(&local->irq_init_lock);
 	mutex_init(&local->rid_bap_mtx);
 
 	if (card_idx < 0 || card_idx >= MAX_PARM_DEVICES)
diff --git a/drivers/net/wireless/hostap/hostap_wlan.h b/drivers/net/wireless/hostap/hostap_wlan.h
index a68f97c..1c986f2 100644
--- a/drivers/net/wireless/hostap/hostap_wlan.h
+++ b/drivers/net/wireless/hostap/hostap_wlan.h
@@ -653,7 +653,7 @@ struct local_info {
 	rwlock_t iface_lock; /* hostap_interfaces read lock; use write lock
 			      * when removing entries from the list.
 			      * TX and RX paths can use read lock. */
-	spinlock_t cmdlock, baplock, lock;
+	spinlock_t cmdlock, baplock, lock, irq_init_lock;
 	struct mutex rid_bap_mtx;
 	u16 infofid; /* MAC buffer id for info frame */
 	/* txfid, intransmitfid, next_txtid, and next_alloc are protected by
diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index a735526..a7b7da1 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -645,9 +645,9 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 				/* Does this really need to be GFP_DMA? */
 				p = kmalloc(usg->sg[i].count,GFP_KERNEL|__GFP_DMA);
 				if(!p) {
-					kfree (usg);
-					dprintk((KERN_DEBUG"aacraid: Could not allocate SG buffer - size = %d buffer number %d of %d\n",
+					dprintk((KERN_DEBUG "aacraid: Could not allocate SG buffer - size = %d buffer number %d of %d\n",
 					  usg->sg[i].count,i,usg->count));
+					kfree(usg);
 					rcode = -ENOMEM;
 					goto cleanup;
 				}
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index cff0c53..31a1668 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1594,6 +1594,14 @@ CIFSSMBWrite(const int xid, struct cifsTconInfo *tcon,
 		*nbytes = le16_to_cpu(pSMBr->CountHigh);
 		*nbytes = (*nbytes) << 16;
 		*nbytes += le16_to_cpu(pSMBr->Count);
+
+		/*
+		 * Mask off high 16 bits when bytes written as returned by the
+		 * server is greater than bytes requested by the client. Some
+		 * OS/2 servers are known to set incorrect CountHigh values.
+		 */
+		if (*nbytes > count)
+			*nbytes &= 0xFFFF;
 	}
 
 	cifs_buf_release(pSMB);
@@ -1679,6 +1687,14 @@ CIFSSMBWrite2(const int xid, struct cifsTconInfo *tcon,
 		*nbytes = le16_to_cpu(pSMBr->CountHigh);
 		*nbytes = (*nbytes) << 16;
 		*nbytes += le16_to_cpu(pSMBr->Count);
+
+		/*
+		 * Mask off high 16 bits when bytes written as returned by the
+		 * server is greater than bytes requested by the client. OS/2
+		 * servers are known to set incorrect CountHigh values.
+		 */
+		if (*nbytes > count)
+			*nbytes &= 0xFFFF;
 	}
 
 /*	cifs_small_buf_release(pSMB); */ /* Freed earlier now in SendReceive2 */
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 3890cc2..52c72ea 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -482,15 +482,7 @@ CIFS_SessSetup(unsigned int xid, struct cifsSesInfo *ses, int first_time,
 
 		/* calculate session key */
 		setup_ntlmv2_rsp(ses, v2_sess_key, nls_cp);
-		if (first_time) /* should this be moved into common code
-				   with similar ntlmv2 path? */
-		/*   cifs_calculate_ntlmv2_mac_key(ses->server->mac_signing_key,
-				response BB FIXME, v2_sess_key); */
-
-		/* copy session key */
-
-	/*	memcpy(bcc_ptr, (char *)ntlm_session_key,LM2_SESS_KEY_SIZE);
-		bcc_ptr += LM2_SESS_KEY_SIZE; */
+		/* FIXME: calculate MAC key */
 		memcpy(bcc_ptr, (char *)v2_sess_key,
 		       sizeof(struct ntlmv2_resp));
 		bcc_ptr += sizeof(struct ntlmv2_resp);
diff --git a/fs/ecryptfs/messaging.c b/fs/ecryptfs/messaging.c
index 1b5c200..517bd46 100644
--- a/fs/ecryptfs/messaging.c
+++ b/fs/ecryptfs/messaging.c
@@ -30,9 +30,9 @@ static struct mutex ecryptfs_msg_ctx_lists_mux;
 
 static struct hlist_head *ecryptfs_daemon_hash;
 struct mutex ecryptfs_daemon_hash_mux;
-static int ecryptfs_hash_buckets;
+static int ecryptfs_hash_bits;
 #define ecryptfs_uid_hash(uid) \
-        hash_long((unsigned long)uid, ecryptfs_hash_buckets)
+        hash_long((unsigned long)uid, ecryptfs_hash_bits)
 
 static u32 ecryptfs_msg_counter;
 static struct ecryptfs_msg_ctx *ecryptfs_msg_ctx_arr;
@@ -599,18 +599,19 @@ int ecryptfs_init_messaging(unsigned int transport)
 	}
 	mutex_init(&ecryptfs_daemon_hash_mux);
 	mutex_lock(&ecryptfs_daemon_hash_mux);
-	ecryptfs_hash_buckets = 1;
-	while (ecryptfs_number_of_users >> ecryptfs_hash_buckets)
-		ecryptfs_hash_buckets++;
+	ecryptfs_hash_bits = 1;
+	while (ecryptfs_number_of_users >> ecryptfs_hash_bits)
+		ecryptfs_hash_bits++;
 	ecryptfs_daemon_hash = kmalloc((sizeof(struct hlist_head)
-					* ecryptfs_hash_buckets), GFP_KERNEL);
+					* (1 << ecryptfs_hash_bits)),
+				       GFP_KERNEL);
 	if (!ecryptfs_daemon_hash) {
 		rc = -ENOMEM;
 		printk(KERN_ERR "%s: Failed to allocate memory\n", __func__);
 		mutex_unlock(&ecryptfs_daemon_hash_mux);
 		goto out;
 	}
-	for (i = 0; i < ecryptfs_hash_buckets; i++)
+	for (i = 0; i < (1 << ecryptfs_hash_bits); i++)
 		INIT_HLIST_HEAD(&ecryptfs_daemon_hash[i]);
 	mutex_unlock(&ecryptfs_daemon_hash_mux);
 	ecryptfs_msg_ctx_arr = kmalloc((sizeof(struct ecryptfs_msg_ctx)
@@ -680,7 +681,7 @@ void ecryptfs_release_messaging(unsigned int transport)
 		int i;
 
 		mutex_lock(&ecryptfs_daemon_hash_mux);
-		for (i = 0; i < ecryptfs_hash_buckets; i++) {
+		for (i = 0; i < (1 << ecryptfs_hash_bits); i++) {
 			int rc;
 
 			hlist_for_each_entry(daemon, elem,
diff --git a/include/math-emu/op-common.h b/include/math-emu/op-common.h
index 408f743..a4cb9d1 100644
--- a/include/math-emu/op-common.h
+++ b/include/math-emu/op-common.h
@@ -793,7 +793,7 @@ do {									\
 		X##_e -= (_FP_W_TYPE_SIZE - rsize);			\
 	X##_e = rsize - X##_e - 1;					\
 									\
-	if (_FP_FRACBITS_##fs < rsize && _FP_WFRACBITS_##fs < X##_e)	\
+	if (_FP_FRACBITS_##fs < rsize && _FP_WFRACBITS_##fs <= X##_e)	\
 	  __FP_FRAC_SRS_1(ur_, (X##_e - _FP_WFRACBITS_##fs + 1), rsize);\
 	_FP_FRAC_DISASSEMBLE_##wc(X, ur_, rsize);			\
 	if ((_FP_WFRACBITS_##fs - X##_e - 1) > 0)			\
diff --git a/net/ipv6/netfilter/ip6t_REJECT.c b/net/ipv6/netfilter/ip6t_REJECT.c
index 44c8d65..1be1a6c 100644
--- a/net/ipv6/netfilter/ip6t_REJECT.c
+++ b/net/ipv6/netfilter/ip6t_REJECT.c
@@ -95,9 +95,11 @@ static void send_reset(struct sk_buff *oldskb)
 	fl.fl_ip_dport = otcph.source;
 	security_skb_classify_flow(oldskb, &fl);
 	dst = ip6_route_output(&init_net, NULL, &fl);
-	if (dst == NULL)
+	if (dst == NULL || dst->error) {
+		dst_release(dst);
 		return;
-	if (dst->error || xfrm_lookup(&dst, &fl, NULL, 0))
+	}
+	if (xfrm_lookup(&dst, &fl, NULL, 0))
 		return;
 
 	hh_len = (dst->dev->hard_header_len + 15)&~15;
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index f05e36a..78480c2 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1292,7 +1292,7 @@ static unsigned int *reloc_location(struct elf_info *elf,
 	int section = sechdr->sh_info;
 
 	return (void *)elf->hdr + sechdrs[section].sh_offset +
-		(r->r_offset - sechdrs[section].sh_addr);
+		r->r_offset - sechdrs[section].sh_addr;
 }
 
 static int addend_386_rel(struct elf_info *elf, Elf_Shdr *sechdr, Elf_Rela *r)
