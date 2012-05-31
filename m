Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab2EaAfO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 20:35:14 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36843 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056Ab2EaAfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 20:35:12 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FC6BC3E.5010807@jp.fujitsu.com>
Date: Thu, 31 May 2012 09:33:02 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
CC: David Rientjes <rientjes@google.com>, Gao feng <gaofeng@cn.fujitsu.com>,
        hannes@cmpxchg.org, mhocko@suse.cz, bsingharora@gmail.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        containers@lists.linux-foundation.org
Subject: Re: [PATCH] meminfo: show /proc/meminfo base on container's memcg
References: <1338260214-21919-1-git-send-email-gaofeng@cn.fujitsu.com> <alpine.DEB.2.00.1205301433490.9716@chino.kir.corp.google.com> <4FC6B68C.2070703@jp.fujitsu.com> <CAHGf_=pFbsy4FO_UNu6O1-KyTd6O=pkmR8=3EGuZB5Reu3Vb9w@mail.gmail.com>
In-Reply-To: <CAHGf_=pFbsy4FO_UNu6O1-KyTd6O=pkmR8=3EGuZB5Reu3Vb9w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/05/31 9:22), KOSAKI Motohiro wrote:
> On Wed, May 30, 2012 at 8:08 PM, Kamezawa Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com>  wrote:
>> (2012/05/31 6:38), David Rientjes wrote:
>>>
>>> On Tue, 29 May 2012, Gao feng wrote:
>>>
>>>> cgroup and namespaces are used for creating containers but some of
>>>> information is not isolated/virtualized. This patch is for isolating
>>>> /proc/meminfo
>>>> information per container, which uses memory cgroup. By this, top,free
>>>> and other tools under container can work as expected(show container's
>>>> usage) without changes.
>>>>
>>>> This patch is a trial to show memcg's info in /proc/meminfo if 'current'
>>>> is under a memcg other than root.
>>>>
>>>> we show /proc/meminfo base on container's memory cgroup.
>>>> because there are lots of info can't be provide by memcg, and
>>>> the cmds such as top, free just use some entries of /proc/meminfo,
>>>> we replace those entries by memory cgroup.
>>>>
>>>> if container has no memcg, we will show host's /proc/meminfo
>>>> as before.
>>>>
>>>> there is no idea how to deal with Buffers,I just set it zero,
>>>> It's strange if Buffers bigger than MemTotal.
>>>>
>>>> Signed-off-by: Gao feng<gaofeng@cn.fujitsu.com>
>>>
>>>
>>> Nack, this type of thing was initially tried with cpusets when a thread
>>> was bound to a subset of nodes, i.e. only show the total amount of memory
>>> spanned by those nodes.
>>>
>>
>> Hmm. How about having memory.meminfo under memory cgroup directory and
>> use it with bind mount ? (container tools will be able to help it.)
>> Then, container applications(top,free,etc..) can read the values they wants.
>> If admins don't want it, they'll not use bind mount.
>
> +1. 50% users need namespace separation and others don't. We need a
> selectability.

My test with sysfs node's meminfo seems to work...

[root@rx100-1 qqm]# mount --bind /sys/devices/system/node/node0/meminfo /proc/meminfo
[root@rx100-1 qqm]# cat /proc/meminfo

Node 0 MemTotal:        8379636 kB
Node 0 MemFree:         4050224 kB
Node 0 MemUsed:         4329412 kB
Node 0 Active:          3010876 kB
Node 0 Inactive:         507480 kB
Node 0 Active(anon):    2671920 kB
Node 0 Inactive(anon):   111596 kB
Node 0 Active(file):     338956 kB
Node 0 Inactive(file):   395884 kB
Node 0 Unevictable:       48316 kB
Node 0 Mlocked:           11524 kB
Node 0 Dirty:                 8 kB
Node 0 Writeback:             0 kB
Node 0 FilePages:        744908 kB
Node 0 Mapped:            20604 kB
Node 0 AnonPages:       1344940 kB
Node 0 Shmem:              1448 kB
Node 0 KernelStack:        3528 kB
Node 0 PageTables:        53840 kB
Node 0 NFS_Unstable:          0 kB
Node 0 Bounce:                0 kB
Node 0 WritebackTmp:          0 kB
Node 0 Slab:             184404 kB
Node 0 SReclaimable:     131060 kB
Node 0 SUnreclaim:        53344 kB
Node 0 HugePages_Total:     0
Node 0 HugePages_Free:      0
Node 0 HugePages_Surp:      0

Thanks,
-Kame

