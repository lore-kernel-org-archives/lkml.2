Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901Ab1GYVBz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 17:01:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012Ab1GYVBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 17:01:53 -0400
Date: Mon, 25 Jul 2011 23:01:48 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Johannes Weiner <jweiner@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: thp: disable defrag for page faults per default
Message-ID: <20110725210148.GP18528@redhat.com>
References: <1311626321-14364-1-git-send-email-jweiner@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311626321-14364-1-git-send-email-jweiner@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Johannes,

On Mon, Jul 25, 2011 at 10:38:41PM +0200, Johannes Weiner wrote:
> With defrag mode enabled per default, huge page allocations pass
> __GFP_WAIT and may drop compaction into sync-mode where they wait for
> pages under writeback.
> 
> I observe applications hang for several minutes(!) when they fault in
> huge pages and compaction starts to wait on in-"flight" USB stick IO.
> 
> This patch disables defrag mode for page fault allocations unless the
> VMA is madvised explicitely.  Khugepaged will continue to allocate
> with __GFP_WAIT per default, but stalls are not a problem of
> application responsiveness there.

Allocating memory without __GFP_WAIT means THP it's like disabled
except when there's plenty of memory free after boot, even trying with
__GFP_WAIT and without compaction would be better than that. We don't
want to modify all apps, just a few special ones should have the
madvise like qemu-kvm for example (for embedded in case there's
embedded virt).

If you want to make compaction and migrate run without ever dropping
into sync-mode (or aborting if we've to wait on too many pages) I
think it'd be a whole lot better.

If you could show the SYSRQ+T during the minute wait it'd be
interesting too.

There was also some compaction bug that would lead to minutes of stall
in congestion_wait, those are fixed in current kernels.
