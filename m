Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950Ab0ETTwn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 15:52:43 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46116 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886Ab0ETTwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 15:52:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=kT5FboBLaBpDagMle7TtuJqyvtVWvl+Zi4F3A351e6sGBlJeK3b0ni7Oe4g/7fFFK8
         JeYUfvII6gf/wNxqjDFjx5ONAytlIem5UbMNUWzMh5ZukL8hDpWO0E2IkJNvwE5ZIAHL
         Z1fo4wqLWIlSRRyzZh2R0hojyydlA6Qg9gkoQ=
Subject: Re: [alternative-merged]
 serial-apbuartc-fix-two-problems-related-to-grlib_apbuart_configure.patch
 removed from -mm tree
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kristoffer@gaisler.com,
       Andrew Morton <akpm@linux-foundation.org>, davem@davemloft.net,
       Anton Vorontsov <avorontsov@ru.mvista.com>
In-Reply-To: <1273355935.13191.6.camel@carter>
References: <1273355935.13191.6.camel@carter>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 May 2010 21:52:36 +0200
Message-ID: <1274385156.9756.4.camel@carter>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I found two problems using the Simics' sunfire target. It occurs as well on real machines.

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
sunfire target. In addition, it warns the users if no ports were found.

Signed-off-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Acked-by: Kristoffer Glembo <kristoffer@gaisler.com>
---
--- drivers/serial/apbuart.c.orig	2010-04-26 16:48:30.000000000 +0200
+++ drivers/serial/apbuart.c	2010-05-11 15:21:28.984666230 +0200
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
@@ -612,6 +615,10 @@ static void grlib_apbuart_configure(void
 	rp = of_find_node_by_path("/");
 	rp = of_get_next_child(rp, NULL);
 	prop = of_get_property(rp, "clock-frequency", NULL);
+	if (prop == NULL) {
+		grlib_apbuart_port_nr = 0;
+		return;
+	}
 	freq_khz = *prop;
 
 	line = 0;
@@ -666,6 +673,10 @@ static int __init grlib_apbuart_init(voi
 
 	/* Find all APBUARTS in device the tree and initialize their ports */
 	grlib_apbuart_configure();
+	if (grlib_apbuart_port_nr == 0) {
+		printk(KERN_INFO "Serial: GRLIB APBUART: No ports found.\n");
+		return -ENODEV;
+	}
 
 	printk(KERN_INFO "Serial: GRLIB APBUART driver\n");
 


