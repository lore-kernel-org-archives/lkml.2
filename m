Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932953Ab2JZNnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 09:43:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:43413 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932884Ab2JZNne convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 09:43:34 -0400
Message-ID: <1351258992.16863.77.camel@twins>
Subject: Re: [PATCH 1/2] numa, mm: drop redundant check in
 do_huge_pmd_numa_page()
From: Peter Zijlstra <peterz@infradead.org>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: linux-mm@kvack.org, Will Deacon <will.deacon@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Date: Fri, 26 Oct 2012 15:43:12 +0200
In-Reply-To: <20121026134129.GA31306@otc-wbsnb-06>
References: <1351256077-1594-1-git-send-email-kirill.shutemov@linux.intel.com>
	 <1351256885.16863.62.camel@twins> <20121026134129.GA31306@otc-wbsnb-06>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-26 at 16:41 +0300, Kirill A. Shutemov wrote:
> On Fri, Oct 26, 2012 at 03:08:05PM +0200, Peter Zijlstra wrote:
> > On Fri, 2012-10-26 at 15:54 +0300, Kirill A. Shutemov wrote:
> > > From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> > > 
> > > We check if the pmd entry is the same as on pmd_trans_huge() in
> > > handle_mm_fault(). That's enough.
> > > 
> > > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > 
> > Ah indeed, Will mentioned something like this on IRC as well, I hadn't
> > gotten around to looking at it -- now have, thanks!
> > 
> > Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > 
> > That said, where in handle_mm_fault() do we wait for a split to
> > complete? We have a pmd_trans_huge() && !pmd_trans_splitting(), so a
> > fault on a currently splitting pmd will fall through.
> > 
> > Is it the return from the fault on unlikely(pmd_trans_huge()) ?
> 
> Yes, this code will catch it:
> 
> 	/* if an huge pmd materialized from under us just retry later */
> 	if (unlikely(pmd_trans_huge(*pmd)))
> 		return 0;
> 
> If the pmd is under splitting it's still a pmd_trans_huge().

OK, so then we simply keep taking the same fault until the split is
complete? Wouldn't it be better to wait for it instead of spin on
faults?
