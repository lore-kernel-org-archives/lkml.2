Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272Ab1LOD1a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 22:27:30 -0500
Received: from ozlabs.org ([203.10.76.45]:44376 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758653Ab1LODXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 22:23:39 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Steve Glendinning <steve.glendinning@smsc.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
Cc: Christoph Raisch <raisch@de.ibm.com>
Cc: Roland Dreier <roland@kernel.org>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux390@de.ibm.com
Cc: Anton Altaparmakov <anton@tuxera.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: lm-sensors@lm-sensors.org
Cc: linux-rdma@vger.kernel.org
Cc: linux-s390@vger.kernel.org
Cc: linux-ntfs-dev@lists.sourceforge.net
Cc: alsa-devel@alsa-project.org
Subject: [PATCH 2/15] module_param: avoid bool abuse, add bint for special cases.
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 15 Dec 2011 13:32:26 +1030
Message-ID: <877h1ytu4d.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For historical reasons, we allow module_param(bool) to take an int (or
an unsigned int).  That's going away.

A few drivers really want an int: they set it to -1 and a parameter
will set it to 0 or 1.  This sucks: reading them from sysfs will give
'Y' for both -1 and 1, but if we change it to an int, then the users
might be broken (if they did "param" instead of "param=1").

Use a new 'bint' parser for them.

(ntfs has a different problem: it needs an int for debug_msgs because
it's also exposed via sysctl.)

Cc: Steve Glendinning <steve.glendinning@smsc.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
Cc: Christoph Raisch <raisch@de.ibm.com>
Cc: Roland Dreier <roland@kernel.org>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux390@de.ibm.com
Cc: Anton Altaparmakov <anton@tuxera.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: lm-sensors@lm-sensors.org
Cc: linux-rdma@vger.kernel.org
Cc: linux-s390@vger.kernel.org
Cc: linux-ntfs-dev@lists.sourceforge.net
Cc: alsa-devel@alsa-project.org
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/hwmon/emc2103.c                |    2 +-
 drivers/infiniband/hw/ehca/ehca_main.c |    2 +-
 drivers/s390/cio/cmf.c                 |    2 +-
 fs/ntfs/super.c                        |    2 +-
 include/linux/moduleparam.h            |    6 ++++++
 kernel/params.c                        |   24 ++++++++++++++++++++++++
 sound/pci/intel8x0.c                   |    4 ++--
 7 files changed, 36 insertions(+), 6 deletions(-)

diff --git a/drivers/hwmon/emc2103.c b/drivers/hwmon/emc2103.c
--- a/drivers/hwmon/emc2103.c
+++ b/drivers/hwmon/emc2103.c
@@ -55,7 +55,7 @@ static const u8 REG_TEMP_MAX[4] = { 0x34
  * it.  Default is to leave the device in the state it's already in (-1).
  * This parameter allows APD mode to be optionally forced on or off */
 static int apd = -1;
-module_param(apd, bool, 0);
+module_param(apd, bint, 0);
 MODULE_PARM_DESC(init, "Set to zero to disable anti-parallel diode mode");
 
 struct temperature {
diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -82,7 +82,7 @@ module_param_named(port_act_time, ehca_p
 module_param_named(poll_all_eqs,  ehca_poll_all_eqs,  bool, S_IRUGO);
 module_param_named(static_rate,   ehca_static_rate,   int,  S_IRUGO);
 module_param_named(scaling_code,  ehca_scaling_code,  bool, S_IRUGO);
-module_param_named(lock_hcalls,   ehca_lock_hcalls,   bool, S_IRUGO);
+module_param_named(lock_hcalls,   ehca_lock_hcalls,   bint, S_IRUGO);
 module_param_named(number_of_cqs, ehca_max_cq,        int,  S_IRUGO);
 module_param_named(number_of_qps, ehca_max_qp,        int,  S_IRUGO);
 
diff --git a/drivers/s390/cio/cmf.c b/drivers/s390/cio/cmf.c
--- a/drivers/s390/cio/cmf.c
+++ b/drivers/s390/cio/cmf.c
@@ -98,7 +98,7 @@ enum cmb_format {
  * enum cmb_format.
  */
 static int format = CMF_AUTODETECT;
-module_param(format, bool, 0444);
+module_param(format, bint, 0444);
 
 /**
  * struct cmb_operations - functions to use depending on cmb_format
diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -3198,7 +3198,7 @@ MODULE_DESCRIPTION("NTFS 1.2/3.x driver 
 MODULE_VERSION(NTFS_VERSION);
 MODULE_LICENSE("GPL");
 #ifdef DEBUG
-module_param(debug_msgs, bool, 0);
+module_param(debug_msgs, bint, 0);
 MODULE_PARM_DESC(debug_msgs, "Enable debug messages.");
 #endif
 
diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -367,6 +367,12 @@ extern int param_set_invbool(const char 
 extern int param_get_invbool(char *buffer, const struct kernel_param *kp);
 #define param_check_invbool(name, p) __param_check(name, p, bool)
 
+/* An int, which can only be set like a bool (though it shows as an int). */
+extern struct kernel_param_ops param_ops_bint;
+extern int param_set_bint(const char *val, const struct kernel_param *kp);
+#define param_get_bint param_get_int
+#define param_check_bint param_check_int
+
 /**
  * module_param_array - a parameter which is an array of some type
  * @name: the name of the array variable
diff --git a/kernel/params.c b/kernel/params.c
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -369,6 +369,30 @@ struct kernel_param_ops param_ops_invboo
 };
 EXPORT_SYMBOL(param_ops_invbool);
 
+int param_set_bint(const char *val, const struct kernel_param *kp)
+{
+	struct kernel_param boolkp;
+	bool v;
+	int ret;
+
+	/* Match bool exactly, by re-using it. */
+	boolkp = *kp;
+	boolkp.arg = &v;
+	boolkp.flags |= KPARAM_ISBOOL;
+
+	ret = param_set_bool(val, &boolkp);
+	if (ret == 0)
+		*(int *)kp->arg = v;
+	return ret;
+}
+EXPORT_SYMBOL(param_set_bint);
+
+struct kernel_param_ops param_ops_bint = {
+	.set = param_set_bint,
+	.get = param_get_int,
+};
+EXPORT_SYMBOL(param_ops_bint);
+
 /* We break the rule and mangle the string. */
 static int param_array(const char *name,
 		       const char *val,
diff --git a/sound/pci/intel8x0.c b/sound/pci/intel8x0.c
--- a/sound/pci/intel8x0.c
+++ b/sound/pci/intel8x0.c
@@ -95,13 +95,13 @@ module_param(ac97_quirk, charp, 0444);
 MODULE_PARM_DESC(ac97_quirk, "AC'97 workaround for strange hardware.");
 module_param(buggy_semaphore, bool, 0444);
 MODULE_PARM_DESC(buggy_semaphore, "Enable workaround for hardwares with problematic codec semaphores.");
-module_param(buggy_irq, bool, 0444);
+module_param(buggy_irq, bint, 0444);
 MODULE_PARM_DESC(buggy_irq, "Enable workaround for buggy interrupts on some motherboards.");
 module_param(xbox, bool, 0444);
 MODULE_PARM_DESC(xbox, "Set to 1 for Xbox, if you have problems with the AC'97 codec detection.");
 module_param(spdif_aclink, int, 0444);
 MODULE_PARM_DESC(spdif_aclink, "S/PDIF over AC-link.");
-module_param(inside_vm, bool, 0444);
+module_param(inside_vm, bint, 0444);
 MODULE_PARM_DESC(inside_vm, "KVM/Parallels optimization.");
 
 /* just for backward compatibility */
