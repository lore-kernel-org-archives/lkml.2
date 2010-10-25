Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454Ab0JYBWL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 21:22:11 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60991 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752004Ab0JYBWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 21:22:09 -0400
Message-ID: <4CC4DBF4.1030405@cn.fujitsu.com>
Date: Mon, 25 Oct 2010 09:23:00 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Matt Helsley <matthltc@us.ibm.com>
CC: "akpm >> Andrew Morton" <akpm@linux-foundation.org>,
        containers@lists.linux-foundation.org, Paul Menage <menage@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/7] cgroups: Allow to bind a subsystem to a cgroup hierarchy
References: <4CC146A4.9090505@cn.fujitsu.com> <4CC146D4.7030009@cn.fujitsu.com> <20101022213819.GK10119@count0.beaverton.ibm.com>
In-Reply-To: <20101022213819.GK10119@count0.beaverton.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +/*
>> + * cgroup_walk_herarchy - iterate through a cgroup hierarchy
>> + * @process_cgroup: callback called on each cgroup in the hierarchy
>> + * @data: will be passed to @process_cgroup
>> + * @top_cgrp: the root cgroup of the hierarchy
>> + *
>> + * For such a hierarchy:
>> + *        a1        c1
>> + *      /         /
>> + * Root - a2 - b1 - c2
>> + *      \
>> + *        a3
>> + *
>> + * The iterating order is: a1, a2, b1, c1, c2, a3. So a parent will be
>> + * processed before its children.
>> + */
> 
> You could just say it's a depth-first walk except we process the parent before
> its children.
> 

Will revise the comment. A diagram is intuitive. :)

>> +static int cgroup_walk_hierarchy(int (*process_cgroup)(struct cgroup *, void *),
>> +				 void *data, struct cgroup *top_cgrp)
> 
> <snip>
> 
>> +static int hierarchy_populate_dir(struct cgroup *cgrp, void *data)
>> +{
>> +	mutex_lock_nested(&cgrp->dentry->d_inode->i_mutex, I_MUTEX_CHILD);
>> +	cgroup_populate_dir(cgrp);
>> +	mutex_unlock(&cgrp->dentry->d_inode->i_mutex);
>> +	return 0;
>> +}
>> +
>>  /*
>>   * Call with cgroup_mutex held. Drops reference counts on modules, including
>>   * any duplicate ones that parse_cgroupfs_options took. If this function
>> @@ -945,36 +1079,53 @@ static int rebind_subsystems(struct cgroupfs_root *root,
>>  	unsigned long added_bits, removed_bits;
>>  	struct cgroup *cgrp = &root->top_cgroup;
>>  	int i;
>> +	int err;
>>
>>  	BUG_ON(!mutex_is_locked(&cgroup_mutex));
>>
>>  	removed_bits = root->actual_subsys_bits & ~final_bits;
>>  	added_bits = final_bits & ~root->actual_subsys_bits;
>> +
>>  	/* Check that any added subsystems are currently free */
>> -	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
>> -		unsigned long bit = 1UL << i;
>> -		struct cgroup_subsys *ss = subsys[i];
>> -		if (!(bit & added_bits))
>> -			continue;
>> +	for_each_set_bit(i, &added_bits, CGROUP_SUBSYS_COUNT) {
>>  		/*
>>  		 * Nobody should tell us to do a subsys that doesn't exist:
>>  		 * parse_cgroupfs_options should catch that case and refcounts
>>  		 * ensure that subsystems won't disappear once selected.
>>  		 */
>> -		BUG_ON(ss == NULL);
>> -		if (ss->root != &rootnode) {
>> +		BUG_ON(subsys[i] == NULL);
>> +		if (subsys[i]->root != &rootnode) {
>>  			/* Subsystem isn't free */
>>  			return -EBUSY;
>>  		}
>>  	}
>>
>> -	/* Currently we don't handle adding/removing subsystems when
>> -	 * any child cgroups exist. This is theoretically supportable
>> -	 * but involves complex error handling, so it's being left until
>> -	 * later */
>> -	if (root->number_of_cgroups > 1)
>> +	/* removing will be supported later */
>> +	if (root->number_of_cgroups > 1 && removed_bits)
>>  		return -EBUSY;
>>
>> +	if (root->number_of_cgroups > 1) {
> 
> Is there something wrong with the indentation here? I can't
> see the closing brace for the "if (root->number_of_cgroups > 1)"
> that should precede the for_each_set_bit() loop below.
> 

Oops, I must have forgot to commit the change when I fixed this.

>> +		for_each_set_bit(i, &added_bits, CGROUP_SUBSYS_COUNT)
>> +			if (!subsys[i]->can_bind)
>> +				return -EBUSY;
> 
> I think you could avoid the can_bind flag field entirely and do:
> 
> 			if (!subsys[i]->bind)
> 

Nope. For some subsystems we just set the flag and need not to
provide a bind() callback.

> Also, if we're going with my "split out unbind" suggestion I think
> the part here would be:
> 
> 		for_each_set_bit(i, &removed_bits, CGROUP_SUBSYS_COUNT)
> 			if (!subsys[i]->unbind)
> 				return -EBUSY;
> 
