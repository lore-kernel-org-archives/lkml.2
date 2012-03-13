Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620Ab2CMNdP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 09:33:15 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:35210 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440Ab2CMNdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 09:33:12 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Trond.Myklebust@netapp.com,
        sfrench@samba.org, sage@newdream.net, ericvh@gmail.com
Subject: Re: [PATCH 00/25] vfs: atomic open RFC
References: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
	<20120313095102.GA27480@infradead.org>
	<87y5r49362.fsf@tucsk.pomaz.szeredi.hu>
	<20120313120137.GA21755@infradead.org>
Date: Tue, 13 Mar 2012 14:33:27 +0100
In-Reply-To: <20120313120137.GA21755@infradead.org> (Christoph Hellwig's
	message of "Tue, 13 Mar 2012 08:01:37 -0400")
Message-ID: <87d38g8w2g.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> On Tue, Mar 13, 2012 at 12:00:05PM +0100, Miklos Szeredi wrote:
>> > Do we really need the opendata structure?
>> >
>> > It seems like we could just pass a struct path instead of the dentry
>> > passed directly and the vfsmount in it.  There should be no need to
>> > preallocate the file before calling into ->atomic_open, as it's only
>> > used to pass around f_flags - but we already pass that one to
>> > ->atomic_open directly and might as well pass it on to finish_open and
>> > allocate the file there.
>> 
>> We really don't want to get into the situation where the open fails
>> after a successful create(*).  Which means the file needs to be allocated
>> prior to calling ->atomic_open and needs to be passed to finish_open()
>> toghether with the vfsmount and dentry.
>> 
>> In the first version of the patch I set filp->f_path.mnt to nd->path.mnt
>> and passed the half initialized filp to ->atomic_open.  But then decided
>> that it's confusing for the filesystem code to deal with a half baked
>> filp (does it need to be fput on error?  etc...)
>> 
>> Doing it with an opaque opendata makes this cleaner I think.
>
> Make sense.  Can you throw in another cleanup patch to really just make
> it a pass-through and not also use it as a boolean flag if open_flags
> should be obeyed?  This probably will change sematincs for the various
> filesystems, but given that they should behave the same way that's a
> good thing.

It's not just that.  The filesystems will create some state if od is
non-NULL, which is released in f_op->release.  If od is always non-NULL
then the VFS has to call ->release on a dummy file, that file has to be
allocated, which might fail...  So this brings with it a couple of
issues that I didn't want to deal with.

But yes, it would probably be a good cleanup...

Thanks,
Miklos
