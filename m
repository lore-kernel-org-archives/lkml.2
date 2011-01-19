Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254Ab1ASBUA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 20:20:00 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56309 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751903Ab1ASBT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 20:19:59 -0500
Message-ID: <4D363C54.90403@cn.fujitsu.com>
Date: Wed, 19 Jan 2011 09:20:20 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Jens Axboe <axboe@kernel.dk>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        Chad Talbott <ctalbott@google.com>, Nauman Rafique <nauman@google.com>,
        Divyesh Shah <dpshah@google.com>, jmoyer@redhat.com,
        Shaohua Li <shaohua.li@intel.com>
Subject: Re: [PATCH 6/6 v3] blkio-cgroup: Document for blkio.use_hierarchy
 interface
References: <4D180ECE.4000305@cn.fujitsu.com> <4D185388.4080104@cn.fujitsu.com> <20110118202720.GJ27946@redhat.com>
In-Reply-To: <20110118202720.GJ27946@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-19 09:19:26,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-19 09:19:26,
	Serialize complete at 2011-01-19 09:19:26
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Mon, Dec 27, 2010 at 04:51:20PM +0800, Gui Jianfeng wrote:
>> Document for blkio.use_hierarchy interface
>>
>> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
>> ---
>>  Documentation/cgroups/blkio-controller.txt |   70 ++++++++++++++++++++--------
>>  1 files changed, 51 insertions(+), 19 deletions(-)
>>
>> diff --git a/Documentation/cgroups/blkio-controller.txt b/Documentation/cgroups/blkio-controller.txt
>> index 4ed7b5c..bd01d6c 100644
>> --- a/Documentation/cgroups/blkio-controller.txt
>> +++ b/Documentation/cgroups/blkio-controller.txt
>> @@ -91,30 +91,51 @@ Throttling/Upper Limit policy
>>  
>>  Hierarchical Cgroups
>>  ====================
>> -- Currently none of the IO control policy supports hierarhical groups. But
>> -  cgroup interface does allow creation of hierarhical cgroups and internally
>> -  IO policies treat them as flat hierarchy.
>> +- Cgroup interface allows creation of hierarchical cgroups. Currently,
>> +  internally IO policies are able to treat them as flat hierarchy or
>> +  hierarchical hierarchy.
> 
> Gui, now we have 2 IO policies. Throttling policy still supports only flat
> mode. Can you please make it clear here that CFQ will support both flat
> and hierarhical mode while throttling supports only flat mode as of today.
> 
>> Both hierarchical bandwidth division and flat
>> +  bandwidth division are supported. "blkio.use_hierarchy" can be used to
>> +  switch between flat mode and hierarchical mode.
>>  
>> -  So this patch will allow creation of cgroup hierarhcy but at the backend
>> -  everything will be treated as flat. So if somebody created a hierarchy like
>> -  as follows.
>> +  Consider the following CGroup hierarchy:
>>  
>> -			root
>> -			/  \
>> -		     test1 test2
>> -			|
>> -		     test3
>> +			  Root
>> +			/  |   \
>> +		     Grp1  Grp2 tsk1
>> +	            /  \
>> +		 Grp3 tsk2
>>  
>> -  CFQ and throttling will practically treat all groups at same level.
>> +  If blkio.use_hierarchy is disabled in all CGroups, CFQ will practically treat all groups
>> +  at the same level.
>>  
>> -				pivot
>> -			     /  |   \  \
>> -			root  test1 test2  test3
>> +			     Pivot tree
>> +			    /  |   |   \
>> +			Root Grp1 Grp2 Grp3
>> +			 /     |
>> +			tsk1  tsk2
>>  
>> -  Down the line we can implement hierarchical accounting/control support
>> -  and also introduce a new cgroup file "use_hierarchy" which will control
>> -  whether cgroup hierarchy is viewed as flat or hierarchical by the policy..
>> -  This is how memory controller also has implemented the things.
>> +  If blkio.use_hierarchy is enabled in Grp1 and Grp3, CFQ will treat groups and tasks as the
> 
> I would think that before this example, we can give one simpler example
> where use_hierarhcy=1 in root cgroup and that would/should lead to all
> children group under root having use_hierarchy=1 set automatically and
> will look as follows.
> 
> 		     	Pivot tree
> 			    |
> 		           root
> 			 /  |  | 
> 	             tsk1   G1 G2 
> 			   / \
> 			 grp3 tsk2
> 
> After this now you can give more complicated example as below where
> use_hierarchy=1 is only set for sub branch of tree and not the whole
> tree.

Sure.

> 
>> +  same view in CGroup hierarchy, it looks as follows.
>> +
>> +
>> +			     Pivot tree
>> +			    /    |    \
>> +			  Root  Grp1  Grp2
>> +			  /     /  \
>> +		       tsk1   Grp3 tsk2
>> +
>> +  Root, Grp1 and Grp2 are treated at the same level under Pivot tree. tsk1 stays under Root.
>> +  Grp3 and tsk2 are treated at the same level under Grp1. Below is the mapping between
>> +  task io priority and io weight:
>> +
>> +	    prio       0    1     2    3    4    5    6     7
>> +	    weight  1000  868   740  612  484  356  228   100
>> +
>> +  Note1: Regardless of the use_hierarchy setting in Root group, Root group is always put onto
>> +  Pivot tree.
>> +
>> +  Note2: Currently, "blkio.use_hierarchy" only effects proportional bandwidth division. For
>> +  Throttling logic, it still continue to treat everything as flat.
>>  
> 
> Ok, I see you mentioned throttling flat mode here. I guess it is better
> to clarify it in the beginning itself.

Ok

Thanks,
Gui

> 
>>  Various user visible config options
>>  ===================================
>> @@ -169,6 +190,17 @@ Proportional weight policy files
>>  	  dev     weight
>>  	  8:16    300
>>  
>> +- blkio.use_hierarchy
>> +	- Switch between hierarchical mode and flat mode as stated above.
>> +	  blkio.use_hierarchy == 1 means hierarchical mode is enabled.
>> +	  blkio.use_hierarchy == 0 means flat mode is enabled.
>> +	  You can set this interface only if there isn't any child CGroup under
>> +	  this CGroup. If one CGroup's blkio.use_hierarchy is set, the created
>> +	  children will inherit it. it's not allowed to unset it in children.
>> +	  The default mode in Root CGroup is flat.
>> +	  blkio.use_hierarchy only works for proportional bandwidth division
>> +	  as of today and doesn't have any effect on throttling logic.
>> +
> 
> This is good. Makes use_hierarchy behavior for children and subtree very
> clear.
> 
>>  - blkio.time
>>  	- disk time allocated to cgroup per device in milliseconds. First
>>  	  two fields specify the major and minor number of the device and
>> -- 
>> 1.6.5.2
>>
>>
>>
>>
>>
>>
> 
