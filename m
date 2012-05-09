Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758734Ab2EIOKS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:10:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34094 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272Ab2EIOKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:10:14 -0400
Message-ID: <4FAA7AB2.7040802@redhat.com>
Date: Wed, 09 May 2012 11:09:54 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>,
        Greg K H <gregkh@linuxfoundation.org>
Subject: [PATCH v21] edac: rewrite the sysfs code to use struct device - Was:
 Re: [EDAC ABI v13 09/25] edac: rewrite the sysfs code to use struct device
References: <1334608729-30803-1-git-send-email-mchehab@redhat.com> <1334608729-30803-10-git-send-email-mchehab@redhat.com> <20120509123441.GC22737@aftab.osrc.amd.com> <4FAA6CC9.5060106@redhat.com> <20120509132455.GE22737@aftab.osrc.amd.com>
In-Reply-To: <20120509132455.GE22737@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 09-05-2012 10:24, Borislav Petkov escreveu:
> On Wed, May 09, 2012 at 10:10:33AM -0300, Mauro Carvalho Chehab wrote:
>> This is fixed by this patch, already acked-by Greg:
>> 	[EDAC ABI v13 17/25] edac: Create a per-Memory Controller bus
>> 	http://git.infradead.org/users/mchehab/edac.git/commit/a2c90149c2e87e51908003b1ba504f92d749f74b
>>
>> Basically, on devices with multiple controllers, there a separate per-memory controller bus
>> is needed due to sysfs nodes under /sys/bus.
>>
>> I opted to keep it on a separate patch, in order to preserve the history, and properly
>> document why this is needed.
> 
> We don't apply patches causing oopses like that because this breaks
> bisection.
> 

Merged both patches, adding the second comment as a note.

Regards,
Mauro

-

edac: rewrite the sysfs code to use struct device

From: Mauro Carvalho Chehab <mchehab@redhat.com>

The EDAC subsystem uses the old struct sysdev approach,
creating all nodes using the raw sysfs API. This is bad,
as the API is deprecated.

As we'll be changing the EDAC API, let's first port the existing
code to struct device.

There's one drawback on this patch: driver-specific sysfs
nodes, used by mpc85xx_edac, amd64_edac and i7core_edac
 won't be created anymore. While it would be possible to
also port the device-specific code, that would mix kobj with
struct device, with is not recommended. Also, it is easier and nicer
to move the code to the drivers, instead, as the core can get rid
of some complex logic that just emulates what the device_add()
and device_create_file() already does.

The next patches will convert the driver-specific code to use
the device-specific calls. Then, the remaining bits of the old
sysfs API will be removed.

NOTE: a per-MC bus is required, otherwise devices with more than
one memory controller will hit a bug like the one below:

[  819.094946] EDAC DEBUG: find_mci_by_dev: find_mci_by_dev()
[  819.094948] EDAC DEBUG: edac_create_sysfs_mci_device: edac_create_sysfs_mci_device() idx=1
[  819.094952] EDAC DEBUG: edac_create_sysfs_mci_device: edac_create_sysfs_mci_device(): creating device mc1
[  819.094967] EDAC DEBUG: edac_create_sysfs_mci_device: edac_create_sysfs_mci_device creating dimm0, located at channel 0 slot 0
[  819.094984] ------------[ cut here ]------------
[  819.100142] WARNING: at fs/sysfs/dir.c:481 sysfs_add_one+0xc1/0xf0()
[  819.107282] Hardware name: S2600CP
[  819.111078] sysfs: cannot create duplicate filename '/bus/edac/devices/dimm0'
[  819.119062] Modules linked in: sb_edac(+) edac_core ip6table_filter ip6_tables ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables bridge stp llc sunrpc binfmt_misc dm_mirror dm_region_hash dm_log vhost_net macvtap macvlan tun kvm microcode pcspkr iTCO_wdt iTCO_vendor_support igb i2c_i801 i2c_core sg ioatdma dca sr_mod cdrom sd_mod crc_t10dif ahci libahci isci libsas libata scsi_transport_sas scsi_mod wmi dm_mod [last unloaded: scsi_wait_scan]
[  819.175748] Pid: 10902, comm: modprobe Not tainted 3.3.0-0.11.el7.v12.2.x86_64 #1
[  819.184113] Call Trace:
[  819.186868]  [<ffffffff8105adaf>] warn_slowpath_common+0x7f/0xc0
[  819.193573]  [<ffffffff8105aea6>] warn_slowpath_fmt+0x46/0x50
[  819.200000]  [<ffffffff811f53d1>] sysfs_add_one+0xc1/0xf0
[  819.206025]  [<ffffffff811f5cf5>] sysfs_do_create_link+0x135/0x220
[  819.212944]  [<ffffffff811f7023>] ? sysfs_create_group+0x13/0x20
[  819.219656]  [<ffffffff811f5df3>] sysfs_create_link+0x13/0x20
[  819.226109]  [<ffffffff813b04f6>] bus_add_device+0xe6/0x1b0
[  819.232350]  [<ffffffff813ae7cb>] device_add+0x2db/0x460
[  819.238300]  [<ffffffffa0325634>] edac_create_dimm_object+0x84/0xf0 [edac_core]
[  819.246460]  [<ffffffffa0325e18>] edac_create_sysfs_mci_device+0xe8/0x290 [edac_core]
[  819.255215]  [<ffffffffa0322e2a>] edac_mc_add_mc+0x5a/0x2c0 [edac_core]
[  819.262611]  [<ffffffffa03412df>] sbridge_register_mci+0x1bc/0x279 [sb_edac]
[  819.270493]  [<ffffffffa03417a3>] sbridge_probe+0xef/0x175 [sb_edac]
[  819.277630]  [<ffffffff813ba4e8>] ? pm_runtime_enable+0x58/0x90
[  819.284268]  [<ffffffff812f430c>] local_pci_probe+0x5c/0xd0
[  819.290508]  [<ffffffff812f5ba1>] __pci_device_probe+0xf1/0x100
[  819.297117]  [<ffffffff812f5bea>] pci_device_probe+0x3a/0x60
[  819.303457]  [<ffffffff813b1003>] really_probe+0x73/0x270
[  819.309496]  [<ffffffff813b138e>] driver_probe_device+0x4e/0xb0
[  819.316104]  [<ffffffff813b149b>] __driver_attach+0xab/0xb0
[  819.322337]  [<ffffffff813b13f0>] ? driver_probe_device+0xb0/0xb0
[  819.329151]  [<ffffffff813af5d6>] bus_for_each_dev+0x56/0x90
[  819.335489]  [<ffffffff813b0d7e>] driver_attach+0x1e/0x20
[  819.341534]  [<ffffffff813b0980>] bus_add_driver+0x1b0/0x2a0
[  819.347884]  [<ffffffffa0347000>] ? 0xffffffffa0346fff
[  819.353641]  [<ffffffff813b19f6>] driver_register+0x76/0x140
[  819.359980]  [<ffffffff8159f18b>] ? printk+0x51/0x53
[  819.365524]  [<ffffffffa0347000>] ? 0xffffffffa0346fff
[  819.371291]  [<ffffffff812f5896>] __pci_register_driver+0x56/0xd0
[  819.378096]  [<ffffffffa0347054>] sbridge_init+0x54/0x1000 [sb_edac]
[  819.385231]  [<ffffffff8100203f>] do_one_initcall+0x3f/0x170
[  819.391577]  [<ffffffff810bcd2e>] sys_init_module+0xbe/0x230
[  819.397926]  [<ffffffff815bb529>] system_call_fastpath+0x16/0x1b
[  819.404633] ---[ end trace 1654fdd39556689f ]---

This happens because the bus is not being properly initialized.
Instead of putting the memory sub-devices inside the memory controller,
it is putting everything under the same directory:

$ tree /sys/bus/edac/
/sys/bus/edac/
├── devices
│   ├── all_channel_counts -> ../../../devices/system/edac/mc/mc0/all_channel_counts
│   ├── csrow0 -> ../../../devices/system/edac/mc/mc0/csrow0
│   ├── csrow1 -> ../../../devices/system/edac/mc/mc0/csrow1
│   ├── csrow2 -> ../../../devices/system/edac/mc/mc0/csrow2
│   ├── dimm0 -> ../../../devices/system/edac/mc/mc0/dimm0
│   ├── dimm1 -> ../../../devices/system/edac/mc/mc0/dimm1
│   ├── dimm3 -> ../../../devices/system/edac/mc/mc0/dimm3
│   ├── dimm6 -> ../../../devices/system/edac/mc/mc0/dimm6
│   ├── inject_addrmatch -> ../../../devices/system/edac/mc/mc0/inject_addrmatch
│   ├── mc -> ../../../devices/system/edac/mc
│   └── mc0 -> ../../../devices/system/edac/mc/mc0
├── drivers
├── drivers_autoprobe
├── drivers_probe
└── uevent

On a multi-memory controller system, the names "csrow%d" and "dimm%d"
should be under "mc%d", and not at the main hierarchy level.

So, we need to create a per-MC bus, in order to have its own namespace.

Reviewed-by: Aristeu Rozanski <arozansk@redhat.com>
Cc: Doug Thompson <norsk5@yahoo.com>
Cc: Greg K H <gregkh@linuxfoundation.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 538a439..b7b060f 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -216,7 +216,7 @@ struct mem_ctl_info *edac_mc_alloc(unsigned mc_num,
 	unsigned size, tot_dimms = 1, count = 1;
 	unsigned tot_csrows = 1, tot_channels = 1, tot_errcount = 0;
 	void *pvt, *p, *ptr = NULL;
-	int i, j, err, row, chn, n, len;
+	int i, j, row, chn, n, len;
 	bool per_rank = false;
 
 	BUG_ON(n_layers > EDAC_MAX_LAYERS || n_layers == 0);
@@ -369,15 +369,6 @@ struct mem_ctl_info *edac_mc_alloc(unsigned mc_num,
 	mci->op_state = OP_ALLOC;
 	INIT_LIST_HEAD(&mci->grp_kobj_list);
 
-	/*
-	 * Initialize the 'root' kobj for the edac_mc controller
-	 */
-	err = edac_mc_register_sysfs_main_kobj(mci);
-	if (err) {
-		kfree(mci);
-		return NULL;
-	}
-
 	/* at this point, the root kobj is valid, and in order to
 	 * 'free' the object, then the function:
 	 *      edac_mc_unregister_sysfs_main_kobj() must be called
@@ -398,7 +389,7 @@ void edac_mc_free(struct mem_ctl_info *mci)
 {
 	debugf1("%s()\n", __func__);
 
-	edac_mc_unregister_sysfs_main_kobj(mci);
+	edac_unregister_sysfs(mci);
 
 	/* free the mci instance memory here */
 	kfree(mci);
diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index c0dde23..b212ee3 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -7,17 +7,20 @@
  *
  * Written Doug Thompson <norsk5@xmission.com> www.softwarebitmaker.com
  *
+ * (c) 2012 - Mauro Carvalho Chehab <mchehab@redhat.com>
+ *	The entire API were re-written, and ported to use struct device
+ *
  */
 
 #include <linux/ctype.h>
 #include <linux/slab.h>
 #include <linux/edac.h>
 #include <linux/bug.h>
+#include <linux/pm_runtime.h>
 
 #include "edac_core.h"
 #include "edac_module.h"
 
-
 /* MC EDAC Controls, setable by module parameter, and sysfs */
 static int edac_mc_log_ue = 1;
 static int edac_mc_log_ce = 1;
@@ -78,6 +81,8 @@ module_param_call(edac_mc_poll_msec, edac_set_poll_msec, param_get_int,
 		  &edac_mc_poll_msec, 0644);
 MODULE_PARM_DESC(edac_mc_poll_msec, "Polling period in milliseconds");
 
+static struct device mci_pdev;
+
 /*
  * various constants for Memory Controllers
  */
@@ -125,308 +130,336 @@ static const char *edac_caps[] = {
 	[EDAC_S16ECD16ED] = "S16ECD16ED"
 };
 
-/* EDAC sysfs CSROW data structures and methods
+/*
+ * EDAC sysfs CSROW data structures and methods
+ */
+
+#define to_csrow(k) container_of(k, struct csrow_info, dev)
+
+/*
+ * We need it to avoid namespace conflicts between the legacy API
+ * and the per-dimm/per-rank one
  */
+#define DEVICE_ATTR_LEGACY(_name, _mode, _show, _store) \
+	struct device_attribute dev_attr_legacy_##_name = __ATTR(_name, _mode, _show, _store)
+
+struct dev_ch_attribute {
+	struct device_attribute attr;
+	int channel;
+};
+
+#define DEVICE_CHANNEL(_name, _mode, _show, _store, _var) \
+	struct dev_ch_attribute dev_attr_legacy_##_name = \
+		{ __ATTR(_name, _mode, _show, _store), (_var) }
+
+#define to_channel(k) (container_of(k, struct dev_ch_attribute, attr)->channel)
 
 /* Set of more default csrow<id> attribute show/store functions */
-static ssize_t csrow_ue_count_show(struct csrow_info *csrow, char *data,
-				int private)
+static ssize_t csrow_ue_count_show(struct device *dev,
+				   struct device_attribute *mattr, char *data)
 {
+	struct csrow_info *csrow = to_csrow(dev);
+
 	return sprintf(data, "%u\n", csrow->ue_count);
 }
 
-static ssize_t csrow_ce_count_show(struct csrow_info *csrow, char *data,
-				int private)
+static ssize_t csrow_ce_count_show(struct device *dev,
+				   struct device_attribute *mattr, char *data)
 {
+	struct csrow_info *csrow = to_csrow(dev);
+
 	return sprintf(data, "%u\n", csrow->ce_count);
 }
 
-static ssize_t csrow_size_show(struct csrow_info *csrow, char *data,
-				int private)
+static ssize_t csrow_size_show(struct device *dev,
+			       struct device_attribute *mattr, char *data)
 {
+	struct csrow_info *csrow = to_csrow(dev);
 	int i;
 	u32 nr_pages = 0;
 
 	for (i = 0; i < csrow->nr_channels; i++)
 		nr_pages += csrow->channels[i].dimm->nr_pages;
-
 	return sprintf(data, "%u\n", PAGES_TO_MiB(nr_pages));
 }
 
-static ssize_t csrow_mem_type_show(struct csrow_info *csrow, char *data,
-				int private)
+static ssize_t csrow_mem_type_show(struct device *dev,
+				   struct device_attribute *mattr, char *data)
 {
+	struct csrow_info *csrow = to_csrow(dev);
+
 	return sprintf(data, "%s\n", mem_types[csrow->channels[0].dimm->mtype]);
 }
 
-static ssize_t csrow_dev_type_show(struct csrow_info *csrow, char *data,
-				int private)
+static ssize_t csrow_dev_type_show(struct device *dev,
+				   struct device_attribute *mattr, char *data)
 {
+	struct csrow_info *csrow = to_csrow(dev);
+
 	return sprintf(data, "%s\n", dev_types[csrow->channels[0].dimm->dtype]);
 }
 
-static ssize_t csrow_edac_mode_show(struct csrow_info *csrow, char *data,
-				int private)
+static ssize_t csrow_edac_mode_show(struct device *dev,
+				    struct device_attribute *mattr,
+				    char *data)
 {
+	struct csrow_info *csrow = to_csrow(dev);
+
 	return sprintf(data, "%s\n", edac_caps[csrow->channels[0].dimm->edac_mode]);
 }
 
 /* show/store functions for DIMM Label attributes */
-static ssize_t channel_dimm_label_show(struct csrow_info *csrow,
-				char *data, int channel)
+static ssize_t channel_dimm_label_show(struct device *dev,
+				       struct device_attribute *mattr,
+				       char *data)
 {
+	struct csrow_info *csrow = to_csrow(dev);
+	unsigned chan = to_channel(mattr);
+	struct rank_info *rank = &csrow->channels[chan];
+
 	/* if field has not been initialized, there is nothing to send */
-	if (!csrow->channels[channel].dimm->label[0])
+	if (!rank->dimm->label[0])
 		return 0;
 
 	return snprintf(data, EDAC_MC_LABEL_LEN, "%s\n",
-			csrow->channels[channel].dimm->label);
+			rank->dimm->label);
 }
 
-static ssize_t channel_dimm_label_store(struct csrow_info *csrow,
-					const char *data,
-					size_t count, int channel)
+static ssize_t channel_dimm_label_store(struct device *dev,
+					struct device_attribute *mattr,
+					const char *data, size_t count)
 {
+	struct csrow_info *csrow = to_csrow(dev);
+	unsigned chan = to_channel(mattr);
+	struct rank_info *rank = &csrow->channels[chan];
+
 	ssize_t max_size = 0;
 
 	max_size = min((ssize_t) count, (ssize_t) EDAC_MC_LABEL_LEN - 1);
-	strncpy(csrow->channels[channel].dimm->label, data, max_size);
-	csrow->channels[channel].dimm->label[max_size] = '\0';
+	strncpy(rank->dimm->label, data, max_size);
+	rank->dimm->label[max_size] = '\0';
 
 	return max_size;
 }
 
 /* show function for dynamic chX_ce_count attribute */
-static ssize_t channel_ce_count_show(struct csrow_info *csrow,
-				char *data, int channel)
+static ssize_t channel_ce_count_show(struct device *dev,
+				     struct device_attribute *mattr, char *data)
 {
-	return sprintf(data, "%u\n", csrow->channels[channel].ce_count);
+	struct csrow_info *csrow = to_csrow(dev);
+	unsigned chan = to_channel(mattr);
+	struct rank_info *rank = &csrow->channels[chan];
+
+	return sprintf(data, "%u\n", rank->ce_count);
 }
 
-/* csrow specific attribute structure */
-struct csrowdev_attribute {
-	struct attribute attr;
-	 ssize_t(*show) (struct csrow_info *, char *, int);
-	 ssize_t(*store) (struct csrow_info *, const char *, size_t, int);
-	int private;
-};
+/* cwrow<id>/attribute files */
+DEVICE_ATTR_LEGACY(size_mb, S_IRUGO, csrow_size_show, NULL);
+DEVICE_ATTR_LEGACY(dev_type, S_IRUGO, csrow_dev_type_show, NULL);
+DEVICE_ATTR_LEGACY(mem_type, S_IRUGO, csrow_mem_type_show, NULL);
+DEVICE_ATTR_LEGACY(edac_mode, S_IRUGO, csrow_edac_mode_show, NULL);
+DEVICE_ATTR_LEGACY(ue_count, S_IRUGO, csrow_ue_count_show, NULL);
+DEVICE_ATTR_LEGACY(ce_count, S_IRUGO, csrow_ce_count_show, NULL);
 
-#define to_csrow(k) container_of(k, struct csrow_info, kobj)
-#define to_csrowdev_attr(a) container_of(a, struct csrowdev_attribute, attr)
+/* default attributes of the CSROW<id> object */
+static struct attribute *csrow_attrs[] = {
+	&dev_attr_legacy_dev_type.attr,
+	&dev_attr_legacy_mem_type.attr,
+	&dev_attr_legacy_edac_mode.attr,
+	&dev_attr_legacy_size_mb.attr,
+	&dev_attr_legacy_ue_count.attr,
+	&dev_attr_legacy_ce_count.attr,
+	NULL,
+};
 
-/* Set of show/store higher level functions for default csrow attributes */
-static ssize_t csrowdev_show(struct kobject *kobj,
-			struct attribute *attr, char *buffer)
-{
-	struct csrow_info *csrow = to_csrow(kobj);
-	struct csrowdev_attribute *csrowdev_attr = to_csrowdev_attr(attr);
+static struct attribute_group csrow_attr_grp = {
+	.attrs	= csrow_attrs,
+};
 
-	if (csrowdev_attr->show)
-		return csrowdev_attr->show(csrow,
-					buffer, csrowdev_attr->private);
-	return -EIO;
-}
+static const struct attribute_group *csrow_attr_groups[] = {
+	&csrow_attr_grp,
+	NULL
+};
 
-static ssize_t csrowdev_store(struct kobject *kobj, struct attribute *attr,
-			const char *buffer, size_t count)
+static void csrow_attr_release(struct device *device)
 {
-	struct csrow_info *csrow = to_csrow(kobj);
-	struct csrowdev_attribute *csrowdev_attr = to_csrowdev_attr(attr);
-
-	if (csrowdev_attr->store)
-		return csrowdev_attr->store(csrow,
-					buffer,
-					count, csrowdev_attr->private);
-	return -EIO;
+	debugf1("Releasing csrow device %s\n", dev_name(device));
 }
 
-static const struct sysfs_ops csrowfs_ops = {
-	.show = csrowdev_show,
-	.store = csrowdev_store
+static struct device_type csrow_attr_type = {
+	.groups		= csrow_attr_groups,
+	.release	= csrow_attr_release,
 };
 
-#define CSROWDEV_ATTR(_name,_mode,_show,_store,_private)	\
-static struct csrowdev_attribute attr_##_name = {			\
-	.attr = {.name = __stringify(_name), .mode = _mode },	\
-	.show   = _show,					\
-	.store  = _store,					\
-	.private = _private,					\
-};
-
-/* default cwrow<id>/attribute files */
-CSROWDEV_ATTR(size_mb, S_IRUGO, csrow_size_show, NULL, 0);
-CSROWDEV_ATTR(dev_type, S_IRUGO, csrow_dev_type_show, NULL, 0);
-CSROWDEV_ATTR(mem_type, S_IRUGO, csrow_mem_type_show, NULL, 0);
-CSROWDEV_ATTR(edac_mode, S_IRUGO, csrow_edac_mode_show, NULL, 0);
-CSROWDEV_ATTR(ue_count, S_IRUGO, csrow_ue_count_show, NULL, 0);
-CSROWDEV_ATTR(ce_count, S_IRUGO, csrow_ce_count_show, NULL, 0);
+/*
+ * possible dynamic channel DIMM Label attribute files
+ *
+ */
 
-/* default attributes of the CSROW<id> object */
-static struct csrowdev_attribute *default_csrow_attr[] = {
-	&attr_dev_type,
-	&attr_mem_type,
-	&attr_edac_mode,
-	&attr_size_mb,
-	&attr_ue_count,
-	&attr_ce_count,
-	NULL,
-};
+#define EDAC_NR_CHANNELS	6
 
-/* possible dynamic channel DIMM Label attribute files */
-CSROWDEV_ATTR(ch0_dimm_label, S_IRUGO | S_IWUSR,
+DEVICE_CHANNEL(ch0_dimm_label, S_IRUGO | S_IWUSR,
 	channel_dimm_label_show, channel_dimm_label_store, 0);
-CSROWDEV_ATTR(ch1_dimm_label, S_IRUGO | S_IWUSR,
+DEVICE_CHANNEL(ch1_dimm_label, S_IRUGO | S_IWUSR,
 	channel_dimm_label_show, channel_dimm_label_store, 1);
-CSROWDEV_ATTR(ch2_dimm_label, S_IRUGO | S_IWUSR,
+DEVICE_CHANNEL(ch2_dimm_label, S_IRUGO | S_IWUSR,
 	channel_dimm_label_show, channel_dimm_label_store, 2);
-CSROWDEV_ATTR(ch3_dimm_label, S_IRUGO | S_IWUSR,
+DEVICE_CHANNEL(ch3_dimm_label, S_IRUGO | S_IWUSR,
 	channel_dimm_label_show, channel_dimm_label_store, 3);
-CSROWDEV_ATTR(ch4_dimm_label, S_IRUGO | S_IWUSR,
+DEVICE_CHANNEL(ch4_dimm_label, S_IRUGO | S_IWUSR,
 	channel_dimm_label_show, channel_dimm_label_store, 4);
-CSROWDEV_ATTR(ch5_dimm_label, S_IRUGO | S_IWUSR,
+DEVICE_CHANNEL(ch5_dimm_label, S_IRUGO | S_IWUSR,
 	channel_dimm_label_show, channel_dimm_label_store, 5);
 
 /* Total possible dynamic DIMM Label attribute file table */
-static struct csrowdev_attribute *dynamic_csrow_dimm_attr[] = {
-	&attr_ch0_dimm_label,
-	&attr_ch1_dimm_label,
-	&attr_ch2_dimm_label,
-	&attr_ch3_dimm_label,
-	&attr_ch4_dimm_label,
-	&attr_ch5_dimm_label
+static struct device_attribute *dynamic_csrow_dimm_attr[] = {
+	&dev_attr_legacy_ch0_dimm_label.attr,
+	&dev_attr_legacy_ch1_dimm_label.attr,
+	&dev_attr_legacy_ch2_dimm_label.attr,
+	&dev_attr_legacy_ch3_dimm_label.attr,
+	&dev_attr_legacy_ch4_dimm_label.attr,
+	&dev_attr_legacy_ch5_dimm_label.attr
 };
 
 /* possible dynamic channel ce_count attribute files */
-CSROWDEV_ATTR(ch0_ce_count, S_IRUGO | S_IWUSR, channel_ce_count_show, NULL, 0);
-CSROWDEV_ATTR(ch1_ce_count, S_IRUGO | S_IWUSR, channel_ce_count_show, NULL, 1);
-CSROWDEV_ATTR(ch2_ce_count, S_IRUGO | S_IWUSR, channel_ce_count_show, NULL, 2);
-CSROWDEV_ATTR(ch3_ce_count, S_IRUGO | S_IWUSR, channel_ce_count_show, NULL, 3);
-CSROWDEV_ATTR(ch4_ce_count, S_IRUGO | S_IWUSR, channel_ce_count_show, NULL, 4);
-CSROWDEV_ATTR(ch5_ce_count, S_IRUGO | S_IWUSR, channel_ce_count_show, NULL, 5);
+DEVICE_CHANNEL(ch0_ce_count, S_IRUGO | S_IWUSR,
+		   channel_ce_count_show, NULL, 0);
+DEVICE_CHANNEL(ch1_ce_count, S_IRUGO | S_IWUSR,
+		   channel_ce_count_show, NULL, 1);
+DEVICE_CHANNEL(ch2_ce_count, S_IRUGO | S_IWUSR,
+		   channel_ce_count_show, NULL, 2);
+DEVICE_CHANNEL(ch3_ce_count, S_IRUGO | S_IWUSR,
+		   channel_ce_count_show, NULL, 3);
+DEVICE_CHANNEL(ch4_ce_count, S_IRUGO | S_IWUSR,
+		   channel_ce_count_show, NULL, 4);
+DEVICE_CHANNEL(ch5_ce_count, S_IRUGO | S_IWUSR,
+		   channel_ce_count_show, NULL, 5);
 
 /* Total possible dynamic ce_count attribute file table */
-static struct csrowdev_attribute *dynamic_csrow_ce_count_attr[] = {
-	&attr_ch0_ce_count,
-	&attr_ch1_ce_count,
-	&attr_ch2_ce_count,
-	&attr_ch3_ce_count,
-	&attr_ch4_ce_count,
-	&attr_ch5_ce_count
+static struct device_attribute *dynamic_csrow_ce_count_attr[] = {
+	&dev_attr_legacy_ch0_ce_count.attr,
+	&dev_attr_legacy_ch1_ce_count.attr,
+	&dev_attr_legacy_ch2_ce_count.attr,
+	&dev_attr_legacy_ch3_ce_count.attr,
+	&dev_attr_legacy_ch4_ce_count.attr,
+	&dev_attr_legacy_ch5_ce_count.attr
 };
 
-#define EDAC_NR_CHANNELS	6
-
-/* Create dynamic CHANNEL files, indexed by 'chan',  under specifed CSROW */
-static int edac_create_channel_files(struct kobject *kobj, int chan)
+/* Create a CSROW object under specifed edac_mc_device */
+static int edac_create_csrow_object(struct mem_ctl_info *mci,
+				    struct csrow_info *csrow, int index)
 {
-	int err = -ENODEV;
+	int err, chan;
 
-	if (chan >= EDAC_NR_CHANNELS)
-		return err;
+	if (csrow->nr_channels >= EDAC_NR_CHANNELS)
+		return -ENODEV;
 
-	/* create the DIMM label attribute file */
-	err = sysfs_create_file(kobj,
-				(struct attribute *)
-				dynamic_csrow_dimm_attr[chan]);
-
-	if (!err) {
-		/* create the CE Count attribute file */
-		err = sysfs_create_file(kobj,
-					(struct attribute *)
-					dynamic_csrow_ce_count_attr[chan]);
-	} else {
-		debugf1("%s()  dimm labels and ce_count files created",
-			__func__);
-	}
+	csrow->dev.type = &csrow_attr_type;
+	csrow->dev.bus = &mci->bus;
+	device_initialize(&csrow->dev);
+	csrow->dev.parent = &mci->dev;
+	dev_set_name(&csrow->dev, "csrow%d", index);
+	dev_set_drvdata(&csrow->dev, csrow);
 
-	return err;
-}
+	debugf0("%s(): creating (virtual) csrow node %s\n", __func__,
+		dev_name(&csrow->dev));
 
-/* No memory to release for this kobj */
-static void edac_csrow_instance_release(struct kobject *kobj)
-{
-	struct mem_ctl_info *mci;
-	struct csrow_info *cs;
+	err = device_add(&csrow->dev);
+	if (err < 0)
+		return err;
 
-	debugf1("%s()\n", __func__);
+	for (chan = 0; chan < csrow->nr_channels; chan++) {
+		err = device_create_file(&csrow->dev,
+					 dynamic_csrow_dimm_attr[chan]);
+		if (err < 0)
+			goto error;
+		err = device_create_file(&csrow->dev,
+					 dynamic_csrow_ce_count_attr[chan]);
+		if (err < 0) {
+			device_remove_file(&csrow->dev,
+					   dynamic_csrow_dimm_attr[chan]);
+			goto error;
+		}
+	}
 
-	cs = container_of(kobj, struct csrow_info, kobj);
-	mci = cs->mci;
+	return 0;
 
-	kobject_put(&mci->edac_mci_kobj);
-}
+error:
+	for (--chan; chan >= 0; chan--) {
+		device_remove_file(&csrow->dev,
+					dynamic_csrow_dimm_attr[chan]);
+		device_remove_file(&csrow->dev,
+					   dynamic_csrow_ce_count_attr[chan]);
+	}
+	put_device(&csrow->dev);
 
-/* the kobj_type instance for a CSROW */
-static struct kobj_type ktype_csrow = {
-	.release = edac_csrow_instance_release,
-	.sysfs_ops = &csrowfs_ops,
-	.default_attrs = (struct attribute **)default_csrow_attr,
-};
+	return err;
+}
 
 /* Create a CSROW object under specifed edac_mc_device */
-static int edac_create_csrow_object(struct mem_ctl_info *mci,
-					struct csrow_info *csrow, int index)
+static int edac_create_csrow_objects(struct mem_ctl_info *mci)
 {
-	struct kobject *kobj_mci = &mci->edac_mci_kobj;
-	struct kobject *kobj;
-	int chan;
-	int err;
+	int err, i, chan;
+	struct csrow_info *csrow;
 
-	/* generate ..../edac/mc/mc<id>/csrow<index>   */
-	memset(&csrow->kobj, 0, sizeof(csrow->kobj));
-	csrow->mci = mci;	/* include container up link */
+	for (i = 0; i < mci->nr_csrows; i++) {
+		err = edac_create_csrow_object(mci, &mci->csrows[i], i);
+		if (err < 0)
+			goto error;
+	}
+	return 0;
 
-	/* bump the mci instance's kobject's ref count */
-	kobj = kobject_get(&mci->edac_mci_kobj);
-	if (!kobj) {
-		err = -ENODEV;
-		goto err_out;
+error:
+	for (--i; i >= 0; i--) {
+		csrow = &mci->csrows[i];
+		for (chan = csrow->nr_channels - 1; chan >= 0; chan--) {
+			device_remove_file(&csrow->dev,
+						dynamic_csrow_dimm_attr[chan]);
+			device_remove_file(&csrow->dev,
+						dynamic_csrow_ce_count_attr[chan]);
+		}
+		put_device(&mci->csrows[i].dev);
 	}
 
-	/* Instanstiate the csrow object */
-	err = kobject_init_and_add(&csrow->kobj, &ktype_csrow, kobj_mci,
-				   "csrow%d", index);
-	if (err)
-		goto err_release_top_kobj;
+	return err;
+}
 
-	/* At this point, to release a csrow kobj, one must
-	 * call the kobject_put and allow that tear down
-	 * to work the releasing
-	 */
+static void edac_delete_csrow_objects(struct mem_ctl_info *mci)
+{
+	int i, chan;
+	struct csrow_info *csrow;
 
-	/* Create the dyanmic attribute files on this csrow,
-	 * namely, the DIMM labels and the channel ce_count
-	 */
-	for (chan = 0; chan < csrow->nr_channels; chan++) {
-		err = edac_create_channel_files(&csrow->kobj, chan);
-		if (err) {
-			/* special case the unregister here */
-			kobject_put(&csrow->kobj);
-			goto err_out;
+	for (i = mci->nr_csrows - 1; i >= 0; i--) {
+		csrow = &mci->csrows[i];
+		for (chan = csrow->nr_channels - 1; chan >= 0; chan--) {
+			debugf1("Removing csrow %d channel %d sysfs nodes\n",
+				i, chan);
+			device_remove_file(&csrow->dev,
+						dynamic_csrow_dimm_attr[chan]);
+			device_remove_file(&csrow->dev,
+						dynamic_csrow_ce_count_attr[chan]);
 		}
+		put_device(&mci->csrows[i].dev);
+		device_del(&mci->csrows[i].dev);
 	}
-	kobject_uevent(&csrow->kobj, KOBJ_ADD);
-	return 0;
-
-	/* error unwind stack */
-err_release_top_kobj:
-	kobject_put(&mci->edac_mci_kobj);
-
-err_out:
-	return err;
 }
 
-/* default sysfs methods and data structures for the main MCI kobject */
+/*
+ * Memory controller device
+ */
 
-static ssize_t mci_reset_counters_store(struct mem_ctl_info *mci,
+#define to_mci(k) container_of(k, struct mem_ctl_info, dev)
+
+static ssize_t mci_reset_counters_store(struct device *dev,
+					struct device_attribute *mattr,
 					const char *data, size_t count)
 {
-	int row, chan;
-
-	mci->ue_noinfo_count = 0;
-	mci->ce_noinfo_count = 0;
+	struct mem_ctl_info *mci = to_mci(dev);
+	int cnt, row, chan, i;
 	mci->ue_mc = 0;
 	mci->ce_mc = 0;
+	mci->ue_noinfo_count = 0;
+	mci->ce_noinfo_count = 0;
 
 	for (row = 0; row < mci->nr_csrows; row++) {
 		struct csrow_info *ri = &mci->csrows[row];
@@ -438,6 +471,13 @@ static ssize_t mci_reset_counters_store(struct mem_ctl_info *mci,
 			ri->channels[chan].ce_count = 0;
 	}
 
+	cnt = 1;
+	for (i = 0; i < mci->n_layers; i++) {
+		cnt *= mci->layers[i].size;
+		memset(mci->ce_per_layer[i], 0, cnt * sizeof(u32));
+		memset(mci->ue_per_layer[i], 0, cnt * sizeof(u32));
+	}
+
 	mci->start_time = jiffies;
 	return count;
 }
@@ -451,9 +491,11 @@ static ssize_t mci_reset_counters_store(struct mem_ctl_info *mci,
  * Negative value still means that an error has occurred while setting
  * the scrub rate.
  */
-static ssize_t mci_sdram_scrub_rate_store(struct mem_ctl_info *mci,
+static ssize_t mci_sdram_scrub_rate_store(struct device *dev,
+					  struct device_attribute *mattr,
 					  const char *data, size_t count)
 {
+	struct mem_ctl_info *mci = to_mci(dev);
 	unsigned long bandwidth = 0;
 	int new_bw = 0;
 
@@ -476,8 +518,11 @@ static ssize_t mci_sdram_scrub_rate_store(struct mem_ctl_info *mci,
 /*
  * ->get_sdram_scrub_rate() return value semantics same as above.
  */
-static ssize_t mci_sdram_scrub_rate_show(struct mem_ctl_info *mci, char *data)
+static ssize_t mci_sdram_scrub_rate_show(struct device *dev,
+					 struct device_attribute *mattr,
+					 char *data)
 {
+	struct mem_ctl_info *mci = to_mci(dev);
 	int bandwidth = 0;
 
 	if (!mci->get_sdram_scrub_rate)
@@ -493,38 +538,65 @@ static ssize_t mci_sdram_scrub_rate_show(struct mem_ctl_info *mci, char *data)
 }
 
 /* default attribute files for the MCI object */
-static ssize_t mci_ue_count_show(struct mem_ctl_info *mci, char *data)
+static ssize_t mci_ue_count_show(struct device *dev,
+				 struct device_attribute *mattr,
+				 char *data)
 {
+	struct mem_ctl_info *mci = to_mci(dev);
+
 	return sprintf(data, "%d\n", mci->ue_mc);
 }
 
-static ssize_t mci_ce_count_show(struct mem_ctl_info *mci, char *data)
+static ssize_t mci_ce_count_show(struct device *dev,
+				 struct device_attribute *mattr,
+				 char *data)
 {
+	struct mem_ctl_info *mci = to_mci(dev);
+
 	return sprintf(data, "%d\n", mci->ce_mc);
 }
 
-static ssize_t mci_ce_noinfo_show(struct mem_ctl_info *mci, char *data)
+static ssize_t mci_ce_noinfo_show(struct device *dev,
+				  struct device_attribute *mattr,
+				  char *data)
 {
+	struct mem_ctl_info *mci = to_mci(dev);
+
 	return sprintf(data, "%d\n", mci->ce_noinfo_count);
 }
 
-static ssize_t mci_ue_noinfo_show(struct mem_ctl_info *mci, char *data)
+static ssize_t mci_ue_noinfo_show(struct device *dev,
+				  struct device_attribute *mattr,
+				  char *data)
 {
+	struct mem_ctl_info *mci = to_mci(dev);
+
 	return sprintf(data, "%d\n", mci->ue_noinfo_count);
 }
 
-static ssize_t mci_seconds_show(struct mem_ctl_info *mci, char *data)
+static ssize_t mci_seconds_show(struct device *dev,
+				struct device_attribute *mattr,
+				char *data)
 {
+	struct mem_ctl_info *mci = to_mci(dev);
+
 	return sprintf(data, "%ld\n", (jiffies - mci->start_time) / HZ);
 }
 
-static ssize_t mci_ctl_name_show(struct mem_ctl_info *mci, char *data)
+static ssize_t mci_ctl_name_show(struct device *dev,
+				 struct device_attribute *mattr,
+				 char *data)
 {
+	struct mem_ctl_info *mci = to_mci(dev);
+
 	return sprintf(data, "%s\n", mci->ctl_name);
 }
 
-static ssize_t mci_size_mb_show(struct mem_ctl_info *mci, char *data)
+static ssize_t mci_size_mb_show(struct device *dev,
+				struct device_attribute *mattr,
+				char *data)
 {
+	struct mem_ctl_info *mci = to_mci(dev);
 	int total_pages = 0, csrow_idx, j;
 
 	for (csrow_idx = 0; csrow_idx < mci->nr_csrows; csrow_idx++) {
@@ -540,360 +612,53 @@ static ssize_t mci_size_mb_show(struct mem_ctl_info *mci, char *data)
 	return sprintf(data, "%u\n", PAGES_TO_MiB(total_pages));
 }
 
-#define to_mci(k) container_of(k, struct mem_ctl_info, edac_mci_kobj)
-#define to_mcidev_attr(a) container_of(a,struct mcidev_sysfs_attribute,attr)
-
-/* MCI show/store functions for top most object */
-static ssize_t mcidev_show(struct kobject *kobj, struct attribute *attr,
-			char *buffer)
-{
-	struct mem_ctl_info *mem_ctl_info = to_mci(kobj);
-	struct mcidev_sysfs_attribute *mcidev_attr = to_mcidev_attr(attr);
-
-	debugf1("%s() mem_ctl_info %p\n", __func__, mem_ctl_info);
-
-	if (mcidev_attr->show)
-		return mcidev_attr->show(mem_ctl_info, buffer);
-
-	return -EIO;
-}
-
-static ssize_t mcidev_store(struct kobject *kobj, struct attribute *attr,
-			const char *buffer, size_t count)
-{
-	struct mem_ctl_info *mem_ctl_info = to_mci(kobj);
-	struct mcidev_sysfs_attribute *mcidev_attr = to_mcidev_attr(attr);
-
-	debugf1("%s() mem_ctl_info %p\n", __func__, mem_ctl_info);
-
-	if (mcidev_attr->store)
-		return mcidev_attr->store(mem_ctl_info, buffer, count);
-
-	return -EIO;
-}
-
-/* Intermediate show/store table */
-static const struct sysfs_ops mci_ops = {
-	.show = mcidev_show,
-	.store = mcidev_store
-};
-
-#define MCIDEV_ATTR(_name,_mode,_show,_store)			\
-static struct mcidev_sysfs_attribute mci_attr_##_name = {			\
-	.attr = {.name = __stringify(_name), .mode = _mode },	\
-	.show   = _show,					\
-	.store  = _store,					\
-};
-
 /* default Control file */
-MCIDEV_ATTR(reset_counters, S_IWUSR, NULL, mci_reset_counters_store);
+DEVICE_ATTR(reset_counters, S_IWUSR, NULL, mci_reset_counters_store);
 
 /* default Attribute files */
-MCIDEV_ATTR(mc_name, S_IRUGO, mci_ctl_name_show, NULL);
-MCIDEV_ATTR(size_mb, S_IRUGO, mci_size_mb_show, NULL);
-MCIDEV_ATTR(seconds_since_reset, S_IRUGO, mci_seconds_show, NULL);
-MCIDEV_ATTR(ue_noinfo_count, S_IRUGO, mci_ue_noinfo_show, NULL);
-MCIDEV_ATTR(ce_noinfo_count, S_IRUGO, mci_ce_noinfo_show, NULL);
-MCIDEV_ATTR(ue_count, S_IRUGO, mci_ue_count_show, NULL);
-MCIDEV_ATTR(ce_count, S_IRUGO, mci_ce_count_show, NULL);
+DEVICE_ATTR(mc_name, S_IRUGO, mci_ctl_name_show, NULL);
+DEVICE_ATTR(size_mb, S_IRUGO, mci_size_mb_show, NULL);
+DEVICE_ATTR(seconds_since_reset, S_IRUGO, mci_seconds_show, NULL);
+DEVICE_ATTR(ue_noinfo_count, S_IRUGO, mci_ue_noinfo_show, NULL);
+DEVICE_ATTR(ce_noinfo_count, S_IRUGO, mci_ce_noinfo_show, NULL);
+DEVICE_ATTR(ue_count, S_IRUGO, mci_ue_count_show, NULL);
+DEVICE_ATTR(ce_count, S_IRUGO, mci_ce_count_show, NULL);
 
 /* memory scrubber attribute file */
-MCIDEV_ATTR(sdram_scrub_rate, S_IRUGO | S_IWUSR, mci_sdram_scrub_rate_show,
+DEVICE_ATTR(sdram_scrub_rate, S_IRUGO | S_IWUSR, mci_sdram_scrub_rate_show,
 	mci_sdram_scrub_rate_store);
 
-static struct mcidev_sysfs_attribute *mci_attr[] = {
-	&mci_attr_reset_counters,
-	&mci_attr_mc_name,
-	&mci_attr_size_mb,
-	&mci_attr_seconds_since_reset,
-	&mci_attr_ue_noinfo_count,
-	&mci_attr_ce_noinfo_count,
-	&mci_attr_ue_count,
-	&mci_attr_ce_count,
-	&mci_attr_sdram_scrub_rate,
+static struct attribute *mci_attrs[] = {
+	&dev_attr_reset_counters.attr,
+	&dev_attr_mc_name.attr,
+	&dev_attr_size_mb.attr,
+	&dev_attr_seconds_since_reset.attr,
+	&dev_attr_ue_noinfo_count.attr,
+	&dev_attr_ce_noinfo_count.attr,
+	&dev_attr_ue_count.attr,
+	&dev_attr_ce_count.attr,
+	&dev_attr_sdram_scrub_rate.attr,
 	NULL
 };
 
-
-/*
- * Release of a MC controlling instance
- *
- *	each MC control instance has the following resources upon entry:
- *		a) a ref count on the top memctl kobj
- *		b) a ref count on this module
- *
- *	this function must decrement those ref counts and then
- *	issue a free on the instance's memory
- */
-static void edac_mci_control_release(struct kobject *kobj)
-{
-	struct mem_ctl_info *mci;
-
-	mci = to_mci(kobj);
-
-	debugf0("%s() mci instance idx=%d releasing\n", __func__, mci->mc_idx);
-
-	/* decrement the module ref count */
-	module_put(mci->owner);
-}
-
-static struct kobj_type ktype_mci = {
-	.release = edac_mci_control_release,
-	.sysfs_ops = &mci_ops,
-	.default_attrs = (struct attribute **)mci_attr,
+static struct attribute_group mci_attr_grp = {
+	.attrs	= mci_attrs,
 };
 
-/* EDAC memory controller sysfs kset:
- *	/sys/devices/system/edac/mc
- */
-static struct kset *mc_kset;
-
-/*
- * edac_mc_register_sysfs_main_kobj
- *
- *	setups and registers the main kobject for each mci
- */
-int edac_mc_register_sysfs_main_kobj(struct mem_ctl_info *mci)
-{
-	struct kobject *kobj_mci;
-	int err;
-
-	debugf1("%s()\n", __func__);
-
-	kobj_mci = &mci->edac_mci_kobj;
-
-	/* Init the mci's kobject */
-	memset(kobj_mci, 0, sizeof(*kobj_mci));
-
-	/* Record which module 'owns' this control structure
-	 * and bump the ref count of the module
-	 */
-	mci->owner = THIS_MODULE;
-
-	/* bump ref count on this module */
-	if (!try_module_get(mci->owner)) {
-		err = -ENODEV;
-		goto fail_out;
-	}
-
-	/* this instance become part of the mc_kset */
-	kobj_mci->kset = mc_kset;
-
-	/* register the mc<id> kobject to the mc_kset */
-	err = kobject_init_and_add(kobj_mci, &ktype_mci, NULL,
-				   "mc%d", mci->mc_idx);
-	if (err) {
-		debugf1("%s()Failed to register '.../edac/mc%d'\n",
-			__func__, mci->mc_idx);
-		goto kobj_reg_fail;
-	}
-	kobject_uevent(kobj_mci, KOBJ_ADD);
-
-	/* At this point, to 'free' the control struct,
-	 * edac_mc_unregister_sysfs_main_kobj() must be used
-	 */
-
-	debugf1("%s() Registered '.../edac/mc%d' kobject\n",
-		__func__, mci->mc_idx);
-
-	return 0;
-
-	/* Error exit stack */
-
-kobj_reg_fail:
-	module_put(mci->owner);
-
-fail_out:
-	return err;
-}
-
-/*
- * edac_mc_register_sysfs_main_kobj
- *
- *	tears down and the main mci kobject from the mc_kset
- */
-void edac_mc_unregister_sysfs_main_kobj(struct mem_ctl_info *mci)
-{
-	debugf1("%s()\n", __func__);
-
-	/* delete the kobj from the mc_kset */
-	kobject_put(&mci->edac_mci_kobj);
-}
-
-#define EDAC_DEVICE_SYMLINK	"device"
-
-#define grp_to_mci(k) (container_of(k, struct mcidev_sysfs_group_kobj, kobj)->mci)
-
-/* MCI show/store functions for top most object */
-static ssize_t inst_grp_show(struct kobject *kobj, struct attribute *attr,
-			char *buffer)
-{
-	struct mem_ctl_info *mem_ctl_info = grp_to_mci(kobj);
-	struct mcidev_sysfs_attribute *mcidev_attr = to_mcidev_attr(attr);
-
-	debugf1("%s() mem_ctl_info %p\n", __func__, mem_ctl_info);
-
-	if (mcidev_attr->show)
-		return mcidev_attr->show(mem_ctl_info, buffer);
-
-	return -EIO;
-}
-
-static ssize_t inst_grp_store(struct kobject *kobj, struct attribute *attr,
-			const char *buffer, size_t count)
-{
-	struct mem_ctl_info *mem_ctl_info = grp_to_mci(kobj);
-	struct mcidev_sysfs_attribute *mcidev_attr = to_mcidev_attr(attr);
-
-	debugf1("%s() mem_ctl_info %p\n", __func__, mem_ctl_info);
-
-	if (mcidev_attr->store)
-		return mcidev_attr->store(mem_ctl_info, buffer, count);
-
-	return -EIO;
-}
-
-/* No memory to release for this kobj */
-static void edac_inst_grp_release(struct kobject *kobj)
-{
-	struct mcidev_sysfs_group_kobj *grp;
-	struct mem_ctl_info *mci;
-
-	debugf1("%s()\n", __func__);
-
-	grp = container_of(kobj, struct mcidev_sysfs_group_kobj, kobj);
-	mci = grp->mci;
-}
-
-/* Intermediate show/store table */
-static struct sysfs_ops inst_grp_ops = {
-	.show = inst_grp_show,
-	.store = inst_grp_store
-};
-
-/* the kobj_type instance for a instance group */
-static struct kobj_type ktype_inst_grp = {
-	.release = edac_inst_grp_release,
-	.sysfs_ops = &inst_grp_ops,
+static const struct attribute_group *mci_attr_groups[] = {
+	&mci_attr_grp,
+	NULL
 };
 
-
-/*
- * edac_create_mci_instance_attributes
- *	create MC driver specific attributes bellow an specified kobj
- * This routine calls itself recursively, in order to create an entire
- * object tree.
- */
-static int edac_create_mci_instance_attributes(struct mem_ctl_info *mci,
-				const struct mcidev_sysfs_attribute *sysfs_attrib,
-				struct kobject *kobj)
+static void mci_attr_release(struct device *device)
 {
-	int err;
-
-	debugf4("%s()\n", __func__);
-
-	while (sysfs_attrib) {
-		debugf4("%s() sysfs_attrib = %p\n",__func__, sysfs_attrib);
-		if (sysfs_attrib->grp) {
-			struct mcidev_sysfs_group_kobj *grp_kobj;
-
-			grp_kobj = kzalloc(sizeof(*grp_kobj), GFP_KERNEL);
-			if (!grp_kobj)
-				return -ENOMEM;
-
-			grp_kobj->grp = sysfs_attrib->grp;
-			grp_kobj->mci = mci;
-			list_add_tail(&grp_kobj->list, &mci->grp_kobj_list);
-
-			debugf0("%s() grp %s, mci %p\n", __func__,
-				sysfs_attrib->grp->name, mci);
-
-			err = kobject_init_and_add(&grp_kobj->kobj,
-						&ktype_inst_grp,
-						&mci->edac_mci_kobj,
-						sysfs_attrib->grp->name);
-			if (err < 0) {
-				printk(KERN_ERR "kobject_init_and_add failed: %d\n", err);
-				return err;
-			}
-			err = edac_create_mci_instance_attributes(mci,
-					grp_kobj->grp->mcidev_attr,
-					&grp_kobj->kobj);
-
-			if (err < 0)
-				return err;
-		} else if (sysfs_attrib->attr.name) {
-			debugf4("%s() file %s\n", __func__,
-				sysfs_attrib->attr.name);
-
-			err = sysfs_create_file(kobj, &sysfs_attrib->attr);
-			if (err < 0) {
-				printk(KERN_ERR "sysfs_create_file failed: %d\n", err);
-				return err;
-			}
-		} else
-			break;
-
-		sysfs_attrib++;
-	}
-
-	return 0;
+	debugf1("Releasing mci device %s\n", dev_name(device));
 }
 
-/*
- * edac_remove_mci_instance_attributes
- *	remove MC driver specific attributes at the topmost level
- *	directory of this mci instance.
- */
-static void edac_remove_mci_instance_attributes(struct mem_ctl_info *mci,
-				const struct mcidev_sysfs_attribute *sysfs_attrib,
-				struct kobject *kobj, int count)
-{
-	struct mcidev_sysfs_group_kobj *grp_kobj, *tmp;
-
-	debugf1("%s()\n", __func__);
-
-	/*
-	 * loop if there are attributes and until we hit a NULL entry
-	 * Remove first all the attributes
-	 */
-	while (sysfs_attrib) {
-		debugf4("%s() sysfs_attrib = %p\n",__func__, sysfs_attrib);
-		if (sysfs_attrib->grp) {
-			debugf4("%s() seeking for group %s\n",
-				__func__, sysfs_attrib->grp->name);
-			list_for_each_entry(grp_kobj,
-					    &mci->grp_kobj_list, list) {
-				debugf4("%s() grp_kobj->grp = %p\n",__func__, grp_kobj->grp);
-				if (grp_kobj->grp == sysfs_attrib->grp) {
-					edac_remove_mci_instance_attributes(mci,
-						    grp_kobj->grp->mcidev_attr,
-						    &grp_kobj->kobj, count + 1);
-					debugf4("%s() group %s\n", __func__,
-						sysfs_attrib->grp->name);
-					kobject_put(&grp_kobj->kobj);
-				}
-			}
-			debugf4("%s() end of seeking for group %s\n",
-				__func__, sysfs_attrib->grp->name);
-		} else if (sysfs_attrib->attr.name) {
-			debugf4("%s() file %s\n", __func__,
-				sysfs_attrib->attr.name);
-			sysfs_remove_file(kobj, &sysfs_attrib->attr);
-		} else
-			break;
-		sysfs_attrib++;
-	}
-
-	/* Remove the group objects */
-	if (count)
-		return;
-	list_for_each_entry_safe(grp_kobj, tmp,
-				 &mci->grp_kobj_list, list) {
-		list_del(&grp_kobj->list);
-		kfree(grp_kobj);
-	}
-}
+static struct device_type mci_attr_type = {
+	.groups		= mci_attr_groups,
+	.release	= mci_attr_release,
+};
 
 
 /*
@@ -906,77 +671,80 @@ static void edac_remove_mci_instance_attributes(struct mem_ctl_info *mci,
  */
 int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
 {
-	int i, j;
-	int err;
-	struct csrow_info *csrow;
-	struct kobject *kobj_mci = &mci->edac_mci_kobj;
+	int i, err;
 
 	debugf0("%s() idx=%d\n", __func__, mci->mc_idx);
 
-	INIT_LIST_HEAD(&mci->grp_kobj_list);
+	/* get the /sys/devices/system/edac subsys reference */
+
+	mci->dev.type = &mci_attr_type;
+	device_initialize(&mci->dev);
 
-	/* create a symlink for the device */
-	err = sysfs_create_link(kobj_mci, &mci->pdev->kobj,
-				EDAC_DEVICE_SYMLINK);
-	if (err) {
-		debugf1("%s() failure to create symlink\n", __func__);
-		goto fail0;
-	}
+	mci->dev.parent = &mci_pdev;
+	mci->dev.bus = &mci->bus;
+	dev_set_name(&mci->dev, "mc%d", mci->mc_idx);
+	dev_set_drvdata(&mci->dev, mci);
+	pm_runtime_forbid(&mci->dev);
 
-	/* If the low level driver desires some attributes,
-	 * then create them now for the driver.
+	/*
+	 * The memory controller needs its own bus, in order to avoid
+	 * namespace conflicts at /sys/bus/edac.
 	 */
-	if (mci->mc_driver_sysfs_attributes) {
-		err = edac_create_mci_instance_attributes(mci,
-					mci->mc_driver_sysfs_attributes,
-					&mci->edac_mci_kobj);
-		if (err) {
-			debugf1("%s() failure to create mci attributes\n",
-				__func__);
-			goto fail0;
-		}
+	debugf0("creating bus %s\n",mci->bus.name);
+	mci->bus.name = kstrdup(dev_name(&mci->dev), GFP_KERNEL);
+	err = bus_register(&mci->bus);
+	if (err < 0)
+		return err;
+
+	debugf0("%s(): creating device %s\n", __func__,
+		dev_name(&mci->dev));
+	err = device_add(&mci->dev);
+	if (err < 0) {
+		bus_unregister(&mci->bus);
+		kfree(mci->bus.name);
+		return err;
 	}
 
-	/* Make directories for each CSROW object under the mc<id> kobject
+	/*
+	 * Create the dimm/rank devices
 	 */
-	for (i = 0; i < mci->nr_csrows; i++) {
-		int nr_pages = 0;
-
-		csrow = &mci->csrows[i];
-		for (j = 0; j < csrow->nr_channels; j++)
-			nr_pages += csrow->channels[j].dimm->nr_pages;
-
-		if (nr_pages > 0) {
-			err = edac_create_csrow_object(mci, csrow, i);
-			if (err) {
-				debugf1("%s() failure: create csrow %d obj\n",
-					__func__, i);
-				goto fail1;
-			}
+	for (i = 0; i < mci->tot_dimms; i++) {
+		struct dimm_info *dimm = &mci->dimms[i];
+		/* Only expose populated DIMMs */
+		if (dimm->nr_pages == 0)
+			continue;
+#ifdef CONFIG_EDAC_DEBUG
+		debugf1("%s creating dimm%d, located at ",
+			__func__, i);
+		if (edac_debug_level >= 1) {
+			int lay;
+			for (lay = 0; lay < mci->n_layers; lay++)
+				printk(KERN_CONT "%s %d ",
+					edac_layer_name[mci->layers[lay].type],
+					dimm->location[lay]);
+			printk(KERN_CONT "\n");
 		}
+#endif
 	}
 
+	err = edac_create_csrow_objects(mci);
+	if (err < 0)
+		goto fail;
+
 	return 0;
 
-fail1:
+fail:
 	for (i--; i >= 0; i--) {
-		int nr_pages = 0;
-
-		csrow = &mci->csrows[i];
-		for (j = 0; j < csrow->nr_channels; j++)
-			nr_pages += csrow->channels[j].dimm->nr_pages;
-		if (nr_pages > 0)
-			kobject_put(&mci->csrows[i].kobj);
+		struct dimm_info *dimm = &mci->dimms[i];
+		if (dimm->nr_pages == 0)
+			continue;
+		put_device(&dimm->dev);
+		device_del(&dimm->dev);
 	}
-
-	/* remove the mci instance's attributes, if any */
-	edac_remove_mci_instance_attributes(mci,
-		mci->mc_driver_sysfs_attributes, &mci->edac_mci_kobj, 0);
-
-	/* remove the symlink */
-	sysfs_remove_link(kobj_mci, EDAC_DEVICE_SYMLINK);
-
-fail0:
+	put_device(&mci->dev);
+	device_del(&mci->dev);
+	bus_unregister(&mci->bus);
+	kfree(mci->bus.name);
 	return err;
 }
 
@@ -985,98 +753,70 @@ fail0:
  */
 void edac_remove_sysfs_mci_device(struct mem_ctl_info *mci)
 {
-	struct csrow_info *csrow;
-	int i, j;
+	int i;
 
 	debugf0("%s()\n", __func__);
 
-	/* remove all csrow kobjects */
-	debugf4("%s()  unregister this mci kobj\n", __func__);
-	for (i = 0; i < mci->nr_csrows; i++) {
-		int nr_pages = 0;
-
-		csrow = &mci->csrows[i];
-		for (j = 0; j < csrow->nr_channels; j++)
-			nr_pages += csrow->channels[j].dimm->nr_pages;
-		if (nr_pages > 0) {
-			debugf0("%s()  unreg csrow-%d\n", __func__, i);
-			kobject_put(&mci->csrows[i].kobj);
-		}
-	}
+	edac_delete_csrow_objects(mci);
 
-	/* remove this mci instance's attribtes */
-	if (mci->mc_driver_sysfs_attributes) {
-		debugf4("%s()  unregister mci private attributes\n", __func__);
-		edac_remove_mci_instance_attributes(mci,
-						mci->mc_driver_sysfs_attributes,
-						&mci->edac_mci_kobj, 0);
+	for (i = 0; i < mci->tot_dimms; i++) {
+		struct dimm_info *dimm = &mci->dimms[i];
+		if (dimm->nr_pages == 0)
+			continue;
+		debugf0("%s(): removing device %s\n", __func__,
+			dev_name(&dimm->dev));
+		put_device(&dimm->dev);
+		device_del(&dimm->dev);
 	}
-
-	/* remove the symlink */
-	debugf4("%s()  remove_link\n", __func__);
-	sysfs_remove_link(&mci->edac_mci_kobj, EDAC_DEVICE_SYMLINK);
-
-	/* unregister this instance's kobject */
-	debugf4("%s()  remove_mci_instance\n", __func__);
-	kobject_put(&mci->edac_mci_kobj);
 }
 
+void edac_unregister_sysfs(struct mem_ctl_info *mci)
+{
+	debugf1("Unregistering device %s\n", dev_name(&mci->dev));
+	put_device(&mci->dev);
+	device_del(&mci->dev);
+	bus_unregister(&mci->bus);
+	kfree(mci->bus.name);
+}
 
+static void mc_attr_release(struct device *device)
+{
+	debugf1("Releasing device %s\n", dev_name(device));
+}
 
-
+static struct device_type mc_attr_type = {
+	.release	= mc_attr_release,
+};
 /*
- * edac_setup_sysfs_mc_kset(void)
- *
- * Initialize the mc_kset for the 'mc' entry
- *	This requires creating the top 'mc' directory with a kset
- *	and its controls/attributes.
- *
- *	To this 'mc' kset, instance 'mci' will be grouped as children.
- *
- * Return:  0 SUCCESS
- *         !0 FAILURE error code
+ * Init/exit code for the module. Basically, creates/removes /sys/class/rc
  */
-int edac_sysfs_setup_mc_kset(void)
+int __init edac_mc_sysfs_init(void)
 {
-	int err = -EINVAL;
 	struct bus_type *edac_subsys;
-
-	debugf1("%s()\n", __func__);
+	int err;
 
 	/* get the /sys/devices/system/edac subsys reference */
 	edac_subsys = edac_get_sysfs_subsys();
 	if (edac_subsys == NULL) {
-		debugf1("%s() no edac_subsys error=%d\n", __func__, err);
-		goto fail_out;
+		debugf1("%s() no edac_subsys\n", __func__);
+		return -EINVAL;
 	}
 
-	/* Init the MC's kobject */
-	mc_kset = kset_create_and_add("mc", NULL, &edac_subsys->dev_root->kobj);
-	if (!mc_kset) {
-		err = -ENOMEM;
-		debugf1("%s() Failed to register '.../edac/mc'\n", __func__);
-		goto fail_kset;
-	}
+	mci_pdev.bus = edac_subsys;
+	mci_pdev.type = &mc_attr_type;
+	device_initialize(&mci_pdev);
+	dev_set_name(&mci_pdev, "mc");
 
-	debugf1("%s() Registered '.../edac/mc' kobject\n", __func__);
+	err = device_add(&mci_pdev);
+	if (err < 0)
+		return err;
 
 	return 0;
-
-fail_kset:
-	edac_put_sysfs_subsys();
-
-fail_out:
-	return err;
 }
 
-/*
- * edac_sysfs_teardown_mc_kset
- *
- *	deconstruct the mc_ket for memory controllers
- */
-void edac_sysfs_teardown_mc_kset(void)
+void __exit edac_mc_sysfs_exit(void)
 {
-	kset_unregister(mc_kset);
+	put_device(&mci_pdev);
+	device_del(&mci_pdev);
 	edac_put_sysfs_subsys();
 }
-
diff --git a/drivers/edac/edac_module.c b/drivers/edac/edac_module.c
index 5ddaa86..8735a0d 100644
--- a/drivers/edac/edac_module.c
+++ b/drivers/edac/edac_module.c
@@ -90,10 +90,7 @@ static int __init edac_init(void)
 	 */
 	edac_pci_clear_parity_errors();
 
-	/*
-	 * now set up the mc_kset under the edac class object
-	 */
-	err = edac_sysfs_setup_mc_kset();
+	err = edac_mc_sysfs_init();
 	if (err)
 		goto error;
 
@@ -101,15 +98,11 @@ static int __init edac_init(void)
 	err = edac_workqueue_setup();
 	if (err) {
 		edac_printk(KERN_ERR, EDAC_MC, "init WorkQueue failure\n");
-		goto workq_fail;
+		goto error;
 	}
 
 	return 0;
 
-	/* Error teardown stack */
-workq_fail:
-	edac_sysfs_teardown_mc_kset();
-
 error:
 	return err;
 }
@@ -124,7 +117,7 @@ static void __exit edac_exit(void)
 
 	/* tear down the various subsystems */
 	edac_workqueue_teardown();
-	edac_sysfs_teardown_mc_kset();
+	edac_mc_sysfs_exit();
 }
 
 /*
diff --git a/drivers/edac/edac_module.h b/drivers/edac/edac_module.h
index 0ea7d14..1af1367 100644
--- a/drivers/edac/edac_module.h
+++ b/drivers/edac/edac_module.h
@@ -19,12 +19,12 @@
  *
  * edac_mc objects
  */
-extern int edac_sysfs_setup_mc_kset(void);
-extern void edac_sysfs_teardown_mc_kset(void);
-extern int edac_mc_register_sysfs_main_kobj(struct mem_ctl_info *mci);
-extern void edac_mc_unregister_sysfs_main_kobj(struct mem_ctl_info *mci);
+	/* on edac_mc_sysfs.c */
+int edac_mc_sysfs_init(void);
+void edac_mc_sysfs_exit(void);
 extern int edac_create_sysfs_mci_device(struct mem_ctl_info *mci);
 extern void edac_remove_sysfs_mci_device(struct mem_ctl_info *mci);
+void edac_unregister_sysfs(struct mem_ctl_info *mci);
 extern int edac_get_log_ue(void);
 extern int edac_get_log_ce(void);
 extern int edac_get_panic_on_ue(void);
@@ -34,6 +34,7 @@ extern int edac_mc_get_panic_on_ue(void);
 extern int edac_get_poll_msec(void);
 extern int edac_mc_get_poll_msec(void);
 
+	/* on edac_device.c */
 extern int edac_device_register_sysfs_main_kobj(
 				struct edac_device_ctl_info *edac_dev);
 extern void edac_device_unregister_sysfs_main_kobj(
diff --git a/include/linux/edac.h b/include/linux/edac.h
index c8b8133..a36df2a 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -444,14 +444,15 @@ struct edac_mc_layer {
 	__p;								\
 })
 
-
-/* FIXME: add the proper per-location error counts */
 struct dimm_info {
+	struct device dev;
+
 	char label[EDAC_MC_LABEL_LEN + 1];	/* DIMM label on motherboard */
 
 	/* Memory location data */
 	unsigned location[EDAC_MAX_LAYERS];
 
+	struct kobject kobj;		/* sysfs kobject for this csrow */
 	struct mem_ctl_info *mci;	/* the parent */
 
 	u32 grain;		/* granularity of reported error in bytes */
@@ -480,6 +481,8 @@ struct dimm_info {
  *	  patches in this series will fix this issue.
  */
 struct rank_info {
+	struct device dev;
+
 	int chan_idx;
 	struct csrow_info *csrow;
 	struct dimm_info *dimm;
@@ -488,6 +491,8 @@ struct rank_info {
 };
 
 struct csrow_info {
+	struct device dev;
+
 	/* Used only by edac_mc_find_csrow_by_page() */
 	unsigned long first_page;	/* first page number in csrow */
 	unsigned long last_page;	/* last page number in csrow */
@@ -513,15 +518,6 @@ struct mcidev_sysfs_group {
 	const struct mcidev_sysfs_attribute *mcidev_attr; /* group attributes */
 };
 
-struct mcidev_sysfs_group_kobj {
-	struct list_head list;		/* list for all instances within a mc */
-
-	struct kobject kobj;		/* kobj for the group */
-
-	const struct mcidev_sysfs_group *grp;	/* group description table */
-	struct mem_ctl_info *mci;	/* the parent */
-};
-
 /* mcidev_sysfs_attribute structure
  *	used for driver sysfs attributes and in mem_ctl_info
  * 	sysfs top level entries
@@ -532,13 +528,27 @@ struct mcidev_sysfs_attribute {
 	const struct mcidev_sysfs_group *grp;	/* Points to a group of attributes */
 
 	/* Ops for show/store values at the attribute - not used on group */
-        ssize_t (*show)(struct mem_ctl_info *,char *);
-        ssize_t (*store)(struct mem_ctl_info *, const char *,size_t);
+	ssize_t (*show)(struct mem_ctl_info *, char *);
+	ssize_t (*store)(struct mem_ctl_info *, const char *, size_t);
+
+	void *priv;
+};
+
+/*
+ * struct errcount_attribute - used to store the several error counts
+ */
+struct errcount_attribute_data {
+	int n_layers;
+	int pos[EDAC_MAX_LAYERS];
+	int layer0, layer1, layer2;
 };
 
 /* MEMORY controller information structure
  */
 struct mem_ctl_info {
+	struct device			dev;
+	struct bus_type			bus;
+
 	struct list_head link;	/* for global list of mem_ctl_info structs */
 
 	struct module *owner;	/* Module owner of this control struct */
@@ -583,7 +593,15 @@ struct mem_ctl_info {
 	struct csrow_info *csrows;
 	unsigned nr_csrows, num_cschannel;
 
-	/* Memory Controller hierarchy */
+	/*
+	 * Memory Controller hierarchy
+	 *
+	 * There are basically two types of memory controller: the ones that
+	 * sees memory sticks ("dimms"), and the ones that sees memory ranks.
+	 * All old memory controllers enumerate memories per rank, but most
+	 * of the recent drivers enumerate memories per DIMM, instead.
+	 * When the memory controller is per rank, mem_is_per_rank is true.
+	 */
 	unsigned n_layers;
 	struct edac_mc_layer *layers;
 	bool mem_is_per_rank;
