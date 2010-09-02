Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab0IBQSy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 12:18:54 -0400
Received: from smtp-out.google.com ([216.239.44.51]:3749 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755673Ab0IBQSx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 12:18:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=S8UevClqtl3HSZUasH5dm503NPR8Tx41ckaW6+WQVyBoydo1fCfDtWz91dsoUW4syz
         +kE9BwrrzTalqYg64YMw==
MIME-Version: 1.0
In-Reply-To: <20100902154743.GI4879@redhat.com>
References: <AANLkTimA-AZWJugaLR3VPGVhBaJid=t=a1rPVNUE_8Dh@mail.gmail.com>
	<20100901145728.GM22783@erda.amd.com>
	<AANLkTikOaCL8FqQuUQsYPxm19WZOdarp8AMAugN0mnqQ@mail.gmail.com>
	<20100902141900.GG4879@redhat.com>
	<AANLkTin2KVPpkQWUa_GQ66q+wvZpfYHOKAfWbG-+K5FD@mail.gmail.com>
	<20100902154743.GI4879@redhat.com>
Date: Thu, 2 Sep 2010 18:18:49 +0200
Message-ID: <AANLkTinfcekCCcKVZOUd7wfWHQGJ4sf5Cd6GO2Qzfo+9@mail.gmail.com>
Subject: Re: [PATCH 4/4] [x86] perf: fix accidentally ack'ing a second event
 on intel perf counter
From: Stephane Eranian <eranian@google.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Robert Richter <robert.richter@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 2, 2010 at 5:47 PM, Don Zickus <dzickus@redhat.com> wrote:
> On Thu, Sep 02, 2010 at 04:39:02PM +0200, Stephane Eranian wrote:
>> Don,
>>
>> On Thu, Sep 2, 2010 at 4:19 PM, Don Zickus <dzickus@redhat.com> wrote:
>> > On Thu, Sep 02, 2010 at 10:13:19AM +0200, Stephane Eranian wrote:
>> >> Robert,
>> >>
>> >> Do you have the test program you used to test this?
>> >> I believe the NHM hack does not solve the problem, it
>> >> just makes it harder to appear.
>> >
>> > Could be.
>> >
>> >>
>> >> I suspect the real issue is that the GLOBAL_STATUS
>> >> bitmask cannot be trusted. I'd like to verify this.
>> >>
>> >> Has the problem appear only on Nehalem or also on
>> >> Westmere?
>> >
>> > I was able to duplicate on
>> >
>> > Intel(R) Core(TM) i5 CPU         650  @ 3.20GHz
>> > Intel(R) Xeon(R) CPU           X5560  @ 2.80GHz
>> >
>> I managed to reproduce on core i7 860 (without patch4).
>> Looking at the code again, I am dubious you ever execute
>> the retry goto. If the PMU is disabled and you've just
>> cleared the OVF_STAT, then I don't see where the new
>> overflows would come from. But that's a separate problem.
>
> I agree with you, but a printk before the goto proved otherwise! :-)
>

Well, I was wrong about my status validation. I had my test wrong.
I am seeing discrepancies between OVF_STATUS (status)
and manual inspection of each counter (status2) compared to
active_mask (act):

[  489.338564] CPU2 status=0x6 status2=0x4 act=0x7
[  501.484235] CPU2 status=0x6 status2=0x4 act=0x7
[  541.686414] CPU2 status=0x6 status2=0x4 act=0x7
[  561.819575] CPU2 status=0x6 status2=0x4 act=0x7

Note that I have the NMI watchdog on, and running perf record
with 2 events only.

OVF_STATUS reports more than what has actually occurred.
I think that is fine because in the loop there is a check for against
active_mask. Nevertheless, I think there is a problem right there.

I am trying to narrow down when it happens. It seems to occur
only when I start a new perf record session. And possibly when
perf runs on a CPU that is not monitored:

taskset -c 4   perf record -e cycles -e instructions -F 2000 -a  -C 2
-o /dev/null -- sleep 600

> And a printk of the status bit that triggered the goto happened to be the
> same one that we initially cleared.  Like I said when I initially posted
> the patch, I am not sure why it works but it does do something to stem the
> NMI.

Yes, I suspect the clearing does not work well. Let's try to do it
multiple times
in a loop.

>
> There is probably a deeper problem here, I was just trying to get the
> external/unknown nmis working again.
>
I suspect that if we were not to use OVF_STATUS, then we would not need
the back-to-back nmi logic. NMi cannot be nested. So just looking at
the counters
should be reliable (excl. PEBS for now).


> Cheers,
> Don
>
