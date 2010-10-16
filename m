Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945Ab0JPExm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 00:53:42 -0400
Received: from smtp-out.google.com ([216.239.44.51]:55921 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab0JPExk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 00:53:40 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
	b=D5CpHG6dzPJ15MFldSZsUaQ5m6IoJPZmAWaEIep9xIuU18XDz9ANyCWLyXtevFmu5
	LdaL01j9mULotMia/DOSg==
Message-Id: <20101016045119.357629631@google.com>
References: <20101016044349.830426011@google.com>
User-Agent: quilt/0.46-1
Date: Fri, 15 Oct 2010 21:44:01 -0700
From: pjt@google.com
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Chris Friesen <cfriesen@nortel.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Pierre Bourdon <pbourdon@excellency.fr>, Paul Turner <pjt@google.com>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: [RFC tg_shares_up improvements - v1 12/12] debug: export effective shares for analysis versus specified
Content-Disposition: inline; filename=sched-tg-debug-add_issued_shares.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 kernel/sched.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

Index: kernel/sched.c
===================================================================
--- kernel/sched.c.orig
+++ kernel/sched.c
@@ -8607,6 +8607,21 @@ static u64 cpu_shares_read_u64(struct cg
 
 	return (u64) tg->shares;
 }
+
+static u64 cpu_issued_shares_read_u64(struct cgroup *cgrp, struct cftype *cft)
+{
+	struct task_group *tg = cgroup_tg(cgrp);
+	u64 result = 0;
+	int i;
+
+	if (!tg->se[0])
+		return 0;
+
+	for_each_online_cpu(i)
+		result += tg->se[i]->load.weight;
+
+	return result;
+}
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
 #ifdef CONFIG_RT_GROUP_SCHED
@@ -8640,6 +8655,10 @@ static struct cftype cpu_files[] = {
 		.read_u64 = cpu_shares_read_u64,
 		.write_u64 = cpu_shares_write_u64,
 	},
+	{
+		.name = "issued_shares",
+		.read_u64 = cpu_issued_shares_read_u64,
+	},
 #endif
 #ifdef CONFIG_RT_GROUP_SCHED
 	{

-- 

