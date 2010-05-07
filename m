Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159Ab0EGGyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 02:54:19 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60079 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752669Ab0EGGyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 02:54:17 -0400
Message-ID: <4BE3B985.1000407@cn.fujitsu.com>
Date: Fri, 07 May 2010 14:56:05 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com, Jens Axboe <jens.axboe@oracle.com>
CC: "containers@lists.osdl.org" <containers@lists.osdl.org>,
       Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
       Gui Jianfeng <GuiJianfeng@cn.fujitsu.com>
Subject: Re: [PATCH 5/5] blk-cgroup: Fix an RCU warning in blkiocg_create()
References: <4BD016F4.8060108@cn.fujitsu.com> <4BD017AC.1020209@cn.fujitsu.com> <20100422195725.GM2524@linux.vnet.ibm.com>
In-Reply-To: <20100422195725.GM2524@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> On Thu, Apr 22, 2010 at 05:32:28PM +0800, Li Zefan wrote:
>> with CONFIG_PROVE_RCU=y, a warning can be triggered:
>>
>>   # mount -t cgroup -o blkio xxx /mnt
>>   # mkdir /mnt/subgroup
>>
>> ...
>> kernel/cgroup.c:4442 invoked rcu_dereference_check() without protection!
>> ...
>>
>> To fix this, we avoid caling css_depth() here, which is a bit simpler
>> than the original code.
> 
> Queued for 2.6.34, thank you!
> 

Seems neither you nor Jens queued this patch...

> 							Thanx, Paul
> 
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>> ---
>>  block/blk-cgroup.c |    8 ++++----
>>  1 files changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
>> index 5fe03de..2cc682b 100644
>> --- a/block/blk-cgroup.c
>> +++ b/block/blk-cgroup.c
>> @@ -286,16 +286,16 @@ done:
>>  static struct cgroup_subsys_state *
>>  blkiocg_create(struct cgroup_subsys *subsys, struct cgroup *cgroup)
>>  {
>> -	struct blkio_cgroup *blkcg, *parent_blkcg;
>> +	struct blkio_cgroup *blkcg;
>> +	struct cgroup *parent = cgroup->parent;
>>
>> -	if (!cgroup->parent) {
>> +	if (!parent) {
>>  		blkcg = &blkio_root_cgroup;
>>  		goto done;
>>  	}
>>
>>  	/* Currently we do not support hierarchy deeper than two level (0,1) */
>> -	parent_blkcg = cgroup_to_blkio_cgroup(cgroup->parent);
>> -	if (css_depth(&parent_blkcg->css) > 0)
>> +	if (parent != cgroup->top_cgroup)
>>  		return ERR_PTR(-EINVAL);
>>
>>  	blkcg = kzalloc(sizeof(*blkcg), GFP_KERNEL);
>> -- 
>> 1.6.3
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
