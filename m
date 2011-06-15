Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374Ab1FPHAe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:00:34 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:33109 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755174Ab1FPHAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:00:30 -0400
X-Sasl-enc: 9Lt6jUkE9t7I5337zA/S8D1krY8II4teh/U1tla6MhxO 1308207629
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:31 2011
Message-Id: <20110616000230.970460490@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 16:59:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Huaxu Wan <huaxu.wan@linux.intel.com>, Carsten Emde <C.Emde@osadl.org>,
        Valdis Kletnieks <valdis.kletnieks@vt.edu>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Yong Wang <yong.y.wang@linux.intel.com>,
        Rudolf Marek <r.marek@assembler.cz>, Fenghua Yu <fenghua.yu@intel.com>,
        Jean Delvare <khali@linux-fr.org>
Subject: [20/89] hwmon: (coretemp) Fix TjMax detection for older CPUs
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Guenter Roeck <guenter.roeck@ericsson.com>

commit 4f5f71a7abe329bdad81ee6a8e4545054a7cc30a upstream.

Commit a321cedb12904114e2ba5041a3673ca24deb09c9 excludes CPU models 0xe, 0xf,
0x16, and 0x1a from TjMax temperature adjustment, even though several of those
CPUs are known to have TiMax other than 100 degrees C, and even though the code
in adjust_tjmax() explicitly handles those CPUs and points to a Web document
listing several of the affected CPU IDs.

Reinstate original TjMax adjustment if TjMax can not be determined using the
IA32_TEMPERATURE_TARGET register.

https://bugzilla.kernel.org/show_bug.cgi?id=32582

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Huaxu Wan <huaxu.wan@linux.intel.com>
Cc: Carsten Emde <C.Emde@osadl.org>
Cc: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Yong Wang <yong.y.wang@linux.intel.com>
Cc: Rudolf Marek <r.marek@assembler.cz>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Tested-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/coretemp.c |   19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -271,24 +271,9 @@ static int __devinit get_tjmax(struct cp
 
 	/*
 	 * An assumption is made for early CPUs and unreadable MSR.
-	 * NOTE: the given value may not be correct.
+	 * NOTE: the calculated value may not be correct.
 	 */
-
-	switch (c->x86_model) {
-	case 0xe:
-	case 0xf:
-	case 0x16:
-	case 0x1a:
-		dev_warn(dev, "TjMax is assumed as 100 C!\n");
-		return 100000;
-	case 0x17:
-	case 0x1c:		/* Atom CPUs */
-		return adjust_tjmax(c, id, dev);
-	default:
-		dev_warn(dev, "CPU (model=0x%x) is not supported yet,"
-			" using default TjMax of 100C.\n", c->x86_model);
-		return 100000;
-	}
+	return adjust_tjmax(c, id, dev);
 }
 
 static void __devinit get_ucode_rev_on_cpu(void *edx)


