Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432Ab2EWETX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 00:19:23 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:53183 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab2EWETW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 00:19:22 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Masami Hiramatsu <mhiramat@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Use test_and_clear_bit() instead atomic_dec_and_test() for stop_machine
References: <87likkt7u6.fsf@devron.myhome.or.jp>
	<87ehqct7a3.fsf@devron.myhome.or.jp>
	<20120522214633.GB30024@home.goodmis.org>
	<87aa0zty4r.fsf@devron.myhome.or.jp>
Date: Wed, 23 May 2012 13:19:14 +0900
In-Reply-To: <87aa0zty4r.fsf@devron.myhome.or.jp> (OGAWA Hirofumi's message of
	"Wed, 23 May 2012 11:44:04 +0900")
Message-ID: <87mx4zr0l9.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:

>> The down side to this is that it adds 4 more bytes on a 64bit
>> machine. (sizeof(unsigned log) == 8 and sizeof(atomic_t) == 4)

Another patch without additional 4bytes. This simply change
atomic_dec_and_test() to atomic_xchg().

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>


stop_machine_first is just to see if it is first one or not.  In this
usage, atomic_dec_and_test() makes value less than 0.

I think it is not desirable, because it only triggers
atomic_dec_and_test() less than 0 debug patch. (the patch tests result
of atomic_dec_and_test() is < 0)

So, this uses atomic_xchg() instead.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
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
