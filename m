Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964860Ab2CBHNB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 02:13:01 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:54549 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756654Ab2CBHM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 02:12:58 -0500
X-AuditID: 9c930179-b7c4fae0000073fb-70-4f5072f7d22f
Message-ID: <4F5072F4.3030505@lge.com>
Date: Fri, 02 Mar 2012 16:12:52 +0900
From: Namhyung Kim <namhyung.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:10.0) Gecko/20120129 Thunderbird/10.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.linux.kernel.mm
To: Christoph Lameter <cl@gentwo.org>
CC: Namhyung Kim <namhyung@gmail.com>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] slub: set PG_slab on all of slab pages
References: <1330505674-31610-1-git-send-email-namhyung.kim@lge.com>  <alpine.DEB.2.00.1202290922210.32268@router.home> <1330587031.1762.46.camel@leonhard> <alpine.DEB.2.00.1203010901020.5004@router.home>
In-Reply-To: <alpine.DEB.2.00.1203010901020.5004@router.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-03-02 12:03 AM, Christoph Lameter wrote:
> On Thu, 1 Mar 2012, Namhyung Kim wrote:
>
>>> You cannot free a tail page of a compound higher order page independently.
>>> You must free the whole compound.
>>>
>>
>> I meant freeing a *slab object* resides in a compound page using buddy
>> system API (e.g. free_pages). I know it's definitely a programming
>> error. However there's no safety net to protect and/or warn such a
>> misbehavior AFAICS - except for head page which has PG_slab set - when
>> it happened by any chance.
>
> ?? One generally passed a struct page pointer to the page allocator. Slab
> allocator takes pointers to object. The calls that take a pointer to an
> object must have a page aligned value.
>

Please see free_pages(). It converts the pointer using virt_to_page().


>> Without it, it might be possible to free part of tail pages silently,
>> and cause unexpected not-so-funny results some time later. It should be
>> hard to find out.
>
> Ok then fix the page allocator to BUG() on tail pages. That is an issue
> with the page allocator not the slab allocator.
>
> Adding PG_tail to the flags checked on free should do the trick (at least
> for 64 bit).
>

Yeah, but doing it requires to change free path of compound pages. It seems 
freeing normal compound pages would not clear PG_head/tail bits before 
free_pages_check() called. I guess moving destroy_compound_page() into 
free_pages_prepare() will solved this issue but I want to make sure it's the 
right approach since I have no idea how it affects huge page behaviors.

Besides, as it has no effect on 32 bit kernels I still want add the PG_slab 
flag to those pages. If you care about the performance of hot path, how about 
adding it under debug configurations at least?


Thanks,
Namhyung Kim
