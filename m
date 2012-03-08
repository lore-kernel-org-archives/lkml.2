Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757866Ab2CHVoi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 16:44:38 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:55409 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757767Ab2CHVoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 16:44:37 -0500
Date: Thu, 8 Mar 2012 21:44:25 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, linux-mm@kvack.org,
        davej@redhat.com, jboyer@redhat.com, tyhicks@canonical.com,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH] hugetlbfs: lockdep annotate root inode properly
Message-ID: <20120308214425.GA23916@ZenIV.linux.org.uk>
References: <1331198116-13670-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <20120308130256.c7855cbd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120308130256.c7855cbd.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2012 at 01:02:56PM -0800, Andrew Morton wrote:
> > This fix the below lockdep warning
> 
> OK, what's going on here.

Deadlock in hugetlbfs mmap getting misreported.

One last time: ->mmap_sem nests inside ->i_mutex.  Both for regular
files and for directories.  Always had.

For directories there's copy_to_user() from ->readdir() done under ->i_mutex.
For regular files there's copy_from_user() from ->write(), usually done under
->i_mutex.  On hugetlbfs there's copy_to_user() from ->read() done under
->i_mutex.

It had not changed at all.  Lockdep sees both call chains; the only question
is which chain is seen first.  And usually reading a directory happens earlier
in the boot than writing into a file.  That's all there is to it.

Unfortunately, the fact that call chain being reported is obviously about
directories leads to false hopes that deadlock doesn't exist - mmap()
obviously can't happen to a directory inode, so people hope that it's a
false positive.  It isn't.

Patch separating directory and non-directory ->i_mutex into different classes
went in at some point, precisely due to those hopes.  It had a braino that
made it useless.  Fix for that braino had been posted and sits my queue; I'll
push it to Linus along with other pending fixes tonight.

It will *not* eliminate the (very real) deadlock.  It might make the warning
go away, but only if read() on hugetlbfs files doesn't happen during boot.

I suspect that they right thing would be to have a way to set explicit
nesting rules, not tied to speficic call trace.  I hadn't looked into
lockdep guts, so no idea how much will that hurt to implement.  As in
lockdep_lock_nests(class_outer, class_inner, message), acting as if
there had been a call chain where class_outer had been taken before
class_inner, with message going in place of call trace for that chain
when we run into a conflict...
