Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab1LFUQN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 15:16:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38160 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729Ab1LFUQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 15:16:12 -0500
Date: Tue, 6 Dec 2011 12:15:44 -0800
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-9lefe89mrvurrwpqw5h8xm8z@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, jbaron@redhat.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, jbaron@redhat.com,
        mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] jump_label, x86: Fix section mismatch
Git-Commit-ID: 9cdbe1cbac4ec318037297175587a0080acc9d11
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 06 Dec 2011 12:15:50 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9cdbe1cbac4ec318037297175587a0080acc9d11
Gitweb:     http://git.kernel.org/tip/9cdbe1cbac4ec318037297175587a0080acc9d11
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 6 Dec 2011 17:27:29 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Dec 2011 20:41:02 +0100

jump_label, x86: Fix section mismatch

WARNING: arch/x86/kernel/built-in.o(.text+0x4c71): Section mismatch in
reference from the function arch_jump_label_transform_static() to the
function .init.text:text_poke_early()
The function arch_jump_label_transform_static() references
the function __init text_poke_early().
This is often because arch_jump_label_transform_static lacks a __init
annotation or the annotation of text_poke_early is wrong.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jason Baron <jbaron@redhat.com>
Link: http://lkml.kernel.org/n/tip-9lefe89mrvurrwpqw5h8xm8z@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/jump_label.c |    2 +-
 kernel/jump_label.c          |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
index ea9d5f2f..2889b3d 100644
--- a/arch/x86/kernel/jump_label.c
+++ b/arch/x86/kernel/jump_label.c
@@ -50,7 +50,7 @@ void arch_jump_label_transform(struct jump_entry *entry,
 	put_online_cpus();
 }
 
-void arch_jump_label_transform_static(struct jump_entry *entry,
+__init_or_module void arch_jump_label_transform_static(struct jump_entry *entry,
 				      enum jump_label_type type)
 {
 	__jump_label_transform(entry, type, text_poke_early);
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 51a175a..3fb7b79 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -142,7 +142,7 @@ static int __jump_label_text_reserved(struct jump_entry *iter_start,
  * running code can override this to make the non-live update case
  * cheaper.
  */
-void __weak arch_jump_label_transform_static(struct jump_entry *entry,
+void __weak __init_or_module arch_jump_label_transform_static(struct jump_entry *entry,
 					    enum jump_label_type type)
 {
 	arch_jump_label_transform(entry, type);	
