Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab2GQJES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 05:04:18 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:38385 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917Ab2GQJEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 05:04:14 -0400
Message-ID: <50052A85.7070305@linux.vnet.ibm.com>
Date: Tue, 17 Jul 2012 17:04:05 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: mingo@redhat.com, Peter Zijlstra <peterz@infradead.org>,
        paul@paulmenage.org
Subject: [PATCH 3/5] cpusets: enable the dynamical domain flags
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12071709-8878-0000-0000-00000349C349
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Wang <wangyun@linux.vnet.ibm.com>

We will record the domain flags for cpuset in update_domain_attr and
use it to replace the static domain flags in set_domain_attribute.

Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 kernel/cpuset.c     |    7 +++++++
 kernel/sched/core.c |   10 +++++++++-
 2 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 67ee111..def8080 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -476,8 +476,15 @@ static int cpusets_overlap(struct cpuset *a, struct cpuset *b)
 static void
 update_domain_attr(struct sched_domain_attr *dattr, struct cpuset *c)
 {
+	int i;
 	if (dattr->relax_domain_level < c->relax_domain_level)
 		dattr->relax_domain_level = c->relax_domain_level;
+	/* record all the domain flags if cpuset want to use them */
+	if (c->enable_ddf) {
+		dattr->enable_ddf = 1;
+		for (i = 0; i < MAX_DDF; i++)
+			dattr->ddf[i] = c->ddf[i];
+	}
 	return;
 }
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 3f9d368..7a1c886 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6461,7 +6461,15 @@ static void set_domain_attribute(struct sched_domain *sd,
 {
 	int request;
 
-	if (!attr || attr->relax_domain_level < 0) {
+	if (!attr)
+		return;
+
+	if (attr->enable_ddf) {
+		/* replace domain flags with ddf according to level */
+		sd->flags = attr->ddf[sd->level];
+	}
+
+	if (attr->relax_domain_level < 0) {
 		if (default_relax_domain_level < 0)
 			return;
 		else
-- 
1.7.4.1

