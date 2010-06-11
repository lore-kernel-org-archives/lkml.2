Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064Ab0FKF6t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 01:58:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55300 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751819Ab0FKF6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 01:58:48 -0400
Date: Thu, 10 Jun 2010 22:57:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [RFC PATCH 0/6] Do not call ->writepage[s] from direct reclaim
 and use a_ops->writepages() where possible
Message-Id: <20100610225749.c8cc3bc3.akpm@linux-foundation.org>
In-Reply-To: <1275987745-21708-1-git-send-email-mel@csn.ul.ie>
References: <1275987745-21708-1-git-send-email-mel@csn.ul.ie>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  8 Jun 2010 10:02:19 +0100 Mel Gorman <mel@csn.ul.ie> wrote:

> To summarise, there are two big problems with page reclaim right now. The
> first is that page reclaim uses a_op->writepage to write a back back
> under the page lock which is inefficient from an IO perspective due to
> seeky patterns.

No it isn't.  If we have a pile of file-contiguous, disk-contiguous
dirty pages on the tail of the LRU then the single writepage()s will
work just fine due to request merging.



Look.  This is getting very frustrating.  I keep saying the same thing
and keep getting ignored.  Once more:

	WE BROKE IT!

	PLEASE STOP WRITING CODE!

	FIND OUT HOW WE BROKE IT!

Loud enough yet?

It used to be the case that only very small amounts of IO occurred in
page reclaim - the vast majority of writeback happened within
write()->balance_dirty_pages().  Then (and I think it was around 2.6.12)
we broke it, and page reclaim started doing lots of writeout.

So the thing to do is to either find out how we broke it and see if it
can be repaired, or change the VM so that it doesn't do so much
LRU-based writeout.  Rather than fiddling around trying to make the
we-broke-it code run its brokenness faster.
