Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382Ab0JFOXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 10:23:30 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:46770 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932216Ab0JFOX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 10:23:29 -0400
Date: Wed, 6 Oct 2010 19:53:14 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        containers@lists.linux-foundation.org
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [RFC] Restrict size of page_cgroup->flags
Message-ID: <20101006142314.GG4195@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I propose restricting page_cgroup.flags to 16 bits. The patch for the
same is below. Comments?


Restrict the bits usage in page_cgroup.flags

From: Balbir Singh <balbir@linux.vnet.ibm.com>

Restricting the flags helps control growth of the flags unbound.
Restriciting it to 16 bits gives us the possibility of merging
cgroup id with flags (atomicity permitting) and saving a whole
long word in page_cgroup

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 include/linux/page_cgroup.h |    3 +++
 mm/page_cgroup.c            |    1 +
 2 files changed, 4 insertions(+), 0 deletions(-)


diff --git a/include/linux/page_cgroup.h b/include/linux/page_cgroup.h
index 872f6b1..10c37b4 100644
--- a/include/linux/page_cgroup.h
+++ b/include/linux/page_cgroup.h
@@ -44,8 +44,11 @@ enum {
 	PCG_FILE_WRITEBACK, /* page is under writeback */
 	PCG_FILE_UNSTABLE_NFS, /* page is NFS unstable */
 	PCG_MIGRATION, /* under page migration */
+	PCG_MAX_NR,
 };
 
+#define PCG_MAX_BIT_SIZE	16
+
 #define TESTPCGFLAG(uname, lname)			\
 static inline int PageCgroup##uname(struct page_cgroup *pc)	\
 	{ return test_bit(PCG_##lname, &pc->flags); }
diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
index 5bffada..e16ad2e 100644
--- a/mm/page_cgroup.c
+++ b/mm/page_cgroup.c
@@ -258,6 +258,7 @@ void __init page_cgroup_init(void)
 	unsigned long pfn;
 	int fail = 0;
 
+	BUILD_BUG_ON(PCG_MAX_NR >= PCG_MAX_BIT_SIZE);
 	if (mem_cgroup_disabled())
 		return;
 

-- 
	Three Cheers,
	Balbir
