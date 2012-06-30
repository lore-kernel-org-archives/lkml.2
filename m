Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673Ab2F3Ie3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 04:34:29 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54180 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320Ab2F3Ie0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 04:34:26 -0400
Date: Sat, 30 Jun 2012 09:34:21 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, shyju pv <shyju.pv@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Sanil kumar <sanil.kumar@huawei.com>,
        Masanari Iida <standby24x7@gmail.com>
Subject: Re: 3.5-rc3: BUG: Dentry still in use (1) [unmount of cgroup cgroup]
Message-ID: <20120630083421.GD14083@ZenIV.linux.org.uk>
References: <E061084CB90FCE4F89232A6CF839683B32B52291@SZXEML507-MBS.china.huawei.com>
 <20120627182903.GP15811@google.com>
 <4FEBF4B7.2070105@huawei.com>
 <20120628180712.GC22641@google.com>
 <4FED10DB.7040500@huawei.com>
 <20120629165809.GB21048@google.com>
 <4FEE98EE.1050409@huawei.com>
 <20120630064724.GC14083@ZenIV.linux.org.uk>
 <CAOS58YNnU3J+c2ZQcRCesSoxn0dSJjDLBsZ2qzZ09X6N-ky0fQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOS58YNnU3J+c2ZQcRCesSoxn0dSJjDLBsZ2qzZ09X6N-ky0fQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 30, 2012 at 12:04:36AM -0700, Tejun Heo wrote:
> Hello, Al.
> 
> On Fri, Jun 29, 2012 at 11:47 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > On Sat, Jun 30, 2012 at 02:13:02PM +0800, Li Zefan wrote:
> >> So it's bad to have dentry refcnts dangling after umount.
> >
> > No shit. ?Yes, it is bad. ?What on the Earth is cgroup code doing with
> > those? ?And what could it possibly want to do with dentry reference
> > after the filesystem has been shut down, assuming it could hold one
> > in the first place?
> 
> cgroup interface code was copied from sysfs back when it was
> piggybacking internal data structures to dentries, so, unfortunately,
> sysfs is still using dentries to manage internal data structures and
> propagates internal refs to dentry refs. There seem to be several
> places where dentry ref is held w/o active super ref triggering BUG on
> umount. Longer term, it should be updated to share sysfs code, I
> guess.

Now that I've looked at that code again...  What's the story with
                simple_unlink(d->d_inode, d);
in cgroup_rm_file()?  Wrong parent inode, at the very least...

While we are at it, what the hell is going on in
static void cgroup_clear_directory(struct dentry *dir)
{
        struct cgroup *cgrp = __d_cgrp(dir);

        while (!list_empty(&cgrp->files))
                cgroup_rm_file(cgrp, NULL);
}
Are you fighting some kind of race against somebody adding stuff
there?  Unless I'm seriously misreading cgroup_rm_file(), it'll
do all the work on the first call...
