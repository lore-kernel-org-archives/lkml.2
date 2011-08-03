Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151Ab1HCSmz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 14:42:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:38873 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753980Ab1HCSmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 14:42:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,311,1309762800"; 
   d="scan'208";a="35095929"
Subject: [patch] gma500: restore the wb attribute for the scratch page
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "Cox, Alan" <alan.cox@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Venkatesh Pallipadi <venki@google.com>,
        "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Wed, 03 Aug 2011 11:42:26 -0700
Message-Id: <1312396946.7884.7.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan, Found this while checking who is using set_pages_uc() in the
current mainline code. I am also looking to see if we should add bug
check in __free_page() to avoid this kind of attribute leak or better
yet, restore the wb attribute in __free_page() itself (perhaps using
something like arch_free_page).

---
From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: gma500: restore the wb attribute for the scratch page

psb_driver_load() is changing the scratch_page attribute to uncached.
Restore the write-back attribute before freeing the page in the unload
routine.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 drivers/staging/gma500/psb_drv.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index b2cdce7..cb45ad7 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -285,6 +285,7 @@ static int psb_driver_unload(struct drm_device *dev)
 		}
 		psb_gtt_takedown(dev);
 		if (dev_priv->scratch_page) {
+			set_pages_wb(dev_priv->scratch_page, 1);
 			__free_page(dev_priv->scratch_page);
 			dev_priv->scratch_page = NULL;
 		}


