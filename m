Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030899Ab2B2KOh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 05:14:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58615 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030332Ab2B2KOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 05:14:35 -0500
Date: Wed, 29 Feb 2012 02:13:40 -0800
From: tip-bot for Jason Baron <jbaron@redhat.com>
Message-ID: <tip-fadf0464b83f91ba021a358c0238a0810c0d2a0b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, gleb@redhat.com, hpa@zytor.com,
        mingo@redhat.com, jbaron@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, gleb@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, jbaron@redhat.com,
        mingo@elte.hu
In-Reply-To: <3c68556121be4d1920417a3fe367da1ec38246b4.1329851692.git.jbaron@redhat.com>
References: <3c68556121be4d1920417a3fe367da1ec38246b4.1329851692.git.jbaron@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] jump label: Add a WARN()
  if jump label key count goes negative
Git-Commit-ID: fadf0464b83f91ba021a358c0238a0810c0d2a0b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 29 Feb 2012 02:14:13 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fadf0464b83f91ba021a358c0238a0810c0d2a0b
Gitweb:     http://git.kernel.org/tip/fadf0464b83f91ba021a358c0238a0810c0d2a0b
Author:     Jason Baron <jbaron@redhat.com>
AuthorDate: Tue, 21 Feb 2012 15:02:53 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 22 Feb 2012 07:59:39 +0100

jump label: Add a WARN() if jump label key count goes negative

The count on a jump label key should never go negative. Add a
WARN() to check for this condition.

Signed-off-by: Jason Baron <jbaron@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: rostedt@goodmis.org
Cc: mathieu.desnoyers@efficios.com
Cc: davem@davemloft.net
Cc: ddaney.cavm@gmail.com
Cc: a.p.zijlstra@chello.nl
Link: http://lkml.kernel.org/r/3c68556121be4d1920417a3fe367da1ec38246b4.1329851692.git.jbaron@redhat.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
