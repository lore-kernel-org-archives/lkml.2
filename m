Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759341Ab2JaRix (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 13:38:53 -0400
Received: from mx2.parallels.com ([64.131.90.16]:37292 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758945Ab2JaRiv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 13:38:51 -0400
Message-ID: <50916218.3090301@parallels.com>
Date: Wed, 31 Oct 2012 21:38:32 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Michal Hocko <mhocko@suse.cz>, <lizefan@huawei.com>, <hannes@cmpxchg.org>,
        <bsingharora@gmail.com>, <kamezawa.hiroyu@jp.fujitsu.com>,
        <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/8] cgroup: kill CSS_REMOVED
References: <1351657365-25055-1-git-send-email-tj@kernel.org> <1351657365-25055-3-git-send-email-tj@kernel.org> <20121031153926.GC22809@dhcp22.suse.cz> <20121031165739.GE2945@htj.dyndns.org> <50915A87.4070504@parallels.com> <CAOS58YP=CjTPFdETLRXnc3gXEzX2=EEe2dMdSh3Eov7zRfV4Qg@mail.gmail.com> <50915DB7.5020706@parallels.com> <20121031172522.GJ2945@htj.dyndns.org>
In-Reply-To: <20121031172522.GJ2945@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [46.39.244.6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2012 09:25 PM, Tejun Heo wrote:
> Hello,
> 
> On Wed, Oct 31, 2012 at 09:19:51PM +0400, Glauber Costa wrote:
>> I don't see post_create failing as a huge problem. The natural
>> synchronization point would be "right after post_create" - then you can
>> definitely tell that it is online. Although this can be viewed a bit as
>> "exposing internals", creating is different then destroying: When you
>> create, you may not have all data yet. When destroying, you do - and
>> want to get rid of it. So this kind of bootstrapping is pretty standard
>> and common.
> 
> More proper names for these callbacks would be,
> 
> 	->allocate()
> 	->online()
> 	->offline()
> 	->free()
> 
> And I may rename them.  I don't wanna make ->online() failable.  Why
> can't you just allocate everything from ->allocate() and use it from
> ->online()?
> 

Because I am allocating an array big enough to hold one entry per memcg.
The natural array index for this, is the css_id. Obviously, I don't want
this array to have 65k entries in size, so I resize it (doubling every
time) Because I don't know the css_id at this time, I have to do it later.

Another option for this - which I also considered - would be to use a
different index. We get more packing, since not all memcgs will be kmem
limited (and the index would contain only the kmem limited memcgs), and
we can allocate this index during ->create().

I initially picked the css_index because I though a specialized index
might be confusing. But if you feel strongly about all the allocations
happening inside ->create(), this would be a way to avoid it. Would you
prefer that?


