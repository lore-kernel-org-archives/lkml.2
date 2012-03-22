Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758708Ab2CVC56 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 22:57:58 -0400
Received: from gate.crashing.org ([63.228.1.57]:57532 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753288Ab2CVC5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 22:57:55 -0400
Message-ID: <1332385050.2982.71.camel@pasglop>
Subject: Re: [PATCH 14/17] powerpc: crypto: nx driver code supporting nx
 encryption
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Kent Yoder <key@linux.vnet.ibm.com>, David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        rcj@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org,
        Greg KH <gregkh@linuxfoundation.org>
Date: Thu, 22 Mar 2012 13:57:30 +1100
In-Reply-To: <1332381004.2982.65.camel@pasglop>
References: <1332365297.3858.5.camel@key-ThinkPad-W510>
	 <1332366068.3858.50.camel@key-ThinkPad-W510>
	 <20120321221517.GB30748@kroah.com> <1332381004.2982.65.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-22 at 12:50 +1100, Benjamin Herrenschmidt wrote:
> On Wed, 2012-03-21 at 15:15 -0700, Greg KH wrote:
> > 
> > Really?  vio drivers are supposed to look like this with the .name and
> > .owner field manually being set in the static initialization of the
> > driver?  That's sad, and should be fixed, the vio core should do this
> > type of thing for you. 
> 
> Yeah, they still do it the old way, nobody got to fix that yet, should
> be pretty easy though.

Kent, Dave care to try this ? It's only compile tested.

powerpc+sparc/vio: Modernize driver registration

This makes vio_register_driver() get the module owner & name at compile
time like PCI drivers do, and adds a name pointer directly in struct
vio_driver to avoid having to explicitly initialize the embedded
struct device.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/powerpc/include/asm/vio.h     |   10 +++++++++-
 arch/powerpc/kernel/vio.c          |    9 +++++++--
 arch/sparc/include/asm/vio.h       |    9 ++++++++-
 arch/sparc/kernel/ds.c             |    5 +----
 arch/sparc/kernel/vio.c            |    9 +++++++--
 drivers/block/sunvdc.c             |    5 +----
 drivers/net/ethernet/ibm/ibmveth.c |    7 ++-----
 drivers/net/ethernet/sun/sunvnet.c |    5 +----
 drivers/scsi/ibmvscsi/ibmvfc.c     |    7 ++-----
 drivers/scsi/ibmvscsi/ibmvscsi.c   |    7 ++-----
 drivers/scsi/ibmvscsi/ibmvstgt.c   |    5 +----
 drivers/tty/hvc/hvc_vio.c          |    7 ++-----
 drivers/tty/hvc/hvcs.c             |    5 +----
 13 files changed, 44 insertions(+), 46 deletions(-)

diff --git a/arch/powerpc/include/asm/vio.h b/arch/powerpc/include/asm/vio.h
index 0a290a1..6bfd5ff 100644
--- a/arch/powerpc/include/asm/vio.h
+++ b/arch/powerpc/include/asm/vio.h
@@ -69,6 +69,7 @@ struct vio_dev {
 };
 
 struct vio_driver {
+	const char *name;
 	const struct vio_device_id *id_table;
 	int (*probe)(struct vio_dev *dev, const struct vio_device_id *id);
 	int (*remove)(struct vio_dev *dev);
@@ -76,10 +77,17 @@ struct vio_driver {
 	 * be loaded in a CMO environment if it uses DMA.
 	 */
 	unsigned long (*get_desired_dma)(struct vio_dev *dev);
+	const struct dev_pm_ops *pm;
 	struct device_driver driver;
 };
 
-extern int vio_register_driver(struct vio_driver *drv);
+extern int __vio_register_driver(struct vio_driver *drv, struct module *owner,
+				 const char *mod_name);
+/*
+ * vio_register_driver must be a macro so that KBUILD_MODNAME can be expanded
+ */
+#define vio_register_driver(driver)		\
+	__vio_register_driver(driver, THIS_MODULE, KBUILD_MODNAME)
 extern void vio_unregister_driver(struct vio_driver *drv);
 
 extern int vio_cmo_entitlement_update(size_t);
diff --git a/arch/powerpc/kernel/vio.c b/arch/powerpc/kernel/vio.c
index bca3fc4..879dd25 100644
--- a/arch/powerpc/kernel/vio.c
+++ b/arch/powerpc/kernel/vio.c
@@ -1159,17 +1159,22 @@ static int vio_bus_remove(struct device *dev)
  * vio_register_driver: - Register a new vio driver
  * @drv:	The vio_driver structure to be registered.
  */
-int vio_register_driver(struct vio_driver *viodrv)
+int __vio_register_driver(struct vio_driver *viodrv, struct module *owner,
+			  const char *mod_name)
 {
 	printk(KERN_DEBUG "%s: driver %s registering\n", __func__,
 		viodrv->driver.name);
 
 	/* fill in 'struct driver' fields */
+	viodrv->driver.name = viodrv->name;
+	viodrv->driver.pm = viodrv->pm;
 	viodrv->driver.bus = &vio_bus_type;
+	viodrv->driver.owner = owner;
+	viodrv->driver.mod_name = mod_name;
 
 	return driver_register(&viodrv->driver);
 }
-EXPORT_SYMBOL(vio_register_driver);
+EXPORT_SYMBOL(__vio_register_driver);
 
 /**
  * vio_unregister_driver - Remove registration of vio driver.
diff --git a/arch/sparc/include/asm/vio.h b/arch/sparc/include/asm/vio.h
index 9d83d3b..432afa8 100644
--- a/arch/sparc/include/asm/vio.h
+++ b/arch/sparc/include/asm/vio.h
@@ -284,6 +284,7 @@ struct vio_dev {
 };
 
 struct vio_driver {
+	const char			*name;
 	struct list_head		node;
 	const struct vio_device_id	*id_table;
 	int (*probe)(struct vio_dev *dev, const struct vio_device_id *id);
@@ -371,7 +372,13 @@ do {	if (vio->debug & VIO_DEBUG_##TYPE) \
 		       vio->vdev->channel_id, ## a); \
 } while (0)
 
-extern int vio_register_driver(struct vio_driver *drv);
+extern int __vio_register_driver(struct vio_driver *drv, struct module *owner,
+				 const char *mod_name);
+/*
+ * vio_register_driver must be a macro so that KBUILD_MODNAME can be expanded
+ */
+#define vio_register_driver(driver)		\
+	__vio_register_driver(driver, THIS_MODULE, KBUILD_MODNAME)
 extern void vio_unregister_driver(struct vio_driver *drv);
 
 static inline struct vio_driver *to_vio_driver(struct device_driver *drv)
diff --git a/arch/sparc/kernel/ds.c b/arch/sparc/kernel/ds.c
index 381edcd..fea13c7 100644
--- a/arch/sparc/kernel/ds.c
+++ b/arch/sparc/kernel/ds.c
@@ -1244,10 +1244,7 @@ static struct vio_driver ds_driver = {
 	.id_table	= ds_match,
 	.probe		= ds_probe,
 	.remove		= ds_remove,
-	.driver		= {
-		.name	= "ds",
-		.owner	= THIS_MODULE,
-	}
+	.name		= "ds",
 };
 
 static int __init ds_init(void)
diff --git a/arch/sparc/kernel/vio.c b/arch/sparc/kernel/vio.c
index f67e28e..6758b0b 100644
--- a/arch/sparc/kernel/vio.c
+++ b/arch/sparc/kernel/vio.c
@@ -119,13 +119,18 @@ static struct bus_type vio_bus_type = {
 	.remove		= vio_device_remove,
 };
 
-int vio_register_driver(struct vio_driver *viodrv)
+int __vio_register_driver(struct vio_driver *viodrv, struct module *owner,
+			const char *mod_name)
 {
 	viodrv->driver.bus = &vio_bus_type;
+	viodrv->driver.name = viodrv->name;
+	viodrv->driver.bus = &vio_bus_type;
+	viodrv->driver.owner = owner;
+	viodrv->driver.mod_name = mod_name;
 
 	return driver_register(&viodrv->driver);
 }
-EXPORT_SYMBOL(vio_register_driver);
+EXPORT_SYMBOL(__vio_register_driver);
 
 void vio_unregister_driver(struct vio_driver *viodrv)
 {
diff --git a/drivers/block/sunvdc.c b/drivers/block/sunvdc.c
index 48e8fee..9dcf76a 100644
--- a/drivers/block/sunvdc.c
+++ b/drivers/block/sunvdc.c
@@ -839,10 +839,7 @@ static struct vio_driver vdc_port_driver = {
 	.id_table	= vdc_port_match,
 	.probe		= vdc_port_probe,
 	.remove		= vdc_port_remove,
-	.driver		= {
-		.name	= "vdc_port",
-		.owner	= THIS_MODULE,
-	}
+	.name		= "vdc_port",
 };
 
 static int __init vdc_init(void)
diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index e877371..9010cea 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -1616,11 +1616,8 @@ static struct vio_driver ibmveth_driver = {
 	.probe		= ibmveth_probe,
 	.remove		= ibmveth_remove,
 	.get_desired_dma = ibmveth_get_desired_dma,
-	.driver		= {
-		.name	= ibmveth_driver_name,
-		.owner	= THIS_MODULE,
-		.pm = &ibmveth_pm_ops,
-	}
+	.name		= ibmveth_driver_name,
+	.pm		= &ibmveth_pm_ops,
 };
 
 static int __init ibmveth_module_init(void)
diff --git a/drivers/net/ethernet/sun/sunvnet.c b/drivers/net/ethernet/sun/sunvnet.c
index 8c6c059..998c0f0 100644
--- a/drivers/net/ethernet/sun/sunvnet.c
+++ b/drivers/net/ethernet/sun/sunvnet.c
@@ -1264,10 +1264,7 @@ static struct vio_driver vnet_port_driver = {
 	.id_table	= vnet_port_match,
 	.probe		= vnet_port_probe,
 	.remove		= vnet_port_remove,
-	.driver		= {
-		.name	= "vnet_port",
-		.owner	= THIS_MODULE,
-	}
+	.name		= "vnet_port",
 };
 
 static int __init vnet_init(void)
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index bdfa223..134a0ae 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -4890,11 +4890,8 @@ static struct vio_driver ibmvfc_driver = {
 	.probe = ibmvfc_probe,
 	.remove = ibmvfc_remove,
 	.get_desired_dma = ibmvfc_get_desired_dma,
-	.driver = {
-		.name = IBMVFC_NAME,
-		.owner = THIS_MODULE,
-		.pm = &ibmvfc_pm_ops,
-	}
+	.name = IBMVFC_NAME,
+	.pm = &ibmvfc_pm_ops,
 };
 
 static struct fc_function_template ibmvfc_transport_functions = {
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index e984951..3a6c474 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -2061,11 +2061,8 @@ static struct vio_driver ibmvscsi_driver = {
 	.probe = ibmvscsi_probe,
 	.remove = ibmvscsi_remove,
 	.get_desired_dma = ibmvscsi_get_desired_dma,
-	.driver = {
-		.name = "ibmvscsi",
-		.owner = THIS_MODULE,
-		.pm = &ibmvscsi_pm_ops,
-	}
+	.name = "ibmvscsi",
+	.pm = &ibmvscsi_pm_ops,
 };
 
 static struct srp_function_template ibmvscsi_transport_functions = {
diff --git a/drivers/scsi/ibmvscsi/ibmvstgt.c b/drivers/scsi/ibmvscsi/ibmvstgt.c
index 2256bab..aa7ed81 100644
--- a/drivers/scsi/ibmvscsi/ibmvstgt.c
+++ b/drivers/scsi/ibmvscsi/ibmvstgt.c
@@ -918,10 +918,7 @@ static struct vio_driver ibmvstgt_driver = {
 	.id_table = ibmvstgt_device_table,
 	.probe = ibmvstgt_probe,
 	.remove = ibmvstgt_remove,
-	.driver = {
-		.name = "ibmvscsis",
-		.owner = THIS_MODULE,
-	}
+	.name = "ibmvscsis",
 };
 
 static int get_system_info(void)
diff --git a/drivers/tty/hvc/hvc_vio.c b/drivers/tty/hvc/hvc_vio.c
index 3a0d53d..ee30779 100644
--- a/drivers/tty/hvc/hvc_vio.c
+++ b/drivers/tty/hvc/hvc_vio.c
@@ -310,11 +310,8 @@ static int __devexit hvc_vio_remove(struct vio_dev *vdev)
 static struct vio_driver hvc_vio_driver = {
 	.id_table	= hvc_driver_table,
 	.probe		= hvc_vio_probe,
-	.remove		= __devexit_p(hvc_vio_remove),
-	.driver		= {
-		.name	= hvc_driver_name,
-		.owner	= THIS_MODULE,
-	}
+	.remove		= hvc_vio_remove,
+	.name		= hvc_driver_name,
 };
 
 static int __init hvc_vio_init(void)
diff --git a/drivers/tty/hvc/hvcs.c b/drivers/tty/hvc/hvcs.c
index d237591..3436436 100644
--- a/drivers/tty/hvc/hvcs.c
+++ b/drivers/tty/hvc/hvcs.c
@@ -879,10 +879,7 @@ static struct vio_driver hvcs_vio_driver = {
 	.id_table	= hvcs_driver_table,
 	.probe		= hvcs_probe,
 	.remove		= __devexit_p(hvcs_remove),
-	.driver		= {
-		.name	= hvcs_driver_name,
-		.owner	= THIS_MODULE,
-	}
+	.name		= hvcs_driver_name,
 };
 
 /* Only called from hvcs_get_pi please */


