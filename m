Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126Ab2BUUDO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 15:03:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754763Ab2BUUDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 15:03:12 -0500
Date: Tue, 21 Feb 2012 15:02:53 -0500
From: Jason Baron <jbaron@redhat.com>
To: a.p.zijlstra@chello.nl, mingo@elte.hu
Cc: rostedt@goodmis.org, mathieu.desnoyers@efficios.com, hpa@zytor.com,
        davem@davemloft.net, ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        gleb@redhat.com, linux-kernel@vger.kernel.org
Message-Id: <3c68556121be4d1920417a3fe367da1ec38246b4.1329851692.git.jbaron@redhat.com>
In-Reply-To: <cover.1329851692.git.jbaron@redhat.com>
References: <cover.1329851692.git.jbaron@redhat.com>
Subject: [PATCH 01/10] jump label: Add a WARN() if jump label key count goes negative
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The count on a jump label key should never go negative. Add a WARN() to
check for this condition.

Cc: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 kernel/jump_label.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 01d3b70..ed9654f 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -76,8 +76,11 @@ EXPORT_SYMBOL_GPL(jump_label_inc);
 static void __jump_label_dec(struct jump_label_key *key,
 		unsigned long rate_limit, struct delayed_work *work)
 {
-	if (!atomic_dec_and_mutex_lock(&key->enabled, &jump_label_mutex))
+	if (!atomic_dec_and_mutex_lock(&key->enabled, &jump_label_mutex)) {
+		WARN(atomic_read(&key->enabled) < 0,
+		     "jump label: negative count!\n");
 		return;
+	}
 
 	if (rate_limit) {
 		atomic_inc(&key->enabled);
-- 
1.7.7.5

