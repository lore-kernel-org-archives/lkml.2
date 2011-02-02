Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748Ab1BBBAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 20:00:53 -0500
Received: from mga11.intel.com ([192.55.52.93]:8119 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335Ab1BBAoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:44:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="883418133"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: nelhage@ksplice.com, davem@davemloft.net, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [66/139] econet: Do the correct cleanup after an unprivileged SIOCSIFADDR.
Message-Id: <20110202004422.DC4903E09C6@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:44:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Nelson Elhage <nelhage@ksplice.com>

[ Upstream commit 0c62fc6dd02c8d793c75ae76a9b6881fc36388ad]

We need to drop the mutex and do a dev_put, so set an error code and break like
the other paths, instead of returning directly.

Signed-off-by: Nelson Elhage <nelhage@ksplice.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/econet/af_econet.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/net/econet/af_econet.c
===================================================================
--- linux-2.6.35.y.orig/net/econet/af_econet.c
+++ linux-2.6.35.y/net/econet/af_econet.c
@@ -661,8 +661,10 @@ static int ec_dev_ioctl(struct socket *s
 	err = 0;
 	switch (cmd) {
 	case SIOCSIFADDR:
-		if (!capable(CAP_NET_ADMIN))
-			return -EPERM;
+		if (!capable(CAP_NET_ADMIN)) {
+			err = -EPERM;
+			break;
+		}
 
 		edev = dev->ec_ptr;
 		if (edev == NULL) {
