Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123Ab1EDPjE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 11:39:04 -0400
Received: from smtp.outflux.net ([198.145.64.163]:58934 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755001Ab1EDPjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 11:39:01 -0400
Date: Wed, 4 May 2011 08:38:56 -0700
From: Kees Cook <kees.cook@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>, cpufreq@vger.kernel.org
Subject: [PATCH] cpufreq: remove redundant sprintf
Message-ID: <20110504153856.GA30309@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since format string handling is part of request_module, there is no
need to construct the module name. As such, drop the redundant sprintf
and heap usage.

Signed-off-by: Kees Cook <kees.cook@canonical.com>
---
 drivers/cpufreq/cpufreq.c |   19 ++++++-------------
 1 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 2dafc5c..95eb6cc 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -411,21 +411,14 @@ static int cpufreq_parse_governor(char *str_governor, unsigned int *policy,
 		t = __find_governor(str_governor);
 
 		if (t == NULL) {
-			char *name = kasprintf(GFP_KERNEL, "cpufreq_%s",
-								str_governor);
+			int ret;
 
-			if (name) {
-				int ret;
+			mutex_unlock(&cpufreq_governor_mutex);
+			ret = request_module("cpufreq_%s", str_governor);
+			mutex_lock(&cpufreq_governor_mutex);
 
-				mutex_unlock(&cpufreq_governor_mutex);
-				ret = request_module("%s", name);
-				mutex_lock(&cpufreq_governor_mutex);
-
-				if (ret == 0)
-					t = __find_governor(str_governor);
-			}
-
-			kfree(name);
+			if (ret == 0)
+				t = __find_governor(str_governor);
 		}
 
 		if (t != NULL) {
-- 
1.7.4.1

-- 
Kees Cook
Ubuntu Security Team
