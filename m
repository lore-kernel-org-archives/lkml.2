Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389Ab1LWDi0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 22:38:26 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57438 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752843Ab1LWDiZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 22:38:25 -0500
Message-ID: <4EF3F834.0@cn.fujitsu.com>
Date: Fri, 23 Dec 2011 11:40:36 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH] cgroup: move a check to parse_cgroupfs_options()
References: <4EF2EDA7.4010004@cn.fujitsu.com> <20111222152011.GA17084@google.com>
In-Reply-To: <20111222152011.GA17084@google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-23 11:37:39,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-23 11:37:40
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年12月22日 23:20, Tejun Heo 写道:
> Hello,
> 
> On Thu, Dec 22, 2011 at 04:43:19PM +0800, Li Zefan wrote:
>> Always check the validity of mount options in parse_cgroupfs_options().
>>
>> No functional change.
>>
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>> ---
>>  kernel/cgroup.c |   15 +++++++--------
>>  1 files changed, 7 insertions(+), 8 deletions(-)
>>
>> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
>> index 4936d88..bdb7994 100644
>> --- a/kernel/cgroup.c
>> +++ b/kernel/cgroup.c
>> @@ -1218,7 +1218,6 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
>>  	    (opts->subsys_bits & mask))
>>  		return -EINVAL;
>>  
>> -
>>  	/* Can't specify "none" and some subsystems */
>>  	if (opts->subsys_bits && opts->none)
>>  		return -EINVAL;
>> @@ -1231,6 +1230,13 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
>>  		return -EINVAL;
>>  
>>  	/*
>> +	 * This can happen only when none of the subsystems is enabled
>> +	 * in the system.
>> +	 */
>> +	if (!opts->subsys_bits && !opts->none)
>> +		return -EINVAL;
> 
> The three ifs here share a lot and I think sharing the common parts
> would make the logic clearer.  e.g. The first and this can be easily
> combined to (bool)opts->subsys_bits != (bool)opts->none which would
> explain the logic better too.
> 

ok.

>> @@ -1442,10 +1445,6 @@ static int cgroup_set_super(struct super_block *sb, void *data)
>>  	int ret;
>>  	struct cgroup_sb_opts *opts = data;
>>  
>> -	/* If we don't have a new root, we can't set up a new sb */
>> -	if (!opts->new_root)
>> -		return -EINVAL;
>> -
> 
> And where did this one go?
> 

The other one I removed sets opts->new_root to NULL, and this one detects
the NULL ptr:

if (!opts->subsys_bits && !opts->none)
	return NULL;
...
opts->new_root = NULL;
...
if (!opts->new_root)
	return -EINVAL;

shortcut to:

if (!opts->subsys_bits && !opts->none)
	return -EINVAL;
