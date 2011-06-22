Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758663Ab1FVXht (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 19:37:49 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35387 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758591Ab1FVXhr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 19:37:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PwXSlEcZFXl3zo4MuPFKAsYy3Pg4o/8c3xFxLVeN327izSbmLS/oGZ+aOEydtSeLIQ
         as6g3e2xixxO+qhQi2JOv6XtMNO/AZKz2S4L7VjT3/A99+lSioT4zg7qX3f7KYFUABBK
         74HfqLmTUp03eDoV7aAuY4RaI345sp9i40frA=
MIME-Version: 1.0
In-Reply-To: <20110622165529.GY20843@redhat.com>
References: <201106212055.25400.nai.xia@gmail.com>
	<201106212132.39311.nai.xia@gmail.com>
	<4E01C752.10405@redhat.com>
	<4E01CC77.10607@ravellosystems.com>
	<4E01CDAD.3070202@redhat.com>
	<4E01CFD2.6000404@ravellosystems.com>
	<4E020CBC.7070604@redhat.com>
	<20110622165529.GY20843@redhat.com>
Date: Thu, 23 Jun 2011 07:37:47 +0800
Message-ID: <BANLkTinRYr9Vg==C-qyCaRmO7C_aQqBPzw@mail.gmail.com>
Subject: Re: [PATCH] mmu_notifier, kvm: Introduce dirty bit tracking in spte
 and mmu notifier to help KSM dirty bit tracking
From: Nai Xia <nai.xia@gmail.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, Izik Eidus <izik.eidus@ravellosystems.com>,
        Avi Kivity <avi@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Chris Wright <chrisw@sous-sol.org>,
        linux-mm <linux-mm@kvack.org>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 12:55 AM, Andrea Arcangeli <aarcange@redhat.com> wrote:
> On Wed, Jun 22, 2011 at 11:39:40AM -0400, Rik van Riel wrote:
>> On 06/22/2011 07:19 AM, Izik Eidus wrote:
>>
>> > So what we say here is: it is better to have little junk in the unstable
>> > tree that get flushed eventualy anyway, instead of make the guest
>> > slower....
>> > this race is something that does not reflect accurate of ksm anyway due
>> > to the full memcmp that we will eventualy perform...
>>
>> With 2MB pages, I am not convinced they will get "flushed eventually",
>> because there is a good chance at least one of the 4kB pages inside
>> a 2MB page is in active use at all times.
>>
>> I worry that the proposed changes may end up effectively preventing
>> KSM from scanning inside 2MB pages, when even one 4kB page inside
>> is in active use.  This could mean increased swapping on systems
>> that run low on memory, which can be a much larger performance penalty
>> than ksmd CPU use.
>>
>> We need to scan inside 2MB pages when memory runs low, regardless
>> of the accessed or dirty bits.
>
> I guess we could fallback to the cksum when a THP is encountered
> (repeating the test_and_clear_dirty also wouldn't give the expected
> result if it's repeated on the same hugepmd for the next 4k virtual
> address candidate for unstable tree insertion, so it'd need special
> handling during the virtual walk anyway).
>
> So it's getting a little hairy, skip on THP, skip on EPT, then I
> wonder what is the common case that would be left using it...
>
> Or we could evaluate with statistic how many less pages are inserted
> into the unstable tree using the 2m dirty bit but clearly it'd be less
> reliable, the algorithm really is meant to track the volatility of
> what is later merged, not of a bigger chunk with unrelated data in it.

On 2MB pages, I'd like to remind you and Rik that ksmd currently splits
huge pages before their sub pages gets really merged to stable tree.
So when there are many 2MB pages each having a 4kB subpage
changed for all time, this is already a concern for ksmd to judge
if it's worthwhile to split 2MB page and get its sub-pages merged.
I think the policy for ksmd in a system should be "If you cannot do sth good,
at least do nothing evil". So I really don't think we can satisfy _all_ people.
Get a general method and give users one or two knobs to tune it when they
are the corner cases. How do  you think of my proposal ?

>
> On a side note, khugepaged should also be changed to preserve the
> dirty bit if at least one dirty bit of the ptes is dirty (currently
> the hugepmd is always created dirty, it can never happen for an
> hugepmd to be clean today so it wasn't preserved in khugepaged so far).
>

Thanks for the point that out. This is what I have overlooked!

thanks,
Nai
