Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552Ab2BQA7c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 19:59:32 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:40043 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756493Ab2BQA72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 19:59:28 -0500
X-Sasl-enc: auHbdFsWIAr3Nmijpd0lqG+81qORGgQG0Jtd3eQNVYKX 1329440367
X-Mailbox-Line: From gregkh@linuxfoundation.org Thu Feb 16 16:55:10 2012
Message-Id: <20120217005510.084150159@linuxfoundation.org>
User-Agent: quilt/0.51-15.1
Date: Thu, 16 Feb 2012 16:55:11 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Clark Williams <williams@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [02/15] perf tools: Fix perf stack to non executable on x86_64
In-Reply-To: <20120217005650.GA17119@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@redhat.com>

commit 7a0153ee15575a4d07b5da8c96b79e0b0fd41a12 upstream.

By adding following objects:
  bench/mem-memcpy-x86-64-asm.o
the x86_64 perf binary ended up with executable stack.

The reason was that above object are assembler sourced and is missing the
GNU-stack note section. In such case the linker assumes that the final binary
should not be restricted at all and mark the stack as RWX.

Adding section ".note.GNU-stack" definition to mentioned object, with all
flags disabled, thus omiting this object from linker stack flags decision.

Problem introduced in:

  $ git describe ea7872b
  v2.6.37-rc2-19-gea7872b

Reported-at: https://bugzilla.redhat.com/show_bug.cgi?id=783570
Reported-by: Clark Williams <williams@redhat.com>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1328100848-5630-1-git-send-email-jolsa@redhat.com
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
[ committer note: Backported fix to perf/urgent (3.3-rc2+) ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/bench/mem-memcpy-x86-64-asm.S |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/tools/perf/bench/mem-memcpy-x86-64-asm.S
+++ b/tools/perf/bench/mem-memcpy-x86-64-asm.S
@@ -1,2 +1,8 @@
 
 #include "../../../arch/x86/lib/memcpy_64.S"
+/*
+ * We need to provide note.GNU-stack section, saying that we want
+ * NOT executable stack. Otherwise the final linking will assume that
+ * the ELF stack should not be restricted at all and set it RWX.
+ */
+.section .note.GNU-stack,"",@progbits


