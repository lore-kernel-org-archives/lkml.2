Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab2EROsn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 10:48:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:29732 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752914Ab2EROsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 10:48:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="145593275"
Date: Fri, 18 May 2012 10:49:22 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: NVM Mapping API
Message-ID: <20120518144922.GS22985@linux.intel.com>
References: <20120515133450.GD22985@linux.intel.com>
 <1337161920.2985.32.camel@dabdike.int.hansenpartnership.com>
 <20120516173523.GK22985@linux.intel.com>
 <1337248478.30498.24.camel@dabdike.int.hansenpartnership.com>
 <20120517185944.GP22985@linux.intel.com>
 <1337331833.2938.22.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337331833.2938.22.camel@dabdike.int.hansenpartnership.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 10:03:53AM +0100, James Bottomley wrote:
> On Thu, 2012-05-17 at 14:59 -0400, Matthew Wilcox wrote:
> > On Thu, May 17, 2012 at 10:54:38AM +0100, James Bottomley wrote:
> > > On Wed, 2012-05-16 at 13:35 -0400, Matthew Wilcox wrote:
> > > > I'm not talking about a specific piece of technology, I'm assuming that
> > > > one of the competing storage technologies will eventually make it to
> > > > widespread production usage.  Let's assume what we have is DRAM with a
> > > > giant battery on it.
> > > > 
> > > > So, while we can use it just as DRAM, we're not taking advantage of the
> > > > persistent aspect of it if we don't have an API that lets us find the
> > > > data we wrote before the last reboot.  And that sounds like a filesystem
> > > > to me.
> > > 
> > > Well, it sounds like a unix file to me rather than a filesystem (it's a
> > > flat region with a beginning and end and no structure in between).
> > 
> > That's true, but I think we want to put a structure on top of it.
> > Presumably there will be multiple independent users, and each will want
> > only a fraction of it.
> > 
> > > However, I'm not precluding doing this, I'm merely asking that if it
> > > looks and smells like DRAM with the only additional property being
> > > persistency, shouldn't we begin with the memory APIs and see if we can
> > > add persistency to them?
> > 
> > I don't think so.  It feels harder to add useful persistent
> > properties to the memory APIs than it does to add memory-like
> > properties to our file APIs, at least partially because for
> > userspace we already have memory properties for our file APIs (ie
> > mmap/msync/munmap/mprotect/mincore/mlock/munlock/mremap).
> 
> This is what I don't quite get.  At the OS level, it's all memory; we
> just have to flag one region as persistent.  This is easy, I'd do it in
> the physical memory map.  once this is done, we need either to tell the
> allocators only use volatile, only use persistent, or don't care (I
> presume the latter would only be if you needed the extra ram).
> 
> The missing thing is persistent key management of the memory space (so
> if a user or kernel wants 10Mb of persistent space, they get the same
> 10Mb back again across boots).
> 
> The reason a memory API looks better to me is because a memory API can
> be used within the kernel.  For instance, I want a persistent /var/tmp
> on tmpfs, I just tell tmpfs to allocate it in persistent memory and it
> survives reboots.  Likewise, if I want an area to dump panics, I just
> use it ... in fact, I'd probably always place the dmesg buffer in
> persistent memory.
> 
> If you start off with a vfs API, it becomes far harder to use it easily
> from within the kernel.
> 
> The question, really is all about space management: how many persistent
> spaces would there be.  I think, given the use cases above it would be a
> small number (it's basically one for every kernel use and one for ever
> user use ... a filesystem mount counting as one use), so a flat key to
> space management mapping (probably using u32 keys) makes sense, and
> that's similar to our current shared memory API.

So who manages the key space?  If we do it based on names, it's easy; all
kernel uses are ".kernel/..." and we manage our own sub-hierarchy within
the namespace.  If there's only a u32, somebody has to lay down the rules
about which numbers are used for what things.  This isn't quite as ugly
as the initial proposal somebody made to me "We just use the physical
address as the key", and I told them all about how a.out libraries worked.

Nevertheless, I'm not interested in being the Mitch DSouza of NVM.

> > Discussion of use cases is exactly what I want!  I think that a
> > non-hierarchical attempt at naming chunks of memory quickly expands
> > into cases where we learn we really do want a hierarchy after all.
> 
> OK, so enumerate the uses.  I can be persuaded the namespace has to be
> hierarchical if there are orders of magnitude more users than I think
> there will be.

I don't know what the potential use cases might be.  I just don't think
the use cases are all that bounded.

> > > Again, this depends on use case.  The SYSV shm API has a global flat
> > > keyspace.  Perhaps your envisaged use requires a hierarchical key space
> > > and therefore a FS interface looks more natural with the leaves being
> > > divided memory regions?
> > 
> > I've really never heard anybody hold up the SYSV shm API as something
> > to be desired before.  Indeed, POSIX shared memory is much closer to
> > the filesystem API;
> 
> I'm not really ... I was just thinking this needs key -> region mapping
> and SYSV shm does that.  The POSIX anonymous memory API needs you to
> map /dev/zero and then pass file descriptors around for sharing.  It's
> not clear how you manage a persistent key space with that.

I didn't say "POSIX anonymous memory".  I said "POSIX shared memory".
I even pointed you at the right manpage to read if you haven't heard
of it before.  The POSIX committee took a look at SYSV shm and said
"This is too ugly".  So they invented their own API.

> >  the only difference being use of shm_open() and
> > shm_unlink() instead of open() and unlink() [see shm_overview(7)].
> 
> The internal kernel API addition is simply a key -> region mapping.
> Once that's done, you need an allocation API for userspace and you're
> done.  I bet most userspace uses will be either give me xGB and put a
> tmpfs on it or give me xGB and put a something filesystem on it, but if
> the user wants an xGB mmap'd region, you can give them that as well.
> 
> For a vfs interface, you have to do all of this as well, but in a much
> more complex way because the file name becomes the key and the metadata
> becomes the mapping.

You're downplaying the complexity of your own solution while overstating
the complexity of mine.  Let's compare, using your suggestion of the
dmesg buffer.

Mine:

struct file *filp = filp_open(".kernel/dmesg", O_RDWR, 0);
if (!IS_ERR(filp))
	log_buf = nvm_map(filp, 0, __LOG_BUF_LEN, PAGE_KERNEL);

Yours:

log_buf = nvm_attach(492, NULL, 0);  /* Hope nobody else used 492! */

Hm.  Doesn't look all that different, does it?  I've modelled nvm_attach()
after shmat().  Of course, this ignores the need to be able to sync,
which may vary between different NVM technologies, and the (desired
by some users) ability to change portions of the mapped NVM between
read-only and read-write.

If the extra parameters and extra lines of code hinder adoption, I have
no problems with adding a helper for the simple use cases:

void *nvm_attach(const char *name, int perms)
{
	void *mem;
	struct file *filp = filp_open(name, perms, 0);
	if (IS_ERR(filp))
		return NULL;
	mem = nvm_map(filp, 0, filp->f_dentry->d_inode->i_size, PAGE_KERNEL);
	fput(filp);
	return mem;
}

I do think that using numbers to refer to regions of NVM is a complete
non-starter.  This was one of the big mistakes of SYSV; one so big that
even POSIX couldn't stomach it.
