Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492Ab1HBNAZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 09:00:25 -0400
Received: from mx2.parallels.com ([64.131.90.16]:46682 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752096Ab1HBNAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 09:00:20 -0400
X-Greylist: delayed 782 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Aug 2011 09:00:19 EDT
Message-ID: <4E37F19F.6080107@parallels.com>
Date: Tue, 2 Aug 2011 09:46:23 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Thunderbird/3.1.11
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <containers@lists.linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        James Bottomley <JBottomley@parallels.com>
Subject: Re: [PATCH 2/4] limit nr_dentries per superblock
References: <1311947059-17209-1-git-send-email-glommer@parallels.com> <1311947059-17209-3-git-send-email-glommer@parallels.com> <20110731011531.GL5404@dastard>
In-Reply-To: <20110731011531.GL5404@dastard>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [187.106.54.7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Thank you for your comments. I actually agree with most of the things 
you pointed out, so I'll focus my reply here only.

> Also, this doesn't address the problem I originally commented on -
> it only shrinks the dcache, not the inode or filesystem caches that
> hold all the memory.

I understand that the icache is a greater memory user than the dcache.
I also understand that the icache can be dirty due to pending IO.
I am also okay to shrink some of the icache every time we shrink the 
dcache - and see below, this might happen if I change they way I am 
calling the shrinker.

However, since the dcache precedes the icache in the cache hierarchy,
and is the actual entity pinning the icache into memory, I don't see a 
reason to *limit* the icache size, since once the dcache is limited,
anything holding the icache into memory will go away eventually, and the 
shrinkers that run during memory pressure will be able to get rid of it.

> I mentioned the new per-sb shrinkers for a
> reason - you should be calling them, not __shrink_dcache_sb(). i.e.
> building a scan_control structure and calling
> sb->shrinker.shrink(&sb->shrinker,&sc);
>

Would you be okay with having prune_super() being called whenever the
nr_dentries_max limit is reached? It will effectively shrink both
the icache and the dcache, using the dentry limit as a trigger only.

> I'm seriously starting to think that this needs to share an
> implementation with the mm shrinker code, because it already
> solves most of these problems...

I have to think more about that. Hold on!
