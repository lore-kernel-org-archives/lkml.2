Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab2E3Nez (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 09:34:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38369 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab2E3Nex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 09:34:53 -0400
Date: Wed, 30 May 2012 06:34:29 -0700
From: tip-bot for John Dykstra <jdykstra@cray.com>
Message-ID: <tip-fa83523f45fbb403eba4ebc5704bf98aa4da0163@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        jdykstra@cray.com, akpm@linux-foundation.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        jdykstra@cray.com, akpm@linux-foundation.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de
In-Reply-To: <1337980366.1979.6.camel@redwood>
References: <1337980366.1979.6.camel@redwood>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/mm/pat:
  Improve scaling of pat_pagerange_is_ram()
Git-Commit-ID: fa83523f45fbb403eba4ebc5704bf98aa4da0163
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 30 May 2012 06:34:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fa83523f45fbb403eba4ebc5704bf98aa4da0163
Gitweb:     http://git.kernel.org/tip/fa83523f45fbb403eba4ebc5704bf98aa4da0163
Author:     John Dykstra <jdykstra@cray.com>
AuthorDate: Fri, 25 May 2012 16:12:46 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 30 May 2012 10:57:11 +0200

x86/mm/pat: Improve scaling of pat_pagerange_is_ram()

Function pat_pagerange_is_ram() scales poorly to large address
ranges, because it probes the resource tree for each page.

On a 2.6 GHz Opteron, this function consumes 34 ms for a 1 GB range.

It is called twice during untrack_pfn_vma(), slowing process
cleanup and handicapping the OOM killer.

This replacement consumes less than 1ms, under the same conditions.

Signed-off-by: John Dykstra <jdykstra@cray.com> on behalf of Cray Inc.
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1337980366.1979.6.camel@redwood
[ Small stylistic cleanups and renames ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/mm/pat.c |   58 +++++++++++++++++++++++++++++++++-------------------
 1 files changed, 37 insertions(+), 21 deletions(-)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index f6ff57b..bea6e57 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -158,31 +158,47 @@ static unsigned long pat_x_mtrr_type(u64 start, u64 end, unsigned long req_type)
 	return req_type;
 }
 
+struct pagerange_state {
+	unsigned long		cur_pfn;
+	int			ram;
+	int			not_ram;
+};
+
+static int
+pagerange_is_ram_callback(unsigned long initial_pfn, unsigned long total_nr_pages, void *arg)
+{
+	struct pagerange_state *state = arg;
+
+	state->not_ram	|= initial_pfn > state->cur_pfn;
+	state->ram	|= total_nr_pages > 0;
+	state->cur_pfn	 = initial_pfn + total_nr_pages;
+
+	return state->ram && state->not_ram;
+}
+
 static int pat_pagerange_is_ram(resource_size_t start, resource_size_t end)
 {
-	int ram_page = 0, not_rampage = 0;
-	unsigned long page_nr;
+	int ret = 0;
+	unsigned long start_pfn = start >> PAGE_SHIFT;
+	unsigned long end_pfn = (end + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	struct pagerange_state state = {start_pfn, 0, 0};
 
-	for (page_nr = (start >> PAGE_SHIFT); page_nr < (end >> PAGE_SHIFT);
-	     ++page_nr) {
-		/*
-		 * For legacy reasons, physical address range in the legacy ISA
-		 * region is tracked as non-RAM. This will allow users of
-		 * /dev/mem to map portions of legacy ISA region, even when
-		 * some of those portions are listed(or not even listed) with
-		 * different e820 types(RAM/reserved/..)
-		 */
-		if (page_nr >= (ISA_END_ADDRESS >> PAGE_SHIFT) &&
-		    page_is_ram(page_nr))
-			ram_page = 1;
-		else
-			not_rampage = 1;
-
-		if (ram_page == not_rampage)
-			return -1;
+	/*
+	 * For legacy reasons, physical address range in the legacy ISA
+	 * region is tracked as non-RAM. This will allow users of
+	 * /dev/mem to map portions of legacy ISA region, even when
+	 * some of those portions are listed(or not even listed) with
+	 * different e820 types(RAM/reserved/..)
+	 */
+	if (start_pfn < ISA_END_ADDRESS >> PAGE_SHIFT)
+		start_pfn = ISA_END_ADDRESS >> PAGE_SHIFT;
+
+	if (start_pfn < end_pfn) {
+		ret = walk_system_ram_range(start_pfn, end_pfn - start_pfn,
+				&state, pagerange_is_ram_callback);
 	}
 
-	return ram_page;
+	return (ret > 0) ? -1 : (state.ram ? 1 : 0);
 }
 
 /*
