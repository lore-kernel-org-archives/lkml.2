Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab3AGWHt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 17:07:49 -0500
Received: from mout.gmx.net ([212.227.15.19]:49689 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755844Ab3AGWHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 17:07:36 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18r1/wTvV0rY05hjAX1b8gxbbmmH1q7LCpbMHl6pV
	iDVyidoqyEPhyS
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Devendra Naga <devendra.aaru@gmail.com>,
        Marcos Paulo de Souza <marcos.souza.org@gmail.com>,
        Priit Laes <plaes@plaes.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH] staging/csr: Fix dereference before check
Date: Mon,  7 Jan 2013 23:09:53 +0100
Message-Id: <1357596593-18225-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Smatch complains about some pointers that are dereferenced before being
checked:

drivers/staging/csr/sme_sys.c:285
CsrWifiRouterCtrlHipReqHandler() warn: variable dereferenced before
check 'priv' (see line 283)
drivers/staging/csr/sme_sys.c:1503
CsrWifiRouterMaPacketReqHandler() warn: variable dereferenced before
check 'priv' (see line 1501)
drivers/staging/csr/sme_sys.c:2062
CsrWifiRouterCtrlPeerDelReqHandler() warn: variable dereferenced before
check 'priv' (see line 2059)
drivers/staging/csr/sme_sys.c:2477
CsrWifiRouterCtrlPeerAddReqHandler() warn: variable dereferenced before
check 'priv' (see line 2474)
drivers/staging/csr/sme_sys.c:3045
CsrWifiRouterCtrlWapiRxPktReqHandler() warn: variable dereferenced
before check 'priv' (see line 3039)

We put the check before the dereferencing and prevent an oops and fix
the warning.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/csr/sme_sys.c |   41 ++++++++++++++++++++++++++---------------
 1 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/csr/sme_sys.c b/drivers/staging/csr/sme_sys.c
index 2b06819..b1151a2 100644
--- a/drivers/staging/csr/sme_sys.c
+++ b/drivers/staging/csr/sme_sys.c
@@ -280,7 +280,7 @@ void CsrWifiRouterCtrlHipReqHandler(void* drvpriv, CsrWifiFsmEvent* msg)
     CSR_SIGNAL *signal;
     u16 interfaceTag = 0;
     CSR_MA_PACKET_REQUEST *req;
-    netInterface_priv_t *interfacePriv = priv->interfacePriv[interfaceTag];
+    netInterface_priv_t *interfacePriv;
 
     if (priv == NULL) {
         return;
@@ -294,6 +294,8 @@ void CsrWifiRouterCtrlHipReqHandler(void* drvpriv, CsrWifiFsmEvent* msg)
         return;
     }
 
+    interfacePriv = priv->interfacePriv[interfaceTag];
+
     /* Initialize bulkdata to avoid os_net_buf is garbage */
     memset(&bulkdata, 0, sizeof(bulk_data_param_t));
 
@@ -1498,7 +1500,7 @@ void CsrWifiRouterMaPacketReqHandler(void* drvpriv, CsrWifiFsmEvent* msg)
     u8 *daddr, *saddr;
     u16 interfaceTag = mareq->interfaceTag & 0x00ff;
     int queue;
-    netInterface_priv_t *interfacePriv = priv->interfacePriv[interfaceTag];
+    netInterface_priv_t *interfacePriv;
 
     if (!mareq->frame || !priv || !priv->smepriv)
     {
@@ -1510,6 +1512,8 @@ void CsrWifiRouterMaPacketReqHandler(void* drvpriv, CsrWifiFsmEvent* msg)
         unifi_error(priv, "CsrWifiRouterMaPacketReqHandler: interfaceID >= CSR_WIFI_NUM_INTERFACES.\n");
         return;
     }
+
+    interfacePriv = priv->interfacePriv[interfaceTag];
     /* get a pointer to dest & source Mac address */
     daddr = mareq->frame;
     saddr = (mareq->frame + ETH_ALEN);
@@ -2056,9 +2060,9 @@ void CsrWifiRouterCtrlPeerDelReqHandler(void* drvpriv, CsrWifiFsmEvent* msg)
     CsrWifiRouterCtrlPeerDelReq* req = (CsrWifiRouterCtrlPeerDelReq*)msg;
     CsrResult status = CSR_RESULT_SUCCESS;
     unifi_priv_t *priv = (unifi_priv_t*)drvpriv;
-    netInterface_priv_t *interfacePriv = priv->interfacePriv[req->interfaceTag];
+    netInterface_priv_t *interfacePriv;
 
-    unifi_trace(priv, UDBG2, "entering CsrWifiRouterCtrlPeerDelReqHandler \n");
+    unifi_trace(priv, UDBG2, "entering CsrWifiRouterCtrlPeerDelReqHandler\n");
     if (priv == NULL)
     {
         unifi_error(priv, "CsrWifiRouterCtrlPeerDelReqHandler: invalid smepriv\n");
@@ -2071,6 +2075,8 @@ void CsrWifiRouterCtrlPeerDelReqHandler(void* drvpriv, CsrWifiFsmEvent* msg)
         return;
     }
 
+    interfacePriv = priv->interfacePriv[req->interfaceTag];
+
     switch(interfacePriv->interfaceMode)
     {
         case CSR_WIFI_ROUTER_CTRL_MODE_AP:
@@ -2471,7 +2477,7 @@ void CsrWifiRouterCtrlPeerAddReqHandler(void* drvpriv,CsrWifiFsmEvent* msg)
     CsrResult status = CSR_RESULT_SUCCESS;
     unifi_priv_t *priv = (unifi_priv_t*)drvpriv;
     u32 handle = 0;
-    netInterface_priv_t *interfacePriv = priv->interfacePriv[req->interfaceTag];
+    netInterface_priv_t *interfacePriv;
 
     unifi_trace(priv, UDBG2, "entering CsrWifiRouterCtrlPeerAddReqHandler \n");
     if (priv == NULL)
@@ -2486,6 +2492,8 @@ void CsrWifiRouterCtrlPeerAddReqHandler(void* drvpriv,CsrWifiFsmEvent* msg)
         return;
     }
 
+    interfacePriv = priv->interfacePriv[req->interfaceTag];
+
     switch(interfacePriv->interfaceMode)
     {
         case CSR_WIFI_ROUTER_CTRL_MODE_AP:
@@ -3036,21 +3044,24 @@ void CsrWifiRouterCtrlWapiRxPktReqHandler(void* drvpriv, CsrWifiFsmEvent* msg)
     ul_client_t *client;
     CSR_SIGNAL signal;
     CSR_MA_PACKET_INDICATION *pkt_ind;
-    netInterface_priv_t *interfacePriv = priv->interfacePriv[req->interfaceTag];
+    netInterface_priv_t *interfacePriv;
+
+    if (priv == NULL) {
+	    unifi_error(priv, "CsrWifiRouterCtrlWapiRxPktReq : invalid priv\n", __func__);
+	    return;
+    }
+
+    if (priv->smepriv == NULL) {
+	    unifi_error(priv, "CsrWifiRouterCtrlWapiRxPktReq : invalid sme priv\n", __func__);
+	    return;
+    }
+
+    interfacePriv = priv->interfacePriv[req->interfaceTag];
 
     if (CSR_WIFI_ROUTER_CTRL_MODE_STA == interfacePriv->interfaceMode) {
 
     	unifi_trace(priv, UDBG6, ">>%s\n", __FUNCTION__);
 
-        if (priv == NULL) {
-            unifi_error(priv, "CsrWifiRouterCtrlWapiRxPktReq : invalid priv\n",__FUNCTION__);
-            return;
-        }
-
-        if (priv->smepriv == NULL) {
-             unifi_error(priv, "CsrWifiRouterCtrlWapiRxPktReq : invalid sme priv\n",__FUNCTION__);
-             return;
-        }
 
         if (req->dataLength == 0 || req->data == NULL) {
              unifi_error(priv, "CsrWifiRouterCtrlWapiRxPktReq: invalid request\n",__FUNCTION__);
-- 
1.7.8.6

