Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932542Ab2FBE7S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 00:59:18 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:59654 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756993Ab2FBE7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 00:59:17 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1206012108430.11308@eggly.anvils>
References: <20120530163317.GA13189@redhat.com> <20120531005739.GA4532@redhat.com>
 <20120601023107.GA19445@redhat.com> <alpine.LSU.2.00.1206010030050.8462@eggly.anvils>
 <20120601161205.GA1918@redhat.com> <20120601171606.GA3794@redhat.com>
 <alpine.LSU.2.00.1206011511560.12839@eggly.anvils> <CA+55aFy2-X92EqpiuyvkBp_2-UaYDUpaC2c3XT3gXMN1O+T7sw@mail.gmail.com>
 <alpine.LSU.2.00.1206012108430.11308@eggly.anvils>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 1 Jun 2012 21:58:50 -0700
X-Google-Sender-Auth: 1BphR7UYHfcZPYjKyGWiFBLzWiI
Message-ID: <CA+55aFytGfGm2mmF-9BwjqiDCtNpz40AkQrmGOqduss2YAiEvQ@mail.gmail.com>
Subject: Re: WARNING: at mm/page-writeback.c:1990 __set_page_dirty_nobuffers+0x13a/0x170()
To: Hugh Dickins <hughd@google.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        Rik van Riel <riel@redhat.com>, Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <amwang@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 1, 2012 at 9:40 PM, Hugh Dickins <hughd@google.com> wrote:
>
> Move the lock after the loop, I think you meant.

Well, I wasn't sure if anything inside the loop might need it. I don't
*think* so, but at the same time, what protects "page_order(page)"
(or, indeed PageBuddy()) from being stable while that loop content
uses them?

I don't understand that code at all. It does that crazy iteration over
page, and changes "page" in random ways, and then finishes up with a
totally new "page" value that is some random thing that is *after* the
end_page thing. WHAT?

The code makes no sense. It tests all those pages within the
page-block, but then after it has done all those tests, it does the
final

  set_pageblock_migratetype(..)
  move_freepages_block(..)

using a page that is *beyond* the pageblock (and with the whole
page_order() thing, who knows just how far beyond it?)

It looks entirely too much like random-monkey code to me.

            Linus
