Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965106Ab2CTIwS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 04:52:18 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:34748 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964972Ab2CTIwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 04:52:14 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>, glommer@parallels.com, lizf@cn.fujitsu.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, rni@google.com,
        ctalbott@google.com, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 03/10] cgroup: implement cgroup_add_cftypes() and friends
In-Reply-To: <1331940963-15756-4-git-send-email-tj@kernel.org>
References: <1331940963-15756-1-git-send-email-tj@kernel.org> <1331940963-15756-4-git-send-email-tj@kernel.org>User-Agent: Notmuch/0.11.1+346~g13d19c3 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 20 Mar 2012 14:22:02 +0530
Message-ID: <877gyfu025.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12031922-1396-0000-0000-000000D72F0D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Currently, cgroup directories are populated by subsys->populate()
> callback explicitly creating files on each cgroup creation.  This
> level of flexibility isn't needed or desirable.  It provides largely
> unused flexibility which call for abuses while severely limiting what
> the core layer can do through the lack of structure and conventions.
>
> Per each cgroup file type, the only distinction that cgroup users is
> making is whether a cgroup is root or not, which can easily be
> expressed with flags.
>
> This patch introduces cgroup_add_cftypes() and its wrapper macros -
> CGROUP_SUBSYS_CFTYPES[_COND]().  These deal with cftypes instead of
> individual files - controllers indicate that certain types of files
> exist for certain subsystem.  Newly added CFTYPE_*_ON_ROOT flags
> indicate whether a cftype should be excluded or created only on the
> root cgroup.
>
> cgroup_add_cftypes() can be called any time whether the target
> subsystem is currently attached or not.  cgroup core will create files
> on the existing cgroups as necessary.  CGROUP_SUBSYS_CFTYPES[_COND]()
> are convenience macros controllers so that cftypes can be declared to
> belong to certain cgroup.  The COND variant is useful for cases where
> certain files are dependent on boot time parameter.
>
> Further patches will convert the existing users and remove the file
> based interface.  Note that this interface allows dynamic addition of
> files to an active controller.  This will be used for sub-controller
> modularity and unified hierarchy in the longer term.
>
> This patch implements the new mechanism but doesn't apply it to any
> user.
>

.....

> +/*
> + * Declare cftype array @cfts for cgroup subsys @ss if @cond is %true.
> + * Useful if the files are dependent on boot time parameter.
> + */
> +#define CGROUP_SUBSYS_CFTYPES_COND(ss, cfts, cond)			\
> +	static int __init __cgroup_cfts_init_##ss_##cfts(void)		\
> +	{								\
> +		if ((cond))						\
> +			WARN_ON(cgroup_add_cftypes(&ss, cfts));		\
> +		return 0;						\
> +	}								\
> +	fs_initcall(__cgroup_cfts_init_##ss_##cfts);
> +

Instead of using CGROUP_SUBSYS_CFTYPES_COND, are you ok if other
subsystem called cgroup_add_cftypes ?. I am looking at how this will
impact http://article.gmane.org/gmane.linux.kernel.mm/75470 . With
HugeTLB we cannot do the above. 

-aneesh

