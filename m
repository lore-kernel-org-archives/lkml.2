Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934312Ab1ESTYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 15:24:19 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:35407 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934182Ab1ESTYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 15:24:18 -0400
X-Greylist: delayed 1125 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 May 2011 15:24:18 EDT
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19925.27077.673335.609614@quad.stoffel.home>
Date: Thu, 19 May 2011 15:04:37 -0400
From: "John Stoffel" <john@stoffel.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Andy Whitcroft <apw@canonical.com>, viro@ZenIV.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, nbd@openwrt.org, neilb@suse.de,
        hramrach@centrum.cz, jordipujolp@gmail.com
Subject: Re: [PATCH 0/7] overlay filesystem v9
In-Reply-To: <87sjsak2jt.fsf@tucsk.pomaz.szeredi.hu>
References: <1305635452-14835-1-git-send-email-miklos@szeredi.hu>
	<20110519163709.GH3702@shadowen.org>
	<87sjsak2jt.fsf@tucsk.pomaz.szeredi.hu>
X-Mailer: VM 8.1.1 under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Miklos" == Miklos Szeredi <miklos@szeredi.hu> writes:

Miklos> Andy Whitcroft <apw@canonical.com> writes:
>> On Tue, May 17, 2011 at 02:30:45PM +0200, Miklos Szeredi wrote:
>> 
>>> Here's an updated version of the overlay filesystem.
>>> 
>>> Git tree is here:
>>> 
>>> git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs.v9
>> 
>> Ok I pulled this into the Ubuntu kernel and made an Ubuntu Live CD
>> for testing.  Overall it worked pretty well, no hangs, no crashes,
>> performance seemed reasonable.  We hit one issue with hard links which
>> fail to be possible on overlayfs mounts when the Yama LSM (out of tree)
>> is enabled.  This module applies more aggressive checks on hard-links
>> preventing links to files you cannot read.

Miklos> Great, thanks for testing.

>> The bug seems to be related to the way we handle user and group owners for
>> the overlayfs inodes, which we do not initialise (and they remain as 0,0).
>> While these ownerships are never exposed to userspace they are exposed
>> to the LSM layer, and the LSM module checks the wrong owner and fails
>> to allow the links.

Miklos> Hmm.

>> From what I can see it is completly reasonable to initialise the ownership
>> fields in the overlayfs inode from the underlying inode, or for new files
>> ones initialise it in the normal way based on the containing directory.
>> Now I am nothing like a filesystems expert but looking at what other
>> filesystems do I think the patch below is sufficient, but certainly it
>> needs some sanity checking.  At least it fixes all the issues I see
>> here.

Miklos> Forgot to attach the patch?

>> 
>> With this in place I have been able to boot a Natty release live CD
>> image, and upgrade it in place to the latest and greatest of everything.
>> Very nice.  Thanks for your work continuing work on overlayfs.  It is
>> starting to look good enough to merge.
>> 
>> Comments?

Miklos> I'd be happier if the LSM module were fixed not to peek inside the inode
Miklos> structure.  Some filesystems (notably network ones) do not guarantee i_*
Miklos> to be up-to-date, relying on these is not a good idea.

One question I have is why is a LiveCD even using the LSM modules?
It's not like it tells you anything you don't know... unless you're
planning on mounting some external disks and then reading in the LSM
checksums from somewhere to confirm.

Just curious.  

But I am happy to see the testing happening and overlayFS looks really
interesting too.  I can see it being used for a bunch of compute nodes
that all use the same hardware and software, and only need minor local
customization.

John
