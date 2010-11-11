Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab0KKSp4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 13:45:56 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:32182 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525Ab0KKSpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 13:45:54 -0500
Date: Thu, 11 Nov 2010 10:44:22 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Mike Thomas <rmthomas@sciolus.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        gregkh@suse.de
Subject: [PATCH -next] staging/easycap: make module params private/static,
 fix build
Message-Id: <20101111104422.28594510.randy.dunlap@oracle.com>
In-Reply-To: <20101111125655.15fa7188.sfr@canb.auug.org.au>
References: <20101111125655.15fa7188.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

The easycap driver has module parameters (bars, gain, & debug)
with global scope that intrude on the kernel namespace and cause
build problems.  Change the names of them to be driver-specific
and make 2 of them static.

drivers/built-in.o:(.bss+0x97c00): multiple definition of `debug'
ld: Warning: size of symbol `debug' changed from 58 in arch/x86/built-in.o to 4 in drivers/built-in.o

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Mike Thomas <rmthomas@sciolus.org>
---
 drivers/staging/easycap/easycap.h       |    4 ++--
 drivers/staging/easycap/easycap_debug.h |    4 ++--
 drivers/staging/easycap/easycap_low.c   |   10 +++++-----
 drivers/staging/easycap/easycap_main.c  |   18 +++++++++---------
 4 files changed, 18 insertions(+), 18 deletions(-)

--- linux-next-20101111.orig/drivers/staging/easycap/easycap_main.c
+++ linux-next-20101111/drivers/staging/easycap/easycap_main.c
@@ -32,12 +32,12 @@
 #include "easycap_standard.h"
 #include "easycap_ioctl.h"
 
-int debug;
-int bars;
-int gain = 16;
-module_param(debug, int, S_IRUGO | S_IWUSR);
-module_param(bars, int, S_IRUGO | S_IWUSR);
-module_param(gain, int, S_IRUGO | S_IWUSR);
+static int easycap_debug;
+static int easycap_bars;
+int easycap_gain = 16;
+module_param_named(debug, easycap_debug, int, S_IRUGO | S_IWUSR);
+module_param_named(bars, easycap_bars, int, S_IRUGO | S_IWUSR);
+module_param_named(gain, easycap_gain, int, S_IRUGO | S_IWUSR);
 
 /*---------------------------------------------------------------------------*/
 /*
@@ -1464,7 +1464,7 @@ if (peasycap->field_read == peasycap->fi
 easycap_testcard(peasycap, peasycap->field_read);
 #else
 if (0 <= input && INPUT_MANY > input) {
-	if (bars && VIDEO_LOST_TOLERATE <= peasycap->lost[input])
+	if (easycap_bars && VIDEO_LOST_TOLERATE <= peasycap->lost[input])
 		easycap_testcard(peasycap, peasycap->field_read);
 }
 #endif /*EASYCAP_TESTCARD*/
@@ -5008,8 +5008,8 @@ easycap_module_init(void)
 int result;
 
 SAY("========easycap=======\n");
-JOT(4, "begins.  %i=debug %i=bars %i=gain\n", debug, bars, \
-						gain);
+JOT(4, "begins.  %i=debug %i=bars %i=gain\n", easycap_debug, easycap_bars, \
+						easycap_gain);
 SAY("version: " EASYCAP_DRIVER_VERSION "\n");
 /*---------------------------------------------------------------------------*/
 /*
--- linux-next-20101111.orig/drivers/staging/easycap/easycap_debug.h
+++ linux-next-20101111/drivers/staging/easycap/easycap_debug.h
@@ -24,6 +24,6 @@
  *
 */
 /*****************************************************************************/
-extern int debug;
-extern int gain;
+extern int easycap_debug;
+extern int easycap_gain;
 extern struct easycap_dongle easycap_dongle[];
--- linux-next-20101111.orig/drivers/staging/easycap/easycap.h
+++ linux-next-20101111/drivers/staging/easycap/easycap.h
@@ -630,13 +630,13 @@ unsigned long long int remainder;
 
 #if defined(EASYCAP_DEBUG)
 #define JOT(n, format, args...) do { \
-	if (n <= debug) { \
+	if (n <= easycap_debug) { \
 		printk(KERN_DEBUG "easycap:: %s: " \
 			format, __func__, ##args);\
 	} \
 } while (0)
 #define JOM(n, format, args...) do { \
-	if (n <= debug) { \
+	if (n <= easycap_debug) { \
 		printk(KERN_DEBUG "easycap::%i%s: " \
 			format, peasycap->isdongle, __func__, ##args);\
 	} \
--- linux-next-20101111.orig/drivers/staging/easycap/easycap_low.c
+++ linux-next-20101111/drivers/staging/easycap/easycap_low.c
@@ -1082,11 +1082,11 @@ SAM("0x%04X:0x%04X is audio vendor id\n"
  *  SELECT AUDIO SOURCE "LINE IN" AND SET THE AUDIO GAIN.
 */
 /*---------------------------------------------------------------------------*/
-if (31 < gain)
-	gain = 31;
-if (0 > gain)
-	gain = 0;
-if (0 != audio_gainset(pusb_device, (__s8)gain))
+if (31 < easycap_gain)
+	easycap_gain = 31;
+if (0 > easycap_gain)
+	easycap_gain = 0;
+if (0 != audio_gainset(pusb_device, (__s8)easycap_gain))
 	SAY("ERROR: audio_gainset() failed\n");
 check_vt(pusb_device);
 return 0;
