Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179Ab2BIBmI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 20:42:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:37272 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab2BIBmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 20:42:06 -0500
X-Authority-Analysis: v=2.0 cv=T9kOvo2Q c=1 sm=0 a=4xDcOe4IjvRdPVVETi+CqA==:17 a=TRgVYD6ZyiEA:10 a=u2xrkPLzPQsA:10 a=Zx2FLkwYMp0A:10 a=kj9zAlcOel0A:10 a=yQdBAQUQAAAA:8 a=AXFKoysDTCddmr-wXt0A:9 a=96cl1kWGtXMRFUIDVowA:7 a=CjuIK1q_8ugA:10 a=IcxpeKGZWnEA:10 a=zd6iddzRxM_W29x7:21 a=0ZQSMzkmbqj5T-0q:21 a=4xDcOe4IjvRdPVVETi+CqA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 75.81.36.228
Date: Wed, 08 Feb 2012 19:42:03 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: r8712u: Simplify semaphores
Message-ID: <4f33246b.XnfV6XJlmISnIarM%Larry.Finger@lwfinger.net>
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am preparing to convert this driver from semaphore to mutex locking,
The first step has been to eliminate a number of semaphores that were
initialized but never used, and one whose only use was a single "up"
after initialization. A total of 9 semaphores were removed in this process.

One other change was to remove some inline semaphore routines that were
unused.

In addition, several cases had the following structure:

down()
if () {
   ...
}
up()

The locking overhead was reduced by moving the up/down inside the if
block.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

 drv_types.h       |    1 -
 os_intfs.c        |    1 -
 osdep_service.h   |   17 -----------------
 rtl8712_recv.c    |    2 --
 rtl871x_io.c      |    1 -
 rtl871x_io.h      |    1 -
 rtl871x_pwrctrl.c |   11 ++++-------
 rtl871x_pwrctrl.h |    1 -
 rtl871x_recv.c    |    1 -
 rtl871x_recv.h    |    3 ---
 rtl871x_xmit.c    |    3 ---
 rtl871x_xmit.h    |    3 ---
 usb_intf.c        |    1 -
 13 files changed, 4 insertions(+), 42 deletions(-)
---

Index: staging/drivers/staging/rtl8712/os_intfs.c
===================================================================
--- staging.orig/drivers/staging/rtl8712/os_intfs.c
+++ staging/drivers/staging/rtl8712/os_intfs.c
@@ -330,7 +330,6 @@ u8 r8712_init_drv_sw(struct _adapter *pa
 	padapter->stapriv.padapter = padapter;
 	r8712_init_bcmc_stainfo(padapter);
 	r8712_init_pwrctrl_priv(padapter);
-	sema_init(&(padapter->pwrctrlpriv.pnp_pwr_mgnt_sema), 0);
 	mp871xinit(padapter);
 	if (init_default_value(padapter) != _SUCCESS)
 		return _FAIL;
Index: staging/drivers/staging/rtl8712/rtl8712_recv.c
===================================================================
--- staging.orig/drivers/staging/rtl8712/rtl8712_recv.c
+++ staging/drivers/staging/rtl8712/rtl8712_recv.c
@@ -55,8 +55,6 @@ int r8712_init_recv_priv(struct recv_pri
 	int alignment = 0;
 	struct sk_buff *pskb = NULL;
 
-	sema_init(&precvpriv->recv_sema, 0);
-	sema_init(&precvpriv->terminate_recvthread_sema, 0);
 	/*init recv_buf*/
 	_init_queue(&precvpriv->free_recv_buf_queue);
 	precvpriv->pallocated_recv_buf = _malloc(NR_RECVBUFF *
Index: staging/drivers/staging/rtl8712/rtl871x_io.c
===================================================================
--- staging.orig/drivers/staging/rtl8712/rtl871x_io.c
+++ staging/drivers/staging/rtl8712/rtl871x_io.c
@@ -131,7 +131,6 @@ uint r8712_alloc_io_queue(struct _adapte
 	pio_req = (struct io_req *)(pio_queue->free_ioreqs_buf);
 	for (i = 0; i < NUM_IOREQ; i++) {
 		_init_listhead(&pio_req->list);
-		sema_init(&pio_req->sema, 0);
 		list_insert_tail(&pio_req->list, &pio_queue->free_ioreqs);
 		pio_req++;
 	}
Index: staging/drivers/staging/rtl8712/rtl871x_io.h
===================================================================
--- staging.orig/drivers/staging/rtl8712/rtl871x_io.h
+++ staging/drivers/staging/rtl8712/rtl871x_io.h
@@ -117,7 +117,6 @@ struct io_req {
 	u32	command;
 	u32	status;
 	u8	*pbuf;
-	struct semaphore sema;
 	void (*_async_io_callback)(struct _adapter *padater,
 				   struct io_req *pio_req, u8 *cnxt);
 	u8 *cnxt;
Index: staging/drivers/staging/rtl8712/rtl871x_pwrctrl.h
===================================================================
--- staging.orig/drivers/staging/rtl8712/rtl871x_pwrctrl.h
+++ staging/drivers/staging/rtl8712/rtl871x_pwrctrl.h
@@ -133,7 +133,6 @@ struct	pwrctrl_priv {
 	u8	rpwm_retry;
 	uint	bSetPSModeWorkItemInProgress;
 
-	struct semaphore pnp_pwr_mgnt_sema;
 	spinlock_t pnp_pwr_mgnt_lock;
 	s32	pnp_current_pwr_state;
 	u8	pnp_bstop_trx;
Index: staging/drivers/staging/rtl8712/rtl871x_recv.c
===================================================================
--- staging.orig/drivers/staging/rtl8712/rtl871x_recv.c
+++ staging/drivers/staging/rtl8712/rtl871x_recv.c
@@ -93,7 +93,6 @@ sint _r8712_init_recv_priv(struct recv_p
 		precvframe++;
 	}
 	precvpriv->rx_pending_cnt = 1;
-	sema_init(&precvpriv->allrxreturnevt, 0);
 	return r8712_init_recv_priv(precvpriv, padapter);
 }
 
Index: staging/drivers/staging/rtl8712/rtl871x_recv.h
===================================================================
--- staging.orig/drivers/staging/rtl8712/rtl871x_recv.h
+++ staging/drivers/staging/rtl8712/rtl871x_recv.h
@@ -85,8 +85,6 @@ using enter_critical section to protect
 */
 struct recv_priv {
 	spinlock_t lock;
-	struct semaphore recv_sema;
-	struct semaphore terminate_recvthread_sema;
 	struct  __queue	free_recv_queue;
 	struct  __queue	recv_pending_queue;
 	u8 *pallocated_frame_buf;
@@ -100,7 +98,6 @@ struct recv_priv {
 	uint  rx_largepacket_crcerr;
 	uint  rx_smallpacket_crcerr;
 	uint  rx_middlepacket_crcerr;
-	struct semaphore allrxreturnevt;
 	u8  rx_pending_cnt;
 	uint	ff_hwaddr;
 	struct tasklet_struct recv_tasklet;
Index: staging/drivers/staging/rtl8712/rtl871x_xmit.c
===================================================================
--- staging.orig/drivers/staging/rtl8712/rtl871x_xmit.c
+++ staging/drivers/staging/rtl8712/rtl871x_xmit.c
@@ -71,8 +71,6 @@ sint _r8712_init_xmit_priv(struct xmit_p
 
 	memset((unsigned char *)pxmitpriv, 0, sizeof(struct xmit_priv));
 	spin_lock_init(&pxmitpriv->lock);
-	sema_init(&pxmitpriv->xmit_sema, 0);
-	sema_init(&pxmitpriv->terminate_xmitthread_sema, 0);
 	/*
 	Please insert all the queue initializaiton using _init_queue below
 	*/
@@ -121,7 +119,6 @@ sint _r8712_init_xmit_priv(struct xmit_p
 	_r8712_init_hw_txqueue(&pxmitpriv->bmc_txqueue, BMC_QUEUE_INX);
 	pxmitpriv->frag_len = MAX_FRAG_THRESHOLD;
 	pxmitpriv->txirp_cnt = 1;
-	sema_init(&(pxmitpriv->tx_retevt), 0);
 	/*per AC pending irp*/
 	pxmitpriv->beq_cnt = 0;
 	pxmitpriv->bkq_cnt = 0;
Index: staging/drivers/staging/rtl8712/rtl871x_xmit.h
===================================================================
--- staging.orig/drivers/staging/rtl8712/rtl871x_xmit.h
+++ staging/drivers/staging/rtl8712/rtl871x_xmit.h
@@ -202,8 +202,6 @@ struct	hw_txqueue {
 
 struct	xmit_priv {
 	spinlock_t lock;
-	struct semaphore xmit_sema;
-	struct semaphore terminate_xmitthread_sema;
 	struct  __queue	be_pending;
 	struct  __queue	bk_pending;
 	struct  __queue	vi_pending;
@@ -233,7 +231,6 @@ struct	xmit_priv {
 	uint	tx_drop;
 	struct hw_xmit *hwxmits;
 	u8	hwxmit_entry;
-	struct semaphore tx_retevt;/*all tx return event;*/
 	u8	txirp_cnt;
 	struct tasklet_struct xmit_tasklet;
 	_workitem xmit_pipe4_reset_wi;
Index: staging/drivers/staging/rtl8712/drv_types.h
===================================================================
--- staging.orig/drivers/staging/rtl8712/drv_types.h
+++ staging/drivers/staging/rtl8712/drv_types.h
@@ -140,7 +140,6 @@ struct dvobj_priv {
 	u8   ishighspeed;
 	uint(*inirp_init)(struct _adapter *adapter);
 	uint(*inirp_deinit)(struct _adapter *adapter);
-	struct semaphore usb_suspend_sema;
 	struct usb_device *pusbdev;
 };
 
Index: staging/drivers/staging/rtl8712/usb_intf.c
===================================================================
--- staging.orig/drivers/staging/rtl8712/usb_intf.c
+++ staging/drivers/staging/rtl8712/usb_intf.c
@@ -281,7 +281,6 @@ static uint r8712_usb_dvobj_init(struct
 	}
 	if ((r8712_alloc_io_queue(padapter)) == _FAIL)
 		status = _FAIL;
-	sema_init(&(padapter->dvobjpriv.usb_suspend_sema), 0);
 	return status;
 }
 
Index: staging/drivers/staging/rtl8712/osdep_service.h
===================================================================
--- staging.orig/drivers/staging/rtl8712/osdep_service.h
+++ staging/drivers/staging/rtl8712/osdep_service.h
@@ -72,18 +72,6 @@ static inline struct list_head *get_list
 #define LIST_CONTAINOR(ptr, type, member) \
 	((type *)((char *)(ptr)-(SIZE_T)(&((type *)0)->member)))
 
-static inline void _enter_hwio_critical(struct semaphore *prwlock,
-					unsigned long *pirqL)
-{
-	down(prwlock);
-}
-
-static inline void _exit_hwio_critical(struct semaphore *prwlock,
-				       unsigned long *pirqL)
-{
-	up(prwlock);
-}
-
 static inline void list_delete(struct list_head *plist)
 {
 	list_del_init(plist);
@@ -152,11 +140,6 @@ static inline u32 _down_sema(struct sema
 		return _SUCCESS;
 }
 
-static inline void _rtl_rwlock_init(struct semaphore *prwlock)
-{
-	sema_init(prwlock, 1);
-}
-
 static inline void _init_listhead(struct list_head *list)
 {
 	INIT_LIST_HEAD(list);
Index: staging/drivers/staging/rtl8712/rtl871x_pwrctrl.c
===================================================================
--- staging.orig/drivers/staging/rtl8712/rtl871x_pwrctrl.c
+++ staging/drivers/staging/rtl8712/rtl871x_pwrctrl.c
@@ -100,7 +100,6 @@ void r8712_cpwm_int_hdl(struct _adapter
 {
 	struct pwrctrl_priv *pwrpriv = &(padapter->pwrctrlpriv);
 	struct cmd_priv	*pcmdpriv = &(padapter->cmdpriv);
-	struct xmit_priv *pxmitpriv = &(padapter->xmitpriv);
 
 	if (pwrpriv->cpwm_tog == ((preportpwrstate->state) & 0x80))
 		return;
@@ -110,8 +109,6 @@ void r8712_cpwm_int_hdl(struct _adapter
 	if (pwrpriv->cpwm >= PS_STATE_S2) {
 		if (pwrpriv->alives & CMD_ALIVE)
 			up(&(pcmdpriv->cmd_queue_sema));
-		if (pwrpriv->alives & XMIT_ALIVE)
-			up(&(pxmitpriv->xmit_sema));
 	}
 	pwrpriv->cpwm_tog = (preportpwrstate->state) & 0x80;
 	up(&pwrpriv->lock);
@@ -145,12 +142,12 @@ static void SetPSModeWorkItemCallback(st
 				       struct pwrctrl_priv, SetPSModeWorkItem);
 	struct _adapter *padapter = container_of(pwrpriv,
 				    struct _adapter, pwrctrlpriv);
-	_enter_pwrlock(&pwrpriv->lock);
 	if (!pwrpriv->bSleep) {
+		_enter_pwrlock(&pwrpriv->lock);
 		if (pwrpriv->pwr_mode == PS_MODE_ACTIVE)
 			r8712_set_rpwm(padapter, PS_STATE_S4);
+		up(&pwrpriv->lock);
 	}
-	up(&pwrpriv->lock);
 }
 
 static void rpwm_workitem_callback(struct work_struct *work)
@@ -160,13 +157,13 @@ static void rpwm_workitem_callback(struc
 	struct _adapter *padapter = container_of(pwrpriv,
 				    struct _adapter, pwrctrlpriv);
 	u8 cpwm = pwrpriv->cpwm;
-	_enter_pwrlock(&pwrpriv->lock);
 	if (pwrpriv->cpwm != pwrpriv->rpwm) {
+		_enter_pwrlock(&pwrpriv->lock);
 		cpwm = r8712_read8(padapter, SDIO_HCPWM);
 		pwrpriv->rpwm_retry = 1;
 		r8712_set_rpwm(padapter, pwrpriv->rpwm);
+		up(&pwrpriv->lock);
 	}
-	up(&pwrpriv->lock);
 }
 
 static void rpwm_check_handler (void *FunctionContext)
