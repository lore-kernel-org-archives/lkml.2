Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235Ab1DOVVJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 17:21:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49604 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757160Ab1DOVVH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 17:21:07 -0400
MIME-Version: 1.0
In-Reply-To: <1302901766.2035.39.camel@laptop>
References: <20110415201652.GA5131@redhat.com> <BANLkTi=ctr7tQLArfbdHRU3uUvEPh6KbwQ@mail.gmail.com>
 <20110415205712.GA13049@infradead.org> <1302901766.2035.39.camel@laptop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 15 Apr 2011 14:19:01 -0700
Message-ID: <BANLkTimg+sVCAE17jLE9oz301oruVZbdbw@mail.gmail.com>
Subject: Re: hugetlb locking bug.
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        William Irwin <wli@holomorphy.com>, Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 15, 2011 at 2:09 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2011-04-15 at 16:57 -0400, Christoph Hellwig wrote:
>>
>> Because it doesn't use iget or unlock_new_inode, but rather calls
>> directly into new_inode().  It and other filesystems not using
>> unlock_new_inode will need a local copy of that logic.
>
> Is there a sane reason they do their own magic, and thus need a copy of
> the logic, instead of using the generic code that already has it?

Hmm. That all seems to be just an oversight.

Does this trivial one-liner work?

(Warning: whitespace damage and TOTALLY UNTESTED)

                      Linus

---

 fs/hugetlbfs/inode.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index b9eeb1cd03ff..a14a6e03ec33 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -491,6 +491,7 @@ static struct inode *hugetlbfs_get_inode(struct
super_block *sb, uid_t uid,
                        inode->i_op = &page_symlink_inode_operations;
                        break;
                }
+               unlock_new_inode(inode);
        }
        return inode;
 }
