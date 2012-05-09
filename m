Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025Ab2EIFBF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 01:01:05 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45468 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754527Ab2EIFBA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:01:00 -0400
MIME-Version: 1.0
In-Reply-To: <1336534682.14207.197.camel@gandalf.stny.rr.com>
References: <1335388704-26790-1-git-send-email-vnagarnaik@google.com>
 <1336096792-25373-1-git-send-email-vnagarnaik@google.com> <1336534682.14207.197.camel@gandalf.stny.rr.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Tue, 8 May 2012 22:00:29 -0700
Message-ID: <CAL26m8J9j9oqGRte80Kp7zH8DQr5RuHPS88w7+2hry2E-N7VYg@mail.gmail.com>
Subject: Re: [PATCH v7 1/3] trace: Make removal of ring buffer pages atomic
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Laurent Chavey <chavey@google.com>,
        Justin Teravest <teravest@google.com>,
        David Sharp <dhsharp@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 8, 2012 at 8:38 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> BTW, why the two loops and not just:
>
>                for_each_buffer_cpu(buffer, cpu) {
>                        cpu_buffer = buffer->buffers[cpu];
>                        if (!cpu_buffer->nr_pages_to_update)
>                                continue;
>
>                        if (cpu_online(cpu))
>                                schedule_work_on(cpu, &cpu_buffer->update_pages_work);
>                        else
>                                rb_update_pages(cpu_buffer);
>                }
>
> ??
>
>
>>
>>               /* wait for all the updates to complete */
>>               for_each_buffer_cpu(buffer, cpu) {
>>                       cpu_buffer = buffer->buffers[cpu];
>> -                     if (cpu_buffer->nr_pages_to_update) {
>> -                             update_pages_handler(cpu_buffer);
>> -                     }
>> +                     if (!cpu_buffer->nr_pages_to_update||
>
>                              !cpu_buffer->nr_pages_to_update ||

This schedules work for all online CPUs and the offline CPUs resizing
(if any) can occur concurrently. It might not be too much of big deal
to just make it one loop.



Vaibhav Nagarnaik
