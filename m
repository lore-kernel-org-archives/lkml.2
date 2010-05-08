Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab0EHV7K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 17:59:10 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47013 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699Ab0EHV7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 17:59:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=mt7oqQpK5v5JGsYG2pV7P5KD+I9NqDbet7Qe7PRIR5nHLTcNDdAhQRUXxq+JfSSLLp
         CBM0Sf2x2XtTgXnPdlEqtWrlyc5QmlgKsoKI9ozrkiUqoBPZzYJwQbfIkwzzkyx2VIAk
         oDaUbzWM5xDxHFz4gvf9tbp++InvycvQaUv0Q=
Subject: [PATCH] [OOPS] apbuart.c: Two problems related to
 grlib_apbuart_configure()
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, kristoffer@gaisler.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 08 May 2010 23:58:55 +0200
Message-ID: <1273355935.13191.6.camel@carter>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I found two problems using the Simics' sunfire target, so maybe the
following does not occur in real machines.

1. At grlib_apbuart_configure() in apbuart.c, prop can be NULL if
"clock-frequency" doesn't exist in the OF tree:

        /* Get bus frequency */
        rp = of_find_node_by_path("/");
        rp = of_get_next_child(rp, NULL);
        prop = of_get_property(rp, "clock-frequency", NULL);
        freq_khz = *prop;

2. In addition, apbuart.c does not check if there aren't any ports
configured after calls to grlib_apbuart_configure(), so other oops will
occur if no port was configured (e.g. uart_set_options() because of
port->ops).

In order to solve that, I added a check after both of the calls to
grlib_apbuart_configure().

The patch that I provide below prevents both problems in the Simics'
sunfire target.

Tested against 2.6.33.3. Please review.

Signed-off-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
---
--- drivers/serial/apbuart.c.orig	2010-04-26 16:48:30.000000000 +0200
+++ drivers/serial/apbuart.c	2010-05-08 23:50:36.786148571 +0200
@@ -525,6 +525,9 @@ static void grlib_apbuart_configure(void
 static int __init apbuart_console_init(void)
 {
 	grlib_apbuart_configure();
+	if (grlib_apbuart_port_nr == 0)
+		return 0;
+
 	register_console(&grlib_apbuart_console);
 	return 0;
 }
@@ -612,6 +615,8 @@ static void grlib_apbuart_configure(void
 	rp = of_find_node_by_path("/");
 	rp = of_get_next_child(rp, NULL);
 	prop = of_get_property(rp, "clock-frequency", NULL);
+	if (prop == NULL)
+		return;
 	freq_khz = *prop;
 
 	line = 0;
@@ -666,6 +671,11 @@ static int __init grlib_apbuart_init(voi
 
 	/* Find all APBUARTS in device the tree and initialize their ports */
 	grlib_apbuart_configure();
+	if (grlib_apbuart_port_nr == 0) {
+		printk(KERN_INFO "Serial: GRLIB APBUART: No ports found.\n",
+			__FILE__);
+		return 0;
+	}
 
 	printk(KERN_INFO "Serial: GRLIB APBUART driver\n");
 

