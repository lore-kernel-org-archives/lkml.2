Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971Ab2KHC4l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 21:56:41 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:47358 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754935Ab2KHC4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 21:56:38 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Hurley <peter@hurleysoftware.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 1/5] resources: Print resource ranges when expanding overlaps
Date: Wed,  7 Nov 2012 21:55:52 -0500
Message-Id: <1352343356-4006-2-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.7.12.3
In-Reply-To: <1352343356-4006-1-git-send-email-peter@hurleysoftware.com>
References: <1352343356-4006-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resource names can be too generic to distinguish which resources
overlap; eg.,
  kernel: Expanded resource reserved due to conflict with PCI Bus 0000:00
  kernel: Expanded resource reserved due to conflict with PCI Bus 0000:00

Rather, print decoded resource info as well; eg.,
  kernel: resource: Expanding reserved [mem 0xcfe5ec00-0xcfffffff]; overlaps PCI Bus 0000:00 [mem 0xcff00000-0xdfffffff]
  kernel: resource: Expanding reserved [mem 0xfe000000-0xfeffffff]; overlaps PCI Bus 0000:00 [mem 0xf0000000-0xfe000000]

Cc: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 kernel/resource.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index 73f35d4..461c2e0 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -696,12 +696,13 @@ void insert_resource_expand_to_fit(struct resource *root, struct resource *new)
 			break;
 
 		/* Ok, expand resource to cover the conflict, then try again .. */
+		pr_warn("Expanding %s %pR; overlaps %s %pR\n",
+			new->name, new, conflict->name, conflict);
+
 		if (conflict->start < new->start)
 			new->start = conflict->start;
 		if (conflict->end > new->end)
 			new->end = conflict->end;
-
-		printk("Expanded resource %s due to conflict with %s\n", new->name, conflict->name);
 	}
 	write_unlock(&resource_lock);
 }
-- 
1.7.12.3

