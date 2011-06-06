Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab1FFOOb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 10:14:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58612 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878Ab1FFOO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 10:14:28 -0400
X-Authority-Analysis: v=1.1 cv=PfPQ8rIoTcZsncbPZjVSZ7K0hy8Zc4hmL68r4VPNpKE= c=1 sm=0 a=P0wiPLkiFm4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=pwlSjyV6AAAA:8 a=1cMp6Op0AAAA:8 a=meVymXHHAAAA:8 a=2jae4u39aCl_ZFJcGxYA:9 a=zxvwelWCyM8pzevIDNYA:7 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=_1CdXZwv0MQA:10 a=PBs7KpRtM0kA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [PATCH][GIT PULL] slob/lockdep: Fix gfp flags passed to lockdep
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Matt Mackall <mpm@selenic.com>,
        Paul Mundt <lethal@linux-sh.org>, Nick Piggin <npiggin@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 06 Jun 2011 10:14:25 -0400
Message-ID: <1307369665.31814.20.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/lockdep/devel tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/lockdep/devel


Steven Rostedt (1):
      slob/lockdep: Fix gfp flags passed to lockdep

----
 mm/slob.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)
---------------------------
commit 38787df146ddd0c5f06127936e2351cae6b46a1f
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Fri Jun 3 12:11:13 2011 -0400

    slob/lockdep: Fix gfp flags passed to lockdep
    
    Doing a ktest.pl randconfig, I stumbled across the following bug
    on boot up:
    
    ------------[ cut here ]------------
    WARNING: at /home/rostedt/work/autotest/nobackup/linux-test.git/kernel/lockdep.c:2649 lockdep_trace_alloc+0xed/0x100()
    Hardware name:
    Modules linked in:
    Pid: 0, comm: swapper Not tainted 3.0.0-rc1-test-00054-g1d68b67 #1
    Call Trace:
     [<ffffffff810626ad>] warn_slowpath_common+0xad/0xf0
     [<ffffffff8106270a>] warn_slowpath_null+0x1a/0x20
     [<ffffffff810b537d>] lockdep_trace_alloc+0xed/0x100
     [<ffffffff81182fb0>] __kmalloc_node+0x30/0x2f0
     [<ffffffff81153eda>] pcpu_mem_alloc+0x13a/0x180
     [<ffffffff82be022c>] percpu_init_late+0x48/0xc2
     [<ffffffff82bd630c>] ? mem_init+0xd8/0xe3
     [<ffffffff82bbcc73>] start_kernel+0x1c2/0x449
     [<ffffffff82bbc35c>] x86_64_start_reservations+0x163/0x167
     [<ffffffff82bbc493>] x86_64_start_kernel+0x133/0x142^M
    ---[ end trace a7919e7f17c0a725 ]---
    
    Then I ran a ktest.pl config_bisect and it came up with this config
    as the problem:
    
      CONFIG_SLOB
    
    Looking at what is different between SLOB and SLAB and SLUB, I found
    that the gfp flags are masked against gfp_allowed_mask in
    SLAB and SLUB, but not SLOB.
    
    On boot up, interrupts are disabled and lockdep will warn if some flags
    are set in gfp and interrupts are disabled. But these flags are masked
    off with the gfp_allowed_mask during boot. Because SLOB does not
    mask the flags against gfp_allowed_mask it triggers the warn on.
    
    Adding this mask fixes the bug. I also found that kmem_cache_alloc_node()
    was missing both the mask and the lockdep check, and that was added too.
    
    Cc: Matt Mackall <mpm@selenic.com>
    Cc: Paul Mundt <lethal@linux-sh.org>
    Cc: Nick Piggin <npiggin@kernel.dk>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/mm/slob.c b/mm/slob.c
index 46e0aee..0ae8818 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -482,6 +482,8 @@ void *__kmalloc_node(size_t size, gfp_t gfp, int node)
 	int align = max(ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);
 	void *ret;
 
+	gfp &= gfp_allowed_mask;
+
 	lockdep_trace_alloc(gfp);
 
 	if (size < PAGE_SIZE - align) {
@@ -608,6 +610,10 @@ void *kmem_cache_alloc_node(struct kmem_cache *c, gfp_t flags, int node)
 {
 	void *b;
 
+	flags &= gfp_allowed_mask;
+
+	lockdep_trace_alloc(flags);
+
 	if (c->size < PAGE_SIZE) {
 		b = slob_alloc(c->size, flags, c->align, node);
 		trace_kmem_cache_alloc_node(_RET_IP_, b, c->size,


