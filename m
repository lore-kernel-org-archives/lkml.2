Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991Ab1DAOX4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 10:23:56 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:35616 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809Ab1DAOXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 10:23:54 -0400
From: Julia Lawall <julia@diku.dk>
To: Brett Rudley <brudley@broadcom.com>
Cc: kernel-janitors@vger.kernel.org, Henry Ptasinski <henryp@broadcom.com>,
        Dowan Kim <dowan@broadcom.com>, Roland Vossen <rvossen@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Jason Cooper <jason@lakedaemon.net>, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] drivers/staging/brcm80211/brcmfmac/wl_iw.c: introduce missing kfree
Date: Fri,  1 Apr 2011 16:23:42 +0200
Message-Id: <1301667827-20056-1-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Error handling code following a kmalloc should free the allocated data.

The semantic match that finds the problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
statement S;
expression E;
identifier f,f1,l;
position p1,p2;
expression *ptr != NULL;
@@

x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...);
...
if (x == NULL) S
<... when != x
     when != if (...) { <+...x...+> }
(
x->f1 = E
|
 (x->f1 == NULL || ...)
|
 f(...,x->f1,...)
)
...>
(
 return \(0\|<+...x...+>\|ptr\);
|
 return@p2 ...;
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

print "* file: %s kmalloc %s return %s" % (p1[0].file,p1[0].line,p2[0].line)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
There is some other error handling code about 10 lines down where it looks
like a kfree is needed as well.  If that is the case, I can extend the patch.

 drivers/staging/brcm80211/brcmfmac/wl_iw.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/wl_iw.c b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
index b49957f..4e4cf36 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_iw.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
@@ -3672,8 +3672,10 @@ int wl_iw_attach(struct net_device *dev, void *dhdp)
 		return -ENOMEM;
 
 	iscan->iscan_ex_params_p = kmalloc(params_size, GFP_KERNEL);
-	if (!iscan->iscan_ex_params_p)
+	if (!iscan->iscan_ex_params_p) {
+		kfree(iscan);
 		return -ENOMEM;
+	}
 	iscan->iscan_ex_param_size = params_size;
 	iscan->sysioc_tsk = NULL;
 

