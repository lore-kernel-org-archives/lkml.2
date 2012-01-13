Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758147Ab2AMNUm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 08:20:42 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:47016 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753197Ab2AMNUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 08:20:41 -0500
MIME-Version: 1.0
In-Reply-To: <1326099318.2442.39.camel@twins>
References: <20120106181912.GA5564@quad>
	<1325955818.2442.29.camel@twins>
	<CABPqkBSmDHHJsSQo8hhe0a9zxr+YX1yWNr3hZoWEU-OShu7=wA@mail.gmail.com>
	<1326099318.2442.39.camel@twins>
Date: Fri, 13 Jan 2012 14:20:39 +0100
Message-ID: <CABPqkBROHTRb24KiuJW4kMxS_FRA347N0LBTri3fkoRuVwCwJw@mail.gmail.com>
Subject: Re: [PATCH] perf_events: proposed fix for broken intr throttling (v2)
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, gleb@redhat.com, mingo@elte.hu,
        asharma@fb.com, vince@deater.net, wcohen@redhat.com
X-System-Of-Record: true
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Some update on this. I took your patch and modify it to implement the breakdown
unthrottle, adjust freq, multiplexing without requiring two passes
over the events
for the first two. That seems to work fine.

However, there is another major issue: the throttling logic does not
honor the max
rate. I set a lower rate 3000 and sampled with fixed periods creating more than
3000 samples/s, I got throttled/unthrottled, but over the 10s run,
when I compare
/proc/interrupts before and after, I did get a lot more than 3000 intr
x 10s. I have
not yet had time to investigate but I suspect it has to do with the
fact the events
may get unthrottled sooner than in the next timer tick. Will look at
this again next
week.


On Mon, Jan 9, 2012 at 9:55 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Sun, 2012-01-08 at 00:11 +0100, Stephane Eranian wrote:
>> I'll look into that one. But at first glance, it does not address the issue
>> of adjusting the period at each timer tick. Only multiplexing (rotation) should
>> happen at the multiplier rate.
>
> Correct, it only pokes at the throttle stuff. For the freq stuff we can
> remain using the nr_freq count to see if we need the iteration.
>
> But yeah, I think that separation you did makes sense.
