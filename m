Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab1EXKCv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 06:02:51 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:50686 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752Ab1EXKCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 06:02:48 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6355"; a="93037261"
From: Tatyana Brokhman <tlinder@codeaurora.org>
To: greg@kroah.com
Cc: linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org, balbi@ti.com,
        ablay@codeaurora.org, Tatyana Brokhman <tlinder@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH/RESEND v13 3/8] usb: Modify existing gadget drivers to use config_ep_by_speed() instead of ep_choose.
Date: Tue, 24 May 2011 13:02:00 +0300
Message-Id: <1306231330-11158-4-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1306231330-11158-1-git-send-email-tlinder@codeaurora.org>
References: <1306231330-11158-1-git-send-email-tlinder@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove obsolete functions:
1. ep_choose()
2. usb_find_endpoint()

Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

---
 drivers/usb/gadget/config.c         |   25 ------------------
 drivers/usb/gadget/f_acm.c          |   47 ++++++++++-----------------------
 drivers/usb/gadget/f_ecm.c          |   45 ++++++++++----------------------
 drivers/usb/gadget/f_eem.c          |   32 ++++++----------------
 drivers/usb/gadget/f_hid.c          |   19 ++++---------
 drivers/usb/gadget/f_loopback.c     |   11 +++++---
 drivers/usb/gadget/f_mass_storage.c |   34 +++++++++---------------
 drivers/usb/gadget/f_ncm.c          |   49 ++++++++++------------------------
 drivers/usb/gadget/f_obex.c         |   32 ++++++----------------
 drivers/usb/gadget/f_phonet.c       |   12 ++++----
 drivers/usb/gadget/f_rndis.c        |   45 +++++++++----------------------
 drivers/usb/gadget/f_serial.c       |   32 +++++-----------------
 drivers/usb/gadget/f_sourcesink.c   |    8 ++++-
 drivers/usb/gadget/f_subset.c       |   29 ++++----------------
 include/linux/usb/composite.h       |   15 ----------
 include/linux/usb/gadget.h          |    6 ----
 16 files changed, 126 insertions(+), 315 deletions(-)

diff --git a/drivers/usb/gadget/config.c b/drivers/usb/gadget/config.c
index 09084fd..b2c0013 100644
--- a/drivers/usb/gadget/config.c
+++ b/drivers/usb/gadget/config.c
@@ -165,28 +165,3 @@ usb_copy_descriptors(struct usb_descriptor_header **src)
 	return ret;
 }
 
-/**
- * usb_find_endpoint - find a copy of an endpoint descriptor
- * @src: original vector of descriptors
- * @copy: copy of @src
- * @match: endpoint descriptor found in @src
- *
- * This returns the copy of the @match descriptor made for @copy.  Its
- * intended use is to help remembering the endpoint descriptor to use
- * when enabling a given endpoint.
- */
-struct usb_endpoint_descriptor *
-usb_find_endpoint(
-	struct usb_descriptor_header **src,
-	struct usb_descriptor_header **copy,
-	struct usb_endpoint_descriptor *match
-)
-{
-	while (*src) {
-		if (*src == (void *) match)
-			return (void *)*copy;
-		src++;
-		copy++;
-	}
-	return NULL;
-}
diff --git a/drivers/usb/gadget/f_acm.c b/drivers/usb/gadget/f_acm.c
index d04b4a6..3f88493 100644
--- a/drivers/usb/gadget/f_acm.c
+++ b/drivers/usb/gadget/f_acm.c
@@ -39,12 +39,6 @@
  * descriptors (roughly equivalent to CDC Unions) may sometimes help.
  */
 
-struct acm_ep_descs {
-	struct usb_endpoint_descriptor	*in;
-	struct usb_endpoint_descriptor	*out;
-	struct usb_endpoint_descriptor	*notify;
-};
-
 struct f_acm {
 	struct gserial			port;
 	u8				ctrl_id, data_id;
@@ -58,9 +52,6 @@ struct f_acm {
 	 */
 	spinlock_t			lock;
 
-	struct acm_ep_descs		fs;
-	struct acm_ep_descs		hs;
-
 	struct usb_ep			*notify;
 	struct usb_request		*notify_req;
 
@@ -404,9 +395,8 @@ static int acm_set_alt(struct usb_function *f, unsigned intf, unsigned alt)
 			usb_ep_disable(acm->notify);
 		} else {
 			VDBG(cdev, "init acm ctrl interface %d\n", intf);
-			acm->notify->desc = ep_choose(cdev->gadget,
-					acm->hs.notify,
-					acm->fs.notify);
+			if (config_ep_by_speed(cdev->gadget, f, acm->notify))
+				return -EINVAL;
 		}
 		usb_ep_enable(acm->notify);
 		acm->notify->driver_data = acm;
@@ -415,12 +405,17 @@ static int acm_set_alt(struct usb_function *f, unsigned intf, unsigned alt)
 		if (acm->port.in->driver_data) {
 			DBG(cdev, "reset acm ttyGS%d\n", acm->port_num);
 			gserial_disconnect(&acm->port);
-		} else {
+		}
+		if (!acm->port.in->desc || !acm->port.out->desc) {
 			DBG(cdev, "activate acm ttyGS%d\n", acm->port_num);
-			acm->port.in->desc = ep_choose(cdev->gadget,
-					acm->hs.in, acm->fs.in);
-			acm->port.out->desc = ep_choose(cdev->gadget,
-					acm->hs.out, acm->fs.out);
+			if (config_ep_by_speed(cdev->gadget, f,
+					       acm->port.in) ||
+			    config_ep_by_speed(cdev->gadget, f,
+					       acm->port.out)) {
+				acm->port.in->desc = NULL;
+				acm->port.out->desc = NULL;
+				return -EINVAL;
+			}
 		}
 		gserial_connect(&acm->port, acm->port_num);
 
@@ -628,18 +623,11 @@ acm_bind(struct usb_configuration *c, struct usb_function *f)
 	acm->notify_req->complete = acm_cdc_notify_complete;
 	acm->notify_req->context = acm;
 
-	/* copy descriptors, and track endpoint copies */
+	/* copy descriptors */
 	f->descriptors = usb_copy_descriptors(acm_fs_function);
 	if (!f->descriptors)
 		goto fail;
 
-	acm->fs.in = usb_find_endpoint(acm_fs_function,
-			f->descriptors, &acm_fs_in_desc);
-	acm->fs.out = usb_find_endpoint(acm_fs_function,
-			f->descriptors, &acm_fs_out_desc);
-	acm->fs.notify = usb_find_endpoint(acm_fs_function,
-			f->descriptors, &acm_fs_notify_desc);
-
 	/* support all relevant hardware speeds... we expect that when
 	 * hardware is dual speed, all bulk-capable endpoints work at
 	 * both speeds
@@ -652,15 +640,8 @@ acm_bind(struct usb_configuration *c, struct usb_function *f)
 		acm_hs_notify_desc.bEndpointAddress =
 				acm_fs_notify_desc.bEndpointAddress;
 
-		/* copy descriptors, and track endpoint copies */
+		/* copy descriptors */
 		f->hs_descriptors = usb_copy_descriptors(acm_hs_function);
-
-		acm->hs.in = usb_find_endpoint(acm_hs_function,
-				f->hs_descriptors, &acm_hs_in_desc);
-		acm->hs.out = usb_find_endpoint(acm_hs_function,
-				f->hs_descriptors, &acm_hs_out_desc);
-		acm->hs.notify = usb_find_endpoint(acm_hs_function,
-				f->hs_descriptors, &acm_hs_notify_desc);
 	}
 
 	DBG(cdev, "acm ttyGS%d: %s speed IN/%s OUT/%s NOTIFY/%s\n",
diff --git a/drivers/usb/gadget/f_ecm.c b/drivers/usb/gadget/f_ecm.c
index 7c996f2..ddedbc83 100644
--- a/drivers/usb/gadget/f_ecm.c
+++ b/drivers/usb/gadget/f_ecm.c
@@ -46,11 +46,6 @@
  * and also means that a get_alt() method is required.
  */
 
-struct ecm_ep_descs {
-	struct usb_endpoint_descriptor	*in;
-	struct usb_endpoint_descriptor	*out;
-	struct usb_endpoint_descriptor	*notify;
-};
 
 enum ecm_notify_state {
 	ECM_NOTIFY_NONE,		/* don't notify */
@@ -64,9 +59,6 @@ struct f_ecm {
 
 	char				ethaddr[14];
 
-	struct ecm_ep_descs		fs;
-	struct ecm_ep_descs		hs;
-
 	struct usb_ep			*notify;
 	struct usb_request		*notify_req;
 	u8				notify_state;
@@ -463,11 +455,11 @@ static int ecm_set_alt(struct usb_function *f, unsigned intf, unsigned alt)
 		if (ecm->notify->driver_data) {
 			VDBG(cdev, "reset ecm control %d\n", intf);
 			usb_ep_disable(ecm->notify);
-		} else {
+		}
+		if (!(ecm->notify->desc)) {
 			VDBG(cdev, "init ecm ctrl %d\n", intf);
-			ecm->notify->desc = ep_choose(cdev->gadget,
-					ecm->hs.notify,
-					ecm->fs.notify);
+			if (config_ep_by_speed(cdev->gadget, f, ecm->notify))
+				goto fail;
 		}
 		usb_ep_enable(ecm->notify);
 		ecm->notify->driver_data = ecm;
@@ -482,12 +474,17 @@ static int ecm_set_alt(struct usb_function *f, unsigned intf, unsigned alt)
 			gether_disconnect(&ecm->port);
 		}
 
-		if (!ecm->port.in_ep->desc) {
+		if (!ecm->port.in_ep->desc ||
+		    !ecm->port.out_ep->desc) {
 			DBG(cdev, "init ecm\n");
-			ecm->port.in_ep->desc = ep_choose(cdev->gadget,
-					ecm->hs.in, ecm->fs.in);
-			ecm->port.out_ep->desc = ep_choose(cdev->gadget,
-					ecm->hs.out, ecm->fs.out);
+			if (config_ep_by_speed(cdev->gadget, f,
+					       ecm->port.in_ep) ||
+			    config_ep_by_speed(cdev->gadget, f,
+					       ecm->port.out_ep)) {
+				ecm->port.in_ep->desc = NULL;
+				ecm->port.out_ep->desc = NULL;
+				goto fail;
+			}
 		}
 
 		/* CDC Ethernet only sends data in non-default altsettings.
@@ -664,13 +661,6 @@ ecm_bind(struct usb_configuration *c, struct usb_function *f)
 	if (!f->descriptors)
 		goto fail;
 
-	ecm->fs.in = usb_find_endpoint(ecm_fs_function,
-			f->descriptors, &fs_ecm_in_desc);
-	ecm->fs.out = usb_find_endpoint(ecm_fs_function,
-			f->descriptors, &fs_ecm_out_desc);
-	ecm->fs.notify = usb_find_endpoint(ecm_fs_function,
-			f->descriptors, &fs_ecm_notify_desc);
-
 	/* support all relevant hardware speeds... we expect that when
 	 * hardware is dual speed, all bulk-capable endpoints work at
 	 * both speeds
@@ -687,13 +677,6 @@ ecm_bind(struct usb_configuration *c, struct usb_function *f)
 		f->hs_descriptors = usb_copy_descriptors(ecm_hs_function);
 		if (!f->hs_descriptors)
 			goto fail;
-
-		ecm->hs.in = usb_find_endpoint(ecm_hs_function,
-				f->hs_descriptors, &hs_ecm_in_desc);
-		ecm->hs.out = usb_find_endpoint(ecm_hs_function,
-				f->hs_descriptors, &hs_ecm_out_desc);
-		ecm->hs.notify = usb_find_endpoint(ecm_hs_function,
-				f->hs_descriptors, &hs_ecm_notify_desc);
 	}
 
 	/* NOTE:  all that is done without knowing or caring about
diff --git a/drivers/usb/gadget/f_eem.c b/drivers/usb/gadget/f_eem.c
index fea8e3b..3e41274 100644
--- a/drivers/usb/gadget/f_eem.c
+++ b/drivers/usb/gadget/f_eem.c
@@ -35,17 +35,9 @@
  * Ethernet link.
  */
 
-struct eem_ep_descs {
-	struct usb_endpoint_descriptor	*in;
-	struct usb_endpoint_descriptor	*out;
-};
-
 struct f_eem {
 	struct gether			port;
 	u8				ctrl_id;
-
-	struct eem_ep_descs		fs;
-	struct eem_ep_descs		hs;
 };
 
 static inline struct f_eem *func_to_eem(struct usb_function *f)
@@ -176,12 +168,16 @@ static int eem_set_alt(struct usb_function *f, unsigned intf, unsigned alt)
 			gether_disconnect(&eem->port);
 		}
 
-		if (!eem->port.in_ep->desc) {
+		if (!eem->port.in_ep->desc || !eem->port.out_ep->desc) {
 			DBG(cdev, "init eem\n");
-			eem->port.in_ep->desc = ep_choose(cdev->gadget,
-					eem->hs.in, eem->fs.in);
-			eem->port.out_ep->desc = ep_choose(cdev->gadget,
-					eem->hs.out, eem->fs.out);
+			if (config_ep_by_speed(cdev->gadget, f,
+					       eem->port.in_ep) ||
+			    config_ep_by_speed(cdev->gadget, f,
+					       eem->port.out_ep)) {
+				eem->port.in_ep->desc = NULL;
+				eem->port.out_ep->desc = NULL;
+				goto fail;
+			}
 		}
 
 		/* zlps should not occur because zero-length EEM packets
@@ -253,11 +249,6 @@ eem_bind(struct usb_configuration *c, struct usb_function *f)
 	if (!f->descriptors)
 		goto fail;
 
-	eem->fs.in = usb_find_endpoint(eem_fs_function,
-			f->descriptors, &eem_fs_in_desc);
-	eem->fs.out = usb_find_endpoint(eem_fs_function,
-			f->descriptors, &eem_fs_out_desc);
-
 	/* support all relevant hardware speeds... we expect that when
 	 * hardware is dual speed, all bulk-capable endpoints work at
 	 * both speeds
@@ -272,11 +263,6 @@ eem_bind(struct usb_configuration *c, struct usb_function *f)
 		f->hs_descriptors = usb_copy_descriptors(eem_hs_function);
 		if (!f->hs_descriptors)
 			goto fail;
-
-		eem->hs.in = usb_find_endpoint(eem_hs_function,
-				f->hs_descriptors, &eem_hs_in_desc);
-		eem->hs.out = usb_find_endpoint(eem_hs_function,
-				f->hs_descriptors, &eem_hs_out_desc);
 	}
 
 	DBG(cdev, "CDC Ethernet (EEM): %s speed IN/%s OUT/%s\n",
diff --git a/drivers/usb/gadget/f_hid.c b/drivers/usb/gadget/f_hid.c
index 12879b6..403a48b 100644
--- a/drivers/usb/gadget/f_hid.c
+++ b/drivers/usb/gadget/f_hid.c
@@ -59,8 +59,6 @@ struct f_hidg {
 	struct cdev			cdev;
 	struct usb_function		func;
 	struct usb_ep			*in_ep;
-	struct usb_endpoint_descriptor	*fs_in_ep_desc;
-	struct usb_endpoint_descriptor	*hs_in_ep_desc;
 };
 
 static inline struct f_hidg *func_to_hidg(struct usb_function *f)
@@ -425,8 +423,12 @@ static int hidg_set_alt(struct usb_function *f, unsigned intf, unsigned alt)
 		if (hidg->in_ep->driver_data != NULL)
 			usb_ep_disable(hidg->in_ep);
 
-		hidg->in_ep->desc = ep_choose(f->config->cdev->gadget,
-				hidg->hs_in_ep_desc, hidg->fs_in_ep_desc);
+		status = config_ep_by_speed(f->config->cdev->gadget, f,
+					    hidg->in_ep);
+		if (status) {
+			ERROR(cdev, "config_ep_by_speed FAILED!\n");
+			goto fail;
+		}
 		status = usb_ep_enable(hidg->in_ep);
 		if (status < 0) {
 			ERROR(cdev, "Enable endpoint FAILED!\n");
@@ -497,21 +499,12 @@ static int __init hidg_bind(struct usb_configuration *c, struct usb_function *f)
 	if (!f->descriptors)
 		goto fail;
 
-	hidg->fs_in_ep_desc = usb_find_endpoint(hidg_fs_descriptors,
-						f->descriptors,
-						&hidg_fs_in_ep_desc);
-
 	if (gadget_is_dualspeed(c->cdev->gadget)) {
 		hidg_hs_in_ep_desc.bEndpointAddress =
 			hidg_fs_in_ep_desc.bEndpointAddress;
 		f->hs_descriptors = usb_copy_descriptors(hidg_hs_descriptors);
 		if (!f->hs_descriptors)
 			goto fail;
-		hidg->hs_in_ep_desc = usb_find_endpoint(hidg_hs_descriptors,
-							f->hs_descriptors,
-							&hidg_hs_in_ep_desc);
-	} else {
-		hidg->hs_in_ep_desc = NULL;
 	}
 
 	mutex_init(&hidg->lock);
diff --git a/drivers/usb/gadget/f_loopback.c b/drivers/usb/gadget/f_loopback.c
index 34e3cca..3756326 100644
--- a/drivers/usb/gadget/f_loopback.c
+++ b/drivers/usb/gadget/f_loopback.c
@@ -256,8 +256,9 @@ enable_loopback(struct usb_composite_dev *cdev, struct f_loopback *loop)
 
 	/* one endpoint writes data back IN to the host */
 	ep = loop->in_ep;
-	ep->desc = ep_choose(cdev->gadget,
-			&hs_loop_source_desc, &fs_loop_source_desc);
+	result = config_ep_by_speed(cdev->gadget, &(loop->function), ep);
+	if (result)
+		return result;
 	result = usb_ep_enable(ep);
 	if (result < 0)
 		return result;
@@ -265,8 +266,10 @@ enable_loopback(struct usb_composite_dev *cdev, struct f_loopback *loop)
 
 	/* one endpoint just reads OUT packets */
 	ep = loop->out_ep;
-	ep->desc = ep_choose(cdev->gadget,
-			&hs_loop_sink_desc, &fs_loop_sink_desc);
+	result = config_ep_by_speed(cdev->gadget, &(loop->function), ep);
+	if (result)
+		goto fail0;
+
 	result = usb_ep_enable(ep);
 	if (result < 0) {
 fail0:
diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index 4eee434..5b93395 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -2324,19 +2324,6 @@ static int get_next_command(struct fsg_common *common)
 
 /*-------------------------------------------------------------------------*/
 
-static int enable_endpoint(struct fsg_common *common, struct usb_ep *ep,
-		const struct usb_endpoint_descriptor *d)
-{
-	int	rc;
-
-	ep->driver_data = common;
-	ep->desc = (struct usb_endpoint_descriptor *)d;
-	rc = usb_ep_enable(ep);
-	if (rc)
-		ERROR(common, "can't enable %s, result %d\n", ep->name, rc);
-	return rc;
-}
-
 static int alloc_request(struct fsg_common *common, struct usb_ep *ep,
 		struct usb_request **preq)
 {
@@ -2350,7 +2337,6 @@ static int alloc_request(struct fsg_common *common, struct usb_ep *ep,
 /* Reset interface setting and re-init endpoint state (toggle etc). */
 static int do_set_interface(struct fsg_common *common, struct fsg_dev *new_fsg)
 {
-	const struct usb_endpoint_descriptor *d;
 	struct fsg_dev *fsg;
 	int i, rc = 0;
 
@@ -2397,20 +2383,26 @@ reset:
 	fsg = common->fsg;
 
 	/* Enable the endpoints */
-	d = fsg_ep_desc(common->gadget,
-			&fsg_fs_bulk_in_desc, &fsg_hs_bulk_in_desc);
-	rc = enable_endpoint(common, fsg->bulk_in, d);
+	rc = config_ep_by_speed(common->gadget, &(fsg->function), fsg->bulk_in);
+	if (rc)
+		goto reset;
+	rc = usb_ep_enable(fsg->bulk_in);
 	if (rc)
 		goto reset;
+	fsg->bulk_in->driver_data = common;
 	fsg->bulk_in_enabled = 1;
 
-	d = fsg_ep_desc(common->gadget,
-			&fsg_fs_bulk_out_desc, &fsg_hs_bulk_out_desc);
-	rc = enable_endpoint(common, fsg->bulk_out, d);
+	rc = config_ep_by_speed(common->gadget, &(fsg->function),
+				fsg->bulk_out);
+	if (rc)
+		goto reset;
+	rc = usb_ep_enable(fsg->bulk_out);
 	if (rc)
 		goto reset;
+	fsg->bulk_out->driver_data = common;
 	fsg->bulk_out_enabled = 1;
-	common->bulk_out_maxpacket = le16_to_cpu(d->wMaxPacketSize);
+	common->bulk_out_maxpacket =
+		le16_to_cpu(fsg->bulk_out->desc->wMaxPacketSize);
 	clear_bit(IGNORE_BULK_OUT, &fsg->atomic_bitflags);
 
 	/* Allocate the requests */
diff --git a/drivers/usb/gadget/f_ncm.c b/drivers/usb/gadget/f_ncm.c
index 06daa1b..ae69ed7 100644
--- a/drivers/usb/gadget/f_ncm.c
+++ b/drivers/usb/gadget/f_ncm.c
@@ -48,12 +48,6 @@
 #define NCM_NDP_HDR_CRC		0x01000000
 #define NCM_NDP_HDR_NOCRC	0x00000000
 
-struct ncm_ep_descs {
-	struct usb_endpoint_descriptor	*in;
-	struct usb_endpoint_descriptor	*out;
-	struct usb_endpoint_descriptor	*notify;
-};
-
 enum ncm_notify_state {
 	NCM_NOTIFY_NONE,		/* don't notify */
 	NCM_NOTIFY_CONNECT,		/* issue CONNECT next */
@@ -66,9 +60,6 @@ struct f_ncm {
 
 	char				ethaddr[14];
 
-	struct ncm_ep_descs		fs;
-	struct ncm_ep_descs		hs;
-
 	struct usb_ep			*notify;
 	struct usb_request		*notify_req;
 	u8				notify_state;
@@ -801,11 +792,12 @@ static int ncm_set_alt(struct usb_function *f, unsigned intf, unsigned alt)
 		if (ncm->notify->driver_data) {
 			DBG(cdev, "reset ncm control %d\n", intf);
 			usb_ep_disable(ncm->notify);
-		} else {
+		}
+
+		if (!(ncm->notify->desc)) {
 			DBG(cdev, "init ncm ctrl %d\n", intf);
-			ncm->notify->desc = ep_choose(cdev->gadget,
-					ncm->hs.notify,
-					ncm->fs.notify);
+			if (config_ep_by_speed(cdev->gadget, f, ncm->notify))
+				goto fail;
 		}
 		usb_ep_enable(ncm->notify);
 		ncm->notify->driver_data = ncm;
@@ -828,14 +820,17 @@ static int ncm_set_alt(struct usb_function *f, unsigned intf, unsigned alt)
 		if (alt == 1) {
 			struct net_device	*net;
 
-			if (!ncm->port.in_ep->desc) {
+			if (!ncm->port.in_ep->desc ||
+			    !ncm->port.out_ep->desc) {
 				DBG(cdev, "init ncm\n");
-				ncm->port.in_ep->desc = ep_choose(cdev->gadget,
-							 ncm->hs.in,
-							 ncm->fs.in);
-				ncm->port.out_ep->desc = ep_choose(cdev->gadget,
-							  ncm->hs.out,
-							  ncm->fs.out);
+				if (config_ep_by_speed(cdev->gadget, f,
+						       ncm->port.in_ep) ||
+				    config_ep_by_speed(cdev->gadget, f,
+						       ncm->port.out_ep)) {
+					ncm->port.in_ep->desc = NULL;
+					ncm->port.out_ep->desc = NULL;
+					goto fail;
+				}
 			}
 
 			/* TODO */
@@ -1227,13 +1222,6 @@ ncm_bind(struct usb_configuration *c, struct usb_function *f)
 	if (!f->descriptors)
 		goto fail;
 
-	ncm->fs.in = usb_find_endpoint(ncm_fs_function,
-			f->descriptors, &fs_ncm_in_desc);
-	ncm->fs.out = usb_find_endpoint(ncm_fs_function,
-			f->descriptors, &fs_ncm_out_desc);
-	ncm->fs.notify = usb_find_endpoint(ncm_fs_function,
-			f->descriptors, &fs_ncm_notify_desc);
-
 	/*
 	 * support all relevant hardware speeds... we expect that when
 	 * hardware is dual speed, all bulk-capable endpoints work at
@@ -1251,13 +1239,6 @@ ncm_bind(struct usb_configuration *c, struct usb_function *f)
 		f->hs_descriptors = usb_copy_descriptors(ncm_hs_function);
 		if (!f->hs_descriptors)
 			goto fail;
-
-		ncm->hs.in = usb_find_endpoint(ncm_hs_function,
-				f->hs_descriptors, &hs_ncm_in_desc);
-		ncm->hs.out = usb_find_endpoint(ncm_hs_function,
-				f->hs_descriptors, &hs_ncm_out_desc);
-		ncm->hs.notify = usb_find_endpoint(ncm_hs_function,
-				f->hs_descriptors, &hs_ncm_notify_desc);
 	}
 
 	/*
diff --git a/drivers/usb/gadget/f_obex.c b/drivers/usb/gadget/f_obex.c
index a6dbda09..394502a 100644
--- a/drivers/usb/gadget/f_obex.c
+++ b/drivers/usb/gadget/f_obex.c
@@ -39,20 +39,12 @@
  * ready to handle the commands.
  */
 
-struct obex_ep_descs {
-	struct usb_endpoint_descriptor	*obex_in;
-	struct usb_endpoint_descriptor	*obex_out;
-};
-
 struct f_obex {
 	struct gserial			port;
 	u8				ctrl_id;
 	u8				data_id;
 	u8				port_num;
 	u8				can_activate;
-
-	struct obex_ep_descs		fs;
-	struct obex_ep_descs		hs;
 };
 
 static inline struct f_obex *func_to_obex(struct usb_function *f)
@@ -227,12 +219,16 @@ static int obex_set_alt(struct usb_function *f, unsigned intf, unsigned alt)
 			gserial_disconnect(&obex->port);
 		}
 
-		if (!obex->port.in->desc) {
+		if (!obex->port.in->desc || !obex->port.out->desc) {
 			DBG(cdev, "init obex ttyGS%d\n", obex->port_num);
-			obex->port.in->desc = ep_choose(cdev->gadget,
-					obex->hs.obex_in, obex->fs.obex_in);
-			obex->port.out->desc = ep_choose(cdev->gadget,
-					obex->hs.obex_out, obex->fs.obex_out);
+			if (config_ep_by_speed(cdev->gadget, f,
+					       obex->port.in) ||
+			    config_ep_by_speed(cdev->gadget, f,
+					       obex->port.out)) {
+				obex->port.out->desc = NULL;
+				obex->port.in->desc = NULL;
+				goto fail;
+			}
 		}
 
 		if (alt == 1) {
@@ -346,11 +342,6 @@ obex_bind(struct usb_configuration *c, struct usb_function *f)
 	/* copy descriptors, and track endpoint copies */
 	f->descriptors = usb_copy_descriptors(fs_function);
 
-	obex->fs.obex_in = usb_find_endpoint(fs_function,
-			f->descriptors, &obex_fs_ep_in_desc);
-	obex->fs.obex_out = usb_find_endpoint(fs_function,
-			f->descriptors, &obex_fs_ep_out_desc);
-
 	/* support all relevant hardware speeds... we expect that when
 	 * hardware is dual speed, all bulk-capable endpoints work at
 	 * both speeds
@@ -364,11 +355,6 @@ obex_bind(struct usb_configuration *c, struct usb_function *f)
 
 		/* copy descriptors, and track endpoint copies */
 		f->hs_descriptors = usb_copy_descriptors(hs_function);
-
-		obex->hs.obex_in = usb_find_endpoint(hs_function,
-				f->hs_descriptors, &obex_hs_ep_in_desc);
-		obex->hs.obex_out = usb_find_endpoint(hs_function,
-				f->hs_descriptors, &obex_hs_ep_out_desc);
 	}
 
 	/* Avoid letting this gadget enumerate until the userspace
diff --git a/drivers/usb/gadget/f_phonet.c b/drivers/usb/gadget/f_phonet.c
index dc63f16..0d6d260 100644
--- a/drivers/usb/gadget/f_phonet.c
+++ b/drivers/usb/gadget/f_phonet.c
@@ -429,12 +429,12 @@ static int pn_set_alt(struct usb_function *f, unsigned intf, unsigned alt)
 		if (alt == 1) {
 			int i;
 
-			fp->out_ep->desc = ep_choose(gadget,
-					&pn_hs_sink_desc,
-					&pn_fs_sink_desc);
-			fp->in_ep->desc = ep_choose(gadget,
-					&pn_hs_source_desc,
-					&pn_fs_source_desc);
+			if (config_ep_by_speed(gadget, f, fp->in_ep) ||
+			    config_ep_by_speed(gadget, f, fp->out_ep)) {
+				fp->in_ep->desc = NULL;
+				fp->out_ep->desc = NULL;
+				return -EINVAL;
+			}
 			usb_ep_enable(fp->out_ep);
 			usb_ep_enable(fp->in_ep);
 
diff --git a/drivers/usb/gadget/f_rndis.c b/drivers/usb/gadget/f_rndis.c
index 4646254..b324efa 100644
--- a/drivers/usb/gadget/f_rndis.c
+++ b/drivers/usb/gadget/f_rndis.c
@@ -76,21 +76,12 @@
  *   - MS-Windows drivers sometimes emit undocumented requests.
  */
 
-struct rndis_ep_descs {
-	struct usb_endpoint_descriptor	*in;
-	struct usb_endpoint_descriptor	*out;
-	struct usb_endpoint_descriptor	*notify;
-};
-
 struct f_rndis {
 	struct gether			port;
 	u8				ctrl_id, data_id;
 	u8				ethaddr[ETH_ALEN];
 	int				config;
 
-	struct rndis_ep_descs		fs;
-	struct rndis_ep_descs		hs;
-
 	struct usb_ep			*notify;
 	struct usb_request		*notify_req;
 	atomic_t			notify_count;
@@ -483,11 +474,11 @@ static int rndis_set_alt(struct usb_function *f, unsigned intf, unsigned alt)
 		if (rndis->notify->driver_data) {
 			VDBG(cdev, "reset rndis control %d\n", intf);
 			usb_ep_disable(rndis->notify);
-		} else {
+		}
+		if (!rndis->notify->desc) {
 			VDBG(cdev, "init rndis ctrl %d\n", intf);
-			rndis->notify->desc = ep_choose(cdev->gadget,
-					rndis->hs.notify,
-					rndis->fs.notify);
+			if (config_ep_by_speed(cdev->gadget, f, rndis->notify))
+				goto fail;
 		}
 		usb_ep_enable(rndis->notify);
 		rndis->notify->driver_data = rndis;
@@ -500,12 +491,16 @@ static int rndis_set_alt(struct usb_function *f, unsigned intf, unsigned alt)
 			gether_disconnect(&rndis->port);
 		}
 
-		if (!rndis->port.in_ep->desc) {
+		if (!rndis->port.in_ep->desc || !rndis->port.out_ep->desc) {
 			DBG(cdev, "init rndis\n");
-			rndis->port.in_ep->desc = ep_choose(cdev->gadget,
-					rndis->hs.in, rndis->fs.in);
-			rndis->port.out_ep->desc = ep_choose(cdev->gadget,
-					rndis->hs.out, rndis->fs.out);
+			if (config_ep_by_speed(cdev->gadget, f,
+					       rndis->port.in_ep) ||
+			    config_ep_by_speed(cdev->gadget, f,
+					       rndis->port.out_ep)) {
+				rndis->port.in_ep->desc = NULL;
+				rndis->port.out_ep->desc = NULL;
+				goto fail;
+			}
 		}
 
 		/* Avoid ZLPs; they can be troublesome. */
@@ -661,13 +656,6 @@ rndis_bind(struct usb_configuration *c, struct usb_function *f)
 	if (!f->descriptors)
 		goto fail;
 
-	rndis->fs.in = usb_find_endpoint(eth_fs_function,
-			f->descriptors, &fs_in_desc);
-	rndis->fs.out = usb_find_endpoint(eth_fs_function,
-			f->descriptors, &fs_out_desc);
-	rndis->fs.notify = usb_find_endpoint(eth_fs_function,
-			f->descriptors, &fs_notify_desc);
-
 	/* support all relevant hardware speeds... we expect that when
 	 * hardware is dual speed, all bulk-capable endpoints work at
 	 * both speeds
@@ -685,13 +673,6 @@ rndis_bind(struct usb_configuration *c, struct usb_function *f)
 
 		if (!f->hs_descriptors)
 			goto fail;
-
-		rndis->hs.in = usb_find_endpoint(eth_hs_function,
-				f->hs_descriptors, &hs_in_desc);
-		rndis->hs.out = usb_find_endpoint(eth_hs_function,
-				f->hs_descriptors, &hs_out_desc);
-		rndis->hs.notify = usb_find_endpoint(eth_hs_function,
-				f->hs_descriptors, &hs_notify_desc);
 	}
 
 	rndis->port.open = rndis_open;
diff --git a/drivers/usb/gadget/f_serial.c b/drivers/usb/gadget/f_serial.c
index a9ce626..91fdf79 100644
--- a/drivers/usb/gadget/f_serial.c
+++ b/drivers/usb/gadget/f_serial.c
@@ -27,18 +27,10 @@
  * if you can arrange appropriate host side drivers.
  */
 
-struct gser_descs {
-	struct usb_endpoint_descriptor	*in;
-	struct usb_endpoint_descriptor	*out;
-};
-
 struct f_gser {
 	struct gserial			port;
 	u8				data_id;
 	u8				port_num;
-
-	struct gser_descs		fs;
-	struct gser_descs		hs;
 };
 
 static inline struct f_gser *func_to_gser(struct usb_function *f)
@@ -136,12 +128,15 @@ static int gser_set_alt(struct usb_function *f, unsigned intf, unsigned alt)
 	if (gser->port.in->driver_data) {
 		DBG(cdev, "reset generic ttyGS%d\n", gser->port_num);
 		gserial_disconnect(&gser->port);
-	} else {
+	}
+	if (!gser->port.in->desc || !gser->port.out->desc) {
 		DBG(cdev, "activate generic ttyGS%d\n", gser->port_num);
-		gser->port.in->desc = ep_choose(cdev->gadget,
-				gser->hs.in, gser->fs.in);
-		gser->port.out->desc = ep_choose(cdev->gadget,
-				gser->hs.out, gser->fs.out);
+		if (!config_ep_by_speed(cdev->gadget, f, gser->port.in) ||
+		    !config_ep_by_speed(cdev->gadget, f, gser->port.out)) {
+			gser->port.in->desc = NULL;
+			gser->port.out->desc = NULL;
+			return -EINVAL;
+		}
 	}
 	gserial_connect(&gser->port, gser->port_num);
 	return 0;
@@ -193,12 +188,6 @@ gser_bind(struct usb_configuration *c, struct usb_function *f)
 	/* copy descriptors, and track endpoint copies */
 	f->descriptors = usb_copy_descriptors(gser_fs_function);
 
-	gser->fs.in = usb_find_endpoint(gser_fs_function,
-			f->descriptors, &gser_fs_in_desc);
-	gser->fs.out = usb_find_endpoint(gser_fs_function,
-			f->descriptors, &gser_fs_out_desc);
-
-
 	/* support all relevant hardware speeds... we expect that when
 	 * hardware is dual speed, all bulk-capable endpoints work at
 	 * both speeds
@@ -211,11 +200,6 @@ gser_bind(struct usb_configuration *c, struct usb_function *f)
 
 		/* copy descriptors, and track endpoint copies */
 		f->hs_descriptors = usb_copy_descriptors(gser_hs_function);
-
-		gser->hs.in = usb_find_endpoint(gser_hs_function,
-				f->hs_descriptors, &gser_hs_in_desc);
-		gser->hs.out = usb_find_endpoint(gser_hs_function,
-				f->hs_descriptors, &gser_hs_out_desc);
 	}
 
 	DBG(cdev, "generic ttyGS%d: %s speed IN/%s OUT/%s\n",
diff --git a/drivers/usb/gadget/f_sourcesink.c b/drivers/usb/gadget/f_sourcesink.c
index 0ffddd3..caf2f95 100644
--- a/drivers/usb/gadget/f_sourcesink.c
+++ b/drivers/usb/gadget/f_sourcesink.c
@@ -347,7 +347,9 @@ enable_source_sink(struct usb_composite_dev *cdev, struct f_sourcesink *ss)
 
 	/* one endpoint writes (sources) zeroes IN (to the host) */
 	ep = ss->in_ep;
-	ep->desc = ep_choose(cdev->gadget, &hs_source_desc, &fs_source_desc);
+	result = config_ep_by_speed(cdev->gadget, &(ss->function), ep);
+	if (result)
+		return result;
 	result = usb_ep_enable(ep);
 	if (result < 0)
 		return result;
@@ -364,7 +366,9 @@ fail:
 
 	/* one endpoint reads (sinks) anything OUT (from the host) */
 	ep = ss->out_ep;
-	ep->desc = ep_choose(cdev->gadget, &hs_sink_desc, &fs_sink_desc);
+	result = config_ep_by_speed(cdev->gadget, &(ss->function), ep);
+	if (result)
+		goto fail;
 	result = usb_ep_enable(ep);
 	if (result < 0)
 		goto fail;
diff --git a/drivers/usb/gadget/f_subset.c b/drivers/usb/gadget/f_subset.c
index aecaed1..93bf676 100644
--- a/drivers/usb/gadget/f_subset.c
+++ b/drivers/usb/gadget/f_subset.c
@@ -57,18 +57,10 @@
  * caring about specific product and vendor IDs.
  */
 
-struct geth_descs {
-	struct usb_endpoint_descriptor	*in;
-	struct usb_endpoint_descriptor	*out;
-};
-
 struct f_gether {
 	struct gether			port;
 
 	char				ethaddr[14];
-
-	struct geth_descs		fs;
-	struct geth_descs		hs;
 };
 
 static inline struct f_gether *func_to_geth(struct usb_function *f)
@@ -243,10 +235,12 @@ static int geth_set_alt(struct usb_function *f, unsigned intf, unsigned alt)
 	}
 
 	DBG(cdev, "init + activate cdc subset\n");
-	geth->port.in_ep->desc = ep_choose(cdev->gadget,
-			geth->hs.in, geth->fs.in);
-	geth->port.out_ep->desc = ep_choose(cdev->gadget,
-			geth->hs.out, geth->fs.out);
+	if (config_ep_by_speed(cdev->gadget, f, geth->port.in_ep) ||
+	    config_ep_by_speed(cdev->gadget, f, geth->port.out_ep)) {
+		geth->port.in_ep->desc = NULL;
+		geth->port.out_ep->desc = NULL;
+		return -EINVAL;
+	}
 
 	net = gether_connect(&geth->port);
 	return IS_ERR(net) ? PTR_ERR(net) : 0;
@@ -297,12 +291,6 @@ geth_bind(struct usb_configuration *c, struct usb_function *f)
 	/* copy descriptors, and track endpoint copies */
 	f->descriptors = usb_copy_descriptors(fs_eth_function);
 
-	geth->fs.in = usb_find_endpoint(fs_eth_function,
-			f->descriptors, &fs_subset_in_desc);
-	geth->fs.out = usb_find_endpoint(fs_eth_function,
-			f->descriptors, &fs_subset_out_desc);
-
-
 	/* support all relevant hardware speeds... we expect that when
 	 * hardware is dual speed, all bulk-capable endpoints work at
 	 * both speeds
@@ -315,11 +303,6 @@ geth_bind(struct usb_configuration *c, struct usb_function *f)
 
 		/* copy descriptors, and track endpoint copies */
 		f->hs_descriptors = usb_copy_descriptors(hs_eth_function);
-
-		geth->hs.in = usb_find_endpoint(hs_eth_function,
-				f->hs_descriptors, &hs_subset_in_desc);
-		geth->hs.out = usb_find_endpoint(hs_eth_function,
-				f->hs_descriptors, &hs_subset_out_desc);
 	}
 
 	/* NOTE:  all that is done without knowing or caring about
diff --git a/include/linux/usb/composite.h b/include/linux/usb/composite.h
index 2014d6b..99830d6 100644
--- a/include/linux/usb/composite.h
+++ b/include/linux/usb/composite.h
@@ -148,21 +148,6 @@ int usb_interface_id(struct usb_configuration *, struct usb_function *);
 int config_ep_by_speed(struct usb_gadget *g, struct usb_function *f,
 			struct usb_ep *_ep);
 
-/**
- * ep_choose - select descriptor endpoint at current device speed
- * @g: gadget, connected and running at some speed
- * @hs: descriptor to use for high speed operation
- * @fs: descriptor to use for full or low speed operation
- */
-static inline struct usb_endpoint_descriptor *
-ep_choose(struct usb_gadget *g, struct usb_endpoint_descriptor *hs,
-		struct usb_endpoint_descriptor *fs)
-{
-	if (gadget_is_dualspeed(g) && g->speed == USB_SPEED_HIGH)
-		return hs;
-	return fs;
-}
-
 #define	MAX_CONFIG_INTERFACES		16	/* arbitrary; max 255 */
 
 /**
diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
index 8015ceb..318c815 100644
--- a/include/linux/usb/gadget.h
+++ b/include/linux/usb/gadget.h
@@ -871,12 +871,6 @@ int usb_gadget_config_buf(const struct usb_config_descriptor *config,
 struct usb_descriptor_header **usb_copy_descriptors(
 		struct usb_descriptor_header **);
 
-/* return copy of endpoint descriptor given original descriptor set */
-struct usb_endpoint_descriptor *usb_find_endpoint(
-	struct usb_descriptor_header **src,
-	struct usb_descriptor_header **copy,
-	struct usb_endpoint_descriptor *match);
-
 /**
  * usb_free_descriptors - free descriptors returned by usb_copy_descriptors()
  * @v: vector of descriptors
-- 
1.7.3.3

--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
