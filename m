Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758457Ab2BKDhk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 22:37:40 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51792 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474Ab2BKDhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 22:37:38 -0500
Date: Sat, 11 Feb 2012 03:37:33 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Serge Hallyn <serge.hallyn@canonical.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Dave Hansen <haveblue@us.ibm.com>,
        linux-security-module@vger.kernel.org,
        Linux Containers <containers@lists.osdl.org>,
        St?phane Graber <stgraber@ubuntu.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>
Subject: Re: prevent containers from turning host filesystem readonly
Message-ID: <20120211033732.GK23916@ZenIV.linux.org.uk>
References: <20120211031939.GA4772@sergelap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120211031939.GA4772@sergelap>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 09:19:39PM -0600, Serge Hallyn wrote:
> When a container shuts down, it likes to do 'mount -o remount,ro /'.
> That sets the superblock's readonly flag, not the mount's.  So unless
> the mount action fails for some reason (i.e. a file is held open on
> the fs), if the container's rootfs is just a directory on the host's
> fs, the host fs will be marked readonly.
> 
> Thanks to Dave Hansen for pointing out how simple the fix can be.  If
> the devices cgroup denies the mounting task write access to the
> underlying superblock (as it usually does when the container's root fs
> is on a block device shared with the host), then it do_remount_sb should
> deny the right to change mount flags as well.
> 
> This patch adds that check.
> 
> Note that another possibility would be to have the LSM step in.  We
> can't catch this (as is) at the LSM level because security_remount_sb
> doesn't get the mount flags, so we can't distinguish
> 	mount -o remount,ro
> from
> 	mount --bind -o remount,ro.
> Sending the flags to that hook would probably be a good idea in addition
> to this patch, but I haven't done it here.

NAK.  This is just plain wrong - what about the filesystems that are not
bdev-backed or, as e.g. btrfs, sit on more than one device?

<comments about inadequacy of cgroup as an API censored - far too unprintable>
