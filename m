Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab0HCHWN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 03:22:13 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49147 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362Ab0HCHWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 03:22:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=DZNA3oLayAAmoD1lxddI81b7Yxakl7LZevsmkjh93YYoRPZrKVaslsg6j5N/KBnjPV
         WjFUpAY4Kgf3Fzzk0nA8A8p13NgMsQSZZxal60vIEeIgamXF8Z/YipwvK+yX/sy2Ck/H
         W2m2Tq5CCvkZcLmMciIbE3BnyhA7eyv0ctoNo=
MIME-Version: 1.0
From: Hui Zhu <teawater@gmail.com>
Date: Tue, 3 Aug 2010 15:21:49 +0800
Message-ID: <AANLkTikuUi=i6Lk-ZpE65Gr0tWOeVnrnpWPe85T=J=Ph@mail.gmail.com>
Subject: [PATCH] kexec: set prstatus.pr_pid to cpu id when current->pid is 0
To: Eric Biederman <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Simon Kagstrom <simon.kagstrom@netinsight.net>,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I found that from gdb 7.1 to gdb-cvs-head cannot analyze the core file
that get from kdump.
What I got:
[New <main task>]
[New Thread 2719]
../../src/gdb/thread.c:884: internal-error: switch_to_thread:
Assertion `inf != NULL' failed.
A problem internal to GDB has been detected,
further debugging may prove unreliable.
Quit this debugging session? (y or n)
That is because:
 objdump -h ./vmcore

./vmcore:     file format elf64-x86-64

Sections:
Idx Name          Size      VMA               LMA               File off  Algn
  0 note0         00000a48  0000000000000000  0000000000000000  00000238  2**0
                  CONTENTS, READONLY
  1 .reg/0        000000d8  0000000000000000  0000000000000000  000002bc  2**2
                  CONTENTS
  2 .reg          000000d8  0000000000000000  0000000000000000  000002bc  2**2
                  CONTENTS
  3 .reg/2719     000000d8  0000000000000000  0000000000000000  00000420  2**2
                  CONTENTS
  4 .reg/0        000000d8  0000000000000000  0000000000000000  00000584  2**2
                  CONTENTS
  5 .reg/0        000000d8  0000000000000000  0000000000000000  000006e8  2**2
                  CONTENTS
Each of reg/n is a cpu core note.  It will be a GDB thread.  n is the
prstatus.pr_pid that will be the thread lwpid.  Because the 3 threads
pid is same, so GDB get error.

current->pid is 0 because this cpu is in idle.  So I add a check, set
prstatus.pr_pid to cpu id when current->pid is 0.  Then GDB work OK
with the core.

Thanks,
Hui

Signed-off-by: Hui Zhu <teawater@gmail.com>
---
 kernel/kexec.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1191,7 +1191,10 @@ void crash_save_cpu(struct pt_regs *regs
 	if (!buf)
 		return;
 	memset(&prstatus, 0, sizeof(prstatus));
-	prstatus.pr_pid = current->pid;
+	if (current->pid)
+		prstatus.pr_pid = current->pid;
+	else
+		prstatus.pr_pid = cpu;
 	elf_core_copy_kernel_regs(&prstatus.pr_reg, regs);
 	buf = append_elf_note(buf, KEXEC_CORE_NOTE_NAME, NT_PRSTATUS,
 		      	      &prstatus, sizeof(prstatus));
