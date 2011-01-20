Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205Ab1ATR1i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 12:27:38 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:55439 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130Ab1ATR1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 12:27:37 -0500
Subject: Re: [PATCH] ARM: mm: Regarding section when dealing with meminfo
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: KyongHo Cho <pullip.cho@samsung.com>, linux-arm-kernel@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Ilho Lee <ilho215.lee@samsung.com>,
        KeyYoung Park <keyyoung.park@samsung.com>
In-Reply-To: <20110120142844.GA28358@barrios-desktop>
References: <1295516739-9839-1-git-send-email-pullip.cho@samsung.com>
	 <20110120142844.GA28358@barrios-desktop>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Thu, 20 Jan 2011 09:25:13 -0800
Message-ID: <1295544313.9039.618.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-20 at 23:28 +0900, Minchan Kim wrote:
> On Thu, Jan 20, 2011 at 06:45:39PM +0900, KyongHo Cho wrote:
> > Sparsemem allows that a bank of memory spans over several adjacent
> > sections if the start address and the end address of the bank
> > belong to different sections.
> > When gathering statictics of physical memory in mem_init() and
> > show_mem(), this possiblity was not considered.
> 
> Please write down the result if we doesn't consider this patch.
> I can understand what happens but for making good description and review,
> merging easily, it would be better to write down the result without 
> the patch explicitly. 

You'll oops.  __section_mem_map_addr() in:

> #define __pfn_to_page(pfn)                              \
> ({      unsigned long __pfn = (pfn);                    \
>         struct mem_section *__sec = __pfn_to_section(__pfn);    \
>         __section_mem_map_addr(__sec) + __pfn;          \
> })

will return NULL, you'll add some fuzz on to it with __pfn, then you'll
oops when the arm show_mem() does PageReserved() and dereferences
page->flags.

Ether that, or with the sparsemem vmemmap variant, you'll get a
valid-looking pointer with no backing memory, and oops as well.

-- Dave

