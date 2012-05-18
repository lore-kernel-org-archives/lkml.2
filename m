Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946565Ab2ERXF3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:05:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58844 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946549Ab2ERXFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:05:21 -0400
Message-Id: <20120518211604.358375854@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 18 May 2012 14:16:53 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [ 54/54] pch_gbe: memory corruption calling pch_gbe_validate_option()
In-Reply-To: <20120518212656.GA4992@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 73f98eab9b9e0bab492ca06add5657d9e702ddb1 upstream.

pch_gbe_validate_option() modifies 32 bits of memory but we pass
&hw->phy.autoneg_advertised which only has 16 bits and &hw->mac.fc
which only has 8 bits.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/pch_gbe/pch_gbe_param.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/drivers/net/pch_gbe/pch_gbe_param.c
+++ b/drivers/net/pch_gbe/pch_gbe_param.c
@@ -320,10 +320,10 @@ static void pch_gbe_check_copper_options
 			pr_debug("AutoNeg specified along with Speed or Duplex, AutoNeg parameter ignored\n");
 			hw->phy.autoneg_advertised = opt.def;
 		} else {
-			hw->phy.autoneg_advertised = AutoNeg;
-			pch_gbe_validate_option(
-				(int *)(&hw->phy.autoneg_advertised),
-				&opt, adapter);
+			int tmp = AutoNeg;
+
+			pch_gbe_validate_option(&tmp, &opt, adapter);
+			hw->phy.autoneg_advertised = tmp;
 		}
 	}
 
@@ -494,9 +494,10 @@ void pch_gbe_check_options(struct pch_gb
 			.arg  = { .l = { .nr = (int)ARRAY_SIZE(fc_list),
 					 .p = fc_list } }
 		};
-		hw->mac.fc = FlowControl;
-		pch_gbe_validate_option((int *)(&hw->mac.fc),
-						&opt, adapter);
+		int tmp = FlowControl;
+
+		pch_gbe_validate_option(&tmp, &opt, adapter);
+		hw->mac.fc = tmp;
 	}
 
 	pch_gbe_check_copper_options(adapter);


