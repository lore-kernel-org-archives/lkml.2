Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373Ab0IJWHb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 18:07:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39665 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751453Ab0IJWH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 18:07:29 -0400
MIME-Version: 1.0
In-Reply-To: <20100910235022.74ec04de@basil.nowhere.org>
References: <1284092586-1179-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1284092586-1179-2-git-send-email-n-horiguchi@ah.jp.nec.com>
 <AANLkTikV9nXxMW8X9Wq+wGaJfzMEAmzTFrDNf8Aq4cTs@mail.gmail.com> <20100910235022.74ec04de@basil.nowhere.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 10 Sep 2010 15:07:08 -0700
Message-ID: <AANLkTinFqM4BSD0jkrqkrNxg-o+3eC6QQ6zq8jKdaLJx@mail.gmail.com>
Subject: Re: [PATCH 1/4] hugetlb, rmap: always use anon_vma root pointer
To: Andi Kleen <andi@firstfloor.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>, Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 10, 2010 at 2:50 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> Btw, why isn't the code in __page_set_anon_rmap() also doing this
>> cleaner version (ie a single "if (PageAnon(page)) return;" up front)?
>
> Perhaps I misunderstand the question, but __page_set_anon_rmap
> should handle Anon pages, shouldn't it?

I'm talking about this:

    if (!exclusive) {
        if (PageAnon(page))
            return;
        anon_vma = anon_vma->root;
    } else {
        .. big bad comment ...
        if (PageAnon(page))
            return;
    }

where both sides of the if-statement start off doing the same thing.

It would be much cleaner to just do

    ... big _comprehensible_ comment ...
    if (PageAnon(page))
        return;

    if (!exclusive)
        anon_vma = anon_vma->root;

which avoids that silly else that just does something that we always do.

The reason I reacted is that Naoya-san's patch did that cleaner
version for the hugetlb case. So when I compared it to the non-hugetlb
case I just went "Ewww..."

                             Linus
