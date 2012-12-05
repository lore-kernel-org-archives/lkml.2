Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557Ab2LEG2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 01:28:39 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:40324 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060Ab2LEG2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 01:28:37 -0500
Date: Tue, 4 Dec 2012 22:28:33 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Mel Gorman <mgorman@suse.de>
cc: Tommi Rantala <tt.rantala@gmail.com>, Stable <stable@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Jones <davej@redhat.com>, Christoph Lameter <cl@linux.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH 5/5] mempolicy: fix a memory corruption by refcount
 imbalance in alloc_pages_vma()
In-Reply-To: <alpine.LNX.2.00.1212042042130.13895@eggly.anvils>
Message-ID: <alpine.LNX.2.00.1212042211340.892@eggly.anvils>
References: <1349801921-16598-1-git-send-email-mgorman@suse.de> <1349801921-16598-6-git-send-email-mgorman@suse.de> <CA+ydwtqQ7iK_1E+7ctLxYe8JZY+SzMfuRagjyHJ12OYsxbMcaA@mail.gmail.com> <20121204141501.GA2797@suse.de>
 <alpine.LNX.2.00.1212042042130.13895@eggly.anvils>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Dec 2012, Hugh Dickins wrote:
> 
> Yes, your patch fixes it Mel, but I prefer it as below, with a couple
> of mods: removing the no longer true comment, and leaving shmem_swapin()
> alone with just a comment.  It appears to be the job of the rather weird
> mpol_cond_copy() to drop the reference on the original mempolicy, and
> clear MPOL_F_SHARED so the copy won't need one (it's trying to cope with
> the fact that swapin_readahead will make an unknown number of calls to
> alloc_page_vma).  So I'd rather not add another mpol_cond_put there,
> whose cond will never be met.

Hold on, ignore that patch for now, I think I had my priorities
upside down: it would be better for shmem_swapin() to behave as
you proposed, and we delete the mpol_cond_copy() weirdness instead.

Your 00442ad04a5e changed alloc_pages_vma() to keep its refcounting
in balance, so it now does not matter that swapin_readahead() makes
an unknown number of calls to it: we should simply take a reference
before and drop it after, just as you do in shmem_alloc_page().

I'd still like to revisit alloc_page_vma(), and its refcount
manipulations do now appear redundant; but changing that is not
something I want to get into in a last minute rush.  But getting rid
of mpol_cond_copy() should be safe and clear, I'll test that out now
and reply with an updated patch (or else admit I got confused).

Hugh
