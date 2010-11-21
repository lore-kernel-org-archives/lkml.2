Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388Ab0KUPpB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 10:45:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754031Ab0KUPpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 10:45:00 -0500
Date: Sun, 21 Nov 2010 10:44:04 -0500
From: Josef Bacik <josef@redhat.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
        eparis@redhat.com, linux-kernel@vger.kernel.org, sds@tycho.nsa.gov,
        selinux@tycho.nsa.gov
Subject: Re: [PATCH] fs: call security_d_instantiate in d_obtain_alias V2
Message-ID: <20101121154402.GA20863@dhcp231-156.rdu.redhat.com>
References: <1290131575-2489-1-git-send-email-josef@redhat.com> <20101119223552.GB12783@fieldses.org> <20101121025945.GA4365@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101121025945.GA4365@fieldses.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 20, 2010 at 09:59:45PM -0500, J. Bruce Fields wrote:
> On Fri, Nov 19, 2010 at 05:35:52PM -0500, J. Bruce Fields wrote:
> > On Thu, Nov 18, 2010 at 08:52:55PM -0500, Josef Bacik wrote:
> > > While trying to track down some NFS problems with BTRFS, I kept noticing I was
> > > getting -EACCESS for no apparent reason.  Eric Paris and printk() helped me
> > > figure out that it was SELinux that was giving me grief, with the following
> > > denial
> > > 
> > > type=AVC msg=audit(1290013638.413:95): avc:  denied  { 0x800000 } for  pid=1772
> > > comm="nfsd" name="" dev=sda1 ino=256 scontext=system_u:system_r:kernel_t:s0
> > > tcontext=system_u:object_r:unlabeled_t:s0 tclass=file
> > > 
> > > Turns out this is because in d_obtain_alias if we can't find an alias we create
> > > one and do all the normal instantiation stuff, but we don't do the
> > > security_d_instantiate.
> > > 
> > > Usually we are protected from getting a hashed dentry that hasn't yet run
> > > security_d_instantiate() by the parent's i_mutex, but obviously this isn't an
> > > option there, so in order to deal with the case that a second thread comes in
> > > and finds our new dentry before we get to run security_d_instantiate(), we go
> > > ahead and call it if we find a dentry already.  Eric assures me that this is ok
> > > as the code checks to see if the dentry has been initialized already so calling
> > > security_d_instantiate() against the same dentry multiple times is ok.  With
> > > this patch I'm no longer getting errant -EACCESS values.
> > 
> > Thanks, I can't see any reason that wouldn't work.
> 
> (FWIW, I also ran my usual nfs regression tests with this applied.  They
> don't exercise the problem you were seeing, but maybe it's at least some
> sort of sanity check.)
>

Oh I should have mentioned the testing I gave it.  With BTRFS I could regularly
reproduce this by doing the following

SERVER
mount /dev/sda1 /mnt/btrfs
btrfs subvol create /mnt/btrfs/foo
cp mutt.tar.gz /mnt/btrfs/foo

CLIENT
mount server:/mnt/btrfs /mnt/test
cd /mnt/test/foo
tar xzvf mutt.tar.gz
cd mutt
ls

SERVER
echo 3 > /proc/sys/vm/drop_caches

CLIENT
ls

and bam I'd get -EACCESS every time.  I did this a bunch of times to make sure
it didn't happen anymore plus variations of the above.  Thanks,

Josef 
