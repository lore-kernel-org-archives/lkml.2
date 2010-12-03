Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758438Ab0LCJ5X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 04:57:23 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:41711 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756615Ab0LCJ5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 04:57:21 -0500
X-AuditID: b753bd60-a430fba00000392d-73-4cf8befe6ecd
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip v5 0/8] Kprobes/x86: Batch optimization support
To: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jason Baron <jbaron@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp
Date: Fri, 03 Dec 2010 18:53:25 +0900
Message-ID: <20101203095325.2961.75137.stgit@ltc236.sdl.hitachi.co.jp>
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

Here is batch (un)optimizing patch series version 5.
Ingo, I've splitted the biggest patch into 6 patches.

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

Changes in v5:
- Split delayed unregistering patch into 3 cleanup patches
  and 3 feature-adding patches.
- Add comments to explain code.
- Fix missing of text_mutex locks.

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

Masami Hiramatsu (8):
      kprobes: Use text_poke_smp_batch for unoptimizing
      kprobes: Use text_poke_smp_batch for optimizing
      x86: Introduce text_poke_smp_batch() for batch-code modifying
      kprobes: Reuse unused kprobe
      kprobes: Support delayed unoptimizing
      [CLEANUP]kprobes: Separate kprobe optimizing code from optimizer
      [CLEANUP]kprobes: Cleanup disabling and unregistering path
      [CLEANUP] kprobes: Rename old_p to more appropriate name


 arch/x86/include/asm/alternative.h |    7 
 arch/x86/kernel/alternative.c      |   49 +++
 arch/x86/kernel/kprobes.c          |  113 +++++++
 include/linux/kprobes.h            |    4 
 kernel/kprobes.c                   |  565 ++++++++++++++++++++++++------------
 5 files changed, 539 insertions(+), 199 deletions(-)

-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com

