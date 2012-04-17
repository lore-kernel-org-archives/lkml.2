Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab2DQP3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 11:29:20 -0400
Received: from mx2.parallels.com ([64.131.90.16]:49376 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753996Ab2DQP3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 11:29:18 -0400
Message-ID: <4F8D8BE5.9020902@parallels.com>
Date: Tue, 17 Apr 2012 12:27:33 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Johannes Weiner <hannes@cmpxchg.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Walsh <dwalsh@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Li Zefan <lizefan@huawei.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: Cgroup in a single hierarchy (Was: Re: [RFD] Merge task counter
 into memcg)
References: <20120411185715.GA4317@somewhere.redhat.com> <4F862851.3040208@jp.fujitsu.com> <20120412113217.GB11455@somewhere.redhat.com> <4F86BFC6.2050400@parallels.com> <20120412123256.GI1787@cmpxchg.org> <4F86D4BD.1040305@parallels.com> <20120412153055.GL1787@cmpxchg.org> <20120412163825.GB13069@google.com> <4F870B18.5060703@parallels.com> <20120417151352.GA32402@google.com>
In-Reply-To: <20120417151352.GA32402@google.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [143.106.24.197]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2012 12:13 PM, Tejun Heo wrote:
> Pretty similar to the plan that I was thinking about.
>
> * Provide both mechanisms from the kernel while implementing new
>    features / optimizations with the assumption that there's one
>    hierarchy.
I believe the static_keys, that we are already using for the tcp
buffers can play a large role here. They can't save us from the 
complexity of still supporting multiple hierarchies in the mean time, 
but maybe nothing can.

the only problem with that, is that it is proving itself to be quite 
fragile. Because cpusets gets a bunch of function calls with the 
cgroup_mutex held from within the cpu hotplug notifier, this creates a 
lock dependency between the hotplug lock and cgroup mutex, meaning we
can't call any jump label function patching with the cgroup mutex held.

Neither we seem to be able to defer it to a worker, since it will create 
a window of opportunity in which the information presented is inconsistent.

Sigh...
