Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab2HFDWz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 23:22:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:33681 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755583Ab2HFDWc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 23:22:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="182024304"
From: "Gross, Mark" <mark.gross@intel.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Julia Lawall <julia@diku.dk>
Subject: RE: [PATCH 5/6] drivers/char/tlclk.c: fix error return code
Thread-Topic: [PATCH 5/6] drivers/char/tlclk.c: fix error return code
Thread-Index: AQHNcvARe9rI/aKwJkqVxEYO/gu9pJdMHwXQ
Date: Mon, 6 Aug 2012 03:22:29 +0000
Message-ID: <BD75D217E5BAC84080F8EFB25829763746C7A7D9@ORSMSX101.amr.corp.intel.com>
References: <1344160356-387-1-git-send-email-Julia.Lawall@lip6.fr>
 <1344160356-387-6-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1344160356-387-6-git-send-email-Julia.Lawall@lip6.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by <mark.gross@intel.com>

--mark
Ps sorry for the outlook munged reply.

-----Original Message-----
From: Julia Lawall [mailto:Julia.Lawall@lip6.fr] 
Sent: Sunday, August 05, 2012 2:53 AM
To: Gross, Mark
Cc: kernel-janitors@vger.kernel.org; Arnd Bergmann; Greg Kroah-Hartman; linux-kernel@vger.kernel.org; Julia Lawall
Subject: [PATCH 5/6] drivers/char/tlclk.c: fix error return code

From: Julia Lawall <julia@diku.dk>

Convert a 0 error return code to a negative one, as returned elsewhere in the function.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier ret;
expression e,e1,e2,e3,e4,x;
@@

(
if (\(ret != 0\|ret < 0\) || ...) { ... return ...; }
|
ret = 0
)
... when != ret = e1
*x = \(kmalloc\|kzalloc\|kcalloc\|devm_kzalloc\|ioremap\|ioremap_nocache\|devm_ioremap\|devm_ioremap_nocache\)(...);
... when != x = e2
    when != ret = e3
*if (x == NULL || ...)
{
  ... when != ret = e4
*  return ret;
}
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/char/tlclk.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tlclk.c b/drivers/char/tlclk.c index ce29e7c..e95e0ab 100644
--- a/drivers/char/tlclk.c
+++ b/drivers/char/tlclk.c
@@ -784,8 +784,10 @@ static int __init tlclk_init(void)
 	}
 	tlclk_major = ret;
 	alarm_events = kzalloc( sizeof(struct tlclk_alarms), GFP_KERNEL);
-	if (!alarm_events)
+	if (!alarm_events) {
+		ret = -ENOMEM;
 		goto out1;
+	}
 
 	/* Read telecom clock IRQ number (Set by BIOS) */
 	if (!request_region(TLCLK_BASE, 8, "telco_clock")) {

