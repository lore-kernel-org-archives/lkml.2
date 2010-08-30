Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443Ab0H3BOr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 21:14:47 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:17402 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381Ab0H3BOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 21:14:40 -0400
Message-ID: <4C7B05A6.4010801@kernel.org>
Date: Sun, 29 Aug 2010 18:13:10 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
CC: Torsten Kaiser <just.for.lkml@googlemail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86, setup: fix earlyprintk=serial,0x3f8,115200
References: <AANLkTinRRiW1VUzS+3T82=q8PsoRn78Cgn_X8gSduM0U@mail.gmail.com> <AANLkTi=652CHVZz8TAqCOiOLO2XyUHd6_i3vWNgbVzKA@mail.gmail.com> <4C7B0578.8090807@kernel.org>
In-Reply-To: <4C7B0578.8090807@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


earlyprintk could take io port.

So we need to handle this case in setup code too, otherwise 0x3f8
will be treated as baud rate.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/boot/early_serial_console.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/boot/early_serial_console.c
===================================================================
--- linux-2.6.orig/arch/x86/boot/early_serial_console.c
+++ linux-2.6/arch/x86/boot/early_serial_console.c
@@ -58,7 +58,19 @@ static void parse_earlyprintk(void)
 		if (arg[pos] == ',')
 			pos++;
 
-		if (!strncmp(arg + pos, "ttyS", 4)) {
+		/*
+		 * make sure we have
+		 *	"serial,0x3f8,115200"
+		 *	"serial,ttyS0,115200"
+		 *	"ttyS0,115200"
+		 */
+		if (pos == 7 && !strncmp(arg + pos, "0x", 2)) {
+			port = simple_strtoull(arg + pos, &e, 16);
+			if (port == 0 || arg + pos == e)
+				port = DEFAULT_SERIAL_PORT;
+			else
+				pos = e - arg;
+		} else if (!strncmp(arg + pos, "ttyS", 4)) {
 			static const int bases[] = { 0x3f8, 0x2f8 };
 			int idx = 0;
 
