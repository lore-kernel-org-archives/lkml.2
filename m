Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662Ab2JSFrA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 01:47:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:37401 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752100Ab2JSFqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 01:46:36 -0400
X-IronPort-AV: E=Sophos;i="4.80,611,1344182400"; 
   d="scan'208";a="6028349"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: stable@vger.kernel.org, tony.luck@intel.com, bp@amd64.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        miaox@cn.fujitsu.com, laijs@cn.fujitsu.com, wency@cn.fujitsu.com,
        x86@kernel.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] Replace if statement with WARN_ON_ONCE() in cmci_rediscover().
Date: Fri, 19 Oct 2012 13:45:27 +0800
Message-Id: <1350625528-1385-2-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1350625528-1385-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1350625528-1385-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/19 13:46:09,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/19 13:46:10,
	Serialize complete at 2012/10/19 13:46:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cmci_rediscover() is only called by the CPU_POST_DEAD event handler,
which means the corresponding cpu has already dead. As a result, it
won't be accessed in the for_each_online_cpu loop.
So, we could change the if(cpu == dying) statement into a WARN_ON_ONCE().

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/mce_intel.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
index 38e49bc..481d152 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -180,8 +180,8 @@ void cmci_rediscover(int dying)
 	cpumask_copy(old, &current->cpus_allowed);
 
 	for_each_online_cpu(cpu) {
-		if (cpu == dying)
-			continue;
+		WARN_ON_ONCE(cpu == dying);
+
 		if (set_cpus_allowed_ptr(current, cpumask_of(cpu)))
 			continue;
 		/* Recheck banks in case CPUs don't all have the same */
-- 
1.7.1

