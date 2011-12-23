Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757640Ab1LWTIa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 14:08:30 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:43863 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753655Ab1LWTI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 14:08:28 -0500
Date: Fri, 23 Dec 2011 11:08:19 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Mel Gorman <mgorman@suse.de>
cc: Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>, Dave Jones <davej@redhat.com>,
        Jan Kara <jack@suse.cz>, Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Nai Xia <nai.xia@gmail.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 11/11] mm: Isolate pages for immediate reclaim on their
 own LRU
In-Reply-To: <20111220095544.GP3487@suse.de>
Message-ID: <alpine.LSU.2.00.1112231039030.17640@eggly.anvils>
References: <1323877293-15401-1-git-send-email-mgorman@suse.de> <1323877293-15401-12-git-send-email-mgorman@suse.de> <20111217160822.GA10064@barrios-laptop.redhat.com> <20111219132615.GL3487@suse.de> <20111220071026.GA19025@barrios-laptop.redhat.com>
 <20111220095544.GP3487@suse.de>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, Mel, I've had to revert this patch (and its two little children)
from my 3.2.0-rc6-next-20111222 testing: you really do need a page flag
(or substitute) for your "immediate" lru.

How else can a del_page_from_lru[_list]() know whether to decrement
the count of the immediate or the inactive list?  page_lru() says to
decrement the count of the inactive list, so in due course that wraps
to a gigantic number, and then page reclaim livelocks trying to wring
pages out of an empty list.  It's the memcg case I've been hitting,
but presumably the same happens with global counts.

There is another such accounting bug in -next, been there longer and
not so easy to hit: I'm fairly sure it will turn out to be memcg
misaccounting a THPage somewhere, I'll have a look around shortly.

Hugh

p.s. Immediate?  Isn't that an odd name for a list of pages which are
not immediately freeable?  Maybe Rik's launder/laundry name would be
better: pages which are currently being cleaned.
