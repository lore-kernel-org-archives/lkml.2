Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732Ab2BFVRa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 16:17:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47585 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755709Ab2BFVR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 16:17:28 -0500
Date: Mon, 6 Feb 2012 13:17:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        hare@suse.de, Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH] vfs: Avoid IPI storm due to bh LRU invalidation
Message-Id: <20120206131717.c4346f72.akpm@linux-foundation.org>
In-Reply-To: <20120206164732.GH6890@quack.suse.cz>
References: <1328536531-19034-1-git-send-email-jack@suse.cz>
	<4F2FF4EC.1000104@linux.vnet.ibm.com>
	<20120206164732.GH6890@quack.suse.cz>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Feb 2012 17:47:32 +0100
Jan Kara <jack@suse.cz> wrote:

> On Mon 06-02-12 21:12:36, Srivatsa S. Bhat wrote:
> > On 02/06/2012 07:25 PM, Jan Kara wrote:
> > 
> > > When discovery of lots of disks happen in parallel, we call
> > > invalidate_bh_lrus() once for each disk from partitioning code resulting in a
> > > storm of IPIs and causing a softlockup detection to fire (it takes several
> > > *minutes* for a machine to execute all the invalidate_bh_lrus() calls).

Gad.  How many disks are we talking about here?

> > > Fix the issue by allowing only single invalidation to run using a mutex and let
> > > waiters for mutex figure out whether someone invalidated LRUs for them while
> > > they were waiting.
> > > 
> > > Signed-off-by: Jan Kara <jack@suse.cz>
> > > ---
> > >  fs/buffer.c |   23 ++++++++++++++++++++++-
> > >  1 files changed, 22 insertions(+), 1 deletions(-)
> > > 
> > >   I feel this is slightly hacky approach but it works. If someone has better
> > > idea, please speak up.
> > > 
> > 
> > 
> > Something related that you might be interested in:
> > https://lkml.org/lkml/2012/2/5/109
> > 
> > (This is part of Gilad's patchset that tries to reduce cross-CPU IPI
> > interference.)
>   Thanks for the pointer. I didn't know about it. As Hannes wrote, this
> need not be enough for our use case as there might indeed be some bhs in
> the LRU. But I'd be interested how well the patchset works anyway. Maybe it
> would be enough because after all when we invalidate LRUs subsequent
> callers will see them empty and not issue IPI? Hannes, can you give a try
> to the patches?

If that doesn't work then an option to think about is to have a bool to
disable the bh LRU code.  That would add a test-n-branch to
__find_get_block(), which wouldn't kill us.  Arrange for the LRU code
to be disabled during device probing.  Or just leave the LRU disabled
until very late in boot, perhaps.

Also, I'm wondering why we call invalidate_bh_lrus() at all during
partition reading.  Presumably it's where we're shooting down the
blockdev pagecache (you didn't tell us and I'm too lazy to hunt it
down).  But do we really need to drop the pagecache at
whatever-this-callsite-is?
