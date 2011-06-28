Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366Ab1F1P6v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 11:58:51 -0400
Received: from adelie.canonical.com ([91.189.90.139]:36470 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758666Ab1F1P43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 11:56:29 -0400
From: John Johansen <john.johansen@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, jmorris@namei.org
Subject: [PATCH 1/2] AppArmor: Fix reference to rcu protected pointer outside of rcu_read_lock
Date: Tue, 28 Jun 2011 16:56:04 +0100
Message-Id: <1309276565-20776-2-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309276565-20776-1-git-send-email-john.johansen@canonical.com>
References: <1309276565-20776-1-git-send-email-john.johansen@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pointer returned from tracehook_tracer_task() is only valid inside
the rcu_read_lock.  However the tracer pointer obtained is being passed
to aa_may_ptrace outside of the rcu_read_lock critical section.

Mover the aa_may_ptrace test into the rcu_read_lock critical section, to
fix this.

Kernels affected: 2.6.36 - 3.0

Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
---
 security/apparmor/domain.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/security/apparmor/domain.c b/security/apparmor/domain.c
index c825c6e..78adc43 100644
--- a/security/apparmor/domain.c
+++ b/security/apparmor/domain.c
@@ -73,7 +73,6 @@ static int may_change_ptraced_domain(struct task_struct *task,
 		cred = get_task_cred(tracer);
 		tracerp = aa_cred_profile(cred);
 	}
-	rcu_read_unlock();
 
 	/* not ptraced */
 	if (!tracer || unconfined(tracerp))
@@ -82,6 +81,7 @@ static int may_change_ptraced_domain(struct task_struct *task,
 	error = aa_may_ptrace(tracer, tracerp, to_profile, PTRACE_MODE_ATTACH);
 
 out:
+	rcu_read_unlock();
 	if (cred)
 		put_cred(cred);
 
-- 
1.7.4.1

