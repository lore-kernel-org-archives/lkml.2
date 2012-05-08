Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab2EHEY0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 00:24:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51305 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab2EHEYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 00:24:25 -0400
Date: Mon, 7 May 2012 21:24:06 -0700
From: tip-bot for Shai Fultheim <shai@scalemp.com>
Message-ID: <tip-ddc5681ed33a279fdc188e98e71f0c539f08c6e6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        travis@sgi.com, andreas.herrmann3@amd.com, davej@redhat.com,
        shai@scalemp.com, tglx@linutronix.de, ido@wizery.com,
        borislav.petkov@amd.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andreas.herrmann3@amd.com, travis@sgi.com, davej@redhat.com,
        shai@scalemp.com, ido@wizery.com, tglx@linutronix.de,
        borislav.petkov@amd.com
In-Reply-To: <1334873351-31142-1-git-send-email-ido@wizery.com>
References: <1334873351-31142-1-git-send-email-ido@wizery.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86/cache_info: Fix setup of l2/l3 ids
Git-Commit-ID: ddc5681ed33a279fdc188e98e71f0c539f08c6e6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 07 May 2012 21:24:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ddc5681ed33a279fdc188e98e71f0c539f08c6e6
Gitweb:     http://git.kernel.org/tip/ddc5681ed33a279fdc188e98e71f0c539f08c6e6
Author:     Shai Fultheim <shai@scalemp.com>
AuthorDate: Fri, 20 Apr 2012 01:09:11 +0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 7 May 2012 15:27:37 +0200

x86/cache_info: Fix setup of l2/l3 ids

On some architectures (such as vSMP), it is possible to have
CPUs with a different number of cores sharing the same cache.

The current implementation implicitly assumes that all CPUs will
have the same number of cores sharing caches, and as a result,
different CPUs can end up with the same l2/l3 ids.

Fix this by masking out the shared cache bits, instead of
shifting the APICID. By doing so, it is guaranteed that the
generated cache ids are always unique.

Signed-off-by: Shai Fultheim <shai@scalemp.com>
[ rebased, simplified, and reworded the commit message]
Signed-off-by: Ido Yariv <ido@wizery.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Mike Travis <travis@sgi.com>
Cc: Dave Jones <davej@redhat.com>
Link: http://lkml.kernel.org/r/1334873351-31142-1-git-send-email-ido@wizery.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index b8f3653..9a7c90d 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -615,14 +615,14 @@ unsigned int __cpuinit init_intel_cacheinfo(struct cpuinfo_x86 *c)
 					new_l2 = this_leaf.size/1024;
 					num_threads_sharing = 1 + this_leaf.eax.split.num_threads_sharing;
 					index_msb = get_count_order(num_threads_sharing);
-					l2_id = c->apicid >> index_msb;
+					l2_id = c->apicid & ~((1 << index_msb) - 1);
 					break;
 				case 3:
 					new_l3 = this_leaf.size/1024;
 					num_threads_sharing = 1 + this_leaf.eax.split.num_threads_sharing;
 					index_msb = get_count_order(
 							num_threads_sharing);
-					l3_id = c->apicid >> index_msb;
+					l3_id = c->apicid & ~((1 << index_msb) - 1);
 					break;
 				default:
 					break;
