Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010Ab0ILTWm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 15:22:42 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:53142 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab0ILTWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 15:22:41 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: miklos@szeredi.hu, hch@infradead.org, viro@zeniv.linux.org.uk,
        adilger@sun.com, corbet@lwn.net, neilb@suse.de, npiggin@kernel.dk,
        hooanon05@yahoo.co.jp, bfields@fieldses.org, miklos@szeredi.hu,
        linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
        philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V19 00/15] Generic name to handle and open by handle syscalls
In-Reply-To: <E1OsyA1-0007Ct-KS@pomaz-ex.szeredi.hu>
References: <1282906982-26918-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <m31v95zweh.fsf@linux.vnet.ibm.com> <E1OswT5-000709-U9@pomaz-ex.szeredi.hu> <m3d3spvhdn.fsf@linux.vnet.ibm.com> <E1OsyA1-0007Ct-KS@pomaz-ex.szeredi.hu>
User-Agent: Notmuch/0.3.1-58-g6607fd6 (http://notmuchmail.org) Emacs/24.0.50.1 (i686-pc-linux-gnu)
Date: Mon, 13 Sep 2010 00:52:27 +0530
Message-ID: <m3r5gyepho.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Sep 2010 15:24:29 +0200, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Tue, 07 Sep 2010, Aneesh Kumar K. V wrote:
> > On Tue, 07 Sep 2010 13:36:03 +0200, Miklos Szeredi <miklos@szeredi.hu> wrote:
> > > On Tue, 07 Sep 2010, Aneesh Kumar K. V wrote:
> > > > Any update on this. Are you ok with syscall approach which is limitted to
> > > > CAP_DAC_READ_SEARCH  ?
> > > 
> > > My gut reaction is: "not another bunch of xattr syscalls!".  It
> > > doesn't feel right, this interface is too specialized to warrant a
> > > full set of filesystem syscalls.
> > 
> > 
> > Are you ok with rest of syscalls other than the handle based xattr one ?
> 
> No, not really.  Only xattrs stand out from the rest as the "API that
> shouldn't be" and adding more to that pile makes me feel especially
> bad.
> 
> But xattrs aside, I still don't think we need another interface for
> file handles that duplicates the existing filesystem APIs.
> 

As per your suggestion i started looking at handlefs details and below
is my take on the approach.

handlefs would be an internal kernel mount like pipefs and would have
inode object mapping to the returned file descriptor of
open_by_handle_at syscall for symlinks. For regular files we can do what
we already does and for symlinks we will create inodes in handlefs and
their inode operation will in turn result in call out of inode operations
of the actual symlinks. Based on the above

a) We still need open_by_handle_at syscall
b) We still need handle based link syscall, because we need to support
   creating hardlinks based on handle, and the existing linkat syscall
   takes the oldpath name.
c) We still need handle based readlink syscall, because the existing
   readlinkat syscall takes pathname.
d) we can drop stat, chown and xattr syscall because they are introduced
   specially for symlinks as we don't allow open on symlinks.
e) It would be nice to have handle based stat syscall to avoid two
   syscall overhead for fetching file attributes when implementing a
   file server, where fetching file attribute is a common operation. 

With the above from the current patch series we can drop chown and
xattr syscalls. Would it be ok if we get the series with the those two
syscall patches dropped upstream as i work on supporting symlinks with
handlefs approach ?

-aneesh

