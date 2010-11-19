Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab0KSKM7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 05:12:59 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:41232 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab0KSKM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 05:12:58 -0500
X-AuditID: b753bd60-a4d2fba000000226-b5-4ce64da765ea
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip v4 0/3] Kprobes/x86: Batch optimization support
To: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jason Baron <jbaron@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp
Date: Fri, 19 Nov 2010 19:09:25 +0900
Message-ID: <20101119100925.16882.34772.stgit@ltc236.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is batch optimizing patch series version 4.

Since current kprobes jump optimization calls stop_machine() for each
probe, it can make a lot of latency noises when (un)registering a lot of
probes (~1000) at once. For example, on 4 core Xeon, 256 probes
optimization takes 770us in average (max 3.3ms).
This patch series introduces batch (un)optimization which modifies
code with just one stop_machine(), and it improves optimization time
to 90us in average (max 330us).

- Introduce text_poke_smp_batch() which modifies multiple
  codes with one stop_machine().
- Limit how many probes can be (un)optimized at once.
- Introduce delayed unoptimization for batch processing.

text_poke_smp_batch() will also help Jump label to reduce
its delay coming from text_poke_smp().

Changes in v4:
- Update to the latest tip tree.

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

Masami Hiramatsu (3):
      kprobes: Support delayed unoptimization
      kprobes/x86: Use text_poke_smp_batch
      x86: Introduce text_poke_smp_batch() for batch-code modifying


 arch/x86/include/asm/alternative.h |    7 +
 arch/x86/include/asm/kprobes.h     |    4 
 arch/x86/kernel/alternative.c      |   49 +++-
 arch/x86/kernel/kprobes.c          |  114 +++++++++
 include/linux/kprobes.h            |    4 
 kernel/kprobes.c                   |  435 ++++++++++++++++++++++++------------
 6 files changed, 451 insertions(+), 162 deletions(-)

-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com

