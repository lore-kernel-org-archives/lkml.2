Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964795Ab1ETUEP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 16:04:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54970 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751692Ab1ETUEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 16:04:14 -0400
Date: Fri, 20 May 2011 13:04:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Russ Anderson <rja@sgi.com>
Cc: Rafael Aquini <aquini@linux.com>, Andrea Arcangeli <aarcange@redhat.com>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH] [BUGFIX] mm: hugepages can cause negative commitlimit
Message-Id: <20110520130411.d1e0baef.akpm@linux-foundation.org>
In-Reply-To: <20110519221101.GC19648@sgi.com>
References: <20110518153445.GA18127@sgi.com>
	<BANLkTinbHnrf2isuLzUFZN8ypaT476G1zw@mail.gmail.com>
	<20110519045630.GA22533@sgi.com>
	<BANLkTinyYP-je9Nf8X-xWEdpgvn8a631Mw@mail.gmail.com>
	<20110519221101.GC19648@sgi.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 May 2011 17:11:01 -0500
Russ Anderson <rja@sgi.com> wrote:

> OK, I see your point.  The root problem is hugepages allocated at boot are
> subtracted from totalram_pages but hugepages allocated at run time are not.
> Correct me if I've mistate it or are other conditions.
> 
> By "allocated at run time" I mean "echo 1 > /proc/sys/vm/nr_hugepages".
> That allocation will not change totalram_pages but will change
> hugetlb_total_pages().
> 
> How best to fix this inconsistency?  Should totalram_pages include or exclude
> hugepages?  What are the implications?

The problem is that hugetlb_total_pages() is trying to account for two
different things, while totalram_pages accounts for only one of those
things, yes?

One fix would be to stop accounting for huge pages in totalram_pages
altogether.  That might break other things so careful checking would be
needed.

Or we stop accounting for the boot-time allocated huge pages in
hugetlb_total_pages().  Split the two things apart altogether and
account for boot-time allocated and runtime-allocated pages separately.  This
souds saner to me - it reflects what's actually happening in the kernel.
