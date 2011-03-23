Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933083Ab1CWPU0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 11:20:26 -0400
Received: from mout.perfora.net ([74.208.4.194]:53205 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933031Ab1CWPUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 11:20:23 -0400
From: Stephen Wilson <wilsons@start.ca>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Michel Lespinasse <walken@google.com>, Andi Kleen <ak@linux.intel.com>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Matt Mackall <mpm@selenic.com>, David Rientjes <rientjes@google.com>,
        Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Stephen Wilson <wilsons@start.ca>
Subject: [PATCH v2 resend 08/12] mm: implement access_remote_vm
Date: Wed, 23 Mar 2011 10:43:57 -0400
Message-Id: <1300891441-16280-9-git-send-email-wilsons@start.ca>
X-Mailer: git-send-email 1.7.3.5
In-Reply-To: <1300891441-16280-1-git-send-email-wilsons@start.ca>
References: <1300891441-16280-1-git-send-email-wilsons@start.ca>
X-Provags-ID: V02:K0:GxY913RmnpaGabQgVrNcBo+6ZS+ITYtb0+Vx8/DttqQ
 Nu3TpgStasCU2WtA52xQY0gK0Vj1HrdQsSSj2ZN94763A9OCH6
 otwJeohNGysMr/rdFyVLiPXYTqt637IWcPw9ehOIfFoCmpvyTB
 gqJlyETQy4gOfA2E5ImxLzpuXgQFsgIGxhuhEKnkQq276yX+cw
 uxmvnJZf8IpIV/AEb/M7tjD5DWWuB91af/ENgCU9Bw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide an alternative to access_process_vm that allows the caller to obtain a
reference to the supplied mm_struct.

Signed-off-by: Stephen Wilson <wilsons@start.ca>
---
 include/linux/mm.h |    2 ++
 mm/memory.c        |   16 ++++++++++++++++
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 694512d..e5fde8a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -964,6 +964,8 @@ static inline int handle_mm_fault(struct mm_struct *mm,
 
 extern int make_pages_present(unsigned long addr, unsigned long end);
 extern int access_process_vm(struct task_struct *tsk, unsigned long addr, void *buf, int len, int write);
+extern int access_remote_vm(struct mm_struct *mm, unsigned long addr,
+		void *buf, int len, int write);
 
 int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 			unsigned long start, int nr_pages, int write, int force,
diff --git a/mm/memory.c b/mm/memory.c
index 68eec4f..c26e4f9 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3654,6 +3654,22 @@ static int __access_remote_vm(struct task_struct *tsk, struct mm_struct *mm,
 	return buf - old_buf;
 }
 
+/**
+ * @access_remote_vm - access another process' address space
+ * @mm:		the mm_struct of the target address space
+ * @addr:	start address to access
+ * @buf:	source or destination buffer
+ * @len:	number of bytes to transfer
+ * @write:	whether the access is a write
+ *
+ * The caller must hold a reference on @mm.
+ */
+int access_remote_vm(struct mm_struct *mm, unsigned long addr,
+		void *buf, int len, int write)
+{
+	return __access_remote_vm(NULL, mm, addr, buf, len, write);
+}
+
 /*
  * Access another process' address space.
  * Source/target buffer must be kernel space,
-- 
1.7.3.5

