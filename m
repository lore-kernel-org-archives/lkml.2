Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab2LJXWe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 18:22:34 -0500
Received: from wren.arvixe.com ([50.97.138.99]:45865 "EHLO wren.arvixe.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533Ab2LJXW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 18:22:29 -0500
From: Przemo Firszt <przemo@firszt.eu>
To: greg@kroah.com, Larry.Finger@lwfinger.net,
        florian.c.schilhabel@googlemail.com, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Przemo Firszt <przemo@firszt.eu>
Subject: [PATCH 3/9] rtl8712: replace printk with better solutions
Date: Mon, 10 Dec 2012 23:21:21 +0000
Message-Id: <1355181685-4444-3-git-send-email-przemo@firszt.eu>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1355181685-4444-1-git-send-email-przemo@firszt.eu>
References: <1355181685-4444-1-git-send-email-przemo@firszt.eu>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - wren.arvixe.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - firszt.eu
X-Get-Message-Sender-Via: wren.arvixe.com: authenticated_id: przemo@firszt.eu
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace printk with netdev_printk helpers, dev_printk helpers or
pr_err/warn/info if there is no device info available.

Signed-off-by: Przemo Firszt <przemo@firszt.eu>
---
 drivers/staging/rtl8712/hal_init.c            | 17 ++++-----
 drivers/staging/rtl8712/os_intfs.c            |  3 +-
 drivers/staging/rtl8712/rtl8712_recv.c        | 14 ++++----
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c | 52 ++++++++++++---------------
 drivers/staging/rtl8712/rtl871x_mlme.c        |  4 +--
 drivers/staging/rtl8712/usb_intf.c            | 33 ++++++++---------
 drivers/staging/rtl8712/usb_ops_linux.c       | 12 +++----
 drivers/staging/rtl8712/xmit_linux.c          |  3 +-
 8 files changed, 61 insertions(+), 77 deletions(-)

diff --git a/drivers/staging/rtl8712/hal_init.c b/drivers/staging/rtl8712/hal_init.c
index cb9d4cf..d801c5a 100644
--- a/drivers/staging/rtl8712/hal_init.c
+++ b/drivers/staging/rtl8712/hal_init.c
@@ -49,7 +49,7 @@ static void rtl871x_load_fw_cb(const struct firmware *firmware, void *context)
 	if (!firmware) {
 		struct usb_device *udev = padapter->dvobjpriv.pusbdev;
 		struct usb_interface *pusb_intf = padapter->pusb_intf;
-		printk(KERN_ERR "r8712u: Firmware request failed\n");
+		dev_err(&udev->dev, "r8712u: Firmware request failed\n");
 		padapter->fw_found = false;
 		usb_put_dev(udev);
 		usb_set_intfdata(pusb_intf, NULL);
@@ -69,12 +69,11 @@ int rtl871x_load_fw(struct _adapter *padapter)
 	int rc;
 
 	init_completion(&padapter->rtl8712_fw_ready);
-	printk(KERN_INFO "r8712u: Loading firmware from \"%s\"\n",
-	       firmware_file);
+	dev_info(dev, "r8712u: Loading firmware from \"%s\"\n", firmware_file);
 	rc = request_firmware_nowait(THIS_MODULE, 1, firmware_file, dev,
 				     GFP_KERNEL, padapter, rtl871x_load_fw_cb);
 	if (rc)
-		printk(KERN_ERR "r8712u: Firmware request error %d\n", rc);
+		dev_err(dev, "r8712u: Firmware request error %d\n", rc);
 	return rc;
 }
 MODULE_FIRMWARE("rtlwifi/rtl8712u.bin");
@@ -84,8 +83,8 @@ static u32 rtl871x_open_fw(struct _adapter *padapter, const u8 **ppmappedfw)
 	const struct firmware **praw = &padapter->fw;
 
 	if (padapter->fw->size > 200000) {
-		printk(KERN_ERR "r8172u: Badfw->size of %d\n",
-		       (int)padapter->fw->size);
+		dev_err(&padapter->pnetdev->dev, "r8172u: Badfw->size of %d\n",
+			(int)padapter->fw->size);
 		return 0;
 	}
 	*ppmappedfw = (u8 *)((*praw)->data);
@@ -334,11 +333,13 @@ uint rtl8712_hal_init(struct _adapter *padapter)
 	if (rtl8712_dl_fw(padapter) != _SUCCESS)
 		return _FAIL;
 
-	printk(KERN_INFO "r8712u: 1 RCR=0x%x\n",  r8712_read32(padapter, RCR));
+	netdev_info(padapter->pnetdev, "1 RCR=0x%x\n",
+		    r8712_read32(padapter, RCR));
 	val32 = r8712_read32(padapter, RCR);
 	r8712_write32(padapter, RCR, (val32 | BIT(26))); /* Enable RX TCP
 							    Checksum offload */
-	printk(KERN_INFO "r8712u: 2 RCR=0x%x\n", r8712_read32(padapter, RCR));
+	netdev_info(padapter->pnetdev, "2 RCR=0x%x\n",
+		    r8712_read32(padapter, RCR));
 	val32 = r8712_read32(padapter, RCR);
 	r8712_write32(padapter, RCR, (val32|BIT(25))); /* Append PHY status */
 	val32 = 0;
diff --git a/drivers/staging/rtl8712/os_intfs.c b/drivers/staging/rtl8712/os_intfs.c
index e00f791..b65bf5e 100644
--- a/drivers/staging/rtl8712/os_intfs.c
+++ b/drivers/staging/rtl8712/os_intfs.c
@@ -224,8 +224,7 @@ struct net_device *r8712_init_netdev(void)
 	}
 	padapter = (struct _adapter *) netdev_priv(pnetdev);
 	padapter->pnetdev = pnetdev;
-	printk(KERN_INFO "r8712u: register rtl8712_netdev_ops to"
-	       " netdev_ops\n");
+	pr_info("r8712u: register rtl8712_netdev_ops to netdev_ops\n");
 	pnetdev->netdev_ops = &rtl8712_netdev_ops;
 	pnetdev->watchdog_timeo = HZ; /* 1 second timeout */
 	pnetdev->wireless_handlers = (struct iw_handler_def *)
diff --git a/drivers/staging/rtl8712/rtl8712_recv.c b/drivers/staging/rtl8712/rtl8712_recv.c
index c76732c..d59a74a 100644
--- a/drivers/staging/rtl8712/rtl8712_recv.c
+++ b/drivers/staging/rtl8712/rtl8712_recv.c
@@ -115,11 +115,11 @@ void r8712_free_recv_priv(struct recv_priv *precvpriv)
 	kfree(precvpriv->pallocated_recv_buf);
 	skb_queue_purge(&precvpriv->rx_skb_queue);
 	if (skb_queue_len(&precvpriv->rx_skb_queue))
-		printk(KERN_WARNING "r8712u: rx_skb_queue not empty\n");
+		netdev_warn(padapter->pnetdev, "r8712u: rx_skb_queue not empty\n");
 	skb_queue_purge(&precvpriv->free_recv_skb_queue);
 	if (skb_queue_len(&precvpriv->free_recv_skb_queue))
-		printk(KERN_WARNING "r8712u: free_recv_skb_queue not empty "
-		       "%d\n", skb_queue_len(&precvpriv->free_recv_skb_queue));
+		netdev_warn(padapter->pnetdev, "r8712u: free_recv_skb_queue not empty %d\n",
+			    skb_queue_len(&precvpriv->free_recv_skb_queue));
 }
 
 int r8712_init_recvbuf(struct _adapter *padapter, struct recv_buf *precvbuf)
@@ -364,9 +364,8 @@ static int amsdu_to_msdu(struct _adapter *padapter, union recv_frame *prframe)
 		nSubframe_Length = (nSubframe_Length >> 8) +
 				   (nSubframe_Length << 8);
 		if (a_len < (ETHERNET_HEADER_SIZE + nSubframe_Length)) {
-			printk(KERN_WARNING "r8712u: nRemain_Length is %d and"
-			    " nSubframe_Length is: %d\n",
-			    a_len, nSubframe_Length);
+			netdev_warn(padapter->pnetdev, "r8712u: nRemain_Length is %d and nSubframe_Length is: %d\n",
+				    a_len, nSubframe_Length);
 			goto exit;
 		}
 		/* move the data point to data content */
@@ -381,8 +380,7 @@ static int amsdu_to_msdu(struct _adapter *padapter, union recv_frame *prframe)
 		memcpy(data_ptr, pdata, nSubframe_Length);
 		subframes[nr_subframes++] = sub_skb;
 		if (nr_subframes >= MAX_SUBFRAME_COUNT) {
-			printk(KERN_WARNING "r8712u: ParseSubframe(): Too"
-			    " many Subframes! Packets dropped!\n");
+			netdev_warn(padapter->pnetdev, "r8712u: ParseSubframe(): Too many Subframes! Packets dropped!\n");
 			break;
 		}
 		pdata += nSubframe_Length;
diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
index c9a6a7f..74652b5 100644
--- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
@@ -415,8 +415,7 @@ static int wpa_set_encryption(struct net_device *dev, struct ieee_param *param,
 	} else
 		return -EINVAL;
 	if (strcmp(param->u.crypt.alg, "WEP") == 0) {
-		printk(KERN_INFO "r8712u: wpa_set_encryption, crypt.alg ="
-		       " WEP\n");
+		netdev_info(dev, "r8712u: %s: crypt.alg = WEP\n", __func__);
 		padapter->securitypriv.ndisencryptstatus =
 			     Ndis802_11Encryption1Enabled;
 		padapter->securitypriv.PrivacyAlgrthm = _WEP40_;
@@ -608,8 +607,7 @@ static int r871x_set_wpa_ie(struct _adapter *padapter, char *pie,
 
 				if ((eid == _VENDOR_SPECIFIC_IE_) &&
 				    (!memcmp(&buf[cnt+2], wps_oui, 4))) {
-					printk(KERN_INFO "r8712u: "
-					       "SET WPS_IE\n");
+					netdev_info(padapter->pnetdev, "r8712u: SET WPS_IE\n");
 					padapter->securitypriv.wps_ie_len =
 					    ((buf[cnt+1] + 2) <
 					    (MAX_WPA_IE_LEN << 2)) ?
@@ -620,8 +618,7 @@ static int r871x_set_wpa_ie(struct _adapter *padapter, char *pie,
 					    padapter->securitypriv.wps_ie_len);
 					padapter->securitypriv.wps_phase =
 								 true;
-					printk(KERN_INFO "r8712u: SET WPS_IE,"
-					    " wps_phase==true\n");
+					netdev_info(padapter->pnetdev, "r8712u: SET WPS_IE, wps_phase==true\n");
 					cnt += buf[cnt+1]+2;
 					break;
 				} else
@@ -829,8 +826,8 @@ static int r871x_wx_set_pmkid(struct net_device *dev,
 			    strIssueBssid, ETH_ALEN)) {
 				/* BSSID is matched, the same AP => rewrite
 				 * with new PMKID. */
-				printk(KERN_INFO "r8712u: r871x_wx_set_pmkid:"
-				    " BSSID exists in the PMKList.\n");
+				netdev_info(dev, "r8712u: %s: BSSID exists in the PMKList.\n",
+					    __func__);
 				memcpy(psecuritypriv->PMKIDList[j].PMKID,
 					pPMK->pmkid, IW_PMKID_LEN);
 				psecuritypriv->PMKIDList[j].bUsed = true;
@@ -841,9 +838,8 @@ static int r871x_wx_set_pmkid(struct net_device *dev,
 		}
 		if (!blInserted) {
 			/* Find a new entry */
-			printk(KERN_INFO "r8712u: r871x_wx_set_pmkid: Use the"
-			    " new entry index = %d for this PMKID.\n",
-			    psecuritypriv->PMKIDIndex);
+			netdev_info(dev, "r8712u: %s: Use the new entry index = %d for this PMKID.\n",
+				    __func__, psecuritypriv->PMKIDIndex);
 			memcpy(psecuritypriv->PMKIDList[psecuritypriv->
 				PMKIDIndex].Bssid, strIssueBssid, ETH_ALEN);
 			memcpy(psecuritypriv->PMKIDList[psecuritypriv->
@@ -876,8 +872,7 @@ static int r871x_wx_set_pmkid(struct net_device *dev,
 		intReturn = true;
 		break;
 	default:
-		printk(KERN_INFO "r8712u: r871x_wx_set_pmkid: "
-		       "unknown Command\n");
+		netdev_info(dev, "r8712u: %s: unknown Command\n", __func__);
 		intReturn = false;
 		break;
 	}
@@ -1045,8 +1040,8 @@ static int r871x_wx_set_priv(struct net_device *dev,
 		);
 		sprintf(ext, "OK");
 	} else {
-		printk(KERN_INFO "r8712u: r871x_wx_set_priv: unknown Command"
-		       " %s.\n", ext);
+		netdev_info(dev, "r8712u: %s: unknown Command %s.\n",
+			    __func__, ext);
 		goto FREE_EXT;
 	}
 	if (copy_to_user(dwrq->pointer, ext,
@@ -1183,8 +1178,8 @@ static int r8711_wx_set_scan(struct net_device *dev,
 	u8 status = true;
 
 	if (padapter->bDriverStopped == true) {
-		printk(KERN_WARNING "r8712u: in r8711_wx_set_scan: "
-		    "bDriverStopped=%d\n", padapter->bDriverStopped);
+		netdev_info(dev, "In %s: bDriverStopped=%d\n",
+			    __func__, padapter->bDriverStopped);
 		return -1;
 	}
 	if (padapter->bup == false)
@@ -1556,8 +1551,7 @@ static int r8711_wx_set_enc(struct net_device *dev,
 	key = erq->flags & IW_ENCODE_INDEX;
 	memset(&wep, 0, sizeof(struct NDIS_802_11_WEP));
 	if (erq->flags & IW_ENCODE_DISABLED) {
-		printk(KERN_INFO "r8712u: r8711_wx_set_enc: "
-		       "EncryptionDisabled\n");
+		netdev_info(dev, "r8712u: %s: EncryptionDisabled\n", __func__);
 		padapter->securitypriv.ndisencryptstatus =
 				 Ndis802_11EncryptionDisabled;
 		padapter->securitypriv.PrivacyAlgrthm = _NO_PRIVACY_;
@@ -1578,8 +1572,7 @@ static int r8711_wx_set_enc(struct net_device *dev,
 	}
 	/* set authentication mode */
 	if (erq->flags & IW_ENCODE_OPEN) {
-		printk(KERN_INFO "r8712u: r8711_wx_set_enc: "
-		       "IW_ENCODE_OPEN\n");
+		netdev_info(dev, "r8712u: %s: IW_ENCODE_OPEN\n", __func__);
 		padapter->securitypriv.ndisencryptstatus =
 				 Ndis802_11Encryption1Enabled;
 		padapter->securitypriv.AuthAlgrthm = 0; /* open system */
@@ -1588,8 +1581,7 @@ static int r8711_wx_set_enc(struct net_device *dev,
 		authmode = Ndis802_11AuthModeOpen;
 		padapter->securitypriv.ndisauthtype = authmode;
 	} else if (erq->flags & IW_ENCODE_RESTRICTED) {
-		printk(KERN_INFO "r8712u: r8711_wx_set_enc: "
-		       "IW_ENCODE_RESTRICTED\n");
+		netdev_info(dev, "r8712u: %s: IW_ENCODE_RESTRICTED\n", __func__);
 		padapter->securitypriv.ndisencryptstatus =
 				 Ndis802_11Encryption1Enabled;
 		padapter->securitypriv.AuthAlgrthm = 1; /* shared system */
@@ -1977,9 +1969,9 @@ static int r871x_mp_ioctl_hdl(struct net_device *dev,
 		status = phandler->handler(&oid_par);
 		/* todo:check status, BytesNeeded, etc. */
 	} else {
-		printk(KERN_INFO "r8712u: r871x_mp_ioctl_hdl(): err!,"
-		    " subcode=%d, oid=%d, handler=%p\n",
-		    poidparam->subcode, phandler->oid, phandler->handler);
+		netdev_info(dev, "r8712u: %s: err!, subcode=%d, oid=%d, handler=%p\n",
+			    __func__, poidparam->subcode, phandler->oid,
+			    phandler->handler);
 		ret = -EFAULT;
 		goto _r871x_mp_ioctl_hdl_exit;
 	}
@@ -2034,13 +2026,13 @@ static int r871x_get_ap_info(struct net_device *dev,
 			break;
 		pnetwork = LIST_CONTAINOR(plist, struct wlan_network, list);
 		if (hwaddr_aton_i(data, bssid)) {
-			printk(KERN_INFO "r8712u: Invalid BSSID '%s'.\n",
-			       (u8 *)data);
+			netdev_info(dev, "r8712u: Invalid BSSID '%s'.\n",
+				    (u8 *)data);
 			spin_unlock_irqrestore(&(pmlmepriv->scanned_queue.lock),
-									irqL);
+					       irqL);
 			return -EINVAL;
 		}
-		printk(KERN_INFO "r8712u: BSSID:%pM\n", bssid);
+		netdev_info(dev, "r8712u: BSSID:%pM\n", bssid);
 		if (!memcmp(bssid, pnetwork->network.MacAddress, ETH_ALEN)) {
 			/* BSSID match, then check if supporting wpa/wpa2 */
 			pbuf = r8712_get_wpa_ie(&pnetwork->network.IEs[12],
diff --git a/drivers/staging/rtl8712/rtl871x_mlme.c b/drivers/staging/rtl8712/rtl871x_mlme.c
index c51ad9e..ed6cc94 100644
--- a/drivers/staging/rtl8712/rtl871x_mlme.c
+++ b/drivers/staging/rtl8712/rtl871x_mlme.c
@@ -1048,8 +1048,8 @@ void r8712_got_addbareq_event_callback(struct _adapter *adapter, u8 *pbuf)
 	struct	sta_priv *pstapriv = &adapter->stapriv;
 	struct	recv_reorder_ctrl *precvreorder_ctrl = NULL;
 
-	printk(KERN_INFO "r8712u: [%s] mac = %pM, seq = %d, tid = %d\n",
-	     __func__, pAddbareq_pram->MacAddress,
+	netdev_info(adapter->pnetdev, "%s: mac = %pM, seq = %d, tid = %d\n",
+		    __func__, pAddbareq_pram->MacAddress,
 	    pAddbareq_pram->StartSeqNum, pAddbareq_pram->tid);
 	psta = r8712_get_stainfo(pstapriv, pAddbareq_pram->MacAddress);
 	if (psta) {
diff --git a/drivers/staging/rtl8712/usb_intf.c b/drivers/staging/rtl8712/usb_intf.c
index 6b73843..2f8a0bd 100644
--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -203,9 +203,9 @@ static int r871x_suspend(struct usb_interface *pusb_intf, pm_message_t state)
 {
 	struct net_device *pnetdev = usb_get_intfdata(pusb_intf);
 
-	printk(KERN_INFO "r8712: suspending...\n");
+	netdev_info(pnetdev, "Suspending...\n");
 	if (!pnetdev || !netif_running(pnetdev)) {
-		printk(KERN_INFO "r8712: unable to suspend\n");
+		netdev_info(pnetdev, "Unable to suspend\n");
 		return 0;
 	}
 	if (pnetdev->netdev_ops->ndo_stop)
@@ -219,9 +219,9 @@ static int r871x_resume(struct usb_interface *pusb_intf)
 {
 	struct net_device *pnetdev = usb_get_intfdata(pusb_intf);
 
-	printk(KERN_INFO "r8712: resuming...\n");
+	netdev_info(pnetdev,  "Resuming...\n");
 	if (!pnetdev || !netif_running(pnetdev)) {
-		printk(KERN_INFO "r8712: unable to resume\n");
+		netdev_info(pnetdev, "Unable to resume\n");
 		return 0;
 	}
 	netif_device_attach(pnetdev);
@@ -271,12 +271,12 @@ static uint r8712_usb_dvobj_init(struct _adapter *padapter)
 	pdvobjpriv->nr_endpoint = piface_desc->bNumEndpoints;
 	if (pusbd->speed == USB_SPEED_HIGH) {
 		pdvobjpriv->ishighspeed = true;
-		printk(KERN_INFO "r8712u: USB_SPEED_HIGH with %d endpoints\n",
-		       pdvobjpriv->nr_endpoint);
+		dev_info(&pusbd->dev, "r8712u: USB_SPEED_HIGH with %d endpoints\n",
+			 pdvobjpriv->nr_endpoint);
 	} else {
 		pdvobjpriv->ishighspeed = false;
-		printk(KERN_INFO "r8712u: USB_SPEED_LOW with %d endpoints\n",
-		       pdvobjpriv->nr_endpoint);
+		dev_info(&pusbd->dev, "r8712u: USB_SPEED_LOW with %d endpoints\n",
+			 pdvobjpriv->nr_endpoint);
 	}
 	if ((r8712_alloc_io_queue(padapter)) == _FAIL)
 		status = _FAIL;
@@ -421,9 +421,9 @@ static int r871xu_drv_init(struct usb_interface *pusb_intf,
 		tmpU1b = r8712_read8(padapter, EE_9346CR);/*CR9346*/
 
 		/* To check system boot selection.*/
-		printk(KERN_INFO "r8712u: Boot from %s: Autoload %s\n",
-		       (tmpU1b & _9356SEL) ? "EEPROM" : "EFUSE",
-		       (tmpU1b & _EEPROM_EN) ? "OK" : "Failed");
+		dev_info(&udev->dev, "r8712u: Boot from %s: Autoload %s\n",
+			 (tmpU1b & _9356SEL) ? "EEPROM" : "EFUSE",
+			 (tmpU1b & _EEPROM_EN) ? "OK" : "Failed");
 
 		/* To check autoload success or not.*/
 		if (tmpU1b & _EEPROM_EN) {
@@ -531,8 +531,8 @@ static int r871xu_drv_init(struct usb_interface *pusb_intf,
 						 RT_CID_DEFAULT;
 				break;
 			}
-			printk(KERN_INFO "r8712u: CustomerID = 0x%.4x\n",
-			     padapter->eeprompriv.CustomerID);
+			dev_info(&udev->dev, "r8712u: CustomerID = 0x%.4x\n",
+				 padapter->eeprompriv.CustomerID);
 			/* Led mode */
 			switch (padapter->eeprompriv.CustomerID) {
 			case RT_CID_DEFAULT:
@@ -588,11 +588,9 @@ static int r871xu_drv_init(struct usb_interface *pusb_intf,
 			 * address by setting bit 1 of first octet.
 			 */
 			mac[0] &= 0xFE;
-			printk(KERN_INFO "r8712u: MAC Address from user = "
-			       "%pM\n", mac);
+			dev_info(&udev->dev, "r8712u: MAC Address from user = %pM\n", mac);
 		} else
-			printk(KERN_INFO "r8712u: MAC Address from efuse = "
-			       "%pM\n", mac);
+			dev_info(&udev->dev, "r8712u: MAC Address from efuse = %pM\n", mac);
 		memcpy(pnetdev->dev_addr, mac, ETH_ALEN);
 	}
 	/* step 6. Load the firmware asynchronously */
@@ -659,7 +657,6 @@ static void __exit r8712u_drv_halt(void)
 {
 	drvpriv.drv_registered = false;
 	usb_deregister(&drvpriv.r871xu_drv);
-	printk(KERN_INFO "r8712u: Driver unloaded\n");
 }
 
 module_init(r8712u_drv_entry);
diff --git a/drivers/staging/rtl8712/usb_ops_linux.c b/drivers/staging/rtl8712/usb_ops_linux.c
index 24e1ec5..9e28ef0 100644
--- a/drivers/staging/rtl8712/usb_ops_linux.c
+++ b/drivers/staging/rtl8712/usb_ops_linux.c
@@ -243,8 +243,7 @@ static void r8712_usb_read_port_complete(struct urb *purb)
 				  (unsigned char *)precvbuf);
 			break;
 		case -EINPROGRESS:
-			printk(KERN_ERR "r8712u: ERROR: URB IS IN"
-			       " PROGRESS!/n");
+			netdev_err(padapter->pnetdev, "ERROR: URB IS IN PROGRESS!\n");
 			break;
 		default:
 			break;
@@ -336,8 +335,7 @@ void r8712_xmit_bh(void *priv)
 
 	if ((padapter->bDriverStopped == true) ||
 	    (padapter->bSurpriseRemoved == true)) {
-		printk(KERN_ERR "r8712u: xmit_bh => bDriverStopped"
-		       " or bSurpriseRemoved\n");
+		netdev_err(padapter->pnetdev, "xmit_bh => bDriverStopped or bSurpriseRemoved\n");
 		return;
 	}
 	ret = r8712_xmitframe_complete(padapter, pxmitpriv, NULL);
@@ -387,7 +385,7 @@ static void usb_write_port_complete(struct urb *purb)
 	case 0:
 		break;
 	default:
-		printk(KERN_WARNING "r8712u: pipe error: (%d)\n", purb->status);
+		netdev_warn(padapter->pnetdev, "r8712u: pipe error: (%d)\n", purb->status);
 		break;
 	}
 	/* not to consider tx fragment */
@@ -502,8 +500,8 @@ int r8712_usbctrl_vendorreq(struct intf_priv *pintfpriv, u8 request, u16 value,
 
 	palloc_buf = _malloc((u32) len + 16);
 	if (palloc_buf == NULL) {
-		printk(KERN_ERR "r8712u: [%s] Can't alloc memory for vendor"
-		       " request\n", __func__);
+		dev_err(&udev->dev, "%s: Can't alloc memory for vendor request\n",
+			__func__);
 		return -1;
 	}
 	pIo_buf = palloc_buf + 16 - ((addr_t)(palloc_buf) & 0x0f);
diff --git a/drivers/staging/rtl8712/xmit_linux.c b/drivers/staging/rtl8712/xmit_linux.c
index 65542cb..4d22bb7 100644
--- a/drivers/staging/rtl8712/xmit_linux.c
+++ b/drivers/staging/rtl8712/xmit_linux.c
@@ -134,8 +134,7 @@ int r8712_xmit_resource_alloc(struct _adapter *padapter,
 	for (i = 0; i < 8; i++) {
 		pxmitbuf->pxmit_urb[i] = usb_alloc_urb(0, GFP_KERNEL);
 		if (pxmitbuf->pxmit_urb[i] == NULL) {
-			printk(KERN_ERR "r8712u: pxmitbuf->pxmit_urb[i]"
-			    " == NULL");
+			netdev_err(padapter->pnetdev, "pxmitbuf->pxmit_urb[i] == NULL\n");
 			return _FAIL;
 		}
 	}
-- 
1.8.0.1

