Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191Ab2GCUe1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 16:34:27 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:48509 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748Ab2GCUe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 16:34:26 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] pwm: fix used-uninitialized warning in pwm_get()
Date: Tue,  3 Jul 2012 14:34:21 -0600
Message-Id: <1341347661-26567-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

This fixes:
drivers/pwm/core.c: In function 'pwm_get':
drivers/pwm/core.c:534:15: warning: 'index' may be used uninitialized in this function

The addition to the if condition at end of the function isn't strictly
necessary to solve the warning, but does make it more obvious that the
initialization of "index" to a dummy value isn't just hiding the
problem.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/pwm/core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
index dbab530..2b401c0 100644
--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -531,7 +531,7 @@ struct pwm_device *pwm_get(struct device *dev, const char *con_id)
 	struct pwm_chip *chip = NULL;
 	unsigned int best = 0;
 	struct pwm_lookup *p;
-	unsigned int index;
+	unsigned int index = -1;
 	unsigned int match;
 
 	/* look up via DT first */
@@ -588,7 +588,7 @@ struct pwm_device *pwm_get(struct device *dev, const char *con_id)
 		}
 	}
 
-	if (chip)
+	if (chip && index != -1)
 		pwm = pwm_request_from_chip(chip, index, con_id ?: dev_id);
 
 	mutex_unlock(&pwm_lookup_lock);
-- 
1.7.0.4

