Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab2FRIyt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 04:54:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40464 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab2FRIyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 04:54:47 -0400
Date: Mon, 18 Jun 2012 01:54:27 -0700
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Message-ID: <tip-7a5bfb66b07f22d2429db776da7bb8b57bfb5cff@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, ananth@in.ibm.com, anton@redhat.com,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de, oleg@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, ananth@in.ibm.com, anton@redhat.com,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20120615154336.GA9588@redhat.com>
References: <20120615154336.GA9588@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] uprobes: Change build_map_info() to try kmalloc(
 GFP_NOWAIT) first
Git-Commit-ID: 7a5bfb66b07f22d2429db776da7bb8b57bfb5cff
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 18 Jun 2012 01:54:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7a5bfb66b07f22d2429db776da7bb8b57bfb5cff
Gitweb:     http://git.kernel.org/tip/7a5bfb66b07f22d2429db776da7bb8b57bfb5cff
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Fri, 15 Jun 2012 17:43:36 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 16 Jun 2012 09:10:44 +0200

uprobes: Change build_map_info() to try kmalloc(GFP_NOWAIT) first

build_map_info() doesn't allocate the memory under i_mmap_mutex
to avoid the deadlock with page reclaim. But it can try
GFP_NOWAIT first, it should work in the likely case and thus we
almost never need the pre-alloc-and-retry path.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anton Arapov <anton@redhat.com>
Link: http://lkml.kernel.org/r/20120615154336.GA9588@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/uprobes.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 4e0db34..897417d 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -761,6 +761,16 @@ build_map_info(struct address_space *mapping, loff_t offset, bool is_register)
 		if (!valid_vma(vma, is_register))
 			continue;
 
+		if (!prev && !more) {
+			/*
+			 * Needs GFP_NOWAIT to avoid i_mmap_mutex recursion through
+			 * reclaim. This is optimistic, no harm done if it fails.
+			 */
+			prev = kmalloc(sizeof(struct map_info),
+					GFP_NOWAIT | __GFP_NOMEMALLOC | __GFP_NOWARN);
+			if (prev)
+				prev->next = NULL;
+		}
 		if (!prev) {
 			more++;
 			continue;
