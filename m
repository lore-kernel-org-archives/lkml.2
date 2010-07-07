Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614Ab0GGSTK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 14:19:10 -0400
Received: from [202.81.31.141] ([202.81.31.141]:33951 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753188Ab0GGSTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 14:19:08 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: Andreas Dilger <andreas.dilger@oracle.com>,
       "J. Bruce Fields" <bfields@fieldses.org>
Cc: Neil Brown <neilb@suse.de>, hch@infradead.org, viro@zeniv.linux.org.uk,
       adilger@Sun.COM, corbet@lwn.net, serue@us.ibm.com,
       hooanon05@yahoo.co.jp, linux-fsdevel@vger.kernel.org,
       sfrench@us.ibm.com, philippe.deniel@CEA.FR,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V14 0/11] Generic name to handle and open by handle syscalls
In-Reply-To: <5920F408-E923-4467-A6A9-6C0923C00927@oracle.com>
References: <1276621981-2774-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <871vbn2mk9.fsf@linux.vnet.ibm.com> <20100702064108.64034561@notabene.brown> <87iq4y29a6.fsf@linux.vnet.ibm.com> <20100706161002.GD7387@fieldses.org> <87eifgfsez.fsf@linux.vnet.ibm.com> <2DC68584-15A8-4C48-8E65-E7EF1DCEEAD0@oracle.com> <20100707150535.GB24360@fieldses.org> <5920F408-E923-4467-A6A9-6C0923C00927@oracle.com>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.0.50.1 (i686-pc-linux-gnu)
Date: Wed, 07 Jul 2010 23:48:51 +0530
Message-ID: <87zky3duk4.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jul 2010 11:02:47 -0600, Andreas Dilger <andreas.dilger@oracle.com> wrote:
> On 2010-07-07, at 09:05, J. Bruce Fields wrote:
> > On Wed, Jul 07, 2010 at 01:40:53AM -0600, Andreas Dilger wrote:
> >> On 2010-07-06, at 11:09, Aneesh Kumar K. V wrote:
> >>> Since we know that system wide file handle should include a file system
> >>> identifier and a file identifier my plan was to retrieve both in the
> >>> same syscall.
> >> 
> >> Won't having it be in a separate system call be racy w.r.t. doing the pathname lookup twice?
> > 
> > It'll be rare that a server will want to *just* get a filehandle;
> > normally it will at least want to get some attributes at the same time.
> > So I think it will always need to open the file first and then do the
> > rest of the operations on the returned filehandle.
> 
> I think you are assuming too much about the use of the file handle.
> What I'm interested in is not a userspace file server, but rather a
> more efficient way to have 10000's to millions of clients to be able
> to open the same regular file, without having to do full path
> traversal for each one.


With the suggested syscall approach we can do on the client that does
the path traversal.

fd = open(name)
file_identifier = fd_to_handle(fd);
fs_identifier  = fd_to_fshandle(fd);
close(fd);


> 
> >>> That still leaves the problem that there isn't always an underlying
> >>> block device, and/or when there is it doesn't always uniquely specify
> >>> the filesystem.
> >> 
> >> And for this reason we would need this as a syscall right ?
> > 
> > That's the only solution I see.  (Or use an xattr?)
> 
> Or... return the UUID as part of the file handle in the first place.
> That avoids races, avoids adding more syscalls that have to be called
> for each file handle, or IMNSHO the worst proposal that requires
> applications to parse a text file in some obscure path for each file
> handle (requiring a stat() to find the major/minor device of the file,
> walking through /proc or /sys, and other nastiness).

I would also like to get both file system identifier and file identifier 
in a single call.

That would also imply instead of the above sequence of 4 calls, we can
do

file_handle = name_to_handle(name);

-aneesh



