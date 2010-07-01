Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab0GALtD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 07:49:03 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44722 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab0GALtA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 07:49:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Lm0zr5TKMLNw4Sx2C+tOyYApSpQwbk99Z/bOL0weippK8XBYuKL49l9mobtjDeNLVb
         +n553fnebGe7PNGlSuXGDnFAm6bEFiBeAY/lR8CJfBG6nNZ/28dDew4S/hTTO5skzkLz
         /fTB/Vbuj9JeQK6HKY1kq3/c/x7V4zY222Zv0=
MIME-Version: 1.0
In-Reply-To: <4C2C5F44.7010006@cn.fujitsu.com>
References: <20100630120419.391D.A69D9226@jp.fujitsu.com>
	<1277948436.25782.5.camel@gandalf.stny.rr.com>
	<20100701104554.DA2D.A69D9226@jp.fujitsu.com>
	<4C2C5F44.7010006@cn.fujitsu.com>
Date: Thu, 1 Jul 2010 20:48:59 +0900
X-Google-Sender-Auth: ihf0PnBuXYp_F9hE7OFKmtjjutQ
Message-ID: <AANLkTinKPVPAMT2tsZ1it90K4Qu601jr12ulHZFOfFEy@mail.gmail.com>
Subject: Re: [PATCH v2] tracing: shrink max latency ringbuffer if unnecessary
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: rostedt@goodmis.org, LKML <linux-kernel@vger.kernel.org>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/7/1 Lai Jiangshan <laijs@cn.fujitsu.com>:
> KOSAKI Motohiro wrote:
>>
>> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> ---
>>  kernel/trace/trace.c              |   39 ++++++++++++++++++++++++++++++------
>>  kernel/trace/trace.h              |    1 +
>>  kernel/trace/trace_irqsoff.c      |    3 ++
>>  kernel/trace/trace_sched_wakeup.c |    2 +
>>  4 files changed, 38 insertions(+), 7 deletions(-)
>>
>
> Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com
>
>
>> -
>> +     if (current_trace && current_trace->use_max_tr) {
>> +             /*
>> +              * We don't free the ring buffer. instead, resize it because
>> +              * The max_tr ring buffer has some state (e.g. ring->clock) and
>> +              * we want preserve it.
>> +              */
>> +             ring_buffer_resize(max_tr.buffer, 1);
>> +             max_tr.entries = 1;
>> +     }
>>       destroy_trace_option_files(topts);
>>
>>       current_trace = t;
>>
>>       topts = create_trace_option_files(current_trace);
>
> I think we can skip the two resize when current_trace->use_max_tr==1 && t->use_max_tr==1

Yup. but I don't think it's worthful because it's rarely operation.


>
>> +     if (current_trace->use_max_tr) {
>> +             ret = ring_buffer_resize(max_tr.buffer, global_trace.entries);
>> +             if (ret < 0)
>> +                     goto out;
>> +             max_tr.entries = global_trace.entries;
>> +     }
>>
>>       if (t->init) {
>>               ret = tracer_init(t, tr);
>
> Does we need to shrink it when tracer_init() fails?
> Although tracer_init() hardly fails, and there is no bad effect even we don't shrink it.

Nope. brief code of tracing_set_tracer() is here

========================================
        if (current_trace && current_trace->reset)
                current_trace->reset(tr);

        destroy_trace_option_files(topts);

        current_trace = t;

        topts = create_trace_option_files(current_trace);

        if (t->init) {
                ret = tracer_init(t, tr);
                if (ret)
                        goto out;
        }
========================================

That's mean, if t->init fail, we can't rollback old tracer. so your
suggested micro optimization
doesn't makes observable improvement, I think.

Thanks.
