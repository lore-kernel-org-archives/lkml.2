Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760072Ab2EVSLz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 14:11:55 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:52976 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617Ab2EVSLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 14:11:53 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Ingo Molnar <mingo@elte.hu>, Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Use test_and_clear_bit() instead atomic_dec_and_test() for stop_machine
References: <87likkt7u6.fsf@devron.myhome.or.jp>
Date: Wed, 23 May 2012 03:11:48 +0900
In-Reply-To: <87likkt7u6.fsf@devron.myhome.or.jp> (OGAWA Hirofumi's message of
	"Wed, 23 May 2012 02:59:45 +0900")
Message-ID: <87ehqct7a3.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[forgot to Cc: lkml, resend]

Hi,

Maybe, nobody using debug patch in atomic_dec_and_test()...  Well,
anyway, how about this?



stop_machine_first is just to see if it is first one or not.  So, there
is no reason to use atomic_dec_and_test(), and makes the value below 0.

I think it is not desirable, because this usage only triggers
atomic_dec_and_test() underflow debug patch. (the patch tests result
of atomic_dec_and_test() is < 0)

So, this uses test_and_clear_bit() instead.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 arch/x86/kernel/alternative.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/x86/kernel/alternative.c~stop_machine-use-test_and_set_bit arch/x86/kernel/alternative.c
--- linux/arch/x86/kernel/alternative.c~stop_machine-use-test_and_set_bit	2012-05-23 02:48:01.000000000 +0900
+++ linux-hirofumi/arch/x86/kernel/alternative.c	2012-05-23 02:48:01.000000000 +0900
@@ -650,7 +650,7 @@ void *__kprobes text_poke(void *addr, co
  * Cross-modifying kernel text with stop_machine().
  * This code originally comes from immediate value.
  */
-static atomic_t stop_machine_first;
+static unsigned long stop_machine_first;
 static int wrote_text;
 
 struct text_poke_params {
@@ -664,7 +664,7 @@ static int __kprobes stop_machine_text_p
 	struct text_poke_param *p;
 	int i;
 
-	if (atomic_dec_and_test(&stop_machine_first)) {
+	if (test_and_clear_bit(0, &stop_machine_first)) {
 		for (i = 0; i < tpp->nparams; i++) {
 			p = &tpp->params[i];
 			text_poke(p->addr, p->opcode, p->len);
@@ -714,7 +714,7 @@ void *__kprobes text_poke_smp(void *addr
 	p.len = len;
 	tpp.params = &p;
 	tpp.nparams = 1;
-	atomic_set(&stop_machine_first, 1);
+	stop_machine_first = 1;
 	wrote_text = 0;
 	/* Use __stop_machine() because the caller already got online_cpus. */
 	__stop_machine(stop_machine_text_poke, (void *)&tpp, cpu_online_mask);
@@ -736,7 +736,7 @@ void __kprobes text_poke_smp_batch(struc
 {
 	struct text_poke_params tpp = {.params = params, .nparams = n};
 
-	atomic_set(&stop_machine_first, 1);
+	stop_machine_first = 1;
 	wrote_text = 0;
 	__stop_machine(stop_machine_text_poke, (void *)&tpp, cpu_online_mask);
 }
_

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
