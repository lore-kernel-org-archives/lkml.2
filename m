Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566Ab1ANDWt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 22:22:49 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:42333 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757115Ab1ANDWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 22:22:43 -0500
X-AuditID: b753bd60-9ef5fba000000f65-95-4d2fc1807728
Message-ID: <4D2FC17D.5010203@hitachi.com>
Date: Fri, 14 Jan 2011 12:22:37 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Franck Bui-Huu <vagabon.xyz@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        lkml <linux-kernel@vger.kernel.org>, 2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH] perf-probe: make "perf-probe -L <function>" display the
 absolute path and absolute line number
References: <m38vyp85qv.fsf@gmail.com> <4D2EDBE4.3060608@hitachi.com> <m34o9c8ual.fsf@gmail.com>
In-Reply-To: <m34o9c8ual.fsf@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/01/14 4:42), Franck Bui-Huu wrote:
 Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> writes:
> 
>> (2011/01/13 19:20), Franck Bui-Huu wrote:
>>> From: Franck Bui-Huu <fbuihuu@gmail.com>
>>>
>>> It should be more usefull to get the full location of the function
>>
>>> (absolute line number + full path) instead of repeating the name of
>>> the function and the start line number given by the command line.
>>>
>>> So we had before:
>>>
>>>    $ perf probe -L schedule | head -n3
>>>    <schedule:0>
>>>          0  asmlinkage void __sched schedule(void)
>>>          1  {
>>>
>>> and now we get:
>>>
>>>    $ perf probe -L schedule | head -n3
>>>    </usr/src/debug/kernel-2.6.35.fc14/linux-2.6.35.x86_64/kernel/sched.c:3813>
>>>          0  asmlinkage void __sched schedule(void)
>>>          1  {
>>
>> Indeed, it could be useful for users to see where the function is...
>>
>> However, I think that should be optional, because the output lines
>> have the relative line numbers from the function, and those numbers
>> are important for users who want to probe a specific line by using
>> function relative line numbers. e.g. "schedule:10"
>>
>> And with that option, I'd suggest to show absolute line numbers on each line.
>>
>>   $ perf probe -L schedule:0-1 --by-source
>>   </usr/src/debug/kernel-2.6.35.fc14/linux-2.6.35.x86_64/kernel/sched.c:3813>
>>      3813  asmlinkage void __sched schedule(void)
>>      3814  {
>>
>> Or, just show source file as an additional information.
>>
>>   $ perf probe -L schedule:0-1
>>   <schedule@/usr/src/debug/kernel-2.6.35.fc14/linux-2.6.35.x86_64/kernel/sched.c:0>
>>         0  asmlinkage void __sched schedule(void)
>>         1  {
>>
>> I just would like to keep the consistency of the output/input format.
> 
> Well, for consistency, I thought that the additional information (given
> inside angle brackets) should always be the same: a full path and an
> absolute line number which clearly identify which source file perf-probe
> is listing.

No, that is NOT an additional information. That indicates from where those
lines are started, and also gives you a hint how you can specify the
actual probe point. For example,

$ perf probe -L schedule:10
<schedule:10>
     10         rq = cpu_rq(cpu);
     11         rcu_note_context_switch(cpu);
     12         prev = rq->curr;

this indicates the lines started from 10th line of schedule(), and
if you want to put a new event on "prev = rq->curr;" line, you
just need to say "perf probe schedule:12"

$ perf probe -L kernel/sched.c:4077
</home/mhiramat/ksrc/linux-2.6-tip/kernel/sched.c:4077>
   4077         rq = cpu_rq(cpu);
   4078         rcu_note_context_switch(cpu);
   4079         prev = rq->curr;

And this also gives you a hint to say (just copy & paste)
"perf probe /home/mhiramat/ksrc/linux-2.6-tip/kernel/sched.c:4079"

Since perf probe also accepts FUNC@SRC:RLN, my suggestion
also keeps that rule.
---
  $ perf probe -L schedule:0-1
  <schedule@/usr/src/debug/kernel-2.6.35.fc14/linux-2.6.35.x86_64/kernel/sched.c:0>
        0  asmlinkage void __sched schedule(void)
        1  {
---

Thank you,

-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com>
