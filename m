Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab2BKU2F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 15:28:05 -0500
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:40032 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab2BKU2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 15:28:03 -0500
Date: Sat, 11 Feb 2012 20:28:03 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>,
        Al Viro <viro@ZenIV.linux.org.uk>, lkml <linux-kernel@vger.kernel.org>,
        Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <haveblue@us.ibm.com>,
        linux-security-module@vger.kernel.org,
        Linux Containers <containers@lists.osdl.org>,
        St?phane Graber <stgraber@ubuntu.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>
Subject: Re: prevent containers from turning host filesystem readonly
Message-ID: <20120211202803.GA19961@hallyn.com>
References: <20120211031939.GA4772@sergelap>
 <20120211033732.GK23916@ZenIV.linux.org.uk>
 <20120211040722.GA5891@sergelap>
 <m1zkcp2np9.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1zkcp2np9.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> Serge Hallyn <serge.hallyn@canonical.com> writes:
> 
> > Quoting Al Viro (viro@ZenIV.linux.org.uk):
> >> On Fri, Feb 10, 2012 at 09:19:39PM -0600, Serge Hallyn wrote:
> >> > When a container shuts down, it likes to do 'mount -o remount,ro /'.
> >> > That sets the superblock's readonly flag, not the mount's.  So unless
> >> > the mount action fails for some reason (i.e. a file is held open on
> >> > the fs), if the container's rootfs is just a directory on the host's
> >> > fs, the host fs will be marked readonly.
> >> > 
> >> > Thanks to Dave Hansen for pointing out how simple the fix can be.  If
> >> > the devices cgroup denies the mounting task write access to the
> >> > underlying superblock (as it usually does when the container's root fs
> >> > is on a block device shared with the host), then it do_remount_sb should
> >> > deny the right to change mount flags as well.
> >> > 
> >> > This patch adds that check.
> >> > 
> >> > Note that another possibility would be to have the LSM step in.  We
> >> > can't catch this (as is) at the LSM level because security_remount_sb
> >> > doesn't get the mount flags, so we can't distinguish
> >> > 	mount -o remount,ro
> >> > from
> >> > 	mount --bind -o remount,ro.
> >> > Sending the flags to that hook would probably be a good idea in addition
> >> > to this patch, but I haven't done it here.
> >> 
> >> NAK.  This is just plain wrong - what about the filesystems that are not
> >
> > BTW, sorry - the patch clearly should've taken non-bdevs into account, but
> > I accept that wouldn't have been enough to evade a NAK.
> >
> >> bdev-backed or, as e.g. btrfs, sit on more than one device?
> >
> > btrfs is actually one of my main motivators - to quickly snapshot containers
> > with btrfs means that the containers all share one fs, but that means one
> > container can mark them all ro.
> 
> Serge let me respectfully suggest that getting the user namespace done
> will deal with this issue nicely.
> 
> In the simple case you simply won't be root so remount will just be
> denied.
> 
> When/if we allow a limited form of unprivileged mounts in a user
> namespace your user won't have mounted the filesystem so you should not
> have the privilege to call remount on the filesystem.

Hm, that's a good point.  Though note it'll require the userns code to
distinguish between the a bind remount and superblock remount.  The
last time we seriously discussed this, that wasn't even on the roadmap.
It was only going to support fully assigning the whole filesystem to
a user namespace.  In that case, the remount issue doesn't apply anyway
as the fs isn't shared with another container.

In any case, there are other workarounds, so I wasn't in a hurry to
address this - it just should be addressed eventually.  I just figured
that to bring up the issue I needed a patch :)

> I think I will have a set of patches ready for serious scrutiny in
> the next week or so.  So we aren't talking impossible pie in the sky
> distance to see this happen.

Awesome.

thanks,
-serge
