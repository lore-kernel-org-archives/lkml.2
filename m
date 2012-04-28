Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966Ab2D1AB0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 20:01:26 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:37103 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757417Ab2D1ABY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 20:01:24 -0400
MIME-Version: 1.0
In-Reply-To: <CALWz4ixHGCqfWh1U+JyiJWTkGmCDtXQy1vbHRjrHaU_pOgGuBw@mail.gmail.com>
References: <4F9A327A.6050409@jp.fujitsu.com>
	<4F9A359C.10107@jp.fujitsu.com>
	<CALWz4ixHGCqfWh1U+JyiJWTkGmCDtXQy1vbHRjrHaU_pOgGuBw@mail.gmail.com>
Date: Sat, 28 Apr 2012 09:01:23 +0900
Message-ID: <CABEgKgpCyWhe1KMgcF7ob0myzcCypNbw5SebhVpSX_Xaz7yOBw@mail.gmail.com>
Subject: Re: [RFC][PATCH 5/9 v2] move charges to root at rmdir if
 use_hierarchy is unset
From: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
To: Ying Han <yinghan@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Glauber Costa <glommer@parallels.com>, Tejun Heo <tj@kernel.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2012 at 4:12 AM, Ying Han <yinghan@google.com> wrote:
> On Thu, Apr 26, 2012 at 10:58 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> Now, at removal of cgroup, ->pre_destroy() is called and move charges
>> to the parent cgroup. A major reason of -EBUSY returned by ->pre_destroy()
>> is that the 'moving' hits parent's resource limitation. It happens only
>> when use_hierarchy=0. This was a mistake of original design.(it's me...)
>
> Nice patch, i can see how broken it is now with use_hierarchy=0...
>
> nitpick on the documentation below:
>
>>
>> Considering use_hierarchy=0, all cgroups are treated as flat. So, no one
>> cannot justify moving charges to parent...parent and children are in
>> flat configuration, not hierarchical.
>>
>> This patch modifes to move charges to root cgroup at rmdir/force_empty
>> if use_hierarchy==0. This will much simplify rmdir() and reduce error
>> in ->pre_destroy.
>>
>> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> ---
>>  Documentation/cgroups/memory.txt |   12 ++++++----
>>  mm/memcontrol.c                  |   39 +++++++++++++------------------------
>>  2 files changed, 21 insertions(+), 30 deletions(-)
>>
>> diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
>> index 54c338d..82ce1ef 100644
>> --- a/Documentation/cgroups/memory.txt
>> +++ b/Documentation/cgroups/memory.txt
>> @@ -393,14 +393,14 @@ cgroup might have some charge associated with it, even though all
>>  tasks have migrated away from it. (because we charge against pages, not
>>  against tasks.)
>>
>> -Such charges are freed or moved to their parent. At moving, both of RSS
>> -and CACHES are moved to parent.
>> -rmdir() may return -EBUSY if freeing/moving fails. See 5.1 also.
>> +Such charges are freed or moved to their parent if use_hierarchy=1.
>> +if use_hierarchy=0, the charges will be moved to root cgroup.
>
> It is more clear that we move the stats to root (if use_hierarchy==0)
> or parent (if use_hierarchy==1), and no change on the charge except
> uncharging from the child.
>

Seems nicer. I'll use your text in next ver.

Thanks,
-Kame
