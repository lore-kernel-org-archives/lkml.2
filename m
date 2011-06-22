Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035Ab1FVOlr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 10:41:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35266 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753411Ab1FVOlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 10:41:46 -0400
Date: Wed, 22 Jun 2011 16:40:57 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Cong Wang <amwang@redhat.com>
Cc: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, dave@linux.vnet.ibm.com,
        Mel Gorman <mel@csn.ul.ie>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org
Subject: Re: [PATCH v2 2/4] mm: make the threshold of enabling THP
 configurable
Message-ID: <20110622144057.GW20843@redhat.com>
References: <1308643849-3325-1-git-send-email-amwang@redhat.com>
 <1308643849-3325-2-git-send-email-amwang@redhat.com>
 <alpine.DEB.2.00.1106211817340.5205@chino.kir.corp.google.com>
 <4E015C36.2050005@redhat.com>
 <alpine.DEB.2.00.1106212024210.8712@chino.kir.corp.google.com>
 <4E018060.3050607@redhat.com>
 <alpine.DEB.2.00.1106212325400.14693@chino.kir.corp.google.com>
 <4E01CCED.5050609@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E01CCED.5050609@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 07:07:25PM +0800, Cong Wang wrote:
> Actually, if we move this out of kernel, to user-space, everything
> you worried will be solved by just changing the user-space code.
> Just add the following pseudo code into your init script,
> 
> if [ $total_memory -lt 512 ]
> then
> 	echo never > /sys/kernel/mm/transparent_hugepage/enabled
> fi

By the time this script runs some app may have allocated hugepages
already potentially wasting mbytes of ram and undoing the
min_free_kbytes isn't possible from userland using the kernel
algorithm (it is possible actually but it's not nearly as simple as
the above).

There's no reason to complicate things and involve userland here when
a simple kernel check can get the default right without userland
dependency. Plus if this user really wants THP on 512m of ram he can
still enable it and run hugeadm to enable antifrag too, without the
need of =force. And forcing when PSE is enabled sounds impossible to be
useful (maybe with the except of nopentium being passed to the kernel ;).

There is no bug here, just send that printk cleanup and if you really
want to save 8k the patch to change the number of hash heads structs
at boot, like for dcache/icache. No other change required.

After you do the above, you can go ahead picking one kernel crashing
bug and fix it, that is more useful than making this 512m thing a
.config variable or anything like that, .config is a nightmare already
so it's probably better not to add anything there.
