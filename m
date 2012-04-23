Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab2DWRca (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 13:32:30 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44666 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421Ab2DWRc3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 13:32:29 -0400
MIME-Version: 1.0
In-Reply-To: <1334982460.28106.90.camel@gandalf.stny.rr.com>
References: <1318382410-14967-1-git-send-email-vnagarnaik@google.com>
 <1328212844-11889-1-git-send-email-vnagarnaik@google.com> <1328212844-11889-2-git-send-email-vnagarnaik@google.com>
 <1334982460.28106.90.camel@gandalf.stny.rr.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Mon, 23 Apr 2012 10:31:58 -0700
Message-ID: <CAL26m8LCAx07BffXTZMWtvLRMOBbksaHSu1-Dw403+WD+_3L0A@mail.gmail.com>
Subject: Re: [PATCH v5 2/4] trace: Make removal of ring buffer pages atomic
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        Justin Teravest <teravest@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 9:27 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Thu, 2012-02-02 at 12:00 -0800, Vaibhav Nagarnaik wrote:
>> +rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned int
>> nr_pages)
>>  {
>> -       struct buffer_page *bpage;
>> -       struct list_head *p;
>> -       unsigned i;
>> +       unsigned int nr_removed;
>> +       int page_entries;
>> +       struct list_head *tail_page, *to_remove, *next_page;
>> +       unsigned long head_bit;
>> +       struct buffer_page *last_page, *first_page;
>> +       struct buffer_page *to_remove_page, *tmp_iter_page;
>>
> Also, please use the "upside down x-mas tree" for the declarations:
>
> ie.
>
>       struct list_head *tail_page, *to_remove, *next_page;
>       struct buffer_page *to_remove_page, *tmp_iter_page;
>       struct buffer_page *last_page, *first_page;
>       unsigned int nr_removed;
>       unsigned long head_bit;
>       int page_entries;
>
> See, it looks easier to read then what you had.
>
>> +             /* fire off all the required work handlers */
>> +             for_each_buffer_cpu(buffer, cpu) {
>> +                     cpu_buffer = buffer->buffers[cpu];
>> +                     if (!cpu_buffer->nr_pages_to_update)
>> +                             continue;
>> +                     schedule_work_on(cpu, &cpu_buffer->update_pages_work);
>
> This locks up. I just tried the following, and it hung the task.
>
> Here:
>
> # cd /sys/kernel/debug/tracing
> # echo 1 > events/enable
> # sleep 10
> # echo 0 > event/enable
> # echo 0 > /sys/devices/system/cpu/cpu1/online
> # echo 100 > buffer_size_kb
>
> <locked!>
>
> I guess you could test if the cpu is online. And if so, then do the
> schedule_work_on(). You will need to get_online_cpus first.
>
> If the cpu is offline, just change it.
>
> -- Steve
>
> PS. The first patch looks good, but I think you need to add some more
> blank lines in your patches. You like to bunch a lot of text together,
> and that causes some eye strain.


Thanks for the feedback. I will update the patch with your suggestions.



Vaibhav Nagarnaik
