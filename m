Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984Ab1EJSzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 14:55:38 -0400
Received: from smtp-out.google.com ([74.125.121.67]:52804 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab1EJSzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 14:55:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=fS9WOlQ/W1U8ixAgyEZCgdr/CTTCX/3fb+14xAx0yU3qaHDu28ET2QMHcz/UXnwloH
         9JKZDop6zFnFMMDNucCA==
MIME-Version: 1.0
In-Reply-To: <4DC90AE8.101@parallels.com>
References: <4DAFD0B1.9090603@parallels.com>
	<20110421064150.6431.84511.stgit@localhost6>
	<20110421124424.0a10ed0c.akpm@linux-foundation.org>
	<4DB0FE8F.9070407@parallels.com>
	<alpine.LSU.2.00.1105031223120.9845@sister.anvils>
	<4DC4D9A6.9070103@parallels.com>
	<alpine.LSU.2.00.1105071621330.3668@sister.anvils>
	<4DC691D0.6050104@parallels.com>
	<alpine.LSU.2.00.1105081234240.15963@sister.anvils>
	<4DC90AE8.101@parallels.com>
Date: Tue, 10 May 2011 11:55:26 -0700
Message-ID: <BANLkTi=pev65quykAhp6SeisxyW7=A3fGA@mail.gmail.com>
Subject: Re: [PATCH v2] tmpfs: fix race between umount and writepage
From: Hugh Dickins <hughd@google.com>
To: Konstantin Khlebnikov <khlebnikov@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 2:52 AM, Konstantin Khlebnikov
<khlebnikov@parallels.com> wrote:
> Hugh Dickins wrote:
>>
>> On Sun, 8 May 2011, Konstantin Khlebnikov wrote:
>>>
>>> Ok, I can test final patch-set on the next week.
>>> Also I can try to add some swapoff test-cases.
>>
>> That would be helpful if you have the time: thank you.
>
> I Confirm, patch 1/3 really fixes race between writepage and umount, as
> expected.

Good, thank you (but that path was identical to what you'd already tested).

>
> In patch 2/3: race-window between unlock_page and iput extremely small.

(I should clarify that the main race window is actually much wider
than that.  That page lock is only effective at holding off
shmem_evict_inode() while the page is in the file's pagecache -
between the (old positioning of) mutex_unlock(&shmem_swaplist_mutex)
and the add_to_page_cache_locked(), the page is just in swapcache and
so not recognizably attached to the file: shmem_evict_inode() will
call shmem_truncate_range(), and that would find the swp_entry_t, but
it frees it with a free_swap_and_cache() - which does not wait if it
cannot trylock the page.)

> My test works fine in parallel with thirty random swapon-swapoff,
> but it works without this patch too, thus I cannot catch this race.

Thanks for trying.  Given my difficulty in reproducing your umount
case, I'm not at all surprised that you didn't manage to reproduce
this swapoff case.  Indeed, I didn't even try to reproduce it myself:
I just saw the theoretical possibility once you'd warned me of
igrab(), and tested that this igrab-less approach works as well as the
old approach, without risking that race.

>
> I apply patch 3/3 too, but have not tested this case.

Fine, that part I could reproduce fairly easily for myself, and the
fix tested out fine.

Thanks,
Hugh
