Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab2LNLC5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 06:02:57 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:39776 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756075Ab2LNLCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 06:02:54 -0500
Subject: [PATCH 06/12] media/rc: fix oops on unloading module rc-core
To: linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, linux-media@vger.kernel.org
Date: Fri, 14 Dec 2012 15:02:48 +0400
Message-ID: <20121214110248.11019.36202.stgit@zurg>
In-Reply-To: <20121214110229.11019.63713.stgit@zurg>
References: <20121214110229.11019.63713.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During modiles initialization rc-core schedules work which calls
request_module() several times to load ir-*-decoder modules, but
it does not wait or cancel this work on module unloading.

rc-core should use request_module_nowait() instead, because it
anyway cannot load modules synchronously or cancel/wait pending
work on unloading, because this leads to deadlock on modules_mutex
between several "modprobe" processes.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
---
 drivers/media/rc/ir-raw.c       |   17 +----------------
 drivers/media/rc/rc-core-priv.h |   16 ++++++++--------
 2 files changed, 9 insertions(+), 24 deletions(-)

diff --git a/drivers/media/rc/ir-raw.c b/drivers/media/rc/ir-raw.c
index 97dc8d1..17c94be 100644
--- a/drivers/media/rc/ir-raw.c
+++ b/drivers/media/rc/ir-raw.c
@@ -31,11 +31,6 @@ static DEFINE_MUTEX(ir_raw_handler_lock);
 static LIST_HEAD(ir_raw_handler_list);
 static u64 available_protocols;
 
-#ifdef MODULE
-/* Used to load the decoders */
-static struct work_struct wq_load;
-#endif
-
 static int ir_raw_event_thread(void *data)
 {
 	struct ir_raw_event ev;
@@ -347,8 +342,7 @@ void ir_raw_handler_unregister(struct ir_raw_handler *ir_raw_handler)
 }
 EXPORT_SYMBOL(ir_raw_handler_unregister);
 
-#ifdef MODULE
-static void init_decoders(struct work_struct *work)
+void ir_raw_init(void)
 {
 	/* Load the decoder modules */
 
@@ -365,12 +359,3 @@ static void init_decoders(struct work_struct *work)
 	   it is needed to change the CONFIG_MODULE test at rc-core.h
 	 */
 }
-#endif
-
-void ir_raw_init(void)
-{
-#ifdef MODULE
-	INIT_WORK(&wq_load, init_decoders);
-	schedule_work(&wq_load);
-#endif
-}
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 96f0a8b..5d87287 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -165,56 +165,56 @@ void ir_raw_init(void);
 
 /* from ir-nec-decoder.c */
 #ifdef CONFIG_IR_NEC_DECODER_MODULE
-#define load_nec_decode()	request_module("ir-nec-decoder")
+#define load_nec_decode()	request_module_nowait("ir-nec-decoder")
 #else
 static inline void load_nec_decode(void) { }
 #endif
 
 /* from ir-rc5-decoder.c */
 #ifdef CONFIG_IR_RC5_DECODER_MODULE
-#define load_rc5_decode()	request_module("ir-rc5-decoder")
+#define load_rc5_decode()	request_module_nowait("ir-rc5-decoder")
 #else
 static inline void load_rc5_decode(void) { }
 #endif
 
 /* from ir-rc6-decoder.c */
 #ifdef CONFIG_IR_RC6_DECODER_MODULE
-#define load_rc6_decode()	request_module("ir-rc6-decoder")
+#define load_rc6_decode()	request_module_nowait("ir-rc6-decoder")
 #else
 static inline void load_rc6_decode(void) { }
 #endif
 
 /* from ir-jvc-decoder.c */
 #ifdef CONFIG_IR_JVC_DECODER_MODULE
-#define load_jvc_decode()	request_module("ir-jvc-decoder")
+#define load_jvc_decode()	request_module_nowait("ir-jvc-decoder")
 #else
 static inline void load_jvc_decode(void) { }
 #endif
 
 /* from ir-sony-decoder.c */
 #ifdef CONFIG_IR_SONY_DECODER_MODULE
-#define load_sony_decode()	request_module("ir-sony-decoder")
+#define load_sony_decode()	request_module_nowait("ir-sony-decoder")
 #else
 static inline void load_sony_decode(void) { }
 #endif
 
 /* from ir-sanyo-decoder.c */
 #ifdef CONFIG_IR_SANYO_DECODER_MODULE
-#define load_sanyo_decode()	request_module("ir-sanyo-decoder")
+#define load_sanyo_decode()	request_module_nowait("ir-sanyo-decoder")
 #else
 static inline void load_sanyo_decode(void) { }
 #endif
 
 /* from ir-mce_kbd-decoder.c */
 #ifdef CONFIG_IR_MCE_KBD_DECODER_MODULE
-#define load_mce_kbd_decode()	request_module("ir-mce_kbd-decoder")
+#define load_mce_kbd_decode()	request_module_nowait("ir-mce_kbd-decoder")
 #else
 static inline void load_mce_kbd_decode(void) { }
 #endif
 
 /* from ir-lirc-codec.c */
 #ifdef CONFIG_IR_LIRC_CODEC_MODULE
-#define load_lirc_codec()	request_module("ir-lirc-codec")
+#define load_lirc_codec()	request_module_nowait("ir-lirc-codec")
 #else
 static inline void load_lirc_codec(void) { }
 #endif

