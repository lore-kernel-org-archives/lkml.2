Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab2FCWSH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 18:18:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48709 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617Ab2FCWSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 18:18:05 -0400
Date: Sun, 3 Jun 2012 15:17:36 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <amwang@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: WARNING: at mm/page-writeback.c:1990
 __set_page_dirty_nobuffers+0x13a/0x170()
In-Reply-To: <20120603205332.GA5412@redhat.com>
Message-ID: <alpine.LSU.2.00.1206031459450.15427@eggly.anvils>
References: <20120601023107.GA19445@redhat.com> <alpine.LSU.2.00.1206010030050.8462@eggly.anvils> <20120601161205.GA1918@redhat.com> <20120601171606.GA3794@redhat.com> <alpine.LSU.2.00.1206011511560.12839@eggly.anvils> <CA+55aFy2-X92EqpiuyvkBp_2-UaYDUpaC2c3XT3gXMN1O+T7sw@mail.gmail.com>
 <alpine.LSU.2.00.1206012108430.11308@eggly.anvils> <20120603181548.GA306@redhat.com> <CA+55aFwZ5PsBLqM7K8vDQdbS3sf+vi3yeoWx6XKV=nF8k2r7DQ@mail.gmail.com> <20120603183139.GA1061@redhat.com> <20120603205332.GA5412@redhat.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Jun 2012, Dave Jones wrote:
> On Sun, Jun 03, 2012 at 02:31:39PM -0400, Dave Jones wrote:
>  > On Sun, Jun 03, 2012 at 11:23:29AM -0700, Linus Torvalds wrote:
>  >  > On Sun, Jun 3, 2012 at 11:15 AM, Dave Jones <davej@redhat.com> wrote:
>  >  > >
>  >  > > Things aren't happy with that patch at all.
>  >  > 
>  >  > Yeah, at this point I think we need to just revert the compaction changes.
>  >  > 
>  >  > Guys, what's the minimal set of commits to revert? That clearly buggy
>  >  > "rescue_unmovable_pageblock()" function was introduced by commit
>  >  > 5ceb9ce6fe94, but is that actually involved with the particular bug?
>  >  > That commit seems to revert cleanly still, but is that sufficient or
>  >  > does it even matter?
>  > 
>  > I'l rerun the test with that (and Hugh's last patch) backed out, and see
>  > if that makes any difference.
> 
> running just over two hours with that commit reverted with no obvious ill effects so far.

Yes, and I ran happily with precisely that commit reverted on Friday -
though I've never got the list corruption that you saw with it in.  

The locking bug certainly comes in with that commit, it's an isolated
commit that reverts cleanly, and I think you got the list corruption
rather sooner than two hours before (9min, 30min, 41min from the traces
you sent).

Maybe we should let you run a little longer, or wait for others to comment.

But another strike against that commit: I tried fixing it up to use
start_page instead of page at the end, with the worrying but safer
locking I suggested at first, with a count of how many times it went
there, and how many times it succeeded.

While I ran my usual swapping test (perhaps that's a very unfair test
to run on this, I've no idea) for seven hours, it went there 25406
times (once per second, it appears) and it succeeded... 0 times.

Let's hope it failed quickly each time, I wasn't capturing that.

Hugh
