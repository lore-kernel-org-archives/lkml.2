Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933776Ab1ESRom (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 13:44:42 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60622 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933666Ab1ESRok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 13:44:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=szeredi.hu; s=google;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=qxKx1JNqTv4U5lL9pb+JXzCq6pdAUvxhAdTZ+HeRkfpnWRjSUBS8fpX+dqvyiQjxHH
         2NXNTHhEFEiSkzEDnmDznfkaVFm2nGNA2d19DHJ9rD0kuoDu9CgViZAjUxKyyC9Jpvui
         knvUCFgUp8hzwQqP+EtAmSrNFTltmLjd81OBA=
From: Miklos Szeredi <miklos@szeredi.hu>
To: Andy Whitcroft <apw@canonical.com>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        nbd@openwrt.org, neilb@suse.de, hramrach@centrum.cz,
        jordipujolp@gmail.com
Subject: Re: [PATCH 0/7] overlay filesystem v9
References: <1305635452-14835-1-git-send-email-miklos@szeredi.hu>
	<20110519163709.GH3702@shadowen.org>
Date: Thu, 19 May 2011 19:44:54 +0200
In-Reply-To: <20110519163709.GH3702@shadowen.org> (Andy Whitcroft's message of
	"Thu, 19 May 2011 17:37:09 +0100")
Message-ID: <87sjsak2jt.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Whitcroft <apw@canonical.com> writes:

> On Tue, May 17, 2011 at 02:30:45PM +0200, Miklos Szeredi wrote:
>
>> Here's an updated version of the overlay filesystem.
>> 
>> Git tree is here:
>> 
>>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs.v9
>
> Ok I pulled this into the Ubuntu kernel and made an Ubuntu Live CD
> for testing.  Overall it worked pretty well, no hangs, no crashes,
> performance seemed reasonable.  We hit one issue with hard links which
> fail to be possible on overlayfs mounts when the Yama LSM (out of tree)
> is enabled.  This module applies more aggressive checks on hard-links
> preventing links to files you cannot read.

Great, thanks for testing.

> The bug seems to be related to the way we handle user and group owners for
> the overlayfs inodes, which we do not initialise (and they remain as 0,0).
> While these ownerships are never exposed to userspace they are exposed
> to the LSM layer, and the LSM module checks the wrong owner and fails
> to allow the links.

Hmm.

> From what I can see it is completly reasonable to initialise the ownership
> fields in the overlayfs inode from the underlying inode, or for new files
> ones initialise it in the normal way based on the containing directory.
> Now I am nothing like a filesystems expert but looking at what other
> filesystems do I think the patch below is sufficient, but certainly it
> needs some sanity checking.  At least it fixes all the issues I see
> here.

Forgot to attach the patch?

>
> With this in place I have been able to boot a Natty release live CD
> image, and upgrade it in place to the latest and greatest of everything.
> Very nice.  Thanks for your work continuing work on overlayfs.  It is
> starting to look good enough to merge.
>
> Comments?

I'd be happier if the LSM module were fixed not to peek inside the inode
structure.  Some filesystems (notably network ones) do not guarantee i_*
to be up-to-date, relying on these is not a good idea.

Thanks,
Miklos
