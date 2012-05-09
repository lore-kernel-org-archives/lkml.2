Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758664Ab2EIL7H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 07:59:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14208 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757790Ab2EIL7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 07:59:06 -0400
Message-ID: <4FAA5BFB.40309@redhat.com>
Date: Wed, 09 May 2012 13:58:51 +0200
From: Igor Mammedov <imammedo@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Jiang Liu <liuj97@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, pjt@google.com, tglx@linutronix.de,
        seto.hidetoshi@jp.fujitsu.com
Subject: Re: [PATCH] sched_groups are expected to be circular linked list,
 make it so right after allocation
References: <1336559908-32533-1-git-send-email-imammedo@redhat.com>  <4FAA452A.1070909@gmail.com> <4FAA588B.5010404@redhat.com> <1336564330.2527.23.camel@twins>
In-Reply-To: <1336564330.2527.23.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2012 01:52 PM, Peter Zijlstra wrote:
> On Wed, 2012-05-09 at 13:44 +0200, Igor Mammedov wrote:
>> This patch fixes only build_sched_groups path, but there is another fail path
>> that results in below OOPS.
>> build_overlap_sched_groups() may exit without setting groups and later it will crash
>> init_sched_groups_power as well.
>
> if that allocation fails? Or is there another fail path?

build_overlap_sched_groups(struct sched_domain *sd, int cpu)
...
                 if (cpumask_test_cpu(cpu, sg_span))
                         groups = sg;
...

above test fails and leaves local var groups set to NULL
and before exit there is:

   sd->groups = groups;

which resets sd->groups to NULL and I'm not sure if it is correct at all to skip this
assignment if groups == NULL.

>
>>   But I just don't know how to fix it, so I've just
>> posted partial fix that reduces crash frequency.
>
>
>> And I have to admit that
>> cpu_active_mask and siblings map are busted but we either should not exit from builder
>> funcs with NULL group or BUG there if it is impossible to come-up with sane group
>> for insane domain span.
>
> I'm perfectly OK with taking the machine down, provided we can output
> useful messages as to what is broken first..

-- 
-----
  Igor
