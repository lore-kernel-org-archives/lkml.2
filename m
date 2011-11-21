Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363Ab1KUV6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 16:58:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32069 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753591Ab1KUV6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 16:58:23 -0500
Message-ID: <4ECAC963.8020906@redhat.com>
Date: Mon, 21 Nov 2011 16:57:55 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: linux-mm@kvack.org, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan.kim@gmail.com>, Jan Kara <jack@suse.cz>,
        Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] Revert "vmscan: limit direct reclaim for higher order
 allocations"
References: <1321635524-8586-1-git-send-email-mgorman@suse.de> <1321732460-14155-9-git-send-email-aarcange@redhat.com>
In-Reply-To: <1321732460-14155-9-git-send-email-aarcange@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2011 02:54 PM, Andrea Arcangeli wrote:
> This reverts commit e0887c19b2daa140f20ca8104bdc5740f39dbb86.
>
> If reclaim runs with an high order allocation, it means compaction
> failed. That means something went wrong with compaction so we can't
> stop reclaim too. We can't assume it failed and was deferred only
> because of the too low watermarks in compaction_suitable, it may have
> failed for other reasons.
>
> Signed-off-by: Andrea Arcangeli<aarcange@redhat.com>

NACK

Reverting this can lead to the situation where every time
we have an attempted THP allocation, we free 4MB more
memory.

This has led to systems with 1/4 to 1/3 of all memory free
and pushed to swap, while the system continues with swapout
activity.

The thrashing this causes can be a factor 10 or worse
performance penalty.  Failing a THP allocation is merely
a 10-20% performance penalty, which is not as much of an
issue.

We can move the threshold at which we skip pageout to be a
little higher (to give compaction more space to work with),
and even call shrink_slab when we skip other reclaiming
(because slab cannot be moved by compaction), but whatever
we do we do need to ensure that we never reclaim an unreasonable
amount of memory and end up pushing the working set into swap.

