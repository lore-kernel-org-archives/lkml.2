Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760460Ab0FKVfA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 17:35:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40684 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752021Ab0FKVe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 17:34:58 -0400
Date: Fri, 11 Jun 2010 14:33:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 5/6] vmscan: Write out ranges of pages contiguous to the
 inode where possible
Message-Id: <20100611143337.53a06329.akpm@linux-foundation.org>
In-Reply-To: <20100611204411.GD9946@csn.ul.ie>
References: <1275987745-21708-1-git-send-email-mel@csn.ul.ie>
	<1275987745-21708-6-git-send-email-mel@csn.ul.ie>
	<20100610231045.7fcd6f9d.akpm@linux-foundation.org>
	<20100611124936.GB8798@csn.ul.ie>
	<20100611120730.26a29366.akpm@linux-foundation.org>
	<20100611204411.GD9946@csn.ul.ie>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jun 2010 21:44:11 +0100
Mel Gorman <mel@csn.ul.ie> wrote:

> > Well.  The main problem is that we're doing too much IO off the LRU of
> > course.
> > 
> 
> What would be considered "too much IO"?

Enough to slow things down ;)

This problem used to hurt a lot.  Since those times we've decreased the
default value of /proc/sys/vm/dirty*ratio by a lot, which surely
papered over this problem a lot.  We shouldn't forget that those ratios
_are_ tunable, after all.  If we make a change which explodes the
kernel when someone's tuned to 40% then that's a problem and we'll need
to scratch our heads over the magnitude of that problem.

As for a workload which triggers the problem on a large machine which
is tuned to 20%/10%: dunno.  If we're reliably activating pages when
dirtying them then perhaps it's no longer a problem with the default
tuning.  I'd do some testing with mem=256M though - that has a habit of
triggering weirdnesses.

btw, I'm trying to work out if zap_pte_range() really needs to run
set_page_dirty().  Didn't (pte_dirty() && !PageDirty()) pages get
themselves stamped out?


