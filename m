Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751174Ab1BJFdF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 00:33:05 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44038 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab1BJFdC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 00:33:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LmJauI168dySu3AcVyMEbj1HUiy2B0mFIDGIJQaeHFkhbQfrKa5pCHocZdIUfDG9Nk
         raR7g9nbMifjIwj/QGrgMxvnXCAcwF1fzv1TlBglCPtKN4YQOiLTxTjAoey8DC/btsyP
         eXN1Xo8lh4VrkIO7Ky7lPpXIrVj5qoW9LvoeY=
MIME-Version: 1.0
In-Reply-To: <20110128111833.GD5054@balbir.in.ibm.com>
References: <20110125051003.13762.35120.stgit@localhost6.localdomain6>
	<20110125051015.13762.13429.stgit@localhost6.localdomain6>
	<AANLkTikHLw0Qg+odOB-bDtBSB-5UbTJ5ZOM-ZAdMqXgh@mail.gmail.com>
	<AANLkTi=qXsDjN5Jp4m3QMgVnckoAM7uE9_Hzn6CajP+c@mail.gmail.com>
	<AANLkTinfxXc04S9VwQcJ9thFff=cP=icroaiVLkN-GeH@mail.gmail.com>
	<20110128064851.GB5054@balbir.in.ibm.com>
	<AANLkTikw_j0JJVqEsj1xThoashiOARg+8BgcLKrvkV3U@mail.gmail.com>
	<20110128111833.GD5054@balbir.in.ibm.com>
Date: Thu, 10 Feb 2011 14:33:00 +0900
Message-ID: <AANLkTin4JM6phwy0wuV6fV-i-3UwP_GGmXh1vN=Wz2u=@mail.gmail.com>
Subject: Re: [PATCH 3/3] Provide control over unmapped pages (v4)
From: Minchan Kim <minchan.kim@gmail.com>
To: balbir@linux.vnet.ibm.com
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, npiggin@kernel.dk,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kosaki.motohiro@jp.fujitsu.com, cl@linux.com,
        kamezawa.hiroyu@jp.fujitsu.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for late response.

On Fri, Jan 28, 2011 at 8:18 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> * MinChan Kim <minchan.kim@gmail.com> [2011-01-28 16:24:19]:
>
>> >
>> > But the assumption for LRU order to change happens only if the page
>> > cannot be successfully freed, which means it is in some way active..
>> > and needs to be moved no?
>>
>> 1. holded page by someone
>> 2. mapped pages
>> 3. active pages
>>
>> 1 is rare so it isn't the problem.
>> Of course, in case of 3, we have to activate it so no problem.
>> The problem is 2.
>>
>
> 2 is a problem, but due to the size aspects not a big one. Like you
> said even lumpy reclaim affects it. May be the reclaim code could
> honour may_unmap much earlier.

Even if it is, it's a trade-off to get a big contiguous memory. I
don't want to add new mess. (In addition, lumpy is weak by compaction
as time goes by)
What I have in mind for preventing LRU ignore is that put the page
into original position instead of head of lru. Maybe it can help the
situation both lumpy and your case. But it's another story.

How about the idea?

I borrow the idea from CFLRU[1]
- PCFLRU(Page-Cache First LRU)

When we allocates new page for page cache, we adds the page into LRU's tail.
When we map the page cache into page table, we rotate the page into LRU's head.

So, inactive list's result is following as.

M.P : mapped page
N.P : none-mapped page

HEAD-M.P-M.P-M.P-M.P-N.P-N.P-N.P-N.P-N.P-TAIL

Admin can set threshold window size which determines stop reclaiming
none-mapped page contiguously.

I think it needs some tweak of page cache/page mapping functions but
we can use kswapd/direct reclaim without change.

Also, it can change page reclaim policy totally but it's just what you
want, I think.

[1] http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.100.6188&rep=rep1&type=pdf

>
> --
>        Three Cheers,
>        Balbir
>



-- 
Kind regards,
Minchan Kim
