Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab2ITVmf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 17:42:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34911 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578Ab2ITVme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 17:42:34 -0400
Date: Thu, 20 Sep 2012 14:42:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Minchan Kim <minchan@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH v3] memory-hotplug: fix zone stat mismatch
Message-Id: <20120920144232.a3e8b60f.akpm@linux-foundation.org>
In-Reply-To: <1348123405-30641-1-git-send-email-minchan@kernel.org>
References: <1348123405-30641-1-git-send-email-minchan@kernel.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2012 15:43:25 +0900
Minchan Kim <minchan@kernel.org> wrote:

> During memory-hotplug, I found NR_ISOLATED_[ANON|FILE]
> are increasing so that kernel are hang out.
> 
> The cause is that when we do memory-hotadd after memory-remove,
> __zone_pcp_update clear out zone's ZONE_STAT_ITEMS in setup_pageset
> although vm_stat_diff of all CPU still have value.
> 
> In addtion, when we offline all pages of the zone, we reset them
> in zone_pcp_reset without drain so that we lost zone stat item.
> 

Here's what I ended up with for a changelog:

: During memory-hotplug, I found NR_ISOLATED_[ANON|FILE] are increasing,
: causing the kernel to hang.  When the system doesn't have enough free
: pages, it enters reclaim but never reclaim any pages due to
: too_many_isolated()==true and loops forever.
: 
: The cause is that when we do memory-hotadd after memory-remove,
: __zone_pcp_update() clears a zone's ZONE_STAT_ITEMS in setup_pageset()
: although the vm_stat_diff of all CPUs still have values.
: 
: In addtion, when we offline all pages of the zone, we reset them in
: zone_pcp_reset without draining so we loss some zone stat item.


As memory hotplug seems fairly immature and broken, I'm thinking
there's no point in backporting this into -stable.  And I don't *think*
we really need it in 3.6 either?  (It doesn't apply cleanly to current
mainline anyway - I didn't check why).


