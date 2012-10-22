Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab2JVTYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 15:24:43 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48986 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab2JVTYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 15:24:42 -0400
MIME-Version: 1.0
In-Reply-To: <20121022151722.GF22780@phenom.dumpdata.com>
References: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
	<1350593430-24470-16-git-send-email-yinghai@kernel.org>
	<20121022151722.GF22780@phenom.dumpdata.com>
Date: Mon, 22 Oct 2012 12:24:41 -0700
X-Google-Sender-Auth: 0mIl7HXHDsnb6CNsLauaIxS73TE
Message-ID: <CAE9FiQUcTQ_7ztmLS=z20j4m6KqJKQXX58UHL7AUHn8XHdTa8w@mail.gmail.com>
Subject: Re: [PATCH 12/19] x86, mm: Add alloc_low_pages(num)
From: Yinghai Lu <yinghai@kernel.org>
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 8:17 AM, Konrad Rzeszutek Wilk
<konrad@kernel.org> wrote:
> On Thu, Oct 18, 2012 at 01:50:23PM -0700, Yinghai Lu wrote:
>> 32bit kmap mapping need page table to be used for low to high.
>                                     ^-s
>
>>
>> At this point those page table are still from pgt_buf_* from BRK,
>                                 ^s
>
>> So it is ok now.
>> But we want to move early_ioremap_page_table_range_init() out of
>> init_memory_mapping() and only call it one time later, that will
>> make page_table_range_init/page_table_kmap_check/alloc_low_page to
>> use memblock to get page.
>>
>> memblock allocation for page table are from high to low.
>                                     ^s
>>
>> So will get panic from page_table_kmap_check() that has BUG_ON to do
>> ordering checking.
>>
>> This patch add alloc_low_pages to make it possible to alloc serveral pages
>> at first, and hand out pages one by one from low to high.
>
> .. But for right now this patch just makes it by default one.

?

---
32bit kmap mapping needs pages to be used for low to high.

At this point those pages are still from pgt_buf_* from BRK, so it is
ok now.
But we want to move early_ioremap_page_table_range_init() out of
init_memory_mapping() and only call it one time later, that will
make page_table_range_init/page_table_kmap_check/alloc_low_page to
use memblock to get page.

memblock allocation for pages are from high to low.

So will get panic from page_table_kmap_check() that has BUG_ON to do
ordering checking.

This patch add alloc_low_pages to make it possible to alloc serveral pages
at first, and hand out pages one by one from low to high.

-v2: add one line comment about xen requirements.
---
