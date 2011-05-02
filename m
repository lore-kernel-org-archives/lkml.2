Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab1EBCi7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 22:38:59 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65398 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384Ab1EBCi6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 22:38:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UCi/QUt2YdqZrV+M5bABnLp9vR8rCVU91hGdLRib2o6XR7TD/8JrEtZIwm1xpWDiyr
         27G/l7Gi070FkE5j2GWDtW3plm64YjsYFXd4VQn40SZ898g4yC+RrJjIaiX61V0/Noe1
         xH9l3aEgjIoxGJDr8k5bLOlKQClDAa0wOJUIU=
MIME-Version: 1.0
In-Reply-To: <1303395603.2035.144.camel@laptop>
References: <BANLkTin_m2Ygnr8csKo6fJZ4sB6YYvYDGw@mail.gmail.com>
	<1303393450.2035.142.camel@laptop>
	<BANLkTinYu00M9No_Pqxp+gpEZAmPJPDt1g@mail.gmail.com>
	<1303395603.2035.144.camel@laptop>
Date: Mon, 2 May 2011 10:38:56 +0800
Message-ID: <BANLkTi=eZt9_nwMVvCtkbdP0d01OZ8k-pA@mail.gmail.com>
Subject: Re: [PATCH] sched: try to fix mm leak when freeing sched groups
From: Hillf Danton <dhillf@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Yong Zhang <yong.zhang0@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 10:20 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2011-04-21 at 21:46 +0800, Hillf Danton wrote:
>>
>> It is linux-2.6.39-rc1.tar.bz2 downloaded at kernel.org, and
>>           >> --- a/kernel/sched.c  2011-03-30 03:09:48.000000000 +0800
>> is the time stamp, right?
>
> Dunno, but 39-rc1 is like ancient, please send patches against the tip
> git tree:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git
>

Hi Peter

I tried again, and please review once more.

thanks

Hillf
---

--- linux-2.6.39-rc5/kernel/sched.c	2011-04-27 11:48:50.000000000 +0800
+++ sched.c	2011-05-02 10:38:02.000000000 +0800
@@ -7120,21 +7120,18 @@ static void free_sched_groups(const stru
 			continue;

 		for (i = 0; i < nr_node_ids; i++) {
-			struct sched_group *oldsg, *sg = sched_group_nodes[i];
+			struct sched_group *sg = sched_group_nodes[i];

 			cpumask_and(nodemask, cpumask_of_node(i), cpu_map);
 			if (cpumask_empty(nodemask))
 				continue;

-			if (sg == NULL)
-				continue;
-			sg = sg->next;
-next_sg:
-			oldsg = sg;
-			sg = sg->next;
-			kfree(oldsg);
-			if (oldsg != sched_group_nodes[i])
-				goto next_sg;
+			if (sg != NULL)
+				do {
+					struct sched_group *next = sg->next;
+					kfree(sg);
+					sg = next;
+				} while (sg != sched_group_nodes[i]);
 		}
 		kfree(sched_group_nodes);
 		sched_group_nodes_bycpu[cpu] = NULL;
