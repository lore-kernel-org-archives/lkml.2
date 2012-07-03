Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757015Ab2GCRKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 13:10:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35609 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab2GCRKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 13:10:38 -0400
Date: Tue, 3 Jul 2012 10:10:33 -0700
From: Tejun Heo <tj@kernel.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Li Zefan <lizefan@huawei.com>, shyju pv <shyju.pv@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Sanil kumar <sanil.kumar@huawei.com>,
        Masanari Iida <standby24x7@gmail.com>
Subject: Re: 3.5-rc3: BUG: Dentry still in use (1) [unmount of cgroup
 cgroup]
Message-ID: <20120703171033.GC555@google.com>
References: <E061084CB90FCE4F89232A6CF839683B32B52291@SZXEML507-MBS.china.huawei.com>
 <20120627182903.GP15811@google.com>
 <4FEBF4B7.2070105@huawei.com>
 <20120628180712.GC22641@google.com>
 <4FED10DB.7040500@huawei.com>
 <20120629165809.GB21048@google.com>
 <4FEE98EE.1050409@huawei.com>
 <20120630064724.GC14083@ZenIV.linux.org.uk>
 <CAOS58YNnU3J+c2ZQcRCesSoxn0dSJjDLBsZ2qzZ09X6N-ky0fQ@mail.gmail.com>
 <20120630083421.GD14083@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120630083421.GD14083@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Al.

On Sat, Jun 30, 2012 at 09:34:21AM +0100, Al Viro wrote:
> Now that I've looked at that code again...  What's the story with
>                 simple_unlink(d->d_inode, d);
> in cgroup_rm_file()?  Wrong parent inode, at the very least...

Yeah, indeed.  My mistake while refactoring the code.  Will fix.

> While we are at it, what the hell is going on in
> static void cgroup_clear_directory(struct dentry *dir)
> {
>         struct cgroup *cgrp = __d_cgrp(dir);
> 
>         while (!list_empty(&cgrp->files))
>                 cgroup_rm_file(cgrp, NULL);
> }
> Are you fighting some kind of race against somebody adding stuff
> there?  Unless I'm seriously misreading cgroup_rm_file(), it'll
> do all the work on the first call...

cgroup_rm_file() finds the file matching @cft, deletes that one file
and returns.  Passing in %NULL @cft makes it deletes the first file
but it still returns after deleting one.  Maybe breaking up
list_for_each_entry() so that deletion and returning is outside the
loop would make that clearer.

Thanks.

-- 
tejun
