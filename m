Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758329Ab1FWAb7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 20:31:59 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37396 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757992Ab1FWAb5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 20:31:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aXn2oPVDO8TBz9COUcgVi56QH106Asscd0VuDwZ+Z6B2t+WqPw0DNc5pL53+g5K4mT
         cPRWJ/eEcbtjdVUvFfktBgdV2tM1C8+ktXpPJyc1XowJRC2tq1qjdyD1lqKCaDBvOpZw
         ez7Q6xWqekDRjUm3d0v9xFbrNormg2I3+F4uo=
MIME-Version: 1.0
In-Reply-To: <20110622235906.GC20843@redhat.com>
References: <201106212055.25400.nai.xia@gmail.com>
	<201106212132.39311.nai.xia@gmail.com>
	<4E01C752.10405@redhat.com>
	<4E01CC77.10607@ravellosystems.com>
	<4E01CDAD.3070202@redhat.com>
	<4E01CFD2.6000404@ravellosystems.com>
	<4E020CBC.7070604@redhat.com>
	<20110622165529.GY20843@redhat.com>
	<BANLkTinRYr9Vg==C-qyCaRmO7C_aQqBPzw@mail.gmail.com>
	<20110622235906.GC20843@redhat.com>
Date: Thu, 23 Jun 2011 08:31:56 +0800
Message-ID: <BANLkTimc0wETJxS7wFqczroPdS5u7BBEfw@mail.gmail.com>
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

On Thu, Jun 23, 2011 at 7:59 AM, Andrea Arcangeli <aarcange@redhat.com> wrote:
> On Thu, Jun 23, 2011 at 07:37:47AM +0800, Nai Xia wrote:
>> On 2MB pages, I'd like to remind you and Rik that ksmd currently splits
>> huge pages before their sub pages gets really merged to stable tree.
>> So when there are many 2MB pages each having a 4kB subpage
>> changed for all time, this is already a concern for ksmd to judge
>> if it's worthwhile to split 2MB page and get its sub-pages merged.
>
> Hmm not sure to follow. KSM memory density with THP on and off should
> be identical. The cksum is computed on subpages so the fact the 4k
> subpage is actually mapped by a hugepmd is invisible to KSM up to the
> point we get a unstable_tree_search_insert/stable_tree_search lookup
> succeeding.

I agree on your points.

But, I mean splitting the huge page into normal pages when some subpages
need to be merged may increase the TLB lookside timing of CPU and
_might_ hurt the workload ksmd is scanning. If only a small portion of false
negative 2MB pages are really get merged eventually, maybe it's not worthwhile,
right?

But, well, just like Rik said below, yes, ksmd should be more aggressive to
avoid much more time consuming cost for swapping.

>
>> I think the policy for ksmd in a system should be "If you cannot do sth good,
>> at least do nothing evil". So I really don't think we can satisfy _all_ people.
>> Get a general method and give users one or two knobs to tune it when they
>> are the corner cases. How do  you think of my proposal ?
>
> I'm neutral, but if we get two methods for deciding the unstable tree
> candidates, the default probably should prioritize on maximum merging
> even if it takes more CPU (if one cares about performance of the core
> dedicated to ksmd, KSM is likely going to be off or scanning at low
> rate in the first place).

I agree with you here.


thanks,

Nai
>
>> > On a side note, khugepaged should also be changed to preserve the
>> > dirty bit if at least one dirty bit of the ptes is dirty (currently
>> > the hugepmd is always created dirty, it can never happen for an
>> > hugepmd to be clean today so it wasn't preserved in khugepaged so far).
>> >
>>
>> Thanks for the point that out. This is what I have overlooked!
>
> No prob. And its default scan rate is very slow compared to ksmd so
> it was unlikely to generate too many false positive dirty bits even if
> you were splitting hugepages through swap.
>
