Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694Ab2EPXBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 19:01:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53903 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760744Ab2EPXBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 19:01:32 -0400
Date: Wed, 16 May 2012 16:01:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 6/6] mm: memcg: print statistics from live counters
Message-Id: <20120516160131.fecb5ddf.akpm@linux-foundation.org>
In-Reply-To: <1337018451-27359-7-git-send-email-hannes@cmpxchg.org>
References: <1337018451-27359-1-git-send-email-hannes@cmpxchg.org>
	<1337018451-27359-7-git-send-email-hannes@cmpxchg.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2012 20:00:51 +0200
Johannes Weiner <hannes@cmpxchg.org> wrote:

> Directly print statistics and event counters instead of going through
> an intermediate accumulation stage into a separate array, which used
> to require defining statistic items in more than one place.
> 
> ...
>
> -static const char *memcg_stat_strings[NR_MCS_STAT] = {
> -	"cache",
> -	"rss",
> -	"mapped_file",

Bah humbug, who went and called this mapped_file?

This stat is derived from MEM_CGROUP_STAT_FILE_MAPPED.  But if we
rename MEM_CGROUP_STAT_FILE_MAPPED to MEM_CGROUP_STAT_MAPPED_FILE then
we also need to rename the non-memcg NR_FILE_MAPPED.  And we can't
change the text to "file_mapped" because it's ABI.

> -	"mlock",
> -	"swap",

And "swap" is derived from MEM_CGROUP_STAT_SWAPOUT.  We could rename
that to MEM_CGROUP_STAT_SWAP without trouble.

But both are poor names.  There are two concepts here: a) swapout
events (ie: swap writeout initiation) and b) swapspace usage.  Type a)
only ever counts up, whereas type b) counts up and down.

MEM_CGROUP_STAT_SWAPOUT is actually of type b), but "swapout" is a
misleading term, because it refers to type a) events.

And the human-displayed "swap" is useless because it can refer to
either type a) or type b) events.  These should be called "swapped" and
MEM_CGROUP_STAT_SWAPPED.  But we can't change the userspace interface.

argh, I hate you all!

