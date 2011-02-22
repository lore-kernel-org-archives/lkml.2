Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab1BVHP0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 02:15:26 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:44345 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752246Ab1BVHPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 02:15:25 -0500
Date: Tue, 22 Feb 2011 18:15:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        George <george0505@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: linux-next: build failure after merge of the final tree (wireless
 tree related)
Message-Id: <20110222181519.7a020eb3.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/net/wireless/rtlwifi/rtl8192cu/sw.c: In function 'rtl92cu_init_sw_vars':
drivers/net/wireless/rtlwifi/rtl8192cu/sw.c:60: error: implicit declaration of function 'vmalloc'
drivers/net/wireless/rtlwifi/rtl8192cu/sw.c:60: warning: assignment makes pointer from integer without a cast
drivers/net/wireless/rtlwifi/rtl8192cu/sw.c: In function 'rtl92cu_deinit_sw_vars':
drivers/net/wireless/rtlwifi/rtl8192cu/sw.c:74: error: implicit declaration of function 'vfree'

Caused by commit 442888c706e90634c4cc3441751b43115a7d8506 ("rtlwifi:
rtl8192cu: Add routines dm, fw, led and sw").  Missing an include of
linux/vmalloc.h.  See Rule 1 in Documentation/SubmitChecklist.

I added the following patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 22 Feb 2011 17:29:04 +1100
Subject: [PATCH] rtlwifi: include vmalloc.h for needed routines

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
index 4e937e0..c69861e 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
@@ -27,6 +27,8 @@
  *
  *****************************************************************************/
 
+#include <linux/vmalloc.h>
+
 #include "../wifi.h"
 #include "../core.h"
 #include "../usb.h"
-- 
1.7.4.1

but then got:

drivers/net/wireless/rtlwifi/rtl8192cu/built-in.o: In function `rtl92c_phy_sw_chnl':
(.opd+0xf30): multiple definition of `rtl92c_phy_sw_chnl'
drivers/net/wireless/rtlwifi/rtl8192ce/built-in.o:(.opd+0xb70): first defined here
drivers/net/wireless/rtlwifi/rtl8192cu/built-in.o: In function `rtl92c_fill_h2c_cmd':
(.opd+0x288): multiple definition of `rtl92c_fill_h2c_cmd'
drivers/net/wireless/rtlwifi/rtl8192ce/built-in.o:(.opd+0x288): first defined here

and lots more.

So I have used the wireless tree from next-20110221 for today.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
