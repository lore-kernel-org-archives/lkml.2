Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab1B1NrE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 08:47:04 -0500
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:55578 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044Ab1B1NrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 08:47:03 -0500
Message-ID: <4D6BA72C.5000100@linux.vnet.ibm.com>
Date: Mon, 28 Feb 2011 10:46:20 -0300
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: Jiri Slaby <jirislaby@gmail.com>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Guillaume Chazarain <guichaz@gmail.com>, akpm@linux-foundation.org
Subject: [GIT PULL]  TPM timeouts and resume fixes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 11022813-8936-0000-0000-000000CF014F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

Please pull from:
   git://tpmdd.git.sourceforge.net/gitroot/tpmdd/tpmdd/ for-james

The first change corrects the logic used to extract timeouts values from TPMs.
This second version includes an adjustment of such values from msecs to usecs,
since some chips return such values in the first form, causing some commands
to fail due the resulting short timeouts.

The second change re-enables TPM interrupts after a resume, making sure
that the TPM interrupts are enabled when running in the interrupt mode.
The TPM's interrupt enable register maye have been cleared by
the TPM's TIS loosing its state during device sleep in ACPI S3 (suspend)
or by the BIOS, which upon resume sends a TPM_Startup() command to the
TPM, and may run the TPM in polling mode and leave the TIS interrupts
disabled once it transfers control to the OS again.

Stefan Berger (2):
       tpm_tis: Use timeouts returned from TPM
       tpm_tis: Re-enable interrupts upon resume

  drivers/char/tpm/tpm.c     |   40 +++++++++++++++++++++++++++++++---------
  drivers/char/tpm/tpm.h     |    3 +++
  drivers/char/tpm/tpm_tis.c |   21 ++++++++++++++++++++-
  3 files changed, 54 insertions(+), 10 deletions(-)

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index 36e0fa1..a92254e 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -577,23 +577,30 @@ duration:
      if (rc)
          return;

-    if (be32_to_cpu(tpm_cmd.header.out.return_code)
-        != 3 * sizeof(u32))
+    if (be32_to_cpu(tpm_cmd.header.out.return_code) != 0 ||
+        be32_to_cpu(tpm_cmd.header.out.length)
+        != sizeof(tpm_cmd.header.out) + sizeof(u32) + 3 * sizeof(u32))
          return;
+
      duration_cap =&tpm_cmd.params.getcap_out.cap.duration;
      chip->vendor.duration[TPM_SHORT] =
          usecs_to_jiffies(be32_to_cpu(duration_cap->tpm_short));
-    /* The Broadcom BCM0102 chipset in a Dell Latitude D820 gets the above
-     * value wrong and apparently reports msecs rather than usecs. So we
-     * fix up the resulting too-small TPM_SHORT value to make things work.
-     */
-    if (chip->vendor.duration[TPM_SHORT]<  (HZ/100))
-        chip->vendor.duration[TPM_SHORT] = HZ;
-
      chip->vendor.duration[TPM_MEDIUM] =
          usecs_to_jiffies(be32_to_cpu(duration_cap->tpm_medium));
      chip->vendor.duration[TPM_LONG] =
          usecs_to_jiffies(be32_to_cpu(duration_cap->tpm_long));
+
+    /* The Broadcom BCM0102 chipset in a Dell Latitude D820 gets the above
+     * value wrong and apparently reports msecs rather than usecs. So we
+     * fix up the resulting too-small TPM_SHORT value to make things work.
+     */
+    if (chip->vendor.duration[TPM_SHORT]<  (HZ/100)) {
+        chip->vendor.duration[TPM_SHORT]   = HZ;
+        chip->vendor.duration[TPM_MEDIUM] *= 1000;
+        chip->vendor.duration[TPM_LONG]   *= 1000;
+        chip->vendor.duration_adjusted = true;
+        dev_info(chip->dev, "Adjusting TPM timeout parameters.");
+    }
  }
  EXPORT_SYMBOL_GPL(tpm_get_timeouts);
@@ -939,6 +946,21 @@ ssize_t tpm_show_caps_1_2(struct device * dev,
  }
  EXPORT_SYMBOL_GPL(tpm_show_caps_1_2);
+ssize_t tpm_show_timeouts(struct device *dev, struct device_attribute *attr,
+              char *buf)
+{
+    struct tpm_chip *chip = dev_get_drvdata(dev);
+
+    return sprintf(buf, "%d %d %d [%s]\n",
+               jiffies_to_usecs(chip->vendor.duration[TPM_SHORT]),
+               jiffies_to_usecs(chip->vendor.duration[TPM_MEDIUM]),
+               jiffies_to_usecs(chip->vendor.duration[TPM_LONG]),
+               chip->vendor.duration_adjusted
+             ? "adjusted"
+             : "original");
+}
+EXPORT_SYMBOL_GPL(tpm_show_timeouts);
+
  ssize_t tpm_store_cancel(struct device *dev, struct device_attribute *attr,
              const char *buf, size_t count)
  {
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 72ddb03..85e47af 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -56,6 +56,8 @@ extern ssize_t tpm_show_owned(struct device *, struct device_attribute *attr,
                  char *);
  extern ssize_t tpm_show_temp_deactivated(struct device *,
                       struct device_attribute *attr, char *);
+extern ssize_t tpm_show_timeouts(struct device *,
+                 struct device_attribute *attr, char *);
  struct tpm_chip;
@@ -82,6 +84,7 @@ struct tpm_vendor_specific {
      int locality;
      unsigned long timeout_a, timeout_b, timeout_c, timeout_d; /* jiffies */
      unsigned long duration[3]; /* jiffies */
+    bool duration_adjusted;
      wait_queue_head_t read_queue;
      wait_queue_head_t int_queue;
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index dd21df5..38040bd 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -376,6 +376,7 @@ static DEVICE_ATTR(temp_deactivated, S_IRUGO, tpm_show_temp_deactivated,
             NULL);
  static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps_1_2, NULL);
  static DEVICE_ATTR(cancel, S_IWUSR | S_IWGRP, NULL, tpm_store_cancel);
+static DEVICE_ATTR(timeouts, S_IRUGO, tpm_show_timeouts, NULL);
  static struct attribute *tis_attrs[] = {
      &dev_attr_pubek.attr,
@@ -385,7 +386,8 @@ static struct attribute *tis_attrs[] = {
      &dev_attr_owned.attr,
      &dev_attr_temp_deactivated.attr,
      &dev_attr_caps.attr,
-&dev_attr_cancel.attr, NULL,
+&dev_attr_cancel.attr,
+&dev_attr_timeouts.attr, NULL,
  };
  static struct attribute_group tis_attr_grp = {
@@ -649,6 +651,23 @@ static int tpm_tis_pnp_resume(struct pnp_dev *dev)
  {
      struct tpm_chip *chip = pnp_get_drvdata(dev);
      int ret;
+    u32 intmask;
+
+    if (chip->vendor.irq) {
+        /* reenable interrupts that device may have lost or
+           BIOS/firmware may have disabled */
+        intmask =
+            ioread32(chip->vendor.iobase +
+                 TPM_INT_ENABLE(chip->vendor.locality));
+
+        intmask |= TPM_INTF_CMD_READY_INT
+            | TPM_INTF_LOCALITY_CHANGE_INT | TPM_INTF_DATA_AVAIL_INT
+            | TPM_INTF_STS_VALID_INT | TPM_GLOBAL_INT_ENABLE;
+
+        iowrite32(intmask,
+              chip->vendor.iobase +
+              TPM_INT_ENABLE(chip->vendor.locality));
+    }
      ret = tpm_pm_resume(&dev->dev);
      if (!ret)


