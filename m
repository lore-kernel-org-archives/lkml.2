Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436Ab2JJRHy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 13:07:54 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34549 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932219Ab2JJRHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 13:07:46 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1210101733220.2689@kaball.uk.xensource.com>
References: <1349827115-16600-1-git-send-email-yinghai@kernel.org>
	<1349827115-16600-7-git-send-email-yinghai@kernel.org>
	<alpine.DEB.2.02.1210101733220.2689@kaball.uk.xensource.com>
Date: Wed, 10 Oct 2012 10:07:44 -0700
X-Google-Sender-Auth: _GRnsRWRj7CXHaE7VVoY2lPrbbA
Message-ID: <CAE9FiQVuU=KfMM0Q16Lddz8ZL_wzg5PLkWWK=6navQdC_j0KbA@mail.gmail.com>
Subject: Re: [PATCH 6/7] x86, mm: setup page table from top-down
From: Yinghai Lu <yinghai@kernel.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 9:38 AM, Stefano Stabellini
<stefano.stabellini@eu.citrix.com> wrote:
>> -     if (pfn >= pgt_buf_top)
>> -             panic("alloc_low_page: ran out of memory");
>> +     if ((pgt_buf_end + 1) >= pgt_buf_top) {
>> +             unsigned long ret;
>> +             if (min_pfn_mapped >= max_pfn_mapped)
>> +                     panic("alloc_low_page: ran out of memory");
>> +             ret = memblock_find_in_range(min_pfn_mapped << PAGE_SHIFT,
>> +                                     max_pfn_mapped << PAGE_SHIFT,
>> +                                     PAGE_SIZE, PAGE_SIZE);
>> +             if (!ret)
>> +                     panic("alloc_low_page: can not alloc memory");
>> +             memblock_reserve(ret, PAGE_SIZE);
>> +             pfn = ret >> PAGE_SHIFT;
>
> This cannot be right: you are allocating another page to be used as
> pagetable page, outside the range pgt_buf_start-pgt_buf_top.
>
> When that page is going to be hooked into the live pagetable, the kernel
> is going to panic on Xen because the page wasn't marked RO.
>
> If you want to do that you need to tell the Xen subsystem of the new
> page. pagetable_reserve is not the right call, we need a new one (see
> past emails).

ok, will change that interface and call in from alloc_low_page.

how about the pages from BRK, do we need to call xen hooks to mark it as RO?
