Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100Ab2CaQlx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 12:41:53 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:54940 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab2CaQlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 12:41:51 -0400
Date: Sat, 31 Mar 2012 09:41:46 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Lennart Poettering <mzxreary@0pointer.de>
Subject: Re: [PATCH] cgroup: deprecate remount option changes mount option
Message-ID: <20120331164146.GD2557@dhcp-172-17-108-109.mtv.corp.google.com>
References: <20120314215228.GI7349@google.com>
 <20120315165655.GD32137@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120315165655.GD32137@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li, re-sending to your new address just in case you missed this one.

On Thu, Mar 15, 2012 at 09:56:55AM -0700, Tejun Heo wrote:
> This patch marks the following features for deprecation.
> 
> * Rebinding subsys by remount: Never reached useful state - only works
>   on empty hierarchies.
> 
> * release_agent update by remount: release_agent itself will be
>   replaced with conventional fsnotify notification.
> 
> v2: Lennart pointed out that "name=" is necessary for mounts w/o any
>     controller attached.  Drop "name=" deprecation.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Lennart Poettering <mzxreary@0pointer.de>
> ---
>  Documentation/feature-removal-schedule.txt |   10 ++++++++++
>  kernel/cgroup.c                            |    5 +++++
>  2 files changed, 15 insertions(+)
> 
> Index: work/Documentation/feature-removal-schedule.txt
> ===================================================================
> --- work.orig/Documentation/feature-removal-schedule.txt
> +++ work/Documentation/feature-removal-schedule.txt
> @@ -510,3 +510,13 @@ Why:	The pci_scan_bus_parented() interfa
>  	convert to using pci_scan_root_bus() so they can supply a list of
>  	bus resources when the bus is created.
>  Who:	Bjorn Helgaas <bhelgaas@google.com>
> +
> +----------------------------
> +
> +What:	cgroup option updates via remount
> +When:	March 2013
> +Why:	Remount currently allows changing bound subsystems and
> +	release_agent.  Rebinding is hardly useful as it only works
> +	when the hierarchy is empty and release_agent itself should be
> +	replaced with conventional fsnotify.
> +Who:	Tejun Heo <tj@kernel.org>
> Index: work/kernel/cgroup.c
> ===================================================================
> --- work.orig/kernel/cgroup.c
> +++ work/kernel/cgroup.c
> @@ -1294,6 +1294,11 @@ static int cgroup_remount(struct super_b
>  	if (ret)
>  		goto out_unlock;
>  
> +	/* See feature-removal-schedule.txt */
> +	if (opts.subsys_bits != root->actual_subsys_bits || opts.release_agent)
> +		pr_warning("cgroup: option changes via remount are deprecated (pid=%d comm=%s)\n",
> +			   task_tgid_nr(current), current->comm);
> +
>  	/* Don't allow flags or name to change at remount */
>  	if (opts.flags != root->flags ||
>  	    (opts.name && strcmp(opts.name, root->name))) {

-- 
tejun
