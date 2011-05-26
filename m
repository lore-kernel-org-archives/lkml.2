Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933173Ab1EZSBR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:01:17 -0400
Received: from smtp-out.google.com ([216.239.44.51]:28229 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933080Ab1EZSBQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:01:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Vak8wG/awkxmBBoJbqQVnw78FdCauxfuoR3RaHGJXz/yxZVyfXOV0O2uDP2YQz4cqb
         czigYTmoZFzPZHRNqlpg==
MIME-Version: 1.0
In-Reply-To: <1306380591.1465.140.camel@gandalf.stny.rr.com>
References: <1304106356-11277-1-git-send-email-vnagarnaik@google.com>
 <1304118968-6620-1-git-send-email-vnagarnaik@google.com> <1306380591.1465.140.camel@gandalf.stny.rr.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Thu, 26 May 2011 11:00:43 -0700
Message-ID: <BANLkTin+WYW6Eahgn+yw2eTX44Erc5yBMg@mail.gmail.com>
Subject: Re: [PATCH] trace: Add a free on close control mechanism for buffer_size_kb
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Michael Rubin <mrubin@google.com>,
        David Sharp <dhsharp@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 8:29 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Fri, 2011-04-29 at 16:16 -0700, Vaibhav Nagarnaik wrote:
>
>> +static ssize_t tracing_resize_ring_buffer(unsigned long size)
>> +{
>> +     int cpu, ret = 0;
>> +
>> +     mutex_lock(&trace_types_lock);
>> +
>> +     tracing_stop();
>> +
>> +     /* disable all cpu buffers */
>> +     for_each_tracing_cpu(cpu) {
>> +             if (global_trace.data[cpu])
>> +                     atomic_inc(&global_trace.data[cpu]->disabled);
>> +             if (max_tr.data[cpu])
>> +                     atomic_inc(&max_tr.data[cpu]->disabled);
>> +     }
>> +
>> +     if (size != global_trace.entries)
>> +             ret = __tracing_resize_ring_buffer(size);
>> +
>> +     /* If check pages failed, return ENOMEM */
>> +     if (tracing_disabled)
>> +             ret = -ENOMEM;
>
> This is incorrect. tracing_disabled is set from
> __tracing_resize_ring_buffer() if the max buffer can't become the same
> size as the global buffer.

That's right. Thanks for catching it, I didn't see that as I was trying
to follow the logic in tracing_entries_write() function.

>
> What you should do is just check if ret is less than zero here.
>
>        if (ret < 0)
>                ret = -ENOMEM;

Instead, I don't have to check/set the return value. I can just return
"ret" to the caller.

>
> -- Steve
>
>
>> +
>> +     for_each_tracing_cpu(cpu) {
>> +             if (global_trace.data[cpu])
>> +                     atomic_dec(&global_trace.data[cpu]->disabled);
>> +             if (max_tr.data[cpu])
>> +                     atomic_dec(&max_tr.data[cpu]->disabled);
>> +     }
>> +
>> +     tracing_start();
>> +     mutex_unlock(&trace_types_lock);
>> +
>> +     return ret;
>> +}
>> +
>>
>
>


Vaibhav Nagarnaik
