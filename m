Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232Ab2F0MqM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 08:46:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32777 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755288Ab2F0MqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 08:46:10 -0400
X-Authority-Analysis: v=2.0 cv=ZuBv2qHG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=XOt6boVe9ZQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=1XWaLZrsAAAA:8 a=a9EbR5VdlrawaFaqM2sA:9 a=PUjeQqilurYA:10 a=UTB_XpHje0EA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1340801169.16702.9.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] ring-buffer: fix uninitialized read_stamp
From: Steven Rostedt <rostedt@goodmis.org>
To: David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org, vnagarnaik@google.com
Date: Wed, 27 Jun 2012 08:46:09 -0400
In-Reply-To: <CAJL_eksSXfq4RVZ_rHagpgex96Jq=QkpiW93hD7M5xoYscq2jQ@mail.gmail.com>
References: <CAJL_eku9byV+Uk-5boR52HLEO0D-++2h_y=PeaaQG_PrCuALhQ@mail.gmail.com>
	 <1340060577-9112-1-git-send-email-dhsharp@google.com>
	 <1340293617.27036.177.camel@gandalf.stny.rr.com>
	 <CAJL_ekt-iVgh-GG_PoY_eqobgdUGf_L4TH6zmVa4D9oBgohCsA@mail.gmail.com>
	 <1340407900.27036.275.camel@gandalf.stny.rr.com>
	 <CAJL_eksV6R2Je+qoBYAtvZ6pSb8d6HdNiBic7AH0TG3u2R0FzQ@mail.gmail.com>
	 <CAJL_eksSXfq4RVZ_rHagpgex96Jq=QkpiW93hD7M5xoYscq2jQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-26 at 17:35 -0700, David Sharp wrote:
> On Fri, Jun 22, 2012 at 6:27 PM, David Sharp <dhsharp@google.com> wrote:
> > On Fri, Jun 22, 2012 at 4:31 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> >>
> >> Now I think you may understand my patch.
> >
> > Yeah, mostly. At least enough that I think it's worth testing. But Monday.
> 
> I got around to testing your patch today, and it fixes the issue. No
> bad-looking timestamps in 40 runs, whereas could reproduce within 3
> runs before. Do you want me to send you a fresh patch, or just use the
> one you have?

I rather use this one for two reasons.

1) it limits the places where read_stamp is updated. And I rather not
add an update because "it fixes an anomaly".

2) I think it is wrong to force the writer on the reader page when no
write has been made. There's some side effects that this causes. One is
that if you do a read with no write, and then do nothing, it forces the
writer on that page. Now if a lot of writes happen (function tracing),
the writes that were on the reader page are never overwritten when the
buffer is full. Then you get a page of very old data, followed by a
buffer full of new data.

-- Steve

> 
> >>> On Thu, Jun 21, 2012 at 8:56 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> >>> > Does something like this work for you. Note, this is totally untested!
> >>> >
> >>> > -- Steve
> >>> >
> >>> > diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> >>> > index ad0239b..5943044 100644
> >>> > --- a/kernel/trace/ring_buffer.c
> >>> > +++ b/kernel/trace/ring_buffer.c
> >>> > @@ -3246,6 +3246,10 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
> >>> >        if (cpu_buffer->commit_page == cpu_buffer->reader_page)
> >>> >                goto out;
> >>> >
> >>> > +       /* Don't bother swapping if the ring buffer is empty */
> >>> > +       if (rb_num_of_entries(cpu_buffer) == 0)
> >>> > +               goto out;
> >>> > +
> >>> >        /*
> >>> >         * Reset the reader page to size zero.
> >>> >         */


