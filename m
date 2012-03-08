Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757812Ab2CHVuB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 16:50:01 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:55150 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757193Ab2CHVuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 16:50:00 -0500
Date: Thu, 8 Mar 2012 21:49:52 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tyler Hicks <tyhicks@canonical.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        linux-mm@kvack.org, davej@redhat.com, jboyer@redhat.com,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH] hugetlbfs: lockdep annotate root inode properly
Message-ID: <20120308214951.GB23916@ZenIV.linux.org.uk>
References: <1331198116-13670-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <20120308130256.c7855cbd.akpm@linux-foundation.org>
 <20120308211926.GB6546@boyd>
 <20120308134050.f53a0b2f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120308134050.f53a0b2f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2012 at 01:40:50PM -0800, Andrew Morton wrote:

> OK, thanks, yup.  Taking i_mutex in file_operations.mmap() is wrong.

... or in .release() (munmap() does fput() under mmap_sem).

> Is hugetlbfs actually deadlockable because of this, or is it the case
> that the i_mutex->mmap_sem ordering happens to never happen for this
> filesystem?

Yes, it is.  Look at read(2) on hugetlbfs; it copies userland data
while holding ->i_mutex.  So we have

read(2):
mutex_lock(&A)
down_read(&B)

mmap(2):
down_write(&B);
mutex_lock(&A);

which is an obvious deadlock.

> So we need to pull the i_mutex out of hugetlbfs_file_mmap().

IIRC, you have a patch in your tree doing just that...
