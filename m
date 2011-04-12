Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757153Ab1DLK35 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 06:29:57 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33099 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756959Ab1DLK34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 06:29:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:content-type:to:cc:subject:references:date:mime-version
         :content-transfer-encoding:from:message-id:in-reply-to:user-agent;
        b=hGf/nMAOXHPawmnTmHCVfhqr9Hxb0IRfZpXp9qpErqEYfgoXesvGF3H3r2D0tRIRVN
         hBk0b6oXymv/O33MQyIGj4iGVGlvy/UwcJnNQ6oFTQas2ePiWyQWgwHGGpbpPLUXWqI2
         os7ILwm1DZbrHmm6DieO2Wyd8RF9mYIViQ0kA=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: linux-mm@kvack.org, "Dave Hansen" <dave@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, "Timur Tabi" <timur@freescale.com>,
        "Andi Kleen" <andi@firstfloor.org>, "Mel Gorman" <mel@csn.ul.ie>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "David Rientjes" <rientjes@google.com>
Subject: Re: [PATCH 3/3] reuse __free_pages_exact() in __alloc_pages_exact()
References: <20110411220345.9B95067C@kernel> <20110411220348.D0280E4D@kernel>
Date: Tue, 12 Apr 2011 12:29:53 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.vttl33xz3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <20110411220348.D0280E4D@kernel>
User-Agent: Opera Mail/11.01 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Apr 2011 00:03:48 +0200, Dave Hansen <dave@linux.vnet.ibm.com>  
wrote:
> diff -puN mm/page_alloc.c~reuse-free-exact mm/page_alloc.c
> --- linux-2.6.git/mm/page_alloc.c~reuse-free-exact	2011-04-11  
> 15:01:17.701822598 -0700
> +++ linux-2.6.git-dave/mm/page_alloc.c	2011-04-11 15:01:17.713822594  
> -0700
> @@ -2338,14 +2338,11 @@ struct page *__alloc_pages_exact(gfp_t g
> 	page = alloc_pages(gfp_mask, order);
>  	if (page) {
> -		struct page *alloc_end = page + (1 << order);
> -		struct page *used = page + nr_pages;
> +		struct page *unused_start = page + nr_pages;
> +		int nr_unused = (1 << order) - nr_pages;

How about unsigned long?

> 		split_page(page, order);
> -		while (used < alloc_end) {
> -			__free_page(used);
> -			used++;
> -		}
> +		__free_pages_exact(unused_start, nr_unused);
>  	}
> 	return page;

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
