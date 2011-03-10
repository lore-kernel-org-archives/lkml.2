Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab1CJXWT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 18:22:19 -0500
Received: from smtp-out.google.com ([216.239.44.51]:1749 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab1CJXWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 18:22:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=OiJ4X74KYK1klsAUBh4UCniuYlLS/l3muJLMVyLSKV/jg+BhQxuN+MGWxULI4JmqFa
         QGKwZ+jTljrt2S28/X7g==
MIME-Version: 1.0
In-Reply-To: <1299683884.15854.154.camel@gandalf.stny.rr.com>
References: <1291421609-14665-1-git-send-email-dhsharp@google.com>
 <1291421609-14665-5-git-send-email-dhsharp@google.com> <1299627003.20306.94.camel@gandalf.stny.rr.com>
 <20110308.223951.193722389.davem@davemloft.net> <1299683884.15854.154.camel@gandalf.stny.rr.com>
From: David Sharp <dhsharp@google.com>
Date: Thu, 10 Mar 2011 15:21:51 -0800
Message-ID: <AANLkTikKYaxLi-3a-0bdsbQR3scFzhn0txktNd+QPVa3@mail.gmail.com>
Subject: Re: [PATCH 04/15] ftrace: pack event structures.
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        mrubin@google.com
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 9, 2011 at 7:18 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, 2011-03-08 at 22:39 -0800, David Miller wrote:
>> From: Steven Rostedt <rostedt@goodmis.org>
>> Date: Tue, 08 Mar 2011 18:30:03 -0500
>>
>> > I'm going back through this patch set and looking to incorporate it into
>> > 2.6.39. But I know how touchy sparc is with "packed" data structures. Do
>> > you see this patch as hurting sparc?
>> >
>> > I wonder if we should change this to something like:
>> >
>> > #ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
>> > # define do_event_packed __attirbute__((packed))
>> > #else
>> > # define do_event_packed
>> > #endif
>> >
>> > and use "do_event_packed" instead?
>>
>> I think you should elide packed at all costs, and instead tell the compiler
>> what your intentions are by exposing the real types using unions or
>> similar instead of hiding it in an opaque way behind final char[] arrays.
>
> The problem here is not the issue of char[] but because of the way
> ftrace's header was 12 bytes and caused everything that had a 8byte word
> use another 4 bytes to align it.

Not only that, but those extra "4 bytes to align it" have a good
chance of in fact causing the 8 byte word to become *un*aligned, so
it's really just wasted space.

> As I stated in another email, I think
> removing the "int lock_depth" from the ftrace header should solve this.
>
> David (Sharp), the reason for the "packed" was because of that extra 4
> bytes in the ftrace header, right? So removing the lock_depth should fix
> the issues that you've seen?

Yes, I think that should have the same effect. Of course the next time
we come along and remove other useless fields like 'flags' and
'preempt_count', a similar condition could arise.

(Note I don't necessarily think that 'flags' and 'preempt_count' are
useless; although I don't know what they're used for, or why they need
to be in every entry. fwiw, we've taken trace_entry down to 4 bytes of
{unsigned short type; unsigned short pid;}, and we even have plans to
completely remove pid.)

>
> -- Steve
>
>
>
>
