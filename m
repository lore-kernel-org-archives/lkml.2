Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384Ab0DBTyX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 15:54:23 -0400
Received: from smtp-out.google.com ([216.239.44.51]:15840 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783Ab0DBTyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 15:54:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=LpW82mGPCVgkaxEhfXbxeQzvv6IX51CnwrOB78O252tVLv316MMTUWA+t+VBcaAw7
	a5GYAZZYaiKM0/Z5uPOyQ==
Date: Fri, 2 Apr 2010 12:54:10 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
cc: anfei <anfei.zhou@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       nishimura@mxp.nes.nec.co.jp,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: [patch -mm] oom: exclude tasks with badness score of 0 from being
 selected
In-Reply-To: <alpine.DEB.2.00.1004021244010.15445@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1004021253480.18402@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1003291302170.14859@chino.kir.corp.google.com> <20100330154659.GA12416@redhat.com> <alpine.DEB.2.00.1003301320020.5234@chino.kir.corp.google.com> <20100331175836.GA11635@redhat.com> <20100331204718.GD11635@redhat.com>
 <alpine.DEB.2.00.1004010133190.6285@chino.kir.corp.google.com> <20100401135927.GA12460@redhat.com> <alpine.DEB.2.00.1004011210380.30661@chino.kir.corp.google.com> <20100402111406.GA4432@redhat.com> <alpine.DEB.2.00.1004021159310.1773@chino.kir.corp.google.com>
 <20100402191414.GA982@redhat.com> <alpine.DEB.2.00.1004021244010.15445@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An oom_badness() score of 0 means "never kill" according to
Documentation/filesystems/proc.txt, so explicitly exclude it from being
selected for kill.  These tasks have either detached their p->mm or are
set to OOM_DISABLE.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/oom_kill.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -336,6 +336,8 @@ static struct task_struct *select_bad_process(unsigned int *ppoints,
 			continue;
 
 		points = oom_badness(p, totalpages);
+		if (!points)
+			continue;
 		if (points > *ppoints || !chosen) {
 			chosen = p;
 			*ppoints = points;
