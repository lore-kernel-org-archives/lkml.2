Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751404Ab2DUE1n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 00:27:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2474 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab2DUE1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 00:27:42 -0400
X-Authority-Analysis: v=2.0 cv=V/z/IJbi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=lt3JZn9S7PoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=IFFSxcZ83qxRnnNlgCYA:9 a=B3yhWHvGVk21BXoNxLgA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1334982460.28106.90.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH v5 2/4] trace: Make removal of ring buffer pages atomic
From: Steven Rostedt <rostedt@goodmis.org>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        Justin Teravest <teravest@google.com>, linux-kernel@vger.kernel.org
Date: Sat, 21 Apr 2012 00:27:40 -0400
In-Reply-To: <1328212844-11889-2-git-send-email-vnagarnaik@google.com>
References: <1318382410-14967-1-git-send-email-vnagarnaik@google.com>
	 <1328212844-11889-1-git-send-email-vnagarnaik@google.com>
	 <1328212844-11889-2-git-send-email-vnagarnaik@google.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-02 at 12:00 -0800, Vaibhav Nagarnaik wrote:
> This patch adds the capability to remove pages from a ring buffer
> without destroying any existing data in it.
> 
> This is done by removing the pages after the tail page. This makes sure
> that first all the empty pages in the ring buffer are removed. If the
> head page is one in the list of pages to be removed, then the page after
> the removed ones is made the head page. This removes the oldest data
> from the ring buffer and keeps the latest data around to be read.
> 
> To do this in a non-racey manner, tracing is stopped for a very short
> time while the pages to be removed are identified and unlinked from the
> ring buffer. The pages are freed after the tracing is restarted to
> minimize the time needed to stop tracing.
> 
> The context in which the pages from the per-cpu ring buffer are removed
> runs on the respective CPU. This minimizes the events not traced to only
> NMI trace contexts.

Can't do this. (see below)



> +rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned int
> nr_pages)
>  {
> -       struct buffer_page *bpage;
> -       struct list_head *p;
> -       unsigned i;
> +       unsigned int nr_removed;
> +       int page_entries;
> +       struct list_head *tail_page, *to_remove, *next_page;
> +       unsigned long head_bit;
> +       struct buffer_page *last_page, *first_page;
> +       struct buffer_page *to_remove_page, *tmp_iter_page;
> 
Also, please use the "upside down x-mas tree" for the declarations:

ie.

       struct list_head *tail_page, *to_remove, *next_page;
       struct buffer_page *to_remove_page, *tmp_iter_page;
       struct buffer_page *last_page, *first_page;
       unsigned int nr_removed;
       unsigned long head_bit;
       int page_entries;

See, it looks easier to read then what you had.

> +		/* fire off all the required work handlers */
> +		for_each_buffer_cpu(buffer, cpu) {
> +			cpu_buffer = buffer->buffers[cpu];
> +			if (!cpu_buffer->nr_pages_to_update)
> +				continue;
> +			schedule_work_on(cpu, &cpu_buffer->update_pages_work);

This locks up. I just tried the following, and it hung the task.

Here:

# cd /sys/kernel/debug/tracing
# echo 1 > events/enable
# sleep 10
# echo 0 > event/enable
# echo 0 > /sys/devices/system/cpu/cpu1/online
# echo 100 > buffer_size_kb

<locked!>

I guess you could test if the cpu is online. And if so, then do the
schedule_work_on(). You will need to get_online_cpus first.

If the cpu is offline, just change it.

-- Steve

PS. The first patch looks good, but I think you need to add some more
blank lines in your patches. You like to bunch a lot of text together,
and that causes some eye strain.

