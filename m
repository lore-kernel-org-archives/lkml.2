Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079Ab0JBNy7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 09:54:59 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:52932 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754659Ab0JBNy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 09:54:57 -0400
From: Julia Lawall <julia@diku.dk>
To: Eric Moore <Eric.Moore@lsi.com>
Cc: kernel-janitors@vger.kernel.org, support@lsi.com,
        DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] drivers/message/fusion/mptctl.c: Add missing error handling code
Date: Sat,  2 Oct 2010 15:59:16 +0200
Message-Id: <1286027958-7333-2-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

karg is allocated using kmalloc and is completely local to this function.
It should thus be freed before exiting the function in an error case.

A simplified version of the sematic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
@r@
statement S1,S2,S3;
constant C1,C2,C3;
@@

*if (...)
 {... S1 return -C1;}
...
*if (...)
 {... when != S1
    return -C2;}
...
*if (...)
 {... S1 return -C3;}
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/message/fusion/mptctl.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index a3856ed..1dcc13a 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -1307,8 +1307,10 @@ mptctl_getiocinfo (unsigned long arg, unsigned int data_size)
 	else
 		karg->adapterType = MPT_IOCTL_INTERFACE_SCSI;
 
-	if (karg->hdr.port > 1)
+	if (karg->hdr.port > 1) {
+		kfree(karg);
 		return -EINVAL;
+	}
 	port = karg->hdr.port;
 
 	karg->port = port;

