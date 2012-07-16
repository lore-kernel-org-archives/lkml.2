Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629Ab2GPQow (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 12:44:52 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33081 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224Ab2GPQov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 12:44:51 -0400
Date: Mon, 16 Jul 2012 09:44:45 -0700
From: "'Tejun Heo'" <tj@kernel.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Shyju PV <shyju.pv@huawei.com>, "'Li Zefan'" <lizefan@huawei.com>,
        "'Sanil kumar'" <sanil.kumar@huawei.com>,
        "'Masanari Iida'" <standby24x7@gmail.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Cgroups'" <cgroups@vger.kernel.org>, levinsasha928@gmail.com,
        nagamani.mantha@huawei.com
Subject: Re: [PATCH 2/2] cgroup: fix cgroup hierarchy umount race
Message-ID: <20120716164445.GA30872@google.com>
References: <4FEEA5CB.8070809@huawei.com>
 <20120703170317.GB555@google.com>
 <20120703225218.GF555@google.com>
 <4ff55c60.27da440a.65ec.ffff83dfSMTPIN_ADDED@mx.google.com>
 <20120707234634.GC16783@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120707234659.GD16783@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120714120852.GK22927@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120714120852.GK22927@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Al.

On Sat, Jul 14, 2012 at 01:08:52PM +0100, Al Viro wrote:
> On Sat, Jul 07, 2012 at 04:46:59PM -0700, 'Tejun Heo' wrote:
> > Fix it by holding an extra superblock->s_active reference across
> > dput() from css release, which is the dput() path added by 48ddbe1946
> > and the only one which doesn't hold an extra s_active ref across the
> > final cgroup dput().
> 
> > @@ -3883,8 +3883,12 @@ static void css_dput_fn(struct work_struct *work)
> >  {
> >  	struct cgroup_subsys_state *css =
> >  		container_of(work, struct cgroup_subsys_state, dput_work);
> > +	struct dentry *dentry = css->cgroup->dentry;
> > +	struct super_block *sb = dentry->d_sb;
> >  
> > -	dput(css->cgroup->dentry);
> > +	atomic_inc(&sb->s_active);
> > +	dput(dentry);
> > +	deactivate_super(sb);
> >  }
> 
> While we are at it, what guarantees that css->dput_work will complete before
> css->cgroup or the object containing css get freed under us?

css's are tied to the cgroup.  They are created on cgroup creation and
destroyed together with cgroup, which is controlled by the dentry
refcnt.  css refcnts are relaying reference to cgroup dentry refcnt.

The reason why css needs this finer grained refcnts instead of
directly using cgroup dentry refcnt is that for some subsystems cgroup
removal tries to drain all css refcnts before proceeding with removal.

Thanks.

-- 
tejun
