Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932797Ab1ELVae (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 17:30:34 -0400
Received: from smtp-out.google.com ([74.125.121.67]:56340 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932759Ab1ELVad convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 17:30:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Trlk91QJLeGgZM0XxI7ukf7T7E6p4O622LeNqK65Sq90keB0j2yUo7TwqeqqC7jGRK
         6/K/+ymt+FPhSCYDoqXg==
MIME-Version: 1.0
In-Reply-To: <BANLkTik7wQc05OQTHThBbrFhKx2pM1Tx+A@mail.gmail.com>
References: <BANLkTim8mAzZbdOhBodaOFKM5esP-Q+K7g@mail.gmail.com>
	<BANLkTi==OatTqfDbnAmHQA0t2DmokEd-CA@mail.gmail.com>
	<BANLkTik7wQc05OQTHThBbrFhKx2pM1Tx+A@mail.gmail.com>
Date: Thu, 12 May 2011 23:30:16 +0200
Message-ID: <BANLkTimjHiaZ+b03FLb1LX=ycv=cAVyJZw@mail.gmail.com>
Subject: Re: [BUG] perf: bogus correlation of kernel symbols
From: Stephane Eranian <eranian@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The other contradiction, I see, is that you have perf_event paranoia level
and this new kptr masquerading feature which conflict with each
other.

You can be allowed to monitor at the kernel level (paranoid=1, default)
but you cannot correlate symbols:

$ perf record -e cycles:k foo

I suspect if you have this kptr thing turned on, then you need to disallow
monitoring at the kernel level too.



On Thu, May 12, 2011 at 11:07 PM, Stephane Eranian <eranian@google.com> wrote:
> On Thu, May 12, 2011 at 10:31 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> On Thu, May 12, 2011 at 7:48 AM, Stephane Eranian <eranian@google.com> wrote:
>> >
>> > I think there is a serious problem with kernel symbol correlation
>> > with the latest perf in 2.6.39-rc7-tip.
>>
>> Yeah. It's annoying. It's a "perf" bug, though - triggered by
>> /proc/sys/kernel/kptr_restrict being set to 1.
>>
> I did not know about this new masquerading of pointers in /proc/kallsyms.
> That certainly explains the problem.
>
>>
>> The bug is that perf doesn't say "I can't match kernel symbols", but
>> instead does some crazy matching and gives total crap module
>> information (I think it just picks the one that shows up last in
>> /proc/kallsyms).
>>
> But I agree perf must not silently return bogus information. It
> should print a big warning message and/or fallback to printing the raw
> addresses. So much for having perf in the kernel source tree to
> keep things in sync...
>
>>
>> That said, I have considered just reverting the thing that makes
>> kptr_restrict be 1 by default. I do like the security implications of
>> restricting visibility into kernel pointers, but I also think that
>> security rules that make the system less usable are dubious. So I
>> dunno.
>>
> I am not clear as to what people could actually do with the addresses
> taken out of /proc/kallsyms. Looks to me like we've lost functionality
> for the vast majority of users. So maybe the default should be inverted.
>
> I know of a somewhat similar issue with the file descriptor limit which
> people are hitting frequently these days when monitoring apps with lots
> of threads or lots of events in one run on large smp systems.
> That can easily be corrected by again requires root privilege to regain
> the functionality.
>
