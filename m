Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244Ab2DXW4K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:56:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38637 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932300Ab2DXWfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:35:17 -0400
Message-Id: <20120424223244.294104971@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:33:08 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dieter Roever <Dieter.Roever@gmx.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 27/62] media: dvb_frontend: Fix a regression when switching back to DVB-S
In-Reply-To: <20120424223305.GA7748@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <mchehab@redhat.com>

commit 3626479e482aa3247aac03724094ba6c13ea1e46 upstream.

There are some softwares (Kaffeine and likely xine) that uses a
DVBv5 call to switch to DVB-S2, but expects that a DVBv3 call to
switch back to DVB-S. Well, this is not right, as a DVBv3 call
doesn't know anything about delivery systems.

However, as, by accident, this used to work, we need to restore its
behavior, in order to avoid regressions with those softwares.

Reported on this Fedora 16 bugzilla:
	https://bugzilla.redhat.com/show_bug.cgi?id=812895

Reported-by: Dieter Roever <Dieter.Roever@gmx.de>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/dvb/dvb-core/dvb_frontend.c |   25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1446,6 +1446,28 @@ static int set_delivery_system(struct dv
 				__func__);
 			return -EINVAL;
 		}
+		/*
+		 * Get a delivery system that is compatible with DVBv3
+		 * NOTE: in order for this to work with softwares like Kaffeine that
+		 *	uses a DVBv5 call for DVB-S2 and a DVBv3 call to go back to
+		 *	DVB-S, drivers that support both should put the SYS_DVBS entry
+		 *	before the SYS_DVBS2, otherwise it won't switch back to DVB-S.
+		 *	The real fix is that userspace applications should not use DVBv3
+		 *	and not trust on calling FE_SET_FRONTEND to switch the delivery
+		 *	system.
+		 */
+		ncaps = 0;
+		while (fe->ops.delsys[ncaps] && ncaps < MAX_DELSYS) {
+			if (fe->ops.delsys[ncaps] == desired_system) {
+				delsys = desired_system;
+				break;
+			}
+			ncaps++;
+		}
+		if (delsys == SYS_UNDEFINED) {
+			dprintk("%s() Couldn't find a delivery system that matches %d\n",
+				__func__, desired_system);
+		}
 	} else {
 		/*
 		 * This is a DVBv5 call. So, it likely knows the supported
@@ -1494,9 +1516,10 @@ static int set_delivery_system(struct dv
 				__func__);
 			return -EINVAL;
 		}
-		c->delivery_system = delsys;
 	}
 
+	c->delivery_system = delsys;
+
 	/*
 	 * The DVBv3 or DVBv5 call is requesting a different system. So,
 	 * emulation is needed.


