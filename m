Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457Ab1LSIBD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 03:01:03 -0500
Received: from mx2.parallels.com ([64.131.90.16]:50472 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411Ab1LSIA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 03:00:59 -0500
Message-ID: <4EEEEF13.9090701@parallels.com>
Date: Mon, 19 Dec 2011 12:00:19 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: <linux-kernel@vger.kernel.org>, <paul@paulmenage.org>,
        <daniel.lezcano@free.fr>, <a.p.zijlstra@chello.nl>,
        <jbottomley@parallels.com>, <pjt@google.com>,
        <cgroups@vger.kernel.org>, <bsingharora@gmail.com>, <devel@openvz.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC] cgroup basic comounting
References: <1324038549-21605-1-git-send-email-glommer@parallels.com> <4EEEEE9D.1010003@cn.fujitsu.com>
In-Reply-To: <4EEEEE9D.1010003@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2011 11:58 AM, Li Zefan wrote:
> Glauber Costa wrote:
>> Turns out that most of the infrastructure we need to put two controllers in the
>> same hierarchy is by far already into place. All we need to do is not failing
>> when we specify two of them.
>>
>
> You don't need to change anything to mount with 2 cgroup subsystems:
>
> 	# mount -t cgroup -o cpu,cpuacct xxx /mnt
>
> But you may want to revise and make use of the subsys->bind() callback, which
> is called at mount/remount/umount when we attach/remove a controller to/from
> a hierarchy. It's the place you can check if two controllers are going to
> be comounted/seperated.
>
>> With this, we can effectively guarantee that by comounting cpu and cpuacct,
>> we'll have the same set of tasks, therefore allowing us to use cpu cgroup data
>> to fill in the usage fields in cpuacct.

Yeah, that patch was bogus, sorry for the noise.

What I should really have posted is the test code, but I guess I'll go 
over that one as well one more time, and then post it.

Thanks
>> I decided not to stabilish any dependency between cgroups as Li previously did:
>> cgroups may or may not be comounted, and any of them can be combined (I don't
>> see a reason to prevent any combination).
>>
>> After testing and some trials, I could verify that the current mount behavior
>> plays well under the plans, so I didn't change it. That is:
>>
>>   * If subsystems A and B aren't mounted, we can comount them.
>>   * If subsystem A is mounted, but B is not:
>>     * we can comount them if A has no children,
>>     * we fail otherwise
>>   * If subsystems A and B are comounted at a location, we can't
>>     mount any of them separately at another point. We do can mount
>>     them together.
>>   * If subsystems A and B are comounted at a location,
>>     * we can comount a third subsystem C, if they have no children
>>     * we fail otherwise
>>
>> Paul,
>>
>> Please let me know if this is tuned with the idea you had in mind.
>> If this is okay, I patch that extracts usage from cpu cgroup data
>> in case of comount would follow.
>>
>> Signed-off-by: Glauber Costa<glommer@parallels.com>
>> CC: Paul Turner<pjt@google.com>
>> CC: Li Zefan<lizf@cn.fujitsu.com>
>> ---
>>   kernel/cgroup.c |    4 ++--
>>   1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
>> index 1fd7867..e894a4f 100644
>> --- a/kernel/cgroup.c
>> +++ b/kernel/cgroup.c
>> @@ -1211,9 +1211,9 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
>>   			set_bit(i,&opts->subsys_bits);
>>   			one_ss = true;
>>
>> -			break;
>> +			continue;
>>   		}
>> -		if (i == CGROUP_SUBSYS_COUNT)
>> +		if (opts->subsys_bits == 0)
>>   			return -ENOENT;
>>   	}
>>
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

