Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589Ab2BRK4J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 05:56:09 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:58163 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab2BRK4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 05:56:07 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>, Tyler Hicks <tyhicks@canonical.com>
Cc: Josh Boyer <jwboyer@redhat.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: hugetlbfs lockdep spew revisited.
In-Reply-To: <20120217004922.GN23916@ZenIV.linux.org.uk>
References: <20120217000856.GA13112@redhat.com> <20120217001634.GH23550@zod.bos.redhat.com> <20120217003848.GB20071@boyd> <20120217004922.GN23916@ZenIV.linux.org.uk>
User-Agent: Notmuch/0.11.1+190~g31a336a (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Sat, 18 Feb 2012 16:25:38 +0530
Message-ID: <87vcn4cswl.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12021800-1396-0000-0000-000000B12BEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Feb 2012 00:49:22 +0000, Al Viro <viro@ZenIV.linux.org.uk> wrote:
> On Thu, Feb 16, 2012 at 06:38:49PM -0600, Tyler Hicks wrote:
> > On 2012-02-16 19:16:34, Josh Boyer wrote:
> > > On Thu, Feb 16, 2012 at 07:08:57PM -0500, Dave Jones wrote:
> > > > Remember this ? https://lkml.org/lkml/2011/4/15/272
> > > > Josh took a stab at fixing it in e096d0c7e2e4e5893792db865dd065ac73cf1f00,
> > > > but it seems to still be there.
> > > 
> > > I think Tyler Hicks actually noticed this a while ago, but his patch has
> > > been waiting on comment from Al and Christoph:
> > > 
> > > http://thread.gmane.org/gmane.linux.file-systems/58795/focus=59565
> > > 
> > > I've been hesitant to comment because I obviously screwed up once
> > > already.  We could try this patch in Fedora for a while if Al and
> > > company don't speak up soon.
> > 
> > I'm pretty confident that my patch that Josh linked to would "fix" the
> > lockdep warning below. According to the backtrace, it is barking about a
> > directory inode and a regular inode having a circular locking
> > dependency, so deadlock is not possible in this case.
> 
> Sigh...  That patch is correct, but it has nothing to do with the locking
> order violation that really *is* there.  The only benefit would be to
> get rid of the "deadlock is not possible" nonsense, since you would see
> read/write vs. mmap instead of readdir vs. mmap in the traces.  Locking
> order is the *same* for directories and nondirectories; both can have
> pagefaults under ->i_mutex on their respective inodes.  And while mmap
> cannot happen for directories, it certainly can happen for regular files,
> so taking ->i_mutex in ->mmap() is a plain and simple bug.  Should never
> be done; in particular, hugetlbfs has ->i_mutex held in read() around
> pagefaults, which gives you an obvious deadlock with its ->mmap().
> 
> Folks, this is not a false positive and it has nothing to do with misannotation
> for directories.  Deadlock is real; I have no idea WTF do we what ->i_mutex
> held over that area in hugetlbfs ->mmap(), but doing that is really, really
> wrong, whatever the reason.

I looked at hugetlbfs recently and noticed this. Another strange thing
with hugetlbfs is, it doesn't support write, instead allows to bump
the file size via mmap. I don't have a patch for inode->i_mutex issue
yet.

-aneesh

