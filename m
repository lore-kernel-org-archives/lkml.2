Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab0KSLfw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 06:35:52 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45621 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225Ab0KSLfu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 06:35:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PdaxowgncmQWzKHwuY24euDca/WQPMG9YwDuEOfRX29GZneHcquv8keYkW43FFWlxu
         zeJarmTEoBytNKPenQ8IsozFHfmoUqZnai4UCLEEfb1rnY2PKZHFmv2EPoypc8t39HoG
         MDhC5G2qqSze2phUimbN0oa8nFDlypZGDIRm0=
MIME-Version: 1.0
In-Reply-To: <1290159806.9342.7.camel@e102144-lin.cambridge.arm.com>
References: <1290063401-25440-1-git-send-email-dengcheng.zhu@gmail.com>
	<1290063401-25440-4-git-send-email-dengcheng.zhu@gmail.com>
	<1290159806.9342.7.camel@e102144-lin.cambridge.arm.com>
Date: Fri, 19 Nov 2010 19:30:08 +0800
Message-ID: <AANLkTikdLqo0-jkLkY-jGxurKMnmv+gb0VWWDZu6TOwd@mail.gmail.com>
Subject: Re: [PATCH 3/5] MIPS/Perf-events: Check event state in validate_event()
From: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
To: Will Deacon <will.deacon@arm.com>
Cc: ralf@linux-mips.org, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        wuzhangjin@gmail.com, paulus@samba.org, mingo@elte.hu, acme@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ah, I see. Thanks for your explanation.

But by doing this, I think we need to modify validate_group() as well.
Consider a group which has all its events either not for this PMU or in
OFF/Error state. Then the last validate_event() in validate_group() does
not work. Right? So, how about the following:

diff --git a/arch/mips/kernel/perf_event.c b/arch/mips/kernel/perf_event.c
index 1ee44a3..4010bc0 100644
--- a/arch/mips/kernel/perf_event.c
+++ b/arch/mips/kernel/perf_event.c
@@ -486,8 +486,8 @@ static int validate_event(struct cpu_hw_events *cpuc,
 {
 	struct hw_perf_event fake_hwc = event->hw;

-	if (event->pmu && event->pmu != &pmu)
-		return 0;
+	if (event->pmu != &pmu || event->state <= PERF_EVENT_STATE_OFF)
+		return 1;

 	return mipspmu->alloc_counter(cpuc, &fake_hwc) >= 0;
 }
@@ -496,6 +496,7 @@ static int validate_group(struct perf_event *event)
 {
 	struct perf_event *sibling, *leader = event->group_leader;
 	struct cpu_hw_events fake_cpuc;
+	struct hw_perf_event fake_hwc = event->hw;

 	memset(&fake_cpuc, 0, sizeof(fake_cpuc));

@@ -507,10 +508,12 @@ static int validate_group(struct perf_event *event)
 			return -ENOSPC;
 	}

-	if (!validate_event(&fake_cpuc, event))
+	if (event->pmu != &pmu || event->state <= PERF_EVENT_STATE_OFF)
+		return -EINVAL;
+	else if (mipspmu->alloc_counter(&fake_cpuc, &fake_hwc) < 0)
 		return -ENOSPC;
-
-	return 0;
+	else
+		return 0;
 }

 /* This is needed by specific irq handlers in perf_event_*.c */


Thanks,

Deng-Cheng


2010/11/19 Will Deacon <will.deacon@arm.com>:
> Hi Deng-Cheng,
>
> On Thu, 2010-11-18 at 06:56 +0000, Deng-Cheng Zhu wrote:
>> Ignore events that are not for this PMU or are in off/error state.
>>
> Sorry I didn't see this before, thanks for pointing out that you
> had included it for MIPS.
>
>> Signed-off-by: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
>> ---
>>  arch/mips/kernel/perf_event.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/mips/kernel/perf_event.c b/arch/mips/kernel/perf_event.c
>> index 1ee44a3..9c6442a 100644
>> --- a/arch/mips/kernel/perf_event.c
>> +++ b/arch/mips/kernel/perf_event.c
>> @@ -486,7 +486,7 @@ static int validate_event(struct cpu_hw_events *cpuc,
>>  {
>>         struct hw_perf_event fake_hwc = event->hw;
>>
>> -       if (event->pmu && event->pmu != &pmu)
>> +       if (event->pmu != &pmu || event->state <= PERF_EVENT_STATE_OFF)
>>                 return 0;
>>
>>         return mipspmu->alloc_counter(cpuc, &fake_hwc) >= 0;
>
> So this is the opposite of what we're doing on ARM. Our
> approach is to ignore events that are OFF (or in the ERROR
> state) or that belong to a different PMU. We do this by
> allowing them to *pass* validation (i.e. by returning 1 above).
> This means that we won't unconditionally fail a mixed event group.
>
> x86 does something similar in the collect_events function.
>
> Will
>
> --
> IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium.  Thank you.
>
> -- IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium.  Thank you.
>
>
