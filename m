Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab2J1VJt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 17:09:49 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:45255 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755672Ab2J1VJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 17:09:47 -0400
From: Chad Williamson <chad@dahc.us>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Daniel Cotey <puff65537@bansheeslibrary.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Devendra Naga <devendra.aaru@gmail.com>,
        Jesper Juhl <jj@chaosbits.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Chad Williamson <chad@dahc.us>
Subject: [PATCH] Staging: silicom: remove code requiring an old LINUX_VERSION_CODE
Date: Sun, 28 Oct 2012 16:08:18 -0500
Message-Id: <1351458498-18090-1-git-send-email-chad@dahc.us>
X-Mailer: git-send-email 1.7.12.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove all code and associated preprocessor logic dependent on an old
LINUX_VERSION_CODE since such code is dead for an in-kernel driver.

Signed-off-by: Chad Williamson <chad@dahc.us>
---
 drivers/staging/silicom/bp_mod.c           | 207 +----------------------------
 drivers/staging/silicom/bypasslib/bplibk.h |   9 --
 2 files changed, 3 insertions(+), 213 deletions(-)

diff --git a/drivers/staging/silicom/bp_mod.c b/drivers/staging/silicom/bp_mod.c
index f579f14..018b4ff 100644
--- a/drivers/staging/silicom/bp_mod.c
+++ b/drivers/staging/silicom/bp_mod.c
@@ -4319,16 +4319,6 @@ void remove_bypass_wd_auto(bpctl_dev_t *pbpctl_dev)
 		del_timer_sync(&pbpctl_dev->bp_timer);
 #ifdef BP_SELF_TEST
 		pbpctl_dev_sl = get_status_port_fn(pbpctl_dev);
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31))
-		if (pbpctl_dev_sl && (pbpctl_dev_sl->ndev)
-		    && (pbpctl_dev_sl->ndev->hard_start_xmit)
-		    && (pbpctl_dev_sl->hard_start_xmit_save)) {
-			rtnl_lock();
-			pbpctl_dev_sl->ndev->hard_start_xmit =
-			    pbpctl_dev_sl->hard_start_xmit_save;
-			rtnl_unlock();
-		}
-#else
 		if (pbpctl_dev_sl && (pbpctl_dev_sl->ndev)) {
 			if ((pbpctl_dev_sl->ndev->netdev_ops)
 			    && (pbpctl_dev_sl->old_ops)) {
@@ -4342,8 +4332,6 @@ void remove_bypass_wd_auto(bpctl_dev_t *pbpctl_dev)
 			}
 
 		}
-
-#endif
 #endif
 	}
 
@@ -4433,23 +4421,7 @@ int set_bp_self_test(bpctl_dev_t *pbpctl_dev, unsigned int param)
 	if (pbpctl_dev->bp_caps & WD_CTL_CAP) {
 		pbpctl_dev->bp_self_test_flag = param == 0 ? 0 : 1;
 		pbpctl_dev_sl = get_status_port_fn(pbpctl_dev);
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31))
-		if ((pbpctl_dev_sl->ndev) &&
-		    (pbpctl_dev_sl->ndev->hard_start_xmit)) {
-			rtnl_lock();
-			if (pbpctl_dev->bp_self_test_flag == 1) {
 
-				pbpctl_dev_sl->hard_start_xmit_save =
-				    pbpctl_dev_sl->ndev->hard_start_xmit;
-				pbpctl_dev_sl->ndev->hard_start_xmit =
-				    bp_hard_start_xmit;
-			} else if (pbpctl_dev_sl->hard_start_xmit_save) {
-				pbpctl_dev_sl->ndev->hard_start_xmit =
-				    pbpctl_dev_sl->hard_start_xmit_save;
-			}
-			rtnl_unlock();
-		}
-#else
 		if ((pbpctl_dev_sl->ndev) && (pbpctl_dev_sl->ndev->netdev_ops)) {
 			rtnl_lock();
 			if (pbpctl_dev->bp_self_test_flag == 1) {
@@ -4470,7 +4442,6 @@ int set_bp_self_test(bpctl_dev_t *pbpctl_dev, unsigned int param)
 			}
 			rtnl_unlock();
 		}
-#endif
 
 		set_bypass_wd_auto(pbpctl_dev, param);
 		return 0;
@@ -5428,15 +5399,8 @@ static void if_scan_init(void)
 	/* rcu_read_lock(); */
 	/* rtnl_lock();     */
 	/* rcu_read_lock(); */
-#if 1
-#if (LINUX_VERSION_CODE >= 0x020618)
-	for_each_netdev(&init_net, dev)
-#elif (LINUX_VERSION_CODE >= 0x20616)
-	for_each_netdev(dev)
-#else
-	for (dev = dev_base; dev; dev = dev->next)
-#endif
-	{
+
+	for_each_netdev(&init_net, dev) {
 
 		struct ethtool_drvinfo drvinfo;
 		char cbuf[32];
@@ -5489,22 +5453,14 @@ static void if_scan_init(void)
 		}
 
 	}
-#endif
 	/* rtnl_unlock();     */
 	/* rcu_read_unlock(); */
 
 }
 
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
-static int device_ioctl(struct inode *inode,	/* see include/linux/fs.h */
-			struct file *file,	/* ditto */
-			unsigned int ioctl_num,	/* number and param for ioctl */
-			unsigned long ioctl_param)
-#else
-static long device_ioctl(struct file *file,	/* ditto */
+static long device_ioctl(struct file *file,	/* see include/linux/fs.h */
 			 unsigned int ioctl_num,	/* number and param for ioctl */
 			 unsigned long ioctl_param)
-#endif
 {
 	struct bpctl_cmd bpctl_cmd;
 	int dev_idx = 0;
@@ -5515,9 +5471,7 @@ static long device_ioctl(struct file *file,	/* ditto */
 
 	static bpctl_dev_t *pbpctl_dev;
 
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,30))
 	/* lock_kernel(); */
-#endif
 	lock_bpctl();
 	/* local_irq_save(flags); */
 	/* if(!spin_trylock_irqsave(&bpvm_lock)){
@@ -5898,9 +5852,7 @@ static long device_ioctl(struct file *file,	/* ditto */
 		ret = -EFAULT;
 	ret = SUCCESS;
  bp_exit:
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,30))
 	/* unlock_kernel(); */
-#endif
 	/* spin_unlock_irqrestore(&bpvm_lock, flags); */
 	unlock_bpctl();
 	/* unlock_kernel(); */
@@ -5909,12 +5861,7 @@ static long device_ioctl(struct file *file,	/* ditto */
 
 struct file_operations Fops = {
 	.owner = THIS_MODULE,
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
-	.ioctl = device_ioctl,
-#else
 	.unlocked_ioctl = device_ioctl,
-#endif
-
 	.open = device_open,
 	.release = device_release,	/* a.k.a. close */
 };
@@ -6950,15 +6897,8 @@ static int __init bypass_init_module(void)
 				memset(bpctl_dev_arr[idx_dev].bp_tx_data + 7,
 				       0xaa, 5);
 
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,9))
-				bpctl_dev_arr[idx_dev].bp_tx_data[12] =
-				    (ETH_P_BPTEST >> 8) & 0xff;
-				bpctl_dev_arr[idx_dev].bp_tx_data[13] =
-				    ETH_P_BPTEST & 0xff;
-#else
 				*(__be16 *) (bpctl_dev_arr[idx_dev].bp_tx_data +
 					     12) = htons(ETH_P_BPTEST);
-#endif
 
 			} else
 				printk("bp_ctl: Memory allocation error!\n");
@@ -7007,83 +6947,6 @@ static int __init bypass_init_module(void)
 		}
 	}
 
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0))
-	inter_module_register("is_bypass_sd", THIS_MODULE, &is_bypass_sd);
-	inter_module_register("get_bypass_slave_sd", THIS_MODULE,
-			      &get_bypass_slave_sd);
-	inter_module_register("get_bypass_caps_sd", THIS_MODULE,
-			      &get_bypass_caps_sd);
-	inter_module_register("get_wd_set_caps_sd", THIS_MODULE,
-			      &get_wd_set_caps_sd);
-	inter_module_register("set_bypass_sd", THIS_MODULE, &set_bypass_sd);
-	inter_module_register("get_bypass_sd", THIS_MODULE, &get_bypass_sd);
-	inter_module_register("get_bypass_change_sd", THIS_MODULE,
-			      &get_bypass_change_sd);
-	inter_module_register("set_dis_bypass_sd", THIS_MODULE,
-			      &set_dis_bypass_sd);
-	inter_module_register("get_dis_bypass_sd", THIS_MODULE,
-			      &get_dis_bypass_sd);
-	inter_module_register("set_bypass_pwoff_sd", THIS_MODULE,
-			      &set_bypass_pwoff_sd);
-	inter_module_register("get_bypass_pwoff_sd", THIS_MODULE,
-			      &get_bypass_pwoff_sd);
-	inter_module_register("set_bypass_pwup_sd", THIS_MODULE,
-			      &set_bypass_pwup_sd);
-	inter_module_register("get_bypass_pwup_sd", THIS_MODULE,
-			      &get_bypass_pwup_sd);
-	inter_module_register("get_bypass_wd_sd", THIS_MODULE,
-			      &get_bypass_wd_sd);
-	inter_module_register("set_bypass_wd_sd", THIS_MODULE,
-			      &set_bypass_wd_sd);
-	inter_module_register("get_wd_expire_time_sd", THIS_MODULE,
-			      &get_wd_expire_time_sd);
-	inter_module_register("reset_bypass_wd_timer_sd", THIS_MODULE,
-			      &reset_bypass_wd_timer_sd);
-	inter_module_register("set_std_nic_sd", THIS_MODULE, &set_std_nic_sd);
-	inter_module_register("get_std_nic_sd", THIS_MODULE, &get_std_nic_sd);
-	inter_module_register("set_tx_sd", THIS_MODULE, &set_tx_sd);
-	inter_module_register("get_tx_sd", THIS_MODULE, &get_tx_sd);
-	inter_module_register("set_tpl_sd", THIS_MODULE, &set_tpl_sd);
-	inter_module_register("get_tpl_sd", THIS_MODULE, &get_tpl_sd);
-
-	inter_module_register("set_bp_hw_reset_sd", THIS_MODULE,
-			      &set_bp_hw_reset_sd);
-	inter_module_register("get_bp_hw_reset_sd", THIS_MODULE,
-			      &get_bp_hw_reset_sd);
-
-	inter_module_register("set_tap_sd", THIS_MODULE, &set_tap_sd);
-	inter_module_register("get_tap_sd", THIS_MODULE, &get_tap_sd);
-	inter_module_register("get_tap_change_sd", THIS_MODULE,
-			      &get_tap_change_sd);
-	inter_module_register("set_dis_tap_sd", THIS_MODULE, &set_dis_tap_sd);
-	inter_module_register("get_dis_tap_sd", THIS_MODULE, &get_dis_tap_sd);
-	inter_module_register("set_tap_pwup_sd", THIS_MODULE, &set_tap_pwup_sd);
-	inter_module_register("get_tap_pwup_sd", THIS_MODULE, &get_tap_pwup_sd);
-	inter_module_register("set_bp_disc_sd", THIS_MODULE, &set_bp_disc_sd);
-	inter_module_register("get_bp_disc_sd", THIS_MODULE, &get_bp_disc_sd);
-	inter_module_register("get_bp_disc_change_sd", THIS_MODULE,
-			      &get_bp_disc_change_sd);
-	inter_module_register("set_bp_dis_disc_sd", THIS_MODULE,
-			      &set_bp_dis_disc_sd);
-	inter_module_register("get_bp_dis_disc_sd", THIS_MODULE,
-			      &get_bp_dis_disc_sd);
-	inter_module_register("set_bp_disc_pwup_sd", THIS_MODULE,
-			      &set_bp_disc_pwup_sd);
-	inter_module_register("get_bp_disc_pwup_sd", THIS_MODULE,
-			      &get_bp_disc_pwup_sd);
-	inter_module_register("set_wd_exp_mode_sd", THIS_MODULE,
-			      &set_wd_exp_mode_sd);
-	inter_module_register("get_wd_exp_mode_sd", THIS_MODULE,
-			      &get_wd_exp_mode_sd);
-	inter_module_register("set_wd_autoreset_sd", THIS_MODULE,
-			      &set_wd_autoreset_sd);
-	inter_module_register("get_wd_autoreset_sd", THIS_MODULE,
-			      &get_wd_autoreset_sd);
-	inter_module_register("get_bypass_info_sd", THIS_MODULE,
-			      &get_bypass_info_sd);
-	inter_module_register("bp_if_scan_sd", THIS_MODULE, &bp_if_scan_sd);
-
-#endif
 	register_netdevice_notifier(&bp_notifier_block);
 #ifdef BP_PROC_SUPPORT
 	{
@@ -7113,58 +6976,8 @@ static int __init bypass_init_module(void)
 static void __exit bypass_cleanup_module(void)
 {
 	int i;
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,23))
-	int ret;
-#endif
 	unregister_netdevice_notifier(&bp_notifier_block);
 
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0))
-	inter_module_unregister("is_bypass_sd");
-	inter_module_unregister("get_bypass_slave_sd");
-	inter_module_unregister("get_bypass_caps_sd");
-	inter_module_unregister("get_wd_set_caps_sd");
-	inter_module_unregister("set_bypass_sd");
-	inter_module_unregister("get_bypass_sd");
-	inter_module_unregister("get_bypass_change_sd");
-	inter_module_unregister("set_dis_bypass_sd");
-	inter_module_unregister("get_dis_bypass_sd");
-	inter_module_unregister("set_bypass_pwoff_sd");
-	inter_module_unregister("get_bypass_pwoff_sd");
-	inter_module_unregister("set_bypass_pwup_sd");
-	inter_module_unregister("get_bypass_pwup_sd");
-	inter_module_unregister("set_bypass_wd_sd");
-	inter_module_unregister("get_bypass_wd_sd");
-	inter_module_unregister("get_wd_expire_time_sd");
-	inter_module_unregister("reset_bypass_wd_timer_sd");
-	inter_module_unregister("set_std_nic_sd");
-	inter_module_unregister("get_std_nic_sd");
-	inter_module_unregister("set_tx_sd");
-	inter_module_unregister("get_tx_sd");
-	inter_module_unregister("set_tpl_sd");
-	inter_module_unregister("get_tpl_sd");
-	inter_module_unregister("set_tap_sd");
-	inter_module_unregister("get_tap_sd");
-	inter_module_unregister("get_tap_change_sd");
-	inter_module_unregister("set_dis_tap_sd");
-	inter_module_unregister("get_dis_tap_sd");
-	inter_module_unregister("set_tap_pwup_sd");
-	inter_module_unregister("get_tap_pwup_sd");
-	inter_module_unregister("set_bp_disc_sd");
-	inter_module_unregister("get_bp_disc_sd");
-	inter_module_unregister("get_bp_disc_change_sd");
-	inter_module_unregister("set_bp_dis_disc_sd");
-	inter_module_unregister("get_bp_dis_disc_sd");
-	inter_module_unregister("set_bp_disc_pwup_sd");
-	inter_module_unregister("get_bp_disc_pwup_sd");
-	inter_module_unregister("set_wd_exp_mode_sd");
-	inter_module_unregister("get_wd_exp_mode_sd");
-	inter_module_unregister("set_wd_autoreset_sd");
-	inter_module_unregister("get_wd_autoreset_sd");
-	inter_module_unregister("get_bypass_info_sd");
-	inter_module_unregister("bp_if_scan_sd");
-
-#endif
-
 	for (i = 0; i < device_num; i++) {
 		/* unsigned long flags; */
 #ifdef BP_PROC_SUPPORT
@@ -7196,17 +7009,7 @@ static void __exit bypass_cleanup_module(void)
 /*
 * Unregister the device                             
 */
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,23))
-	ret = unregister_chrdev(major_num, DEVICE_NAME);
-/*
-* If there's an error, report it
-*/
-	if (ret < 0)
-		printk("Error in module_unregister_chrdev: %d\n", ret);
-#else
 	unregister_chrdev(major_num, DEVICE_NAME);
-
-#endif
 }
 
 module_init(bypass_init_module);
@@ -7595,11 +7398,7 @@ static struct proc_dir_entry *proc_getdir(char *name,
 	}
 	if (pde == (struct proc_dir_entry *)0) {
 		/* create the directory */
-#if (LINUX_VERSION_CODE > 0x20300)
 		pde = proc_mkdir(name, proc_dir);
-#else
-		pde = create_proc_entry(name, S_IFDIR, proc_dir);
-#endif
 		if (pde == (struct proc_dir_entry *)0) {
 
 			return pde;
diff --git a/drivers/staging/silicom/bypasslib/bplibk.h b/drivers/staging/silicom/bypasslib/bplibk.h
index e9db2d1..a726d90 100644
--- a/drivers/staging/silicom/bypasslib/bplibk.h
+++ b/drivers/staging/silicom/bypasslib/bplibk.h
@@ -29,16 +29,7 @@
         ((pid==INTEL_PEG4BPII_PID)||   \
           (pid==INTEL_PEG4BPFII_PID)))
 
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,10))
-#define pci_get_class pci_find_class
-
-#define pci_get_device pci_find_device
-
-#endif
-
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,10))
 #define EXPORT_SYMBOL_NOVERS EXPORT_SYMBOL
-#endif
 
 #ifdef BP_VENDOR_SUPPORT
 char *bp_desc_array[] =
-- 
1.7.12.4

