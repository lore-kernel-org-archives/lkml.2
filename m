Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759284Ab1FWLol (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 07:44:41 -0400
Received: from smtp-out.google.com ([74.125.121.67]:4822 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755812Ab1FWLok convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 07:44:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rWhzXzTsrbLH7aW0QakGeaz+it0nV6Ed8QPgU9dkcnGbHidWqTgiBHCgmDZX7qqWa6
         tpwQVautSSSmco/zXqew==
MIME-Version: 1.0
In-Reply-To: <20110623114055.GV3765@redhat.com>
References: <BANLkTikBsfcFfnmgdVQem15P9f2ooQBzeA@mail.gmail.com>
	<20110621175421.GF21641@sun>
	<BANLkTim8OdhTdaayHZAKSXWhmN0anEhieQ@mail.gmail.com>
	<20110621183227.GG21641@sun>
	<20110622082756.GK21641@sun>
	<20110622092134.GO21641@sun>
	<20110623064835.GB10238@sun>
	<BANLkTikVaOz5DYjKSU-jxVBw_Lw9ihV7BQ@mail.gmail.com>
	<20110623095439.GC10238@sun>
	<20110623110706.GE10238@sun>
	<20110623114055.GV3765@redhat.com>
Date: Thu, 23 Jun 2011 13:44:36 +0200
Message-ID: <BANLkTikR7j0iZ7SLsfkz=2bpTm2uaO_=5g@mail.gmail.com>
Subject: Re: [RFC -tip] perf, x86: Add PERF_COUNT_HW_NMI_WATCHDOG event v2
From: Stephane Eranian <eranian@google.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Vince Weaver <vweaver1@eecs.utk.edu>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 1:40 PM, Don Zickus <dzickus@redhat.com> wrote:
> On Thu, Jun 23, 2011 at 03:07:06PM +0400, Cyrill Gorcunov wrote:
>> On Thu, Jun 23, 2011 at 01:54:39PM +0400, Cyrill Gorcunov wrote:
>> ...
>> > >
>> > > No new hidden event, just a x86_pmu + a per-arch callbacks.
>> >
>> > Looks quite good for me, Don? (i'll cook some draft patch for review meanwhile).
>> >
>> >     Cyrill
>>
>> Since we are going to make __weak linking anyway maybe something like below
>> fit even beter? (untested)
>
> I don't think the compiler knows what platform you are running on and may
> just blindly link your new p4 function for all x86s, which is probably not
> what you want.
>
Don, is right. You need the level of indirection I had in my outline patch.

You also don't need the:
+       if (wd_attr->type       != PERF_TYPE_HARDWARE ||
+          wd_attr->attr.config != PERF_COUNT_HW_CPU_CYCLES)
+               return;

In the p4 callback given you know your coming in for the watchdog.

> Cheers,
> Don
>
>>
>>       Cyrill
>> ---
>>  arch/x86/kernel/cpu/perf_event_p4.c |   26 ++++++++++++++++++++++++++
>>  kernel/watchdog.c                   |    3 +++
>>  2 files changed, 29 insertions(+)
>>
>> Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
>> ===================================================================
>> --- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
>> +++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
>> @@ -705,6 +705,32 @@ static int p4_validate_raw_event(struct
>>       return 0;
>>  }
>>
>> +void hw_nmi_watchdog_set_attr(struct perf_event_attr *wd_attr)
>> +{
>> +     /*
>> +      * Watchdog ticks are special on Netburst, we use
>> +      * that named "non-sleeping" ticks as recommended
>> +      * by Intel SDM Vol3b.
>> +      */
>> +     if (wd_attr->type       != PERF_TYPE_HARDWARE ||
>> +        wd_attr->attr.config != PERF_COUNT_HW_CPU_CYCLES)
>> +             return;
>> +
>> +     wd_attr->type   = PERF_TYPE_RAW;
>> +     wd_attr->config =
>> +             p4_config_pack_escr(P4_ESCR_EVENT(P4_EVENT_EXECUTION_EVENT)             |
>> +                     P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS0)            |
>> +                     P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS1)            |
>> +                     P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS2)            |
>> +                     P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS3)            |
>> +                     P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, BOGUS0)             |
>> +                     P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, BOGUS1)             |
>> +                     P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, BOGUS2)             |
>> +                     P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, BOGUS3))            |
>> +             p4_config_pack_cccr(P4_CCCR_THRESHOLD(15) | P4_CCCR_COMPLEMENT          |
>> +                     P4_CCCR_COMPARE);
>> +}
>> +
>>  static int p4_hw_config(struct perf_event *event)
>>  {
>>       int cpu = get_cpu();
>> Index: linux-2.6.git/kernel/watchdog.c
>> ===================================================================
>> --- linux-2.6.git.orig/kernel/watchdog.c
>> +++ linux-2.6.git/kernel/watchdog.c
>> @@ -355,6 +355,8 @@ static int watchdog(void *unused)
>>
>>
>>  #ifdef CONFIG_HARDLOCKUP_DETECTOR
>> +void __weak hw_nmi_watchdog_set_attr(struct perf_event_attr *wd_attr) { }
>> +
>>  static int watchdog_nmi_enable(int cpu)
>>  {
>>       struct perf_event_attr *wd_attr;
>> @@ -371,6 +373,7 @@ static int watchdog_nmi_enable(int cpu)
>>       /* Try to register using hardware perf events */
>>       wd_attr = &wd_hw_attr;
>>       wd_attr->sample_period = hw_nmi_get_sample_period(watchdog_thresh);
>> +     hw_nmi_watchdog_set_attr(wd_attr);
>>       event = perf_event_create_kernel_counter(wd_attr, cpu, NULL, watchdog_overflow_callback);
>>       if (!IS_ERR(event)) {
>>               printk(KERN_INFO "NMI watchdog enabled, takes one hw-pmu counter.\n");
>
