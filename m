Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830Ab1LNKvX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 05:51:23 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:43926 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753883Ab1LNKvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 05:51:22 -0500
Subject: Re: [PATCH] mm: Fix kswapd livelock on single core, no preempt
 kernel
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Mike Waychison <mikew@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <jweiner@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Hugh Dickens <hughd@google.com>,
        Greg Thelen <gthelen@google.com>
In-Reply-To: <1323798271-1452-1-git-send-email-mikew@google.com>
References: <1323798271-1452-1-git-send-email-mikew@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Dec 2011 14:51:16 +0400
Message-ID: <1323859876.3063.39.camel@dabdike>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-13 at 09:44 -0800, Mike Waychison wrote:
> On a single core system with kernel preemption disabled, it is possible
> for the memory system to be so taxed that kswapd cannot make any forward
> progress.  This can happen when most of system memory is tied up as
> anonymous memory without swap enabled, causing kswapd to consistently
> fail to achieve its watermark goals.  In turn, sleeping_prematurely()
> will consistently return true and kswapd_try_to_sleep() to never invoke
> schedule().  This causes the kswapd thread to stay on the CPU in
> perpetuity and keeps other threads from processing oom-kills to reclaim
> memory.
> 
> The cond_resched() instance in balance_pgdat() is never called as the
> loop that iterates from DEF_PRIORITY down to 0 will always set
> all_zones_ok to true, and not set it to false once we've passed
> DEF_PRIORITY as zones that are marked ->all_unreclaimable are not
> considered in the "all_zones_ok" evaluation.
> 
> This change modifies kswapd_try_to_sleep to ensure that we enter
> scheduler at least once per invocation if needed.  This allows kswapd to
> get off the CPU and allows other threads to die off from the OOM killer
> (freeing memory that is otherwise unavailable in the process).

This keeps cropping up.  I think it's not the same as the last time I
saw it (which was on a multi-core system) but it was definitely caused
by an issue with sleeping_prematurely().  For reference, this is the
thread:

http://marc.info/?t=130436700400001

And this was the eventual fix that worked for me:

http://marc.info/?t=130892304300003

James


