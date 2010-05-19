Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab0ESQr4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 12:47:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33478 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760Ab0ESQry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 12:47:54 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip v3 0/5] kprobes: batch (un)optimization support
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Jim Keniston <jkenisto@us.ibm.com>,
       Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Wed, 19 May 2010 12:53:05 -0400
Message-ID: <20100519165305.31828.15577.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is batch optimizing patch series version 3.

Since current kprobes jump optimization calls stop_machine() for each
probe, it can make a lot latency noise when (un)registering a lot of
probes (~1000) at once. For example, on 4 core Xeon, 256 probes
optimization takes 770us in average (max 3.3ms).
This patch series introduces batch (un)optimization which modifies
code with just one stop_machine(), and it improves optimization time
to 90us in average (max 330us).

- Introduce text_poke_smp_batch() which modifies multiple
  codes with one stop_machine().
- Limit how many probes can be (un)optimized at once.
- Introduce delayed unoptimization for batch processing.

text_poke_smp_batch() also helps Jason's Jump label to reduce
its overhead coming from text_poke_smp().

Changes in v3:
- Set kp.addr = NULL according to Ananth's comment.

Changes in v2:
- Add kprobes selftest bugfix patch.
- Add some comments about locks according to Mathieu's comment.
- Allocate working buffers when initializing kprobes, instead of
  using static arraies.
- Merge max optimization limit patch into batch optimizing patch.

Thank you,

---

Masami Hiramatsu (5):
      kprobes: Support delayed unoptimization
      kprobes/x86: Use text_poke_smp_batch
      x86: Introduce text_poke_smp_batch() for batch-code modifying
      [CLEANUP] kprobes: Remove redundant text_mutex lock in optimize
      [BUGFIX] kprobes: Fix selftest to clear flags field for reusing probes


 arch/x86/include/asm/alternative.h |    7 +
 arch/x86/include/asm/kprobes.h     |    4 
 arch/x86/kernel/alternative.c      |   49 +++-
 arch/x86/kernel/kprobes.c          |  114 +++++++++
 include/linux/kprobes.h            |    4 
 kernel/kprobes.c                   |  442 ++++++++++++++++++++++++------------
 kernel/test_kprobes.c              |   12 +
 7 files changed, 464 insertions(+), 168 deletions(-)

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
