Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab1BDVKX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 16:10:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3885 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243Ab1BDVKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 16:10:22 -0500
Date: Fri, 4 Feb 2011 22:10:13 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Michael J Wolf <mjwolf@us.ibm.com>
Subject: Re: [RFC][PATCH 2/6] pagewalk: only split huge pages when necessary
Message-ID: <20110204211013.GI30909@random.random>
References: <20110201003357.D6F0BE0D@kernel>
 <20110201003359.8DDFF665@kernel>
 <alpine.DEB.2.00.1102031257490.948@chino.kir.corp.google.com>
 <1296768812.8299.1644.camel@nimitz>
 <alpine.DEB.2.00.1102031343530.1307@chino.kir.corp.google.com>
 <1296839952.6737.2316.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296839952.6737.2316.camel@nimitz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 04, 2011 at 09:19:12AM -0800, Dave Hansen wrote:
> For code maintenance, I really like _not_ hiding this in the API
> somewhere.  This way, we have a great, self-explanatory tag wherever
> code (possibly) hasn't properly dealt with THPs.  We get a nice,
> greppable, cscope'able:
> 
> 	split_huge_page_pmd()
> 
> wherever we need to "teach" the code about THP.
> 
> It's kinda like the BKL. :)

It is in my view too ;).

However currently it's not greppable if we don't differentiate it a
bit from the legitimate/optimal usages. split_huge_page_pmd currently
isn't always sign of code not THP aware. It's sign of not THP aware
code only for cases like smaps that is readonly in terms of vma/pte
mangling, but for example mprotect isn't a readonly thing and it's
already fully mprotect aware, but split_huge_page_pmd still comes very
handy when userland asks to create a vma that can't fit an hugepmd
(there are several other places like that). When that ever happens
(like changing protection of only the last 4k of an hugepage backed
mapping) replacing the hugepmd with a regular pmd pointing to a pte
(where we can alter the protection of only the last 4k) becomes
compulsory. So it's not always a sign of lack of optimization,
sometime it's needed and userland should be optimized instead ;).
