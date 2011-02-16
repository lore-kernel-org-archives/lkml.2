Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932430Ab1BPAeT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:34:19 -0500
Received: from kroah.org ([198.145.64.141]:49717 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932290Ab1BPAYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:24:35 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:48 2011
Message-Id: <20110216001448.098700751@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:14:47 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dmitry Torokhov <dtor@mail.ru>
Subject: [230/272] Input: sysrq - rework re-inject logic
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 7ab7b5adfb923978a2cab7bd3fac9ccf7d21cc3f upstream.

Internally 'disable' the filter when re-injecting Alt-SysRq instead
of relying on input core to suppress delivery of injected events
to the originating handler.

This allows to revert commit 5fdbe44d033d059cc56c2803e6b4dbd8cb4e5e39
which causes problems with existing userspace programs trying to
loopback the events via evdev.

Reported-by: Kristen Carlson Accardi <kristen@linux.intel.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/tty/sysrq.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/drivers/tty/sysrq.c
+++ b/drivers/tty/sysrq.c
@@ -571,6 +571,7 @@ struct sysrq_state {
 	unsigned int alt_use;
 	bool active;
 	bool need_reinject;
+	bool reinjecting;
 };
 
 static void sysrq_reinject_alt_sysrq(struct work_struct *work)
@@ -581,6 +582,10 @@ static void sysrq_reinject_alt_sysrq(str
 	unsigned int alt_code = sysrq->alt_use;
 
 	if (sysrq->need_reinject) {
+		/* we do not want the assignment to be reordered */
+		sysrq->reinjecting = true;
+		mb();
+
 		/* Simulate press and release of Alt + SysRq */
 		input_inject_event(handle, EV_KEY, alt_code, 1);
 		input_inject_event(handle, EV_KEY, KEY_SYSRQ, 1);
@@ -589,6 +594,9 @@ static void sysrq_reinject_alt_sysrq(str
 		input_inject_event(handle, EV_KEY, KEY_SYSRQ, 0);
 		input_inject_event(handle, EV_KEY, alt_code, 0);
 		input_inject_event(handle, EV_SYN, SYN_REPORT, 1);
+
+		mb();
+		sysrq->reinjecting = false;
 	}
 }
 
@@ -599,6 +607,13 @@ static bool sysrq_filter(struct input_ha
 	bool was_active = sysrq->active;
 	bool suppress;
 
+	/*
+	 * Do not filter anything if we are in the process of re-injecting
+	 * Alt+SysRq combination.
+	 */
+	if (sysrq->reinjecting)
+		return false;
+
 	switch (type) {
 
 	case EV_SYN:
@@ -629,7 +644,7 @@ static bool sysrq_filter(struct input_ha
 				sysrq->alt_use = sysrq->alt;
 				/*
 				 * If nothing else will be pressed we'll need
-				 * to * re-inject Alt-SysRq keysroke.
+				 * to re-inject Alt-SysRq keysroke.
 				 */
 				sysrq->need_reinject = true;
 			}


