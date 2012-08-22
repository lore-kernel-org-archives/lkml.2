Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933356Ab2HVU4O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 16:56:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46274 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933298Ab2HVU4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 16:56:06 -0400
Date: Wed, 22 Aug 2012 16:55:57 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: Hugh Dickins <hughd@google.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Hillf Danton <dhillf@gmail.com>,
        Lennart Poettering <lpoetter@redhat.com>
Subject: Re: [PATCH v6 1/4] xattr: extract simple_xattr code from tmpfs
Message-ID: <20120822205556.GE16951@redhat.com>
References: <20120816174453.154143248@napanee.usersys.redhat.com>
 <20120816174453.507922179@napanee.usersys.redhat.com>
 <20120816195831.GF24861@google.com>
 <alpine.LSU.2.00.1208192356580.24824@eggly.anvils>
 <20120820190039.GR25353@redhat.com>
 <alpine.LSU.2.00.1208202122470.1286@eggly.anvils>
 <20120822200746.GD16951@redhat.com>
 <alpine.LSU.2.00.1208221312540.1909@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1208221312540.1909@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 01:25:06PM -0700, Hugh Dickins wrote:
> > > Probably more important would be to remove spin_lock() and spin_unlock()
> > > (and INIT_LIST_HEAD) from simple_xattrs_free() - those are unnecessary
> > > in shmem_evict_inode(), and wouldn't they be unnecessary whenever
> > > simple_xattrs_free() gets called?
> > 
> > Removing INIT_LIST_HEAD() it's possible by actually unlinking each xattr
> > inside the loop before freeing them. still, it'll have to check if the list is
> > empty or not, which might end up being the same?
> > 
> > About the locking, I'm not sure, I'm investigating it.
> 
> I think we have a misunderstanding.
> 
> INIT_LIST_HEAD() is not expensive, I just meant to remove it because
> I thought it unnecessary by that point.

ah, I see.

> Do you envisage anywhere that would call simple_xattrs_free() except
> a filesystem's evict_inode()?

cgroup does it differently and it's called in d_iput() path (see cgroup_diput),
because it needs to selectively remove files upon remount.

> By that point, the inode is on its way out of the system: nothing
> much (yes, I am being a bit vague there ;) can get to it any more,
> there's no need to reinitialize the list head and there's no need for
> locking, because nothing else can be playing with those xattrs now.

I agree with you. That's why I'm looking into it because I'm pretty sure
I removed it at some point in the past and decided to put it back after
investigating the easily reproducible oops. Sadly I managed to forget
the analisys I did at the time.

-- 
Aristeu

