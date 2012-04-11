Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965037Ab2DKXSX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:18:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44096 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965010Ab2DKXST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:18:19 -0400
Message-Id: <20120411231031.274448665@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:11:34 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Chris Rankin <rankincj@yahoo.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 76/78] media: dvb_frontend: regression fix: userspace ABI broken for xine
In-Reply-To: <20120411231102.GA6404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Rankin <rankincj@yahoo.com>

commit 556a0442e08a8bc8541587a349cbf26ed14ec6de upstream.

The commit e399ce77e6e has broken the DVB ABI for xine:

The problem is that xine is expecting every event after a successful
FE_SET_FRONTEND ioctl to have a non-zero frequency parameter, regardless
of whether the tuning process has LOCKed yet. What used to happen is
that the events inherited the initial tuning parameters from the
FE_SET_FRONTEND call. However, the fepriv->parameters_out struct is now
not initialised until the status contains the FE_HAS_LOCK bit.

You might argue that this behaviour is intentional, except that if an
application other than xine uses the DVB adapter and manages to set the
parameters_out.frequency field to something other than zero, then xine
no longer has any problems until either the adapter is replugged or the
kernel modules reloaded. This can only mean that the
fepriv->parameters_out struct still contains the (stale) tuning
information from the previous application.

Signed-off-by: Chris Rankin <rankincj@yahoo.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/dvb/dvb-core/dvb_frontend.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -143,6 +143,8 @@ struct dvb_frontend_private {
 static void dvb_frontend_wakeup(struct dvb_frontend *fe);
 static int dtv_get_frontend(struct dvb_frontend *fe,
 			    struct dvb_frontend_parameters *p_out);
+static int dtv_property_legacy_params_sync(struct dvb_frontend *fe,
+					   struct dvb_frontend_parameters *p);
 
 static bool has_get_frontend(struct dvb_frontend *fe)
 {
@@ -695,6 +697,7 @@ restart:
 					fepriv->algo_status |= DVBFE_ALGO_SEARCH_AGAIN;
 					fepriv->delay = HZ / 2;
 				}
+				dtv_property_legacy_params_sync(fe, &fepriv->parameters_out);
 				fe->ops.read_status(fe, &s);
 				if (s != fepriv->status) {
 					dvb_frontend_add_event(fe, s); /* update event list */
@@ -1831,6 +1834,13 @@ static int dtv_set_frontend(struct dvb_f
 		return -EINVAL;
 
 	/*
+	 * Initialize output parameters to match the values given by
+	 * the user. FE_SET_FRONTEND triggers an initial frontend event
+	 * with status = 0, which copies output parameters to userspace.
+	 */
+	dtv_property_legacy_params_sync(fe, &fepriv->parameters_out);
+
+	/*
 	 * Be sure that the bandwidth will be filled for all
 	 * non-satellite systems, as tuners need to know what
 	 * low pass/Nyquist half filter should be applied, in


