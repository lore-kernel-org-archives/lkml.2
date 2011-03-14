Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694Ab1CNULS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 16:11:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49887 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752586Ab1CNULQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 16:11:16 -0400
Date: Mon, 14 Mar 2011 13:10:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Indan Zupancic" <indan@nul.nu>
Cc: "Greg KH" <greg@kroah.com>, "Jonathan Nieder" <jrnieder@gmail.com>,
        "Arnd Bergmann" <arnd@arndb.de>, "Sage Weil" <sage@newdream.net>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
        linux-api@vger.kernel.org, mtk.manpages@gmail.com,
        viro@zeniv.linux.org.uk, hch@lst.de, l@jasper.es
Subject: Re: [PATCH v3] introduce sys_syncfs to sync a single file system
Message-Id: <20110314131042.5a7fb32f.akpm@linux-foundation.org>
In-Reply-To: <1e597aedd3d7825dcc0630b1cf2399fa.squirrel@webmail.greenhost.nl>
References: <Pine.LNX.4.64.1102171035220.13904@cobra.newdream.net>
	<Pine.LNX.4.64.1103101125150.4190@cobra.newdream.net>
	<edfa4cf081249734807e582c14253fca.squirrel@webmail.greenhost.nl>
	<201103111255.44979.arnd@arndb.de>
	<ffafd3ccb3fd1be7c40348c9cee84aef.squirrel@webmail.greenhost.nl>
	<20110311235607.GB15853@elie>
	<9446ab1a2315c0d2476c30f8315a0503.squirrel@webmail.greenhost.nl>
	<20110312021001.GA16833@elie>
	<20110312173217.GA24981@kroah.com>
	<1e597aedd3d7825dcc0630b1cf2399fa.squirrel@webmail.greenhost.nl>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Mar 2011 02:56:52 +0100 (CET)
"Indan Zupancic" <indan@nul.nu> wrote:

> On Sat, March 12, 2011 18:32, Greg KH wrote:
> > On Fri, Mar 11, 2011 at 08:10:01PM -0600, Jonathan Nieder wrote:
> >> Indan Zupancic wrote:
> >>
> >> > I'm not pushing for any official convention, just what seems good taste.
> >>
> >> In cases like this, conventions (consistency and best practices) are
> >> very important.
> >>
> >> > Less code added, less bloat. Architecture independent, no need to update
> >> > all system call tables everywhere (all archs, libc versions and strace).
> >> > Two files changed, instead of 7 (which only hooks up x86).
> >>
> >> Thanks for explaining.  Those do seem like good reasons to use a ioctl
> >> instead of a new syscall.
> >
> > No, make it a syscall, it's more obvious and will be documented much
> > better.
> 
> There is no such guarantee. Everyone seems to want to add this new syncfs,
> but it's not even defined what it does. "Same as sync, but only on one fs"
> is IMHO not good enough, because sync's behaviour is pretty badly documented,
> and that's a system call. The sync_file_range argument effects are quite
> well defined, on the other hand, unlike sync behaviour. You're right for
> ioctls though.

I think the semantics of sync are easily enough defined, even if
they're not well-defined in the documentation: all data which was dirty
at the time sync() was called will be written back and accessible when
the sync() returns.

I do agree that this should be a standalone syscall, not grafted into
sync_file_range() or into an ioctl.


That being said, we have two similar-looking-but-quite-different "sync"
concepts in the kernel.  One is "sync for data integrity" and the other
is "sync to reduce the dirty memory load".  The latter is not a data
integrity thing - it is a resource management thing.

There might one day be a requirement to be able to initiate a
resource-management-style writeback against a whole filesystem.  When
that happens, we'll regret not having added a "mode" argument to
sys_syncfs().

Or maybe not - given that we're syncing the entire fs and that
sync_filesystem() does the two-pass "write for data cleaning then write
for data integrity" thing, it could be that a syncfs-for-data-cleaning
operation has little performance benefit over a
syncfs-for-data-integrity operation.


