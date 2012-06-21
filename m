Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab2FUBEl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 21:04:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59108 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755151Ab2FUBEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 21:04:40 -0400
Date: Wed, 20 Jun 2012 18:04:35 -0700
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Salman Qazi <sqazi@google.com>
Subject: [GIT PULL] cgroup fixes for v3.5-rc3
Message-ID: <20120621010435.GA30634@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Please pull from the following branch to receive two patches fixing a
refcnt race bug during css_put().  Decing and checking the value
weren't atomic and two tasks could think that they both pushed the
counter to zero.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.5-fixes

Salman Qazi (2):
      cgroup: make sure that decisions in __css_put are atomic
      cgroups: Account for CSS_DEACT_BIAS in __css_put

Thanks.
---
 kernel/cgroup.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 72fcd30..2097684 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -255,12 +255,17 @@ int cgroup_lock_is_held(void)
 
 EXPORT_SYMBOL_GPL(cgroup_lock_is_held);
 
+static int css_unbias_refcnt(int refcnt)
+{
+	return refcnt >= 0 ? refcnt : refcnt - CSS_DEACT_BIAS;
+}
+
 /* the current nr of refs, always >= 0 whether @css is deactivated or not */
 static int css_refcnt(struct cgroup_subsys_state *css)
 {
 	int v = atomic_read(&css->refcnt);
 
-	return v >= 0 ? v : v - CSS_DEACT_BIAS;
+	return css_unbias_refcnt(v);
 }
 
 /* convenient tests for these bits */
@@ -4982,10 +4987,12 @@ EXPORT_SYMBOL_GPL(__css_tryget);
 void __css_put(struct cgroup_subsys_state *css)
 {
 	struct cgroup *cgrp = css->cgroup;
+	int v;
 
 	rcu_read_lock();
-	atomic_dec(&css->refcnt);
-	switch (css_refcnt(css)) {
+	v = css_unbias_refcnt(atomic_dec_return(&css->refcnt));
+
+	switch (v) {
 	case 1:
 		if (notify_on_release(cgrp)) {
 			set_bit(CGRP_RELEASABLE, &cgrp->flags);
