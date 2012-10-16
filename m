Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab2JPGZp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 02:25:45 -0400
Received: from gateway.alibaba-inc.com ([121.0.29.147]:22436 "EHLO
	CNHZ-ExGW-02.ali.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753671Ab2JPGZn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 02:25:43 -0400
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Oct 2012 02:25:42 EDT
X-AuditID: 0a14034d-b7c51ae000000ab9-a5-507cfa5ef4ff
From: Sha Zhengju <handai.szj@taobao.com>
To: <linux-mm@kvack.org>, <cgroups@vger.kernel.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, <akpm@linux-foundation.org>,
        <mhocko@suse.cz>
CC: <linux-kernel@vger.kernel.org>, Sha Zhengju <handai.szj@taobao.com>
Subject: [PATCH] oom, memcg: handle sysctl oom_kill_allocating_task while memcg oom happening
Date: Tue, 16 Oct 2012 14:10:37 +0800
Message-ID: <1350367837-27919-1-git-send-email-handai.szj@taobao.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.20.8.3]
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sha Zhengju <handai.szj@taobao.com>

Sysctl oom_kill_allocating_task enables or disables killing the OOM-triggering
task in out-of-memory situations, but it only works on overall system-wide oom.
But it's also a useful indication in memcg so we take it into consideration
while oom happening in memcg. Other sysctl such as panic_on_oom has already
been memcg-ware.


Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
---
 mm/oom_kill.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 38129e3..2a176af 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -574,6 +574,18 @@ void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask)
        check_panic_on_oom(CONSTRAINT_MEMCG, gfp_mask, 0, NULL);
        limit = mem_cgroup_get_limit(memcg) >> PAGE_SHIFT;
        read_lock(&tasklist_lock);
+       if (sysctl_oom_kill_allocating_task &&
+           !oom_unkillable_task(current, memcg, NULL) &&
+           current->mm) {
+               /*
+                * oom_kill_process() needs tasklist_lock held.  If it returns
+                * non-zero, current could not be killed so we must fallback to
+                * the tasklist scan.
+                */
+               if (!oom_kill_process(current, gfp_mask, 0, 0, limit, memcg, NULL,
+                               "Memory cgroup out of memory (oom_kill_allocating_task)"))
+                       goto out;
+       }
 retry:
        p = select_bad_process(&points, limit, memcg, NULL);
        if (!p || PTR_ERR(p) == -1UL)
--
1.7.6.1


________________________________

This email (including any attachments) is confidential and may be legally privileged. If you received this email in error, please delete it immediately and do not copy it or use it for any purpose or disclose its contents to any other person. Thank you.

本电邮(包括任何附件)可能含有机密资料并受法律保护。如您不是正确的收件人，请您立即删除本邮件。请不要将本电邮进行复制并用作任何其他用途、或透露本邮件之内容。谢谢。
