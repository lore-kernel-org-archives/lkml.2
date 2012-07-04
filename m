Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933260Ab2GDGA2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 02:00:28 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:54493 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab2GDGAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 02:00:23 -0400
Message-ID: <4FF3DB08.5080606@huawei.com>
Date: Wed, 4 Jul 2012 13:56:24 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: shyju pv <shyju.pv@huawei.com>, Sanil kumar <sanil.kumar@huawei.com>,
        Masanari Iida <standby24x7@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] cgroup: fix dentry still in use bug when dropping css
 refs after umount
References: <4FEEA5CB.8070809@huawei.com> <20120703170317.GB555@google.com>
In-Reply-To: <20120703170317.GB555@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.166.88.115]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> @@ -78,8 +79,8 @@ struct cgroup_subsys_state {

>>  	/* ID for this css, if possible */
>>  	struct css_id __rcu *id;
>>  
>> -	/* Used to put @cgroup->dentry on the last css_put() */
>> -	struct work_struct dput_work;
>> +	/* Used to put @cgroup->css_refs on the last css_put() */
>> +	struct work_struct put_work;
>>  };
>>  
>>  /* bits in struct cgroup_subsys_state flags field */
>> @@ -170,6 +171,9 @@ struct cgroup {
>>  	 */
>>  	atomic_t count;
>>  
>> +	/* We won't destroy the cgroup when there are css refs */
>> +	struct kref css_refs;
>> +
>>  	/*
>>  	 * We link our 'sibling' struct into our parent's 'children'.
>>  	 * Our children link their 'sibling' into our 'children'.
> 
> Hmm... adding another layer of refcnting.  Now we end up with three
> layers of refcnting - the active usage via cgroup->count, cgroup
> lifetime via cgroup->dentry->d_count and this extended lifecycle
> refcnt.  In addition, we now have to deal with partially destroyed
> cgroups - e.g. running cgroup_path() will oops on lingering cgroups.
> Hating this tangling of dentries and cgroups more and more.  :(
> 


yeah, the fix you sent looks better.

