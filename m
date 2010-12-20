Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489Ab0LTMCD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 07:02:03 -0500
Received: from mxintlb12fl.versatel.de ([62.214.97.106]:53929 "EHLO
	mxintlb12fl.versatel.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757337Ab0LTMCA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 07:02:00 -0500
X-Greylist: delayed 2012 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Dec 2010 07:01:59 EST
X-PMWin-SpamScore: 8
X-PMWin-Spam: Gauge=IIIIIIII, Probability=8%, Report='__MIME_VERSION, __CT, __CT_TEXT_PLAIN, __CTE, __HAS_MSGID, __IMS_MSGID, __SANE_MSGID, __TO_MALFORMED_2, __HAS_XOAT, __FRAUD_REFNUM, __CP_URI_IN_BODY, BODYTEXTP_SIZE_3000_LESS, BODY_SIZE_2000_2999, __MIME_TEXT_ONLY, BODY_SIZE_5000_LESS, BODY_SIZE_7000_LESS'
X-PMWin-Version: 2.6.1, Antispam-Engine: 2.7.2, Antivirus-Engine: 3.14.1
Importance: normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.3959
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: AW: [PATCH] ISDN cmx: Avoid potential NULL deref in dsp_cmx_send_member() and shrink code size.
Date: Mon, 20 Dec 2010 12:26:23 +0100
Message-ID: <B16317F2B1592B4492FC414114171CE604B08AEA@FLBVEXCH01.versatel.local>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] ISDN cmx: Avoid potential NULL deref in dsp_cmx_send_member() and shrink code size.
thread-index: AcufBP37Qwe8hTwDQ8OzClDPHA7dggBMb7iA
From: "Andreas.Eversberg" <Andreas.Eversberg@versatel.de>
To: "Jesper Juhl" <jj@chaosbits.net>, "Karsten Keil" <isdn@linux-pingi.de>
Cc: "David S. Miller" <davem@davemloft.net>, "Julia Lawall" <julia@diku.dk>,
        "Tejun Heo" <tj@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 20 Dec 2010 11:26:24.0037 (UTC) FILETIME=[BBD91550:01CBA038]
X-purgate-ID: 150646::1292844299-00004391-C34875F5/0-0/0-0
X-purgate-type: clean
X-purgate-size: 2810
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi jesper,

thanx for finding the bug. i think the right solution to solve the problem would be:

                if (dsp->conf && dsp->conf->software && dsp->conf->hardware)
                        tx_data_only = 1;
->              if (dsp->echo.software && dsp->echo.hardware)
                        tx_data_only = 1;

this is how it looks in the 'socket' branch of mISDN git respository. it has been fixed already. but i cannot tell in which commit. my current head is this commit:
commit 45a51eed1c554a4891b48b88c270f4f95bd21df0

what branch do you use? 

regards,

andreas


-----Ursprüngliche Nachricht-----
Von: Jesper Juhl [mailto:jj@chaosbits.net] 
Gesendet: Samstag, 18. Dezember 2010 23:34
An: Karsten Keil
Cc: David S. Miller; Julia Lawall; Tejun Heo; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Andreas Eversberg
Betreff: [PATCH] ISDN cmx: Avoid potential NULL deref in dsp_cmx_send_member() and shrink code size.

Hi there,

In drivers/isdn/mISDN/dsp_cmx.c::dsp_cmx_send_member() we currently have 
this code:

           if (dsp->conf && dsp->conf->software && dsp->conf->hardware)
                   tx_data_only = 1;
           if (dsp->conf->software && dsp->echo.hardware)
                   tx_data_only = 1;

The first line implies that 'dsp->conf' may be NULL. If it is, then the 
third line will dereference a NULL pointer.

This patch reworks the code so that we avoid the potential NULL deref.
It also has the added benefit that the object file size shrinks a bit.

before:
   text    data     bss     dec     hex filename
  18840     112    5784   24736    60a0 drivers/isdn/mISDN/dsp_cmx.o
after:
   text    data     bss     dec     hex filename
  18816     112    5776   24704    6080 drivers/isdn/mISDN/dsp_cmx.o


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 dsp_cmx.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

 compile tested only

diff --git a/drivers/isdn/mISDN/dsp_cmx.c b/drivers/isdn/mISDN/dsp_cmx.c
index 76d9e67..f76f595 100644
--- a/drivers/isdn/mISDN/dsp_cmx.c
+++ b/drivers/isdn/mISDN/dsp_cmx.c
@@ -1326,10 +1326,9 @@ dsp_cmx_send_member(struct dsp *dsp, int len, s32 *c, int members)
 			dsp->last_tx = 0;
 			return;
 		}
-		if (dsp->conf && dsp->conf->software && dsp->conf->hardware)
-			tx_data_only = 1;
-		if (dsp->conf->software && dsp->echo.hardware)
-			tx_data_only = 1;
+		if (dsp->conf && dsp->conf->software)
+			if (dsp->conf->hardware || dsp->echo.hardware)
+				tx_data_only = 1;
 	}
 
 #ifdef CMX_DEBUG



-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.
