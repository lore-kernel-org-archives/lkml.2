Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab2LCAps (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 19:45:48 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57218 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754372Ab2LCApr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 19:45:47 -0500
X-IronPort-AV: E=Sophos;i="4.83,359,1352044800"; 
   d="scan'208";a="6317091"
Message-ID: <50BBF631.3070304@cn.fujitsu.com>
Date: Mon, 03 Dec 2012 08:45:37 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: cgroups@vger.kernel.org, lizefan@huawei.com, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: Re: [PATCH 2/2] cgroup: remove subsystem files when remounting cgroup
References: <1354292489-18434-1-git-send-email-gaofeng@cn.fujitsu.com> <1354292489-18434-2-git-send-email-gaofeng@cn.fujitsu.com> <20121130192735.GF3873@htj.dyndns.org>
In-Reply-To: <20121130192735.GF3873@htj.dyndns.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/03 08:45:10,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/03 08:45:11,
	Serialize complete at 2012/12/03 08:45:11
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tejun

on 2012/12/01 03:27, Tejun Heo wrote:
> Hello, Gao.
> 
> On Sat, Dec 01, 2012 at 12:21:29AM +0800, Gao feng wrote:
>> cgroup_clear_directroy is called by cgroup_d_remove_dir
>> and cgroup_remount.
>>
>> when we call cgroup_remount to remount the cgroup,the subsystem
>> may be unlinked from cgroupfs_root->subsys_list in rebind_subsystem,this
>> subsystem's files will not be removed in cgroup_clear_directroy.
>> And the system will panic when we try to access these files.
>>
>> this patch fix it.
> 
> I'd really appreciated if you explain how it's fixed.
> 
>> Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
>> ---
>>  kernel/cgroup.c |   86 ++++++++++++++++++++++++++++++++++--------------------
>>  1 files changed, 54 insertions(+), 32 deletions(-)
>>
>> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
>> index e5233b7..90429d5 100644
>> --- a/kernel/cgroup.c
>> +++ b/kernel/cgroup.c
>> @@ -982,10 +982,14 @@ static void cgroup_clear_directory(struct dentry *dir, bool base_files,
>>  				   unsigned long subsys_mask)
>>  {
>>  	struct cgroup *cgrp = __d_cgrp(dir);
>> -	struct cgroup_subsys *ss;
>> +	int i;
>>  
>> -	for_each_subsys(cgrp->root, ss) {
>> +	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
>>  		struct cftype_set *set;
>> +		struct cgroup_subsys *ss = subsys[i];
>> +
>> +		if (ss == NULL)
>> +			continue;
> 
> Ummm... I can't say I like it.  It tries to work around the problem
> that the backing subsys may go away earlier by changing how the
> subsystems are iterated so that the "gone" subsystems can be iterated,
> which really doesn't seem like a good diea.  I mean, what if somebody
> tries to access the files inbetween?  root_cgrp->subsys[] would be
> %NULL and segfault all the same.
> 

Yes,You are right.I didn't consider this problem.

>>  static void drop_parsed_module_refcounts(unsigned long subsys_mask)
>> @@ -1392,23 +1403,34 @@ static int cgroup_remount(struct super_block *sb, int *flags, char *data)
>>  	removed_mask = root->subsys_mask & ~opts.subsys_mask;
>>  
>>  	/* Don't allow flags or name to change at remount */
>> +	ret = -EINVAL;
>>  	if (opts.flags != root->flags ||
>>  	    (opts.name && strcmp(opts.name, root->name))) {
>> -		ret = -EINVAL;
>>  		drop_parsed_module_refcounts(opts.subsys_mask);
>>  		goto out_unlock;
>>  	}
>>  
>> -	ret = rebind_subsystems(root, opts.subsys_mask);
>> +	/*
>> +	 * Add the reference of these removed subsystem,we
>> +	 * need use subsystems to remove their cgroup files.
>> +	 */
>> +	ret = cgroup_get_module_refcounts(removed_mask);
>>  	if (ret) {
>>  		drop_parsed_module_refcounts(opts.subsys_mask);
>>  		goto out_unlock;
>>  	}
>>  
>> +	ret = rebind_subsystems(root, opts.subsys_mask);
>> +	if (ret) {
>> +		drop_parsed_module_refcounts(opts.subsys_mask | removed_mask);
>> +		goto out_unlock;
>> +	}
>> +
>>  	/* clear out any existing files and repopulate subsystem files */
>>  	cgroup_clear_directory(cgrp->dentry, false, removed_mask);
>>  	/* re-populate subsystem files */
>>  	cgroup_populate_dir(cgrp, false, added_mask);
>> +	drop_parsed_module_refcounts(removed_mask);
> 
> So, how about performing cgroup_clear_directory() *before*
> rebind_subsystems() and then restore it afterwards?
> 

Get it,will fix this problem as you said.

Thanks!

