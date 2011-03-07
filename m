Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab1CGDO5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 22:14:57 -0500
Received: from smtp-out.google.com ([216.239.44.51]:10239 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183Ab1CGDOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 22:14:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=yFM0L4wRAobjd4VGDRw44cz4GR7gbbWEfTaKRcLIW0UgAa75GftsGiIW8WYoQyif1D
         5V6ZsEhpUGQVnfHmgfaQ==
Date: Sun, 6 Mar 2011 18:34:34 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andy Walls <awalls@md.metrocast.net>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        David Miller <davem@davemloft.net>, linux-media@vger.kernel.org,
        Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: BUG at mm/mmap.c:2309 when cx18.ko and cx18-alsa.ko loaded
In-Reply-To: <1299445446.2310.157.camel@localhost>
Message-ID: <alpine.LSU.2.00.1103061828050.4096@sister.anvils>
References: <1299204400.2812.35.camel@localhost> <1299362366.2570.27.camel@localhost> <1299377017.2341.50.camel@localhost> <AANLkTimU9qV11p+wTDz4SCvaoYyxpja8tmJ5D7-ki==B@mail.gmail.com> <1299445446.2310.157.camel@localhost>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Mar 2011, Andy Walls wrote:
> On Sun, 2011-03-06 at 10:37 -0800, Hugh Dickins wrote:
> 
> > There was a horrid list corruption bug in early 2.6.38-rc, fixed in
> > -rc6; but although I guess it could cause all kinds of havoc, its
> > particular signature was not like this, so I don't really believe that
> > one was to blame here.
> 
> Sounds like it may be worth me reviewing the commits that introduced the
> failure and the commit that fixed it.  Do you happen to know what they
> are?

Here are the several fixes, which reference LKML threads and culprits:
it seems to have been a danger since 2.6.33, made much worse recently.

commit ceaaec98ad99859ac90ac6863ad0a6cd075d8e0e
Author: Eric Dumazet <eric.dumazet@gmail.com>
Date:   Thu Feb 17 22:59:19 2011 +0000

    net: deinit automatic LIST_HEAD
    
    commit 9b5e383c11b08784 (net: Introduce
    unregister_netdevice_many()) left an active LIST_HEAD() in
    rollback_registered(), with possible memory corruption.
    
    Even if device is freed without touching its unreg_list (and therefore
    touching the previous memory location holding LISTE_HEAD(single), better
    close the bug for good, since its really subtle.
    
    (Same fix for default_device_exit_batch() for completeness)
    
    Reported-by: Michal Hocko <mhocko@suse.cz>
    Tested-by: Michal Hocko <mhocko@suse.cz>
    Reported-by: Eric W. Biderman <ebiderman@xmission.com>
    Tested-by: Eric W. Biderman <ebiderman@xmission.com>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
    Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
    CC: Ingo Molnar <mingo@elte.hu>
    CC: Octavian Purdila <opurdila@ixiacom.com>
    CC: stable <stable@kernel.org> [.33+]
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit f87e6f47933e3ebeced9bb12615e830a72cedce4
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu Feb 17 22:54:38 2011 +0000

    net: dont leave active on stack LIST_HEAD
    
    Eric W. Biderman and Michal Hocko reported various memory corruptions
    that we suspected to be related to a LIST head located on stack, that
    was manipulated after thread left function frame (and eventually exited,
    so its stack was freed and reused).
    
    Eric Dumazet suggested the problem was probably coming from commit
    443457242beb (net: factorize
    sync-rcu call in unregister_netdevice_many)
    
    This patch fixes __dev_close() and dev_close() to properly deinit their
    respective LIST_HEAD(single) before exiting.
    
    References: https://lkml.org/lkml/2011/2/16/304
    References: https://lkml.org/lkml/2011/2/14/223
    
    Reported-by: Michal Hocko <mhocko@suse.cz>
    Tested-by: Michal Hocko <mhocko@suse.cz>
    Reported-by: Eric W. Biderman <ebiderman@xmission.com>
    Tested-by: Eric W. Biderman <ebiderman@xmission.com>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
    Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
    CC: Ingo Molnar <mingo@elte.hu>
    CC: Octavian Purdila <opurdila@ixiacom.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 3c18d4de86e4a7f93815c081e50e0543fa27200f
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri Feb 18 11:32:28 2011 -0800

    Expand CONFIG_DEBUG_LIST to several other list operations
    
    When list debugging is enabled, we aim to readably show list corruption
    errors, and the basic list_add/list_del operations end up having extra
    debugging code in them to do some basic validation of the list entries.
    
    However, "list_del_init()" and "list_move[_tail]()" ended up avoiding
    the debug code due to how they were written. This fixes that.
    
    So the _next_ time we have list_move() problems with stale list entries,
    we'll hopefully have an easier time finding them..
    
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
