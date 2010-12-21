Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933550Ab0LUDwx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 22:52:53 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48531 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933534Ab0LUDww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 22:52:52 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=pPXw3_qIy5IA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=cZUxKMnCxvWF3LEA1S4A:9 a=b41jcqk7nOdlhGZNzwgA:7 a=QoYjq27p6zj1B7igTTS5FolpmloA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: ftrace: trace_pipe_raw interface broken
From: Steven Rostedt <rostedt@goodmis.org>
To: David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org, Michael Rubin <mrubin@google.com>
In-Reply-To: <AANLkTik6RfWWqjtuBUWRGZ0e+DHHm02opR9FAQJPdTR1@mail.gmail.com>
References: <AANLkTik6RfWWqjtuBUWRGZ0e+DHHm02opR9FAQJPdTR1@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 20 Dec 2010 22:52:49 -0500
Message-ID: <1292903569.22905.123.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Thanks for the report.

On Mon, 2010-12-20 at 18:43 -0800, David Sharp wrote:
> trace_pipe_raw doesn't work correctly, I think because
> tracing_buffers_read() uses ring_buffer_read_page() incorrectly.
> 
> In particular, if you read less than one page at a time, then you get
> much more data than expected from the ring buffer:
> 
> $ ftrace=/sys/kernel/debug/tracing
> $ echo 0 > $ftrace/tracing_enabled
> $ echo 1 > $ftrace/events/enable
> $ echo > $ftrace/trace  # reset
> $ echo 100 > $ftrace/buffer_size_kb
> $  # generate lots of events:
> $ echo 1 > $ftrace/tracing_enabled &&  ls -laR /proc/ > /dev/null 2>&1
> && echo 0 > $ftrace/tracing_enabled
> $ dd bs=1024 if=$ftrace/per_cpu/cpu0/trace_pipe_raw 2>/dev/null | wc -c
> 675840
> 
> That's significantly more data than the buffer could possibly contain.
> Further shrinking bs increases the amount of data output even more.

Yep that's a side effect. What happens is that we always read a "full
page" even if we do not read in page size chunks. If we read 100 bytes,
it will read a header, and all the events that fit inside that 100
bytes, and then return a full page with the header, the 100 bytes -
header size, and the rest of the page filled with zeros.

Do a:

	hexdump -C outputfile

and you'll see a lot of "zeros". The reason for this is to keep all
reads in pagesize chunks. If you read only 100 bytes of data, I still
need to keep that page aligned in the output. The reason I do this is in
case there's two readers. I don't want one to read part of a page that
includes the header, and then the other reads the rest of the page. The
header tells you how much data is on that page.

I guess I could have had the info->spare just read the full page, and
then other readers would just read the next page.



> 
> Even when reading >=4096 bytes, something is funny:
> 
> $ dd bs=4096 if=$ftrace/per_cpu/cpu0/trace_pipe_raw 2>/dev/null | wc -c
> 118784
> 
> That's 116kB. I expect 100kb to allocate (102400+4087)/4088 = 26
> pages, or 104kb-worth of pages. 116kB is about 28 pages.

Hmm, isn't page data 4080, not 4088, since it has 2, 8 byte items in it.
Timestamp and atomic (on 64bit). 4096 - 16 = 4080. But still the numbers
are not much different.

Note, when I did it, I got:

$ dd if=/debug/tracing/per_cpu/cpu0/trace_pipe_raw of=/tmp/dat bs=4096
27+0 records in
27+0 records out
110592 bytes (111 kB) copied, 0.00302891 s, 36.5 MB/s

$ cat /debug/tracing/buffer_size_kb 
100

Ah, running hexdump -C, I got this at the end:

00019c80  62 57 00 00 22 d1 09 81  ff ff ff ff 76 d1 09 81  |bW.."Ñ..ÿÿÿÿvÑ..|
00019c90  ff ff ff ff 00 00 00 00  00 00 00 00 00 00 00 00  |ÿÿÿÿ............|
00019ca0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
0001a000  d8 32 b6 7e ed 53 05 00  24 00 00 00 00 00 00 00  |Ø2¶~íS..$.......|
0001a010  a8 36 00 00 01 00 00 00  ca 0b 00 00 ff ff ff ff  |¨6......Ê...ÿÿÿÿ|
0001a020  00 00 00 00 6a d1 09 81  ff ff ff ff 68 26 16 81  |....jÑ..ÿÿÿÿh&..|
0001a030  ff ff ff ff 00 00 00 00  00 00 00 00 00 00 00 00  |ÿÿÿÿ............|
0001a040  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
0001b000

I don't know why it added that last page. I'll have to look into this.



> Looking at the code for tracing_buffers_read() and
> ring_buffer_read_page(), there seems to be a disconnect.
> 
> ring_buffer_read_page can consume less than one page if it was in the
> middle of the buffer, such as when would happen after userspace only
> asks for 1k. It returns the offset of the start of what it cosumed,

Actually, we don't do that anymore. We either return < 0 on error or
zero. We always add to the 0 offset. The comment needs to be fixed.

> and the end is put in the returned bpage->commit. However,
> ring_buffer_data_page is not exposed outside of ring_buffer.c.
> Furthermore, tracing_buffers_read ignores the return value, except to
> check for error.
> 
> Basically, I think tracing_buffers_read was forgotten when the ring
> buffer got headers in the buffer pages. It looks like it still expects
> whole pages to have valid tracing data.

Yep, it does, and ring_buffer_read_page() adds zero to the rest of the
page.


> 
> I was working on a fix, but, how is trace_pipe_raw supposed to work?
> I'm not sure if it's supposed to output full pages including the page
> headers, or just data. I'm guessing the latter?

Nope, the former, because we need it to be full pages.

-- Steve


