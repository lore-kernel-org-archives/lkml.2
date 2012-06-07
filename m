Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760244Ab2FGNUX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 09:20:23 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:59300 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757999Ab2FGNUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 09:20:21 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Ingo Molnar <mingo@elte.hu>, Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] Use atomic_xchg() instead atomic_dec_and_test() for stop_machine
Date: Thu, 07 Jun 2012 22:20:18 +0900
Message-ID: <87zk8fgsx9.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


stop_machine_first is just to see if it is first one or not.  In this
usage, atomic_dec_and_test() makes value less than 0.

I think it is not desirable, because it only triggers
atomic_dec_and_test() less than 0 debug patch. (the patch tests result
of atomic_dec_and_test() is < 0)

So, this uses atomic_xchg() instead.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
---

 arch/x86/kernel/alternative.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/kernel/alternative.c~stop_machine-use-atomic_xchg arch/x86/kernel/alternative.c
--- linux/arch/x86/kernel/alternative.c~stop_machine-use-atomic_xchg	2012-05-23 13:10:03.000000000 +0900
+++ linux-hirofumi/arch/x86/kernel/alternative.c	2012-05-23 13:10:03.000000000 +0900
@@ -664,7 +664,7 @@ static int __kprobes stop_machine_text_p
 	struct text_poke_param *p;
 	int i;
 
-	if (atomic_dec_and_test(&stop_machine_first)) {
+	if (atomic_xchg(&stop_machine_first, 0)) {
 		for (i = 0; i < tpp->nparams; i++) {
 			p = &tpp->params[i];
 			text_poke(p->addr, p->opcode, p->len);
_
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
