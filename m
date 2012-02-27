Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab2B0XLi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 18:11:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47509 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754962Ab2B0XLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 18:11:37 -0500
Date: Mon, 27 Feb 2012 15:11:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com,
        dhillf@gmail.com, viro@zeniv.linux.org.uk, hughd@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hugetlbfs: Add new rw_semaphore to fix truncate/read
 race
Message-Id: <20120227151135.7d4076c6.akpm@linux-foundation.org>
In-Reply-To: <1330280398-27956-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1330280398-27956-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Feb 2012 23:49:58 +0530
"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:

> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
> 
> Drop using inode->i_mutex from read, since that can result in deadlock with
> mmap. Ideally we can extend the patch to make sure we don't increase i_size
> in mmap. But that will break userspace, because application will have to now
> use truncate(2) to increase i_size in hugetlbfs.
> 
> AFAIU i_mutex was added in hugetlbfs_read as per
> http://lkml.indiana.edu/hypermail/linux/kernel/0707.2/3066.html

This patch comes somewhat out of the blue and I'm unsure what's going on.

You say there's some (potential?) deadlock with mmap, but it is
undescribed.  Have people observed this deadlock?  Has it caused
lockdep warnings?  Please update the changelog to fully describe the
bug.

Also, the new truncate_sem is undoumented.  This leaves readers to work
out for themselves what it might be for.  Please let's add code
comments which completely describe the race, and how this lock prevents
it.

We should also document our locking rules.  When should code take this
lock?  What are its ranking rules with respect to i_mutex, i_mmap_mutex
and possibly others?


