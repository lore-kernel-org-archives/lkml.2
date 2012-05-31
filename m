Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965Ab2EaFii (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 01:38:38 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33640 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab2EaFig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 01:38:36 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FC70355.70805@jp.fujitsu.com>
Date: Thu, 31 May 2012 14:36:21 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Gao feng <gaofeng@cn.fujitsu.com>, hannes@cmpxchg.org, mhocko@suse.cz,
        bsingharora@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.linux-foundation.org
Subject: Re: [PATCH] meminfo: show /proc/meminfo base on container's memcg
References: <1338260214-21919-1-git-send-email-gaofeng@cn.fujitsu.com> <alpine.DEB.2.00.1205301433490.9716@chino.kir.corp.google.com> <4FC6B68C.2070703@jp.fujitsu.com> <CAHGf_=pFbsy4FO_UNu6O1-KyTd6O=pkmR8=3EGuZB5Reu3Vb9w@mail.gmail.com> <4FC6BC3E.5010807@jp.fujitsu.com> <alpine.DEB.2.00.1205301737530.25774@chino.kir.corp.google.com> <4FC6C111.2060108@jp.fujitsu.com> <alpine.DEB.2.00.1205301831270.25774@chino.kir.corp.google.com> <4FC6D881.4090706@jp.fujitsu.com> <alpine.DEB.2.00.1205302156090.25774@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1205302156090.25774@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/05/31 14:02), David Rientjes wrote:
> On Thu, 31 May 2012, Kamezawa Hiroyuki wrote:
>
>>> It's not just a memcg issue, it would also be a cpusets issue.
>>
>> I think you can add cpuset.meminfo.
>>
>
> It's simple to find the same information by reading the per-node meminfo
> files in sysfs for each of the allowed cpuset mems.  This is why this
> approach has been nacked in the past, specifically by Paul Jackson when he
> implemented cpusets.
>

I don't think there was a discussion of LXC in that era.

> The bottomline is that /proc/meminfo is one of many global resource state
> interfaces and doesn't imply that every thread has access to the full
> resources.  It never has.  It's very simple for another thread to consume
> a large amount of memory as soon as your read() of /proc/meminfo completes
> and then that information is completely bogus.

Why you need to discuss this here ? We know all information are snapshot.

> We also don't want to
> virtualize every single global resource state interface, it would be never
> ending.
>
Just doing one by one. It will end.

> Applications that administer memory cgroups or cpusets can get this
> information very easily, each application within those memory cgroups or
> cpusets does not need it and should not rely on it: it provides no
> guarantee about future usage nor notifies the application when the amount
> of free memory changes.

If so, the admin should have know-how to get the information from the inside
of the container. If container is well-isolated, he'll need some
trick to get its own cgroup information from the inside of containers.

Hmm....maybe need to mount cgroup in the container (again) and get an access to cgroup
hierarchy and find the cgroup it belongs to......if it's allowed. I don't want to allow
it and disable it with capability or some other check. Another idea is to exchange
information by some network connection with daemon in root cgroup, like qemu-ga.
And free, top, ....misc applications should support it. It doesn't seem easy.

It may be better to think of supporting yet another FUSE procfs, which will work
with libvirt in userland if having it in the kernel is complicated.

Thanks,
-Kame

