Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759976Ab2FAOJv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 10:09:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21885 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758970Ab2FAOJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 10:09:50 -0400
Date: Fri, 1 Jun 2012 10:09:43 -0400
From: Dave Jones <davej@redhat.com>
To: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: WARNING: at mm/page-writeback.c:1990
 __set_page_dirty_nobuffers+0x13a/0x170()
Message-ID: <20120601140943.GB1732@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Cong Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
References: <20120530163317.GA13189@redhat.com>
 <20120531005739.GA4532@redhat.com>
 <20120601023107.GA19445@redhat.com>
 <alpine.LSU.2.00.1206010030050.8462@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1206010030050.8462@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2012 at 01:44:44AM -0700, Hugh Dickins wrote:

 > > 3f31d07571eeea18a7d34db9af21d2285b807a17 is the first bad commit
 > > commit 3f31d07571eeea18a7d34db9af21d2285b807a17
 > > Author: Hugh Dickins <hughd@google.com>
 > > Date:   Tue May 29 15:06:40 2012 -0700
 > > 
 > >     mm/fs: route MADV_REMOVE to FALLOC_FL_PUNCH_HOLE
 > >     
 > >     Now tmpfs supports hole-punching via fallocate(), switch madvise_remove()
 > >     to use do_fallocate() instead of vmtruncate_range(): which extends
 > >     madvise(,,MADV_REMOVE) support from tmpfs to ext4, ocfs2 and xfs.
 > > 
 > > Hugh ?
 > 
 > Ow, you've caught me.

As I said in another mail, it looks like the bisect was wrong somewhere,
as with this backed out I still see problems.
 
 > One half of the patch at the bottom should fix that: I'm not sure that
 > it's the fix we actually want (a mapping_cap_account_dirty test might
 > be more appropriate, but it's easier just to test a page flag here);
 > but it should be good to shed more light on the problem.

I'll give the patch a try anyway, as builds are quick on that box.

 > So I'm wondering if your trinity fuzzer happens to succeed a lot more
 > often on madvise MADV_REMOVEs than fallocate FALLOC_FL_PUNCH_HOLEs, and
 > the bug you converged on is not in tmpfs, but in ext4 (or xfs? or ocfs2?),
 > which began to support MADV_REMOVE with that commit.

ext4 is a possibility.
 
 > So the second half of the patch should show which filesystem's page is
 > involved when you hit the WARN_ON - unless the first half of the patch
 > turns out to stop the warnings completely, in which case I need to think
 > harder about what was going on in tmpfs, and whether it matters.
 > 
 > Or another possibility is that the bad commit doesn't actually touch mm
 > at all: you were doing a bisection just on mm/ changes, weren't you?

oh, good point. It hadn't occured to me that this could be fs related.
The mm-heavy stack-trace may have misled me.

 > > Sometimes during the bisect these errors happened
 > > in pairs, sometimes only together.
 > 
 > Sometimes in pairs, sometimes together?  I don't understand.

beware late-night emails. I meant sometimes I saw both the list-debug's and the WARN,
but other times I saw only one or the other.

 > Please give this patch a try (preferably on current git), and let us know.
 
Will do.

	Dave
