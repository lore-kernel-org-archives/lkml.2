Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751186Ab0JTENW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 00:13:22 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54915 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab0JTENV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 00:13:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=RZFAPphDvfQrGQmGVY7gkQpbkW6x2WO5krkjCKeJYWYebuev8snjqhe89H7smVmX0d
         cAlXzL6s4V3y3mpX6M71OZlhNnBepvSb4OTBVtG6bca8zFGKYioOzK4pfVsYHpdwJO7t
         0pM/COuLqyDecT7u/qR4Jrq5CF6GWJwDLQ8nY=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=-E6f3US+h9vzmZhQbzLkaoA4_OZqu8uV3wsjv@mail.gmail.com>
References: <AANLkTinoaJX3M2zU_zZOpmFm9Ekxpw-LUVUf_TU8yuSq@mail.gmail.com>
	<1287486167.1994.1.camel@twins>
	<4CBD5D680200005A0007492F@soto.provo.novell.com>
	<AANLkTi=-E6f3US+h9vzmZhQbzLkaoA4_OZqu8uV3wsjv@mail.gmail.com>
Date: Wed, 20 Oct 2010 10:13:19 +0600
Message-ID: <AANLkTimcBESMCtr3osZ=4seqT+bSGGix920PDecaSVX_@mail.gmail.com>
Subject: Re: [PATCH] sched_rt: Removes extra checking for nr_cpus_allowed when
 calling find_lowest_rq
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 8:40 PM, Rakib Mullick <rakib.mullick@gmail.com> wrote:
> On 10/19/10, Gregory Haskins <ghaskins@novell.com> wrote:
>>>>> On 10/19/2010 at 07:02 AM, in message <1287486167.1994.1.camel@twins>,
>>>>> Peter
>> Zijlstra <peterz@infradead.org> wrote:
>>> On Tue, 2010-10-19 at 16:57 +0600, Rakib Mullick wrote:
>>
> If we made explicit check before calling find_lowest_rq, then I don't
> think we need the change that Steve's suggesting. I think explicitly
> checking is much more easier and removes extra overhead of function
> calling.

The following patch shows what I was trying to say. Please check and
comment. Hopefully this looks clean.


--- linus-rc8/kernel/sched_rt.c	2010-10-19 16:42:05.000000000 +0600
+++ rakib-rc8/kernel/sched_rt.c	2010-10-20 10:04:08.000000000 +0600
@@ -1174,9 +1174,6 @@ static int find_lowest_rq(struct task_st
 	int this_cpu = smp_processor_id();
 	int cpu      = task_cpu(task);

-	if (task->rt.nr_cpus_allowed == 1)
-		return -1; /* No other targets possible */
-
 	if (!cpupri_find(&task_rq(task)->rd->cpupri, task, lowest_mask))
 		return -1; /* No targets found */

@@ -1238,6 +1235,9 @@ static struct rq *find_lock_lowest_rq(st
 	int tries;
 	int cpu;

+	if (task->rt.nr_cpus_allowed < 2)
+		goto out;
+
 	for (tries = 0; tries < RT_MAX_TRIES; tries++) {
 		cpu = find_lowest_rq(task);

@@ -1275,6 +1275,7 @@ static struct rq *find_lock_lowest_rq(st
 		lowest_rq = NULL;
 	}

+out:
 	return lowest_rq;
 }



Thanks,
Rakib

>
> Thanks,
> Rakib
>> Kind Regards,
>> -Greg
>>
>>
>>
>
