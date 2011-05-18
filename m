Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933439Ab1ERSXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 14:23:30 -0400
Received: from mail.perches.com ([173.55.12.10]:1761 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932709Ab1ERSX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 14:23:27 -0400
From: Joe Perches <joe@perches.com>
To: Brett Rudley <brudley@broadcom.com>, Henry Ptasinski <henryp@broadcom.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org, Dowan Kim <dowan@broadcom.com>,
        Roland Vossen <rvossen@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>, linux-wireless@vger.kernel.org
Subject: [PATCH] staging: brcm80211: brcmfmac: Add and use dhd_dbg
Date: Wed, 18 May 2011 11:23:21 -0700
Message-Id: <60c19c2ad4f078b6f283b5ff4ecca3653833ea28.1305742868.git.joe@perches.com>
X-Mailer: git-send-email 1.7.5.rc3.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All uses of DHD_<TYPE> macros are for debugging only.

Change the multiple uses of DHD_<TYPE>((...)) to dhd_dbg(TYPE, ...)
for a more consistent style.

Remove unnecessary parentheses from uses.
Coalesce long formats.
Add a few missing newlines.
Use print_hex_dump_bytes where appropriate.
Add KERN_DEBUG prefix to debug message output.
Remove internal single line string concatenations.
Use __func__ a few places instead of hard strings.
Reduced indent in a couple of case labels.
Fix compilation error when !BCMDBG.
Fix a couple of spelling typos.

size increases trivially when CONFIG_BRCMDBG is set,
size decreases quite a bit when not set.

CONFIG_BRCMDBG set:

$ size drivers/staging/brcm80211/brcmfmac/built-in.o*
   text	   data	    bss	    dec	    hex	filename
 238761	   7885	  73052	 319698	  4e0d2	drivers/staging/brcm80211/brcmfmac/built-in.o.new
 238146	   7885	  73132	 319163	  4debb	drivers/staging/brcm80211/brcmfmac/built-in.o.old

CONFIG_BRCMDBG is not set

$ size drivers/staging/brcm80211/brcmfmac/built-in.o*
   text	   data	    bss	    dec	    hex	filename
 175964	   7885	  58820	 242669	  3b3ed	drivers/staging/brcm80211/brcmfmac/built-in.o.new
 200293	   7885	  63732	 271910	  42626	drivers/staging/brcm80211/brcmfmac/built-in.o.old

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c    |   68 +-
 drivers/staging/brcm80211/brcmfmac/dhd_common.c |  478 +++++-----
 drivers/staging/brcm80211/brcmfmac/dhd_dbg.h    |   55 +-
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c  |  254 +++---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c   | 1138 ++++++++++++-----------
 5 files changed, 1026 insertions(+), 967 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
index ba5a5cb..aca04df 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
@@ -65,7 +65,7 @@ static int dhdcdc_msg(dhd_pub_t *dhd)
 	dhd_prot_t *prot = dhd->prot;
 	int len = le32_to_cpu(prot->msg.len) + sizeof(cdc_ioctl_t);
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	dhd_dbg(TRACE, "%s: Enter\n", __func__);
 
 	/* NOTE : cdc->msg.len holds the desired length of the buffer to be
 	 *        returned. Only up to CDC_MAX_MSG_SIZE of this buffer area
@@ -83,7 +83,7 @@ static int dhdcdc_cmplt(dhd_pub_t *dhd, u32 id, u32 len)
 	int ret;
 	dhd_prot_t *prot = dhd->prot;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	dhd_dbg(TRACE, "%s: Enter\n", __func__);
 
 	do {
 		ret =
@@ -105,8 +105,8 @@ dhdcdc_query_ioctl(dhd_pub_t *dhd, int ifidx, uint cmd, void *buf, uint len)
 	int ret = 0, retries = 0;
 	u32 id, flags = 0;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
-	DHD_CTL(("%s: cmd %d len %d\n", __func__, cmd, len));
+	dhd_dbg(TRACE, "%s: Enter\n", __func__);
+	dhd_dbg(CTL, "%s: cmd %d len %d\n", __func__, cmd, len);
 
 	/* Respond "bcmerror" and "bcmerrorstr" with local cache */
 	if (cmd == WLC_GET_VAR && buf) {
@@ -133,8 +133,8 @@ dhdcdc_query_ioctl(dhd_pub_t *dhd, int ifidx, uint cmd, void *buf, uint len)
 
 	ret = dhdcdc_msg(dhd);
 	if (ret < 0) {
-		DHD_ERROR(("dhdcdc_query_ioctl: dhdcdc_msg failed w/status "
-			"%d\n", ret));
+		dhd_dbg(ERROR, "%s: dhdcdc_msg failed w/status %d\n",
+			__func__, ret);
 		goto done;
 	}
 
@@ -150,8 +150,9 @@ retry:
 	if ((id < prot->reqid) && (++retries < RETRIES))
 		goto retry;
 	if (id != prot->reqid) {
-		DHD_ERROR(("%s: %s: unexpected request id %d (expected %d)\n",
-			   dhd_ifname(dhd, ifidx), __func__, id, prot->reqid));
+		dhd_dbg(ERROR,
+			"%s: %s: unexpected request id %d (expected %d)\n",
+			dhd_ifname(dhd, ifidx), __func__, id, prot->reqid);
 		ret = -EINVAL;
 		goto done;
 	}
@@ -184,8 +185,8 @@ int dhdcdc_set_ioctl(dhd_pub_t *dhd, int ifidx, uint cmd, void *buf, uint len)
 	int ret = 0;
 	u32 flags, id;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
-	DHD_CTL(("%s: cmd %d len %d\n", __func__, cmd, len));
+	dhd_dbg(TRACE, "%s: Enter\n", __func__);
+	dhd_dbg(CTL, "%s: cmd %d len %d\n", __func__, cmd, len);
 
 	memset(msg, 0, sizeof(cdc_ioctl_t));
 
@@ -210,8 +211,9 @@ int dhdcdc_set_ioctl(dhd_pub_t *dhd, int ifidx, uint cmd, void *buf, uint len)
 	id = (flags & CDCF_IOC_ID_MASK) >> CDCF_IOC_ID_SHIFT;
 
 	if (id != prot->reqid) {
-		DHD_ERROR(("%s: %s: unexpected request id %d (expected %d)\n",
-			   dhd_ifname(dhd, ifidx), __func__, id, prot->reqid));
+		dhd_dbg(ERROR,
+			"%s: %s: unexpected request id %d (expected %d)\n",
+			dhd_ifname(dhd, ifidx), __func__, id, prot->reqid);
 		ret = -EINVAL;
 		goto done;
 	}
@@ -235,13 +237,13 @@ dhd_prot_ioctl(dhd_pub_t *dhd, int ifidx, wl_ioctl_t *ioc, void *buf, int len)
 	int ret = -1;
 
 	if (dhd->busstate == DHD_BUS_DOWN) {
-		DHD_ERROR(("%s : bus is down. we have nothing to do\n",
-			   __func__));
+		dhd_dbg(ERROR, "%s : bus is down. we have nothing to do\n",
+			__func__);
 		return ret;
 	}
 	dhd_os_proto_block(dhd);
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	dhd_dbg(TRACE, "%s: Enter\n", __func__);
 
 	ASSERT(len <= WLC_IOCTL_MAXLEN);
 
@@ -249,12 +251,12 @@ dhd_prot_ioctl(dhd_pub_t *dhd, int ifidx, wl_ioctl_t *ioc, void *buf, int len)
 		goto done;
 
 	if (prot->pending == true) {
-		DHD_TRACE(("CDC packet is pending!!!! cmd=0x%x (%lu) "
-			"lastcmd=0x%x (%lu)\n",
+		dhd_dbg(TRACE,
+			"CDC packet is pending!!!! cmd=0x%x (%lu) lastcmd=0x%x (%lu)\n",
 			ioc->cmd, (unsigned long)ioc->cmd, prot->lastcmd,
-			(unsigned long)prot->lastcmd));
+			(unsigned long)prot->lastcmd);
 		if ((ioc->cmd == WLC_SET_VAR) || (ioc->cmd == WLC_GET_VAR))
-			DHD_TRACE(("iovar cmd=%s\n", (char *)buf));
+			dhd_dbg(TRACE, "iovar cmd=%s\n", (char *)buf);
 
 		goto done;
 	}
@@ -323,7 +325,7 @@ void dhd_prot_hdrpush(dhd_pub_t *dhd, int ifidx, struct sk_buff *pktbuf)
 	struct bdc_header *h;
 #endif				/* BDC */
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	dhd_dbg(TRACE, "%s: Enter\n", __func__);
 
 #ifdef BDC
 	/* Push BDC header used to convey priority for buses that don't */
@@ -349,14 +351,14 @@ int dhd_prot_hdrpull(dhd_pub_t *dhd, int *ifidx, struct sk_buff *pktbuf)
 	struct bdc_header *h;
 #endif
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	dhd_dbg(TRACE, "%s: Enter\n", __func__);
 
 #ifdef BDC
 	/* Pop BDC header used to convey priority for buses that don't */
 
 	if (pktbuf->len < BDC_HEADER_LEN) {
-		DHD_ERROR(("%s: rx data too short (%d < %d)\n", __func__,
-			   pktbuf->len, BDC_HEADER_LEN));
+		dhd_dbg(ERROR, "%s: rx data too short (%d < %d)\n",
+			__func__, pktbuf->len, BDC_HEADER_LEN);
 		return -EBADE;
 	}
 
@@ -364,22 +366,22 @@ int dhd_prot_hdrpull(dhd_pub_t *dhd, int *ifidx, struct sk_buff *pktbuf)
 
 	*ifidx = BDC_GET_IF_IDX(h);
 	if (*ifidx >= DHD_MAX_IFS) {
-		DHD_ERROR(("%s: rx data ifnum out of range (%d)\n",
-			   __func__, *ifidx));
+		dhd_dbg(ERROR, "%s: rx data ifnum out of range (%d)\n",
+			__func__, *ifidx);
 		return -EBADE;
 	}
 
 	if (((h->flags & BDC_FLAG_VER_MASK) >> BDC_FLAG_VER_SHIFT) !=
 	    BDC_PROTO_VER) {
-		DHD_ERROR(("%s: non-BDC packet received, flags 0x%x\n",
-			   dhd_ifname(dhd, *ifidx), h->flags));
+		dhd_dbg(ERROR, "%s: non-BDC packet received, flags 0x%x\n",
+			dhd_ifname(dhd, *ifidx), h->flags);
 		return -EBADE;
 	}
 
 	if (h->flags & BDC_FLAG_SUM_GOOD) {
-		DHD_INFO(("%s: BDC packet received with good rx-csum, "
-			"flags 0x%x\n",
-			dhd_ifname(dhd, *ifidx), h->flags));
+		dhd_dbg(INFO,
+			"%s: BDC packet received with good rx-csum, flags 0x%x\n",
+			dhd_ifname(dhd, *ifidx), h->flags);
 		PKTSETSUMGOOD(pktbuf, true);
 	}
 
@@ -397,13 +399,13 @@ int dhd_prot_attach(dhd_pub_t *dhd)
 
 	cdc = kzalloc(sizeof(dhd_prot_t), GFP_ATOMIC);
 	if (!cdc) {
-		DHD_ERROR(("%s: kmalloc failed\n", __func__));
+		dhd_dbg(ERROR, "%s: kmalloc failed\n", __func__);
 		goto fail;
 	}
 
 	/* ensure that the msg buf directly follows the cdc msg struct */
 	if ((unsigned long)(&cdc->msg + 1) != (unsigned long)cdc->buf) {
-		DHD_ERROR(("dhd_prot_t is not correctly defined\n"));
+		dhd_dbg(ERROR, "dhd_prot_t is not correctly defined\n");
 		goto fail;
 	}
 
@@ -443,7 +445,7 @@ int dhd_prot_init(dhd_pub_t *dhd)
 	int ret = 0;
 	char buf[128];
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	dhd_dbg(TRACE, "%s: Enter\n", __func__);
 
 	dhd_os_proto_block(dhd);
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index 0bfb93c..dad4db9 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -200,7 +200,7 @@ dhd_doiovar(dhd_pub_t *dhd_pub, const bcm_iovar_t *vi, u32 actionid,
 	int bcmerror = 0;
 	s32 int_val = 0;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	dhd_dbg(TRACE, "%s: Enter\n", __func__);
 
 	bcmerror = bcm_iovar_lencheck(vi, arg, len, IOV_ISSET(actionid));
 	if (bcmerror != 0)
@@ -341,8 +341,9 @@ bool dhd_prec_enq(dhd_pub_t *dhdp, struct pktq *q, struct sk_buff *pkt,
 		p = discard_oldest ? bcm_pktq_pdeq(q, eprec) :
 			bcm_pktq_pdeq_tail(q, eprec);
 		if (p == NULL) {
-			DHD_ERROR(("%s: bcm_pktq_penq() failed, oldest %d.",
-				   __func__, discard_oldest));
+			dhd_dbg(ERROR,
+				"%s: bcm_pktq_penq() failed, oldest %d\n",
+				__func__, discard_oldest);
 			ASSERT(p);
 		}
 
@@ -352,7 +353,7 @@ bool dhd_prec_enq(dhd_pub_t *dhdp, struct pktq *q, struct sk_buff *pkt,
 	/* Enqueue */
 	p = bcm_pktq_penq(q, prec, pkt);
 	if (p == NULL) {
-		DHD_ERROR(("%s: bcm_pktq_penq() failed.", __func__));
+		dhd_dbg(ERROR, "%s: bcm_pktq_penq() failed\n", __func__);
 		ASSERT(p);
 	}
 
@@ -368,7 +369,7 @@ dhd_iovar_op(dhd_pub_t *dhd_pub, const char *name,
 	const bcm_iovar_t *vi = NULL;
 	u32 actionid;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	dhd_dbg(TRACE, "%s: Enter\n", __func__);
 
 	ASSERT(name);
 	ASSERT(len >= 0);
@@ -385,8 +386,8 @@ dhd_iovar_op(dhd_pub_t *dhd_pub, const char *name,
 		goto exit;
 	}
 
-	DHD_CTL(("%s: %s %s, len %d plen %d\n", __func__,
-		 name, (set ? "set" : "get"), len, plen));
+	dhd_dbg(CTL, "%s: %s %s, len %d plen %d\n",
+		__func__, name, (set ? "set" : "get"), len, plen);
 
 	/* set up 'params' pointer in case this is a set command so that
 	 * the convenience int and bool code can be common to set and get
@@ -417,7 +418,7 @@ int dhd_ioctl(dhd_pub_t *dhd_pub, dhd_ioctl_t *ioc, void *buf, uint buflen)
 {
 	int bcmerror = 0;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	dhd_dbg(TRACE, "%s: Enter\n", __func__);
 
 	if (!buf)
 		return -EINVAL;
@@ -585,9 +586,10 @@ static void wl_show_host_event(wl_event_msg_t *event, void *event_data)
 			event_name = event_names[i].event_name;
 	}
 
-	DHD_EVENT(("EVENT: %s, event ID = %d\n", event_name, event_type));
-	DHD_EVENT(("flags 0x%04x, status %d, reason %d, auth_type %d MAC %s\n",
-				flags, status, reason, auth_type, eabuf));
+	dhd_dbg(EVENT, "EVENT: %s, event ID = %d\n", event_name, event_type);
+	dhd_dbg(EVENT,
+		"flags 0x%04x, status %d, reason %d, auth_type %d MAC %s\n",
+		flags, status, reason, auth_type, eabuf);
 
 	if (flags & WLC_EVENT_MSG_LINK)
 		link = true;
@@ -600,35 +602,37 @@ static void wl_show_host_event(wl_event_msg_t *event, void *event_data)
 	case WLC_E_START:
 	case WLC_E_DEAUTH:
 	case WLC_E_DISASSOC:
-		DHD_EVENT(("MACEVENT: %s, MAC %s\n", event_name, eabuf));
+		dhd_dbg(EVENT, "MACEVENT: %s, MAC %s\n", event_name, eabuf);
 		break;
 
 	case WLC_E_ASSOC_IND:
 	case WLC_E_REASSOC_IND:
-		DHD_EVENT(("MACEVENT: %s, MAC %s\n", event_name, eabuf));
+		dhd_dbg(EVENT, "MACEVENT: %s, MAC %s\n", event_name, eabuf);
 		break;
 
 	case WLC_E_ASSOC:
 	case WLC_E_REASSOC:
 		if (status == WLC_E_STATUS_SUCCESS) {
-			DHD_EVENT(("MACEVENT: %s, MAC %s, SUCCESS\n",
-				   event_name, eabuf));
+			dhd_dbg(EVENT, "MACEVENT: %s, MAC %s, SUCCESS\n",
+				event_name, eabuf);
 		} else if (status == WLC_E_STATUS_TIMEOUT) {
-			DHD_EVENT(("MACEVENT: %s, MAC %s, TIMEOUT\n",
-				   event_name, eabuf));
+			dhd_dbg(EVENT, "MACEVENT: %s, MAC %s, TIMEOUT\n",
+				event_name, eabuf);
 		} else if (status == WLC_E_STATUS_FAIL) {
-			DHD_EVENT(("MACEVENT: %s, MAC %s, FAILURE, reason %d\n",
-				   event_name, eabuf, (int)reason));
+			dhd_dbg(EVENT,
+				"MACEVENT: %s, MAC %s, FAILURE, reason %d\n",
+				event_name, eabuf, (int)reason);
 		} else {
-			DHD_EVENT(("MACEVENT: %s, MAC %s, unexpected status "
-				"%d\n", event_name, eabuf, (int)status));
+			dhd_dbg(EVENT,
+				"MACEVENT: %s, MAC %s, unexpected status %d\n",
+				event_name, eabuf, (int)status);
 		}
 		break;
 
 	case WLC_E_DEAUTH_IND:
 	case WLC_E_DISASSOC_IND:
-		DHD_EVENT(("MACEVENT: %s, MAC %s, reason %d\n", event_name,
-			   eabuf, (int)reason));
+		dhd_dbg(EVENT, "MACEVENT: %s, MAC %s, reason %d\n",
+			event_name, eabuf, (int)reason);
 		break;
 
 	case WLC_E_AUTH:
@@ -642,18 +646,18 @@ static void wl_show_host_event(wl_event_msg_t *event, void *event_data)
 			auth_str = err_msg;
 		}
 		if (event_type == WLC_E_AUTH_IND) {
-			DHD_EVENT(("MACEVENT: %s, MAC %s, %s\n", event_name,
-				   eabuf, auth_str));
+			dhd_dbg(EVENT, "MACEVENT: %s, MAC %s, %s\n",
+				event_name, eabuf, auth_str);
 		} else if (status == WLC_E_STATUS_SUCCESS) {
-			DHD_EVENT(("MACEVENT: %s, MAC %s, %s, SUCCESS\n",
-				   event_name, eabuf, auth_str));
+			dhd_dbg(EVENT, "MACEVENT: %s, MAC %s, %s, SUCCESS\n",
+				event_name, eabuf, auth_str);
 		} else if (status == WLC_E_STATUS_TIMEOUT) {
-			DHD_EVENT(("MACEVENT: %s, MAC %s, %s, TIMEOUT\n",
-				   event_name, eabuf, auth_str));
+			dhd_dbg(EVENT, "MACEVENT: %s, MAC %s, %s, TIMEOUT\n",
+				event_name, eabuf, auth_str);
 		} else if (status == WLC_E_STATUS_FAIL) {
-			DHD_EVENT(("MACEVENT: %s, MAC %s, %s, FAILURE, "
-				"reason %d\n",
-				event_name, eabuf, auth_str, (int)reason));
+			dhd_dbg(EVENT,
+				"MACEVENT: %s, MAC %s, %s, FAILURE, reason %d\n",
+				event_name, eabuf, auth_str, (int)reason);
 		}
 
 		break;
@@ -662,145 +666,138 @@ static void wl_show_host_event(wl_event_msg_t *event, void *event_data)
 	case WLC_E_ROAM:
 	case WLC_E_SET_SSID:
 		if (status == WLC_E_STATUS_SUCCESS) {
-			DHD_EVENT(("MACEVENT: %s, MAC %s\n", event_name,
-				   eabuf));
+			dhd_dbg(EVENT, "MACEVENT: %s, MAC %s\n",
+				event_name, eabuf);
 		} else if (status == WLC_E_STATUS_FAIL) {
-			DHD_EVENT(("MACEVENT: %s, failed\n", event_name));
+			dhd_dbg(EVENT, "MACEVENT: %s, failed\n", event_name);
 		} else if (status == WLC_E_STATUS_NO_NETWORKS) {
-			DHD_EVENT(("MACEVENT: %s, no networks found\n",
-				   event_name));
+			dhd_dbg(EVENT, "MACEVENT: %s, no networks found\n",
+				event_name);
 		} else {
-			DHD_EVENT(("MACEVENT: %s, unexpected status %d\n",
-				   event_name, (int)status));
+			dhd_dbg(EVENT, "MACEVENT: %s, unexpected status %d\n",
+				event_name, (int)status);
 		}
 		break;
 
 	case WLC_E_BEACON_RX:
 		if (status == WLC_E_STATUS_SUCCESS) {
-			DHD_EVENT(("MACEVENT: %s, SUCCESS\n", event_name));
+			dhd_dbg(EVENT, "MACEVENT: %s, SUCCESS\n", event_name);
 		} else if (status == WLC_E_STATUS_FAIL) {
-			DHD_EVENT(("MACEVENT: %s, FAIL\n", event_name));
+			dhd_dbg(EVENT, "MACEVENT: %s, FAIL\n", event_name);
 		} else {
-			DHD_EVENT(("MACEVENT: %s, status %d\n", event_name,
-				   status));
+			dhd_dbg(EVENT, "MACEVENT: %s, status %d\n",
+				event_name, status);
 		}
 		break;
 
 	case WLC_E_LINK:
-		DHD_EVENT(("MACEVENT: %s %s\n", event_name,
-			   link ? "UP" : "DOWN"));
+		dhd_dbg(EVENT, "MACEVENT: %s %s\n",
+			event_name, link ? "UP" : "DOWN");
 		break;
 
 	case WLC_E_MIC_ERROR:
-		DHD_EVENT(("MACEVENT: %s, MAC %s, Group %d, Flush %d\n",
-			   event_name, eabuf, group, flush_txq));
+		dhd_dbg(EVENT, "MACEVENT: %s, MAC %s, Group %d, Flush %d\n",
+			event_name, eabuf, group, flush_txq);
 		break;
 
 	case WLC_E_ICV_ERROR:
 	case WLC_E_UNICAST_DECODE_ERROR:
 	case WLC_E_MULTICAST_DECODE_ERROR:
-		DHD_EVENT(("MACEVENT: %s, MAC %s\n", event_name, eabuf));
+		dhd_dbg(EVENT, "MACEVENT: %s, MAC %s\n", event_name, eabuf);
 		break;
 
 	case WLC_E_TXFAIL:
-		DHD_EVENT(("MACEVENT: %s, RA %s\n", event_name, eabuf));
+		dhd_dbg(EVENT, "MACEVENT: %s, RA %s\n", event_name, eabuf);
 		break;
 
 	case WLC_E_SCAN_COMPLETE:
 	case WLC_E_PMKID_CACHE:
-		DHD_EVENT(("MACEVENT: %s\n", event_name));
+		dhd_dbg(EVENT, "MACEVENT: %s\n", event_name);
 		break;
 
 	case WLC_E_PFN_NET_FOUND:
 	case WLC_E_PFN_NET_LOST:
 	case WLC_E_PFN_SCAN_COMPLETE:
-		DHD_EVENT(("PNOEVENT: %s\n", event_name));
+		dhd_dbg(EVENT, "PNOEVENT: %s\n", event_name);
 		break;
 
 	case WLC_E_PSK_SUP:
 	case WLC_E_PRUNE:
-		DHD_EVENT(("MACEVENT: %s, status %d, reason %d\n",
-			   event_name, (int)status, (int)reason));
+		dhd_dbg(EVENT, "MACEVENT: %s, status %d, reason %d\n",
+			event_name, (int)status, (int)reason);
 		break;
 
-	case WLC_E_TRACE:
-		{
-			static u32 seqnum_prev;
-			msgtrace_hdr_t hdr;
-			u32 nblost;
-			char *s, *p;
-
-			buf = (unsigned char *) event_data;
-			memcpy(&hdr, buf, MSGTRACE_HDRLEN);
-
-			if (hdr.version != MSGTRACE_VERSION) {
-				DHD_ERROR(
-				    ("\nMACEVENT: %s [unsupported version --> "
-				     "dhd version:%d dongle version:%d]\n",
-				     event_name, MSGTRACE_VERSION, hdr.version)
-				);
-				/* Reset datalen to avoid display below */
-				datalen = 0;
-				break;
-			}
-
-			/* There are 2 bytes available at the end of data */
-			buf[MSGTRACE_HDRLEN + be16_to_cpu(hdr.len)] = '\0';
+	case WLC_E_TRACE: {
+		static u32 seqnum_prev;
+		msgtrace_hdr_t hdr;
+		u32 nblost;
+		char *s, *p;
 
-			if (be32_to_cpu(hdr.discarded_bytes)
-			    || be32_to_cpu(hdr.discarded_printf)) {
-				DHD_ERROR(
-				    ("\nWLC_E_TRACE: [Discarded traces in dongle -->"
-				     "discarded_bytes %d discarded_printf %d]\n",
-				     be32_to_cpu(hdr.discarded_bytes),
-				     be32_to_cpu(hdr.discarded_printf)));
-			}
-
-			nblost = be32_to_cpu(hdr.seqnum) - seqnum_prev - 1;
-			if (nblost > 0) {
-				DHD_ERROR(
-				    ("\nWLC_E_TRACE: [Event lost --> seqnum %d nblost %d\n",
-				     be32_to_cpu(hdr.seqnum), nblost));
-			}
-			seqnum_prev = be32_to_cpu(hdr.seqnum);
-
-			/* Display the trace buffer. Advance from \n to \n to
-			 * avoid display big
-			 * printf (issue with Linux printk )
-			 */
-			p = (char *)&buf[MSGTRACE_HDRLEN];
-			while ((s = strstr(p, "\n")) != NULL) {
-				*s = '\0';
-				printk(KERN_DEBUG"%s\n", p);
-				p = s + 1;
-			}
-			printk(KERN_DEBUG "%s\n", p);
+		buf = (unsigned char *) event_data;
+		memcpy(&hdr, buf, MSGTRACE_HDRLEN);
 
+		if (hdr.version != MSGTRACE_VERSION) {
+			dhd_dbg(ERROR,
+				"MACEVENT: %s [unsupported version --> dhd version:%d dongle version:%d]\n",
+				event_name, MSGTRACE_VERSION, hdr.version);
 			/* Reset datalen to avoid display below */
 			datalen = 0;
+			break;
+		}
+
+		/* There are 2 bytes available at the end of data */
+		buf[MSGTRACE_HDRLEN + be16_to_cpu(hdr.len)] = '\0';
+
+		if (be32_to_cpu(hdr.discarded_bytes) ||
+		    be32_to_cpu(hdr.discarded_printf)) {
+			dhd_dbg(ERROR,
+				"WLC_E_TRACE: [Discarded traces in dongle --> discarded_bytes %d discarded_printf %d]\n",
+				be32_to_cpu(hdr.discarded_bytes),
+				be32_to_cpu(hdr.discarded_printf));
 		}
+
+		nblost = be32_to_cpu(hdr.seqnum) - seqnum_prev - 1;
+		if (nblost > 0) {
+			dhd_dbg(ERROR,
+				"WLC_E_TRACE: [Event lost --> seqnum %d nblost %d\n",
+				be32_to_cpu(hdr.seqnum), nblost);
+		}
+		seqnum_prev = be32_to_cpu(hdr.seqnum);
+
+		/* Display the trace buffer. Advance from \n to \n to
+		 * avoid display big
+		 * printf (issue with Linux printk )
+		 */
+		p = (char *)&buf[MSGTRACE_HDRLEN];
+		while ((s = strstr(p, "\n")) != NULL) {
+			*s = '\0';
+			printk(KERN_DEBUG "%s\n", p);
+			p = s + 1;
+		}
+		printk(KERN_DEBUG "%s\n", p);
+
+		/* Reset datalen to avoid display below */
+		datalen = 0;
 		break;
+	}
 
 	case WLC_E_RSSI:
-		DHD_EVENT(("MACEVENT: %s %d\n", event_name,
-			   be32_to_cpu(*((int *)event_data))));
+		dhd_dbg(EVENT, "MACEVENT: %s %d\n", event_name,
+			be32_to_cpu(*((int *)event_data)));
 		break;
 
 	default:
-		DHD_EVENT(("MACEVENT: %s %d, MAC %s, status %d, reason %d, "
-			"auth %d\n", event_name, event_type, eabuf,
-			(int)status, (int)reason, (int)auth_type));
+		dhd_dbg(EVENT,
+			"MACEVENT: %s %d, MAC %s, status %d, reason %d, auth %d\n",
+			event_name, event_type, eabuf,
+			(int)status, (int)reason, (int)auth_type);
 		break;
 	}
 
 	/* show any appended data */
-	if (datalen) {
-		buf = (unsigned char *) event_data;
-		DHD_EVENT((" data (%d) : ", datalen));
-		for (i = 0; i < datalen; i++)
-			DHD_EVENT((" 0x%02x ", *buf++));
-		DHD_EVENT(("\n"));
-	}
+	if (datalen && (dhd_msg_level & DHD_ERROR_VAL))
+		print_hex_dump_bytes("Event data: ", DUMP_PREFIX_OFFSET,
+				     event_data, datalen);
 }
 #endif				/* SHOW_EVENTS */
 
@@ -816,14 +813,14 @@ wl_host_event(struct dhd_info *dhd, int *ifidx, void *pktdata,
 	int evlen;
 
 	if (memcmp(BRCM_OUI, &pvt_data->bcm_hdr.oui[0], DOT11_OUI_LEN)) {
-		DHD_ERROR(("%s: mismatched OUI, bailing\n", __func__));
+		dhd_dbg(ERROR, "%s: mismatched OUI, bailing\n", __func__);
 		return -EBADE;
 	}
 
 	/* BRCM event pkt may be unaligned - use xxx_ua to load user_subtype. */
 	if (get_unaligned_be16(&pvt_data->bcm_hdr.usr_subtype) !=
 	    BCMILCP_BCM_SUBTYPE_EVENT) {
-		DHD_ERROR(("%s: mismatched subtype, bailing\n", __func__));
+		dhd_dbg(ERROR, "%s: mismatched subtype, bailing\n", __func__);
 		return -EBADE;
 	}
 
@@ -839,32 +836,31 @@ wl_host_event(struct dhd_info *dhd, int *ifidx, void *pktdata,
 	evlen = get_unaligned_be32(&event->datalen) + sizeof(bcm_event_t);
 
 	switch (type) {
-	case WLC_E_IF:
-		{
-			dhd_if_event_t *ifevent = (dhd_if_event_t *) event_data;
-			DHD_TRACE(("%s: if event\n", __func__));
-
-			if (ifevent->ifidx > 0 &&
-				 ifevent->ifidx < DHD_MAX_IFS) {
-				if (ifevent->action == WLC_E_IF_ADD)
-					dhd_add_if(dhd, ifevent->ifidx,
-						   NULL, event->ifname,
-						   pvt_data->eth.h_dest,
-						   ifevent->flags,
-						   ifevent->bssidx);
-				else
-					dhd_del_if(dhd, ifevent->ifidx);
-			} else {
-				DHD_ERROR(("%s: Invalid ifidx %d for %s\n",
-					   __func__, ifevent->ifidx,
-					   event->ifname));
-			}
+	case WLC_E_IF: {
+		dhd_if_event_t *ifevent = (dhd_if_event_t *) event_data;
+		dhd_dbg(TRACE, "%s: if event\n", __func__);
+
+		if (ifevent->ifidx > 0 &&
+		    ifevent->ifidx < DHD_MAX_IFS) {
+			if (ifevent->action == WLC_E_IF_ADD)
+				dhd_add_if(dhd, ifevent->ifidx,
+					   NULL, event->ifname,
+					   pvt_data->eth.h_dest,
+					   ifevent->flags,
+					   ifevent->bssidx);
+			else
+				dhd_del_if(dhd, ifevent->ifidx);
+		} else {
+			dhd_dbg(ERROR, "%s: Invalid ifidx %d for %s\n",
+				__func__, ifevent->ifidx,
+				event->ifname);
 		}
 		/* send up the if event: btamp user needs it */
 		*ifidx = dhd_ifname2idx(dhd, event->ifname);
 		/* push up to external supp/auth */
 		dhd_event(dhd, (char *)pvt_data, evlen, *ifidx);
 		break;
+	}
 
 #ifdef P2P
 	case WLC_E_NDIS_LINK:
@@ -883,15 +879,16 @@ wl_host_event(struct dhd_info *dhd, int *ifidx, void *pktdata,
 		*ifidx = dhd_ifname2idx(dhd, event->ifname);
 		/* push up to external supp/auth */
 		dhd_event(dhd, (char *)pvt_data, evlen, *ifidx);
-		DHD_TRACE(("%s: MAC event %d, flags %x, status %x\n",
-			   __func__, type, flags, status));
+		dhd_dbg(TRACE, "%s: MAC event %d, flags %x, status %x\n",
+			__func__, type, flags, status);
 
 		/* put it back to WLC_E_NDIS_LINK */
 		if (type == WLC_E_NDIS_LINK) {
 			u32 temp;
 
 			temp = get_unaligned_be32(&event->event_type);
-			DHD_TRACE(("Converted to WLC_E_LINK type %d\n", temp));
+			dhd_dbg(TRACE, "Converted to WLC_E_LINK type %d\n",
+				temp);
 
 			temp = be32_to_cpu(WLC_E_NDIS_LINK);
 			memcpy((void *)(&pvt_data->event.event_type), &temp,
@@ -912,12 +909,12 @@ static int wl_pattern_atoh(char *src, char *dst)
 {
 	int i;
 	if (strncmp(src, "0x", 2) != 0 && strncmp(src, "0X", 2) != 0) {
-		DHD_ERROR(("Mask invalid format. Needs to start with 0x\n"));
+		dhd_dbg(ERROR, "Mask invalid format. Needs to start with 0x\n");
 		return -1;
 	}
 	src = src + 2;		/* Skip past 0x */
 	if (strlen(src) % 2 != 0) {
-		DHD_ERROR(("Mask invalid format. Length must be even.\n"));
+		dhd_dbg(ERROR, "Mask invalid format. Length must be even.\n");
 		return -1;
 	}
 	for (i = 0; *src != '\0'; i++) {
@@ -947,7 +944,7 @@ dhd_pktfilter_offload_enable(dhd_pub_t *dhd, char *arg, int enable,
 
 	arg_save = kmalloc(strlen(arg) + 1, GFP_ATOMIC);
 	if (!arg_save) {
-		DHD_ERROR(("%s: kmalloc failed\n", __func__));
+		dhd_dbg(ERROR, "%s: kmalloc failed\n", __func__);
 		goto fail;
 	}
 	arg_org = arg_save;
@@ -957,7 +954,7 @@ dhd_pktfilter_offload_enable(dhd_pub_t *dhd, char *arg, int enable,
 
 	i = 0;
 	if (NULL == argv[i]) {
-		DHD_ERROR(("No args provided\n"));
+		dhd_dbg(ERROR, "No args provided\n");
 		goto fail;
 	}
 
@@ -982,20 +979,20 @@ dhd_pktfilter_offload_enable(dhd_pub_t *dhd, char *arg, int enable,
 	rc = dhdcdc_set_ioctl(dhd, 0, WLC_SET_VAR, buf, buf_len);
 	rc = rc >= 0 ? 0 : rc;
 	if (rc)
-		DHD_TRACE(("%s: failed to add pktfilter %s, retcode = %d\n",
-			   __func__, arg, rc));
+		dhd_dbg(TRACE, "%s: failed to add pktfilter %s, retcode = %d\n",
+			__func__, arg, rc);
 	else
-		DHD_TRACE(("%s: successfully added pktfilter %s\n",
-			   __func__, arg));
+		dhd_dbg(TRACE, "%s: successfully added pktfilter %s\n",
+			__func__, arg);
 
-	/* Contorl the master mode */
+	/* Control the master mode */
 	bcm_mkiovar("pkt_filter_mode", (char *)&master_mode, 4, buf,
 		    sizeof(buf));
 	rc = dhdcdc_set_ioctl(dhd, 0, WLC_SET_VAR, buf, sizeof(buf));
 	rc = rc >= 0 ? 0 : rc;
 	if (rc)
-		DHD_TRACE(("%s: failed to add pktfilter %s, retcode = %d\n",
-			   __func__, arg, rc));
+		dhd_dbg(TRACE, "%s: failed to add pktfilter %s, retcode = %d\n",
+			__func__, arg, rc);
 
 fail:
 	kfree(arg_org);
@@ -1018,7 +1015,7 @@ void dhd_pktfilter_offload_set(dhd_pub_t *dhd, char *arg)
 
 	arg_save = kmalloc(strlen(arg) + 1, GFP_ATOMIC);
 	if (!arg_save) {
-		DHD_ERROR(("%s: kmalloc failed\n", __func__));
+		dhd_dbg(ERROR, "%s: kmalloc failed\n", __func__);
 		goto fail;
 	}
 
@@ -1026,15 +1023,15 @@ void dhd_pktfilter_offload_set(dhd_pub_t *dhd, char *arg)
 
 	buf = kmalloc(BUF_SIZE, GFP_ATOMIC);
 	if (!buf) {
-		DHD_ERROR(("%s: kmalloc failed\n", __func__));
+		dhd_dbg(ERROR, "%s: kmalloc failed\n", __func__);
 		goto fail;
 	}
 
 	memcpy(arg_save, arg, strlen(arg) + 1);
 
 	if (strlen(arg) > BUF_SIZE) {
-		DHD_ERROR(("Not enough buffer %d < %d\n", (int)strlen(arg),
-			   (int)sizeof(buf)));
+		dhd_dbg(ERROR, "Not enough buffer %d < %d\n",
+			(int)strlen(arg), (int)sizeof(buf));
 		goto fail;
 	}
 
@@ -1044,7 +1041,7 @@ void dhd_pktfilter_offload_set(dhd_pub_t *dhd, char *arg)
 
 	i = 0;
 	if (NULL == argv[i]) {
-		DHD_ERROR(("No args provided\n"));
+		dhd_dbg(ERROR, "No args provided\n");
 		goto fail;
 	}
 
@@ -1060,7 +1057,7 @@ void dhd_pktfilter_offload_set(dhd_pub_t *dhd, char *arg)
 	pkt_filter.id = simple_strtoul(argv[i], NULL, 0);
 
 	if (NULL == argv[++i]) {
-		DHD_ERROR(("Polarity not provided\n"));
+		dhd_dbg(ERROR, "Polarity not provided\n");
 		goto fail;
 	}
 
@@ -1068,7 +1065,7 @@ void dhd_pktfilter_offload_set(dhd_pub_t *dhd, char *arg)
 	pkt_filter.negate_match = simple_strtoul(argv[i], NULL, 0);
 
 	if (NULL == argv[++i]) {
-		DHD_ERROR(("Filter type not provided\n"));
+		dhd_dbg(ERROR, "Filter type not provided\n");
 		goto fail;
 	}
 
@@ -1076,7 +1073,7 @@ void dhd_pktfilter_offload_set(dhd_pub_t *dhd, char *arg)
 	pkt_filter.type = simple_strtoul(argv[i], NULL, 0);
 
 	if (NULL == argv[++i]) {
-		DHD_ERROR(("Offset not provided\n"));
+		dhd_dbg(ERROR, "Offset not provided\n");
 		goto fail;
 	}
 
@@ -1084,7 +1081,7 @@ void dhd_pktfilter_offload_set(dhd_pub_t *dhd, char *arg)
 	pkt_filter.u.pattern.offset = simple_strtoul(argv[i], NULL, 0);
 
 	if (NULL == argv[++i]) {
-		DHD_ERROR(("Bitmask not provided\n"));
+		dhd_dbg(ERROR, "Bitmask not provided\n");
 		goto fail;
 	}
 
@@ -1094,7 +1091,7 @@ void dhd_pktfilter_offload_set(dhd_pub_t *dhd, char *arg)
 		   (argv[i], (char *)pkt_filterp->u.pattern.mask_and_pattern);
 
 	if (NULL == argv[++i]) {
-		DHD_ERROR(("Pattern not provided\n"));
+		dhd_dbg(ERROR, "Pattern not provided\n");
 		goto fail;
 	}
 
@@ -1105,7 +1102,7 @@ void dhd_pktfilter_offload_set(dhd_pub_t *dhd, char *arg)
 				   mask_and_pattern[mask_size]);
 
 	if (mask_size != pattern_size) {
-		DHD_ERROR(("Mask and pattern not the same size\n"));
+		dhd_dbg(ERROR, "Mask and pattern not the same size\n");
 		goto fail;
 	}
 
@@ -1126,11 +1123,11 @@ void dhd_pktfilter_offload_set(dhd_pub_t *dhd, char *arg)
 	rc = rc >= 0 ? 0 : rc;
 
 	if (rc)
-		DHD_TRACE(("%s: failed to add pktfilter %s, retcode = %d\n",
-			   __func__, arg, rc));
+		dhd_dbg(TRACE, "%s: failed to add pktfilter %s, retcode = %d\n",
+			__func__, arg, rc);
 	else
-		DHD_TRACE(("%s: successfully added pktfilter %s\n",
-			   __func__, arg));
+		dhd_dbg(TRACE, "%s: successfully added pktfilter %s\n",
+			__func__, arg);
 
 fail:
 	kfree(arg_org);
@@ -1147,11 +1144,13 @@ void dhd_arp_offload_set(dhd_pub_t *dhd, int arp_mode)
 	retcode = dhdcdc_set_ioctl(dhd, 0, WLC_SET_VAR, iovbuf, sizeof(iovbuf));
 	retcode = retcode >= 0 ? 0 : retcode;
 	if (retcode)
-		DHD_TRACE(("%s: failed to set ARP offload mode to 0x%x, "
-			"retcode = %d\n", __func__, arp_mode, retcode));
+		dhd_dbg(TRACE,
+			"%s: failed to set ARP offload mode to 0x%x, retcode = %d\n",
+			__func__, arp_mode, retcode);
 	else
-		DHD_TRACE(("%s: successfully set ARP offload mode to 0x%x\n",
-			   __func__, arp_mode));
+		dhd_dbg(TRACE,
+			"%s: successfully set ARP offload mode to 0x%x\n",
+			__func__, arp_mode);
 }
 
 void dhd_arp_offload_enable(dhd_pub_t *dhd, int arp_enable)
@@ -1163,11 +1162,12 @@ void dhd_arp_offload_enable(dhd_pub_t *dhd, int arp_enable)
 	retcode = dhdcdc_set_ioctl(dhd, 0, WLC_SET_VAR, iovbuf, sizeof(iovbuf));
 	retcode = retcode >= 0 ? 0 : retcode;
 	if (retcode)
-		DHD_TRACE(("%s: failed to enabe ARP offload to %d, "
-			"retcode = %d\n", __func__, arp_enable, retcode));
+		dhd_dbg(TRACE,
+			"%s: failed to enable ARP offload to %d, retcode = %d\n",
+			__func__, arp_enable, retcode);
 	else
-		DHD_TRACE(("%s: successfully enabed ARP offload to %d\n",
-			   __func__, arp_enable));
+		dhd_dbg(TRACE, "%s: successfully enabled ARP offload to %d\n",
+			__func__, arp_enable);
 }
 
 int dhd_preinit_ioctls(dhd_pub_t *dhd)
@@ -1202,8 +1202,8 @@ int dhd_preinit_ioctls(dhd_pub_t *dhd)
 			    buf, sizeof(buf));
 		ret = dhdcdc_set_ioctl(dhd, 0, WLC_SET_VAR, buf, sizeof(buf));
 		if (ret < 0) {
-			DHD_ERROR(("%s: can't set MAC address , error=%d\n",
-				   __func__, ret));
+			dhd_dbg(ERROR, "%s: can't set MAC address , error=%d\n",
+				__func__, ret);
 		} else
 			memcpy(dhd->mac.octet, (void *)&ea_addr,
 			       ETH_ALEN);
@@ -1215,8 +1215,8 @@ int dhd_preinit_ioctls(dhd_pub_t *dhd)
 		if (dhdcdc_set_ioctl(dhd, 0, WLC_SET_COUNTRY,
 				     dhd->country_code,
 				     sizeof(dhd->country_code)) < 0) {
-			DHD_ERROR(("%s: country code setting failed\n",
-				   __func__));
+			dhd_dbg(ERROR, "%s: country code setting failed\n",
+				__func__);
 		}
 	}
 
@@ -1227,7 +1227,7 @@ int dhd_preinit_ioctls(dhd_pub_t *dhd)
 	dhdcdc_query_ioctl(dhd, 0, WLC_GET_VAR, buf, sizeof(buf));
 	strsep(&ptr, "\n");
 	/* Print fw version info */
-	DHD_ERROR(("Firmware version = %s\n", buf));
+	dhd_dbg(ERROR, "Firmware version = %s\n", buf);
 
 	/* Set PowerSave mode */
 	dhdcdc_set_ioctl(dhd, 0, WLC_SET_PM, (char *)&power_mode,
@@ -1314,13 +1314,13 @@ iscan_buf_t *dhd_iscan_allocate_buf(dhd_pub_t *dhd, iscan_buf_t **iscanbuf)
 	iscanbuf_alloc->next = NULL;
 	iscanbuf_head = *iscanbuf;
 
-	DHD_ISCAN(("%s: addr of allocated node = 0x%X"
-		   "addr of iscanbuf_head = 0x%X dhd = 0x%X\n",
-		   __func__, iscanbuf_alloc, iscanbuf_head, dhd));
+	dhd_dbg(ISCAN,
+		"%s: addr of allocated node = 0x%X addr of iscanbuf_head = 0x%X dhd = 0x%X\n",
+		__func__, iscanbuf_alloc, iscanbuf_head, dhd);
 
 	if (iscanbuf_head == NULL) {
 		*iscanbuf = iscanbuf_alloc;
-		DHD_ISCAN(("%s: Head is allocated\n", __func__));
+		dhd_dbg(ISCAN, "%s: Head is allocated\n", __func__);
 		goto fail;
 	}
 
@@ -1403,9 +1403,9 @@ int dhd_iscan_print_cache(iscan_buf_t *iscan_skip)
 			break;
 
 		if (results->version != WL_BSS_INFO_VERSION) {
-			DHD_ISCAN(("%s: results->version %d != "
-				"WL_BSS_INFO_VERSION\n",
-				__func__, results->version));
+			dhd_dbg(ISCAN,
+				"%s: results->version %d != WL_BSS_INFO_VERSION\n",
+				__func__, results->version);
 			goto done;
 		}
 
@@ -1414,11 +1414,9 @@ int dhd_iscan_print_cache(iscan_buf_t *iscan_skip)
 			if (!bi)
 				break;
 
-			DHD_ISCAN(("%s[%2.2d:%2.2d] %X:%X:%X:%X:%X:%X\n",
-				   iscan_cur != iscan_skip ? "BSS" : "bss", l,
-				   i, bi->BSSID.octet[0], bi->BSSID.octet[1],
-				   bi->BSSID.octet[2], bi->BSSID.octet[3],
-				   bi->BSSID.octet[4], bi->BSSID.octet[5]));
+			dhd_dbg(ISCAN, "%s[%2.2d:%2.2d] %pM\n",
+				iscan_cur != iscan_skip ? "BSS" : "bss", l, i,
+				bi->BSSID.octet);
 
 			bi = (wl_bss_info_t *)((unsigned long)bi + bi->length);
 		}
@@ -1446,9 +1444,7 @@ int dhd_iscan_delete_bss(void *dhdp, void *addr, iscan_buf_t *iscan_skip)
 	unsigned char *s_addr = addr;
 
 	dhd_iscan_lock();
-	DHD_ISCAN(("%s: BSS to remove %X:%X:%X:%X:%X:%X\n",
-		   __func__, s_addr[0], s_addr[1], s_addr[2],
-		   s_addr[3], s_addr[4], s_addr[5]));
+	dhd_dbg(ISCAN, "%s: BSS to remove %pM\n", __func__, s_addr);
 
 	iscan_cur = dhd_iscan_result_buf();
 
@@ -1463,9 +1459,9 @@ int dhd_iscan_delete_bss(void *dhdp, void *addr, iscan_buf_t *iscan_skip)
 				break;
 
 			if (results->version != WL_BSS_INFO_VERSION) {
-				DHD_ERROR(("%s: results->version %d != "
-					"WL_BSS_INFO_VERSION\n",
-					__func__, results->version));
+				dhd_dbg(ERROR,
+					"%s: results->version %d != WL_BSS_INFO_VERSION\n",
+					__func__, results->version);
 				goto done;
 			}
 
@@ -1474,14 +1470,11 @@ int dhd_iscan_delete_bss(void *dhdp, void *addr, iscan_buf_t *iscan_skip)
 				if (!bi)
 					break;
 
-				if (!memcmp
-				    (bi->BSSID.octet, addr, ETH_ALEN)) {
-					DHD_ISCAN(("%s: Del BSS[%2.2d:%2.2d] "
-					"%X:%X:%X:%X:%X:%X\n",
-					__func__, l, i, bi->BSSID.octet[0],
-					bi->BSSID.octet[1], bi->BSSID.octet[2],
-					bi->BSSID.octet[3], bi->BSSID.octet[4],
-					bi->BSSID.octet[5]));
+				if (!memcmp(bi->BSSID.octet, addr, ETH_ALEN)) {
+					dhd_dbg(ISCAN,
+						"%s: Del BSS[%2.2d:%2.2d] %pM\n",
+						__func__, l, i,
+						bi->BSSID.octet);
 
 					bi_new = bi;
 					bi = (wl_bss_info_t *)((unsigned long)
@@ -1498,14 +1491,10 @@ int dhd_iscan_delete_bss(void *dhdp, void *addr, iscan_buf_t *iscan_skip)
 
 					for (j = i; j < results->count; j++) {
 						if (bi && bi_new) {
-							DHD_ISCAN(("%s: Moved up BSS[%2.2d:%2.2d]" "%X:%X:%X:%X:%X:%X\n",
-							__func__, l, j,
-							bi->BSSID.octet[0],
-							bi->BSSID.octet[1],
-							bi->BSSID.octet[2],
-							bi->BSSID.octet[3],
-							bi->BSSID.octet[4],
-							bi->BSSID.octet[5]));
+							dhd_dbg(ISCAN,
+								"%s: Moved up BSS[%2.2d:%2.2d] %pM\n",
+								__func__, l, j,
+								bi->BSSID.octet);
 
 							bi_next =
 							    (wl_bss_info_t *)((unsigned long)bi +
@@ -1551,7 +1540,7 @@ int dhd_iscan_remove_duplicates(void *dhdp, iscan_buf_t *iscan_cur)
 
 	dhd_iscan_lock();
 
-	DHD_ISCAN(("%s: Scan cache before delete\n", __func__));
+	dhd_dbg(ISCAN, "%s: Scan cache before delete\n", __func__);
 	dhd_iscan_print_cache(iscan_cur);
 
 	if (!iscan_cur)
@@ -1566,8 +1555,9 @@ int dhd_iscan_remove_duplicates(void *dhdp, iscan_buf_t *iscan_cur)
 		goto done;
 
 	if (results->version != WL_BSS_INFO_VERSION) {
-		DHD_ERROR(("%s: results->version %d != WL_BSS_INFO_VERSION\n",
-			   __func__, results->version));
+		dhd_dbg(ERROR,
+			"%s: results->version %d != WL_BSS_INFO_VERSION\n",
+			__func__, results->version);
 		goto done;
 	}
 
@@ -1576,11 +1566,8 @@ int dhd_iscan_remove_duplicates(void *dhdp, iscan_buf_t *iscan_cur)
 		if (!bi)
 			break;
 
-		DHD_ISCAN(("%s: Find dups for BSS[%2.2d] %X:%X:%X:%X:%X:%X\n",
-			   __func__, i, bi->BSSID.octet[0],
-			   bi->BSSID.octet[1], bi->BSSID.octet[2],
-			   bi->BSSID.octet[3], bi->BSSID.octet[4],
-			   bi->BSSID.octet[5]));
+		dhd_dbg(ISCAN, "%s: Find dups for BSS[%2.2d] %pM\n",
+			__func__, i, bi->BSSID.octet);
 
 		dhd_iscan_delete_bss(dhdp, bi->BSSID.octet, iscan_cur);
 
@@ -1588,7 +1575,7 @@ int dhd_iscan_remove_duplicates(void *dhdp, iscan_buf_t *iscan_cur)
 	}
 
 done:
-	DHD_ISCAN(("%s: Scan cache after delete\n", __func__));
+	dhd_dbg(ISCAN, "%s: Scan cache after delete\n", __func__);
 	dhd_iscan_print_cache(iscan_cur);
 	dhd_iscan_unlock();
 	return 0;
@@ -1642,7 +1629,7 @@ static int dhd_iscan_get_partial_result(void *dhdp, uint *scan_count)
 
 	iscan_cur = dhd_iscan_allocate_buf(dhd, &iscan_chain);
 	if (!iscan_cur) {
-		DHD_ERROR(("%s: Failed to allocate node\n", __func__));
+		dhd_dbg(ERROR, "%s: Failed to allocate node\n", __func__);
 		dhd_iscan_free_buf(dhdp, 0);
 		dhd_iscan_request(dhdp, WL_SCAN_ACTION_ABORT);
 		goto fail;
@@ -1700,15 +1687,16 @@ int dhd_pno_clean(dhd_pub_t *dhd)
 			ret = dhdcdc_set_ioctl(dhd, 0, WLC_SET_VAR, iovbuf,
 					iov_len);
 			if (ret < 0) {
-				DHD_ERROR(("%s failed code %d\n", __func__,
-					   ret));
+				dhd_dbg(ERROR, "%s failed code %d\n",
+					__func__, ret);
 			}
 		} else {
 			ret = -1;
-			DHD_ERROR(("%s failed code %d\n", __func__, iov_len));
+			dhd_dbg(ERROR, "%s failed code %d\n",
+				__func__, iov_len);
 		}
 	} else
-		DHD_ERROR(("%s failed code %d\n", __func__, ret));
+		dhd_dbg(ERROR, "%s failed code %d\n", __func__, ret);
 
 	return ret;
 }
@@ -1719,7 +1707,7 @@ int dhd_pno_enable(dhd_pub_t *dhd, int pfn_enabled)
 	int ret = -1;
 
 	if ((!dhd) && ((pfn_enabled != 0) || (pfn_enabled != 1))) {
-		DHD_ERROR(("%s error exit\n", __func__));
+		dhd_dbg(ERROR, "%s error exit\n", __func__);
 		return ret;
 	}
 
@@ -1730,15 +1718,16 @@ int dhd_pno_enable(dhd_pub_t *dhd, int pfn_enabled)
 		ret = dhdcdc_set_ioctl(dhd, 0, WLC_SET_VAR, iovbuf,
 				sizeof(iovbuf));
 		if (ret < 0) {
-			DHD_ERROR(("%s failed for error=%d\n", __func__, ret));
+			dhd_dbg(ERROR, "%s failed for error=%d\n",
+				__func__, ret);
 			return ret;
 		} else {
 			dhd->pno_enable = pfn_enabled;
-			DHD_TRACE(("%s set pno as %d\n", __func__,
-				   dhd->pno_enable));
+			dhd_dbg(TRACE, "%s set pno as %d\n",
+				__func__, dhd->pno_enable);
 		}
 	} else
-		DHD_ERROR(("%s failed err=%d\n", __func__, ret));
+		dhd_dbg(ERROR, "%s failed err=%d\n", __func__, ret);
 
 	return ret;
 }
@@ -1753,18 +1742,19 @@ dhd_pno_set(dhd_pub_t *dhd, wlc_ssid_t *ssids_local, int nssid, unsigned char sc
 	wl_pfn_param_t pfn_param;
 	wl_pfn_t pfn_element;
 
-	DHD_TRACE(("%s nssid=%d nchan=%d\n", __func__, nssid, scan_fr));
+	dhd_dbg(TRACE, "%s nssid=%d nchan=%d\n", __func__, nssid, scan_fr);
 
 	if ((!dhd) && (!ssids_local)) {
-		DHD_ERROR(("%s error exit\n", __func__));
+		dhd_dbg(ERROR, "%s error exit\n", __func__);
 		err = -1;
 	}
 
 	/* Check for broadcast ssid */
 	for (k = 0; k < nssid; k++) {
 		if (!ssids_local[k].SSID_len) {
-			DHD_ERROR(("%d: Broadcast SSID is ilegal for PNO "
-				"setting\n", k));
+			dhd_dbg(ERROR,
+				"%d: Broadcast SSID is invalid for PNO setting\n",
+				k);
 			return err;
 		}
 	}
@@ -1773,9 +1763,9 @@ dhd_pno_set(dhd_pub_t *dhd, wlc_ssid_t *ssids_local, int nssid, unsigned char sc
 	{
 		int j;
 		for (j = 0; j < nssid; j++) {
-			DHD_ERROR(("%d: scan  for  %s size =%d\n", j,
-				   ssids_local[j].SSID,
-				   ssids_local[j].SSID_len));
+			dhd_dbg(ERROR, "%d: scan  for  %s size =%d\n",
+				j, ssids_local[j].SSID,
+				ssids_local[j].SSID_len);
 		}
 	}
 #endif				/* PNO_DUMP */
@@ -1783,7 +1773,7 @@ dhd_pno_set(dhd_pub_t *dhd, wlc_ssid_t *ssids_local, int nssid, unsigned char sc
 	/* clean up everything */
 	err = dhd_pno_clean(dhd);
 	if (err < 0) {
-		DHD_ERROR(("%s failed error=%d\n", __func__, err));
+		dhd_dbg(ERROR, "%s failed error=%d\n", __func__, err);
 		return err;
 	}
 	memset(&pfn_param, 0, sizeof(pfn_param));
@@ -1820,12 +1810,12 @@ dhd_pno_set(dhd_pub_t *dhd, wlc_ssid_t *ssids_local, int nssid, unsigned char sc
 			err = dhdcdc_set_ioctl(dhd, 0, WLC_SET_VAR, iovbuf,
 					sizeof(iovbuf));
 			if (err < 0) {
-				DHD_ERROR(("%s failed for i=%d error=%d\n",
-					   __func__, i, err));
+				dhd_dbg(ERROR, "%s failed for i=%d error=%d\n",
+					__func__, i, err);
 				return err;
 			}
 		} else
-			DHD_ERROR(("%s failed err=%d\n", __func__, err));
+			dhd_dbg(ERROR, "%s failed err=%d\n", __func__, err);
 	}
 
 	/* Enable PNO */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_dbg.h b/drivers/staging/brcm80211/brcmfmac/dhd_dbg.h
index 0817f13..dbdfc12 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_dbg.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_dbg.h
@@ -19,33 +19,19 @@
 
 #if defined(DHD_DEBUG)
 
-#define DHD_ERROR(args)	       \
-	do {if ((dhd_msg_level & DHD_ERROR_VAL) && (net_ratelimit())) \
-		printk args; } while (0)
-#define DHD_TRACE(args)		do {if (dhd_msg_level & DHD_TRACE_VAL)	\
-					printk args; } while (0)
-#define DHD_INFO(args)		do {if (dhd_msg_level & DHD_INFO_VAL)	\
-					printk args; } while (0)
-#define DHD_DATA(args)		do {if (dhd_msg_level & DHD_DATA_VAL)	\
-					printk args; } while (0)
-#define DHD_CTL(args)		do {if (dhd_msg_level & DHD_CTL_VAL)	\
-					printk args; } while (0)
-#define DHD_TIMER(args)		do {if (dhd_msg_level & DHD_TIMER_VAL)	\
-					printk args; } while (0)
-#define DHD_HDRS(args)		do {if (dhd_msg_level & DHD_HDRS_VAL)	\
-					printk args; } while (0)
-#define DHD_BYTES(args)		do {if (dhd_msg_level & DHD_BYTES_VAL)	\
-					printk args; } while (0)
-#define DHD_INTR(args)		do {if (dhd_msg_level & DHD_INTR_VAL)	\
-					printk args; } while (0)
-#define DHD_GLOM(args)		do {if (dhd_msg_level & DHD_GLOM_VAL)	\
-					printk args; } while (0)
-#define DHD_EVENT(args)		do {if (dhd_msg_level & DHD_EVENT_VAL)	\
-					printk args; } while (0)
-#define DHD_BTA(args)		do {if (dhd_msg_level & DHD_BTA_VAL)	\
-					printk args; } while (0)
-#define DHD_ISCAN(args)		do {if (dhd_msg_level & DHD_ISCAN_VAL)	\
-					printk args; } while (0)
+#define dhd_dbg(level, fmt, ...)					\
+do {									\
+	if (DHD_ERROR_VAL == DHD_##level##_VAL) {			\
+		if (dhd_msg_level & DHD_##level##_VAL) {		\
+			if (net_ratelimit())				\
+				printk(KERN_DEBUG fmt, ##__VA_ARGS__);	\
+		}							\
+	} else {							\
+		if (dhd_msg_level & DHD_##level##_VAL) {		\
+			printk(KERN_DEBUG fmt, ##__VA_ARGS__);		\
+		}							\
+	}								\
+} while (0)
 
 #define DHD_ERROR_ON()		(dhd_msg_level & DHD_ERROR_VAL)
 #define DHD_TRACE_ON()		(dhd_msg_level & DHD_TRACE_VAL)
@@ -63,19 +49,8 @@
 
 #else	/* (defined BCMDBG) || (defined DHD_DEBUG) */
 
-#define DHD_ERROR(args)  do {if (net_ratelimit()) printk args; } while (0)
-#define DHD_TRACE(args)
-#define DHD_INFO(args)
-#define DHD_DATA(args)
-#define DHD_CTL(args)
-#define DHD_TIMER(args)
-#define DHD_HDRS(args)
-#define DHD_BYTES(args)
-#define DHD_INTR(args)
-#define DHD_GLOM(args)
-#define DHD_EVENT(args)
-#define DHD_BTA(args)
-#define DHD_ISCAN(args)
+#define dhd_dbg(level, fmt, ...)		\
+	no_printk(fmt, ##__VA_ARGS__)
 
 #define DHD_ERROR_ON()		0
 #define DHD_TRACE_ON()		0
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index f356c56..48193c7 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -131,13 +131,13 @@ static int wifi_remove(struct platform_device *pdev)
 
 static int wifi_suspend(struct platform_device *pdev, pm_message_t state)
 {
-	DHD_TRACE(("##> %s\n", __func__));
+	dhd_dbg(TRACE, "##> %s\n", __func__);
 	return 0;
 }
 
 static int wifi_resume(struct platform_device *pdev)
 {
-	DHD_TRACE(("##> %s\n", __func__));
+	dhd_dbg(TRACE, "##> %s\n", __func__);
 	return 0;
 }
 
@@ -153,13 +153,13 @@ static struct platform_driver wifi_device = {
 
 int wifi_add_dev(void)
 {
-	DHD_TRACE(("## Calling platform_driver_register\n"));
+	dhd_dbg(TRACE, "## Calling platform_driver_register\n");
 	return platform_driver_register(&wifi_device);
 }
 
 void wifi_del_dev(void)
 {
-	DHD_TRACE(("## Unregister platform_driver_register\n"));
+	dhd_dbg(TRACE, "## Unregister platform_driver_register\n");
 	platform_driver_unregister(&wifi_device);
 }
 #endif	/* defined(CUSTOMER_HW2) && defined(CONFIG_WIFI_CONTROL_FUNC) */
@@ -429,7 +429,7 @@ extern int unregister_pm_notifier(struct notifier_block *nb);
 static void dhd_set_packet_filter(int value, dhd_pub_t *dhd)
 {
 #ifdef PKT_FILTER_SUPPORT
-	DHD_TRACE(("%s: %d\n", __func__, value));
+	dhd_dbg(TRACE, "%s: %d\n", __func__, value);
 	/* 1 - Enable packet filter, only allow unicast packet to send up */
 	/* 0 - Disable packet filter */
 	if (dhd_pkt_filter_enable) {
@@ -455,15 +455,15 @@ static int dhd_set_suspend(int value, dhd_pub_t *dhd)
 	uint roamvar = 1;
 #endif				/* CUSTOMER_HW2 */
 
-	DHD_TRACE(("%s: enter, value = %d in_suspend=%d\n",
-		   __func__, value, dhd->in_suspend));
+	dhd_dbg(TRACE, "%s: enter, value = %d in_suspend=%d\n",
+		__func__, value, dhd->in_suspend);
 
 	if (dhd && dhd->up) {
 		if (value && dhd->in_suspend) {
 
 			/* Kernel suspended */
-			DHD_TRACE(("%s: force extra Suspend setting\n",
-				   __func__));
+			dhd_dbg(TRACE, "%s: force extra Suspend setting\n",
+				__func__);
 
 			dhdcdc_set_ioctl(dhd, 0, WLC_SET_PM,
 					 (char *)&power_mode,
@@ -499,8 +499,8 @@ static int dhd_set_suspend(int value, dhd_pub_t *dhd)
 		} else {
 
 			/* Kernel resumed  */
-			DHD_TRACE(("%s: Remove extra suspend setting\n",
-				   __func__));
+			dhd_dbg(TRACE, "%s: Remove extra suspend setting\n",
+				__func__);
 
 			power_mode = PM_FAST;
 			dhdcdc_set_ioctl(dhd, 0, WLC_SET_PM,
@@ -545,7 +545,7 @@ static void dhd_early_suspend(struct early_suspend *h)
 {
 	struct dhd_info *dhd = container_of(h, struct dhd_info, early_suspend);
 
-	DHD_TRACE(("%s: enter\n", __func__));
+	dhd_dbg(TRACE, "%s: enter\n", __func__);
 
 	if (dhd)
 		dhd_suspend_resume_helper(dhd, 1);
@@ -556,7 +556,7 @@ static void dhd_late_resume(struct early_suspend *h)
 {
 	struct dhd_info *dhd = container_of(h, struct dhd_info, early_suspend);
 
-	DHD_TRACE(("%s: enter\n", __func__));
+	dhd_dbg(TRACE, "%s: enter\n", __func__);
 
 	if (dhd)
 		dhd_suspend_resume_helper(dhd, 0);
@@ -649,7 +649,7 @@ int dhd_ifname2idx(dhd_info_t *dhd, char *name)
 		    && !strncmp(dhd->iflist[i]->name, name, IFNAMSIZ))
 			break;
 
-	DHD_TRACE(("%s: return idx %d for \"%s\"\n", __func__, i, name));
+	dhd_dbg(TRACE, "%s: return idx %d for \"%s\"\n", __func__, i, name);
 
 	return i;		/* default - the primary interface */
 }
@@ -661,12 +661,12 @@ char *dhd_ifname(dhd_pub_t *dhdp, int ifidx)
 	ASSERT(dhd);
 
 	if (ifidx < 0 || ifidx >= DHD_MAX_IFS) {
-		DHD_ERROR(("%s: ifidx %d out of range\n", __func__, ifidx));
+		dhd_dbg(ERROR, "%s: ifidx %d out of range\n", __func__, ifidx);
 		return "<if_bad>";
 	}
 
 	if (dhd->iflist[ifidx] == NULL) {
-		DHD_ERROR(("%s: null i/f %d\n", __func__, ifidx));
+		dhd_dbg(ERROR, "%s: null i/f %d\n", __func__, ifidx);
 		return "<if_null>";
 	}
 
@@ -699,8 +699,8 @@ static void _dhd_set_multicast_list(dhd_info_t *dhd, int ifidx)
 	buflen = sizeof("mcast_list") + sizeof(cnt) + (cnt * ETH_ALEN);
 	bufp = buf = kmalloc(buflen, GFP_ATOMIC);
 	if (!bufp) {
-		DHD_ERROR(("%s: out of memory for mcast_list, cnt %d\n",
-			   dhd_ifname(&dhd->pub, ifidx), cnt));
+		dhd_dbg(ERROR, "%s: out of memory for mcast_list, cnt %d\n",
+			dhd_ifname(&dhd->pub, ifidx), cnt);
 		return;
 	}
 
@@ -727,8 +727,8 @@ static void _dhd_set_multicast_list(dhd_info_t *dhd, int ifidx)
 
 	ret = dhd_prot_ioctl(&dhd->pub, ifidx, &ioc, ioc.buf, ioc.len);
 	if (ret < 0) {
-		DHD_ERROR(("%s: set mcast_list failed, cnt %d\n",
-			   dhd_ifname(&dhd->pub, ifidx), cnt));
+		dhd_dbg(ERROR, "%s: set mcast_list failed, cnt %d\n",
+			dhd_ifname(&dhd->pub, ifidx), cnt);
 		allmulti = cnt ? true : allmulti;
 	}
 
@@ -742,17 +742,18 @@ static void _dhd_set_multicast_list(dhd_info_t *dhd, int ifidx)
 	buflen = sizeof("allmulti") + sizeof(allmulti);
 	buf = kmalloc(buflen, GFP_ATOMIC);
 	if (!buf) {
-		DHD_ERROR(("%s: out of memory for allmulti\n",
-			   dhd_ifname(&dhd->pub, ifidx)));
+		dhd_dbg(ERROR, "%s: out of memory for allmulti\n",
+			dhd_ifname(&dhd->pub, ifidx));
 		return;
 	}
 	allmulti = cpu_to_le32(allmulti);
 
 	if (!bcm_mkiovar
 	    ("allmulti", (void *)&allmulti, sizeof(allmulti), buf, buflen)) {
-		DHD_ERROR(("%s: mkiovar failed for allmulti, datalen %d "
-			"buflen %u\n", dhd_ifname(&dhd->pub, ifidx),
-			(int)sizeof(allmulti), buflen));
+		dhd_dbg(ERROR,
+			"%s: mkiovar failed for allmulti, datalen %d buflen %u\n",
+			dhd_ifname(&dhd->pub, ifidx),
+			(int)sizeof(allmulti), buflen);
 		kfree(buf);
 		return;
 	}
@@ -765,9 +766,9 @@ static void _dhd_set_multicast_list(dhd_info_t *dhd, int ifidx)
 
 	ret = dhd_prot_ioctl(&dhd->pub, ifidx, &ioc, ioc.buf, ioc.len);
 	if (ret < 0) {
-		DHD_ERROR(("%s: set allmulti %d failed\n",
-			   dhd_ifname(&dhd->pub, ifidx),
-			   le32_to_cpu(allmulti)));
+		dhd_dbg(ERROR, "%s: set allmulti %d failed\n",
+			dhd_ifname(&dhd->pub, ifidx),
+			le32_to_cpu(allmulti));
 	}
 
 	kfree(buf);
@@ -786,9 +787,9 @@ static void _dhd_set_multicast_list(dhd_info_t *dhd, int ifidx)
 
 	ret = dhd_prot_ioctl(&dhd->pub, ifidx, &ioc, ioc.buf, ioc.len);
 	if (ret < 0) {
-		DHD_ERROR(("%s: set promisc %d failed\n",
-			   dhd_ifname(&dhd->pub, ifidx),
-			   le32_to_cpu(allmulti)));
+		dhd_dbg(ERROR, "%s: set promisc %d failed\n",
+			dhd_ifname(&dhd->pub, ifidx),
+			le32_to_cpu(allmulti));
 	}
 }
 
@@ -799,11 +800,11 @@ _dhd_set_mac_address(dhd_info_t *dhd, int ifidx, u8 *addr)
 	wl_ioctl_t ioc;
 	int ret;
 
-	DHD_TRACE(("%s enter\n", __func__));
+	dhd_dbg(TRACE, "%s enter\n", __func__);
 	if (!bcm_mkiovar
 	    ("cur_etheraddr", (char *)addr, ETH_ALEN, buf, 32)) {
-		DHD_ERROR(("%s: mkiovar failed for cur_etheraddr\n",
-			   dhd_ifname(&dhd->pub, ifidx)));
+		dhd_dbg(ERROR, "%s: mkiovar failed for cur_etheraddr\n",
+			dhd_ifname(&dhd->pub, ifidx));
 		return -1;
 	}
 	memset(&ioc, 0, sizeof(ioc));
@@ -814,8 +815,8 @@ _dhd_set_mac_address(dhd_info_t *dhd, int ifidx, u8 *addr)
 
 	ret = dhd_prot_ioctl(&dhd->pub, ifidx, &ioc, ioc.buf, ioc.len);
 	if (ret < 0) {
-		DHD_ERROR(("%s: set cur_etheraddr failed\n",
-			   dhd_ifname(&dhd->pub, ifidx)));
+		dhd_dbg(ERROR, "%s: set cur_etheraddr failed\n",
+			dhd_ifname(&dhd->pub, ifidx));
 	} else {
 		memcpy(dhd->iflist[ifidx]->net->dev_addr, addr, ETH_ALEN);
 	}
@@ -836,7 +837,8 @@ static void dhd_op_if(dhd_if_t *ifp)
 
 	dhd = ifp->info;
 
-	DHD_TRACE(("%s: idx %d, state %d\n", __func__, ifp->idx, ifp->state));
+	dhd_dbg(TRACE, "%s: idx %d, state %d\n",
+		__func__, ifp->idx, ifp->state);
 
 	switch (ifp->state) {
 	case WLC_E_IF_ADD:
@@ -845,9 +847,9 @@ static void dhd_op_if(dhd_if_t *ifp)
 		 * in case we missed the WLC_E_IF_DEL event.
 		 */
 		if (ifp->net != NULL) {
-			DHD_ERROR(("%s: ERROR: netdev:%s already exists, "
-			"try free & unregister\n",
-			__func__, ifp->net->name));
+			dhd_dbg(ERROR,
+				"%s: ERROR: netdev:%s already exists, try free & unregister\n",
+				__func__, ifp->net->name);
 			netif_stop_queue(ifp->net);
 			unregister_netdev(ifp->net);
 			free_netdev(ifp->net);
@@ -855,7 +857,7 @@ static void dhd_op_if(dhd_if_t *ifp)
 		/* Allocate etherdev, including space for private structure */
 		ifp->net = alloc_etherdev(sizeof(dhd));
 		if (!ifp->net) {
-			DHD_ERROR(("%s: OOM - alloc_etherdev\n", __func__));
+			dhd_dbg(ERROR, "%s: OOM - alloc_etherdev\n", __func__);
 			ret = -ENOMEM;
 		}
 		if (ret == 0) {
@@ -863,9 +865,9 @@ static void dhd_op_if(dhd_if_t *ifp)
 			memcpy(netdev_priv(ifp->net), &dhd, sizeof(dhd));
 			err = dhd_net_attach(&dhd->pub, ifp->idx);
 			if (err != 0) {
-				DHD_ERROR(("%s: dhd_net_attach failed, "
-					"err %d\n",
-					__func__, err));
+				dhd_dbg(ERROR,
+					"%s: dhd_net_attach failed, err %d\n",
+					__func__, err);
 				ret = -EOPNOTSUPP;
 			} else {
 #ifdef SOFTAP
@@ -880,17 +882,17 @@ static void dhd_op_if(dhd_if_t *ifp)
 					 wl0.1 is ready */
 				up(&ap_eth_sema);
 #endif
-				DHD_TRACE(("\n ==== pid:%x, net_device for "
-					"if:%s created ===\n\n",
-					current->pid, ifp->net->name));
+				dhd_dbg(TRACE,
+					" ==== pid:%x, net_device for if:%s created ===\n",
+					current->pid, ifp->net->name);
 				ifp->state = 0;
 			}
 		}
 		break;
 	case WLC_E_IF_DEL:
 		if (ifp->net != NULL) {
-			DHD_TRACE(("\n%s: got 'WLC_E_IF_DEL' state\n",
-				   __func__));
+			dhd_dbg(TRACE, "%s: got 'WLC_E_IF_DEL' state\n",
+				__func__);
 			netif_stop_queue(ifp->net);
 			unregister_netdev(ifp->net);
 			ret = DHD_DEL_IF;	/* Make sure the free_netdev()
@@ -898,7 +900,7 @@ static void dhd_op_if(dhd_if_t *ifp)
 		}
 		break;
 	default:
-		DHD_ERROR(("%s: bad op %d\n", __func__, ifp->state));
+		dhd_dbg(ERROR, "%s: bad op %d\n", __func__, ifp->state);
 		ASSERT(!ifp->state);
 		break;
 	}
@@ -939,22 +941,24 @@ static int _dhd_sysioc_thread(void *data)
 					dhd_op_if(dhd->iflist[i]);
 #ifdef SOFTAP
 				if (dhd->iflist[i] == NULL) {
-					DHD_TRACE(("\n\n %s: interface %d "
-						"removed!\n", __func__, i));
+					dhd_dbg(TRACE,
+						" %s: interface %d removed!\n",
+						__func__, i);
 					continue;
 				}
 
 				if (in_ap && dhd->set_macaddress) {
-					DHD_TRACE(("attempt to set MAC for %s "
-						"in AP Mode," "blocked. \n",
-						dhd->iflist[i]->net->name));
+					dhd_dbg(TRACE,
+						"attempt to set MAC for %s in AP Mode blocked!\n",
+						dhd->iflist[i]->net->name);
 					dhd->set_macaddress = false;
 					continue;
 				}
 
 				if (in_ap && dhd->set_multicast) {
-					DHD_TRACE(("attempt to set MULTICAST list for %s" "in AP Mode, blocked. \n",
-						dhd->iflist[i]->net->name));
+					dhd_dbg(TRACE,
+						"attempt to set MULTICAST list for %s in AP Mode blocked!\n",
+						dhd->iflist[i]->net->name);
 					dhd->set_multicast = false;
 					continue;
 				}
@@ -1064,19 +1068,19 @@ static int dhd_start_xmit(struct sk_buff *skb, struct net_device *net)
 	dhd_info_t *dhd = *(dhd_info_t **) netdev_priv(net);
 	int ifidx;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	dhd_dbg(TRACE, "%s: Enter\n", __func__);
 
 	/* Reject if down */
 	if (!dhd->pub.up || (dhd->pub.busstate == DHD_BUS_DOWN)) {
-		DHD_ERROR(("%s: xmit rejected pub.up=%d busstate=%d\n",
-			   __func__, dhd->pub.up, dhd->pub.busstate));
+		dhd_dbg(ERROR, "%s: xmit rejected pub.up=%d busstate=%d\n",
+			__func__, dhd->pub.up, dhd->pub.busstate);
 		netif_stop_queue(net);
 		return -ENODEV;
 	}
 
 	ifidx = dhd_net2idx(dhd, net);
 	if (ifidx == DHD_BAD_IF) {
-		DHD_ERROR(("%s: bad ifidx %d\n", __func__, ifidx));
+		dhd_dbg(ERROR, "%s: bad ifidx %d\n", __func__, ifidx);
 		netif_stop_queue(net);
 		return -ENODEV;
 	}
@@ -1085,15 +1089,15 @@ static int dhd_start_xmit(struct sk_buff *skb, struct net_device *net)
 	if (skb_headroom(skb) < dhd->pub.hdrlen) {
 		struct sk_buff *skb2;
 
-		DHD_INFO(("%s: insufficient headroom\n",
-			  dhd_ifname(&dhd->pub, ifidx)));
+		dhd_dbg(INFO, "%s: insufficient headroom\n",
+			dhd_ifname(&dhd->pub, ifidx));
 		dhd->pub.tx_realloc++;
 		skb2 = skb_realloc_headroom(skb, dhd->pub.hdrlen);
 		dev_kfree_skb(skb);
 		skb = skb2;
 		if (skb == NULL) {
-			DHD_ERROR(("%s: skb_realloc_headroom failed\n",
-				   dhd_ifname(&dhd->pub, ifidx)));
+			dhd_dbg(ERROR, "%s: skb_realloc_headroom failed\n",
+				dhd_ifname(&dhd->pub, ifidx));
 			ret = -ENOMEM;
 			goto done;
 		}
@@ -1102,8 +1106,8 @@ static int dhd_start_xmit(struct sk_buff *skb, struct net_device *net)
 	/* Convert to packet */
 	pktbuf = PKTFRMNATIVE(dhd->pub.osh, skb);
 	if (!pktbuf) {
-		DHD_ERROR(("%s: PKTFRMNATIVE failed\n",
-			   dhd_ifname(&dhd->pub, ifidx)));
+		dhd_dbg(ERROR, "%s: PKTFRMNATIVE failed\n",
+			dhd_ifname(&dhd->pub, ifidx));
 		dev_kfree_skb_any(skb);
 		ret = -ENOMEM;
 		goto done;
@@ -1126,7 +1130,7 @@ void dhd_txflowcontrol(dhd_pub_t *dhdp, int ifidx, bool state)
 	struct net_device *net;
 	dhd_info_t *dhd = dhdp->info;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	dhd_dbg(TRACE, "%s: Enter\n", __func__);
 
 	dhdp->txoff = state;
 	ASSERT(dhd && dhd->iflist[ifidx]);
@@ -1150,7 +1154,7 @@ void dhd_rx_frame(dhd_pub_t *dhdp, int ifidx, struct sk_buff *pktbuf,
 	dhd_if_t *ifp;
 	wl_event_msg_t event;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	dhd_dbg(TRACE, "%s: Enter\n", __func__);
 
 	save_pktbuf = pktbuf;
 
@@ -1252,7 +1256,7 @@ static struct net_device_stats *dhd_get_stats(struct net_device *net)
 	dhd_if_t *ifp;
 	int ifidx;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	dhd_dbg(TRACE, "%s: Enter\n", __func__);
 
 	ifidx = dhd_net2idx(dhd, net);
 	if (ifidx == DHD_BAD_IF)
@@ -1426,13 +1430,13 @@ static int dhd_toe_get(dhd_info_t *dhd, int ifidx, u32 *toe_ol)
 	if (ret < 0) {
 		/* Check for older dongle image that doesn't support toe_ol */
 		if (ret == -EIO) {
-			DHD_ERROR(("%s: toe not supported by device\n",
-				   dhd_ifname(&dhd->pub, ifidx)));
+			dhd_dbg(ERROR, "%s: toe not supported by device\n",
+				dhd_ifname(&dhd->pub, ifidx));
 			return -EOPNOTSUPP;
 		}
 
-		DHD_INFO(("%s: could not get toe_ol: ret=%d\n",
-			  dhd_ifname(&dhd->pub, ifidx), ret));
+		dhd_dbg(INFO, "%s: could not get toe_ol: ret=%d\n",
+			dhd_ifname(&dhd->pub, ifidx), ret);
 		return ret;
 	}
 
@@ -1462,8 +1466,8 @@ static int dhd_toe_set(dhd_info_t *dhd, int ifidx, u32 toe_ol)
 
 	ret = dhd_prot_ioctl(&dhd->pub, ifidx, &ioc, ioc.buf, ioc.len);
 	if (ret < 0) {
-		DHD_ERROR(("%s: could not set toe_ol: ret=%d\n",
-			   dhd_ifname(&dhd->pub, ifidx), ret));
+		dhd_dbg(ERROR, "%s: could not set toe_ol: ret=%d\n",
+			dhd_ifname(&dhd->pub, ifidx), ret);
 		return ret;
 	}
 
@@ -1476,8 +1480,8 @@ static int dhd_toe_set(dhd_info_t *dhd, int ifidx, u32 toe_ol)
 
 	ret = dhd_prot_ioctl(&dhd->pub, ifidx, &ioc, ioc.buf, ioc.len);
 	if (ret < 0) {
-		DHD_ERROR(("%s: could not set toe: ret=%d\n",
-			   dhd_ifname(&dhd->pub, ifidx), ret));
+		dhd_dbg(ERROR, "%s: could not set toe: ret=%d\n",
+			dhd_ifname(&dhd->pub, ifidx), ret);
 		return ret;
 	}
 
@@ -1511,7 +1515,7 @@ static int dhd_ethtool(dhd_info_t *dhd, void *uaddr)
 	int ret;
 #endif
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	dhd_dbg(TRACE, "%s: Enter\n", __func__);
 
 	/* all ethtool calls start with a cmd word */
 	if (copy_from_user(&cmd, uaddr, sizeof(u32)))
@@ -1537,7 +1541,7 @@ static int dhd_ethtool(dhd_info_t *dhd, void *uaddr)
 
 		/* otherwise, require dongle to be up */
 		else if (!dhd->pub.up) {
-			DHD_ERROR(("%s: dongle is not up\n", __func__));
+			dhd_dbg(ERROR, "%s: dongle is not up\n", __func__);
 			return -ENODEV;
 		}
 
@@ -1550,8 +1554,8 @@ static int dhd_ethtool(dhd_info_t *dhd, void *uaddr)
 		sprintf(info.version, "%lu", dhd->pub.drv_version);
 		if (copy_to_user(uaddr, &info, sizeof(info)))
 			return -EFAULT;
-		DHD_CTL(("%s: given %*s, returning %s\n", __func__,
-			 (int)sizeof(drvname), drvname, info.driver));
+		dhd_dbg(CTL, "%s: given %*s, returning %s\n",
+			__func__, (int)sizeof(drvname), drvname, info.driver);
 		break;
 
 #ifdef TOE
@@ -1627,7 +1631,7 @@ static int dhd_ioctl_entry(struct net_device *net, struct ifreq *ifr, int cmd)
 	bool is_set_key_cmd;
 
 	ifidx = dhd_net2idx(dhd, net);
-	DHD_TRACE(("%s: ifidx %d, cmd 0x%04x\n", __func__, ifidx, cmd));
+	dhd_dbg(TRACE, "%s: ifidx %d, cmd 0x%04x\n", __func__, ifidx, cmd);
 
 	if (ifidx == DHD_BAD_IF)
 		return -1;
@@ -1698,7 +1702,7 @@ static int dhd_ioctl_entry(struct net_device *net, struct ifreq *ifr, int cmd)
 
 	/* send to dongle (must be up, and wl) */
 	if ((dhd->pub.busstate != DHD_BUS_DATA)) {
-		DHD_ERROR(("%s DONGLE_DOWN,__func__\n", __func__));
+		dhd_dbg(ERROR, "%s: DONGLE_DOWN\n", __func__);
 		bcmerror = -EIO;
 		goto done;
 	}
@@ -1741,7 +1745,7 @@ static int dhd_stop(struct net_device *net)
 #if !defined(IGNORE_ETH0_DOWN)
 	dhd_info_t *dhd = *(dhd_info_t **) netdev_priv(net);
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	dhd_dbg(TRACE, "%s: Enter\n", __func__);
 	if (IS_CFG80211_FAVORITE()) {
 		wl_cfg80211_down();
 	}
@@ -1752,8 +1756,9 @@ static int dhd_stop(struct net_device *net)
 	dhd->pub.up = 0;
 	netif_stop_queue(net);
 #else
-	DHD_ERROR(("BYPASS %s:due to BRCM compilation : under investigation\n",
-		__func__));
+	dhd_dbg(ERROR,
+		"BYPASS %s:due to BRCM compilation : under investigation\n",
+		__func__);
 #endif				/* !defined(IGNORE_ETH0_DOWN) */
 
 	return 0;
@@ -1768,14 +1773,15 @@ static int dhd_open(struct net_device *net)
 	int ifidx = dhd_net2idx(dhd, net);
 	s32 ret = 0;
 
-	DHD_TRACE(("%s: ifidx %d\n", __func__, ifidx));
+	dhd_dbg(TRACE, "%s: ifidx %d\n", __func__, ifidx);
 
 	if (ifidx == 0) {	/* do it only for primary eth0 */
 
 		/* try to bring up bus */
 		ret = dhd_bus_start(&dhd->pub);
 		if (ret != 0) {
-			DHD_ERROR(("%s: failed with code %d\n", __func__, ret));
+			dhd_dbg(ERROR, "%s: failed with code %d\n",
+				__func__, ret);
 			return -1;
 		}
 		atomic_set(&dhd->pend_8021x_cnt, 0);
@@ -1796,8 +1802,8 @@ static int dhd_open(struct net_device *net)
 	dhd->pub.up = 1;
 	if (IS_CFG80211_FAVORITE()) {
 		if (unlikely(wl_cfg80211_up())) {
-			DHD_ERROR(("%s: failed to bring up cfg80211\n",
-				   __func__));
+			dhd_dbg(ERROR, "%s: failed to bring up cfg80211\n",
+				__func__);
 			return -1;
 		}
 	}
@@ -1811,13 +1817,13 @@ dhd_add_if(dhd_info_t *dhd, int ifidx, void *handle, char *name,
 {
 	dhd_if_t *ifp;
 
-	DHD_TRACE(("%s: idx %d, handle->%p\n", __func__, ifidx, handle));
+	dhd_dbg(TRACE, "%s: idx %d, handle->%p\n", __func__, ifidx, handle);
 
 	ASSERT(dhd && (ifidx < DHD_MAX_IFS));
 
 	ifp = dhd->iflist[ifidx];
 	if (!ifp && !(ifp = kmalloc(sizeof(dhd_if_t), GFP_ATOMIC))) {
-		DHD_ERROR(("%s: OOM - dhd_if_t\n", __func__));
+		dhd_dbg(ERROR, "%s: OOM - dhd_if_t\n", __func__);
 		return -ENOMEM;
 	}
 
@@ -1843,12 +1849,12 @@ void dhd_del_if(dhd_info_t *dhd, int ifidx)
 {
 	dhd_if_t *ifp;
 
-	DHD_TRACE(("%s: idx %d\n", __func__, ifidx));
+	dhd_dbg(TRACE, "%s: idx %d\n", __func__, ifidx);
 
 	ASSERT(dhd && ifidx && (ifidx < DHD_MAX_IFS));
 	ifp = dhd->iflist[ifidx];
 	if (!ifp) {
-		DHD_ERROR(("%s: Null interface\n", __func__));
+		dhd_dbg(ERROR, "%s: Null interface\n", __func__);
 		return;
 	}
 
@@ -1863,7 +1869,7 @@ dhd_pub_t *dhd_attach(struct dhd_bus *bus, uint bus_hdrlen)
 	dhd_info_t *dhd = NULL;
 	struct net_device *net;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	dhd_dbg(TRACE, "%s: Enter\n", __func__);
 	/* updates firmware nvram path if it was provided as module
 		 paramters */
 	if ((firmware_path != NULL) && (firmware_path[0] != '\0'))
@@ -1874,14 +1880,14 @@ dhd_pub_t *dhd_attach(struct dhd_bus *bus, uint bus_hdrlen)
 	/* Allocate etherdev, including space for private structure */
 	net = alloc_etherdev(sizeof(dhd));
 	if (!net) {
-		DHD_ERROR(("%s: OOM - alloc_etherdev\n", __func__));
+		dhd_dbg(ERROR, "%s: OOM - alloc_etherdev\n", __func__);
 		goto fail;
 	}
 
 	/* Allocate primary dhd_info */
 	dhd = kzalloc(sizeof(dhd_info_t), GFP_ATOMIC);
 	if (!dhd) {
-		DHD_ERROR(("%s: OOM - alloc dhd_info\n", __func__));
+		dhd_dbg(ERROR, "%s: OOM - alloc dhd_info\n", __func__);
 		goto fail;
 	}
 
@@ -1925,13 +1931,13 @@ dhd_pub_t *dhd_attach(struct dhd_bus *bus, uint bus_hdrlen)
 
 	/* Attach and link in the protocol */
 	if (dhd_prot_attach(&dhd->pub) != 0) {
-		DHD_ERROR(("dhd_prot_attach failed\n"));
+		dhd_dbg(ERROR, "dhd_prot_attach failed\n");
 		goto fail;
 	}
 #if defined(CONFIG_WIRELESS_EXT)
 	/* Attach and link in the iw */
 	if (wl_iw_attach(net, (void *)&dhd->pub) != 0) {
-		DHD_ERROR(("wl_iw_attach failed\n"));
+		dhd_dbg(ERROR, "wl_iw_attach failed\n");
 		goto fail;
 	}
 #endif	/* defined(CONFIG_WIRELESS_EXT) */
@@ -1939,7 +1945,7 @@ dhd_pub_t *dhd_attach(struct dhd_bus *bus, uint bus_hdrlen)
 	/* Attach and link in the cfg80211 */
 	if (IS_CFG80211_FAVORITE()) {
 		if (unlikely(wl_cfg80211_attach(net, &dhd->pub))) {
-			DHD_ERROR(("wl_cfg80211_attach failed\n"));
+			dhd_dbg(ERROR, "wl_cfg80211_attach failed\n");
 			goto fail;
 		}
 		if (!NO_FW_REQ()) {
@@ -2045,15 +2051,15 @@ int dhd_bus_start(dhd_pub_t *dhdp)
 
 	ASSERT(dhd);
 
-	DHD_TRACE(("%s:\n", __func__));
+	dhd_dbg(TRACE, "%s:\n", __func__);
 
 	/* try to download image and nvram to the dongle */
 	if (dhd->pub.busstate == DHD_BUS_DOWN) {
 		if (!(dhd_bus_download_firmware(dhd->pub.bus,
 						fw_path, nv_path))) {
-			DHD_ERROR(("%s: dhdsdio_probe_download failed. "
-				"firmware = %s nvram = %s\n",
-				__func__, fw_path, nv_path));
+			dhd_dbg(ERROR,
+				"%s: dhdsdio_probe_download failed. firmware = %s nvram = %s\n",
+				__func__, fw_path, nv_path);
 			return -1;
 		}
 	}
@@ -2065,7 +2071,7 @@ int dhd_bus_start(dhd_pub_t *dhdp)
 	/* Bring up the bus */
 	ret = dhd_bus_init(&dhd->pub, true);
 	if (ret != 0) {
-		DHD_ERROR(("%s, dhd_bus_init failed %d\n", __func__, ret));
+		dhd_dbg(ERROR, "%s, dhd_bus_init failed %d\n", __func__, ret);
 		return ret;
 	}
 #if defined(OOB_INTR_ONLY)
@@ -2073,7 +2079,8 @@ int dhd_bus_start(dhd_pub_t *dhdp)
 	if (bcmsdh_register_oob_intr(dhdp)) {
 		del_timer_sync(&dhd->timer);
 		dhd->wd_timer_valid = false;
-		DHD_ERROR(("%s Host failed to resgister for OOB\n", __func__));
+		dhd_dbg(ERROR, "%s Host failed to register for OOB\n",
+			__func__);
 		return -ENODEV;
 	}
 
@@ -2085,7 +2092,7 @@ int dhd_bus_start(dhd_pub_t *dhdp)
 	if (dhd->pub.busstate != DHD_BUS_DATA) {
 		del_timer_sync(&dhd->timer);
 		dhd->wd_timer_valid = false;
-		DHD_ERROR(("%s failed bus is not ready\n", __func__));
+		dhd_dbg(ERROR, "%s failed bus is not ready\n", __func__);
 		return -ENODEV;
 	}
 #ifdef EMBEDDED_PLATFORM
@@ -2173,7 +2180,7 @@ int dhd_net_attach(dhd_pub_t *dhdp, int ifidx)
 	u8 temp_addr[ETH_ALEN] = {
 		0x00, 0x90, 0x4c, 0x11, 0x22, 0x33};
 
-	DHD_TRACE(("%s: ifidx %d\n", __func__, ifidx));
+	dhd_dbg(TRACE, "%s: ifidx %d\n", __func__, ifidx);
 
 	ASSERT(dhd && dhd->iflist[ifidx]);
 
@@ -2193,7 +2200,7 @@ int dhd_net_attach(dhd_pub_t *dhdp, int ifidx)
 	}
 
 	if (ifidx == 1) {
-		DHD_TRACE(("%s ACCESS POINT MAC: \n", __func__));
+		dhd_dbg(TRACE, "%s ACCESS POINT MAC:\n", __func__);
 		/*  ACCESSPOINT INTERFACE CASE */
 		temp_addr[0] |= 0X02;	/* set bit 2 ,
 			 - Locally Administered address  */
@@ -2207,12 +2214,12 @@ int dhd_net_attach(dhd_pub_t *dhdp, int ifidx)
 	memcpy(net->dev_addr, temp_addr, ETH_ALEN);
 
 	if (register_netdev(net) != 0) {
-		DHD_ERROR(("%s: couldn't register the net device\n",
-			__func__));
+		dhd_dbg(ERROR, "%s: couldn't register the net device\n",
+			__func__);
 		goto fail;
 	}
 
-	DHD_INFO(("%s: Broadcom Dongle Host Driver\n", net->name));
+	dhd_dbg(INFO, "%s: Broadcom Dongle Host Driver\n", net->name);
 
 	return 0;
 
@@ -2225,7 +2232,7 @@ void dhd_bus_detach(dhd_pub_t *dhdp)
 {
 	dhd_info_t *dhd;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	dhd_dbg(TRACE, "%s: Enter\n", __func__);
 
 	if (dhdp) {
 		dhd = (dhd_info_t *) dhdp->info;
@@ -2250,7 +2257,7 @@ void dhd_detach(dhd_pub_t *dhdp)
 {
 	dhd_info_t *dhd;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	dhd_dbg(TRACE, "%s: Enter\n", __func__);
 
 	if (dhdp) {
 		dhd = (dhd_info_t *) dhdp->info;
@@ -2319,7 +2326,7 @@ void dhd_detach(dhd_pub_t *dhdp)
 
 static void __exit dhd_module_cleanup(void)
 {
-	DHD_TRACE(("%s: Enter\n", __func__));
+	dhd_dbg(TRACE, "%s: Enter\n", __func__);
 
 	dhd_bus_unregister();
 #if defined(CUSTOMER_HW2) && defined(CONFIG_WIFI_CONTROL_FUNC)
@@ -2333,7 +2340,7 @@ static int __init dhd_module_init(void)
 {
 	int error;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	dhd_dbg(TRACE, "%s: Enter\n", __func__);
 
 	/* Sanity check on the module parameters */
 	do {
@@ -2346,7 +2353,7 @@ static int __init dhd_module_init(void)
 		    && dhd_deferred_tx)
 			break;
 
-		DHD_ERROR(("Invalid module parameters.\n"));
+		dhd_dbg(ERROR, "Invalid module parameters\n");
 		return -EINVAL;
 	} while (0);
 	/* Call customer gpio to turn on power with WL_REG_ON signal */
@@ -2357,7 +2364,8 @@ static int __init dhd_module_init(void)
 
 	error = wifi_add_dev();
 	if (error) {
-		DHD_ERROR(("%s: platform_driver_register failed\n", __func__));
+		dhd_dbg(ERROR, "%s: platform_driver_register failed\n",
+			__func__);
 		goto failed;
 	}
 
@@ -2375,7 +2383,7 @@ static int __init dhd_module_init(void)
 	error = dhd_bus_register();
 
 	if (error) {
-		DHD_ERROR(("%s: sdio_register_driver failed\n", __func__));
+		dhd_dbg(ERROR, "%s: sdio_register_driver failed\n", __func__);
 		goto failed;
 	}
 	return error;
@@ -2625,7 +2633,7 @@ dhd_wl_host_event(dhd_info_t *dhd, int *ifidx, void *pktdata,
 	if (!IS_CFG80211_FAVORITE()) {
 		if ((dhd->iflist[*ifidx] == NULL)
 		    || (dhd->iflist[*ifidx]->net == NULL)) {
-			DHD_ERROR(("%s Exit null pointer\n", __func__));
+			dhd_dbg(ERROR, "%s Exit null pointer\n", __func__);
 			return bcmerror;
 		}
 
@@ -2685,7 +2693,7 @@ int dhd_dev_reset(struct net_device *dev, u8 flag)
 	/* Turning on watchdog back */
 	if (!flag)
 		dhd_os_wd_timer(&dhd->pub, dhd_watchdog_ms);
-	DHD_ERROR(("%s:  WLAN OFF DONE\n", __func__));
+	dhd_dbg(ERROR, "%s:  WLAN OFF DONE\n", __func__);
 
 	return 1;
 }
@@ -2840,7 +2848,7 @@ int write_to_file(dhd_pub_t *dhd, u8 *buf, int size)
 	/* open file to write */
 	fp = filp_open("/tmp/mem_dump", O_WRONLY | O_CREAT, 0640);
 	if (!fp) {
-		DHD_ERROR(("%s: open file error\n", __func__));
+		dhd_dbg(ERROR, "%s: open file error\n", __func__);
 		ret = -1;
 		goto exit;
 	}
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index a71c6f8..1df92be 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -405,8 +405,8 @@ do { \
 	if (retryvar) { \
 		bus->regfails += (retryvar-1); \
 		if (retryvar > retry_limit) { \
-			DHD_ERROR(("%s: FAILED" #regvar "READ, LINE %d\n", \
-			__func__, __LINE__)); \
+			dhd_dbg(ERROR, "%s: FAILED" #regvar "READ, LINE %d\n", \
+				__func__, __LINE__);			\
 			regvar = 0; \
 		} \
 	} \
@@ -421,8 +421,8 @@ do { \
 	if (retryvar) { \
 		bus->regfails += (retryvar-1); \
 		if (retryvar > retry_limit) \
-			DHD_ERROR(("%s: FAILED REGISTER WRITE, LINE %d\n", \
-			__func__, __LINE__)); \
+			dhd_dbg(ERROR, "%s: FAILED REGISTER WRITE, LINE %d\n", \
+				__func__, __LINE__);			\
 	} \
 } while (0)
 
@@ -491,8 +491,8 @@ static void dhd_dongle_setmemsize(struct dhd_bus *bus, int mem_size)
 {
 	s32 min_size = DONGLE_MIN_MEMSIZE;
 	/* Restrict the memsize to user specified limit */
-	DHD_ERROR(("user: Restrict the dongle ram size to %d, min %d\n",
-		dhd_dongle_memsize, min_size));
+	dhd_dbg(ERROR, "user: Restrict the dongle ram size to %d, min %d\n",
+		dhd_dongle_memsize, min_size);
 	if ((dhd_dongle_memsize > min_size) &&
 	    (dhd_dongle_memsize < (s32) bus->orig_ramsize))
 		bus->ramsize = dhd_dongle_memsize;
@@ -520,7 +520,7 @@ static int dhdsdio_htclk(dhd_bus_t *bus, bool on, bool pendok)
 	u8 clkctl, clkreq, devctl;
 	bcmsdh_info_t *sdh;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	dhd_dbg(TRACE, "%s: Enter\n", __func__);
 
 #if defined(OOB_INTR_ONLY)
 	pendok = false;
@@ -540,8 +540,8 @@ static int dhdsdio_htclk(dhd_bus_t *bus, bool on, bool pendok)
 		bcmsdh_cfg_write(sdh, SDIO_FUNC_1, SBSDIO_FUNC1_CHIPCLKCSR,
 				 clkreq, &err);
 		if (err) {
-			DHD_ERROR(("%s: HT Avail request error: %d\n",
-				   __func__, err));
+			dhd_dbg(ERROR, "%s: HT Avail request error: %d\n",
+				__func__, err);
 			return -EBADE;
 		}
 
@@ -556,8 +556,8 @@ static int dhdsdio_htclk(dhd_bus_t *bus, bool on, bool pendok)
 		    bcmsdh_cfg_read(sdh, SDIO_FUNC_1, SBSDIO_FUNC1_CHIPCLKCSR,
 				    &err);
 		if (err) {
-			DHD_ERROR(("%s: HT Avail read error: %d\n",
-				   __func__, err));
+			dhd_dbg(ERROR, "%s: HT Avail read error: %d\n",
+				__func__, err);
 			return -EBADE;
 		}
 
@@ -568,15 +568,16 @@ static int dhdsdio_htclk(dhd_bus_t *bus, bool on, bool pendok)
 			    bcmsdh_cfg_read(sdh, SDIO_FUNC_1, SBSDIO_DEVICE_CTL,
 					    &err);
 			if (err) {
-				DHD_ERROR(("%s: Devctl error setting CA: %d\n",
-					__func__, err));
+				dhd_dbg(ERROR,
+					"%s: Devctl error setting CA: %d\n",
+					__func__, err);
 				return -EBADE;
 			}
 
 			devctl |= SBSDIO_DEVCTL_CA_INT_ONLY;
 			bcmsdh_cfg_write(sdh, SDIO_FUNC_1, SBSDIO_DEVICE_CTL,
 					 devctl, &err);
-			DHD_INFO(("CLKCTL: set PENDING\n"));
+			dhd_dbg(INFO, "CLKCTL: set PENDING\n");
 			bus->clkstate = CLK_PENDING;
 
 			return 0;
@@ -601,32 +602,33 @@ static int dhdsdio_htclk(dhd_bus_t *bus, bool on, bool pendok)
 				       PMU_MAX_TRANSITION_DLY);
 		}
 		if (err) {
-			DHD_ERROR(("%s: HT Avail request error: %d\n",
-				   __func__, err));
+			dhd_dbg(ERROR, "%s: HT Avail request error: %d\n",
+				__func__, err);
 			return -EBADE;
 		}
 		if (!SBSDIO_CLKAV(clkctl, bus->alp_only)) {
-			DHD_ERROR(("%s: HT Avail timeout (%d): clkctl 0x%02x\n",
-				   __func__, PMU_MAX_TRANSITION_DLY, clkctl));
+			dhd_dbg(ERROR,
+				"%s: HT Avail timeout (%d): clkctl 0x%02x\n",
+				__func__, PMU_MAX_TRANSITION_DLY, clkctl);
 			return -EBADE;
 		}
 
 		/* Mark clock available */
 		bus->clkstate = CLK_AVAIL;
-		DHD_INFO(("CLKCTL: turned ON\n"));
+		dhd_dbg(INFO, "CLKCTL: turned ON\n");
 
 #if defined(DHD_DEBUG)
 		if (bus->alp_only == true) {
 #if !defined(BCMLXSDMMC)
 			if (!SBSDIO_ALPONLY(clkctl)) {
-				DHD_ERROR(("%s: HT Clock, when ALP Only\n",
-					   __func__));
+				dhd_dbg(ERROR, "%s: HT Clock, when ALP Only\n",
+					__func__);
 			}
 #endif				/* !defined(BCMLXSDMMC) */
 		} else {
 			if (SBSDIO_ALPONLY(clkctl)) {
-				DHD_ERROR(("%s: HT Clock should be on.\n",
-					   __func__));
+				dhd_dbg(ERROR, "%s: HT Clock should be on\n",
+					__func__);
 			}
 		}
 #endif				/* defined (DHD_DEBUG) */
@@ -648,10 +650,11 @@ static int dhdsdio_htclk(dhd_bus_t *bus, bool on, bool pendok)
 		bus->clkstate = CLK_SDONLY;
 		bcmsdh_cfg_write(sdh, SDIO_FUNC_1, SBSDIO_FUNC1_CHIPCLKCSR,
 				 clkreq, &err);
-		DHD_INFO(("CLKCTL: turned OFF\n"));
+		dhd_dbg(INFO, "CLKCTL: turned OFF\n");
 		if (err) {
-			DHD_ERROR(("%s: Failed access turning clock off: %d\n",
-				   __func__, err));
+			dhd_dbg(ERROR,
+				"%s: Failed access turning clock off: %d\n",
+				__func__, err);
 			return -EBADE;
 		}
 	}
@@ -664,7 +667,7 @@ static int dhdsdio_sdclk(dhd_bus_t *bus, bool on)
 	int err;
 	s32 iovalue;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	dhd_dbg(TRACE, "%s: Enter\n", __func__);
 
 	if (on) {
 		if (bus->idleclock == DHD_IDLE_STOP) {
@@ -673,8 +676,9 @@ static int dhdsdio_sdclk(dhd_bus_t *bus, bool on)
 			err = bcmsdh_iovar_op(bus->sdh, "sd_clock", NULL, 0,
 					      &iovalue, sizeof(iovalue), true);
 			if (err) {
-				DHD_ERROR(("%s: error enabling sd_clock: %d\n",
-					   __func__, err));
+				dhd_dbg(ERROR,
+					"%s: error enabling sd_clock: %d\n",
+					__func__, err);
 				return -EBADE;
 			}
 
@@ -682,8 +686,9 @@ static int dhdsdio_sdclk(dhd_bus_t *bus, bool on)
 			err = bcmsdh_iovar_op(bus->sdh, "sd_mode", NULL, 0,
 					      &iovalue, sizeof(iovalue), true);
 			if (err) {
-				DHD_ERROR(("%s: error changing sd_mode: %d\n",
-					   __func__, err));
+				dhd_dbg(ERROR,
+					"%s: error changing sd_mode: %d\n",
+					__func__, err);
 				return -EBADE;
 			}
 		} else if (bus->idleclock != DHD_IDLE_ACTIVE) {
@@ -692,8 +697,9 @@ static int dhdsdio_sdclk(dhd_bus_t *bus, bool on)
 			err = bcmsdh_iovar_op(bus->sdh, "sd_divisor", NULL, 0,
 					      &iovalue, sizeof(iovalue), true);
 			if (err) {
-				DHD_ERROR(("%s: error restoring sd_divisor: %d\n",
-					__func__, err));
+				dhd_dbg(ERROR,
+					"%s: error restoring sd_divisor: %d\n",
+					__func__, err);
 				return -EBADE;
 			}
 		}
@@ -701,8 +707,9 @@ static int dhdsdio_sdclk(dhd_bus_t *bus, bool on)
 	} else {
 		/* Stop or slow the SD clock itself */
 		if ((bus->sd_divisor == -1) || (bus->sd_mode == -1)) {
-			DHD_TRACE(("%s: can't idle clock, divisor %d mode %d\n",
-				   __func__, bus->sd_divisor, bus->sd_mode));
+			dhd_dbg(TRACE,
+				"%s: can't idle clock, divisor %d mode %d\n",
+				__func__, bus->sd_divisor, bus->sd_mode);
 			return -EBADE;
 		}
 		if (bus->idleclock == DHD_IDLE_STOP) {
@@ -714,8 +721,9 @@ static int dhdsdio_sdclk(dhd_bus_t *bus, bool on)
 						    0, &iovalue,
 						    sizeof(iovalue), true);
 				if (err) {
-					DHD_ERROR(("%s: error changing sd_clock: %d\n",
-						__func__, err));
+					dhd_dbg(ERROR,
+						"%s: error changing sd_clock: %d\n",
+						__func__, err);
 					return -EBADE;
 				}
 			}
@@ -724,8 +732,9 @@ static int dhdsdio_sdclk(dhd_bus_t *bus, bool on)
 			err = bcmsdh_iovar_op(bus->sdh, "sd_clock", NULL, 0,
 					      &iovalue, sizeof(iovalue), true);
 			if (err) {
-				DHD_ERROR(("%s: error disabling sd_clock: %d\n",
-					   __func__, err));
+				dhd_dbg(ERROR,
+					"%s: error disabling sd_clock: %d\n",
+					__func__, err);
 				return -EBADE;
 			}
 		} else if (bus->idleclock != DHD_IDLE_ACTIVE) {
@@ -734,8 +743,9 @@ static int dhdsdio_sdclk(dhd_bus_t *bus, bool on)
 			err = bcmsdh_iovar_op(bus->sdh, "sd_divisor", NULL, 0,
 					      &iovalue, sizeof(iovalue), true);
 			if (err) {
-				DHD_ERROR(("%s: error changing sd_divisor: %d\n",
-					__func__, err));
+				dhd_dbg(ERROR,
+					"%s: error changing sd_divisor: %d\n",
+					__func__, err);
 				return -EBADE;
 			}
 		}
@@ -752,7 +762,7 @@ static int dhdsdio_clkctl(dhd_bus_t *bus, uint target, bool pendok)
 	uint oldstate = bus->clkstate;
 #endif				/* DHD_DEBUG */
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	dhd_dbg(TRACE, "%s: Enter\n", __func__);
 
 	/* Early exit if we're already there */
 	if (bus->clkstate == target) {
@@ -781,8 +791,8 @@ static int dhdsdio_clkctl(dhd_bus_t *bus, uint target, bool pendok)
 		else if (bus->clkstate == CLK_AVAIL)
 			dhdsdio_htclk(bus, false, false);
 		else
-			DHD_ERROR(("dhdsdio_clkctl: request for %d -> %d\n",
-				   bus->clkstate, target));
+			dhd_dbg(ERROR, "dhdsdio_clkctl: request for %d -> %d\n",
+				bus->clkstate, target);
 		dhd_os_wd_timer(bus->dhd, dhd_watchdog_ms);
 		break;
 
@@ -796,7 +806,7 @@ static int dhdsdio_clkctl(dhd_bus_t *bus, uint target, bool pendok)
 		break;
 	}
 #ifdef DHD_DEBUG
-	DHD_INFO(("dhdsdio_clkctl: %d -> %d\n", oldstate, bus->clkstate));
+	dhd_dbg(INFO, "dhdsdio_clkctl: %d -> %d\n", oldstate, bus->clkstate);
 #endif				/* DHD_DEBUG */
 
 	return 0;
@@ -808,9 +818,9 @@ int dhdsdio_bussleep(dhd_bus_t *bus, bool sleep)
 	sdpcmd_regs_t *regs = bus->regs;
 	uint retries = 0;
 
-	DHD_INFO(("dhdsdio_bussleep: request %s (currently %s)\n",
-		  (sleep ? "SLEEP" : "WAKE"),
-		  (bus->sleeping ? "SLEEP" : "WAKE")));
+	dhd_dbg(INFO, "dhdsdio_bussleep: request %s (currently %s)\n",
+		sleep ? "SLEEP" : "WAKE",
+		bus->sleeping ? "SLEEP" : "WAKE");
 
 	/* Done if we're already in the requested state */
 	if (sleep == bus->sleeping)
@@ -831,7 +841,8 @@ int dhdsdio_bussleep(dhd_bus_t *bus, bool sleep)
 		/* Tell device to start using OOB wakeup */
 		W_SDREG(SMB_USE_OOB, &regs->tosbmailbox, retries);
 		if (retries > retry_limit)
-			DHD_ERROR(("CANNOT SIGNAL CHIP, WILL NOT WAKE UP!!\n"));
+			dhd_dbg(ERROR,
+				"CANNOT SIGNAL CHIP, WILL NOT WAKE UP!!\n");
 
 		/* Turn off our contribution to the HT clock request */
 		dhdsdio_clkctl(bus, CLK_SDONLY, false);
@@ -871,7 +882,7 @@ int dhdsdio_bussleep(dhd_bus_t *bus, bool sleep)
 			W_SDREG(SMB_DEV_INT, &regs->tosbmailbox, retries);
 
 		if (retries > retry_limit)
-			DHD_ERROR(("CANNOT SIGNAL CHIP TO CLEAR OOB!!\n"));
+			dhd_dbg(ERROR, "CANNOT SIGNAL CHIP TO CLEAR OOB!!\n");
 
 		/* Make sure we have SD bus access */
 		dhdsdio_clkctl(bus, CLK_SDONLY, false);
@@ -904,7 +915,8 @@ void dhd_enable_oob_intr(struct dhd_bus *bus, bool enable)
 		/* Tell device to start using OOB wakeup */
 		W_SDREG(SMB_USE_OOB, &regs->tosbmailbox, retries);
 		if (retries > retry_limit)
-			DHD_ERROR(("CANNOT SIGNAL CHIP, WILL NOT WAKE UP!!\n"));
+			dhd_dbg(ERROR,
+				"CANNOT SIGNAL CHIP, WILL NOT WAKE UP!!\n");
 
 	} else {
 		/* Send misc interrupt to indicate OOB not needed */
@@ -939,7 +951,7 @@ static int dhdsdio_txpkt(dhd_bus_t *bus, struct sk_buff *pkt, uint chan,
 	struct sk_buff *new;
 	int i;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	dhd_dbg(TRACE, "%s: Enter\n", __func__);
 
 	sdh = bus->sdh;
 
@@ -954,14 +966,15 @@ static int dhdsdio_txpkt(dhd_bus_t *bus, struct sk_buff *pkt, uint chan,
 	pad = ((unsigned long)frame % DHD_SDALIGN);
 	if (pad) {
 		if (skb_headroom(pkt) < pad) {
-			DHD_INFO(("%s: insufficient headroom %d for %d pad\n",
-				  __func__, skb_headroom(pkt), pad));
+			dhd_dbg(INFO,
+				"%s: insufficient headroom %d for %d pad\n",
+				__func__, skb_headroom(pkt), pad);
 			bus->dhd->tx_realloc++;
 			new = bcm_pkt_buf_get_skb(pkt->len + DHD_SDALIGN);
 			if (!new) {
-				DHD_ERROR(("%s: couldn't allocate new %d-byte "
-					"packet\n",
-					__func__, pkt->len + DHD_SDALIGN));
+				dhd_dbg(ERROR,
+					"%s: couldn't allocate new %d-byte packet\n",
+					__func__, pkt->len + DHD_SDALIGN);
 				ret = -ENOMEM;
 				goto done;
 			}
@@ -1034,8 +1047,8 @@ static int dhdsdio_txpkt(dhd_bus_t *bus, struct sk_buff *pkt, uint chan,
 			len = roundup(len, ALIGNMENT);
 #ifdef NOTUSED
 		else
-			DHD_ERROR(("%s: sending unrounded %d-byte packet\n",
-				   __func__, len));
+			dhd_dbg(ERROR, "%s: sending unrounded %d-byte packet\n",
+				__func__, len);
 #endif
 	}
 
@@ -1049,8 +1062,9 @@ static int dhdsdio_txpkt(dhd_bus_t *bus, struct sk_buff *pkt, uint chan,
 		if (ret < 0) {
 			/* On failure, abort the command
 			 and terminate the frame */
-			DHD_INFO(("%s: sdio error %d, abort command and "
-				"terminate frame.\n", __func__, ret));
+			dhd_dbg(INFO,
+				"%s: sdio error %d, abort command and terminate frame\n",
+				__func__, ret);
 			bus->tx_sderrs++;
 
 			bcmsdh_abort(sdh, SDIO_FUNC_2);
@@ -1096,7 +1110,7 @@ int dhd_bus_txdata(struct dhd_bus *bus, struct sk_buff *pkt)
 	int ret = -EBADE;
 	uint datalen, prec;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	dhd_dbg(TRACE, "%s: Enter\n", __func__);
 
 	datalen = pkt->len;
 
@@ -1126,8 +1140,8 @@ int dhd_bus_txdata(struct dhd_bus *bus, struct sk_buff *pkt)
 	    || bus->dpc_sched || (!DATAOK(bus))
 	    || (bus->flowcontrol & NBITVAL(prec))
 	    || (bus->clkstate != CLK_AVAIL)) {
-		DHD_TRACE(("%s: deferring pktq len %d\n", __func__,
-			   pktq_len(&bus->txq)));
+		dhd_dbg(TRACE, "%s: deferring pktq len %d\n",
+			__func__, pktq_len(&bus->txq));
 		bus->fcqueued++;
 
 		/* Priority based enq */
@@ -1136,7 +1150,7 @@ int dhd_bus_txdata(struct dhd_bus *bus, struct sk_buff *pkt)
 			skb_pull(pkt, SDPCM_HDRLEN);
 			dhd_txcomplete(bus->dhd, pkt, false);
 			bcm_pkt_buf_free_skb(pkt);
-			DHD_ERROR(("%s: out of bus->txq !!!\n", __func__));
+			dhd_dbg(ERROR, "%s: out of bus->txq !!!\n", __func__);
 			ret = -ENOSR;
 		} else {
 			ret = 0;
@@ -1165,7 +1179,7 @@ int dhd_bus_txdata(struct dhd_bus *bus, struct sk_buff *pkt)
 		dhdsdio_clkctl(bus, CLK_AVAIL, true);
 
 #ifndef SDTEST
-		DHD_TRACE(("%s: calling txpkt\n", __func__));
+		dhd_dbg(TRACE, "%s: calling txpkt\n", __func__);
 		ret = dhdsdio_txpkt(bus, pkt, SDPCM_DATA_CHANNEL, true);
 #else
 		ret = dhdsdio_txpkt(bus, pkt,
@@ -1201,7 +1215,7 @@ static uint dhdsdio_sendfromq(dhd_bus_t *bus, uint maxframes)
 	dhd_pub_t *dhd = bus->dhd;
 	sdpcmd_regs_t *regs = bus->regs;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	dhd_dbg(TRACE, "%s: Enter\n", __func__);
 
 	tx_prec_map = ~bus->flowcontrol;
 
@@ -1259,7 +1273,7 @@ int dhd_bus_txctl(struct dhd_bus *bus, unsigned char *msg, uint msglen)
 	int ret = -1;
 	int i;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	dhd_dbg(TRACE, "%s: Enter\n", __func__);
 
 	if (bus->dhd->dongle_reset)
 		return -EIO;
@@ -1318,8 +1332,9 @@ int dhd_bus_txctl(struct dhd_bus *bus, unsigned char *msg, uint msglen)
 	put_unaligned_le32(0, frame + SDPCM_FRAMETAG_LEN + sizeof(swheader));
 
 	if (!DATAOK(bus)) {
-		DHD_INFO(("%s: No bus credit bus->tx_max %d, bus->tx_seq %d\n",
-			  __func__, bus->tx_max, bus->tx_seq));
+		dhd_dbg(INFO,
+			"%s: No bus credit bus->tx_max %d, bus->tx_seq %d\n",
+			__func__, bus->tx_max, bus->tx_seq);
 		bus->ctrl_frame_stat = true;
 		/* Send from dpc */
 		bus->ctrl_frame_buf = frame;
@@ -1328,10 +1343,12 @@ int dhd_bus_txctl(struct dhd_bus *bus, unsigned char *msg, uint msglen)
 		dhd_wait_for_event(bus->dhd, &bus->ctrl_frame_stat);
 
 		if (bus->ctrl_frame_stat == false) {
-			DHD_INFO(("%s: ctrl_frame_stat == false\n", __func__));
+			dhd_dbg(INFO, "%s: ctrl_frame_stat == false\n",
+				__func__);
 			ret = 0;
 		} else {
-			DHD_INFO(("%s: ctrl_frame_stat == true\n", __func__));
+			dhd_dbg(INFO, "%s: ctrl_frame_stat == true\n",
+				__func__);
 			ret = -1;
 		}
 	}
@@ -1361,8 +1378,9 @@ int dhd_bus_txctl(struct dhd_bus *bus, unsigned char *msg, uint msglen)
 			if (ret < 0) {
 				/* On failure, abort the command and
 				 terminate the frame */
-				DHD_INFO(("%s: sdio error %d, abort command and terminate frame.\n",
-					__func__, ret));
+				dhd_dbg(INFO,
+					"%s: sdio error %d, abort command and terminate frame\n",
+					__func__, ret);
 				bus->tx_sderrs++;
 
 				bcmsdh_abort(sdh, SDIO_FUNC_2);
@@ -1414,7 +1432,7 @@ int dhd_bus_rxctl(struct dhd_bus *bus, unsigned char *msg, uint msglen)
 	uint rxlen = 0;
 	bool pending;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	dhd_dbg(TRACE, "%s: Enter\n", __func__);
 
 	if (bus->dhd->dongle_reset)
 		return -EIO;
@@ -1429,20 +1447,20 @@ int dhd_bus_rxctl(struct dhd_bus *bus, unsigned char *msg, uint msglen)
 	dhd_os_sdunlock(bus->dhd);
 
 	if (rxlen) {
-		DHD_CTL(("%s: resumed on rxctl frame, got %d expected %d\n",
-			 __func__, rxlen, msglen));
+		dhd_dbg(CTL, "%s: resumed on rxctl frame, got %d expected %d\n",
+			__func__, rxlen, msglen);
 	} else if (timeleft == 0) {
-		DHD_ERROR(("%s: resumed on timeout\n", __func__));
+		dhd_dbg(ERROR, "%s: resumed on timeout\n", __func__);
 #ifdef DHD_DEBUG
 		dhd_os_sdlock(bus->dhd);
 		dhdsdio_checkdied(bus, NULL, 0);
 		dhd_os_sdunlock(bus->dhd);
 #endif				/* DHD_DEBUG */
 	} else if (pending == true) {
-		DHD_CTL(("%s: cancelled\n", __func__));
+		dhd_dbg(CTL, "%s: cancelled\n", __func__);
 		return -ERESTARTSYS;
 	} else {
-		DHD_CTL(("%s: resumed for unknown reason?\n", __func__));
+		dhd_dbg(CTL, "%s: resumed for unknown reason?\n", __func__);
 #ifdef DHD_DEBUG
 		dhd_os_sdlock(bus->dhd);
 		dhdsdio_checkdied(bus, NULL, 0);
@@ -1743,19 +1761,21 @@ dhdsdio_membytes(dhd_bus_t *bus, bool write, u32 address, u8 *data,
 	/* Set the backplane window to include the start address */
 	bcmerror = dhdsdio_set_siaddr_window(bus, address);
 	if (bcmerror) {
-		DHD_ERROR(("%s: window change failed\n", __func__));
+		dhd_dbg(ERROR, "%s: window change failed\n", __func__);
 		goto xfer_done;
 	}
 
 	/* Do the transfer(s) */
 	while (size) {
-		DHD_INFO(("%s: %s %d bytes at offset 0x%08x in window 0x%08x\n",
-			  __func__, (write ? "write" : "read"), dsize,
-			  sdaddr, (address & SBSDIO_SBWINDOW_MASK)));
+		dhd_dbg(INFO,
+			"%s: %s %d bytes at offset 0x%08x in window 0x%08x\n",
+			__func__, (write ? "write" : "read"), dsize,
+			sdaddr, (address & SBSDIO_SBWINDOW_MASK));
 		bcmerror =
 		     bcmsdh_rwdata(bus->sdh, write, sdaddr, data, dsize);
 		if (bcmerror) {
-			DHD_ERROR(("%s: membytes transfer failed\n", __func__));
+			dhd_dbg(ERROR, "%s: membytes transfer failed\n",
+				__func__);
 			break;
 		}
 
@@ -1766,8 +1786,8 @@ dhdsdio_membytes(dhd_bus_t *bus, bool write, u32 address, u8 *data,
 			address += dsize;
 			bcmerror = dhdsdio_set_siaddr_window(bus, address);
 			if (bcmerror) {
-				DHD_ERROR(("%s: window change failed\n",
-					   __func__));
+				dhd_dbg(ERROR, "%s: window change failed\n",
+					__func__);
 				break;
 			}
 			sdaddr = 0;
@@ -1778,8 +1798,8 @@ dhdsdio_membytes(dhd_bus_t *bus, bool write, u32 address, u8 *data,
 xfer_done:
 	/* Return the window to backplane enumeration space for core access */
 	if (dhdsdio_set_siaddr_window(bus, bcmsdh_cur_sbwad(bus->sdh))) {
-		DHD_ERROR(("%s: FAILED to set window back to 0x%x\n",
-			   __func__, bcmsdh_cur_sbwad(bus->sdh)));
+		dhd_dbg(ERROR, "%s: FAILED to set window back to 0x%x\n",
+			__func__, bcmsdh_cur_sbwad(bus->sdh));
 	}
 
 	return bcmerror;
@@ -1799,15 +1819,15 @@ static int dhdsdio_readshared(dhd_bus_t *bus, sdpcm_shared_t *sh)
 
 	addr = le32_to_cpu(addr);
 
-	DHD_INFO(("sdpcm_shared address 0x%08X\n", addr));
+	dhd_dbg(INFO, "sdpcm_shared address 0x%08X\n", addr);
 
 	/*
 	 * Check if addr is valid.
 	 * NVRAM length at the end of memory should have been overwritten.
 	 */
 	if (addr == 0 || ((~addr >> 16) & 0xffff) == (addr & 0xffff)) {
-		DHD_ERROR(("%s: address (0x%08x) of sdpcm_shared invalid\n",
-			   __func__, addr));
+		dhd_dbg(ERROR, "%s: address (0x%08x) of sdpcm_shared invalid\n",
+			__func__, addr);
 		return -EBADE;
 	}
 
@@ -1827,10 +1847,10 @@ static int dhdsdio_readshared(dhd_bus_t *bus, sdpcm_shared_t *sh)
 	sh->msgtrace_addr = le32_to_cpu(sh->msgtrace_addr);
 
 	if ((sh->flags & SDPCM_SHARED_VERSION_MASK) != SDPCM_SHARED_VERSION) {
-		DHD_ERROR(("%s: sdpcm_shared version %d in dhd "
-			   "is different than sdpcm_shared version %d in dongle\n",
-			   __func__, SDPCM_SHARED_VERSION,
-			   sh->flags & SDPCM_SHARED_VERSION_MASK));
+		dhd_dbg(ERROR,
+			"%s: sdpcm_shared version %d in dhd is different than sdpcm_shared version %d in dongle\n",
+			__func__, SDPCM_SHARED_VERSION,
+			sh->flags & SDPCM_SHARED_VERSION_MASK);
 		return -EBADE;
 	}
 
@@ -1848,7 +1868,7 @@ static int dhdsdio_checkdied(dhd_bus_t *bus, u8 *data, uint size)
 	sdpcm_shared_t sdpcm_shared;
 	struct bcmstrbuf strbuf;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	dhd_dbg(TRACE, "%s: Enter\n", __func__);
 
 	if (data == NULL) {
 		/*
@@ -1858,8 +1878,8 @@ static int dhdsdio_checkdied(dhd_bus_t *bus, u8 *data, uint size)
 		size = msize;
 		mbuffer = data = kmalloc(msize, GFP_ATOMIC);
 		if (mbuffer == NULL) {
-			DHD_ERROR(("%s: kmalloc(%d) failed\n", __func__,
-				   msize));
+			dhd_dbg(ERROR, "%s: kmalloc(%d) failed\n",
+				__func__, msize);
 			bcmerror = -ENOMEM;
 			goto done;
 		}
@@ -1867,7 +1887,7 @@ static int dhdsdio_checkdied(dhd_bus_t *bus, u8 *data, uint size)
 
 	str = kmalloc(maxstrlen, GFP_ATOMIC);
 	if (str == NULL) {
-		DHD_ERROR(("%s: kmalloc(%d) failed\n", __func__, maxstrlen));
+		dhd_dbg(ERROR, "%s: kmalloc(%d) failed\n", __func__, maxstrlen);
 		bcmerror = -ENOMEM;
 		goto done;
 	}
@@ -1950,7 +1970,7 @@ static int dhdsdio_checkdied(dhd_bus_t *bus, u8 *data, uint size)
 	}
 
 	if (sdpcm_shared.flags & (SDPCM_SHARED_ASSERT | SDPCM_SHARED_TRAP))
-		DHD_ERROR(("%s: %s\n", __func__, strbuf.origbuf));
+		dhd_dbg(ERROR, "%s: %s\n", __func__, strbuf.origbuf);
 
 #ifdef DHD_DEBUG
 	if (sdpcm_shared.flags & SDPCM_SHARED_TRAP) {
@@ -1978,7 +1998,8 @@ static int dhdsdio_mem_dump(dhd_bus_t *bus)
 	size = bus->ramsize;
 	buf = kmalloc(size, GFP_ATOMIC);
 	if (!buf) {
-		DHD_ERROR(("%s: Out of memory (%d bytes)\n", __func__, size));
+		dhd_dbg(ERROR, "%s: Out of memory (%d bytes)\n",
+			__func__, size);
 		return -1;
 	}
 
@@ -1989,7 +2010,8 @@ static int dhdsdio_mem_dump(dhd_bus_t *bus)
 		read_size = min(MEMBLOCK, size);
 		ret = dhdsdio_membytes(bus, false, start, databuf, read_size);
 		if (ret) {
-			DHD_ERROR(("%s: Error membytes %d\n", __func__, ret));
+			dhd_dbg(ERROR, "%s: Error membytes %d\n",
+				__func__, ret);
 			kfree(buf);
 			return -1;
 		}
@@ -2004,7 +2026,7 @@ static int dhdsdio_mem_dump(dhd_bus_t *bus)
 
 	/* free buf before return !!! */
 	if (write_to_file(bus->dhd, buf, bus->ramsize)) {
-		DHD_ERROR(("%s: Error writing to files\n", __func__));
+		dhd_dbg(ERROR, "%s: Error writing to files\n", __func__);
 		return -1;
 	}
 
@@ -2095,7 +2117,7 @@ int dhdsdio_downloadvars(dhd_bus_t *bus, void *arg, int len)
 {
 	int bcmerror = 0;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	dhd_dbg(TRACE, "%s: Enter\n", __func__);
 
 	/* Basic sanity checks */
 	if (bus->dhd->up) {
@@ -2133,9 +2155,9 @@ dhdsdio_doiovar(dhd_bus_t *bus, const bcm_iovar_t *vi, u32 actionid,
 	s32 int_val = 0;
 	bool bool_val = 0;
 
-	DHD_TRACE(("%s: Enter, action %d name %s params %p plen %d arg %p "
-		"len %d val_size %d\n",
-		__func__, actionid, name, params, plen, arg, len, val_size));
+	dhd_dbg(TRACE,
+		"%s: Enter, action %d name %s params %p plen %d arg %p len %d val_size %d\n",
+		__func__, actionid, name, params, plen, arg, len, val_size);
 
 	bcmerror = bcm_iovar_lencheck(vi, arg, len, IOV_ISSET(actionid));
 	if (bcmerror != 0)
@@ -2184,12 +2206,13 @@ dhdsdio_doiovar(dhd_bus_t *bus, const bcm_iovar_t *vi, u32 actionid,
 		bus->intdis = false;
 		if (bus->dhd->up) {
 			if (bus->intr) {
-				DHD_INTR(("%s: enable SDIO device interrupts\n",
-					  __func__));
+				dhd_dbg(INTR,
+					"%s: enable SDIO device interrupts\n",
+					__func__);
 				bcmsdh_intr_enable(bus->sdh);
 			} else {
-				DHD_INTR(("%s: disable SDIO interrupts\n",
-					  __func__));
+				dhd_dbg(INTR, "%s: disable SDIO interrupts\n",
+					__func__);
 				bcmsdh_intr_disable(bus->sdh);
 			}
 		}
@@ -2254,25 +2277,27 @@ dhdsdio_doiovar(dhd_bus_t *bus, const bcm_iovar_t *vi, u32 actionid,
 			/* Do some validation */
 			dsize = set ? plen - (2 * sizeof(int)) : len;
 			if (dsize < size) {
-				DHD_ERROR(("%s: error on %s membytes, addr "
-				"0x%08x size %d dsize %d\n",
-				__func__, (set ? "set" : "get"),
-				address, size, dsize));
+				dhd_dbg(ERROR,
+					"%s: error on %s membytes, addr 0x%08x size %d dsize %d\n",
+					__func__, (set ? "set" : "get"),
+					address, size, dsize);
 				bcmerror = -EINVAL;
 				break;
 			}
 
-			DHD_INFO(("%s: Request to %s %d bytes at address "
-			"0x%08x\n",
-			__func__, (set ? "write" : "read"), size, address));
+			dhd_dbg(INFO,
+				"%s: Request to %s %d bytes at address 0x%08x\n",
+				__func__, (set ? "write" : "read"), size,
+				address);
 
 			/* If we know about SOCRAM, check for a fit */
 			if ((bus->orig_ramsize) &&
 			    ((address > bus->orig_ramsize)
 			     || (address + size > bus->orig_ramsize))) {
-				DHD_ERROR(("%s: ramsize 0x%08x doesn't have %d "
-				"bytes at 0x%08x\n",
-				__func__, bus->orig_ramsize, size, address));
+				dhd_dbg(ERROR,
+					"%s: ramsize 0x%08x doesn't have %d bytes at 0x%08x\n",
+					__func__, bus->orig_ramsize, size,
+					address);
 				bcmerror = -EINVAL;
 				break;
 			}
@@ -2499,17 +2524,17 @@ dhdsdio_doiovar(dhd_bus_t *bus, const bcm_iovar_t *vi, u32 actionid,
 #endif				/* SDTEST */
 
 	case IOV_SVAL(IOV_DEVRESET):
-		DHD_TRACE(("%s: Called set IOV_DEVRESET=%d dongle_reset=%d "
-			"busstate=%d\n",
+		dhd_dbg(TRACE,
+			"%s: Called set IOV_DEVRESET=%d dongle_reset=%d busstate=%d\n",
 			__func__, bool_val, bus->dhd->dongle_reset,
-			bus->dhd->busstate));
+			bus->dhd->busstate);
 
 		dhd_bus_devreset(bus->dhd, (u8) bool_val);
 
 		break;
 
 	case IOV_GVAL(IOV_DEVRESET):
-		DHD_TRACE(("%s: Called get IOV_DEVRESET\n", __func__));
+		dhd_dbg(TRACE, "%s: Called get IOV_DEVRESET\n", __func__);
 
 		/* Get its status */
 		int_val = (bool) bus->dhd->dongle_reset;
@@ -2564,7 +2589,7 @@ static int dhdsdio_write_vars(dhd_bus_t *bus)
 		    dhdsdio_membytes(bus, true, varaddr, vbuffer, varsize);
 #ifdef DHD_DEBUG
 		/* Verify NVRAM bytes */
-		DHD_INFO(("Compare NVRAM dl & ul; varsize=%d\n", varsize));
+		dhd_dbg(INFO, "Compare NVRAM dl & ul; varsize=%d\n", varsize);
 		nvram_ularray = kmalloc(varsize, GFP_ATOMIC);
 		if (!nvram_ularray)
 			return -ENOMEM;
@@ -2577,16 +2602,19 @@ static int dhdsdio_write_vars(dhd_bus_t *bus)
 		    dhdsdio_membytes(bus, false, varaddr, nvram_ularray,
 				     varsize);
 		if (bcmerror) {
-			DHD_ERROR(("%s: error %d on reading %d nvram bytes at "
-			"0x%08x\n", __func__, bcmerror, varsize, varaddr));
+			dhd_dbg(ERROR,
+				"%s: error %d on reading %d nvram bytes at 0x%08x\n",
+				__func__, bcmerror, varsize, varaddr);
 		}
 		/* Compare the org NVRAM with the one read from RAM */
 		if (memcmp(vbuffer, nvram_ularray, varsize)) {
-			DHD_ERROR(("%s: Downloaded NVRAM image is corrupted.\n",
-				   __func__));
+			dhd_dbg(ERROR,
+				"%s: Downloaded NVRAM image is corrupted\n",
+				__func__);
 		} else
-			DHD_ERROR(("%s: Download/Upload/Compare of NVRAM ok.\n",
-				__func__));
+			dhd_dbg(ERROR,
+				"%s: Download/Upload/Compare of NVRAM ok\n",
+				__func__);
 
 		kfree(nvram_ularray);
 #endif				/* DHD_DEBUG */
@@ -2595,9 +2623,9 @@ static int dhdsdio_write_vars(dhd_bus_t *bus)
 	}
 
 	/* adjust to the user specified RAM */
-	DHD_INFO(("Physical memory size: %d, usable memory size: %d\n",
-		  bus->orig_ramsize, bus->ramsize));
-	DHD_INFO(("Vars are at %d, orig varsize is %d\n", varaddr, varsize));
+	dhd_dbg(INFO, "Physical memory size: %d, usable memory size: %d\n",
+		bus->orig_ramsize, bus->ramsize);
+	dhd_dbg(INFO, "Vars are at %d, orig varsize is %d\n", varaddr, varsize);
 	varsize = ((bus->orig_ramsize - 4) - varaddr);
 
 	/*
@@ -2613,8 +2641,8 @@ static int dhdsdio_write_vars(dhd_bus_t *bus)
 		varsizew = cpu_to_le32(varsizew);
 	}
 
-	DHD_INFO(("New varsize is %d, length token=0x%08x\n", varsize,
-		  varsizew));
+	dhd_dbg(INFO, "New varsize is %d, length token=0x%08x\n",
+		varsize, varsizew);
 
 	/* Write the length token to the last word */
 	bcmerror = dhdsdio_membytes(bus, true, (bus->orig_ramsize - 4),
@@ -2651,15 +2679,15 @@ static int dhdsdio_download_state(dhd_bus_t *bus, bool enter)
 		regdata &= (SBTML_RESET | SBTML_REJ_MASK |
 			(SICF_CLOCK_EN << SBTML_SICF_SHIFT));
 		if ((SICF_CLOCK_EN << SBTML_SICF_SHIFT) != regdata) {
-			DHD_ERROR(("%s: SOCRAM core is down after reset?\n",
-				   __func__));
+			dhd_dbg(ERROR, "%s: SOCRAM core is down after reset?\n",
+				__func__);
 			bcmerror = -EBADE;
 			goto fail;
 		}
 
 		bcmerror = dhdsdio_write_vars(bus);
 		if (bcmerror) {
-			DHD_ERROR(("%s: no vars written to RAM\n", __func__));
+			dhd_dbg(ERROR, "%s: no vars written to RAM\n", __func__);
 			bcmerror = 0;
 		}
 
@@ -2686,7 +2714,7 @@ dhd_bus_iovar_op(dhd_pub_t *dhdp, const char *name,
 	int val_size;
 	u32 actionid;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	dhd_dbg(TRACE, "%s: Enter\n", __func__);
 
 	ASSERT(name);
 	ASSERT(len >= 0);
@@ -2719,11 +2747,12 @@ dhd_bus_iovar_op(dhd_pub_t *dhdp, const char *name,
 					    &bus->sd_divisor, sizeof(s32),
 					    false) != 0) {
 				bus->sd_divisor = -1;
-				DHD_ERROR(("%s: fail on %s get\n", __func__,
-					   name));
+				dhd_dbg(ERROR, "%s: fail on %s get\n",
+					__func__, name);
 			} else {
-				DHD_INFO(("%s: noted %s update, value now %d\n",
-					  __func__, name, bus->sd_divisor));
+				dhd_dbg(INFO,
+					"%s: noted %s update, value now %d\n",
+					__func__, name, bus->sd_divisor);
 			}
 		}
 		/* If it was a mode change, read the new one */
@@ -2732,11 +2761,12 @@ dhd_bus_iovar_op(dhd_pub_t *dhdp, const char *name,
 					    &bus->sd_mode, sizeof(s32),
 					    false) != 0) {
 				bus->sd_mode = -1;
-				DHD_ERROR(("%s: fail on %s get\n", __func__,
-					   name));
+				dhd_dbg(ERROR, "%s: fail on %s get\n",
+					__func__, name);
 			} else {
-				DHD_INFO(("%s: noted %s update, value now %d\n",
-					  __func__, name, bus->sd_mode));
+				dhd_dbg(INFO,
+					"%s: noted %s update, value now %d\n",
+					__func__, name, bus->sd_mode);
 			}
 		}
 		/* Similar check for blocksize change */
@@ -2747,12 +2777,13 @@ dhd_bus_iovar_op(dhd_pub_t *dhdp, const char *name,
 			     &bus->blocksize, sizeof(s32),
 			     false) != 0) {
 				bus->blocksize = 0;
-				DHD_ERROR(("%s: fail on %s get\n", __func__,
-					   "sd_blocksize"));
+				dhd_dbg(ERROR, "%s: fail on %s get\n",
+					__func__, "sd_blocksize");
 			} else {
-				DHD_INFO(("%s: noted %s update, value now %d\n",
-					  __func__, "sd_blocksize",
-					  bus->blocksize));
+				dhd_dbg(INFO,
+					"%s: noted %s update, value now %d\n",
+					__func__, "sd_blocksize",
+					bus->blocksize);
 			}
 		}
 		bus->roundup = min(max_roundup, bus->blocksize);
@@ -2766,8 +2797,8 @@ dhd_bus_iovar_op(dhd_pub_t *dhdp, const char *name,
 		goto exit;
 	}
 
-	DHD_CTL(("%s: %s %s, len %d plen %d\n", __func__,
-		 name, (set ? "set" : "get"), len, plen));
+	dhd_dbg(CTL, "%s: %s %s, len %d plen %d\n",
+		__func__, name, (set ? "set" : "get"), len, plen);
 
 	/* set up 'params' pointer in case this is a set command so that
 	 * the convenience int and bool code can be common to set and get
@@ -2801,7 +2832,7 @@ void dhd_bus_stop(struct dhd_bus *bus, bool enforce_mutex)
 	uint retries;
 	int err;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	dhd_dbg(TRACE, "%s: Enter\n", __func__);
 
 	if (enforce_mutex)
 		dhd_os_sdlock(bus->dhd);
@@ -2828,12 +2859,12 @@ void dhd_bus_stop(struct dhd_bus *bus, bool enforce_mutex)
 				 (saveclk | SBSDIO_FORCE_HT), &err);
 	}
 	if (err) {
-		DHD_ERROR(("%s: Failed to force clock for F2: err %d\n",
-			   __func__, err));
+		dhd_dbg(ERROR, "%s: Failed to force clock for F2: err %d\n",
+			__func__, err);
 	}
 
 	/* Turn off the bus (F2), free any pending packets */
-	DHD_INTR(("%s: disable SDIO interrupts\n", __func__));
+	dhd_dbg(INTR, "%s: disable SDIO interrupts\n", __func__);
 	bcmsdh_intr_disable(bus->sdh);
 	bcmsdh_cfg_write(bus->sdh, SDIO_FUNC_0, SDIOD_CCCR_IOEN,
 			 SDIO_FUNC_ENABLE_1, NULL);
@@ -2877,7 +2908,7 @@ int dhd_bus_init(dhd_pub_t *dhdp, bool enforce_mutex)
 	int err, ret = 0;
 	u8 saveclk;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	dhd_dbg(TRACE, "%s: Enter\n", __func__);
 
 	ASSERT(bus->dhd);
 	if (!bus->dhd)
@@ -2900,8 +2931,8 @@ int dhd_bus_init(dhd_pub_t *dhdp, bool enforce_mutex)
 				 (saveclk | SBSDIO_FORCE_HT), &err);
 	}
 	if (err) {
-		DHD_ERROR(("%s: Failed to force clock for F2: err %d\n",
-			   __func__, err));
+		dhd_dbg(ERROR, "%s: Failed to force clock for F2: err %d\n",
+			__func__, err);
 		goto exit;
 	}
 
@@ -2921,8 +2952,8 @@ int dhd_bus_init(dhd_pub_t *dhdp, bool enforce_mutex)
 		    bcmsdh_cfg_read(bus->sdh, SDIO_FUNC_0, SDIOD_CCCR_IORDY,
 				    NULL);
 
-	DHD_INFO(("%s: enable 0x%02x, ready 0x%02x (waited %uus)\n",
-		  __func__, enable, ready, tmo.elapsed));
+	dhd_dbg(INFO, "%s: enable 0x%02x, ready 0x%02x (waited %uus)\n",
+		__func__, enable, ready, tmo.elapsed);
 
 	/* If F2 successfully enabled, set core and enable interrupts */
 	if (ready == enable) {
@@ -2942,11 +2973,12 @@ int dhd_bus_init(dhd_pub_t *dhdp, bool enforce_mutex)
 
 		bus->intdis = false;
 		if (bus->intr) {
-			DHD_INTR(("%s: enable SDIO device interrupts\n",
-				  __func__));
+			dhd_dbg(INTR, "%s: enable SDIO device interrupts\n",
+				__func__);
 			bcmsdh_intr_enable(bus->sdh);
 		} else {
-			DHD_INTR(("%s: disable SDIO interrupts\n", __func__));
+			dhd_dbg(INTR, "%s: disable SDIO interrupts\n",
+				__func__);
 			bcmsdh_intr_disable(bus->sdh);
 		}
 
@@ -2983,9 +3015,10 @@ static void dhdsdio_rxfail(dhd_bus_t *bus, bool abort, bool rtx)
 	u8 hi, lo;
 	int err;
 
-	DHD_ERROR(("%s: %sterminate frame%s\n", __func__,
-		   (abort ? "abort command, " : ""),
-		   (rtx ? ", send NAK" : "")));
+	dhd_dbg(ERROR, "%s: %sterminate frame%s\n",
+		__func__,
+		abort ? "abort command, " : "",
+		rtx ? ", send NAK" : "");
 
 	if (abort)
 		bcmsdh_abort(sdh, SDIO_FUNC_2);
@@ -3006,19 +3039,19 @@ static void dhdsdio_rxfail(dhd_bus_t *bus, bool abort, bool rtx)
 			break;
 
 		if ((hi > (lastrbc >> 8)) && (lo > (lastrbc & 0x00ff))) {
-			DHD_ERROR(("%s: count growing: last 0x%04x now "
-				"0x%04x\n",
-				__func__, lastrbc, ((hi << 8) + lo)));
+			dhd_dbg(ERROR,
+				"%s: count growing: last 0x%04x now 0x%04x\n",
+				__func__, lastrbc, ((hi << 8) + lo));
 		}
 		lastrbc = (hi << 8) + lo;
 	}
 
 	if (!retries) {
-		DHD_ERROR(("%s: count never zeroed: last 0x%04x\n",
-			   __func__, lastrbc));
+		dhd_dbg(ERROR, "%s: count never zeroed: last 0x%04x\n",
+			__func__, lastrbc);
 	} else {
-		DHD_INFO(("%s: flush took %d iterations\n", __func__,
-			  (0xffff - retries)));
+		dhd_dbg(INFO, "%s: flush took %d iterations\n",
+			__func__, (0xffff - retries));
 	}
 
 	if (rtx) {
@@ -3045,7 +3078,7 @@ dhdsdio_read_control(dhd_bus_t *bus, u8 *hdr, uint len, uint doff)
 
 	int sdret;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	dhd_dbg(TRACE, "%s: Enter\n", __func__);
 
 	/* Control data already received in aligned rxctl */
 	if ((bus->bus == SPI_BUS) && (!bus->usebufpool))
@@ -3091,17 +3124,18 @@ dhdsdio_read_control(dhd_bus_t *bus, u8 *hdr, uint len, uint doff)
 
 	/* Drop if the read is too big or it exceeds our maximum */
 	if ((rdlen + firstread) > bus->dhd->maxctl) {
-		DHD_ERROR(("%s: %d-byte control read exceeds %d-byte buffer\n",
-			   __func__, rdlen, bus->dhd->maxctl));
+		dhd_dbg(ERROR,
+			"%s: %d-byte control read exceeds %d-byte buffer\n",
+			__func__, rdlen, bus->dhd->maxctl);
 		bus->dhd->rx_errors++;
 		dhdsdio_rxfail(bus, false, false);
 		goto done;
 	}
 
 	if ((len - doff) > bus->dhd->maxctl) {
-		DHD_ERROR(("%s: %d-byte ctl frame (%d-byte ctl data) exceeds "
-			"%d-byte limit\n",
-			__func__, len, (len - doff), bus->dhd->maxctl));
+		dhd_dbg(ERROR,
+			"%s: %d-byte ctl frame (%d-byte ctl data) exceeds %d-byte limit\n",
+			__func__, len, (len - doff), bus->dhd->maxctl);
 		bus->dhd->rx_errors++;
 		bus->rx_toolong++;
 		dhdsdio_rxfail(bus, false, false);
@@ -3117,8 +3151,8 @@ dhdsdio_read_control(dhd_bus_t *bus, u8 *hdr, uint len, uint doff)
 
 	/* Control frame failures need retransmission */
 	if (sdret < 0) {
-		DHD_ERROR(("%s: read %d control bytes failed: %d\n",
-			   __func__, rdlen, sdret));
+		dhd_dbg(ERROR, "%s: read %d control bytes failed: %d\n",
+			__func__, rdlen, sdret);
 		bus->rxc_errors++;	/* dhd.rx_ctlerrs is higher level */
 		dhdsdio_rxfail(bus, true, true);
 		goto done;
@@ -3160,8 +3194,8 @@ static u8 dhdsdio_rxglom(dhd_bus_t *bus, u8 rxseq)
 	/* If packets, issue read(s) and send up packet chain */
 	/* Return sequence numbers consumed? */
 
-	DHD_TRACE(("dhdsdio_rxglom: start: glomd %p glom %p\n", bus->glomd,
-		   bus->glom));
+	dhd_dbg(TRACE, "%s: start: glomd %p glom %p\n",
+		__func__, bus->glomd, bus->glom);
 
 	/* If there's a descriptor, generate the packet chain */
 	if (bus->glomd) {
@@ -3171,8 +3205,9 @@ static u8 dhdsdio_rxglom(dhd_bus_t *bus, u8 rxseq)
 		dlen = (u16) (bus->glomd->len);
 		dptr = bus->glomd->data;
 		if (!dlen || (dlen & 1)) {
-			DHD_ERROR(("%s: bad glomd len(%d), ignore descriptor\n",
-			__func__, dlen));
+			dhd_dbg(ERROR,
+				"%s: bad glomd len(%d), ignore descriptor\n",
+				__func__, dlen);
 			dlen = 0;
 		}
 
@@ -3183,14 +3218,16 @@ static u8 dhdsdio_rxglom(dhd_bus_t *bus, u8 rxseq)
 			dptr += sizeof(u16);
 			if ((sublen < SDPCM_HDRLEN) ||
 			    ((num == 0) && (sublen < (2 * SDPCM_HDRLEN)))) {
-				DHD_ERROR(("%s: descriptor len %d bad: %d\n",
-					   __func__, num, sublen));
+				dhd_dbg(ERROR,
+					"%s: descriptor len %d bad: %d\n",
+					__func__, num, sublen);
 				pnext = NULL;
 				break;
 			}
 			if (sublen % DHD_SDALIGN) {
-				DHD_ERROR(("%s: sublen %d not multiple of %d\n",
-				__func__, sublen, DHD_SDALIGN));
+				dhd_dbg(ERROR,
+					"%s: sublen %d not multiple of %d\n",
+					__func__, sublen, DHD_SDALIGN);
 				usechain = false;
 			}
 			totlen += sublen;
@@ -3206,9 +3243,9 @@ static u8 dhdsdio_rxglom(dhd_bus_t *bus, u8 rxseq)
 			/* Allocate/chain packet for next subframe */
 			pnext = bcm_pkt_buf_get_skb(sublen + DHD_SDALIGN);
 			if (pnext == NULL) {
-				DHD_ERROR(("%s: bcm_pkt_buf_get_skb failed, "
-					"num %d len %d\n", __func__,
-					num, sublen));
+				dhd_dbg(ERROR,
+					"%s: bcm_pkt_buf_get_skb failed, num %d len %d\n",
+					__func__, num, sublen);
 				break;
 			}
 			ASSERT(!(pnext->prev));
@@ -3228,13 +3265,15 @@ static u8 dhdsdio_rxglom(dhd_bus_t *bus, u8 rxseq)
 		/* If all allocations succeeded, save packet chain
 			 in bus structure */
 		if (pnext) {
-			DHD_GLOM(("%s: allocated %d-byte packet chain for %d "
-				"subframes\n", __func__, totlen, num));
+			dhd_dbg(GLOM,
+				"%s: allocated %d-byte packet chain for %d subframes\n",
+				__func__, totlen, num);
 			if (DHD_GLOM_ON() && bus->nextlen) {
 				if (totlen != bus->nextlen) {
-					DHD_GLOM(("%s: glomdesc mismatch: nextlen %d glomdesc %d " "rxseq %d\n",
+					dhd_dbg(GLOM,
+						"%s: glomdesc mismatch: nextlen %d glomdesc %d rxseq %d\n",
 						__func__, bus->nextlen,
-						totlen, rxseq));
+						totlen, rxseq);
 				}
 			}
 			bus->glom = pfirst;
@@ -3258,12 +3297,13 @@ static u8 dhdsdio_rxglom(dhd_bus_t *bus, u8 rxseq)
 		 or had one from before */
 	if (bus->glom) {
 		if (DHD_GLOM_ON()) {
-			DHD_GLOM(("%s: try superframe read, packet chain:\n",
-				__func__));
+			dhd_dbg(GLOM,
+				"%s: try superframe read, packet chain:\n",
+				__func__);
 			for (pnext = bus->glom; pnext; pnext = pnext->next) {
-				DHD_GLOM(("    %p: %p len 0x%04x (%d)\n",
-					  pnext, (u8 *) (pnext->data),
-					  pnext->len, pnext->len));
+				dhd_dbg(GLOM, "    %p: %p len 0x%04x (%d)\n",
+					pnext, (u8 *) (pnext->data),
+					pnext->len, pnext->len);
 			}
 		}
 
@@ -3287,14 +3327,16 @@ static u8 dhdsdio_rxglom(dhd_bus_t *bus, u8 rxseq)
 			sublen = (u16) bcm_pktfrombuf(pfirst, 0, dlen,
 						bus->dataptr);
 			if (sublen != dlen) {
-				DHD_ERROR(("%s: FAILED TO COPY, dlen %d sublen %d\n",
-					__func__, dlen, sublen));
+				dhd_dbg(ERROR,
+					"%s: FAILED TO COPY, dlen %d sublen %d\n",
+					__func__, dlen, sublen);
 				errcode = -1;
 			}
 			pnext = NULL;
 		} else {
-			DHD_ERROR(("COULDN'T ALLOC %d-BYTE GLOM, FORCE FAILURE\n",
-				dlen));
+			dhd_dbg(ERROR,
+				"COULDN'T ALLOC %d-BYTE GLOM, FORCE FAILURE\n",
+				dlen);
 			errcode = -1;
 		}
 		bus->f2rxdata++;
@@ -3302,8 +3344,8 @@ static u8 dhdsdio_rxglom(dhd_bus_t *bus, u8 rxseq)
 
 		/* On failure, kill the superframe, allow a couple retries */
 		if (errcode < 0) {
-			DHD_ERROR(("%s: glom read of %d bytes failed: %d\n",
-				   __func__, dlen, errcode));
+			dhd_dbg(ERROR, "%s: glom read of %d bytes failed: %d\n",
+				__func__, dlen, errcode);
 			bus->dhd->rx_errors++;
 
 			if (bus->glomerr++ < 3) {
@@ -3336,8 +3378,8 @@ static u8 dhdsdio_rxglom(dhd_bus_t *bus, u8 rxseq)
 		seq = SDPCM_PACKET_SEQUENCE(&dptr[SDPCM_FRAMETAG_LEN]);
 		bus->nextlen = dptr[SDPCM_FRAMETAG_LEN + SDPCM_NEXTLEN_OFFSET];
 		if ((bus->nextlen << 4) > MAX_RX_DATASZ) {
-			DHD_INFO(("%s: nextlen too large (%d) seq %d\n",
-				__func__, bus->nextlen, seq));
+			dhd_dbg(INFO, "%s: nextlen too large (%d) seq %d\n",
+				__func__, bus->nextlen, seq);
 			bus->nextlen = 0;
 		}
 		doff = SDPCM_DOFFSET_VALUE(&dptr[SDPCM_FRAMETAG_LEN]);
@@ -3345,47 +3387,51 @@ static u8 dhdsdio_rxglom(dhd_bus_t *bus, u8 rxseq)
 
 		errcode = 0;
 		if ((u16)~(sublen ^ check)) {
-			DHD_ERROR(("%s (superframe): HW hdr error: len/check "
-				"0x%04x/0x%04x\n", __func__, sublen, check));
+			dhd_dbg(ERROR,
+				"%s (superframe): HW hdr error: len/check 0x%04x/0x%04x\n",
+				__func__, sublen, check);
 			errcode = -1;
 		} else if (roundup(sublen, bus->blocksize) != dlen) {
-			DHD_ERROR(("%s (superframe): len 0x%04x, rounded "
-				"0x%04x, expect 0x%04x\n",
+			dhd_dbg(ERROR,
+				"%s (superframe): len 0x%04x, rounded 0x%04x, expect 0x%04x\n",
 				__func__, sublen,
-				roundup(sublen, bus->blocksize), dlen));
+				roundup(sublen, bus->blocksize), dlen);
 			errcode = -1;
 		} else if (SDPCM_PACKET_CHANNEL(&dptr[SDPCM_FRAMETAG_LEN]) !=
 			   SDPCM_GLOM_CHANNEL) {
-			DHD_ERROR(("%s (superframe): bad channel %d\n",
-				   __func__,
-				   SDPCM_PACKET_CHANNEL(&dptr
-							[SDPCM_FRAMETAG_LEN])));
+			dhd_dbg(ERROR, "%s (superframe): bad channel %d\n",
+				__func__,
+				SDPCM_PACKET_CHANNEL(&dptr
+						     [SDPCM_FRAMETAG_LEN]));
 			errcode = -1;
 		} else if (SDPCM_GLOMDESC(&dptr[SDPCM_FRAMETAG_LEN])) {
-			DHD_ERROR(("%s (superframe): got second descriptor?\n",
-				   __func__));
+			dhd_dbg(ERROR,
+				"%s (superframe): got second descriptor?\n",
+				__func__);
 			errcode = -1;
 		} else if ((doff < SDPCM_HDRLEN) ||
 			   (doff > (pfirst->len - SDPCM_HDRLEN))) {
-			DHD_ERROR(("%s (superframe): Bad data offset %d: HW %d "
-				"pkt %d min %d\n",
-				__func__, doff, sublen,
-				pfirst->len, SDPCM_HDRLEN));
+			dhd_dbg(ERROR,
+				"%s (superframe): Bad data offset %d: HW %d pkt %d min %d\n",
+				__func__, doff, sublen, pfirst->len,
+				SDPCM_HDRLEN);
 			errcode = -1;
 		}
 
 		/* Check sequence number of superframe SW header */
 		if (rxseq != seq) {
-			DHD_INFO(("%s: (superframe) rx_seq %d, expected %d\n",
-				  __func__, seq, rxseq));
+			dhd_dbg(INFO,
+				"%s: (superframe) rx_seq %d, expected %d\n",
+				__func__, seq, rxseq);
 			bus->rx_badseq++;
 			rxseq = seq;
 		}
 
 		/* Check window for sanity */
 		if ((u8) (txmax - bus->tx_seq) > 0x40) {
-			DHD_ERROR(("%s: unlikely tx max %d with tx_seq %d\n",
-				__func__, txmax, bus->tx_seq));
+			dhd_dbg(ERROR,
+				"%s: unlikely tx max %d with tx_seq %d\n",
+				__func__, txmax, bus->tx_seq);
 			txmax = bus->tx_seq + 2;
 		}
 		bus->tx_max = txmax;
@@ -3412,24 +3458,26 @@ static u8 dhdsdio_rxglom(dhd_bus_t *bus, u8 rxseq)
 #endif
 
 			if ((u16)~(sublen ^ check)) {
-				DHD_ERROR(("%s (subframe %d): HW hdr error: "
-					   "len/check 0x%04x/0x%04x\n",
-					   __func__, num, sublen, check));
+				dhd_dbg(ERROR,
+					"%s (subframe %d): HW hdr error: len/check 0x%04x/0x%04x\n",
+					__func__, num, sublen, check);
 				errcode = -1;
 			} else if ((sublen > dlen) || (sublen < SDPCM_HDRLEN)) {
-				DHD_ERROR(("%s (subframe %d): length mismatch: "
-					   "len 0x%04x, expect 0x%04x\n",
-					   __func__, num, sublen, dlen));
+				dhd_dbg(ERROR,
+					"%s (subframe %d): length mismatch: len 0x%04x, expect 0x%04x\n",
+					__func__, num, sublen, dlen);
 				errcode = -1;
 			} else if ((chan != SDPCM_DATA_CHANNEL) &&
 				   (chan != SDPCM_EVENT_CHANNEL)) {
-				DHD_ERROR(("%s (subframe %d): bad channel %d\n",
-					   __func__, num, chan));
+				dhd_dbg(ERROR,
+					"%s (subframe %d): bad channel %d\n",
+					__func__, num, chan);
 				errcode = -1;
 			} else if ((doff < SDPCM_HDRLEN) || (doff > sublen)) {
-				DHD_ERROR(("%s (subframe %d): Bad data offset %d: HW %d min %d\n",
+				dhd_dbg(ERROR,
+					"%s (subframe %d): Bad data offset %d: HW %d min %d\n",
 					__func__, num, doff, sublen,
-					SDPCM_HDRLEN));
+					SDPCM_HDRLEN);
 				errcode = -1;
 			}
 		}
@@ -3470,17 +3518,17 @@ static u8 dhdsdio_rxglom(dhd_bus_t *bus, u8 rxseq)
 			seq = SDPCM_PACKET_SEQUENCE(&dptr[SDPCM_FRAMETAG_LEN]);
 			doff = SDPCM_DOFFSET_VALUE(&dptr[SDPCM_FRAMETAG_LEN]);
 
-			DHD_GLOM(("%s: Get subframe %d, %p(%p/%d), sublen %d "
-				"chan %d seq %d\n",
+			dhd_dbg(GLOM,
+				"%s: Get subframe %d, %p(%p/%d), sublen %d chan %d seq %d\n",
 				__func__, num, pfirst, pfirst->data,
-				pfirst->len, sublen, chan, seq));
+				pfirst->len, sublen, chan, seq);
 
 			ASSERT((chan == SDPCM_DATA_CHANNEL)
 			       || (chan == SDPCM_EVENT_CHANNEL));
 
 			if (rxseq != seq) {
-				DHD_GLOM(("%s: rx_seq %d, expected %d\n",
-					  __func__, seq, rxseq));
+				dhd_dbg(GLOM, "%s: rx_seq %d, expected %d\n",
+					__func__, seq, rxseq);
 				bus->rx_badseq++;
 				rxseq = seq;
 			}
@@ -3506,8 +3554,8 @@ static u8 dhdsdio_rxglom(dhd_bus_t *bus, u8 rxseq)
 				continue;
 			} else if (dhd_prot_hdrpull(bus->dhd, &ifidx, pfirst) !=
 				   0) {
-				DHD_ERROR(("%s: rx protocol error\n",
-					   __func__));
+				dhd_dbg(ERROR, "%s: rx protocol error\n",
+					__func__);
 				bus->dhd->rx_errors++;
 				bcm_pkt_buf_free_skb(pfirst);
 				if (plast) {
@@ -3527,11 +3575,11 @@ static u8 dhdsdio_rxglom(dhd_bus_t *bus, u8 rxseq)
 
 #ifdef DHD_DEBUG
 			if (DHD_GLOM_ON()) {
-				DHD_GLOM(("%s subframe %d to stack, %p(%p/%d) "
-				"nxt/lnk %p/%p\n",
-				__func__, num, pfirst, pfirst->data,
-				pfirst->len, pfirst->next,
-				pfirst->prev));
+				dhd_dbg(GLOM,
+					"%s subframe %d to stack, %p(%p/%d) nxt/lnk %p/%p\n",
+					__func__, num, pfirst, pfirst->data,
+					pfirst->len, pfirst->next,
+					pfirst->prev);
 				print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
 						pfirst->data,
 						min_t(int, pfirst->len, 32));
@@ -3577,7 +3625,7 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 	bool sdtest = false;	/* To limit message spew from test mode */
 #endif
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	dhd_dbg(TRACE, "%s: Enter\n", __func__);
 
 	ASSERT(maxframes);
 
@@ -3599,10 +3647,11 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 		/* Handle glomming separately */
 		if (bus->glom || bus->glomd) {
 			u8 cnt;
-			DHD_GLOM(("%s: calling rxglom: glomd %p, glom %p\n",
-				  __func__, bus->glomd, bus->glom));
+			dhd_dbg(GLOM, "%s: calling rxglom: glomd %p, glom %p\n",
+				__func__, bus->glomd, bus->glom);
 			cnt = dhdsdio_rxglom(bus, rxseq);
-			DHD_GLOM(("%s: rxglom returned %d\n", __func__, cnt));
+			dhd_dbg(GLOM, "%s: rxglom returned %d\n",
+				__func__, cnt);
 			rxseq += cnt - 1;
 			rxleft = (rxleft > cnt) ? (rxleft - cnt) : 1;
 			continue;
@@ -3675,9 +3724,9 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 					/* Control frame failures need
 					 retransmission */
 					if (sdret < 0) {
-						DHD_ERROR(("%s: read %d control bytes failed: %d\n",
-							__func__,
-							rdlen, sdret));
+						dhd_dbg(ERROR,
+							"%s: read %d control bytes failed: %d\n",
+							__func__, rdlen, sdret);
 						/* dhd.rx_ctlerrs is higher */
 						bus->rxc_errors++;
 						dhd_os_sdunlock_rxq(bus->dhd);
@@ -3690,11 +3739,10 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 				} else {
 					/* Give up on data,
 					request rtx of events */
-					DHD_ERROR(("%s (nextlen): "
-						   "bcm_pkt_buf_get_skb failed:"
-						   " len %d rdlen %d expected"
-						   " rxseq %d\n", __func__,
-						   len, rdlen, rxseq));
+					dhd_dbg(ERROR,
+						"%s (nextlen): bcm_pkt_buf_get_skb failed:"
+						   " len %d rdlen %d expected rxseq %d\n",
+						__func__, len, rdlen, rxseq);
 					/* Just go try again w/normal
 					header read */
 					dhd_os_sdunlock_rxq(bus->dhd);
@@ -3717,8 +3765,9 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 				ASSERT(sdret != -BCME_PENDING);
 
 				if (sdret < 0) {
-					DHD_ERROR(("%s (nextlen): read %d bytes failed: %d\n",
-						__func__, rdlen, sdret));
+					dhd_dbg(ERROR,
+						"%s (nextlen): read %d bytes failed: %d\n",
+						__func__, rdlen, sdret);
 					bcm_pkt_buf_free_skb(pkt);
 					bus->dhd->rx_errors++;
 					dhd_os_sdunlock_rxq(bus->dhd);
@@ -3744,18 +3793,18 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 
 			/* All zeros means readahead info was bad */
 			if (!(len | check)) {
-				DHD_INFO(("%s (nextlen): read zeros in HW "
-					"header???\n", __func__));
+				dhd_dbg(INFO,
+					"%s (nextlen): read zeros in HW header???\n",
+					__func__);
 				dhdsdio_pktfree2(bus, pkt);
 				continue;
 			}
 
 			/* Validate check bytes */
 			if ((u16)~(len ^ check)) {
-				DHD_ERROR(("%s (nextlen): HW hdr error:"
-					" nextlen/len/check"
-					" 0x%04x/0x%04x/0x%04x\n",
-					__func__, nextlen, len, check));
+				dhd_dbg(ERROR,
+					"%s (nextlen): HW hdr error: nextlen/len/check 0x%04x/0x%04x/0x%04x\n",
+					__func__, nextlen, len, check);
 				bus->rx_badhdr++;
 				dhdsdio_rxfail(bus, false, false);
 				dhdsdio_pktfree2(bus, pkt);
@@ -3764,8 +3813,9 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 
 			/* Validate frame length */
 			if (len < SDPCM_HDRLEN) {
-				DHD_ERROR(("%s (nextlen): HW hdr length "
-					"invalid: %d\n", __func__, len));
+				dhd_dbg(ERROR,
+					"%s (nextlen): HW hdr length invalid: %d\n",
+					__func__, len);
 				dhdsdio_pktfree2(bus, pkt);
 				continue;
 			}
@@ -3775,11 +3825,10 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 			if (len_consistent) {
 				/* Mismatch, force retry w/normal
 					header (may be >4K) */
-				DHD_ERROR(("%s (nextlen): mismatch, "
-					"nextlen %d len %d rnd %d; "
-					"expected rxseq %d\n",
-					__func__, nextlen,
-					len, roundup(len, 16), rxseq));
+				dhd_dbg(ERROR,
+					"%s (nextlen): mismatch, nextlen %d len %d rnd %d; expected rxseq %d\n",
+					__func__, nextlen, len,
+					roundup(len, 16), rxseq);
 				dhdsdio_rxfail(bus, true, (bus->bus != SPI_BUS));
 				dhdsdio_pktfree2(bus, pkt);
 				continue;
@@ -3799,8 +3848,9 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 			    bus->rxhdr[SDPCM_FRAMETAG_LEN +
 				       SDPCM_NEXTLEN_OFFSET];
 			if ((bus->nextlen << 4) > MAX_RX_DATASZ) {
-				DHD_INFO(("%s (nextlen): got frame w/nextlen too large" " (%d), seq %d\n",
-					__func__, bus->nextlen, seq));
+				dhd_dbg(INFO,
+					"%s (nextlen): got frame w/nextlen too large (%d), seq %d\n",
+					__func__, bus->nextlen, seq);
 				bus->nextlen = 0;
 			}
 
@@ -3823,17 +3873,18 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 
 			/* Check and update sequence number */
 			if (rxseq != seq) {
-				DHD_INFO(("%s (nextlen): rx_seq %d, expected "
-					"%d\n", __func__, seq, rxseq));
+				dhd_dbg(INFO,
+					"%s (nextlen): rx_seq %d, expected %d\n",
+					__func__, seq, rxseq);
 				bus->rx_badseq++;
 				rxseq = seq;
 			}
 
 			/* Check window for sanity */
 			if ((u8) (txmax - bus->tx_seq) > 0x40) {
-				DHD_ERROR(("%s: got unlikely tx max %d with "
-					"tx_seq %d\n",
-					__func__, txmax, bus->tx_seq));
+				dhd_dbg(ERROR,
+					"%s: got unlikely tx max %d with tx_seq %d\n",
+					__func__, txmax, bus->tx_seq);
 				txmax = bus->tx_seq + 2;
 			}
 			bus->tx_max = txmax;
@@ -3855,8 +3906,9 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 					dhdsdio_read_control(bus, rxbuf, len,
 							     doff);
 				} else {
-					DHD_ERROR(("%s (nextlen): readahead on control" " packet %d?\n",
-						__func__, seq));
+					dhd_dbg(ERROR,
+						"%s (nextlen): readahead on control packet %d?\n",
+						__func__, seq);
 					/* Force retry w/normal header read */
 					bus->nextlen = 0;
 					dhdsdio_rxfail(bus, false, true);
@@ -3866,15 +3918,17 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 			}
 
 			if ((bus->bus == SPI_BUS) && !bus->usebufpool) {
-				DHD_ERROR(("Received %d bytes on %d channel. Running out of " "rx pktbuf's or not yet malloced.\n",
-					len, chan));
+				dhd_dbg(ERROR,
+					"Received %d bytes on %d channel. Running out of rx pktbuf's or not yet malloced.\n",
+					len, chan);
 				continue;
 			}
 
 			/* Validate data offset */
 			if ((doff < SDPCM_HDRLEN) || (doff > len)) {
-				DHD_ERROR(("%s (nextlen): bad data offset %d: HW len %d min %d\n",
-					__func__, doff, len, SDPCM_HDRLEN));
+				dhd_dbg(ERROR,
+					"%s (nextlen): bad data offset %d: HW len %d min %d\n",
+					__func__, doff, len, SDPCM_HDRLEN);
 				dhdsdio_rxfail(bus, false, false);
 				dhdsdio_pktfree2(bus, pkt);
 				continue;
@@ -3895,8 +3949,8 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 		ASSERT(sdret != -BCME_PENDING);
 
 		if (sdret < 0) {
-			DHD_ERROR(("%s: RXHEADER FAILED: %d\n", __func__,
-				   sdret));
+			dhd_dbg(ERROR, "%s: RXHEADER FAILED: %d\n",
+				__func__, sdret);
 			bus->rx_hdrfail++;
 			dhdsdio_rxfail(bus, true, true);
 			continue;
@@ -3921,8 +3975,9 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 
 		/* Validate check bytes */
 		if ((u16) ~(len ^ check)) {
-			DHD_ERROR(("%s: HW hdr err: len/check 0x%04x/0x%04x\n",
-				__func__, len, check));
+			dhd_dbg(ERROR,
+				"%s: HW hdr err: len/check 0x%04x/0x%04x\n",
+				__func__, len, check);
 			bus->rx_badhdr++;
 			dhdsdio_rxfail(bus, false, false);
 			continue;
@@ -3930,8 +3985,8 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 
 		/* Validate frame length */
 		if (len < SDPCM_HDRLEN) {
-			DHD_ERROR(("%s: HW hdr length invalid: %d\n",
-				   __func__, len));
+			dhd_dbg(ERROR, "%s: HW hdr length invalid: %d\n",
+				__func__, len);
 			continue;
 		}
 
@@ -3943,9 +3998,9 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 
 		/* Validate data offset */
 		if ((doff < SDPCM_HDRLEN) || (doff > len)) {
-			DHD_ERROR(("%s: Bad data offset %d: HW len %d, min %d "
-				"seq %d\n",
-				__func__, doff, len, SDPCM_HDRLEN, seq));
+			dhd_dbg(ERROR,
+				"%s: Bad data offset %d: HW len %d, min %d seq %d\n",
+				__func__, doff, len, SDPCM_HDRLEN, seq);
 			bus->rx_badhdr++;
 			ASSERT(0);
 			dhdsdio_rxfail(bus, false, false);
@@ -3956,9 +4011,9 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 		bus->nextlen =
 		    bus->rxhdr[SDPCM_FRAMETAG_LEN + SDPCM_NEXTLEN_OFFSET];
 		if ((bus->nextlen << 4) > MAX_RX_DATASZ) {
-			DHD_INFO(("%s (nextlen): got frame w/nextlen too large "
-				"(%d), seq %d\n",
-				__func__, bus->nextlen, seq));
+			dhd_dbg(INFO,
+				"%s (nextlen): got frame w/nextlen too large (%d), seq %d\n",
+				__func__, bus->nextlen, seq);
 			bus->nextlen = 0;
 		}
 
@@ -3978,16 +4033,17 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 
 		/* Check and update sequence number */
 		if (rxseq != seq) {
-			DHD_INFO(("%s: rx_seq %d, expected %d\n", __func__,
-				  seq, rxseq));
+			dhd_dbg(INFO, "%s: rx_seq %d, expected %d\n",
+				__func__, seq, rxseq);
 			bus->rx_badseq++;
 			rxseq = seq;
 		}
 
 		/* Check window for sanity */
 		if ((u8) (txmax - bus->tx_seq) > 0x40) {
-			DHD_ERROR(("%s: unlikely tx max %d with tx_seq %d\n",
-				__func__, txmax, bus->tx_seq));
+			dhd_dbg(ERROR,
+				"%s: unlikely tx max %d with tx_seq %d\n",
+				__func__, txmax, bus->tx_seq);
 			txmax = bus->tx_seq + 2;
 		}
 		bus->tx_max = txmax;
@@ -4023,8 +4079,8 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 
 		if ((rdlen + firstread) > MAX_RX_DATASZ) {
 			/* Too long -- skip this frame */
-			DHD_ERROR(("%s: too long: len %d rdlen %d\n",
-				   __func__, len, rdlen));
+			dhd_dbg(ERROR, "%s: too long: len %d rdlen %d\n",
+				__func__, len, rdlen);
 			bus->dhd->rx_errors++;
 			bus->rx_toolong++;
 			dhdsdio_rxfail(bus, false, false);
@@ -4035,8 +4091,9 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 		pkt = bcm_pkt_buf_get_skb(rdlen + firstread + DHD_SDALIGN);
 		if (!pkt) {
 			/* Give up on data, request rtx of events */
-			DHD_ERROR(("%s: bcm_pkt_buf_get_skb failed: rdlen %d "
-				"chan %d\n", __func__, rdlen, chan));
+			dhd_dbg(ERROR,
+				"%s: bcm_pkt_buf_get_skb failed: rdlen %d chan %d\n",
+				__func__, rdlen, chan);
 			bus->dhd->rx_dropped++;
 			dhd_os_sdunlock_rxq(bus->dhd);
 			dhdsdio_rxfail(bus, false, RETRYCHAN(chan));
@@ -4059,13 +4116,11 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 		ASSERT(sdret != -BCME_PENDING);
 
 		if (sdret < 0) {
-			DHD_ERROR(("%s: read %d %s bytes failed: %d\n",
-				   __func__, rdlen,
-				   ((chan ==
-				     SDPCM_EVENT_CHANNEL) ? "event" : ((chan ==
-					SDPCM_DATA_CHANNEL)
-				       ? "data" : "test")),
-				   sdret));
+			dhd_dbg(ERROR, "%s: read %d %s bytes failed: %d\n",
+				__func__, rdlen,
+				chan == SDPCM_EVENT_CHANNEL ? "event" :
+				chan == SDPCM_DATA_CHANNEL ? "data" : "test",
+				sdret);
 			dhd_os_sdlock_rxq(bus->dhd);
 			bcm_pkt_buf_free_skb(pkt);
 			dhd_os_sdunlock_rxq(bus->dhd);
@@ -4090,8 +4145,9 @@ deliver:
 		/* Save superframe descriptor and allocate packet frame */
 		if (chan == SDPCM_GLOM_CHANNEL) {
 			if (SDPCM_GLOMDESC(&bus->rxhdr[SDPCM_FRAMETAG_LEN])) {
-				DHD_GLOM(("%s: glom descriptor, %d bytes:\n",
-					__func__, len));
+				dhd_dbg(GLOM,
+					"%s: glom descriptor, %d bytes:\n",
+					__func__, len);
 #ifdef DHD_DEBUG
 				if (DHD_GLOM_ON()) {
 					printk(KERN_DEBUG "Glom Data:\n");
@@ -4105,8 +4161,9 @@ deliver:
 				skb_pull(pkt, SDPCM_HDRLEN);
 				bus->glomd = pkt;
 			} else {
-				DHD_ERROR(("%s: glom superframe w/o "
-					"descriptor!\n", __func__));
+				dhd_dbg(ERROR,
+					"%s: glom superframe w/o descriptor!\n",
+					__func__);
 				dhdsdio_rxfail(bus, false, false);
 			}
 			continue;
@@ -4130,7 +4187,7 @@ deliver:
 			dhd_os_sdunlock_rxq(bus->dhd);
 			continue;
 		} else if (dhd_prot_hdrpull(bus->dhd, &ifidx, pkt) != 0) {
-			DHD_ERROR(("%s: rx protocol error\n", __func__));
+			dhd_dbg(ERROR, "%s: rx protocol error\n", __func__);
 			dhd_os_sdlock_rxq(bus->dhd);
 			bcm_pkt_buf_free_skb(pkt);
 			dhd_os_sdunlock_rxq(bus->dhd);
@@ -4147,11 +4204,11 @@ deliver:
 #ifdef DHD_DEBUG
 	/* Message if we hit the limit */
 	if (!rxleft && !sdtest)
-		DHD_DATA(("%s: hit rx limit of %d frames\n", __func__,
-			  maxframes));
+		dhd_dbg(DATA, "%s: hit rx limit of %d frames\n",
+			__func__, maxframes);
 	else
 #endif				/* DHD_DEBUG */
-		DHD_DATA(("%s: processed %d frames\n", __func__, rxcount));
+		dhd_dbg(DATA, "%s: processed %d frames\n", __func__, rxcount);
 	/* Back off rxseq if awaiting rtx, update rx_seq */
 	if (bus->rxskip)
 		rxseq--;
@@ -4168,7 +4225,7 @@ static u32 dhdsdio_hostmail(dhd_bus_t *bus)
 	u8 fcbits;
 	uint retries = 0;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	dhd_dbg(TRACE, "%s: Enter\n", __func__);
 
 	/* Read mailbox data and ack that we did so */
 	R_SDREG(hmb_data, &regs->tohostmailboxdata, retries);
@@ -4178,10 +4235,11 @@ static u32 dhdsdio_hostmail(dhd_bus_t *bus)
 
 	/* Dongle recomposed rx frames, accept them again */
 	if (hmb_data & HMB_DATA_NAKHANDLED) {
-		DHD_INFO(("Dongle reports NAK handled, expect rtx of %d\n",
-			  bus->rx_seq));
+		dhd_dbg(INFO, "Dongle reports NAK handled, expect rtx of %d\n",
+			bus->rx_seq);
 		if (!bus->rxskip)
-			DHD_ERROR(("%s: unexpected NAKHANDLED!\n", __func__));
+			dhd_dbg(ERROR, "%s: unexpected NAKHANDLED!\n",
+				__func__);
 
 		bus->rxskip = false;
 		intstatus |= I_HMB_FRAME_IND;
@@ -4195,12 +4253,12 @@ static u32 dhdsdio_hostmail(dhd_bus_t *bus)
 		    (hmb_data & HMB_DATA_VERSION_MASK) >>
 		    HMB_DATA_VERSION_SHIFT;
 		if (bus->sdpcm_ver != SDPCM_PROT_VERSION)
-			DHD_ERROR(("Version mismatch, dongle reports %d, "
-				"expecting %d\n",
-				bus->sdpcm_ver, SDPCM_PROT_VERSION));
+			dhd_dbg(ERROR,
+				"Version mismatch, dongle reports %d, expecting %d\n",
+				bus->sdpcm_ver, SDPCM_PROT_VERSION);
 		else
-			DHD_INFO(("Dongle ready, protocol version %d\n",
-				  bus->sdpcm_ver));
+			dhd_dbg(INFO, "Dongle ready, protocol version %d\n",
+				bus->sdpcm_ver);
 	}
 
 	/*
@@ -4228,7 +4286,8 @@ static u32 dhdsdio_hostmail(dhd_bus_t *bus)
 			 HMB_DATA_FC |
 			 HMB_DATA_FWREADY |
 			 HMB_DATA_FCDATA_MASK | HMB_DATA_VERSION_MASK)) {
-		DHD_ERROR(("Unknown mailbox data content: 0x%02x\n", hmb_data));
+		dhd_dbg(ERROR, "Unknown mailbox data content: 0x%02x\n",
+			hmb_data);
 	}
 
 	return intstatus;
@@ -4246,7 +4305,7 @@ bool dhdsdio_dpc(dhd_bus_t *bus)
 	bool rxdone = true;	/* Flag for no more read data */
 	bool resched = false;	/* Flag indicating resched wanted */
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	dhd_dbg(TRACE, "%s: Enter\n", __func__);
 
 	/* Start with leftover status bits */
 	intstatus = bus->intstatus;
@@ -4263,8 +4322,8 @@ bool dhdsdio_dpc(dhd_bus_t *bus)
 		devctl =
 		    bcmsdh_cfg_read(sdh, SDIO_FUNC_1, SBSDIO_DEVICE_CTL, &err);
 		if (err) {
-			DHD_ERROR(("%s: error reading DEVCTL: %d\n",
-				   __func__, err));
+			dhd_dbg(ERROR, "%s: error reading DEVCTL: %d\n",
+				__func__, err);
 			bus->dhd->busstate = DHD_BUS_DOWN;
 		} else {
 			ASSERT(devctl & SBSDIO_DEVCTL_CA_INT_ONLY);
@@ -4276,29 +4335,29 @@ bool dhdsdio_dpc(dhd_bus_t *bus)
 		    bcmsdh_cfg_read(sdh, SDIO_FUNC_1, SBSDIO_FUNC1_CHIPCLKCSR,
 				    &err);
 		if (err) {
-			DHD_ERROR(("%s: error reading CSR: %d\n", __func__,
-				   err));
+			dhd_dbg(ERROR, "%s: error reading CSR: %d\n",
+				__func__, err);
 			bus->dhd->busstate = DHD_BUS_DOWN;
 		}
 
-		DHD_INFO(("DPC: PENDING, devctl 0x%02x clkctl 0x%02x\n", devctl,
-			  clkctl));
+		dhd_dbg(INFO, "DPC: PENDING, devctl 0x%02x clkctl 0x%02x\n",
+			devctl, clkctl);
 
 		if (SBSDIO_HTAV(clkctl)) {
 			devctl =
 			    bcmsdh_cfg_read(sdh, SDIO_FUNC_1, SBSDIO_DEVICE_CTL,
 					    &err);
 			if (err) {
-				DHD_ERROR(("%s: error reading DEVCTL: %d\n",
-					   __func__, err));
+				dhd_dbg(ERROR, "%s: error reading DEVCTL: %d\n",
+					__func__, err);
 				bus->dhd->busstate = DHD_BUS_DOWN;
 			}
 			devctl &= ~SBSDIO_DEVCTL_CA_INT_ONLY;
 			bcmsdh_cfg_write(sdh, SDIO_FUNC_1, SBSDIO_DEVICE_CTL,
 					 devctl, &err);
 			if (err) {
-				DHD_ERROR(("%s: error writing DEVCTL: %d\n",
-					   __func__, err));
+				dhd_dbg(ERROR, "%s: error writing DEVCTL: %d\n",
+					__func__, err);
 				bus->dhd->busstate = DHD_BUS_DOWN;
 			}
 			bus->clkstate = CLK_AVAIL;
@@ -4355,23 +4414,23 @@ bool dhdsdio_dpc(dhd_bus_t *bus)
 
 	/* Generally don't ask for these, can get CRC errors... */
 	if (intstatus & I_WR_OOSYNC) {
-		DHD_ERROR(("Dongle reports WR_OOSYNC\n"));
+		dhd_dbg(ERROR, "Dongle reports WR_OOSYNC\n");
 		intstatus &= ~I_WR_OOSYNC;
 	}
 
 	if (intstatus & I_RD_OOSYNC) {
-		DHD_ERROR(("Dongle reports RD_OOSYNC\n"));
+		dhd_dbg(ERROR, "Dongle reports RD_OOSYNC\n");
 		intstatus &= ~I_RD_OOSYNC;
 	}
 
 	if (intstatus & I_SBINT) {
-		DHD_ERROR(("Dongle reports SBINT\n"));
+		dhd_dbg(ERROR, "Dongle reports SBINT\n");
 		intstatus &= ~I_SBINT;
 	}
 
 	/* Would be active due to wake-wlan in gSPI */
 	if (intstatus & I_CHIPACTIVE) {
-		DHD_INFO(("Dongle reports CHIPACTIVE\n"));
+		dhd_dbg(INFO, "Dongle reports CHIPACTIVE\n");
 		intstatus &= ~I_CHIPACTIVE;
 	}
 
@@ -4399,8 +4458,9 @@ clkwait:
 	 * (Unless register access seems hosed, as we may not be able to ACK...)
 	 */
 	if (bus->intr && bus->intdis && !bcmsdh_regfail(sdh)) {
-		DHD_INTR(("%s: enable SDIO interrupts, rxdone %d framecnt %d\n",
-			  __func__, rxdone, framecnt));
+		dhd_dbg(INTR,
+			"%s: enable SDIO interrupts, rxdone %d framecnt %d\n",
+			__func__, rxdone, framecnt);
 		bus->intdis = false;
 		bcmsdh_intr_enable(sdh);
 	}
@@ -4419,8 +4479,9 @@ clkwait:
 		if (ret < 0) {
 			/* On failure, abort the command and
 				terminate the frame */
-			DHD_INFO(("%s: sdio error %d, abort command and "
-				"terminate frame.\n", __func__, ret));
+			dhd_dbg(INFO,
+				"%s: sdio error %d, abort command and terminate frame\n",
+				__func__, ret);
 			bus->tx_sderrs++;
 
 			bcmsdh_abort(sdh, SDIO_FUNC_2);
@@ -4447,7 +4508,7 @@ clkwait:
 		if (ret == 0)
 			bus->tx_seq = (bus->tx_seq + 1) % SDPCM_SEQUENCE_WRAP;
 
-		DHD_INFO(("Return_dpc value is : %d\n", ret));
+		dhd_dbg(INFO, "Return_dpc value is : %d\n", ret);
 		bus->ctrl_frame_stat = false;
 		dhd_wait_event_wakeup(bus->dhd);
 	}
@@ -4465,13 +4526,15 @@ clkwait:
 	/* On failed register access, all bets are off:
 		 no resched or interrupts */
 	if ((bus->dhd->busstate == DHD_BUS_DOWN) || bcmsdh_regfail(sdh)) {
-		DHD_ERROR(("%s: failed backplane access over SDIO, halting "
-			"operation %d\n", __func__, bcmsdh_regfail(sdh)));
+		dhd_dbg(ERROR,
+			"%s: failed backplane access over SDIO, halting operation %d\n",
+			__func__, bcmsdh_regfail(sdh));
 		bus->dhd->busstate = DHD_BUS_DOWN;
 		bus->intstatus = 0;
 	} else if (bus->clkstate == CLK_PENDING) {
-		DHD_INFO(("%s: rescheduled due to CLK_PENDING awaiting "
-			"I_CHIPACTIVE interrupt\n", __func__));
+		dhd_dbg(INFO,
+			"%s: rescheduled due to CLK_PENDING awaiting I_CHIPACTIVE interrupt\n",
+			__func__);
 		resched = true;
 	} else if (bus->intstatus || bus->ipend ||
 		(!bus->fcstate && bcm_pktq_mlen(&bus->txq, ~bus->flowcontrol) &&
@@ -4498,7 +4561,7 @@ bool dhd_bus_dpc(struct dhd_bus *bus)
 	bool resched;
 
 	/* Call the DPC directly. */
-	DHD_TRACE(("Calling dhdsdio_dpc() from %s\n", __func__));
+	dhd_dbg(TRACE, "Calling dhdsdio_dpc() from %s\n", __func__);
 	resched = dhdsdio_dpc(bus);
 
 	return resched;
@@ -4509,17 +4572,17 @@ void dhdsdio_isr(void *arg)
 	dhd_bus_t *bus = (dhd_bus_t *) arg;
 	bcmsdh_info_t *sdh;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	dhd_dbg(TRACE, "%s: Enter\n", __func__);
 
 	if (!bus) {
-		DHD_ERROR(("%s : bus is null pointer , exit\n", __func__));
+		dhd_dbg(ERROR, "%s: bus is null pointer, exit\n", __func__);
 		return;
 	}
 	sdh = bus->sdh;
 
 	if (bus->dhd->busstate == DHD_BUS_DOWN) {
-		DHD_ERROR(("%s : bus is down. we have nothing to do\n",
-			   __func__));
+		dhd_dbg(ERROR, "%s: bus is down. we have nothing to do\n",
+			__func__);
 		return;
 	}
 	/* Count the interrupt call */
@@ -4528,21 +4591,21 @@ void dhdsdio_isr(void *arg)
 
 	/* Shouldn't get this interrupt if we're sleeping? */
 	if (bus->sleeping) {
-		DHD_ERROR(("INTERRUPT WHILE SLEEPING??\n"));
+		dhd_dbg(ERROR, "INTERRUPT WHILE SLEEPING??\n");
 		return;
 	}
 
 	/* Disable additional interrupts (is this needed now)? */
 	if (bus->intr)
-		DHD_INTR(("%s: disable SDIO interrupts\n", __func__));
+		dhd_dbg(INTR, "%s: disable SDIO interrupts\n", __func__);
 	else
-		DHD_ERROR(("dhdsdio_isr() w/o interrupt configured!\n"));
+		dhd_dbg(ERROR, "dhdsdio_isr() w/o interrupt configured!\n");
 
 	bcmsdh_intr_disable(sdh);
 	bus->intdis = true;
 
 #if defined(SDIO_ISR_THREAD)
-	DHD_TRACE(("Calling dhdsdio_dpc() from %s\n", __func__));
+	dhd_dbg(TRACE, "Calling dhdsdio_dpc() from %s\n", __func__);
 	while (dhdsdio_dpc(bus))
 		;
 #else
@@ -4612,8 +4675,8 @@ static void dhdsdio_pktgen(dhd_bus_t *bus)
 			(len + SDPCM_HDRLEN + SDPCM_TEST_HDRLEN + DHD_SDALIGN),
 			true);
 		if (!pkt) {
-			DHD_ERROR(("%s: bcm_pkt_buf_get_skb failed!\n",
-				__func__));
+			dhd_dbg(ERROR, "%s: bcm_pkt_buf_get_skb failed!\n",
+				__func__);
 			break;
 		}
 		PKTALIGN(pkt, (len + SDPCM_HDRLEN + SDPCM_TEST_HDRLEN),
@@ -4638,8 +4701,8 @@ static void dhdsdio_pktgen(dhd_bus_t *bus)
 			break;
 
 		default:
-			DHD_ERROR(("Unrecognized pktgen mode %d\n",
-				   bus->pktgen_mode));
+			dhd_dbg(ERROR, "Unrecognized pktgen mode %d\n",
+				   bus->pktgen_mode);
 			bcm_pkt_buf_free_skb(pkt, true);
 			bus->pktgen_count = 0;
 			return;
@@ -4692,7 +4755,7 @@ static void dhdsdio_sdtest_set(dhd_bus_t *bus, bool start)
 	pkt = bcm_pkt_buf_get_skb(SDPCM_HDRLEN + SDPCM_TEST_HDRLEN +
 		DHD_SDALIGN, true);
 	if (!pkt) {
-		DHD_ERROR(("%s: bcm_pkt_buf_get_skb failed!\n", __func__));
+		dhd_dbg(ERROR, "%s: bcm_pkt_buf_get_skb failed!\n", __func__);
 		return;
 	}
 	PKTALIGN(pkt, (SDPCM_HDRLEN + SDPCM_TEST_HDRLEN), DHD_SDALIGN);
@@ -4722,8 +4785,8 @@ static void dhdsdio_testrcv(dhd_bus_t *bus, struct sk_buff *pkt, uint seq)
 	/* Check for min length */
 	pktlen = pkt->len;
 	if (pktlen < SDPCM_TEST_HDRLEN) {
-		DHD_ERROR(("dhdsdio_restrcv: toss runt frame, pktlen %d\n",
-			   pktlen));
+		dhd_dbg(ERROR, "%s: toss runt frame, pktlen %d\n",
+			__func__, pktlen);
 		bcm_pkt_buf_free_skb(pkt, false);
 		return;
 	}
@@ -4739,9 +4802,9 @@ static void dhdsdio_testrcv(dhd_bus_t *bus, struct sk_buff *pkt, uint seq)
 	if (cmd == SDPCM_TEST_DISCARD || cmd == SDPCM_TEST_ECHOREQ
 	    || cmd == SDPCM_TEST_ECHORSP) {
 		if (pktlen != len + SDPCM_TEST_HDRLEN) {
-			DHD_ERROR(("dhdsdio_testrcv: frame length mismatch, "
-				"pktlen %d seq %d" " cmd %d extra %d len %d\n",
-				pktlen, seq, cmd, extra, len));
+			dhd_dbg(ERROR,
+				"%s: frame length mismatch, pktlen %d seq %d cmd %d extra %d len %d\n",
+				__func__, pktlen, seq, cmd, extra, len);
 			bcm_pkt_buf_free_skb(pkt, false);
 			return;
 		}
@@ -4771,9 +4834,10 @@ static void dhdsdio_testrcv(dhd_bus_t *bus, struct sk_buff *pkt, uint seq)
 
 		for (offset = 0; offset < len; offset++, data++) {
 			if (*data != SDPCM_TEST_FILL(offset, extra)) {
-				DHD_ERROR(("dhdsdio_testrcv: echo data mismatch: " "offset %d (len %d) expect 0x%02x rcvd 0x%02x\n",
-					offset, len,
-					SDPCM_TEST_FILL(offset, extra), *data));
+				dhd_dbg(ERROR,
+					"%s: echo data mismatch: offset %d (len %d) expect 0x%02x rcvd 0x%02x\n",
+					__func__, offset, len,
+					SDPCM_TEST_FILL(offset, extra), *data);
 				break;
 			}
 		}
@@ -4789,9 +4853,9 @@ static void dhdsdio_testrcv(dhd_bus_t *bus, struct sk_buff *pkt, uint seq)
 	case SDPCM_TEST_BURST:
 	case SDPCM_TEST_SEND:
 	default:
-		DHD_INFO(("dhdsdio_testrcv: unsupported or unknown command, "
-			"pktlen %d seq %d" " cmd %d extra %d len %d\n",
-			pktlen, seq, cmd, extra, len));
+		dhd_dbg(INFO,
+			"%s: unsupported or unknown command, pktlen %d seq %d cmd %d extra %d len %d\n",
+			__func__, pktlen, seq, cmd, extra, len);
 		bcm_pkt_buf_free_skb(pkt, false);
 		break;
 	}
@@ -4811,7 +4875,7 @@ extern bool dhd_bus_watchdog(dhd_pub_t *dhdp)
 {
 	dhd_bus_t *bus;
 
-	DHD_TIMER(("%s: Enter\n", __func__));
+	dhd_dbg(TIMER, "%s: Enter\n", __func__);
 
 	bus = dhdp->bus;
 
@@ -4973,14 +5037,15 @@ done:
 static void dhd_dump_cis(uint fn, u8 *cis)
 {
 	uint byte, tag, tdata;
-	DHD_INFO(("Function %d CIS:\n", fn));
+
+	dhd_dbg(INFO, "Function %d CIS:\n", fn);
 
 	for (tdata = byte = 0; byte < SBSDIO_CIS_SIZE_LIMIT; byte++) {
 		if ((byte % 16) == 0)
-			DHD_INFO(("    "));
-		DHD_INFO(("%02x ", cis[byte]));
+			dhd_dbg(INFO, "    ");
+		dhd_dbg(INFO, "%02x ", cis[byte]);
 		if ((byte % 16) == 15)
-			DHD_INFO(("\n"));
+			dhd_dbg(INFO, "\n");
 		if (!tdata--) {
 			tag = cis[byte];
 			if (tag == 0xff)
@@ -4990,11 +5055,11 @@ static void dhd_dump_cis(uint fn, u8 *cis)
 			else if ((byte + 1) < SBSDIO_CIS_SIZE_LIMIT)
 				tdata = cis[byte + 1] + 1;
 			else
-				DHD_INFO(("]"));
+				dhd_dbg(INFO, "]");
 		}
 	}
 	if ((byte % 16) != 15)
-		DHD_INFO(("\n"));
+		dhd_dbg(INFO, "\n");
 }
 #endif				/* DHD_DEBUG */
 
@@ -5037,8 +5102,9 @@ static void *dhdsdio_probe(u16 venid, u16 devid, u16 bus_no,
 
 	dhd_common_init();
 
-	DHD_TRACE(("%s: Enter\n", __func__));
-	DHD_INFO(("%s: venid 0x%04x devid 0x%04x\n", __func__, venid, devid));
+	dhd_dbg(TRACE, "%s: Enter\n", __func__);
+	dhd_dbg(INFO, "%s: venid 0x%04x devid 0x%04x\n",
+		__func__, venid, devid);
 
 	/* We make assumptions about address window mappings */
 	ASSERT((unsigned long)regsva == SI_ENUM_BASE);
@@ -5054,7 +5120,7 @@ static void *dhdsdio_probe(u16 venid, u16 devid, u16 bus_no,
 	case PCI_VENDOR_ID_BROADCOM:
 		break;
 	default:
-		DHD_ERROR(("%s: unknown vendor: 0x%04x\n", __func__, venid));
+		dhd_dbg(ERROR, "%s: unknown vendor: 0x%04x\n", __func__, venid);
 		return NULL;
 	}
 
@@ -5063,34 +5129,35 @@ static void *dhdsdio_probe(u16 venid, u16 devid, u16 bus_no,
 	case BCM4325_D11DUAL_ID:	/* 4325 802.11a/g id */
 	case BCM4325_D11G_ID:	/* 4325 802.11g 2.4Ghz band id */
 	case BCM4325_D11A_ID:	/* 4325 802.11a 5Ghz band id */
-		DHD_INFO(("%s: found 4325 Dongle\n", __func__));
+		dhd_dbg(INFO, "%s: found 4325 Dongle\n", __func__);
 		break;
 	case BCM4329_D11NDUAL_ID:	/* 4329 802.11n dualband device */
 	case BCM4329_D11N2G_ID:	/* 4329 802.11n 2.4G device */
 	case BCM4329_D11N5G_ID:	/* 4329 802.11n 5G device */
 	case 0x4329:
-		DHD_INFO(("%s: found 4329 Dongle\n", __func__));
+		dhd_dbg(INFO, "%s: found 4329 Dongle\n", __func__);
 		break;
 	case BCM4319_D11N_ID:	/* 4319 802.11n id */
 	case BCM4319_D11N2G_ID:	/* 4319 802.11n2g id */
 	case BCM4319_D11N5G_ID:	/* 4319 802.11n5g id */
-		DHD_INFO(("%s: found 4319 Dongle\n", __func__));
+		dhd_dbg(INFO, "%s: found 4319 Dongle\n", __func__);
 		break;
 	case 0:
-		DHD_INFO(("%s: allow device id 0, will check chip internals\n",
-			  __func__));
+		dhd_dbg(INFO,
+			"%s: allow device id 0, will check chip internals\n",
+			__func__);
 		break;
 
 	default:
-		DHD_ERROR(("%s: skipping 0x%04x/0x%04x, not a dongle\n",
-			   __func__, venid, devid));
+		dhd_dbg(ERROR, "%s: skipping 0x%04x/0x%04x, not a dongle\n",
+			__func__, venid, devid);
 		return NULL;
 	}
 
 	/* Allocate private bus interface state */
 	bus = kzalloc(sizeof(dhd_bus_t), GFP_ATOMIC);
 	if (!bus) {
-		DHD_ERROR(("%s: kmalloc of dhd_bus_t failed\n", __func__));
+		dhd_dbg(ERROR, "%s: kmalloc of dhd_bus_t failed\n", __func__);
 		goto fail;
 	}
 	bus->sdh = sdh;
@@ -5102,53 +5169,54 @@ static void *dhdsdio_probe(u16 venid, u16 devid, u16 bus_no,
 
 	/* attempt to attach to the dongle */
 	if (!(dhdsdio_probe_attach(bus, sdh, regsva, devid))) {
-		DHD_ERROR(("%s: dhdsdio_probe_attach failed\n", __func__));
+		dhd_dbg(ERROR, "%s: dhdsdio_probe_attach failed\n", __func__);
 		goto fail;
 	}
 
 	/* Attach to the dhd/OS/network interface */
 	bus->dhd = dhd_attach(bus, SDPCM_RESERVE);
 	if (!bus->dhd) {
-		DHD_ERROR(("%s: dhd_attach failed\n", __func__));
+		dhd_dbg(ERROR, "%s: dhd_attach failed\n", __func__);
 		goto fail;
 	}
 
 	/* Allocate buffers */
 	if (!(dhdsdio_probe_malloc(bus, sdh))) {
-		DHD_ERROR(("%s: dhdsdio_probe_malloc failed\n", __func__));
+		dhd_dbg(ERROR, "%s: dhdsdio_probe_malloc failed\n", __func__);
 		goto fail;
 	}
 
 	if (!(dhdsdio_probe_init(bus, sdh))) {
-		DHD_ERROR(("%s: dhdsdio_probe_init failed\n", __func__));
+		dhd_dbg(ERROR, "%s: dhdsdio_probe_init failed\n", __func__);
 		goto fail;
 	}
 
 	/* Register interrupt callback, but mask it (not operational yet). */
-	DHD_INTR(("%s: disable SDIO interrupts (not interested yet)\n",
-		  __func__));
+	dhd_dbg(INTR, "%s: disable SDIO interrupts (not interested yet)\n",
+		__func__);
 	bcmsdh_intr_disable(sdh);
 	ret = bcmsdh_intr_reg(sdh, dhdsdio_isr, bus);
 	if (ret != 0) {
-		DHD_ERROR(("%s: FAILED: bcmsdh_intr_reg returned %d\n",
-			   __func__, ret));
+		dhd_dbg(ERROR, "%s: FAILED: bcmsdh_intr_reg returned %d\n",
+			__func__, ret);
 		goto fail;
 	}
-	DHD_INTR(("%s: registered SDIO interrupt function ok\n", __func__));
+	dhd_dbg(INTR, "%s: registered SDIO interrupt function ok\n", __func__);
 
-	DHD_INFO(("%s: completed!!\n", __func__));
+	dhd_dbg(INFO, "%s: completed!!\n", __func__);
 
 	/* if firmware path present try to download and bring up bus */
 	ret = dhd_bus_start(bus->dhd);
 	if (ret != 0) {
 		if (ret == -ENOLINK) {
-			DHD_ERROR(("%s: dongle is not responding\n", __func__));
+			dhd_dbg(ERROR, "%s: dongle is not responding\n",
+				__func__);
 			goto fail;
 		}
 	}
 	/* Ok, have the per-port tell the stack we're open for business */
 	if (dhd_net_attach(bus->dhd, 0) != 0) {
-		DHD_ERROR(("%s: Net attach failed!!\n", __func__));
+		dhd_dbg(ERROR, "%s: Net attach failed!!\n", __func__);
 		goto fail;
 	}
 
@@ -5169,7 +5237,8 @@ dhdsdio_probe_attach(struct dhd_bus *bus, void *sdh, void *regsva, u16 devid)
 
 	/* Return the window to backplane enumeration space for core access */
 	if (dhdsdio_set_siaddr_window(bus, SI_ENUM_BASE))
-		DHD_ERROR(("%s: FAILED to return to SI_ENUM_BASE\n", __func__));
+		dhd_dbg(ERROR, "%s: FAILED to return to SI_ENUM_BASE\n",
+			__func__);
 
 #ifdef DHD_DEBUG
 	printk(KERN_DEBUG "F1 signature read @0x18000000=0x%4x\n",
@@ -5190,9 +5259,9 @@ dhdsdio_probe_attach(struct dhd_bus *bus, void *sdh, void *regsva, u16 devid)
 				    &err);
 
 	if (err || ((clkctl & ~SBSDIO_AVBITS) != DHD_INIT_CLKCTL1)) {
-		DHD_ERROR(("dhdsdio_probe: ChipClkCSR access: err %d wrote "
-			"0x%02x read 0x%02x\n",
-			err, DHD_INIT_CLKCTL1, clkctl));
+		dhd_dbg(ERROR,
+			"%s: ChipClkCSR access: err %d wrote 0x%02x read 0x%02x\n",
+			__func__, err, DHD_INIT_CLKCTL1, clkctl);
 		goto fail;
 	}
 #ifdef DHD_DEBUG
@@ -5218,16 +5287,16 @@ dhdsdio_probe_attach(struct dhd_bus *bus, void *sdh, void *regsva, u16 devid)
 		for (fn = 0; fn <= numfn; fn++) {
 			cis[fn] = kzalloc(SBSDIO_CIS_SIZE_LIMIT, GFP_ATOMIC);
 			if (!cis[fn]) {
-				DHD_INFO(("dhdsdio_probe: fn %d cis malloc "
-					"failed\n", fn));
+				dhd_dbg(INFO, "%s: fn %d cis malloc failed\n",
+					__func__, fn);
 				break;
 			}
 
 			err = bcmsdh_cis_read(sdh, fn, cis[fn],
 						SBSDIO_CIS_SIZE_LIMIT);
 			if (err) {
-				DHD_INFO(("dhdsdio_probe: fn %d cis read "
-					"err %d\n", fn, err));
+				dhd_dbg(INFO, "%s: fn %d cis read err %d\n",
+					__func__, fn, err);
 				kfree(cis[fn]);
 				break;
 			}
@@ -5240,22 +5309,22 @@ dhdsdio_probe_attach(struct dhd_bus *bus, void *sdh, void *regsva, u16 devid)
 		}
 
 		if (err) {
-			DHD_ERROR(("dhdsdio_probe: error read/parsing CIS\n"));
+			dhd_dbg(ERROR, "%s: error read/parsing CIS\n", __func__);
 			goto fail;
 		}
 	}
 #endif				/* DHD_DEBUG */
 
 	if (dhdsdio_chip_attach(bus, regsva)) {
-		DHD_ERROR(("%s: dhdsdio_chip_attach failed!\n", __func__));
+		dhd_dbg(ERROR, "%s: dhdsdio_chip_attach failed!\n", __func__);
 		goto fail;
 	}
 
 	bcmsdh_chipinfo(sdh, bus->ci->chip, bus->ci->chiprev);
 
 	if (!dhdsdio_chipmatch((u16) bus->ci->chip)) {
-		DHD_ERROR(("%s: unsupported chip: 0x%04x\n",
-			   __func__, bus->ci->chip));
+		dhd_dbg(ERROR, "%s: unsupported chip: 0x%04x\n",
+			__func__, bus->ci->chip);
 		goto fail;
 	}
 
@@ -5267,16 +5336,16 @@ dhdsdio_probe_attach(struct dhd_bus *bus, void *sdh, void *regsva, u16 devid)
 			CORE_SB(bus->ci->armcorebase, sbidhigh), 4));
 		bus->orig_ramsize = bus->ci->ramsize;
 		if (!(bus->orig_ramsize)) {
-			DHD_ERROR(("%s: failed to find SOCRAM memory!\n",
-				   __func__));
+			dhd_dbg(ERROR, "%s: failed to find SOCRAM memory!\n",
+				__func__);
 			goto fail;
 		}
 		bus->ramsize = bus->orig_ramsize;
 		if (dhd_dongle_memsize)
 			dhd_dongle_setmemsize(bus, dhd_dongle_memsize);
 
-		DHD_ERROR(("DHD: dongle ram size is set to %d(orig %d)\n",
-			   bus->ramsize, bus->orig_ramsize));
+		dhd_dbg(ERROR, "DHD: dongle ram size is set to %d(orig %d)\n",
+			bus->ramsize, bus->orig_ramsize);
 	}
 
 	bus->regs = (void *)bus->ci->buscorebase;
@@ -5303,7 +5372,7 @@ fail:
 
 static bool dhdsdio_probe_malloc(dhd_bus_t *bus, void *sdh)
 {
-	DHD_TRACE(("%s: Enter\n", __func__));
+	dhd_dbg(TRACE, "%s: Enter\n", __func__);
 
 	if (bus->dhd->maxctl) {
 		bus->rxblen =
@@ -5311,8 +5380,8 @@ static bool dhdsdio_probe_malloc(dhd_bus_t *bus, void *sdh)
 			    ALIGNMENT) + DHD_SDALIGN;
 		bus->rxbuf = kmalloc(bus->rxblen, GFP_ATOMIC);
 		if (!(bus->rxbuf)) {
-			DHD_ERROR(("%s: kmalloc of %d-byte rxbuf failed\n",
-				   __func__, bus->rxblen));
+			dhd_dbg(ERROR, "%s: kmalloc of %d-byte rxbuf failed\n",
+				__func__, bus->rxblen);
 			goto fail;
 		}
 	}
@@ -5320,8 +5389,8 @@ static bool dhdsdio_probe_malloc(dhd_bus_t *bus, void *sdh)
 	/* Allocate buffer to receive glomed packet */
 	bus->databuf = kmalloc(MAX_DATA_BUF, GFP_ATOMIC);
 	if (!(bus->databuf)) {
-		DHD_ERROR(("%s: kmalloc of %d-byte databuf failed\n",
-			   __func__, MAX_DATA_BUF));
+		dhd_dbg(ERROR, "%s: kmalloc of %d-byte databuf failed\n",
+			__func__, MAX_DATA_BUF);
 		/* release rxbuf which was already located as above */
 		if (!bus->rxblen)
 			kfree(bus->rxbuf);
@@ -5346,7 +5415,7 @@ static bool dhdsdio_probe_init(dhd_bus_t *bus, void *sdh)
 {
 	s32 fnum;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	dhd_dbg(TRACE, "%s: Enter\n", __func__);
 
 #ifdef SDTEST
 	dhdsdio_pktgen_init(bus);
@@ -5373,21 +5442,21 @@ static bool dhdsdio_probe_init(dhd_bus_t *bus, void *sdh)
 	if (bcmsdh_iovar_op(sdh, "sd_divisor", NULL, 0,
 			    &bus->sd_divisor, sizeof(s32),
 			    false) != 0) {
-		DHD_ERROR(("%s: fail on %s get\n", __func__, "sd_divisor"));
+		dhd_dbg(ERROR, "%s: fail on %s get\n", __func__, "sd_divisor");
 		bus->sd_divisor = -1;
 	} else {
-		DHD_INFO(("%s: Initial value for %s is %d\n",
-			  __func__, "sd_divisor", bus->sd_divisor));
+		dhd_dbg(INFO, "%s: Initial value for %s is %d\n",
+			__func__, "sd_divisor", bus->sd_divisor);
 	}
 
 	/* Query the SD bus mode */
 	if (bcmsdh_iovar_op(sdh, "sd_mode", NULL, 0,
 			    &bus->sd_mode, sizeof(s32), false) != 0) {
-		DHD_ERROR(("%s: fail on %s get\n", __func__, "sd_mode"));
+		dhd_dbg(ERROR, "%s: fail on %s get\n", __func__, "sd_mode");
 		bus->sd_mode = -1;
 	} else {
-		DHD_INFO(("%s: Initial value for %s is %d\n",
-			  __func__, "sd_mode", bus->sd_mode));
+		dhd_dbg(INFO, "%s: Initial value for %s is %d\n",
+			__func__, "sd_mode", bus->sd_mode);
 	}
 
 	/* Query the F2 block size, set roundup accordingly */
@@ -5395,10 +5464,11 @@ static bool dhdsdio_probe_init(dhd_bus_t *bus, void *sdh)
 	if (bcmsdh_iovar_op(sdh, "sd_blocksize", &fnum, sizeof(s32),
 			    &bus->blocksize, sizeof(s32), false) != 0) {
 		bus->blocksize = 0;
-		DHD_ERROR(("%s: fail on %s get\n", __func__, "sd_blocksize"));
+		dhd_dbg(ERROR, "%s: fail on %s get\n",
+			__func__, "sd_blocksize");
 	} else {
-		DHD_INFO(("%s: Initial value for %s is %d\n",
-			  __func__, "sd_blocksize", bus->blocksize));
+		dhd_dbg(INFO, "%s: Initial value for %s is %d\n",
+			__func__, "sd_blocksize", bus->blocksize);
 	}
 	bus->roundup = min(max_roundup, bus->blocksize);
 
@@ -5409,9 +5479,10 @@ static bool dhdsdio_probe_init(dhd_bus_t *bus, void *sdh)
 			    false) != 0) {
 		bus->sd_rxchain = false;
 	} else {
-		DHD_INFO(("%s: bus module (through bcmsdh API) %s chaining\n",
-			  __func__,
-			  (bus->sd_rxchain ? "supports" : "does not support")));
+		dhd_dbg(INFO,
+			"%s: bus module (through bcmsdh API) %s chaining\n",
+			__func__,
+			bus->sd_rxchain ? "supports" : "does not support");
 	}
 	bus->use_rxchain = (bool) bus->sd_rxchain;
 
@@ -5448,7 +5519,7 @@ dhdsdio_download_firmware(struct dhd_bus *bus, void *sdh)
 /* Detach and free everything */
 static void dhdsdio_release(dhd_bus_t *bus)
 {
-	DHD_TRACE(("%s: Enter\n", __func__));
+	dhd_dbg(TRACE, "%s: Enter\n", __func__);
 
 	if (bus) {
 		/* De-register interrupt handler */
@@ -5466,12 +5537,12 @@ static void dhdsdio_release(dhd_bus_t *bus)
 		kfree(bus);
 	}
 
-	DHD_TRACE(("%s: Disconnected\n", __func__));
+	dhd_dbg(TRACE, "%s: Disconnected\n", __func__);
 }
 
 static void dhdsdio_release_malloc(dhd_bus_t *bus)
 {
-	DHD_TRACE(("%s: Enter\n", __func__));
+	dhd_dbg(TRACE, "%s: Enter\n", __func__);
 
 	if (bus->dhd && bus->dhd->dongle_reset)
 		return;
@@ -5488,7 +5559,7 @@ static void dhdsdio_release_malloc(dhd_bus_t *bus)
 
 static void dhdsdio_release_dongle(dhd_bus_t *bus)
 {
-	DHD_TRACE(("%s: Enter\n", __func__));
+	dhd_dbg(TRACE, "%s: Enter\n", __func__);
 
 	if (bus->dhd && bus->dhd->dongle_reset)
 		return;
@@ -5502,21 +5573,21 @@ static void dhdsdio_release_dongle(dhd_bus_t *bus)
 		bus->vars = NULL;
 	}
 
-	DHD_TRACE(("%s: Disconnected\n", __func__));
+	dhd_dbg(TRACE, "%s: Disconnected\n", __func__);
 }
 
 static void dhdsdio_disconnect(void *ptr)
 {
 	dhd_bus_t *bus = (dhd_bus_t *)ptr;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	dhd_dbg(TRACE, "%s: Enter\n", __func__);
 
 	if (bus) {
 		ASSERT(bus->dhd);
 		dhdsdio_release(bus);
 	}
 
-	DHD_TRACE(("%s: Disconnected\n", __func__));
+	dhd_dbg(TRACE, "%s: Disconnected\n", __func__);
 }
 
 /* Register/Unregister functions are called by the main DHD entry
@@ -5531,14 +5602,14 @@ static bcmsdh_driver_t dhd_sdio = {
 
 int dhd_bus_register(void)
 {
-	DHD_TRACE(("%s: Enter\n", __func__));
+	dhd_dbg(TRACE, "%s: Enter\n", __func__);
 
 	return bcmsdh_register(&dhd_sdio);
 }
 
 void dhd_bus_unregister(void)
 {
-	DHD_TRACE(("%s: Enter\n", __func__));
+	dhd_dbg(TRACE, "%s: Enter\n", __func__);
 
 	bcmsdh_unregister();
 }
@@ -5549,7 +5620,7 @@ static int dhdsdio_download_code_array(struct dhd_bus *bus)
 	int bcmerror = -1;
 	int offset = 0;
 
-	DHD_INFO(("%s: download embedded firmware...\n", __func__));
+	dhd_dbg(INFO, "%s: download embedded firmware...\n", __func__);
 
 	/* Download image */
 	while ((offset + MEMBLOCK) < sizeof(dlarray)) {
@@ -5557,9 +5628,9 @@ static int dhdsdio_download_code_array(struct dhd_bus *bus)
 		    dhdsdio_membytes(bus, true, offset, dlarray + offset,
 				     MEMBLOCK);
 		if (bcmerror) {
-			DHD_ERROR(("%s: error %d on writing %d membytes at "
-				"0x%08x\n",
-				__func__, bcmerror, MEMBLOCK, offset));
+			dhd_dbg(ERROR,
+				"%s: error %d on writing %d membytes at 0x%08x\n",
+				__func__, bcmerror, MEMBLOCK, offset);
 			goto err;
 		}
 
@@ -5571,9 +5642,10 @@ static int dhdsdio_download_code_array(struct dhd_bus *bus)
 					    dlarray + offset,
 					    sizeof(dlarray) - offset);
 		if (bcmerror) {
-			DHD_ERROR(("%s: error %d on writing %d membytes at "
-				"0x%08x\n", __func__, bcmerror,
-				sizeof(dlarray) - offset, offset));
+			dhd_dbg(ERROR,
+				"%s: error %d on writing %d membytes at 0x%08x\n",
+				__func__, bcmerror,
+				sizeof(dlarray) - offset, offset);
 			goto err;
 		}
 	}
@@ -5595,9 +5667,9 @@ static int dhdsdio_download_code_array(struct dhd_bus *bus)
 			    dhdsdio_membytes(bus, false, offset,
 					     ularray + offset, MEMBLOCK);
 			if (bcmerror) {
-				DHD_ERROR(("%s: error %d on reading %d membytes"
-					" at 0x%08x\n",
-					__func__, bcmerror, MEMBLOCK, offset));
+				dhd_dbg(ERROR,
+					"%s: error %d on reading %d membytes at 0x%08x\n",
+					__func__, bcmerror, MEMBLOCK, offset);
 				goto free;
 			}
 
@@ -5609,21 +5681,23 @@ static int dhdsdio_download_code_array(struct dhd_bus *bus)
 						    ularray + offset,
 						    sizeof(dlarray) - offset);
 			if (bcmerror) {
-				DHD_ERROR(("%s: error %d on reading %d membytes at 0x%08x\n",
-				__func__, bcmerror,
-				sizeof(dlarray) - offset, offset));
+				dhd_dbg(ERROR,
+					"%s: error %d on reading %d membytes at 0x%08x\n",
+					__func__, bcmerror,
+					sizeof(dlarray) - offset, offset);
 				goto free;
 			}
 		}
 
 		if (memcmp(dlarray, ularray, sizeof(dlarray))) {
-			DHD_ERROR(("%s: Downloaded image is corrupted.\n",
-				   __func__));
+			dhd_dbg(ERROR, "%s: Downloaded image is corrupted\n",
+				__func__);
 			ASSERT(0);
 			goto free;
 		} else
-			DHD_ERROR(("%s: Download/Upload/Compare succeeded.\n",
-				__func__));
+			dhd_dbg(ERROR,
+				"%s: Download/Upload/Compare succeeded\n",
+				__func__);
 free:
 		kfree(ularray);
 	}
@@ -5642,7 +5716,7 @@ static int dhdsdio_download_code_file(struct dhd_bus *bus, char *fw_path)
 	void *image = NULL;
 	u8 *memblock = NULL, *memptr;
 
-	DHD_INFO(("%s: download firmware %s\n", __func__, fw_path));
+	dhd_dbg(INFO, "%s: download firmware %s\n", __func__, fw_path);
 
 	image = dhd_os_open_image(fw_path);
 	if (image == NULL)
@@ -5650,8 +5724,8 @@ static int dhdsdio_download_code_file(struct dhd_bus *bus, char *fw_path)
 
 	memptr = memblock = kmalloc(MEMBLOCK + DHD_SDALIGN, GFP_ATOMIC);
 	if (memblock == NULL) {
-		DHD_ERROR(("%s: Failed to allocate memory %d bytes\n",
-			   __func__, MEMBLOCK));
+		dhd_dbg(ERROR, "%s: Failed to allocate memory %d bytes\n",
+			__func__, MEMBLOCK);
 		goto err;
 	}
 	if ((u32)(unsigned long)memblock % DHD_SDALIGN)
@@ -5663,8 +5737,9 @@ static int dhdsdio_download_code_file(struct dhd_bus *bus, char *fw_path)
 		dhd_os_get_image_block((char *)memptr, MEMBLOCK, image))) {
 		bcmerror = dhdsdio_membytes(bus, true, offset, memptr, len);
 		if (bcmerror) {
-			DHD_ERROR(("%s: error %d on writing %d membytes at "
-			"0x%08x\n", __func__, bcmerror, MEMBLOCK, offset));
+			dhd_dbg(ERROR,
+				"%s: error %d on writing %d membytes at 0x%08x\n",
+				__func__, bcmerror, MEMBLOCK, offset);
 			goto err;
 		}
 
@@ -5776,8 +5851,8 @@ static int dhdsdio_download_nvram(struct dhd_bus *bus)
 
 	memblock = kmalloc(MEMBLOCK, GFP_ATOMIC);
 	if (memblock == NULL) {
-		DHD_ERROR(("%s: Failed to allocate memory %d bytes\n",
-			   __func__, MEMBLOCK));
+		dhd_dbg(ERROR, "%s: Failed to allocate memory %d bytes\n",
+			__func__, MEMBLOCK);
 		goto err;
 	}
 
@@ -5801,12 +5876,12 @@ static int dhdsdio_download_nvram(struct dhd_bus *bus)
 		if (len)
 			bcmerror = dhdsdio_downloadvars(bus, memblock, len + 1);
 		if (bcmerror) {
-			DHD_ERROR(("%s: error downloading vars: %d\n",
-				   __func__, bcmerror));
+			dhd_dbg(ERROR, "%s: error downloading vars: %d\n",
+				__func__, bcmerror);
 		}
 	} else {
-		DHD_ERROR(("%s: error reading nvram file: %d\n",
-			   __func__, len));
+		dhd_dbg(ERROR, "%s: error reading nvram file: %d\n",
+			__func__, len);
 		bcmerror = -EIO;
 	}
 
@@ -5837,15 +5912,17 @@ static int _dhdsdio_download_firmware(struct dhd_bus *bus)
 
 	/* Keep arm in reset */
 	if (dhdsdio_download_state(bus, true)) {
-		DHD_ERROR(("%s: error placing ARM core in reset\n", __func__));
+		dhd_dbg(ERROR, "%s: error placing ARM core in reset\n",
+			__func__);
 		goto err;
 	}
 
 	/* External image takes precedence if specified */
 	if ((bus->fw_path != NULL) && (bus->fw_path[0] != '\0')) {
 		if (dhdsdio_download_code_file(bus, bus->fw_path)) {
-			DHD_ERROR(("%s: dongle image file download failed\n",
-				   __func__));
+			dhd_dbg(ERROR,
+				"%s: dongle image file download failed\n",
+				__func__);
 #ifdef BCMEMBEDIMAGE
 			embed = true;
 #else
@@ -5859,8 +5936,9 @@ static int _dhdsdio_download_firmware(struct dhd_bus *bus)
 #ifdef BCMEMBEDIMAGE
 	if (embed) {
 		if (dhdsdio_download_code_array(bus)) {
-			DHD_ERROR(("%s: dongle image array download failed\n",
-				   __func__));
+			dhd_dbg(ERROR,
+				"%s: dongle image array download failed\n",
+				__func__);
 			goto err;
 		} else {
 			dlok = true;
@@ -5868,7 +5946,7 @@ static int _dhdsdio_download_firmware(struct dhd_bus *bus)
 	}
 #endif
 	if (!dlok) {
-		DHD_ERROR(("%s: dongle image download failed\n", __func__));
+		dhd_dbg(ERROR, "%s: dongle image download failed\n", __func__);
 		goto err;
 	}
 
@@ -5879,14 +5957,14 @@ static int _dhdsdio_download_firmware(struct dhd_bus *bus)
 
 	/* External nvram takes precedence if specified */
 	if (dhdsdio_download_nvram(bus)) {
-		DHD_ERROR(("%s: dongle nvram file download failed\n",
-			   __func__));
+		dhd_dbg(ERROR, "%s: dongle nvram file download failed\n",
+			__func__);
 	}
 
 	/* Take arm out of reset */
 	if (dhdsdio_download_state(bus, false)) {
-		DHD_ERROR(("%s: error getting out of ARM core reset\n",
-			   __func__));
+		dhd_dbg(ERROR, "%s: error getting out of ARM core reset\n",
+			__func__);
 		goto err;
 	}
 
@@ -5949,14 +6027,14 @@ int dhd_bus_devreset(dhd_pub_t *dhdp, u8 flag)
 			bus->dhd->dongle_reset = true;
 			bus->dhd->up = false;
 
-			DHD_TRACE(("%s:  WLAN OFF DONE\n", __func__));
+			dhd_dbg(TRACE, "%s:  WLAN OFF DONE\n", __func__);
 			/* App can now remove power from device */
 		} else
 			bcmerror = -EIO;
 	} else {
 		/* App must have restored power to device before calling */
 
-		DHD_TRACE(("\n\n%s: == WLAN ON ==\n", __func__));
+		dhd_dbg(TRACE, "\n\n%s: == WLAN ON ==\n", __func__);
 
 		if (bus->dhd->dongle_reset) {
 			/* Turn on WLAN */
@@ -5984,16 +6062,17 @@ int dhd_bus_devreset(dhd_pub_t *dhdp, u8 flag)
 					bus->dhd->dongle_reset = false;
 					bus->dhd->up = true;
 
-					DHD_TRACE(("%s: WLAN ON DONE\n",
-						   __func__));
+					dhd_dbg(TRACE, "%s: WLAN ON DONE\n",
+						__func__);
 				} else
 					bcmerror = -EIO;
 			} else
 				bcmerror = -EIO;
 		} else {
 			bcmerror = -EISCONN;
-			DHD_ERROR(("%s: Set DEVRESET=false invoked when device "
-				"is on\n", __func__));
+			dhd_dbg(ERROR,
+				"%s: Set DEVRESET=false invoked when device is on\n",
+				__func__);
 			bcmerror = -EIO;
 		}
 	}
@@ -6016,8 +6095,8 @@ dhdsdio_chip_recognition(bcmsdh_info_t *sdh, struct chip_info *ci, void *regs)
 	ci->chip = regdata & CID_ID_MASK;
 	ci->chiprev = (regdata & CID_REV_MASK) >> CID_REV_SHIFT;
 
-	DHD_INFO(("%s: chipid=0x%x chiprev=%d\n",
-		__func__, ci->chip, ci->chiprev));
+	dhd_dbg(INFO, "%s: chipid=0x%x chiprev=%d\n",
+		__func__, ci->chip, ci->chiprev);
 
 	/* Address of cores for new chips should be added here */
 	switch (ci->chip) {
@@ -6028,8 +6107,8 @@ dhdsdio_chip_recognition(bcmsdh_info_t *sdh, struct chip_info *ci, void *regs)
 		ci->ramsize = BCM4329_RAMSIZE;
 		break;
 	default:
-		DHD_ERROR(("%s: chipid 0x%x is not supported\n",
-			__func__, ci->chip));
+		dhd_dbg(ERROR, "%s: chipid 0x%x is not supported\n",
+			__func__, ci->chip);
 		return -ENODEV;
 	}
 
@@ -6045,9 +6124,9 @@ dhdsdio_chip_recognition(bcmsdh_info_t *sdh, struct chip_info *ci, void *regs)
 	ci->buscorerev = SBCOREREV(regdata);
 	ci->buscoretype = (regdata & SBIDH_CC_MASK) >> SBIDH_CC_SHIFT;
 
-	DHD_INFO(("%s: ccrev=%d, pmurev=%d, buscore rev/type=%d/0x%x\n",
+	dhd_dbg(INFO, "%s: ccrev=%d, pmurev=%d, buscore rev/type=%d/0x%x\n",
 		__func__, ci->ccrev, ci->pmurev,
-		ci->buscorerev, ci->buscoretype));
+		ci->buscorerev, ci->buscoretype);
 
 	/* get chipcommon capabilites */
 	ci->cccaps = bcmsdh_reg_read(sdh,
@@ -6088,7 +6167,7 @@ dhdsdio_chip_disablecore(bcmsdh_info_t *sdh, u32 corebase)
 		regdata = bcmsdh_reg_read(sdh,
 			CORE_SB(corebase, sbtmstatehigh), 4);
 		if (regdata & SBTMH_BUSY)
-			DHD_ERROR(("%s: ARM core still busy\n", __func__));
+			dhd_dbg(ERROR, "%s: ARM core still busy\n", __func__);
 
 		regdata = bcmsdh_reg_read(sdh,
 			CORE_SB(corebase, sbidlow), 4);
@@ -6142,12 +6221,12 @@ dhdsdio_chip_attach(struct dhd_bus *bus, void *regs)
 	int err;
 	u8 clkval, clkset;
 
-	DHD_TRACE(("%s: Enter\n", __func__));
+	dhd_dbg(TRACE, "%s: Enter\n", __func__);
 
 	/* alloc chip_info_t */
 	ci = kmalloc(sizeof(struct chip_info), GFP_ATOMIC);
 	if (NULL == ci) {
-		DHD_ERROR(("%s: malloc failed!\n", __func__));
+		dhd_dbg(ERROR, "%s: malloc failed!\n", __func__);
 		return -ENOMEM;
 	}
 
@@ -6159,7 +6238,7 @@ dhdsdio_chip_attach(struct dhd_bus *bus, void *regs)
 	bcmsdh_cfg_write(bus->sdh, SDIO_FUNC_1, SBSDIO_FUNC1_CHIPCLKCSR,
 			clkset, &err);
 	if (err) {
-		DHD_ERROR(("%s: error writing for HT off\n", __func__));
+		dhd_dbg(ERROR, "%s: error writing for HT off\n", __func__);
 		goto fail;
 	}
 
@@ -6175,8 +6254,9 @@ dhdsdio_chip_attach(struct dhd_bus *bus, void *regs)
 				!SBSDIO_ALPAV(clkval)),
 				PMU_MAX_TRANSITION_DLY);
 		if (!SBSDIO_ALPAV(clkval)) {
-			DHD_ERROR(("%s: timeout on ALPAV wait, clkval 0x%02x\n",
-				__func__, clkval));
+			dhd_dbg(ERROR,
+				"%s: timeout on ALPAV wait, clkval 0x%02x\n",
+				__func__, clkval);
 			err = -EBUSY;
 			goto fail;
 		}
@@ -6187,8 +6267,9 @@ dhdsdio_chip_attach(struct dhd_bus *bus, void *regs)
 				clkset, &err);
 		udelay(65);
 	} else {
-		DHD_ERROR(("%s: ChipClkCSR access: wrote 0x%02x read 0x%02x\n",
-			__func__, clkset, clkval));
+		dhd_dbg(ERROR,
+			"%s: ChipClkCSR access: wrote 0x%02x read 0x%02x\n",
+			__func__, clkset, clkval);
 		err = -EACCES;
 		goto fail;
 	}
@@ -6344,10 +6425,12 @@ dhdsdio_sdiod_drive_strength_init(struct dhd_bus *bus, u32 drivestrength) {
 		str_shift = 11;
 		break;
 	default:
-		DHD_ERROR(("No SDIO Drive strength init"
-			"done for chip %s rev %d pmurev %d\n",
+#ifdef BCMDBG
+		dhd_dbg(ERROR,
+			"No SDIO Drive strength init done for chip %s rev %d pmurev %d\n",
 			bcm_chipname(bus->ci->chip, chn, 8),
-			bus->ci->chiprev, bus->ci->pmurev));
+			bus->ci->chiprev, bus->ci->pmurev);
+#endif
 		break;
 	}
 
@@ -6375,15 +6458,16 @@ dhdsdio_sdiod_drive_strength_init(struct dhd_bus *bus, u32 drivestrength) {
 			CORE_CC_REG(bus->ci->cccorebase, chipcontrol_addr),
 			4, cc_data_temp);
 
-		DHD_INFO(("SDIO: %dmA drive strength selected, set to 0x%08x\n",
-			drivestrength, cc_data_temp));
+		dhd_dbg(INFO,
+			"SDIO: %dmA drive strength selected, set to 0x%08x\n",
+			drivestrength, cc_data_temp);
 	}
 }
 
 static void
 dhdsdio_chip_detach(struct dhd_bus *bus)
 {
-	DHD_TRACE(("%s: Enter\n", __func__));
+	dhd_dbg(TRACE, "%s: Enter\n", __func__);
 
 	kfree(bus->ci);
 	bus->ci = NULL;
-- 
1.7.5.rc3.dirty

