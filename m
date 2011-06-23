Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758775Ab1FWBgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 21:36:39 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51067 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758537Ab1FWBgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 21:36:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=itfp+ns0nHZ1uSPiUvCck3z8MSeXPGDrTgodKXsQkPc5jCKUwJDmZ9xTZqBXdjTlnW
         aHECZi/PpGCNbpwJC+LN1x1LA6YP+r+XVHgvWYbCCLymz8QdmGDZHkl4PKqiClo3xVxE
         qLsW2IaHqooLxoFY4SkaFgsILupt/12bMAHTI=
MIME-Version: 1.0
In-Reply-To: <20110623004404.GE20843@redhat.com>
References: <201106212132.39311.nai.xia@gmail.com>
	<4E01C752.10405@redhat.com>
	<4E01CC77.10607@ravellosystems.com>
	<4E01CDAD.3070202@redhat.com>
	<4E01CFD2.6000404@ravellosystems.com>
	<4E020CBC.7070604@redhat.com>
	<20110622165529.GY20843@redhat.com>
	<BANLkTinRYr9Vg==C-qyCaRmO7C_aQqBPzw@mail.gmail.com>
	<20110622235906.GC20843@redhat.com>
	<BANLkTimc0wETJxS7wFqczroPdS5u7BBEfw@mail.gmail.com>
	<20110623004404.GE20843@redhat.com>
Date: Thu, 23 Jun 2011 09:36:37 +0800
Message-ID: <BANLkTik4+A0owJhKKb27KO0HtQ0v-KzU9g@mail.gmail.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 8:44 AM, Andrea Arcangeli <aarcange@redhat.com> wrote:
> On Thu, Jun 23, 2011 at 08:31:56AM +0800, Nai Xia wrote:
>> On Thu, Jun 23, 2011 at 7:59 AM, Andrea Arcangeli <aarcange@redhat.com> wrote:
>> > On Thu, Jun 23, 2011 at 07:37:47AM +0800, Nai Xia wrote:
>> >> On 2MB pages, I'd like to remind you and Rik that ksmd currently splits
>> >> huge pages before their sub pages gets really merged to stable tree.
>> >> So when there are many 2MB pages each having a 4kB subpage
>> >> changed for all time, this is already a concern for ksmd to judge
>> >> if it's worthwhile to split 2MB page and get its sub-pages merged.
>> >
>> > Hmm not sure to follow. KSM memory density with THP on and off should
>> > be identical. The cksum is computed on subpages so the fact the 4k
>> > subpage is actually mapped by a hugepmd is invisible to KSM up to the
>> > point we get a unstable_tree_search_insert/stable_tree_search lookup
>> > succeeding.
>>
>> I agree on your points.
>>
>> But, I mean splitting the huge page into normal pages when some subpages
>> need to be merged may increase the TLB lookside timing of CPU and
>> _might_ hurt the workload ksmd is scanning. If only a small portion of false
>> negative 2MB pages are really get merged eventually, maybe it's not worthwhile,
>> right?
>
> Yes, there's not threshold to say "only split if we could merge more
> than N subpages", 1 subpage match in two different hugepages is enough
> to split both and save just 4k but then memory accesses will be slower
> for both 2m ranges that have been splitted. But the point is that it
> won't be slower than if THP was off in the first place. So in the end
> all we gain is 4k saved but we still run faster than THP off, in the
> other hugepages that haven't been splitted yet.

Yes, so ksmd is still doing good compared to THP off.
Thanks for making my mind clearer :)

>
>> But, well, just like Rik said below, yes, ksmd should be more aggressive to
>> avoid much more time consuming cost for swapping.
>
> Correct the above logic also follows the idea to always maximize
> memory merging in KSM, which is why we've no threshold to wait N
> subpages to be mergeable before we split the hugepage.
>
> I'm unsure if admins in real life would then start to use those
> thresholds even if we'd implement them. The current way of enabling
> KSM a per-VM (not per-host) basis is pretty simple: the performance
> critical VM has KSM off, non-performance critical VM has KSM on and it
> prioritizes on memory merging.
>
Hmm, yes, you are right.

Thanks,
Nai
