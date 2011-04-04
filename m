Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095Ab1DDQEh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 12:04:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:36567 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755047Ab1DDQEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 12:04:36 -0400
Date: Mon, 4 Apr 2011 16:03:59 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, gorcunov@gmail.com, tj@kernel.org,
        tglx@linutronix.de, rientjes@google.com, hpa@linux.intel.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, gorcunov@gmail.com, tj@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, rientjes@google.com,
        mingo@elte.hu
In-Reply-To: <20110404100645.GE1420@mtj.dyndns.org>
References: <20110404100645.GE1420@mtj.dyndns.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86-32, NUMA: Fix ACPI NUMA init broken by recent x86-64 change
Message-ID: <tip-765af22da8a61bd44d354b3c3be955c332325b2f@git.kernel.org>
Git-Commit-ID: 765af22da8a61bd44d354b3c3be955c332325b2f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 04 Apr 2011 16:04:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  765af22da8a61bd44d354b3c3be955c332325b2f
Gitweb:     http://git.kernel.org/tip/765af22da8a61bd44d354b3c3be955c332325b2f
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Mon, 4 Apr 2011 03:06:45 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 4 Apr 2011 16:56:33 +0200

x86-32, NUMA: Fix ACPI NUMA init broken by recent x86-64 change

Commit d8fc3afc49 (x86, NUMA: Move *_numa_init() invocations
into initmem_init()) moved acpi_numa_init() call into NUMA
initmem_init() but forgot to update 32bit NUMA init breaking ACPI
NUMA configuration for 32bit.

acpi_numa_init() call was later moved again to srat_64.c.  Match
it by adding the call to get_memcfg_from_srat() in srat_32.c.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: H. Peter Anvin <hpa@linux.intel.com>
LKML-Reference: <20110404100645.GE1420@mtj.dyndns.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/srat_32.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/srat_32.c b/arch/x86/mm/srat_32.c
index 48651c6..364f36b 100644
--- a/arch/x86/mm/srat_32.c
+++ b/arch/x86/mm/srat_32.c
@@ -211,10 +211,12 @@ int __init get_memcfg_from_srat(void)
 {
 	int i, j, nid;
 
-
 	if (srat_disabled())
 		goto out_fail;
 
+	if (acpi_numa_init() < 0)
+		goto out_fail;
+
 	if (num_memory_chunks == 0) {
 		printk(KERN_DEBUG
 			 "could not find any ACPI SRAT memory areas.\n");
