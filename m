Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264Ab0EKNiS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 09:38:18 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63468 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757186Ab0EKNiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 09:38:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=PoDBGIwTr7Hk820PoAPLT1dFFe04/sKAyHi6loKZ6s9UGq6NSFK/lGrJrdaTVXOrbq
         LaHMMlq+iOxrcnNy0KZwinZvROJvJzmqNq4uDBlZiehe96xQnLJ0xoDycMuL33IIEUHw
         eTlUeHOmwjZqSi73s69MuZmITSL4JqDZlzAAM=
Subject: Re: [PATCH] [OOPS] apbuart.c: Two problems related to
 grlib_apbuart_configure()
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
To: kristoffer@gaisler.com, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1273355935.13191.6.camel@carter>
References: <1273355935.13191.6.camel@carter>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 May 2010 15:38:04 +0200
Message-ID: <1273585084.8948.12.camel@carter>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Kristoffer, please check this one instead.

Changes:
1. Added the grlib_apbuart_port_nr = 0 line.
2. Returned -ENODEV instead of 0 in the "no ports found branch" in
init(), because if compiled as a module, exit() will try to unregister
things that were not registered. In addition, this will alert the users
that modprobe'd.
3. Deleted the unused __FILE__ argument of the previous patch (oops
sorry :).

Andrew, if Kristoffer agrees, please drop the older patch from -mm and
merge this one instead.

Signed-off-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
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
 

