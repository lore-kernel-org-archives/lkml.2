Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588Ab3AILi0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 06:38:26 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:61438 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757453Ab3AILiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 06:38:24 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFwcDs_R0Cv=RS2LD8ggP3EdvODjENAsXNe126xNwYatOQ@mail.gmail.com>
References: <CAJd=RBCb0oheRnVCM4okVKFvKGzuLp9GpZJCkVY3RR-J=XEoBA@mail.gmail.com>
	<alpine.LNX.2.00.1301061037140.28950@eggly.anvils>
	<CAJd=RBAps4Qk9WLYbQhLkJd8d12NLV0CbjPYC6uqH_-L+Vu0VQ@mail.gmail.com>
	<CA+55aFyYAf6ztDLsxWFD+6jb++y0YNjso-9j+83Mm+3uQ=8PdA@mail.gmail.com>
	<CAJd=RBDTvCcYV8qAd-++_DOyDSypQD4Dvt216pG9nTQnWA2uCA@mail.gmail.com>
	<CA+55aFzfUABPycR82aNQhHNasQkL1kmxLN1rD0DJcByFtead3g@mail.gmail.com>
	<20130108163141.GA27555@shutemov.name>
	<CA+55aFzaTvF7nYxWBT-G_b=xGz+_akRAeJ=U9iHy+Y=ZPo=pbA@mail.gmail.com>
	<20130108173747.GF9163@redhat.com>
	<CA+55aFyG26N3_KiA8_cxLW59xFMJBK8SKfG4qL80NMQ3tdh3Nw@mail.gmail.com>
	<20130108180346.GH9163@redhat.com>
	<CA+55aFwcDs_R0Cv=RS2LD8ggP3EdvODjENAsXNe126xNwYatOQ@mail.gmail.com>
Date: Wed, 9 Jan 2013 19:38:24 +0800
Message-ID: <CAJd=RBAe5D11+L1H3_cgbcCGuCv0-oSLi_uu84f7ozG4yDO7=w@mail.gmail.com>
Subject: Re: oops in copy_page_rep()
From: Hillf Danton <dhillf@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hugh Dickins <hughd@google.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Linux-MM <linux-mm@kvack.org>,
        Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 9, 2013 at 2:21 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Jan 8, 2013 at 10:03 AM, Andrea Arcangeli <aarcange@redhat.com> wrote:
>>
>> It looks very fine to me, but I suggest to move it above the
>> pmd_numa() check because of the newly introduced
>> migrate_misplaced_transhuge_page method relying on pmd_same too.
>
> Hmm. If we need it there, then we need to fix the *later* case of
> pmd_numa() too:
>
>         if (pmd_numa(*pmd))
>                 return do_pmd_numa_page(mm, vma, address, pmd);
>
> Also, and more fundamentally, since do_pmd_numa_page() doesn't take
> the orig_pmd thing as an argument (and re-check it under the
> page-table lock), testing pmd_trans_splitting() on it is pointless,
> since it can change later.
>
A splitting pmd has to be huge first, and we do handle huge pmd already in
the up dozen of lines.
That said, we can igore splitting check in this case, Sir.

Hillf

> So no, moving the check up does *not* make sense, at least not without
> other changes. Because if I read things right, pmd_trans_splitting()
> really has to be done with the page-table lock protection (where "with
> page-table lock protection" does *not* mean that it has to be done
> under the page table lock, but if it is done outside, then the pmd
> entry has to be re-verified after getting the lock - which both
> do_huge_pmd_wp_page() and huge_pmd_set_accessed() correctly do).
>
> Comments?
>
>                 Linus
