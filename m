Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744Ab1DLTgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 15:36:18 -0400
Received: from www.linutronix.de ([62.245.132.108]:40344 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756157Ab1DLTfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 15:35:21 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Tatyana Brokhman <tlinder@codeaurora.org>
Cc: gregkh@suse.de, linux-arm-msm@vger.kernel.org, balbi@ti.com,
        ablay@codeaurora.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 5/5] usb/gadget: don't auto-create SS descriptors if HS are avilable
Date: Tue, 12 Apr 2011 21:34:56 +0200
Message-Id: <1302636896-12717-6-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1302636896-12717-1-git-send-email-bigeasy@linutronix.de>
References: <20110411175917.GE4018@linutronix.de>
 <1302636896-12717-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead every gadget driver has to requests this to be done for him. A
gadget driver may use usb_create_ss_descriptors() if it wants a
descriptor based on its HS descriptor.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/usb/gadget/composite.c      |   29 ++++++++++++++++-------------
 drivers/usb/gadget/f_acm.c          |    5 ++---
 drivers/usb/gadget/f_audio.c        |    4 ++--
 drivers/usb/gadget/f_ecm.c          |   11 ++++-------
 drivers/usb/gadget/f_eem.c          |   10 ++++------
 drivers/usb/gadget/f_hid.c          |    9 +++------
 drivers/usb/gadget/f_loopback.c     |    2 ++
 drivers/usb/gadget/f_mass_storage.c |    9 +++++----
 drivers/usb/gadget/f_ncm.c          |   10 ++++------
 drivers/usb/gadget/f_obex.c         |    5 ++---
 drivers/usb/gadget/f_phonet.c       |    3 +++
 drivers/usb/gadget/f_rndis.c        |   14 ++++----------
 drivers/usb/gadget/f_serial.c       |    5 ++---
 drivers/usb/gadget/f_sourcesink.c   |    2 ++
 drivers/usb/gadget/f_subset.c       |    5 ++---
 drivers/usb/gadget/f_uvc.c          |    5 ++---
 include/linux/usb/composite.h       |    9 ---------
 17 files changed, 59 insertions(+), 78 deletions(-)

diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index ac30e2f..c3c6cb1 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -187,7 +187,6 @@ void usb_create_ss_descriptors(struct usb_function *f)
 	 * vector is NULL
 	 */
 	*tmp = NULL;
-	f->ss_desc_allocated = true;
 #endif
 }
 
@@ -304,6 +303,21 @@ ep_found:
 }
 
 /**
+ * usb_free_all_descriptors - free all allocated descriptors
+ * @f: function driver
+ *
+ * Simply remove all three usb descriptors which were dynamically allocated.
+ */
+void usb_free_all_descriptors(struct usb_function *f)
+{
+	usb_free_descriptors(f->ss_descriptors);
+	usb_free_descriptors(f->hs_descriptors);
+	usb_free_descriptors(f->descriptors);
+
+	f->ss_descriptors = f->hs_descriptors = f->descriptors = NULL;
+}
+
+/**
  * usb_add_function() - add a function to a configuration
  * @config: the configuration
  * @function: the function being added
@@ -339,14 +353,6 @@ int usb_add_function(struct usb_configuration *config,
 			list_del(&function->list);
 			function->config = NULL;
 		}
-		/*
-		 * Add SS descriptors if there are any. This has to be done
-		 * after the bind since we need the hs_descriptors to be set in
-		 * usb_function and some of the FDs does it in the bind.
-		 */
-		if ((gadget_is_superspeed(config->cdev->gadget)) &&
-		    (!function->ss_not_capable) && (!function->ss_descriptors))
-			create_ss_descriptors(function);
 	} else
 		value = 0;
 
@@ -1437,11 +1443,8 @@ composite_unbind(struct usb_gadget *gadget)
 				DBG(cdev, "unbind function '%s'/%p\n",
 						f->name, f);
 				f->unbind(c, f);
+				/* may free memory for "f" */
 			}
-			/* Free memory allocated for ss descriptors */
-			if (f->ss_desc_allocated && f->ss_descriptors)
-				usb_free_descriptors(f->ss_descriptors);
-			/* may free memory for "f" */
 		}
 		list_del(&c->list);
 		if (c->unbind) {
diff --git a/drivers/usb/gadget/f_acm.c b/drivers/usb/gadget/f_acm.c
index 3f88493..aa2ceb4 100644
--- a/drivers/usb/gadget/f_acm.c
+++ b/drivers/usb/gadget/f_acm.c
@@ -642,6 +642,7 @@ acm_bind(struct usb_configuration *c, struct usb_function *f)
 
 		/* copy descriptors */
 		f->hs_descriptors = usb_copy_descriptors(acm_hs_function);
+		usb_create_ss_descriptors(f);
 	}
 
 	DBG(cdev, "acm ttyGS%d: %s speed IN/%s OUT/%s NOTIFY/%s\n",
@@ -673,9 +674,7 @@ acm_unbind(struct usb_configuration *c, struct usb_function *f)
 {
 	struct f_acm		*acm = func_to_acm(f);
 
-	if (gadget_is_dualspeed(c->cdev->gadget))
-		usb_free_descriptors(f->hs_descriptors);
-	usb_free_descriptors(f->descriptors);
+	usb_free_all_descriptors(f);
 	gs_free_req(acm->notify, acm->notify_req);
 	kfree(acm);
 }
diff --git a/drivers/usb/gadget/f_audio.c b/drivers/usb/gadget/f_audio.c
index fdaa0a5..b9c054d 100644
--- a/drivers/usb/gadget/f_audio.c
+++ b/drivers/usb/gadget/f_audio.c
@@ -689,6 +689,7 @@ f_audio_bind(struct usb_configuration *c, struct usb_function *f)
 	if (gadget_is_dualspeed(c->cdev->gadget)) {
 		c->highspeed = true;
 		f->hs_descriptors = usb_copy_descriptors(f_audio_desc);
+		usb_create_ss_descriptors(f);
 	} else
 		f->descriptors = usb_copy_descriptors(f_audio_desc);
 
@@ -704,8 +705,7 @@ f_audio_unbind(struct usb_configuration *c, struct usb_function *f)
 {
 	struct f_audio		*audio = func_to_audio(f);
 
-	usb_free_descriptors(f->descriptors);
-	usb_free_descriptors(f->hs_descriptors);
+	usb_free_all_descriptors(f);
 	kfree(audio);
 }
 
diff --git a/drivers/usb/gadget/f_ecm.c b/drivers/usb/gadget/f_ecm.c
index ddedbc83..3899036 100644
--- a/drivers/usb/gadget/f_ecm.c
+++ b/drivers/usb/gadget/f_ecm.c
@@ -675,7 +675,8 @@ ecm_bind(struct usb_configuration *c, struct usb_function *f)
 
 		/* copy descriptors, and track endpoint copies */
 		f->hs_descriptors = usb_copy_descriptors(ecm_hs_function);
-		if (!f->hs_descriptors)
+		usb_create_ss_descriptors(f);
+		if (!f->hs_descriptors || !f->ss_descriptors)
 			goto fail;
 	}
 
@@ -694,8 +695,7 @@ ecm_bind(struct usb_configuration *c, struct usb_function *f)
 	return 0;
 
 fail:
-	if (f->descriptors)
-		usb_free_descriptors(f->descriptors);
+	usb_free_all_descriptors(f);
 
 	if (ecm->notify_req) {
 		kfree(ecm->notify_req->buf);
@@ -722,10 +722,7 @@ ecm_unbind(struct usb_configuration *c, struct usb_function *f)
 
 	DBG(c->cdev, "ecm unbind\n");
 
-	if (gadget_is_dualspeed(c->cdev->gadget))
-		usb_free_descriptors(f->hs_descriptors);
-	usb_free_descriptors(f->descriptors);
-
+	usb_free_all_descriptors(f);
 	kfree(ecm->notify_req->buf);
 	usb_ep_free_request(ecm->notify, ecm->notify_req);
 
diff --git a/drivers/usb/gadget/f_eem.c b/drivers/usb/gadget/f_eem.c
index d28e61f..5a09eef 100644
--- a/drivers/usb/gadget/f_eem.c
+++ b/drivers/usb/gadget/f_eem.c
@@ -261,7 +261,8 @@ eem_bind(struct usb_configuration *c, struct usb_function *f)
 
 		/* copy descriptors, and track endpoint copies */
 		f->hs_descriptors = usb_copy_descriptors(eem_hs_function);
-		if (!f->hs_descriptors)
+		usb_create_ss_descriptors(f);
+		if (!f->hs_descriptors || !f->ss_descriptors)
 			goto fail;
 	}
 
@@ -271,8 +272,7 @@ eem_bind(struct usb_configuration *c, struct usb_function *f)
 	return 0;
 
 fail:
-	if (f->descriptors)
-		usb_free_descriptors(f->descriptors);
+	usb_free_all_descriptors(f);
 
 	/* we might as well release our claims on endpoints */
 	if (eem->port.out_ep->desc)
@@ -292,9 +292,7 @@ eem_unbind(struct usb_configuration *c, struct usb_function *f)
 
 	DBG(c->cdev, "eem unbind\n");
 
-	if (gadget_is_dualspeed(c->cdev->gadget))
-		usb_free_descriptors(f->hs_descriptors);
-	usb_free_descriptors(f->descriptors);
+	usb_free_all_descriptors(f);
 	kfree(eem);
 }
 
diff --git a/drivers/usb/gadget/f_hid.c b/drivers/usb/gadget/f_hid.c
index 403a48b..642a6bc 100644
--- a/drivers/usb/gadget/f_hid.c
+++ b/drivers/usb/gadget/f_hid.c
@@ -503,7 +503,7 @@ static int __init hidg_bind(struct usb_configuration *c, struct usb_function *f)
 		hidg_hs_in_ep_desc.bEndpointAddress =
 			hidg_fs_in_ep_desc.bEndpointAddress;
 		f->hs_descriptors = usb_copy_descriptors(hidg_hs_descriptors);
-		if (!f->hs_descriptors)
+		if (!f->hs_descriptors || !f->ss_descriptors)
 			goto fail;
 	}
 
@@ -531,9 +531,7 @@ fail:
 			usb_ep_free_request(hidg->in_ep, hidg->req);
 	}
 
-	usb_free_descriptors(f->hs_descriptors);
-	usb_free_descriptors(f->descriptors);
-
+	usb_free_all_descriptors(f);
 	return status;
 }
 
@@ -551,8 +549,7 @@ static void hidg_unbind(struct usb_configuration *c, struct usb_function *f)
 	usb_ep_free_request(hidg->in_ep, hidg->req);
 
 	/* free descriptors copies */
-	usb_free_descriptors(f->hs_descriptors);
-	usb_free_descriptors(f->descriptors);
+	usb_free_all_descriptors(f);
 
 	kfree(hidg->report_desc);
 	kfree(hidg->set_report_buff);
diff --git a/drivers/usb/gadget/f_loopback.c b/drivers/usb/gadget/f_loopback.c
index 3756326..622a0df 100644
--- a/drivers/usb/gadget/f_loopback.c
+++ b/drivers/usb/gadget/f_loopback.c
@@ -173,6 +173,7 @@ autoconf_fail:
 		hs_loop_sink_desc.bEndpointAddress =
 				fs_loop_sink_desc.bEndpointAddress;
 		f->hs_descriptors = hs_loopback_descs;
+		usb_create_ss_descriptors(f);
 	}
 
 	DBG(cdev, "%s speed %s: IN/%s, OUT/%s\n",
@@ -184,6 +185,7 @@ autoconf_fail:
 static void
 loopback_unbind(struct usb_configuration *c, struct usb_function *f)
 {
+	usb_free_descriptors(f->ss_descriptors);
 	kfree(func_to_loop(f));
 }
 
diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index a688d04..a2da410 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -2989,8 +2989,8 @@ static void fsg_unbind(struct usb_configuration *c, struct usb_function *f)
 	}
 
 	fsg_common_put(common);
-	usb_free_descriptors(fsg->function.descriptors);
-	usb_free_descriptors(fsg->function.hs_descriptors);
+	usb_free_all_descriptors(f);
+
 	kfree(fsg);
 }
 
@@ -3035,8 +3035,9 @@ static int fsg_bind(struct usb_configuration *c, struct usb_function *f)
 		fsg_hs_bulk_out_desc.bEndpointAddress =
 			fsg_fs_bulk_out_desc.bEndpointAddress;
 		f->hs_descriptors = usb_copy_descriptors(fsg_hs_function);
-		if (unlikely(!f->hs_descriptors)) {
-			usb_free_descriptors(f->descriptors);
+		usb_create_ss_descriptors(f);
+		if (!f->hs_descriptors || !f->ss_descriptors) {
+			usb_free_all_descriptors(f);
 			return -ENOMEM;
 		}
 	}
diff --git a/drivers/usb/gadget/f_ncm.c b/drivers/usb/gadget/f_ncm.c
index 681e5fc..f9ee06b 100644
--- a/drivers/usb/gadget/f_ncm.c
+++ b/drivers/usb/gadget/f_ncm.c
@@ -1237,7 +1237,8 @@ ncm_bind(struct usb_configuration *c, struct usb_function *f)
 
 		/* copy descriptors, and track endpoint copies */
 		f->hs_descriptors = usb_copy_descriptors(ncm_hs_function);
-		if (!f->hs_descriptors)
+		usb_create_ss_descriptors(f);
+		if (!f->hs_descriptors || !f->ss_descriptors)
 			goto fail;
 	}
 
@@ -1257,8 +1258,7 @@ ncm_bind(struct usb_configuration *c, struct usb_function *f)
 	return 0;
 
 fail:
-	if (f->descriptors)
-		usb_free_descriptors(f->descriptors);
+	usb_free_all_descriptors(f);
 
 	if (ncm->notify_req) {
 		kfree(ncm->notify_req->buf);
@@ -1285,9 +1285,7 @@ ncm_unbind(struct usb_configuration *c, struct usb_function *f)
 
 	DBG(c->cdev, "ncm unbind\n");
 
-	if (gadget_is_dualspeed(c->cdev->gadget))
-		usb_free_descriptors(f->hs_descriptors);
-	usb_free_descriptors(f->descriptors);
+	usb_free_all_descriptors(f);
 
 	kfree(ncm->notify_req->buf);
 	usb_ep_free_request(ncm->notify, ncm->notify_req);
diff --git a/drivers/usb/gadget/f_obex.c b/drivers/usb/gadget/f_obex.c
index 394502a..2aa8366 100644
--- a/drivers/usb/gadget/f_obex.c
+++ b/drivers/usb/gadget/f_obex.c
@@ -355,6 +355,7 @@ obex_bind(struct usb_configuration *c, struct usb_function *f)
 
 		/* copy descriptors, and track endpoint copies */
 		f->hs_descriptors = usb_copy_descriptors(hs_function);
+		usb_create_ss_descriptors(f);
 	}
 
 	/* Avoid letting this gadget enumerate until the userspace
@@ -390,9 +391,7 @@ fail:
 static void
 obex_unbind(struct usb_configuration *c, struct usb_function *f)
 {
-	if (gadget_is_dualspeed(c->cdev->gadget))
-		usb_free_descriptors(f->hs_descriptors);
-	usb_free_descriptors(f->descriptors);
+	usb_free_all_descriptors(f);
 	kfree(func_to_obex(f));
 }
 
diff --git a/drivers/usb/gadget/f_phonet.c b/drivers/usb/gadget/f_phonet.c
index 0d6d260..47310d4 100644
--- a/drivers/usb/gadget/f_phonet.c
+++ b/drivers/usb/gadget/f_phonet.c
@@ -532,6 +532,7 @@ int pn_bind(struct usb_configuration *c, struct usb_function *f)
 	/* Do not try to bind Phonet twice... */
 	fp->function.descriptors = fs_pn_function;
 	fp->function.hs_descriptors = hs_pn_function;
+	usb_create_ss_descriptors(f);
 
 	/* Incoming USB requests */
 	status = -ENOMEM;
@@ -557,6 +558,7 @@ int pn_bind(struct usb_configuration *c, struct usb_function *f)
 	return 0;
 
 err:
+	usb_free_descriptors(f->ss_descriptors);
 	if (fp->out_ep)
 		fp->out_ep->driver_data = NULL;
 	if (fp->in_ep)
@@ -578,6 +580,7 @@ pn_unbind(struct usb_configuration *c, struct usb_function *f)
 		if (fp->out_reqv[i])
 			usb_ep_free_request(fp->out_ep, fp->out_reqv[i]);
 
+	usb_free_descriptors(f->ss_descriptors);
 	kfree(fp);
 }
 
diff --git a/drivers/usb/gadget/f_rndis.c b/drivers/usb/gadget/f_rndis.c
index 775a97d..46c859d 100644
--- a/drivers/usb/gadget/f_rndis.c
+++ b/drivers/usb/gadget/f_rndis.c
@@ -671,8 +671,8 @@ rndis_bind(struct usb_configuration *c, struct usb_function *f)
 
 		/* copy descriptors, and track endpoint copies */
 		f->hs_descriptors = usb_copy_descriptors(eth_hs_function);
-
-		if (!f->hs_descriptors)
+		usb_create_ss_descriptors(f);
+		if (!f->hs_descriptors || !f->ss_descriptors)
 			goto fail;
 	}
 
@@ -706,10 +706,7 @@ rndis_bind(struct usb_configuration *c, struct usb_function *f)
 	return 0;
 
 fail:
-	if (gadget_is_dualspeed(c->cdev->gadget) && f->hs_descriptors)
-		usb_free_descriptors(f->hs_descriptors);
-	if (f->descriptors)
-		usb_free_descriptors(f->descriptors);
+	usb_free_all_descriptors(f);
 
 	if (rndis->notify_req) {
 		kfree(rndis->notify_req->buf);
@@ -737,10 +734,7 @@ rndis_unbind(struct usb_configuration *c, struct usb_function *f)
 	rndis_deregister(rndis->config);
 	rndis_exit();
 
-	if (gadget_is_dualspeed(c->cdev->gadget))
-		usb_free_descriptors(f->hs_descriptors);
-	usb_free_descriptors(f->descriptors);
-
+	usb_free_all_descriptors(f);
 	kfree(rndis->notify_req->buf);
 	usb_ep_free_request(rndis->notify, rndis->notify_req);
 
diff --git a/drivers/usb/gadget/f_serial.c b/drivers/usb/gadget/f_serial.c
index 91fdf79..d9cb150 100644
--- a/drivers/usb/gadget/f_serial.c
+++ b/drivers/usb/gadget/f_serial.c
@@ -200,6 +200,7 @@ gser_bind(struct usb_configuration *c, struct usb_function *f)
 
 		/* copy descriptors, and track endpoint copies */
 		f->hs_descriptors = usb_copy_descriptors(gser_hs_function);
+		usb_create_ss_descriptors(f);
 	}
 
 	DBG(cdev, "generic ttyGS%d: %s speed IN/%s OUT/%s\n",
@@ -223,9 +224,7 @@ fail:
 static void
 gser_unbind(struct usb_configuration *c, struct usb_function *f)
 {
-	if (gadget_is_dualspeed(c->cdev->gadget))
-		usb_free_descriptors(f->hs_descriptors);
-	usb_free_descriptors(f->descriptors);
+	usb_free_all_descriptors(f);
 	kfree(func_to_gser(f));
 }
 
diff --git a/drivers/usb/gadget/f_sourcesink.c b/drivers/usb/gadget/f_sourcesink.c
index caf2f95..bf1c595 100644
--- a/drivers/usb/gadget/f_sourcesink.c
+++ b/drivers/usb/gadget/f_sourcesink.c
@@ -185,6 +185,7 @@ autoconf_fail:
 		hs_sink_desc.bEndpointAddress =
 				fs_sink_desc.bEndpointAddress;
 		f->hs_descriptors = hs_source_sink_descs;
+		usb_create_ss_descriptors(f);
 	}
 
 	DBG(cdev, "%s speed %s: IN/%s, OUT/%s\n",
@@ -196,6 +197,7 @@ autoconf_fail:
 static void
 sourcesink_unbind(struct usb_configuration *c, struct usb_function *f)
 {
+	usb_free_descriptors(f->ss_descriptors);
 	kfree(func_to_ss(f));
 }
 
diff --git a/drivers/usb/gadget/f_subset.c b/drivers/usb/gadget/f_subset.c
index 93bf676..ada5b76 100644
--- a/drivers/usb/gadget/f_subset.c
+++ b/drivers/usb/gadget/f_subset.c
@@ -303,6 +303,7 @@ geth_bind(struct usb_configuration *c, struct usb_function *f)
 
 		/* copy descriptors, and track endpoint copies */
 		f->hs_descriptors = usb_copy_descriptors(hs_eth_function);
+		usb_create_ss_descriptors(f);
 	}
 
 	/* NOTE:  all that is done without knowing or caring about
@@ -330,9 +331,7 @@ fail:
 static void
 geth_unbind(struct usb_configuration *c, struct usb_function *f)
 {
-	if (gadget_is_dualspeed(c->cdev->gadget))
-		usb_free_descriptors(f->hs_descriptors);
-	usb_free_descriptors(f->descriptors);
+	usb_free_all_descriptors(f);
 	geth_string_defs[1].s = NULL;
 	kfree(func_to_geth(f));
 }
diff --git a/drivers/usb/gadget/f_uvc.c b/drivers/usb/gadget/f_uvc.c
index df74d03..f8c7673 100644
--- a/drivers/usb/gadget/f_uvc.c
+++ b/drivers/usb/gadget/f_uvc.c
@@ -481,9 +481,7 @@ uvc_function_unbind(struct usb_configuration *c, struct usb_function *f)
 		kfree(uvc->control_buf);
 	}
 
-	kfree(f->descriptors);
-	kfree(f->hs_descriptors);
-
+	usb_free_all_descriptors(f);
 	kfree(uvc);
 }
 
@@ -530,6 +528,7 @@ uvc_function_bind(struct usb_configuration *c, struct usb_function *f)
 	/* Copy descriptors. */
 	f->descriptors = uvc_copy_descriptors(uvc, USB_SPEED_FULL);
 	f->hs_descriptors = uvc_copy_descriptors(uvc, USB_SPEED_HIGH);
+	usb_create_ss_descriptors(f);
 
 	/* Preallocate control endpoint request. */
 	uvc->control_req = usb_ep_alloc_request(cdev->gadget->ep0, GFP_KERNEL);
diff --git a/include/linux/usb/composite.h b/include/linux/usb/composite.h
index e9fa7d8..9f2254c 100644
--- a/include/linux/usb/composite.h
+++ b/include/linux/usb/composite.h
@@ -57,12 +57,6 @@ struct usb_configuration;
  *	default values while working in superspeed mode. If this
  *	pointer is null after initiation, the function will not
  *	be available at super speed.
- * @ss_not_capable: This flag is used by the FD to indicate if
- *	this function is SS capble. Meaning: if SS descriptors
- *	weren't supplied by the FD, and the flag is set ss
- *	descriptors will NOT be automatically generated
- * @ss_desc_allocated: This flag indicates whether the ss descriptors were
- *	dynamically allocated (and needs to be released).
  * @config: assigned when @usb_add_function() is called; this is the
  *	configuration with which this function is associated.
  * @bind: Before the gadget can register, all of its functions bind() to the
@@ -116,9 +110,6 @@ struct usb_function {
 	struct usb_descriptor_header	**hs_descriptors;
 	struct usb_descriptor_header	**ss_descriptors;
 
-	unsigned			ss_desc_allocated:1;
-	unsigned			ss_not_capable:1;
-
 	struct usb_configuration	*config;
 
 	/* REVISIT:  bind() functions can be marked __init, which
-- 
1.7.4

