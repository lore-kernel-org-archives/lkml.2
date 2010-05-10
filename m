Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab0EJRtB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 13:49:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753889Ab0EJRsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 13:48:52 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 0/5] kprobes: batch (un)optimization support
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Jim Keniston <jkenisto@us.ibm.com>,
       Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Mon, 10 May 2010 13:53:13 -0400
Message-ID: <20100510175313.27396.34605.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Since current kprobes jump optimization calls stop_machine() for each
probe, it will almost freeze machine when registering a lot of probes
(~1000) at once.
For avoiding this issue, this patch series enhances kprobes and
text_poke.

- Introduces text_poke_smp_batch() which modifies multiple codes
  with one stop_machine().
- Limits how many probes can be optimized at once.
- Introduce delayed unoptimization for batch processing.

text_poke_smp_batch() also helps Jason's Jump label to reduce
its overhead coming from text_poke_smp().

Currently, this patch allocates working memory static, however,
it is possible to allocate dynamically, because its not in
a critical section. it will be done by the next step, or next version.

Thank you,

---

Masami Hiramatsu (5):
      kprobes: Support delayed unoptimization
      kprobes/x86: Use text_poke_smp_batch
      x86: Introduce text_poke_smp_batch() for batch-code modifying
      kprobes: Limit maximum number of optimization at once
      [CLEANUP] kprobes: Remove redundant text_mutex lock in optimize


 arch/x86/include/asm/alternative.h |    7 +
 arch/x86/include/asm/kprobes.h     |    4 
 arch/x86/kernel/alternative.c      |   49 +++-
 arch/x86/kernel/kprobes.c          |   78 ++++++
 include/linux/kprobes.h            |    4 
 kernel/kprobes.c                   |  437 ++++++++++++++++++++++++------------
 6 files changed, 416 insertions(+), 163 deletions(-)

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
