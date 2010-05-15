Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894Ab0EOGAh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 02:00:37 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36245 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab0EOGAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 02:00:36 -0400
Date: Sat, 15 May 2010 07:00:23 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Andreas Dilger <andreas.dilger@oracle.com>, Neil Brown <neilb@suse.de>,
       Christoph Hellwig <hch@infradead.org>, Jonathan Corbet <corbet@lwn.net>,
       Serge Hallyn <serue@us.ibm.com>, linux-fsdevel@vger.kernel.org,
       Steven French <sfrench@us.ibm.com>,
       Philippe Deniel <philippe.deniel@CEA.FR>,
       "linux-kernel@vger.kernel.org Mailinglist" 
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -V7 3/9] vfs: Add name to file handle conversion support
Message-ID: <20100515060023.GC31073@ZenIV.linux.org.uk>
References: <871vdg2ulx.fsf@linux.vnet.ibm.com>
 <20100513171114.1629086b@notabene.brown>
 <51B2B398-99A7-43BF-A074-ACFBBA318DF7@oracle.com>
 <8739xvevbw.fsf@linux.vnet.ibm.com>
 <878w7n1xb3.fsf@linux.vnet.ibm.com>
 <B93EA6D0-4D21-46B2-988C-A7A307EBE0B7@oracle.com>
 <20100514172510.GU30031@ZenIV.linux.org.uk>
 <87d3wye49b.fsf@linux.vnet.ibm.com>
 <20100514184044.GV30031@ZenIV.linux.org.uk>
 <874oi9enoe.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874oi9enoe.fsf@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 15, 2010 at 11:01:13AM +0530, Aneesh Kumar K. V wrote:

> We need to have a file system identifier to identify a file system with
> respect to which file_id need to be decoded.

Obviously.

> We can either do it in
> userspace via statfs or any other encoding or let the kernel fill the
> field for userspace. Now having kernel providing both file_id and file
> system id implies we can get an 'unique' handle with one syscall. (Not
> unique if we have multiple file system with same UUID. Userspace
> file server can find out whether all the mount point it is exporting
> have a unique UUID during startup.) 

Or it can decide which UUID to use by parsing its analog of /etc/exports, or
any number of other schemes.  Sure.

> Now if we have UUID as a part of file handle, adding the check make
> sure that we are passing the right file handle with the correct mountdirfd.
> If they don't match return -ESTALE. 

Pardon?  Your variant needs to choose mountdirfd somehow and it has to be
done by UUID found in fhandle it has received.  Whatever userland code will
be doing that, you
	a) need to open() these suckers at some point
	b) do _NOT_ want to reopen them on each incoming fhandle, for obvious
efficiency reasons
	c) will have very few opens compared to the amount of fhandles you
are going to handle (number of filesystems vs. number of requested accesses
to them)
	d) can be sure that identity of fs hosting an opened directory will
_not_ change while it's open, so the checks concerning the validity of
UUID -> mountdirfd mapping you need to do should be done only once per
opening mountdirfd

So why the devil would you repeat them on each open-by-fhandle in a variant
that gets mountdirfd from caller?
 
> Adding UUID as a part of file handle also help us to get a 16 byte UUID
> of the file system in userspace in a simple syscall interface, rather
> than using file system specific libraries like libext2fs.

Your choice of fsid encoding is orthogonal to my question; again, the question
is "why would you want to have open-by-fhandle do anything with fsid, if it
gets filesystem identified by opened file descriptor passed by userland anyway?"

I don't think that UUID is always a good choice, BTW, but that's a separate
issue.  For one thing, not every fs _has_ UUID, so while that might be a
reasonable default, it doesn't make sense to hardwire it into the design.
For another, you might want a different policy (e.g. you might want to
allow explicitly configured "this fsid value corresponds to whatever's mounted
on that path" for some userland server), so again it doesn't make any sense
to hardwire that one.

But that's a completely independent issue; whether you use hardwire UUID into
the thing or not, rechecking that yes, mountdirfd is on the same fs as it
used to back when we'd opened it, is pointless.  It *will* be on the same fs,
so checking that we'd got the right filesystem should be done once per
opening mountdirfd, not once per opening file by fhandle.
