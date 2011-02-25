Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335Ab1BYCls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 21:41:48 -0500
Received: from web38004.mail.mud.yahoo.com ([209.191.124.115]:36269 "HELO
	web38004.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753025Ab1BYClr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 21:41:47 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Feb 2011 21:41:47 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type;
  b=0zUK/xOJ47j7a2bq9+EH6mvxwV2UOpurphqnpup3yTKXeqtsLAnQ+6kj7DDKGGyKB0Du174dlgymAnW4Iju65i/GHwutAnAJmJ1pEy6IM+ffVr22+lrBcmjj+939rF4aSFdgcHFgVyHoobNwgZQhSb4nlJ63A2m6b6KfaYsBSMA=;
Message-ID: <518456.82543.qm@web38004.mail.mud.yahoo.com>
X-YMail-OSG: lABlIqUVM1k0YxV6sYe5XzCTb3v4HzNVZbwioMGhIVB3Eo7
 AkjLkf2pNmeQie4vSBIPIYv.RNKIir0jM99PtAd8FPTtZX9T.IICDqOPHP0y
 bcfEF1Q88XG7nog1xIDRwHODnGHdgszlRuoLETahem_0qk71MBiZr81AhkTY
 NFylQksh6Q6hFax7dpQ2PsIuklxkKoXOQGpCVreKle..6OUZXD2Tc1tuRNyR
 bgqj2UT25obFibDeAYH4HMKigmWyFfrMfAQizojKuyKNl8MBs6.kTAkVWexQ
 TxvgHq4ewlsXxIj_JKYPS8dIq81No2mKFTcpJm_xfPIlMDps_AIlOp7ovLB0
 w6NCfNQo-
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.109.292656
Date: Thu, 24 Feb 2011 18:35:05 -0800 (PST)
From: stuart h <stuart_hayes@yahoo.com>
Subject: [PATCH v2] dcdbas: force SMI to happen when expected
To: linux-kernel@vger.kernel.org, douglas_warzecha@dell.com
Cc: shyam_iyer@dell.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a reworked version of a very similar patch I sent about three weeks ago... a flaw was pointed out with the original.  That patch didn't make it into the kernel, though, so I'm just sending this one as a new patch.

The dcdbas driver can do an I/O write to cause a SMI to occur.  The SMI handler looks at certain registers and memory locations, so the SMI needs to happen immediately.  On some systems I/O writes are posted, though, causing the SMI to happen well after the "outb" occurred, which causes random failures.  Following the "outb" with an "inb" forces the write to go through even if it is posted.

This patch is against the 2.6.37.1 kernel.

Signed-off-by: Stuart Hayes <stuart_hayes@yahoo.com>
---

--- linux-2.6.37/drivers/firmware/dcdbas.c	2011-01-18 10:44:44.869882461 -0500
+++ linux-2.6.37_test/drivers/firmware/dcdbas.c	2011-02-24 13:23:58.663771596 -0500
@@ -268,8 +268,10 @@ int dcdbas_smi_request(struct smi_cmd *s
 	}
 
 	/* generate SMI */
+	/* inb to force posted write through and make SMI happen now */
 	asm volatile (
-		"outb %b0,%w1"
+		"outb %b0,%w1\n"
+		"inb %w1"
 		: /* no output args */
 		: "a" (smi_cmd->command_code),
 		  "d" (smi_cmd->command_address),



      
