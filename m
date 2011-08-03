Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534Ab1HCS2g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 14:28:36 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:40452 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052Ab1HCS2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 14:28:31 -0400
Date: Wed, 3 Aug 2011 22:28:26 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        Oleg Nesterov <oleg@redhat.com>, Richard Weinberger <richard@nod.at>,
        Marc Zyngier <marc.zyngier@arm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] shm: optimize exit_shm()
Message-ID: <20110803182826.GB2865@albatros>
References: <20110803140456.GA14393@redhat.com>
 <20110803182417.GA2510@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110803182417.GA2510@albatros>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We may check .in_use == 0 without holding the rw_mutex as .in_use is int
and reads of ints are atomic.  As .in_use may be changed to zero while current
process was sleeping in down_write(), we should check .in_use once again after
down_write().

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 ipc/shm.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/ipc/shm.c b/ipc/shm.c
index 4e3c883..855ddc0 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -304,6 +304,9 @@ void exit_shm(struct task_struct *task)
 {
 	struct ipc_namespace *ns = task->nsproxy->ipc_ns;
 
+	if (shm_ids(ns).in_use == 0)
+		return;
+
 	/* Destroy all already created segments, but not mapped yet */
 	down_write(&shm_ids(ns).rw_mutex);
 	if (shm_ids(ns).in_use)
-- 
1.7.0.4

