Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933636Ab0LUGAN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 01:00:13 -0500
Received: from smtp-out.google.com ([216.239.44.51]:8365 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933616Ab0LUGAI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 01:00:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=BL3jTEGBv0ryCw1THwiphyefPEOUl2yFE84I5GVYdGC9wfb4cnfKBX9Z/Cabe1xTLB
         DJ+b4AQYAcUmgzvo+aVA==
MIME-Version: 1.0
In-Reply-To: <1292903569.22905.123.camel@gandalf.stny.rr.com>
References: <AANLkTik6RfWWqjtuBUWRGZ0e+DHHm02opR9FAQJPdTR1@mail.gmail.com> <1292903569.22905.123.camel@gandalf.stny.rr.com>
From: David Sharp <dhsharp@google.com>
Date: Mon, 20 Dec 2010 21:59:46 -0800
Message-ID: <AANLkTin7nLrRPc9qGjdjHbeVDDWiJjAiYyb-L=gH85bx@mail.gmail.com>
Subject: Re: ftrace: trace_pipe_raw interface broken
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Michael Rubin <mrubin@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 7:52 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> Hi David,
>
> Thanks for the report.
>
> On Mon, 2010-12-20 at 18:43 -0800, David Sharp wrote:
>> trace_pipe_raw doesn't work correctly, I think because
>> tracing_buffers_read() uses ring_buffer_read_page() incorrectly.
>>
>> In particular, if you read less than one page at a time, then you get
>> much more data than expected from the ring buffer:
>>
>> $ ftrace=/sys/kernel/debug/tracing
>> $ echo 0 > $ftrace/tracing_enabled
>> $ echo 1 > $ftrace/events/enable
>> $ echo > $ftrace/trace  # reset
>> $ echo 100 > $ftrace/buffer_size_kb
>> $  # generate lots of events:
>> $ echo 1 > $ftrace/tracing_enabled &&  ls -laR /proc/ > /dev/null 2>&1
>> && echo 0 > $ftrace/tracing_enabled
>> $ dd bs=1024 if=$ftrace/per_cpu/cpu0/trace_pipe_raw 2>/dev/null | wc -c
>> 675840
>>
>> That's significantly more data than the buffer could possibly contain.
>> Further shrinking bs increases the amount of data output even more.
>
> Yep that's a side effect. What happens is that we always read a "full
> page" even if we do not read in page size chunks. If we read 100 bytes,
> it will read a header, and all the events that fit inside that 100
> bytes, and then return a full page with the header, the 100 bytes -
> header size, and the rest of the page filled with zeros.
>
> Do a:
>
>        hexdump -C outputfile
>
> and you'll see a lot of "zeros". The reason for this is to keep all
> reads in pagesize chunks. If you read only 100 bytes of data, I still
> need to keep that page aligned in the output. The reason I do this is in
> case there's two readers. I don't want one to read part of a page that
> includes the header, and then the other reads the rest of the page. The
> header tells you how much data is on that page.

aha, I see. My assumption that the page headers weren't a needed part
of the trace output was throwing off my analysis.

> I guess I could have had the info->spare just read the full page, and
> then other readers would just read the next page.

I don't think multiple readers a use case we're concerned about, so
either way as far as I'm concerned.

>> Even when reading >=4096 bytes, something is funny:
>>
>> $ dd bs=4096 if=$ftrace/per_cpu/cpu0/trace_pipe_raw 2>/dev/null | wc -c
>> 118784
>>
>> That's 116kB. I expect 100kb to allocate (102400+4087)/4088 = 26
>> pages, or 104kb-worth of pages. 116kB is about 28 pages.
>
> Hmm, isn't page data 4080, not 4088, since it has 2, 8 byte items in it.
> Timestamp and atomic (on 64bit). 4096 - 16 = 4080. But still the numbers
> are not much different.

oops, yeah. I rounded 2*8 = 8  ;)

> Note, when I did it, I got:
>
> $ dd if=/debug/tracing/per_cpu/cpu0/trace_pipe_raw of=/tmp/dat bs=4096
> 27+0 records in
> 27+0 records out
> 110592 bytes (111 kB) copied, 0.00302891 s, 36.5 MB/s
>
> $ cat /debug/tracing/buffer_size_kb
> 100
>
> Ah, running hexdump -C, I got this at the end:
>
> 00019c80  62 57 00 00 22 d1 09 81  ff ff ff ff 76 d1 09 81  |bW.."Ñ..ÿÿÿÿvÑ..|
> 00019c90  ff ff ff ff 00 00 00 00  00 00 00 00 00 00 00 00  |ÿÿÿÿ............|
> 00019ca0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> *
> 0001a000  d8 32 b6 7e ed 53 05 00  24 00 00 00 00 00 00 00  |Ø2¶~íS..$.......|
> 0001a010  a8 36 00 00 01 00 00 00  ca 0b 00 00 ff ff ff ff  |š6......Ê...ÿÿÿÿ|
> 0001a020  00 00 00 00 6a d1 09 81  ff ff ff ff 68 26 16 81  |....jÑ..ÿÿÿÿh&..|
> 0001a030  ff ff ff ff 00 00 00 00  00 00 00 00 00 00 00 00  |ÿÿÿÿ............|
> 0001a040  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> *
> 0001b000
>
> I don't know why it added that last page. I'll have to look into this.

Thanks for taking a look!

I'm actually seeing up to 3 extra pages (29 records) frequently,
although it varies. I even just got 30 pages.

aha, check this out though, looking at all the page headers:

$ hexdump -C /tmp/trace_raw | grep '^[0-9a-f]*000 '
00000000  7d 9a 19 9a fd 01 00 00  74 0d 00 00 00 00 00 00  |}...�...t.......|
00001000  12 22 4a 71 01 02 00 00  38 00 00 00 00 00 00 00  |."Jq....8.......|
00002000  62 99 60 d7 01 02 00 00  b8 0f 00 c0 ff ff ff ff  |b.`�....�..�����|
# negative commit count? or, notice this is the third page.
# Maybe there's garbage at the beginning, rather than the end.
00003000  e4 cb e2 dc 01 02 00 00  f0 0f 00 00 00 00 00 00  |����....�.......|
# <snip>
00019000  7a 79 01 ef 01 02 00 00  dc 0f 00 00 00 00 00 00  |zy.�....�.......|
0001a000  c7 51 05 ef 01 02 00 00  c0 0f 00 00 00 00 00 00  |�Q.�....�.......|
0001b000  af fe 1b ef 01 02 00 00  34 08 00 00 00 00 00 00  |��.�....4.......|
0001c000  49 f3 1f ef 01 02 00 00  2c 00 00 00 00 00 00 00  |I�.�....,.......|

Interestingly, they all have valid-looking timestamps (in that they
are monotonic), even before the negative commit count.

Here's the one where I got 30 pages:

00000000  1d f5 1f ef 01 02 00 00  68 07 00 00 00 00 00 00  |.�.�....h.......|
00000770  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00001000  bf 04 59 1f 4a 02 00 00  28 00 00 00 00 00 00 00  |�.Y.J...(.......|
00001030  00 00 00 00 ff ff ff ff  00 00 00 00 00 00 00 00  |....����........|
00001040  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00002000  6b 0b 59 1f 4a 02 00 00  28 00 00 00 00 00 00 00  |k.Y.J...(.......|
00002030  ff ff ff ff 1d 00 00 00  00 00 00 00 00 00 00 00  |����............|
00002040  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00003000  df b5 6d 68 4a 02 00 00  d4 0f 00 c0 ff ff ff ff  |ߵmhJ...�..�����|
# negative commit count in the 4th page this time. I see a pattern here...
# also, lots of zeroes in the first 3 pages.
00004000  94 9b be 6c 4a 02 00 00  d4 0f 00 00 00 00 00 00  |..�lJ...�.......|
# <snip>
00019000  88 69 4f 91 4a 02 00 00  cc 0f 00 00 00 00 00 00  |.iO.J...�.......|
0001a000  6f 4d ab 97 4a 02 00 00  e4 0f 00 00 00 00 00 00  |oM�.J...�.......|
0001b000  4c 98 2d 9e 4a 02 00 00  d4 0f 00 00 00 00 00 00  |L.-.J...�.......|
0001c000  f0 92 57 a3 4a 02 00 00  6c 0e 00 00 00 00 00 00  |�.W�J...l.......|
0001d000  6e f9 24 a4 4a 02 00 00  2c 00 00 00 00 00 00 00  |n�$�J...,.......|

I don't know what this means yet. Is a negative commit count ever
expected? ring_buffer_read_page does add 1<<30 and 1<<31 when there
are events missing, but I don't think that would result in these bit
patterns.

That's enough for today. I'll investigate more tomorrow.

>> Looking at the code for tracing_buffers_read() and
>> ring_buffer_read_page(), there seems to be a disconnect.
>>
>> ring_buffer_read_page can consume less than one page if it was in the
>> middle of the buffer, such as when would happen after userspace only
>> asks for 1k. It returns the offset of the start of what it cosumed,
>
> Actually, we don't do that anymore. We either return < 0 on error or
> zero. We always add to the 0 offset. The comment needs to be fixed.
>
>> and the end is put in the returned bpage->commit. However,
>> ring_buffer_data_page is not exposed outside of ring_buffer.c.
>> Furthermore, tracing_buffers_read ignores the return value, except to
>> check for error.
>>
>> Basically, I think tracing_buffers_read was forgotten when the ring
>> buffer got headers in the buffer pages. It looks like it still expects
>> whole pages to have valid tracing data.
>
> Yep, it does, and ring_buffer_read_page() adds zero to the rest of the
> page.
>
>
>>
>> I was working on a fix, but, how is trace_pipe_raw supposed to work?
>> I'm not sure if it's supposed to output full pages including the page
>> headers, or just data. I'm guessing the latter?
>
> Nope, the former, because we need it to be full pages.
>
> -- Steve
>
>
>
