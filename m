Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291Ab1DLUb6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 16:31:58 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42781 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757254Ab1DLUbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 16:31:55 -0400
Date: Tue, 12 Apr 2011 21:30:58 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: mm: convert vma->vm_flags to 64bit
Message-ID: <20110412203058.GC7806@n2100.arm.linux.org.uk>
References: <20110412151116.B50D.A69D9226@jp.fujitsu.com> <20110411233358.dd400e59.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110411233358.dd400e59.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 11, 2011 at 11:33:58PM -0700, Andrew Morton wrote:
> How the heck did we end up using 32 flags??

Good question.

> > @@ -217,7 +217,7 @@ vivt_flush_cache_range(struct vm_area_struct *vma, unsigned long start, unsigned
> >  {
> >  	if (cpumask_test_cpu(smp_processor_id(), mm_cpumask(vma->vm_mm)))
> >  		__cpuc_flush_user_range(start & PAGE_MASK, PAGE_ALIGN(end),
> > -					vma->vm_flags);
> > +					(unsigned long)vma->vm_flags);
> >  }
> 
> I'm surprised this change (and similar) are needed?
> 
> Is it risky?  What happens if we add yet another vm_flags bit and
> __cpuc_flush_user_range() wants to use it?  I guess when that happens,
> __cpuc_flush_user_range() needs to be changed to take a ull.

The truncation is fine provided VM_EXEC is within the least significant
word.  If it isn't, then we'll blow up when the cache handling assembly
gets parsed by the assembler as the VM_EXEC value will overflow.
