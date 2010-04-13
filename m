Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580Ab0DMJwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 05:52:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:51026 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab0DMJwX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 05:52:23 -0400
Subject: Re: [PATCH 1/4] Simplify and comment on anon_vma re-use for
 anon_vma_prepare()
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>, Rik van Riel <riel@redhat.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
In-Reply-To: <alpine.LFD.2.00.1004121320390.3683@i5.linux-foundation.org>
References: <20100411130801.GA7189@a1.tnic>
	 <alpine.LFD.2.00.1004110938570.3514@i5.linux-foundation.org>
	 <alpine.LFD.2.00.1004111010280.3514@i5.linux-foundation.org>
	 <20100411185508.GA4450@liondog.tnic>
	 <alpine.LFD.2.00.1004111707360.3514@i5.linux-foundation.org>
	 <alpine.LFD.2.00.1004111759440.3521@i5.linux-foundation.org>
	 <20100412072056.GA2432@liondog.tnic>
	 <alpine.LFD.2.00.1004120854440.26679@i5.linux-foundation.org>
	 <alpine.LFD.2.00.1004120906370.26679@i5.linux-foundation.org>
	 <4BC36916.3080005@redhat.com> <20100412190002.GA8595@a1.tnic>
	 <alpine.LFD.2.00.1004121201480.3714@i5.linux-foundation.org>
	 <alpine.LFD.2.00.1004121320390.3683@i5.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 13 Apr 2010 11:51:38 +0200
Message-ID: <1271152298.4807.1009.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-12 at 13:22 -0700, Linus Torvalds wrote:
> +static int anon_vma_compatible(struct vm_area_struct *a, struct vm_area_struct *b)
> +{
> +       return a->vm_end == b->vm_start &&
> +               mpol_equal(vma_policy(a), vma_policy(b)) &&
> +               a->vm_file == b->vm_file &&
> +               !((a->vm_flags ^ b->vm_flags) & ~(VM_READ|VM_WRITE|VM_EXEC)) &&
> +               b->vm_pgoff == a->vm_pgoff + ((b->vm_start - a->vm_start) >> PAGE_SHIFT);
> +} 

Maybe write that as:

static int anon_vma_compatible(struct vm_area_struct *a, struct vm_area_struct *b)
{
	if (a->vm_end != b->vm_start)
		return 0;

	if (!mpol_equal(vma_policy(a), vma_policy(b))
		return 0;

	if (a->vm_file != b->vm_file)
		return 0;

	if ((a->vm_flags ^ b->vm_flags) & ~(VM_READ|VM_WRITE|VM_EXEC))
		return 0;

	if (a->vm_pgoff + ((b->vm_start - a->vm_start) >> PAGE_SHIFT) != b->vm_pgoff)
		return 0;

	return 1;
}


