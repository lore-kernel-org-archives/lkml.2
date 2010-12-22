Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822Ab0LVXrt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 18:47:49 -0500
Received: from smtp-out.google.com ([216.239.44.51]:23347 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139Ab0LVXrs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 18:47:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=WBY+2hJuwlbCGwiIWqv/ikRjMKyyYxYo0QrlEWrkCHsyz+7JYV7p4rjb59P4MIAxzi
         TVD5MpYHxsevxXsDSIHg==
MIME-Version: 1.0
In-Reply-To: <AANLkTikkwQC8pHPw=dvf5h++MnSOo9YY0dagNhv6s11B@mail.gmail.com>
References: <AANLkTik6RfWWqjtuBUWRGZ0e+DHHm02opR9FAQJPdTR1@mail.gmail.com>
 <1292903569.22905.123.camel@gandalf.stny.rr.com> <AANLkTin7nLrRPc9qGjdjHbeVDDWiJjAiYyb-L=gH85bx@mail.gmail.com>
 <AANLkTikkwQC8pHPw=dvf5h++MnSOo9YY0dagNhv6s11B@mail.gmail.com>
From: David Sharp <dhsharp@google.com>
Date: Wed, 22 Dec 2010 15:47:24 -0800
Message-ID: <AANLkTinFjuFFAp3ayeF8L5x813248zeVJbPbgKK02Rjv@mail.gmail.com>
Subject: Re: ftrace: trace_pipe_raw interface broken
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Michael Rubin <mrubin@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 3:23 PM, David Sharp <dhsharp@google.com> wrote:
> On Mon, Dec 20, 2010 at 9:59 PM, David Sharp <dhsharp@google.com> wrote:
>> On Mon, Dec 20, 2010 at 7:52 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>>> Hi David,
>>>
>>> Thanks for the report.
>>>
>>> On Mon, 2010-12-20 at 18:43 -0800, David Sharp wrote:
>>>> trace_pipe_raw doesn't work correctly, I think because
>>>> tracing_buffers_read() uses ring_buffer_read_page() incorrectly.
>>>>
>>>> In particular, if you read less than one page at a time, then you get
>>>> much more data than expected from the ring buffer:
>>>>
>>>> $ ftrace=/sys/kernel/debug/tracing
>>>> $ echo 0 > $ftrace/tracing_enabled
>>>> $ echo 1 > $ftrace/events/enable
>>>> $ echo > $ftrace/trace  # reset
>>>> $ echo 100 > $ftrace/buffer_size_kb
>>>> $  # generate lots of events:
>>>> $ echo 1 > $ftrace/tracing_enabled &&  ls -laR /proc/ > /dev/null 2>&1
>>>> && echo 0 > $ftrace/tracing_enabled
>>>> $ dd bs=1024 if=$ftrace/per_cpu/cpu0/trace_pipe_raw 2>/dev/null | wc -c
>>>> 675840
>>>>
>>>> That's significantly more data than the buffer could possibly contain.
>>>> Further shrinking bs increases the amount of data output even more.
>>>
>>> Yep that's a side effect. What happens is that we always read a "full
>>> page" even if we do not read in page size chunks. If we read 100 bytes,
>>> it will read a header, and all the events that fit inside that 100
>>> bytes, and then return a full page with the header, the 100 bytes -
>>> header size, and the rest of the page filled with zeros.
>>>
>>> Do a:
>>>
>>>        hexdump -C outputfile
>>>
>>> and you'll see a lot of "zeros". The reason for this is to keep all
>>> reads in pagesize chunks. If you read only 100 bytes of data, I still
>>> need to keep that page aligned in the output. The reason I do this is in
>>> case there's two readers. I don't want one to read part of a page that
>>> includes the header, and then the other reads the rest of the page. The
>>> header tells you how much data is on that page.
>>
>> aha, I see. My assumption that the page headers weren't a needed part
>> of the trace output was throwing off my analysis.
>>
>>> I guess I could have had the info->spare just read the full page, and
>>> then other readers would just read the next page.
>>
>> I don't think multiple readers a use case we're concerned about, so
>> either way as far as I'm concerned.
>>
>>>> Even when reading >=4096 bytes, something is funny:
>>>>
>>>> $ dd bs=4096 if=$ftrace/per_cpu/cpu0/trace_pipe_raw 2>/dev/null | wc -c
>>>> 118784
>>>>
>>>> That's 116kB. I expect 100kb to allocate (102400+4087)/4088 = 26
>>>> pages, or 104kb-worth of pages. 116kB is about 28 pages.
>>>
>>> Hmm, isn't page data 4080, not 4088, since it has 2, 8 byte items in it.
>>> Timestamp and atomic (on 64bit). 4096 - 16 = 4080. But still the numbers
>>> are not much different.
>>
>> oops, yeah. I rounded 2*8 = 8  ;)
>>
>>> Note, when I did it, I got:
>>>
>>> $ dd if=/debug/tracing/per_cpu/cpu0/trace_pipe_raw of=/tmp/dat bs=4096
>>> 27+0 records in
>>> 27+0 records out
>>> 110592 bytes (111 kB) copied, 0.00302891 s, 36.5 MB/s
>>>
>>> $ cat /debug/tracing/buffer_size_kb
>>> 100
>>>
>>> Ah, running hexdump -C, I got this at the end:
>>>
>>> 00019c80  62 57 00 00 22 d1 09 81  ff ff ff ff 76 d1 09 81  |bW.."Ñ..ÿÿÿÿvÑ..|
>>> 00019c90  ff ff ff ff 00 00 00 00  00 00 00 00 00 00 00 00  |ÿÿÿÿ............|
>>> 00019ca0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
>>> *
>>> 0001a000  d8 32 b6 7e ed 53 05 00  24 00 00 00 00 00 00 00  |Ø2¶~íS..$.......|
>>> 0001a010  a8 36 00 00 01 00 00 00  ca 0b 00 00 ff ff ff ff  |š6......Ê...ÿÿÿÿ|
>>> 0001a020  00 00 00 00 6a d1 09 81  ff ff ff ff 68 26 16 81  |....jÑ..ÿÿÿÿh&..|
>>> 0001a030  ff ff ff ff 00 00 00 00  00 00 00 00 00 00 00 00  |ÿÿÿÿ............|
>>> 0001a040  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
>>> *
>>> 0001b000
>>>
>>> I don't know why it added that last page. I'll have to look into this.
>>
>> Thanks for taking a look!
>>
>> I'm actually seeing up to 3 extra pages (29 records) frequently,
>> although it varies. I even just got 30 pages.
>>
>> aha, check this out though, looking at all the page headers:
>>
>> $ hexdump -C /tmp/trace_raw | grep '^[0-9a-f]*000 '
>> 00000000  7d 9a 19 9a fd 01 00 00  74 0d 00 00 00 00 00 00  |}...�...t.......|
>> 00001000  12 22 4a 71 01 02 00 00  38 00 00 00 00 00 00 00  |."Jq....8.......|
>> 00002000  62 99 60 d7 01 02 00 00  b8 0f 00 c0 ff ff ff ff  |b.`�....�..�����|
>> # negative commit count? or, notice this is the third page.
>> # Maybe there's garbage at the beginning, rather than the end.
>> 00003000  e4 cb e2 dc 01 02 00 00  f0 0f 00 00 00 00 00 00  |����....�.......|
>> # <snip>
>> 00019000  7a 79 01 ef 01 02 00 00  dc 0f 00 00 00 00 00 00  |zy.�....�.......|
>> 0001a000  c7 51 05 ef 01 02 00 00  c0 0f 00 00 00 00 00 00  |�Q.�....�.......|
>> 0001b000  af fe 1b ef 01 02 00 00  34 08 00 00 00 00 00 00  |��.�....4.......|
>> 0001c000  49 f3 1f ef 01 02 00 00  2c 00 00 00 00 00 00 00  |I�.�....,.......|
>>
>> Interestingly, they all have valid-looking timestamps (in that they
>> are monotonic), even before the negative commit count.
>>
>> Here's the one where I got 30 pages:
>>
>> 00000000  1d f5 1f ef 01 02 00 00  68 07 00 00 00 00 00 00  |.�.�....h.......|
>> 00000770  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
>> *
>> 00001000  bf 04 59 1f 4a 02 00 00  28 00 00 00 00 00 00 00  |�.Y.J...(.......|
>> 00001030  00 00 00 00 ff ff ff ff  00 00 00 00 00 00 00 00  |....����........|
>> 00001040  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
>> *
>> 00002000  6b 0b 59 1f 4a 02 00 00  28 00 00 00 00 00 00 00  |k.Y.J...(.......|
>> 00002030  ff ff ff ff 1d 00 00 00  00 00 00 00 00 00 00 00  |����............|
>> 00002040  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
>> *
>> 00003000  df b5 6d 68 4a 02 00 00  d4 0f 00 c0 ff ff ff ff  |ߵmhJ...�..�����|
>> # negative commit count in the 4th page this time. I see a pattern here...
>> # also, lots of zeroes in the first 3 pages.
>> 00004000  94 9b be 6c 4a 02 00 00  d4 0f 00 00 00 00 00 00  |..�lJ...�.......|
>> # <snip>
>> 00019000  88 69 4f 91 4a 02 00 00  cc 0f 00 00 00 00 00 00  |.iO.J...�.......|
>> 0001a000  6f 4d ab 97 4a 02 00 00  e4 0f 00 00 00 00 00 00  |oM�.J...�.......|
>> 0001b000  4c 98 2d 9e 4a 02 00 00  d4 0f 00 00 00 00 00 00  |L.-.J...�.......|
>> 0001c000  f0 92 57 a3 4a 02 00 00  6c 0e 00 00 00 00 00 00  |�.W�J...l.......|
>> 0001d000  6e f9 24 a4 4a 02 00 00  2c 00 00 00 00 00 00 00  |n�$�J...,.......|
>>
>> I don't know what this means yet. Is a negative commit count ever
>> expected? ring_buffer_read_page does add 1<<30 and 1<<31 when there
>> are events missing, but I don't think that would result in these bit
>> patterns.
>>
>> That's enough for today. I'll investigate more tomorrow.
>
> I did a test that yielded some interesting insights:
>
> $ # write the current time to trace_mark continuously from cpu0:
> $ taskset -c 0 sh -c 'while true ; do echo "time: $(date +%s.%N)" \
>  > /sys/kernel/debug/tracing/trace_marker ; done' &
> $ # Let the buffer fill, and note the start and end times:
> $ echo "start: $(date +%s.%N)" ; echo 1 > $ftrace/tracing_enabled ; sleep 12 ; \
>  echo 0 > $ftrace/tracing_enabled ; echo "end:   $(date +%s.%N)"
> start: 1293051826.630452621
> end:   1293051838.634052658
> $ # gather result
> $ dd bs=4096 if=$ftrace/per_cpu/cpu0/trace_pipe_raw of=/tmp/trace_raw
> 30+0 records in
> 30+0 records out
> 122880 bytes (123 kB) copied, 0.000300114 s, 409 MB/s
>
> Okay, 30 pages. 4 too many, but I've seen that before.
>
> Now, the data. Page 1:
>
> 00000000  61 17 63 55 ab 82 00 00  ac 0f 00 00 00 00 00 00  |a.cU�...�.......|
> 00000010  1e 6c b4 f7 04 01 00 00  0c 00 00 00 05 00 00 00  |.l��............|
> 00000020  66 44 00 00 ff ff ff ff  00 00 00 00 00 00 00 00  |fD..����........|
> 00000030  74 69 6d 65 3a 20 31 32  39 33 30 35 31 38 32 36  |time: 1293051826|
> 00000040  2e 36 33 31 32 34 31 31  36 39 0a 00 0c 00 00 00  |.631241169......|
>
> okay, a small time lag (789 microsec) before the trace starts. (If
> you're asking why you're seeing the beginning of the trace and how
> there could have been no overflow, you're in the advanced class. I
> didn't realize this until Page 4...)
>
> btw, the trace_marks are occurring on the order of 1ms apart.
>
> Page 1 ends at 0fbc, which fits the 0fac value for "commit" in the page header.
>
> Now, the whole of Page 2:
>
> 00001000  70 25 e0 81 b3 82 00 00  34 00 00 00 00 00 00 00  |p%�.�...4.......|
> 00001010  6c df ff 01 05 00 00 00  66 44 00 00 ff ff ff ff  |l��.....fD..����|
> 00001020  00 00 00 00 00 00 00 00  74 69 6d 65 3a 20 31 32  |........time: 12|
> 00001030  39 33 30 35 31 38 32 36  2e 37 31 32 31 31 34 34  |93051826.7121144|
> 00001040  36 30 0a 00 00 00 00 00  00 00 00 00 00 00 00 00  |60..............|
>
> Only a single event, nothing remarkable about it other than that it is
> on a separate page
>
> Page 3 has only a padding event in it:
>
> 00002000  6b 24 f0 81 b3 82 00 00  10 00 00 00 00 00 00 00  |k$�.�...........|
> 00002010  3d 00 00 00 0c 00 00 00  00 00 00 00 00 00 00 00  |=...............|
>
> So 0x0fac + 0x34 + 0x10 = 0xff0, plus 16 bytes of header makes one
> page. So, it seems that was the real first page of the ring buffer.
> The question is, why did it get split up?
>
> Here's where it gets more interesting. Here's Page 4:
>
> 00003000  25 56 1a cb b5 82 00 00  d8 0f 00 c0 ff ff ff ff  |%V.˵...�..�����|
> 00003010  0c 00 00 00 05 00 00 00  66 44 00 00 ff ff ff ff  |........fD..����|
> 00003020  00 00 00 00 00 00 00 00  74 69 6d 65 3a 20 31 32  |........time: 12|
> 00003030  39 33 30 35 31 38 33 36  2e 35 34 34 36 31 30 31  |93051836.5446101|
> 00003040  37 39 0a 00 8c c7 0f 02  05 00 00 00 66 44 00 00  |79...�......fD..|
>
> Remember the last event on page 2 was at 1293051826.712114460. There
> are 10 seconds missing!
>
> Also, still seeing that strange value for "commit" (0xffffffff0c000fd8).
>
> Between the first event on Page4 and the last event, the events seem
> to be contiguous, very roughly 1msec apart.
>
> The last event of the trace is the only event on the last page:
>
> 0001d000  50 dc 41 47 b6 82 00 00  34 00 00 00 00 00 00 00  |P�AG�...4.......|
> 0001d010  2c b7 1a 02 05 00 00 00  66 44 00 00 ff ff ff ff  |,�......fD..����|
> 0001d020  00 00 00 00 00 00 00 00  74 69 6d 65 3a 20 31 32  |........time: 12|
> 0001d030  39 33 30 35 31 38 33 38  2e 36 33 31 38 37 38 37  |93051838.6318787|
> 0001d040  39 34 0a 00 00 00 00 00  00 00 00 00 00 00 00 00  |94..............|
>
> That's at 1293051838.631878794, compared to the recorded "end" time
> 1293051838.634052658 (diff is 2,173 microsec). So, that very likely is
> the real end of the trace.
>
> This leads to a theory that this has something to do with overflow:
>
> $ cat per_cpu/cpu0/stats
> entries: 0
> overrun: 16770
> commit overrun: 0
>
> 16770 events where each event is on the order of 1msec apart roughly
> accounts for 10 seconds of missing time.
>
> So, it seems that the ring buffer started out writing to what
> eventually became the initial reader page. But then as overflow
> occurs, that page does not get overwritten.
>
> There are three outstanding questions in my mind:
> 1) Why are we seeing the "first" page, which either should have been
> overwritten, or should not be seen at all?
> 2) As before: Why the strange "commit" value in the page header for
> the first contiguous-event page (Page 4)?
> 3) Why is that first page getting split up?
>
> I think I have an idea about (3):
>
> in ring_buffer_read_page(), there are three conditions for reading out
> a page on event at a time. One of them is "reader_page ==
> commit_page". That seems plausible for a full ring buffer, but I
> haven't fully groked that.
>
> But, within that path, it seems it should still copy out the whole
> page. But, the loop condition for copying events is "while (len >
> size)" where len is the remaining available size in the
> caller-supplied page, and size is the size of the next event in the
> ring buffer. So, that's off-by-one. if len == size, then there's just
> enough space.
>
> Does this fit? 0x1000 - 0xfbc = 68 bytes for len, but the event in
> Page 2 is 52 bytes... So no. hmm, another question.
>
> But, size is set to "rb_event_ts_length(event)", to ensure space for
> time extend events to be paired with the event after it. Then in the
> next loop, "size" bytes are memcpy'd to the caller-supplied page.
> HOWEVER, the reader is then advanced with rb_advance_reader(), which
> *does not* advance twice for time-extend events. So, the memcpy will
> have copied two events, and "pos" is advanced by "size", and "len" is
> decremented by "size", but then the reader is advanced by *only* one
> event! This means that time-extend events should be followed by
> duplicate events. Sure enough, the first event on the Page 1 is a time
> extend, and it is followed by two identical events (I only show the
> first word of the duplicate above, though).
>
> A patch for these two problems is incoming.
>
> Sorry for these long messages. If this is too much detail, I can scale it back.
>

Okay. Now I've tested with the patch (sent separately).

- Extra pages are only seen when I don't reset the buffer before
running the test again.
- So far, when I've seen extra pages, I've only seen one extra page.
- When there's an extra page, it's still full of pre-overflow data, as
opposed to, say, data from the previous test.
