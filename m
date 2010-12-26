Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495Ab0LZGJQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Dec 2010 01:09:16 -0500
Received: from mailfilter9.ihug.co.nz ([203.109.136.9]:56768 "EHLO
	mailfilter9.ihug.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab0LZGJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Dec 2010 01:09:15 -0500
X-Greylist: delayed 698 seconds by postgrey-1.27 at vger.kernel.org; Sun, 26 Dec 2010 01:09:15 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAK5oFk12XLpw/2dsb2JhbACkMHS+AIVKBIsEh3w
X-IronPort-AV: E=Sophos;i="4.60,230,1291546800"; 
   d="scan'208";a="40424945"
Date: Sun, 26 Dec 2010 18:57:18 +1300
From: Ralph Loader <suckfish@ihug.co.nz>
To: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH] Fix some incorrect use of positive error codes.
Message-Id: <20101226185718.aa60e0cd.suckfish@ihug.co.nz>
X-Mailer: Sylpheed 3.1.0beta5 (GTK+ 2.23.2; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a few places where positive EFOO error codes were being returned
where negative error codes are required.

Most of these are trivial.  Explanations of the other two:

cfrfml.c:cfrfml_receive() was returning -EPROTO in one place and
(+) EPROTO in another.  Delete the positive case; the return code has
already been initialised to -EPROTO at that point.

In arch/ppc, cmm.c:cmm_memory_cb() was passing a positive error-code
returned from cmm_mem_going_offline() to notifier_from_errno().
But the latter expects negative error codes.  Resolve the inconsistency
by returning the 'notifier' value from cmm_mem_going_offline() in the
first place.

These were found using coccinelle to grep for returning positive EFOO,
and then going through the 300 or so hits to find a dozen or so
that were obviously wrong.  It is almost certain that I missed some
problems - some places (notably XFS and a few drivers in staging) use
both positive and negative error codes, making it difficult to know
which is intended where.

Signed-off-by: Ralph Loader <suckfish@ihug.co.nz>
---
 arch/powerpc/platforms/pseries/cmm.c               |   18 +++++-------------
 drivers/staging/ath6kl/os/linux/ioctl.c            |   10 +++++-----
 drivers/staging/brcm80211/brcmfmac/wl_iw.c         |    2 +-
 drivers/staging/cxt1e1/linux.c                     |    2 +-
 .../staging/westbridge/astoria/device/cyasdevice.c |    2 +-
 fs/cifs/cifsencrypt.c                              |    2 +-
 net/caif/cfrfml.c                                  |    1 -
 7 files changed, 14 insertions(+), 23 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/cmm.c b/arch/powerpc/platforms/pseries/cmm.c
index f480386..3542fdc 100644
--- a/arch/powerpc/platforms/pseries/cmm.c
+++ b/arch/powerpc/platforms/pseries/cmm.c
@@ -526,7 +526,7 @@ static struct notifier_block cmm_mem_isolate_nb = {
  * @arg: memory_notify structure with page range to be offlined
  *
  * Return value:
- *	0 on success
+ *	NOTIFY_OK on success
  **/
 static int cmm_mem_going_offline(void *arg)
 {
@@ -581,7 +581,7 @@ static int cmm_mem_going_offline(void *arg)
 				cmm_dbg("Failed to allocate memory for list "
 						"management. Memory hotplug "
 						"failed.\n");
-				return ENOMEM;
+				return notifier_from_errno(-ENOMEM);
 			}
 			memcpy(npa, pa_curr, PAGE_SIZE);
 			if (pa_curr == cmm_page_list)
@@ -600,7 +600,7 @@ static int cmm_mem_going_offline(void *arg)
 	spin_unlock(&cmm_lock);
 	cmm_dbg("Released %ld pages in the search range.\n", freed);
 
-	return 0;
+	return NOTIFY_OK;
 }
 
 /**
@@ -616,14 +616,11 @@ static int cmm_mem_going_offline(void *arg)
 static int cmm_memory_cb(struct notifier_block *self,
 			unsigned long action, void *arg)
 {
-	int ret = 0;
-
 	switch (action) {
 	case MEM_GOING_OFFLINE:
 		mutex_lock(&hotplug_mutex);
 		hotplug_occurred = 1;
-		ret = cmm_mem_going_offline(arg);
-		break;
+		return cmm_mem_going_offline(arg);
 	case MEM_OFFLINE:
 	case MEM_CANCEL_OFFLINE:
 		mutex_unlock(&hotplug_mutex);
@@ -635,12 +632,7 @@ static int cmm_memory_cb(struct notifier_block *self,
 		break;
 	}
 
-	if (ret)
-		ret = notifier_from_errno(ret);
-	else
-		ret = NOTIFY_OK;
-
-	return ret;
+	return NOTIFY_OK;
 }
 
 static struct notifier_block cmm_mem_nb = {
diff --git a/drivers/staging/ath6kl/os/linux/ioctl.c b/drivers/staging/ath6kl/os/linux/ioctl.c
index d5f7ac0..0b10376 100644
--- a/drivers/staging/ath6kl/os/linux/ioctl.c
+++ b/drivers/staging/ath6kl/os/linux/ioctl.c
@@ -440,7 +440,7 @@ ar6000_ioctl_set_rssi_threshold(struct net_device *dev, struct ifreq *rq)
             if (ar->rssi_map[j+1].rssi < ar->rssi_map[j].rssi) {
                 SWAP_THOLD(ar->rssi_map[j+1], ar->rssi_map[j]);
             } else if (ar->rssi_map[j+1].rssi == ar->rssi_map[j].rssi) {
-                return EFAULT;
+                return -EFAULT;
             }
         }
     }
@@ -449,7 +449,7 @@ ar6000_ioctl_set_rssi_threshold(struct net_device *dev, struct ifreq *rq)
             if (ar->rssi_map[j+1].rssi < ar->rssi_map[j].rssi) {
                 SWAP_THOLD(ar->rssi_map[j+1], ar->rssi_map[j]);
             } else if (ar->rssi_map[j+1].rssi == ar->rssi_map[j].rssi) {
-                return EFAULT;
+                return -EFAULT;
             }
         }
     }
@@ -2870,7 +2870,7 @@ int ar6000_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
                                              gpio_output_set_cmd.enable_mask,
                                              gpio_output_set_cmd.disable_mask);
                 if (ret != A_OK) {
-                    ret = EIO;
+                    ret = -EIO;
                 }
             }
             up(&ar->arSem);
@@ -2950,7 +2950,7 @@ int ar6000_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
                                                gpio_register_cmd.gpioreg_id,
                                                gpio_register_cmd.value);
                 if (ret != A_OK) {
-                    ret = EIO;
+                    ret = -EIO;
                 }
 
                 /* Wait for acknowledgement from Target */
@@ -3041,7 +3041,7 @@ int ar6000_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
             } else {
                 ret = ar6000_gpio_intr_ack(dev, gpio_intr_ack_cmd.ack_mask);
                 if (ret != A_OK) {
-                    ret = EIO;
+                    ret = -EIO;
                 }
             }
             up(&ar->arSem);
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_iw.c b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
index 979a494..b68bc54 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_iw.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
@@ -1369,7 +1369,7 @@ wl_iw_iscan_set_scan(struct net_device *dev,
 	if (g_scan_specified_ssid) {
 		WL_TRACE(("%s Specific SCAN already running ignoring BC scan\n",
 			  __func__));
-		return EBUSY;
+		return -EBUSY;
 	}
 
 	memset(&ssid, 0, sizeof(ssid));
diff --git a/drivers/staging/cxt1e1/linux.c b/drivers/staging/cxt1e1/linux.c
index c793028..7af4887 100644
--- a/drivers/staging/cxt1e1/linux.c
+++ b/drivers/staging/cxt1e1/linux.c
@@ -548,7 +548,7 @@ do_set_port (struct net_device * ndev, void *data)
         return -EINVAL;             /* get card info */
 
     if (pp.portnum >= ci->max_port) /* sanity check */
-        return ENXIO;
+        return -ENXIO;
 
     memcpy (&ci->port[pp.portnum].p, &pp, sizeof (struct sbecom_port_param));
     return mkret (c4_set_port (ci, pp.portnum));
diff --git a/drivers/staging/westbridge/astoria/device/cyasdevice.c b/drivers/staging/westbridge/astoria/device/cyasdevice.c
index c76e383..0889730 100644
--- a/drivers/staging/westbridge/astoria/device/cyasdevice.c
+++ b/drivers/staging/westbridge/astoria/device/cyasdevice.c
@@ -389,7 +389,7 @@ EXPORT_SYMBOL(cyasdevice_gethaltag);
 static int __init cyasdevice_init(void)
 {
 	if (cyasdevice_initialize() != 0)
-		return ENODEV;
+		return -ENODEV;
 
 	return 0;
 }
diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index f856732..76df22b 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -585,7 +585,7 @@ setup_ntlmv2_rsp(struct cifsSesInfo *ses, const struct nls_table *nls_cp)
 
 	ses->auth_key.response = kmalloc(baselen + tilen, GFP_KERNEL);
 	if (!ses->auth_key.response) {
-		rc = ENOMEM;
+		rc = -ENOMEM;
 		ses->auth_key.len = 0;
 		cERROR(1, "%s: Can't allocate auth blob", __func__);
 		goto setup_ntlmv2_rsp_ret;
diff --git a/net/caif/cfrfml.c b/net/caif/cfrfml.c
index e2fb5fa..f5531c6 100644
--- a/net/caif/cfrfml.c
+++ b/net/caif/cfrfml.c
@@ -162,7 +162,6 @@ static int cfrfml_receive(struct cflayer *layr, struct cfpkt *pkt)
 		tmppkt = NULL;
 
 		/* Verify that length is correct */
-		err = EPROTO;
 		if (rfml->pdu_size != cfpkt_getlen(pkt) - RFM_HEAD_SIZE + 1)
 			goto out;
 	}
-- 
1.7.3.4

