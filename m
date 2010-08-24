Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab0HXKky (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 06:40:54 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:44592 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069Ab0HXKkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 06:40:52 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: Neil Brown <neilb@suse.de>
Cc: Andreas Dilger <andreas.dilger@oracle.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        "adilger\@sun.com" <adilger@sun.com>,
        "corbet\@lwn.net" <corbet@lwn.net>,
        "npiggin\@kernel.dk" <npiggin@kernel.dk>,
        "hooanon05\@yahoo.co.jp" <hooanon05@yahoo.co.jp>,
        "bfields\@fieldses.org" <bfields@fieldses.org>,
        "miklos\@szeredi.hu" <miklos@szeredi.hu>,
        "linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "sfrench\@us.ibm.com" <sfrench@us.ibm.com>,
        "philippe.deniel\@CEA.FR" <philippe.deniel@CEA.FR>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -V18 04/13] vfs: Allow handle based open on symlinks
In-Reply-To: <20100823115247.1f38c154@notabene>
References: <1282269097-26166-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1282269097-26166-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20100820083057.GA10039@infradead.org> <20100820195303.20b17210@notabene> <20100820115135.GQ31363@ZenIV.linux.org.uk> <20100821100900.4b15fe08@notabene> <17761610-AFA9-4BB5-AF62-CD54D67F5C79@oracle.com> <20100823090604.6c735c80@notabene> <m3wrrijf4c.fsf@linux.vnet.ibm.com> <20100823115247.1f38c154@notabene>
User-Agent: Notmuch/0.3.1-58-g6607fd6 (http://notmuchmail.org) Emacs/24.0.50.1 (i686-pc-linux-gnu)
Date: Tue, 24 Aug 2010 16:10:42 +0530
Message-ID: <m3iq30jnth.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Aug 2010 11:52:47 +1000, Neil Brown <neilb@suse.de> wrote:
> On Mon, 23 Aug 2010 06:54:03 +0530
> "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> 
> > On Mon, 23 Aug 2010 09:06:04 +1000, Neil Brown <neilb@suse.de> wrote:
> > > On Sat, 21 Aug 2010 01:13:52 -0600
> > > Andreas Dilger <andreas.dilger@oracle.com> wrote:
> > > 
> > > > On 2010-08-20, at 18:09, Neil Brown <neilb@suse.de> wrote:
> > > > > How about a new AT flag:  AT_FILE_HANDLE
> > > > > 
> > > > > Meaning is that the 'dirfd' is used only to identify a filesystem (vfsmnt) and
> > > > > the 'name' pointer actually points to a filehandle fragment interpreted in
> > > > > that filesystem.
> > > > > 
> > > > > One problem is that there is no way to pass the length...
> > > > > Options:
> > > > >   fragment is at most 64 bytes nul padded at the end
> > > > >   fragment is hex encoded and nul terminated
> > > > >   ??
> > > > > 
> > > > > I think I prefer the hex encoding, but I'm hoping someone else has a better
> > > > > idea.
> > > > 
> > > > That makes it ugly for the kernel to stringify and parse the file handles. 
> > > 
> > > We already parse filenames into components separated by '/'.  Is HEX decoding
> > > that much more ugly.
> > > 
> > > Filehandles are currently passed between the kernel and mountd as HEX
> > > strings, so at least there is some precedent.
> > > 
> > > > 
> > > > How about for AT_FILE_HANDLE THE FIRST __u32 (maybe with an extra __u32 for alignment) is the length and the rest of the binary file handle follows this?  In fact, doesn't the handle itself already encode the length in the header?
> > > 
> > > That part of a filehandle that nfsd gives to the filesystem is one byte out
> > > of a 4-byte header, plus the tail of the filehandle after the part that
> > > identifies the filesystem.
> > > This 'one byte' does imply the length, but it doesn't necessarily encode it.
> > > Rather it is a 'type'.  So it cannot really be used to determine the length
> > > at the point when the filehandle would need to be copied from userspace into
> > > the kernel.
> > > 
> > > 
> > > I don't think there is any precedent for passing a 4-byte length followed by
> > > a binary string, while there is plenty of precedent for passing a
> > > nul-terminated ASCII string.
> > > 
> > > [[ Following this approach I would like to avoid any filehandle-specific
> > > syscalls altogether.
> > > Just use a *at syscall with AT_FILE_HANDLE for filehandle lookup, and use
> > > getxattr('system:linux.file_handle') to get the filehandle for a given path.
> > > 
> > > Ofcourse we would need to at *at versions of the *xattr syscalls, but that is
> > > probably a good idea anyway.
> > > ]]
> > 
> > There are at* syscalls that doesn't take the additional flags as the
> > argument, like openat, readlinkat. How will handle based open and
> > readlink work with the above interface ?
> >
> 
> Bother... you are right.
> 
> I had remembered that at the time that all that *at calls were added there was
> discussion about how you always need some flags, particularly in the context
> of adding O_CLOEXEC and (I thought) a flag to allow non-sequential allocation
> of fds.
> I had thought that they all got 'flags' arguments as a result, but it seems
> not.
> For openat you could squeeze something into the current 'flags' arg
> (O_FILE_HANDLE), but for readlinkat, symlinkat at least there is no such
> option.  Sad really.
> 

IMHO that is really bad overloading of flags value. I also find  hex
encoded handle in pathname argument of *at syscalls confusing. The above
discussion also hint that we would need a new syscall for open,
readlink and setxattr, So how about me posting the new series which
remove open on symlink patch and add a bunch of syscalls to allow
operation on symlinks based on handle ?

-aneesh



