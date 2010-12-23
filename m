Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387Ab0LWXGn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 18:06:43 -0500
Received: from smtp-out.google.com ([216.239.44.51]:24911 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab0LWXGm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 18:06:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=aCBgOI5YXwbZBURBJyL4LO6LIIU+M5gOGV7DyydydlF1LPbfAqGqFBeWFrKiABx4ox
         JBRqI9JlKiH4X09USXSw==
MIME-Version: 1.0
In-Reply-To: <1293119853.22802.33.camel@gandalf.stny.rr.com>
References: <AANLkTik6RfWWqjtuBUWRGZ0e+DHHm02opR9FAQJPdTR1@mail.gmail.com>
 <1292903569.22905.123.camel@gandalf.stny.rr.com> <AANLkTin7nLrRPc9qGjdjHbeVDDWiJjAiYyb-L=gH85bx@mail.gmail.com>
 <AANLkTikkwQC8pHPw=dvf5h++MnSOo9YY0dagNhv6s11B@mail.gmail.com>
 <AANLkTinFjuFFAp3ayeF8L5x813248zeVJbPbgKK02Rjv@mail.gmail.com>
 <AANLkTinEFVeVfMj9HgfO90wHVgCrzK+RSaDyXqeJuHUh@mail.gmail.com> <1293119853.22802.33.camel@gandalf.stny.rr.com>
From: David Sharp <dhsharp@google.com>
Date: Thu, 23 Dec 2010 15:06:18 -0800
Message-ID: <AANLkTi=_VJcDmpdfy=nfo_771iHjdVHTHnciUe8DrZme@mail.gmail.com>
Subject: Re: ftrace: trace_pipe_raw interface broken
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Michael Rubin <mrubin@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 23, 2010 at 7:57 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> Hi David,
>
> Thanks for looking deeper into this.
>
> On Wed, 2010-12-22 at 16:37 -0800, David Sharp wrote:
>
>> Regarding the strange "commit" values:
>>
>> I noticed just now that it appears the low 16-bits are the correct
>> value for "commit", bits 16-31 are c000, and bits 32-63 are ffffffff.
>
> Ah yeah, I use 32bits so it would be the same on both 32 and 64.
>
>>
>> ring_buffer_read_page can store the number of missing events at the
>> end of the page if there is room. It signals it has done so with two
>> bits in commit, bits 30 and 31. That's c0000000. This points to the
>> ffffffff being a signed math problem, because these bits are added
>> using "local_add".
>>
>> Here's how the bits are defined:
>>
>> /* Flag when events were overwritten */
>> #define RB_MISSED_EVENTS      (1 << 31)
>> /* Missed count stored at end */
>> #define RB_MISSED_STORED      (1 << 30)
>>
>> well, those would come out as signed int, and 1<<31 is 0x80000000, aka
>> INT_MIN. When passed to local_add, which takes signed long, that would
>> be sign-extended to 0xffffffff80000000.
>>
>> Well, mystery solved at least. Now, how should it be fixed? Or is this
>> intended behavior?
>
> Not quite intended, but not something to worry about either. We mask off
> the 30 bits to determine the size.

in trace-cmd you mean?

>> By my count that leaves only one mystery: why are we seeing this extra
>> page at the beginning with pre-overflow data?
>
> If you did not reset the buffer, there's a chance that the writer is on
> the reader page. The reader page is always outside the ring buffer, but
> it points into the ring buffer. If this occurs, then you will get the
> reader page data, plus the rest of the ring buffer (which is the full
> size you asked for).

Okay, that's a surprising behavior to me, but resetting the buffer
seems like a fine workaround.

btw, corroborating this is that reading the formatted output of
"trace" also shows the page of pre-overflow data.

Thanks for your help,
d#
