Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260Ab2JSRyo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 13:54:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:53064 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab2JSRym convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 13:54:42 -0400
Message-ID: <1350669236.2768.66.camel@twins>
Subject: Re: question on NUMA page migration
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Mel Gorman <mel@csn.ul.ie>,
        Linux kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 19 Oct 2012 19:53:56 +0200
In-Reply-To: <50818A41.7030909@redhat.com>
References: <5081777A.8050104@redhat.com> <1350664742.2768.40.camel@twins>
	 <50818A41.7030909@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-19 at 13:13 -0400, Rik van Riel wrote:

> Would it make sense to have the normal page migration code always
> work with the extra refcount, so we do not have to introduce a new
> MIGRATE_FAULT migration mode?
> 
> On the other hand, compaction does not take the extra reference...

Right, it appears to not do this, it gets pages from the pfn and
zone->lock and the isolate_lru_page() call is the first reference.

> Another alternative might be to do the put_page inside
> do_prot_none_numa().  That would be analogous to do_wp_page
> disposing of the old page for the caller.

It'd have to be inside migrate_misplaced_page(), can't do before
isolate_lru_page() or the page might disappear. Doing it after is
(obviously) too late.

> I am not real happy about NUMA migration introducing its own
> migration mode...

You didn't seem to mind too much earlier, but I can remove it if you
want.
