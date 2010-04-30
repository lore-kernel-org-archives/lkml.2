Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561Ab0D3Ux2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 16:53:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54612 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752508Ab0D3Ux0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 16:53:26 -0400
Date: Fri, 30 Apr 2010 13:52:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jack Steiner <steiner@sgi.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cl@linux-foundation.org,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] - New round-robin rotor for SLAB allocations
Message-Id: <20100430135239.7782f6ba.akpm@linux-foundation.org>
In-Reply-To: <20100426210041.GA6580@sgi.com>
References: <20100426210041.GA6580@sgi.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Apr 2010 16:00:41 -0500
Jack Steiner <steiner@sgi.com> wrote:

> We have observed several workloads running on multi-node systems where
> memory is assigned unevenly across the nodes in the system. There are
> numerous reasons for this but one is the round-robin rotor in
> cpuset_mem_spread_node().
> 
> For example, a simple test that writes a multi-page file will allocate pages
> on nodes 0 2 4 6 ... Odd nodes are skipped.  (Sometimes it allocates on
> odd nodes & skips even nodes).
> 
> An example is shown below. The program "lfile" writes a file consisting of
> 10 pages. The program then mmaps the file & uses get_mempolicy(...,
> MPOL_F_NODE) to determine the nodes where the file pages were allocated.
> The output is shown below:
> 
> 	# ./lfile
> 	 allocated on nodes: 2 4 6 0 1 2 6 0 2
> 
> 
> 
> There is a single rotor that is used for allocating both file pages & slab
> pages.  Writing the file allocates both a data page & a slab page
> (buffer_head).  This advances the RR rotor 2 nodes for each page
> allocated.
> 
> A quick confirmation seems to confirm this is the cause of the uneven
> allocation:
> 
> 	# echo 0 >/dev/cpuset/memory_spread_slab
> 	# ./lfile
> 	 allocated on nodes: 6 7 8 9 0 1 2 3 4 5
> 
> 
> This patch introduces a second rotor that is used for slab allocations.
>
>  include/linux/cpuset.h |    6 ++++++
>  include/linux/sched.h  |    1 +
>  kernel/cpuset.c        |   20 ++++++++++++++++----
>  mm/slab.c              |    2 +-
>  4 files changed, 24 insertions(+), 5 deletions(-)

Why no update to slob and slub?
