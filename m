Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290Ab2HQQeC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 12:34:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27816 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757164Ab2HQQdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 12:33:54 -0400
Date: Fri, 17 Aug 2012 18:33:46 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH, RFC 7/9] thp: implement splitting pmd for huge zero page
Message-ID: <20120817163346.GC10129@redhat.com>
References: <1344503300-9507-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1344503300-9507-8-git-send-email-kirill.shutemov@linux.intel.com>
 <20120816192738.GO11188@redhat.com>
 <20120817081233.GB9833@otc-wbsnb-06>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120817081233.GB9833@otc-wbsnb-06>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 11:12:33AM +0300, Kirill A. Shutemov wrote:
> I've used do_huge_pmd_wp_page_fallback() as template for my code.
> What's difference between these two code paths?
> Why is do_huge_pmd_wp_page_fallback() safe?

Good point. do_huge_pmd_wp_page_fallback works only on the current
"mm" so it doesn't need the splitting transition, but thinking twice
the split_huge_zero_page_pmd also works only on the local "mm" because
you're not really splitting the zero page there (you're not affecting
other mm). As long as you keep holding the page_table_lock of the "mm"
that you're altering your current version is safe.

I got mistaken because I'm very used to think at split huge page as
something that cannot relay on the page_table_lock, but this is a
simpler case that isn't splitting the "page" but only the "pmd" of a
single "mm", so you can safely relay on the mm->page_table_lock :).

> Looks resonable. I'll update it in next revision.

Thanks. Of course the function parameter comments to avoid unnecessary
calls of find_vma, weren't related to the above locking issues.
