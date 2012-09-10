Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262Ab2IJO6H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 10:58:07 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55442 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067Ab2IJO6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 10:58:04 -0400
Subject: Re: [PATCH v2 10/10] thp: implement refcounting for huge zero page
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>
In-Reply-To: <20120910144438.GA31697@otc-wbsnb-06>
References: <1347282813-21935-1-git-send-email-kirill.shutemov@linux.intel.com>
	 <1347282813-21935-11-git-send-email-kirill.shutemov@linux.intel.com>
	 <1347285759.1234.1645.camel@edumazet-glaptop>
	 <20120910144438.GA31697@otc-wbsnb-06>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Sep 2012 16:57:59 +0200
Message-ID: <1347289079.1234.1706.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-10 at 17:44 +0300, Kirill A. Shutemov wrote:


> Yes, disabling preemption before alloc_pages() and enabling after
> atomic_set() looks reasonable. Thanks.

In fact, as alloc_pages(GFP_TRANSHUGE | __GFP_ZERO, HPAGE_PMD_ORDER);
might sleep, it would be better to disable preemption after calling it :

zero_page = alloc_pages(GFP_TRANSHUGE | __GFP_ZERO, HPAGE_PMD_ORDER);
if (!zero_page)
	return 0;
preempt_disable();
if (cmpxchg(&huge_zero_pfn, 0, page_to_pfn(zero_page))) {
	preempt_enable();
	__free_page(zero_page);
	goto retry;
}
atomic_set(&huge_zero_refcount, 2);
preempt_enable();


