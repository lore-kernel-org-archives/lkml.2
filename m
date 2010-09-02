Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab0IBOjJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 10:39:09 -0400
Received: from smtp-out.google.com ([216.239.44.51]:11115 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754373Ab0IBOjH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 10:39:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CcmGtHLRqcOc8/dj9GuHtpHdhAEJPPvCLEPztpcYE+Cuy05U/74cpybibRcCr63OgN
         Nycxk4y25GEVHc0Gdv9Q==
MIME-Version: 1.0
In-Reply-To: <20100902141900.GG4879@redhat.com>
References: <AANLkTimA-AZWJugaLR3VPGVhBaJid=t=a1rPVNUE_8Dh@mail.gmail.com>
	<20100901145728.GM22783@erda.amd.com>
	<AANLkTikOaCL8FqQuUQsYPxm19WZOdarp8AMAugN0mnqQ@mail.gmail.com>
	<20100902141900.GG4879@redhat.com>
Date: Thu, 2 Sep 2010 16:39:02 +0200
Message-ID: <AANLkTin2KVPpkQWUa_GQ66q+wvZpfYHOKAfWbG-+K5FD@mail.gmail.com>
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

Don,

On Thu, Sep 2, 2010 at 4:19 PM, Don Zickus <dzickus@redhat.com> wrote:
> On Thu, Sep 02, 2010 at 10:13:19AM +0200, Stephane Eranian wrote:
>> Robert,
>>
>> Do you have the test program you used to test this?
>> I believe the NHM hack does not solve the problem, it
>> just makes it harder to appear.
>
> Could be.
>
>>
>> I suspect the real issue is that the GLOBAL_STATUS
>> bitmask cannot be trusted. I'd like to verify this.
>>
>> Has the problem appear only on Nehalem or also on
>> Westmere?
>
> I was able to duplicate on
>
> Intel(R) Core(TM) i5 CPU         650  @ 3.20GHz
> Intel(R) Xeon(R) CPU           X5560  @ 2.80GHz
>
I managed to reproduce on core i7 860 (without patch4).
Looking at the code again, I am dubious you ever execute
the retry goto. If the PMU is disabled and you've just
cleared the OVF_STAT, then I don't see where the new
overflows would come from. But that's a separate problem.

One thing I did is to compare status obtained via OVFL_STATUS
with one that I build manually by inspecting each individual
counter. The two returned bitmasks should always be identical
(with PEBS disabled).  When I got the spurious NMI, it did not
trip my status validation. So the OVFL_STATUS is valid.

I found something else that looked fishy. I am experimenting
with it. I will report back.


> with just running 'perf top' for about 60 seconds.
>
> You would need the first three patches to expose the problem.
>
> Reading the code, it seemed like the perf counters should be disabled and
> this patch should be unecessary, but after playing around with the code
> for a few hours, I came up with this patch to trap the issue.
>
> I read through the cpu errata and could not find anything related but I
> might have missed something.
>
> I am willing to help test if you have a more targeted patch.
>
Thanks.
