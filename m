Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932405Ab2E3JCk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 05:02:40 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:50522 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932272Ab2E3JCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 05:02:38 -0400
From: kosaki.motohiro@gmail.com
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Andrew Morton <akpm@google.com>,
        Dave Jones <davej@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, stable@vger.kernel.org,
        hughd@google.com, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 0/6] mempolicy memory corruption fixlet
Date: Wed, 30 May 2012 05:02:03 -0400
Message-Id: <1338368529-21784-1-git-send-email-kosaki.motohiro@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Hi Linus and all

Sorry for the long long delay.

Maybe I've finished a code auditing of mempolicy.c. It was hard work, multiple
mistakes hided real issues. :-/

Yes, my code auditing is too slow as usual, I know. But probably a slow work is 
better than do nothing, maybe.

Sadly, I've found multiple long living bugs and almost patches in this area were
 committed with no review.  That's sad. Therefore, I'd like to maintain this area 
a while (hopefully short) until known breakage will be fixed or finding another
volunteer. The purpose is not developing new feature. It is preventing more
corruption until known issue is fixed. (Of course, if anyone want to take the role,
I'm really happy and drop patch 6/6.

Here are some bandaid fixing patch set for mempolicy. It may fix all known uservisible
corruptions. But, I know, we have a lot of remained work. Below are unfixed issues.
(because of, they are broken by design. I can't fix them w/o design change)

1) mpol mount option of tmpfs doesn't work correctly

When not using =static mount option modifier, a nodemask is affected cpuset restriction 
of *inode creation* thread and ignore page allocation thread.

2) cpuset rebinding doesn't work correctly if shmem are shared from multiple processes.

mbind(2) (and set_mempolicy(2)) stores pre-calculated mask, say, 
(mbind-mask & cpuset-mask & online-nodes-mask) into struct mempolicy.
and the mempolicy attaches vma and shmem regions. But, of course, 
cpuset-mask depend on a thread. Thus we can't calculate final node mask
on ahead.

3) mbind(2) doesn't work correctly if shmem are shared from multiple processes.

The same of (2). mbind(2) stores final nodemask, but another thread have another
final node mask. The calculation is incorrect.


So, I think we should reconsider about shared mempolicy completely. If my remember 
is correct, Hugh said he worry about this feature because nobody seems
to use and lots bug about 4 years ago. As usually he is, he is correct. now, I'm 
convinced nobody uses this feature. Current  all of my patches are trivial and 
we can easily reproduce kernel memory corruption. And it don't work proper 
functionality (see above todo list). Thus, I'd like to hear his opinion. if he 
still dislike shared mempolicy feature, I'm ok to remove it entirely instead of 
applying current bandaid patch set.

Thank you.


-----------------------------------------------
KOSAKI Motohiro (6):
  Revert "mm: mempolicy: Let vma_merge and vma_split handle
    vma->vm_policy linkages"
  mempolicy: Kill all mempolicy sharing
  mempolicy: fix a race in shared_policy_replace()
  mempolicy: fix refcount leak in mpol_set_shared_policy()
  mempolicy: fix a memory corruption by refcount imbalance in
    alloc_pages_vma()
  MAINTAINERS: Added MEMPOLICY entry

 MAINTAINERS    |    7 +++
 mm/mempolicy.c |  151 ++++++++++++++++++++++++++++++++++++++++----------------
 mm/shmem.c     |    9 ++--
 3 files changed, 120 insertions(+), 47 deletions(-)

