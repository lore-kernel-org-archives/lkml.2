Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014Ab1DLP51 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 11:57:27 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54147 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757921Ab1DLP50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 11:57:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:content-type:to:cc:subject:references:date:mime-version
         :content-transfer-encoding:from:message-id:in-reply-to:user-agent;
        b=UQ6l4v7b5JaWqRI57TJNBZB72sBLEZSXPvbax+AWGRFjbZHe03xfHp3Z9p5cdtDAIv
         7p+llQoZim5VZfB5M0ChUdxrJ5wkWIU7U0Mu12RBfcDdvMIzSNBo17fRMQz9cUVBM+1J
         5RxeyoQ2ExYIS/Xk01iMdhaeJZ7W/UvWkyOlc=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Dave Hansen" <dave@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        "Timur Tabi" <timur@freescale.com>, "Andi Kleen" <andi@firstfloor.org>,
        "Mel Gorman" <mel@csn.ul.ie>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "David Rientjes" <rientjes@google.com>
Subject: Re: [PATCH 3/3] reuse __free_pages_exact() in __alloc_pages_exact()
References: <20110411220345.9B95067C@kernel> <20110411220348.D0280E4D@kernel>
 <op.vttl33xz3l0zgt@mnazarewicz-glaptop> <1302621864.8321.1856.camel@nimitz>
Date: Tue, 12 Apr 2011 17:57:23 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.vtt09xt73l0zgt@mnazarewicz-glaptop>
In-Reply-To: <1302621864.8321.1856.camel@nimitz>
User-Agent: Opera Mail/11.01 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Apr 2011 17:24:24 +0200, Dave Hansen <dave@linux.vnet.ibm.com>  
wrote:

> On Tue, 2011-04-12 at 12:29 +0200, Michal Nazarewicz wrote:
>> On Tue, 12 Apr 2011 00:03:48 +0200, Dave Hansen  
>> <dave@linux.vnet.ibm.com>
>> wrote:
>> > diff -puN mm/page_alloc.c~reuse-free-exact mm/page_alloc.c
>> > --- linux-2.6.git/mm/page_alloc.c~reuse-free-exact	2011-04-11
>> > 15:01:17.701822598 -0700
>> > +++ linux-2.6.git-dave/mm/page_alloc.c	2011-04-11 15:01:17.713822594
>> > -0700
>> > @@ -2338,14 +2338,11 @@ struct page *__alloc_pages_exact(gfp_t g
>> > 	page = alloc_pages(gfp_mask, order);
>> >  	if (page) {
>> > -		struct page *alloc_end = page + (1 << order);
>> > -		struct page *used = page + nr_pages;
>> > +		struct page *unused_start = page + nr_pages;
>> > +		int nr_unused = (1 << order) - nr_pages;
>>
>> How about unsigned long?
>
> Personally, I'd rather leave this up to the poor sucker that tries to
> set MAX_ORDER to 33.  If someone did that, we'd end up with kernels that
> couldn't even boot on systems with less than 16GB of RAM since the
> (required) flatmem mem_map[] would take up ~14.3GB.  They couldn't
> handle memory holes and couldn't be NUMA-aware, either.

I was thinking more about the fact that the int will get converted
anyway when calling __free_pages_exact() and it makes no sense for
number of pages to be negative.  Just a suggestion, no strong
feelings.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
