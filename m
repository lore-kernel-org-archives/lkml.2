Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab2CMK7z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 06:59:55 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:55858 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab2CMK7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 06:59:53 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Trond.Myklebust@netapp.com,
        sfrench@samba.org, sage@newdream.net, ericvh@gmail.com
Subject: Re: [PATCH 00/25] vfs: atomic open RFC
References: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
	<20120313095102.GA27480@infradead.org>
Date: Tue, 13 Mar 2012 12:00:05 +0100
In-Reply-To: <20120313095102.GA27480@infradead.org> (Christoph Hellwig's
	message of "Tue, 13 Mar 2012 05:51:02 -0400")
Message-ID: <87y5r49362.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> Do we really need the opendata structure?
>
> It seems like we could just pass a struct path instead of the dentry
> passed directly and the vfsmount in it.  There should be no need to
> preallocate the file before calling into ->atomic_open, as it's only
> used to pass around f_flags - but we already pass that one to
> ->atomic_open directly and might as well pass it on to finish_open and
> allocate the file there.

We really don't want to get into the situation where the open fails
after a successful create(*).  Which means the file needs to be allocated
prior to calling ->atomic_open and needs to be passed to finish_open()
toghether with the vfsmount and dentry.

In the first version of the patch I set filp->f_path.mnt to nd->path.mnt
and passed the half initialized filp to ->atomic_open.  But then decided
that it's confusing for the filesystem code to deal with a half baked
filp (does it need to be fput on error?  etc...)

Doing it with an opaque opendata makes this cleaner I think.

Thanks,
Miklos


(*)
commit a1a5b3d93ca45613ec1d920fdb131b69b6553882
Author: Peter Staubach <staubach@redhat.com>
Date:   Tue Sep 13 01:25:12 2005 -0700

    [PATCH] open returns ENFILE but creates file anyway
    
    When open(O_CREAT) is called and the error, ENFILE, is returned, the file
    may be created anyway.  This is counter intuitive, against the SUS V3
    specification, and may cause applications to misbehave if they are not
    coded correctly to handle this semantic.  The SUS V3 specification
    explicitly states "No files shall be created or modified if the function
    returns -1.".
    
    The error, ENFILE, is used to indicate the system wide open file table is
    full and no more file structs can be allocated.
    
    This is due to an ordering problem.  The entry in the directory is created
    before the file struct is allocated.  If the allocation for the file struct
    fails, then the system call must return an error, but the directory entry
    was already created and can not be safely removed.
    
    The solution to this situation is relatively easy.  The file struct should
    be allocated before the directory entry is created.  If the allocation
    fails, then the error can be returned directly.  If the creation of the
    directory entry fails, then the file struct can be easily freed.
