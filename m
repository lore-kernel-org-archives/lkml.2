Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357Ab2JDGyh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 02:54:37 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:60131 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694Ab2JDGyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 02:54:35 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohponOWLNSUOtqC_TMfat-yQH=tGC_kg3yNTTQwOoRGH+U5g@mail.gmail.com>
References: <1348252345-5642-1-git-send-email-morten.rasmussen@arm.com>
	<1348252345-5642-3-git-send-email-morten.rasmussen@arm.com>
	<CAKohponOWLNSUOtqC_TMfat-yQH=tGC_kg3yNTTQwOoRGH+U5g@mail.gmail.com>
Date: Thu, 4 Oct 2012 12:24:35 +0530
Message-ID: <CAP245DWzprhZkburwT=j+G2P6QaKwMiFvEM96jv1X1pVgFqJuQ@mail.gmail.com>
Subject: Re: [RFC PATCH 02/10] sched: Task placement for heterogeneous systems
 based on task load-tracking
From: Amit Kucheria <amit.kucheria@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: morten.rasmussen@arm.com, paulmck@linux.vnet.ibm.com, pjt@google.com,
        peterz@infradead.org, suresh.b.siddha@intel.com,
        linaro-sched-sig@lists.linaro.org, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, Robin Randhawa <robin.randhawa@arm.com>,
        Arvind.Chauhan@arm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 4, 2012 at 11:32 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> Hi Morten,
>
> On 22 September 2012 00:02,  <morten.rasmussen@arm.com> wrote:
>> From: Morten Rasmussen <morten.rasmussen@arm.com>
>>
>> This patch introduces the basic SCHED_HMP infrastructure. Each class of
>> cpus is represented by a hmp_domain and tasks will only be moved between
>> these domains when their load profiles suggest it is beneficial.
>>
>> SCHED_HMP relies heavily on the task load-tracking introduced in Paul
>> Turners fair group scheduling patch set:
>>
>> <https://lkml.org/lkml/2012/8/23/267>
>>
>> SCHED_HMP requires that the platform implements arch_get_hmp_domains()
>> which should set up the platform specific list of hmp_domains. It is
>> also assumed that the platform disables SD_LOAD_BALANCE for the
>> appropriate sched_domains.
>
> An explanation of this requirement would be helpful here.
>
>> Tasks placement takes place every time a task is to be inserted into
>> a runqueue based on its load history. The task placement decision is
>> based on load thresholds.
>>
>> There are no restrictions on the number of hmp_domains, however,
>> multiple (>2) has not been tested and the up/down migration policy is
>> rather simple.
>>
>> Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
>> ---
>>  arch/arm/Kconfig      |   17 +++++
>>  include/linux/sched.h |    6 ++
>>  kernel/sched/fair.c   |  168 +++++++++++++++++++++++++++++++++++++++++++++++++
>>  kernel/sched/sched.h  |    6 ++
>>  4 files changed, 197 insertions(+)
>>
>> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
>> index f4a5d58..5b09684 100644
>> --- a/arch/arm/Kconfig
>> +++ b/arch/arm/Kconfig
>> @@ -1554,6 +1554,23 @@ config SCHED_SMT
>>           MultiThreading at a cost of slightly increased overhead in some
>>           places. If unsure say N here.
>>
>> +config DISABLE_CPU_SCHED_DOMAIN_BALANCE
>> +       bool "(EXPERIMENTAL) Disable CPU level scheduler load-balancing"
>> +       help
>> +         Disables scheduler load-balancing at CPU sched domain level.
>
> Shouldn't this depend on EXPERIMENTAL?

EXPERIMENTAL might be on its way out: https://lkml.org/lkml/2012/10/2/398
