Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab2ATQRi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 11:17:38 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:23743 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444Ab2ATQRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 11:17:33 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+rbbWJkylzRIUFMbaxCzhB
Subject: [PATCH 2/4] pinctrl: Fix pinmux_hog_maps when ctrl_dev_name is not
 set
To: linux-kernel@vger.kernel.org
From: Tony Lindgren <tony@atomide.com>
Cc: Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Barry Song <21cnbao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>
Date: Fri, 20 Jan 2012 08:17:27 -0800
Message-ID: <20120120161727.21955.7437.stgit@kaulin.local>
In-Reply-To: <20120120161610.21955.25082.stgit@kaulin.local>
References: <20120120161610.21955.25082.stgit@kaulin.local>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ctrl_dev_name is optional for struct pinmux_map assuming
that ctrl_dev is set. Without this patch we can get:

Unable to handle kernel NULL pointer dereference at virtual address 00000000
...
(pinmux_hog_maps+0xa4/0x20c)
(pinctrl_register+0x2a4/0x378)
...

Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 drivers/pinctrl/pinmux.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index a76a348..06b8943 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -992,9 +992,12 @@ int pinmux_hog_maps(struct pinctrl_dev *pctldev)
 
 	for (i = 0; i < pinmux_maps_num; i++) {
 		struct pinmux_map const *map = &pinmux_maps[i];
+		int match_found = 0;
 
-		if (((map->ctrl_dev == dev) ||
-		     !strcmp(map->ctrl_dev_name, devname)) &&
+		if (map->ctrl_dev_name && !strcmp(map->ctrl_dev_name, devname))
+				match_found = 1;
+
+		if (((map->ctrl_dev == dev) || match_found) &&
 		    map->hog_on_boot) {
 			/* OK time to hog! */
 			ret = pinmux_hog_map(pctldev, map);

