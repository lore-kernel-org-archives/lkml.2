Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332Ab1HYTYW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 15:24:22 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:32913
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751427Ab1HYTYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 15:24:21 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275bhz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4E56A15D.8070406@freescale.com>
Date: Thu, 25 Aug 2011 14:24:13 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20110429 Fedora/3.6.17-1.fc13 Firefox/3.6.17
MIME-Version: 1.0
To: Arnaud Lacombe <lacombar@gmail.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xics/icp_natives: add __init to marker icp_native_init()
References: <1314288433-26322-1-git-send-email-lacombar@gmail.com>
In-Reply-To: <1314288433-26322-1-git-send-email-lacombar@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaud Lacombe wrote:
> This should fix the following warning:
> 
>  LD      arch/powerpc/sysdev/xics/built-in.o
> WARNING: arch/powerpc/sysdev/xics/built-in.o(.text+0x1310): Section mismatch in
> reference from the function .icp_native_init() to the function
> .init.text:.icp_native_init_one_node()
> The function .icp_native_init() references
> the function __init .icp_native_init_one_node().
> This is often because .icp_native_init lacks a __init
> annotation or the annotation of .icp_native_init_one_node is wrong.
> 
> icp_native_init() is only referenced in `arch/powerpc/sysdev/xics/xics-common.c'
> by xics_init() which is itself marked with __init.
> 
> = not built-tested =
> 
> Reported-by: Timur Tabi <timur@freescale.com>
> Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>

Acked-by: Timur Tabi <timur@freescale.com>

This warning still appears, though:

WARNING: arch/powerpc/sysdev/built-in.o(.text+0xf6b8): Section mismatch in
reference from the function .ics_rtas_init() to the function
.init.text:.xics_register_ics()
The function .ics_rtas_init() references
the function __init .xics_register_ics().
This is often because .ics_rtas_init lacks a __init
annotation or the annotation of .xics_register_ics is wrong.

To fix this warning, you'll also need:

diff --git a/arch/powerpc/sysdev/xics/ics-rtas.c b/arch/powerpc/sysdev/xics/ics-
index c782f85..a125721 100644
--- a/arch/powerpc/sysdev/xics/ics-rtas.c
+++ b/arch/powerpc/sysdev/xics/ics-rtas.c
@@ -213,7 +213,7 @@ static int ics_rtas_host_match(struct ics *ics, struct devic
        return !of_device_is_compatible(node, "chrp,iic");
 }

-int ics_rtas_init(void)
+int __init ics_rtas_init(void)
 {
        ibm_get_xive = rtas_token("ibm,get-xive");
        ibm_set_xive = rtas_token("ibm,set-xive");


However, now we get another similar warning:

WARNING: drivers/built-in.o(.text+0x259c484): Section mismatch in reference from
the function .tc3589x_keypad_open() to the function
.devinit.text:.tc3589x_keypad_init_key_hardware()
The function .tc3589x_keypad_open() references
the function __devinit .tc3589x_keypad_init_key_hardware().
This is often because .tc3589x_keypad_open lacks a __devinit
annotation or the annotation of .tc3589x_keypad_init_key_hardware is wrong.

I'm not sure what to do at this point, because I have a suspicion that adding
__devinit to tc3589x_keypad_open() is wrong.

-- 
Timur Tabi
Linux kernel developer at Freescale

