Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968304Ab2ESDBO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 23:01:14 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49605 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626Ab2ESDBM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 23:01:12 -0400
MIME-Version: 1.0
In-Reply-To: <1337392560.7562.21.camel@gandalf.stny.rr.com>
References: <1337372991-14783-1-git-send-email-vnagarnaik@google.com> <1337392560.7562.21.camel@gandalf.stny.rr.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Fri, 18 May 2012 20:00:38 -0700
Message-ID: <CAL26m8KwqabX1TqOcrVZC1cAFyzbo6fKPB44jcrQfqDytNfANA@mail.gmail.com>
Subject: Re: [PATCH] tracing: Merge separate resize loops
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Laurent Chavey <chavey@google.com>, Justin Teravest <teravest@google.com>,
        David Sharp <dhsharp@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 6:56 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Fri, 2012-05-18 at 13:29 -0700, Vaibhav Nagarnaik wrote:
>>
>>               /* wait for all the updates to complete */
>>               for_each_buffer_cpu(buffer, cpu) {
>>                       cpu_buffer = buffer->buffers[cpu];
>> -                     if (!cpu_buffer->nr_pages_to_update||
>> -                         !cpu_online(cpu))
>> +                     if (!cpu_buffer->nr_pages_to_update)
>>                               continue;
>>
>
> Why did you make this change? As we only need to wait for completions.
>
>> -                     wait_for_completion(&cpu_buffer->update_completion);
>> -                     /* reset this value */
>> +                     if (cpu_online(cpu))
>> +                             wait_for_completion(&cpu_buffer->update_done);
>>                       cpu_buffer->nr_pages_to_update = 0;
>
> Or was the original patch buggy, where we never set nr_page_to_update to
> zero for the offline case?

I don't see a bug, since at the start of the resize operation, we
always recalculate this value. It will be reset to 0, if there are no
updates. I set it to zero at the end just as a precautionary measure.


Vaibhav Nagarnaik
