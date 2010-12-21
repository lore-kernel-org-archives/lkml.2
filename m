Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933530Ab0LUCoD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 21:44:03 -0500
Received: from smtp-out.google.com ([216.239.44.51]:57808 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933446Ab0LUCoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 21:44:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=NmV5W2GOLrB4SfIoq2OtszLfgt3mlr4ArruJrm+Hgyi1UEqX5l7cPzptjq7F4vl2LZ
         cdct7Twzrbopq53IglZA==
MIME-Version: 1.0
From: David Sharp <dhsharp@google.com>
Date: Mon, 20 Dec 2010 18:43:37 -0800
Message-ID: <AANLkTik6RfWWqjtuBUWRGZ0e+DHHm02opR9FAQJPdTR1@mail.gmail.com>
Subject: ftrace: trace_pipe_raw interface broken
To: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Cc: Michael Rubin <mrubin@google.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

trace_pipe_raw doesn't work correctly, I think because
tracing_buffers_read() uses ring_buffer_read_page() incorrectly.

In particular, if you read less than one page at a time, then you get
much more data than expected from the ring buffer:

$ ftrace=/sys/kernel/debug/tracing
$ echo 0 > $ftrace/tracing_enabled
$ echo 1 > $ftrace/events/enable
$ echo > $ftrace/trace  # reset
$ echo 100 > $ftrace/buffer_size_kb
$  # generate lots of events:
$ echo 1 > $ftrace/tracing_enabled &&  ls -laR /proc/ > /dev/null 2>&1
&& echo 0 > $ftrace/tracing_enabled
$ dd bs=1024 if=$ftrace/per_cpu/cpu0/trace_pipe_raw 2>/dev/null | wc -c
675840

That's significantly more data than the buffer could possibly contain.
Further shrinking bs increases the amount of data output even more.

Even when reading >=4096 bytes, something is funny:

$ dd bs=4096 if=$ftrace/per_cpu/cpu0/trace_pipe_raw 2>/dev/null | wc -c
118784

That's 116kB. I expect 100kb to allocate (102400+4087)/4088 = 26
pages, or 104kb-worth of pages. 116kB is about 28 pages.

Looking at the code for tracing_buffers_read() and
ring_buffer_read_page(), there seems to be a disconnect.

ring_buffer_read_page can consume less than one page if it was in the
middle of the buffer, such as when would happen after userspace only
asks for 1k. It returns the offset of the start of what it cosumed,
and the end is put in the returned bpage->commit. However,
ring_buffer_data_page is not exposed outside of ring_buffer.c.
Furthermore, tracing_buffers_read ignores the return value, except to
check for error.

Basically, I think tracing_buffers_read was forgotten when the ring
buffer got headers in the buffer pages. It looks like it still expects
whole pages to have valid tracing data.

I was working on a fix, but, how is trace_pipe_raw supposed to work?
I'm not sure if it's supposed to output full pages including the page
headers, or just data. I'm guessing the latter?

Thanks,
d#
