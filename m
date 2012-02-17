Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250Ab2BQA12 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 19:27:28 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:56722 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756102Ab2BQA11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 19:27:27 -0500
Date: Fri, 17 Feb 2012 00:27:26 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Jones <davej@redhat.com>, Josh Boyer <jboyer@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: hugetlbfs lockdep spew revisited.
Message-ID: <20120217002726.GL23916@ZenIV.linux.org.uk>
References: <20120217000856.GA13112@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120217000856.GA13112@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 07:08:57PM -0500, Dave Jones wrote:
> Remember this ? https://lkml.org/lkml/2011/4/15/272
> Josh took a stab at fixing it in e096d0c7e2e4e5893792db865dd065ac73cf1f00,
> but it seems to still be there.

> the existing dependency chain (in reverse order) is:

[snip]

... and as bloody usual, that mentioning of readdir in the output is a
red herring; the real problem (and yes, it *is* deadlock-prone) is not
with getdents(2) that cannot happen on anything that could be mmaped;
it's with hugetlbfs_read() (i.e. read(2)) that very definitely *can*.

This is *not* a misannotation and not a false positive; this is a real,
honest deadlock.
Thread A:
	read() on hugetlbfs
	hugetlbfs_read() called
	i_mutex grabbed
	hugetlbfs_read_actor() called
	__copy_to_user() called
	page fault is triggered
Thread B, sharing address space with A:
	mmap() the same file
	->mmap_sem is grabbed on task_B->mm->mmap_sem
	hugetlbfs_file_mmap() is called
	attempt to grab ->i_mutex and block waiting for A to give it up
Thread A:
	pagefault handled blocked on attempt to grab task_A->mm->mmap_sem,
which happens to be the same thing as task_B->mm->mmap_sem.  Block waiting
for B to give it up.

Deadlock.
