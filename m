Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964890Ab1GOGGz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 02:06:55 -0400
Received: from ozlabs.org ([203.10.76.45]:45667 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964839Ab1GOGGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 02:06:53 -0400
Date: Fri, 15 Jul 2011 16:06:50 +1000
From: Anton Blanchard <anton@samba.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: dwg@au1.ibm.com, akpm@linux-foundation.org, hughd@google.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] hugepage: Allow parallelization of the hugepage
 fault path
Message-ID: <20110715160650.48d61245@kryten>
In-Reply-To: <20110126092428.GR18984@csn.ul.ie>
References: <20110125143226.37532ea2@kryten>
	<20110125143414.1dbb150c@kryten>
	<20110126092428.GR18984@csn.ul.ie>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Mel,

> I haven't tested this patch yet but typically how I would test it is
> multiple parallel instances of make func from libhugetlbfs. In
> particular I would be looking out for counter corruption. Has
> something like this been done? I know hugetlb_lock protects the
> counters but the locking in there has turned into a bit of a mess so
> it's easy to miss something.

Thanks for the suggestion and sorry for taking so long. Make check has
the same PASS/FAIL count before and after the patches.

I also ran 16 copies of make func on a large box with 896 HW threads.
Some of the tests that use shared memory were a bit upset, but that
seems to be because we use a static key. It seems the tests were also
fighting over the number of huge pages they wanted the system set to.

It got up to a load average of 13207, and heap-overflow consumed all my
memory, a pretty good effort considering I have over 1TB of it.

After things settled down things were OK, apart from the fact that we
have 20 huge pages unaccounted for:

HugePages_Total:   10000
HugePages_Free:     9980
HugePages_Rsvd:        0
HugePages_Surp:        0

I verified there were no shared memory segments, and no files in the
hugetlbfs filesystem (I double checked by unmounting it).

I can't see how this patch set would cause this. It seems like we can
leak huge pages, perhaps in an error path. Anyway, I'll repost the
patch set for comments.

Anton
