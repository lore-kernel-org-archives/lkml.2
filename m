Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab0H0ABo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 20:01:44 -0400
Received: from kroah.org ([198.145.64.141]:54776 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754832Ab0H0AAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 20:00:47 -0400
Date: Thu, 26 Aug 2010 16:59:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.27.53
Message-ID: <20100826235914.GF13527@kroah.com>
References: <20100826235552.GA13527@kroah.com> <20100826235645.GB13527@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100826235645.GB13527@kroah.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 948de60..9447d9d 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 27
-EXTRAVERSION = .52
+EXTRAVERSION = .53
 NAME = Trembling Tortoise
 
 # *DOCUMENTATION*
@@ -440,7 +440,11 @@ ifeq ($(config-targets),1)
 include $(srctree)/arch/$(SRCARCH)/Makefile
 export KBUILD_DEFCONFIG
 
-config %config: scripts_basic outputmakefile FORCE
+config: scripts_basic outputmakefile FORCE
+	$(Q)mkdir -p include/linux include/config
+	$(Q)$(MAKE) $(build)=scripts/kconfig $@
+
+%config: scripts_basic outputmakefile FORCE
 	$(Q)mkdir -p include/linux include/config
 	$(Q)$(MAKE) $(build)=scripts/kconfig $@
 
@@ -1602,7 +1606,11 @@ endif
 	$(Q)$(MAKE) $(build)=$(build-dir) $(target-dir)$(notdir $@)
 
 # Modules
-/ %/: prepare scripts FORCE
+/: prepare scripts FORCE
+	$(cmd_crmodverdir)
+	$(Q)$(MAKE) KBUILD_MODULES=$(if $(CONFIG_MODULES),1) \
+	$(build)=$(build-dir)
+%/: prepare scripts FORCE
 	$(cmd_crmodverdir)
 	$(Q)$(MAKE) KBUILD_MODULES=$(if $(CONFIG_MODULES),1) \
 	$(build)=$(build-dir)
diff --git a/arch/arm/include/asm/ptrace.h b/arch/arm/include/asm/ptrace.h
index b415c0e..1c0447e 100644
--- a/arch/arm/include/asm/ptrace.h
+++ b/arch/arm/include/asm/ptrace.h
@@ -124,15 +124,24 @@ struct pt_regs {
  */
 static inline int valid_user_regs(struct pt_regs *regs)
 {
-	if (user_mode(regs) && (regs->ARM_cpsr & PSR_I_BIT) == 0) {
-		regs->ARM_cpsr &= ~(PSR_F_BIT | PSR_A_BIT);
-		return 1;
+	unsigned long mode = regs->ARM_cpsr & MODE_MASK;
+
+	/*
+	 * Always clear the F (FIQ) and A (delayed abort) bits
+	 */
+	regs->ARM_cpsr &= ~(PSR_F_BIT | PSR_A_BIT);
+
+	if ((regs->ARM_cpsr & PSR_I_BIT) == 0) {
+		if (mode == USR_MODE)
+			return 1;
+		if (elf_hwcap & HWCAP_26BIT && mode == USR26_MODE)
+			return 1;
 	}
 
 	/*
 	 * Force CPSR to something logical...
 	 */
-	regs->ARM_cpsr &= PSR_f | PSR_s | (PSR_x & ~PSR_A_BIT) | PSR_T_BIT | MODE32_BIT;
+	regs->ARM_cpsr &= PSR_f | PSR_s | PSR_x | PSR_T_BIT | MODE32_BIT;
 	if (!(elf_hwcap & HWCAP_26BIT))
 		regs->ARM_cpsr |= USR_MODE;
 
diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
index 452c2d8..debeb88 100644
--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -504,7 +504,9 @@ int drm_ioctl(struct inode *inode, struct file *filp,
 				retcode = -EFAULT;
 				goto err_i1;
 			}
-		}
+		} else
+			memset(kdata, 0, _IOC_SIZE(cmd));
+
 		retcode = func(dev, kdata, file_priv);
 
 		if ((retcode == 0) && (cmd & IOC_OUT)) {
diff --git a/drivers/usb/serial/io_ti.c b/drivers/usb/serial/io_ti.c
index 3ff4895..147e044 100644
--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@ -1156,7 +1156,7 @@ static int download_fw(struct edgeport_serial *serial)
 
 			/* Check if we have an old version in the I2C and
 			   update if necessary */
-			if (download_cur_ver != download_new_ver) {
+			if (download_cur_ver < download_new_ver) {
 				dbg("%s - Update I2C dld from %d.%d to %d.%d",
 				    __func__,
 				    firmware_version->Ver_Major,
diff --git a/drivers/usb/serial/navman.c b/drivers/usb/serial/navman.c
index d673653..6177d09 100644
--- a/drivers/usb/serial/navman.c
+++ b/drivers/usb/serial/navman.c
@@ -24,6 +24,7 @@ static int debug;
 
 static struct usb_device_id id_table [] = {
 	{ USB_DEVICE(0x0a99, 0x0001) },	/* Talon Technology device */
+	{ USB_DEVICE(0x0df7, 0x0900) },	/* Mobile Action i-gotU */
 	{ },
 };
 MODULE_DEVICE_TABLE(usb, id_table);
diff --git a/firmware/Makefile b/firmware/Makefile
index da75a6f..5c01761 100644
--- a/firmware/Makefile
+++ b/firmware/Makefile
@@ -75,7 +75,7 @@ fw-shipped-$(CONFIG_VIDEO_CPIA2) += cpia2/stv0672_vp4.bin
 fw-shipped-all := $(fw-shipped-y) $(fw-shipped-m) $(fw-shipped-)
 
 # Directories which we _might_ need to create, so we have a rule for them.
-firmware-dirs := $(sort $(patsubst %,$(objtree)/$(obj)/%/,$(dir $(fw-external-y) $(fw-shipped-all))))
+firmware-dirs := $(sort $(addprefix $(objtree)/$(obj)/,$(dir $(fw-external-y) $(fw-shipped-all))))
 
 quiet_cmd_mkdir = MKDIR   $(patsubst $(objtree)/%,%,$@)
       cmd_mkdir = mkdir -p $@
diff --git a/net/can/bcm.c b/net/can/bcm.c
index da0d426..be700a5 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -58,6 +58,13 @@
 #include <net/sock.h>
 #include <net/net_namespace.h>
 
+/*
+ * To send multiple CAN frame content within TX_SETUP or to filter
+ * CAN messages with multiplex index within RX_SETUP, the number of
+ * different filters is limited to 256 due to the one byte index value.
+ */
+#define MAX_NFRAMES 256
+
 /* use of last_frames[index].can_dlc */
 #define RX_RECV    0x40 /* received data for this element */
 #define RX_THR     0x80 /* element not been sent due to throttle feature */
@@ -86,15 +93,15 @@ struct bcm_op {
 	struct list_head list;
 	int ifindex;
 	canid_t can_id;
-	int flags;
+	u32 flags;
 	unsigned long frames_abs, frames_filtered;
 	struct timeval ival1, ival2;
 	struct hrtimer timer, thrtimer;
 	ktime_t rx_stamp, kt_ival1, kt_ival2, kt_lastmsg;
 	int rx_ifindex;
-	int count;
-	int nframes;
-	int currframe;
+	u32 count;
+	u32 nframes;
+	u32 currframe;
 	struct can_frame *frames;
 	struct can_frame *last_frames;
 	struct can_frame sframe;
@@ -173,7 +180,7 @@ static int bcm_read_proc(char *page, char **start, off_t off,
 		len += snprintf(page + len, PAGE_SIZE - len,
 				"rx_op: %03X %-5s ",
 				op->can_id, bcm_proc_getifname(op->ifindex));
-		len += snprintf(page + len, PAGE_SIZE - len, "[%d]%c ",
+		len += snprintf(page + len, PAGE_SIZE - len, "[%u]%c ",
 				op->nframes,
 				(op->flags & RX_CHECK_DLC)?'d':' ');
 		if (op->kt_ival1.tv64)
@@ -207,7 +214,7 @@ static int bcm_read_proc(char *page, char **start, off_t off,
 	list_for_each_entry(op, &bo->tx_ops, list) {
 
 		len += snprintf(page + len, PAGE_SIZE - len,
-				"tx_op: %03X %s [%d] ",
+				"tx_op: %03X %s [%u] ",
 				op->can_id, bcm_proc_getifname(op->ifindex),
 				op->nframes);
 
@@ -288,7 +295,7 @@ static void bcm_send_to_user(struct bcm_op *op, struct bcm_msg_head *head,
 	struct can_frame *firstframe;
 	struct sockaddr_can *addr;
 	struct sock *sk = op->sk;
-	int datalen = head->nframes * CFSIZ;
+	unsigned int datalen = head->nframes * CFSIZ;
 	int err;
 
 	skb = alloc_skb(sizeof(*head) + datalen, gfp_any());
@@ -466,7 +473,7 @@ static void bcm_rx_update_and_send(struct bcm_op *op,
  * bcm_rx_cmp_to_index - (bit)compares the currently received data to formerly
  *                       received data stored in op->last_frames[]
  */
-static void bcm_rx_cmp_to_index(struct bcm_op *op, int index,
+static void bcm_rx_cmp_to_index(struct bcm_op *op, unsigned int index,
 				struct can_frame *rxdata)
 {
 	/*
@@ -548,7 +555,7 @@ static int bcm_rx_thr_flush(struct bcm_op *op)
 	int updated = 0;
 
 	if (op->nframes > 1) {
-		int i;
+		unsigned int i;
 
 		/* for MUX filter we start at index 1 */
 		for (i = 1; i < op->nframes; i++) {
@@ -597,7 +604,7 @@ static void bcm_rx_handler(struct sk_buff *skb, void *data)
 {
 	struct bcm_op *op = (struct bcm_op *)data;
 	struct can_frame rxframe;
-	int i;
+	unsigned int i;
 
 	/* disable timeout */
 	hrtimer_cancel(&op->timer);
@@ -799,14 +806,15 @@ static int bcm_tx_setup(struct bcm_msg_head *msg_head, struct msghdr *msg,
 {
 	struct bcm_sock *bo = bcm_sk(sk);
 	struct bcm_op *op;
-	int i, err;
+	unsigned int i;
+	int err;
 
 	/* we need a real device to send frames */
 	if (!ifindex)
 		return -ENODEV;
 
-	/* we need at least one can_frame */
-	if (msg_head->nframes < 1)
+	/* check nframes boundaries - we need at least one can_frame */
+	if (msg_head->nframes < 1 || msg_head->nframes > MAX_NFRAMES)
 		return -EINVAL;
 
 	/* check the given can_id */
@@ -966,6 +974,10 @@ static int bcm_rx_setup(struct bcm_msg_head *msg_head, struct msghdr *msg,
 		msg_head->nframes = 0;
 	}
 
+	/* the first element contains the mux-mask => MAX_NFRAMES + 1  */
+	if (msg_head->nframes > MAX_NFRAMES + 1)
+		return -EINVAL;
+
 	if ((msg_head->flags & RX_RTR_FRAME) &&
 	    ((msg_head->nframes != 1) ||
 	     (!(msg_head->can_id & CAN_RTR_FLAG))))
diff --git a/scripts/mkmakefile b/scripts/mkmakefile
index e65d8b3..278b64e 100644
--- a/scripts/mkmakefile
+++ b/scripts/mkmakefile
@@ -42,7 +42,9 @@ all:
 
 Makefile:;
 
-\$(all) %/: all
+\$(all): all
 	@:
 
+%/: all
+	@:
 EOF
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index e2d25da..750cb17 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1290,7 +1290,7 @@ static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dent
 		/* Default to the fs superblock SID. */
 		isec->sid = sbsec->sid;
 
-		if (sbsec->proc) {
+		if (sbsec->proc && !S_ISLNK(inode->i_mode)) {
 			struct proc_inode *proci = PROC_I(inode);
 			if (proci->pde) {
 				isec->sclass = inode_mode_to_security_class(inode->i_mode);
