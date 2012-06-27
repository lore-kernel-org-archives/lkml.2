Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946Ab2F0Af5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 20:35:57 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:53109 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab2F0Af4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 20:35:56 -0400
MIME-Version: 1.0
In-Reply-To: <CAJL_eksV6R2Je+qoBYAtvZ6pSb8d6HdNiBic7AH0TG3u2R0FzQ@mail.gmail.com>
References: <CAJL_eku9byV+Uk-5boR52HLEO0D-++2h_y=PeaaQG_PrCuALhQ@mail.gmail.com>
 <1340060577-9112-1-git-send-email-dhsharp@google.com> <1340293617.27036.177.camel@gandalf.stny.rr.com>
 <CAJL_ekt-iVgh-GG_PoY_eqobgdUGf_L4TH6zmVa4D9oBgohCsA@mail.gmail.com>
 <1340407900.27036.275.camel@gandalf.stny.rr.com> <CAJL_eksV6R2Je+qoBYAtvZ6pSb8d6HdNiBic7AH0TG3u2R0FzQ@mail.gmail.com>
From: David Sharp <dhsharp@google.com>
Date: Tue, 26 Jun 2012 17:35:34 -0700
Message-ID: <CAJL_eksSXfq4RVZ_rHagpgex96Jq=QkpiW93hD7M5xoYscq2jQ@mail.gmail.com>
Subject: Re: [PATCH] ring-buffer: fix uninitialized read_stamp
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, vnagarnaik@google.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 6:27 PM, David Sharp <dhsharp@google.com> wrote:
> On Fri, Jun 22, 2012 at 4:31 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>>
>> Now I think you may understand my patch.
>
> Yeah, mostly. At least enough that I think it's worth testing. But Monday.

I got around to testing your patch today, and it fixes the issue. No
bad-looking timestamps in 40 runs, whereas could reproduce within 3
runs before. Do you want me to send you a fresh patch, or just use the
one you have?

>>> On Thu, Jun 21, 2012 at 8:56 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>>> > Does something like this work for you. Note, this is totally untested!
>>> >
>>> > -- Steve
>>> >
>>> > diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
>>> > index ad0239b..5943044 100644
>>> > --- a/kernel/trace/ring_buffer.c
>>> > +++ b/kernel/trace/ring_buffer.c
>>> > @@ -3246,6 +3246,10 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
>>> >        if (cpu_buffer->commit_page == cpu_buffer->reader_page)
>>> >                goto out;
>>> >
>>> > +       /* Don't bother swapping if the ring buffer is empty */
>>> > +       if (rb_num_of_entries(cpu_buffer) == 0)
>>> > +               goto out;
>>> > +
>>> >        /*
>>> >         * Reset the reader page to size zero.
>>> >         */
