Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554Ab2EVRvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 13:51:19 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:54817 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754372Ab2EVRvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 13:51:17 -0400
MIME-Version: 1.0
In-Reply-To: <1337708035.9698.44.camel@twins>
References: <1337081295-10303-1-git-send-email-eranian@google.com>
	<1337081295-10303-5-git-send-email-eranian@google.com>
	<4FB32032.3000509@gmail.com>
	<CABPqkBQyZfSczhAROdH8p0_asy=c2AJho4Kv9wRYabaLNKkURA@mail.gmail.com>
	<4FB67DE5.8050000@gmail.com>
	<20120518171911.GH2636@infradead.org>
	<1337708035.9698.44.camel@twins>
Date: Tue, 22 May 2012 19:51:15 +0200
Message-ID: <CABPqkBTQ=K-=qkgzC0TZPi1xyHtqT6QQroRg-7o0k8rFmjH_Bw@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] perf record: add meta-data support for pipe-mode
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 7:33 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2012-05-18 at 14:19 -0300, Arnaldo Carvalho de Melo wrote:
>
>> PeterZ was the one objecting to adding more userspace only events,
>
> Ah, yes I was ;-)
>
> So uhm the argument was something like perf_event_type is a kernel enum
> and userspace stealing space there is going to get us into trouble
> eventually since userspace doesn't register its types in our enum.
>
Yes, I did not start this but I understand why it was done that way.

The problem is that the headers as they are written to the file need
seeking in the file to update the offset table. That is NOT possible when
you operate in pipe mode. As such you need to inject the header infos
very much like kernel PERF_RECORD_*. That is also why you have
perf inject -b. Buildids are added at the end of the run in file mode,
and that's another seek to the offset table if I recall correctly.

So we need some namespace, so we can tag certain records as
"synthetic" vs. kernel-generated. The way it was done is to assume
that the kernel is not going to have more than 63 type of record types.
That's where we run the risk of overlap one day. But for now we are
at 10 kernel record types.

As such you need to inject certain header infos in the stream of kernel
> Furthermore most (if not all) the userspace thingies were setup (like in
> this case single session meta-data) things. So they don't belong in the
> event stream at all.
>
> From what I can remember all this is somehow related to how data is
> passed to scripts or so and since there's only a single stdin everything
> is stuffed over it.
>
> For the data file we should simply create another section in the header;
> and I think that is how it works these days.
>
> For the script muck, I've really no idea how all that works, but why
> can't you wrap the stuff in another layer; have a header up front that
> says the next N bytes are meta-data and after that there's the regular
> data stream.
>
> Or take some inspiration from one of the many multi-stream stream
> formats out there like mpeg or ogg or whatever.
