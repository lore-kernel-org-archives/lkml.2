Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757982Ab2CTQxD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 12:53:03 -0400
Received: from mx2.parallels.com ([64.131.90.16]:55416 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757146Ab2CTQxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 12:53:01 -0400
Message-ID: <4F68B590.7090204@parallels.com>
Date: Tue, 20 Mar 2012 20:51:28 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <lizf@cn.fujitsu.com>, <containers@lists.linux-foundation.org>,
        <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <fweisbec@gmail.com>, <rni@google.com>, <ctalbott@google.com>
Subject: Re: [PATCH 09/10] cgroup: introduce struct cfent
References: <1331940963-15756-1-git-send-email-tj@kernel.org> <1331940963-15756-10-git-send-email-tj@kernel.org> <4F688EA9.8050905@parallels.com> <20120320160228.GD5684@google.com> <4F68AA37.80604@parallels.com> <20120320164915.GF5684@google.com>
In-Reply-To: <20120320164915.GF5684@google.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [188.255.67.70]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2012 08:49 PM, Tejun Heo wrote:
> On Tue, Mar 20, 2012 at 08:03:03PM +0400, Glauber Costa wrote:
>>  From 04604201411ab0a14fa1447072cd1b273d0774ed Mon Sep 17 00:00:00 2001
>> From: Glauber Costa<glommer@parallels.com>
>> Date: Tue, 20 Mar 2012 18:12:55 +0400
>> Subject: [PATCH] don't trigger warning when d_subdirs is not empty.
>>
>> It is never empty at this point, because of the self references.
>> a better test is to see if any of them gets d_inode set.
>>
>> Signed-off-by: Glauber Costa<glommer@parallels.com>
>> Signed-off-by: Tejun Heo<tj@kernel.org>
>> ---
>>   kernel/cgroup.c |    8 +++++++-
>>   1 files changed, 7 insertions(+), 1 deletions(-)
>>
>> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
>> index cf7b298..b45a653 100644
>> --- a/kernel/cgroup.c
>> +++ b/kernel/cgroup.c
>> @@ -947,10 +947,16 @@ static int cgroup_rm_file(struct cgroup *cgrp, const struct cftype *cft)
>>   static void cgroup_clear_directory(struct dentry *dir)
>>   {
>>   	struct cgroup *cgrp = __d_cgrp(dir);
>> +	struct list_head *child;
>>
>>   	while (!list_empty(&cgrp->files))
>>   		cgroup_rm_file(cgrp, NULL);
>> -	WARN_ON_ONCE(!list_empty(&dir->d_subdirs));
>> +
>> +	list_for_each(child,&dir->d_subdirs) {
>> +		struct dentry *d;
>> +		d = list_entry(child, struct dentry, d_u.d_child);
>> +		WARN_ON_ONCE(d->d_inode);
>> +	}
>
> This seems correct and I'll apply this but I still can't reproduce the
> warning at will before the patch.  How do I a get negative dentry on
> the d_subdirs when d_delete always returns 1?  Glauber, can you
> trigger the warning at will?
>
> Thanks.
Yes, everytime I reboot the machine.



