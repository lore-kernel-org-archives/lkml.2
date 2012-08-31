Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab2HaVah (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 17:30:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50748 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878Ab2HaVae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 17:30:34 -0400
Date: Fri, 31 Aug 2012 14:30:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: wency@cn.fujitsu.com
Cc: x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-ia64@vger.kernel.org, cmetcalf@tilera.com,
        sparclinux@vger.kernel.org, rientjes@google.com, liuj97@gmail.com,
        len.brown@intel.com, benh@kernel.crashing.org, paulus@samba.org,
        cl@linux.com, minchan.kim@gmail.com, kosaki.motohiro@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com
Subject: Re: [RFC v8 PATCH 13/20] memory-hotplug: check page type in
 get_page_bootmem
Message-Id: <20120831143032.1343e99a.akpm@linux-foundation.org>
In-Reply-To: <1346148027-24468-14-git-send-email-wency@cn.fujitsu.com>
References: <1346148027-24468-1-git-send-email-wency@cn.fujitsu.com>
	<1346148027-24468-14-git-send-email-wency@cn.fujitsu.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Aug 2012 18:00:20 +0800
wency@cn.fujitsu.com wrote:

> From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> 
> There is a possibility that get_page_bootmem() is called to the same page many
> times. So when get_page_bootmem is called to the same page, the function only
> increments page->_count.

I really don't understand this explanation, even after having looked at
the code.  Can you please have another attempt at the changelog?

> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -95,10 +95,17 @@ static void release_memory_resource(struct resource *res)
>  static void get_page_bootmem(unsigned long info,  struct page *page,
>  			     unsigned long type)
>  {
> -	page->lru.next = (struct list_head *) type;
> -	SetPagePrivate(page);
> -	set_page_private(page, info);
> -	atomic_inc(&page->_count);
> +	unsigned long page_type;
> +
> +	page_type = (unsigned long) page->lru.next;
> +	if (page_type < MEMORY_HOTPLUG_MIN_BOOTMEM_TYPE ||
> +	    page_type > MEMORY_HOTPLUG_MAX_BOOTMEM_TYPE){
> +		page->lru.next = (struct list_head *) type;
> +		SetPagePrivate(page);
> +		set_page_private(page, info);
> +		atomic_inc(&page->_count);
> +	} else
> +		atomic_inc(&page->_count);
>  }

And a code comment which explains what is going on would be good.  As
is always the case ;)

