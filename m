Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849Ab1LFRbd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 12:31:33 -0500
Received: from casper.infradead.org ([85.118.1.10]:54238 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab1LFRbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 12:31:32 -0500
Message-Id: <20111206172803.418829103@chello.nl>
User-Agent: quilt/0.48-1
Date: Tue, 06 Dec 2011 18:15:35 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/3] jump_label, x86: Fix section mismatch
References: <20111206171534.429636558@chello.nl>
Content-Disposition: inline; filename=jump_label-section-mismatch.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: arch/x86/kernel/built-in.o(.text+0x4c71): Section mismatch in
reference from the function arch_jump_label_transform_static() to the
function .init.text:text_poke_early()
The function arch_jump_label_transform_static() references
the function __init text_poke_early().
This is often because arch_jump_label_transform_static lacks a __init 
annotation or the annotation of text_poke_early is wrong.

Cc: Jason Baron <jbaron@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/jump_label.c |    2 +-
 kernel/jump_label.c          |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/kernel/jump_label.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/jump_label.c
+++ linux-2.6/arch/x86/kernel/jump_label.c
@@ -50,7 +50,7 @@ void arch_jump_label_transform(struct ju
 	put_online_cpus();
 }
 
-void arch_jump_label_transform_static(struct jump_entry *entry,
+__init_or_module void arch_jump_label_transform_static(struct jump_entry *entry,
 				      enum jump_label_type type)
 {
 	__jump_label_transform(entry, type, text_poke_early);
Index: linux-2.6/kernel/jump_label.c
===================================================================
--- linux-2.6.orig/kernel/jump_label.c
+++ linux-2.6/kernel/jump_label.c
@@ -142,7 +142,7 @@ static int __jump_label_text_reserved(st
  * running code can override this to make the non-live update case
  * cheaper.
  */
-void __weak arch_jump_label_transform_static(struct jump_entry *entry,
+void __weak __init_or_module arch_jump_label_transform_static(struct jump_entry *entry,
 					    enum jump_label_type type)
 {
 	arch_jump_label_transform(entry, type);	


