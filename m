Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab0GROSQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 10:18:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755240Ab0GROSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 10:18:13 -0400
Message-ID: <4C430D1C.3060203@redhat.com>
Date: Sun, 18 Jul 2010 17:18:04 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>, Nick Piggin <npiggin@suse.de>
CC: LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH 6/6] kvm, faster and simpler version of get_user_page_and_protection()
References: <4C3FC03A.9040504@cn.fujitsu.com>
In-Reply-To: <4C3FC03A.9040504@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2010 05:13 AM, Lai Jiangshan wrote:
> a light weight version of get_user_page_and_protection()
>
>
> @@ -375,3 +374,83 @@ slow_irqon:
>   		return ret;
>   	}
>   }
> +
> +/*
> + * get a current mapped page fast, and test whether the page is writable.
> + * equivalent version(but slower):
> + * {
> + *	struct page *page[1];
> + *
> + *	if (__get_user_pages_fast(addr, 1, 1, page) == 1) {
> + *		*writable = 1;
> + *		return page[0];
> + *	}
> + *	if (__get_user_pages_fast(addr, 1, 0, page) == 1) {
> + *		*writable = 0;
> + *		return page[0];
> + *	}
> + *	return NULL;
> + * }
> + */
> +struct page *get_user_page_and_protection(unsigned long addr, int *writable)
> +{
>
>    

<snip lots of code>

> +}
> +EXPORT_SYMBOL_GPL(get_user_page_and_protection);
> +
>    

This a duplication of __get_user_pages_fast(), no?

I think a better way is to have a __get_user_pages_ptes(..., struct page 
*pages, pte_t *ptes, ...), and write __get_user_pages_fast() in terms of 
that.  There's lots of useful info from the pte we can use:

- writeable bit (used here)
- page size (we can stick it in some user bits, speeds up 
host_mapping_level())
- dirty bit (if set, we can set it for speculative sptes and save the 
CPU a RMW)
- page attribute (for device assignment, when snooping is not available)

Nick, is __get_user_pages_ptes() fine with you?

-- 
error compiling committee.c: too many arguments to function

