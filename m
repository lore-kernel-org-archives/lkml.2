Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912Ab0EOFb0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 01:31:26 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:33215 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab0EOFbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 01:31:24 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andreas Dilger <andreas.dilger@oracle.com>, Neil Brown <neilb@suse.de>,
       Christoph Hellwig <hch@infradead.org>, Jonathan Corbet <corbet@lwn.net>,
       Serge Hallyn <serue@us.ibm.com>, linux-fsdevel@vger.kernel.org,
       Steven French <sfrench@us.ibm.com>,
       Philippe Deniel <philippe.deniel@CEA.FR>,
       "linux-kernel\@vger.kernel.org Mailinglist" 
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -V7 3/9] vfs: Add name to file handle conversion support
In-Reply-To: <20100514184044.GV30031@ZenIV.linux.org.uk>
References: <E1DE62DE-D9E1-493B-8AEB-91E10D7D35B2@oracle.com> <20100513084310.5212728b@notabene.brown> <871vdg2ulx.fsf@linux.vnet.ibm.com> <20100513171114.1629086b@notabene.brown> <51B2B398-99A7-43BF-A074-ACFBBA318DF7@oracle.com> <8739xvevbw.fsf@linux.vnet.ibm.com> <878w7n1xb3.fsf@linux.vnet.ibm.com> <B93EA6D0-4D21-46B2-988C-A7A307EBE0B7@oracle.com> <20100514172510.GU30031@ZenIV.linux.org.uk> <87d3wye49b.fsf@linux.vnet.ibm.com> <20100514184044.GV30031@ZenIV.linux.org.uk>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.0.50.1 (i686-pc-linux-gnu)
Date: Sat, 15 May 2010 11:01:13 +0530
Message-ID: <874oi9enoe.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 May 2010 19:40:44 +0100, Al Viro <viro@ZenIV.linux.org.uk> wrote:
> On Fri, May 14, 2010 at 11:48:24PM +0530, Aneesh Kumar K. V wrote:
> 
> > How about
> > sys_open_by_handle(int mountdirfd,
> >                   struct file_handle __user *ufh, int open_flag)
> > 
> > and we validate the UUID present in the file_handle by using mountdirfd
> > vfsmount. In otherwords we drop the UUID based vfsmount lookup, But
> > still add UUID as a part of file handle ?
> 
> IDGI.  If you have decided upon the mountdirfd, why bother with rechecking?
> You still need to handle the case when fs tells you to take a hike because
> fileid was invalid.  What does duplicate uuid check in the kernel buy you?

We need to have a file system identifier to identify a file system with
respect to which file_id need to be decoded. We can either do it in
userspace via statfs or any other encoding or let the kernel fill the
field for userspace. Now having kernel providing both file_id and file
system id implies we can get an 'unique' handle with one syscall. (Not
unique if we have multiple file system with same UUID. Userspace
file server can find out whether all the mount point it is exporting
have a unique UUID during startup.) 

Now if we have UUID as a part of file handle, adding the check make
sure that we are passing the right file handle with the correct mountdirfd.
If they don't match return -ESTALE. 

Adding UUID as a part of file handle also help us to get a 16 byte UUID
of the file system in userspace in a simple syscall interface, rather
than using file system specific libraries like libext2fs.

-aneesh
