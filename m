Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab2BFXJQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 18:09:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36295 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756029Ab2BFXJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 18:09:14 -0500
Date: Tue, 7 Feb 2012 00:08:49 +0100
From: Karel Zak <kzak@redhat.com>
To: Jan Kara <jack@suse.cz>
Cc: Jerome Marchand <jmarchan@redhat.com>, linux-fsdevel@vger.kernel.org,
        util-linux@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] fs: filesystem specific options and remount
Message-ID: <20120206230849.GA20767@x2.net.home>
References: <4F2BFBAF.5020703@redhat.com>
 <20120206224116.GE24840@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120206224116.GE24840@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 06, 2012 at 11:41:16PM +0100, Jan Kara wrote:
> On Fri 03-02-12 16:22:23, Jerome Marchand wrote:
> > 
> > When remounted without option specified, some filesystems keep the
> > options that are already set (e.g. procfs, fat) and some reset them to
> > default (e.g. devpts).
> > Regarding options that are specified at remount, behavior of
> > filesystems also differ: some apply them (procfs, devpts), some
> > silently disregard them (e.g. fat) and some have a more elaborate
> > behavior (e.g. xfs apparently allows a subset of options to be changed
> > and issues warning if someone tries to change any other option).
> > 
> > Is there any policy regarding what the correct behavior should be?
> > This variety of behaviors tends to confuse mount utility which often
> > does not show the correct option actually set after a remount and
> > most certainly confuses the users as well.
> > 
> > Here is a example of discrepancy between mount (/etc/mtab) and
> > /proc/mounts:
> > 
> > $ grep proc /proc/mounts
> > /proc /proc proc rw,relatime 0 0
> > $ mount | grep proc
> > proc on /proc type proc (rw)
> > 
> > $ mount -o remount,hidepid=2 /proc/
> > $ grep proc /proc/mounts
> > /proc /proc proc rw,relatime,hidepid=2 0 0
> > $ mount | grep proc
> > proc on /proc type proc (rw,hidepid=2)
> > 
> > $ mount -o remount /proc/
> > $ grep proc /proc/mounts
> > /proc /proc proc rw,relatime,hidepid=2 0 0
> > $ mount | grep proc
> > proc on /proc type proc (rw)
> > 
> > And here is the discrepancy: mount does not show "hidepid=2" option
> > that is actually still set and enforced. Note that mount also missed
> > the relatime option to begin with.
>   I don't mind the discrepancy between /etc/mtab and /proc/mounts that much
> (/proc/mounts is a fine replacement of /etc/mtab for me) but I agree that

Fedora for example does not use /etc/mtab anymore.

> handling of mount options on remount is a mess and IMHO it's made even
> worse by mount(8) adding options from /etc/mtab to mount(2) syscall when
> -o remount is specified. But realistically I can hardly imagine how to fix

man mount:

   The  remount  functionality follows the standard way how the mount
   command works with options from fstab. It means the mount command
   doesn't read fstab (or mtab) only when  a  device  and dir are fully
   specified.

         mount -o remount,rw /dev/foo /dir

   After this call all old mount options are replaced and arbitrary stuff
   from fstab is ignored, except the loop= option which is internally
   generated and maintained by the mount command.

         mount -o remount,rw  /dir

   After this call mount reads fstab (or mtab) and merges these options
   with options  from command line ( -o ).



Note that mtab is a fallback solution when the mountpoint is not found
in fstab, the mtab is not read by default.

Anyway, libmount allows to specify how use the mount options from mtab
and fstab. My plan is to add to mount(8) new command line options to
override the current default, probably something like:

  --options-mode={ignore,append,prepend,replace}
  --options-source={fstab,mtab,none}

so you will have a full control on options for mount(2) syscall.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
