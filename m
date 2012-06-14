Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab2FNIlb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 04:41:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60718 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754773Ab2FNIl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 04:41:28 -0400
Date: Thu, 14 Jun 2012 01:41:06 -0700
From: tip-bot for OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Message-ID: <tip-2f74759056797054122cdc70844137f70bb3f626@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, rostedt@goodmis.org,
        hirofumi@mail.parknet.co.jp, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, a.p.zijlstra@chello.nl,
        hirofumi@mail.parknet.co.jp, tglx@linutronix.de
In-Reply-To: <87zk8fgsx9.fsf@devron.myhome.or.jp>
References: <87zk8fgsx9.fsf@devron.myhome.or.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86/alternatives: Use atomic_xchg()
  instead atomic_dec_and_test() for stop_machine_text_poke()
Git-Commit-ID: 2f74759056797054122cdc70844137f70bb3f626
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 14 Jun 2012 01:41:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2f74759056797054122cdc70844137f70bb3f626
Gitweb:     http://git.kernel.org/tip/2f74759056797054122cdc70844137f70bb3f626
Author:     OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
AuthorDate: Thu, 7 Jun 2012 22:20:18 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 13 Jun 2012 15:08:37 +0200

x86/alternatives: Use atomic_xchg() instead atomic_dec_and_test() for stop_machine_text_poke()

stop_machine_text_poke() uses atomic_dec_and_test() to select one of
the CPUs executing that function to actually modify the code.

Since the variable is initialized to 1, subsequent CPUs will make the
variable go negative. Since going negative is uncommon/unexpected in
typical dec_and_test usage change this user to atomic_xchg().

This was found using a patch that warns on dec_and_test going
negative.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
[ Rewrote changelog ]
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/87zk8fgsx9.fsf@devron.myhome.or.jp
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/alternative.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 1f84794..53231a0 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -664,7 +664,7 @@ static int __kprobes stop_machine_text_poke(void *data)
 	struct text_poke_param *p;
 	int i;
 
-	if (atomic_dec_and_test(&stop_machine_first)) {
+	if (atomic_xchg(&stop_machine_first, 0)) {
 		for (i = 0; i < tpp->nparams; i++) {
 			p = &tpp->params[i];
 			text_poke(p->addr, p->opcode, p->len);
