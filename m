Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab2IQH7d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 03:59:33 -0400
Received: from hotel311.server4you.de ([85.25.146.15]:38261 "EHLO
	hotel311.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516Ab2IQH7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 03:59:32 -0400
Message-ID: <5056D861.7010404@monom.org>
Date: Mon, 17 Sep 2012 09:59:29 +0200
From: Daniel Wagner <wagi@monom.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Glauber Costa <glommer@parallels.com>
CC: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Michal Hocko <mhocko@suse.cz>, Li Zefan <lizf@cn.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Thomas Graf <tgraf@suug.ch>,
        "Serge E. Hallyn" <serue@us.ibm.com>, Vivek Goyal <vgoyal@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Dave Jones <davej@redhat.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH RFC cgroup/for-3.7] cgroup: mark subsystems with broken
 hierarchy support and whine if cgroups are nested for them
References: <20120910223125.GC7677@google.com> <505055E5.90903@parallels.com> <20120912170357.GN7677@google.com> <5051C954.2080600@parallels.com> <20120913174817.GA7677@google.com> <5052E9BC.2020908@parallels.com>
In-Reply-To: <5052E9BC.2020908@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.09.2012 10:24, Glauber Costa wrote:
> On 09/13/2012 09:48 PM, Tejun Heo wrote:
>> Hello, Glauber.
>>
>> On Thu, Sep 13, 2012 at 03:53:56PM +0400, Glauber Costa wrote:
>>> Here is where the Kconfig option comes to play. If we do it in the
>>> kernel, userspace doesn't have to do anything. I spoke with Lennart and
>>> Kay, and at least from a systemd PoV, they would much rather not provide
>>> a hack in userspace for a file that is scheduled to go away in any case
>>> - which I personally believe is a fair request.
>>>
>>> It is a default, so the effect for the user is the same: After the
>>> machine boots, use_hierarchy = 1, and he can still flip to 0 for some time.
>>
>> Alright, let's go Kconfig.  Let's just make sure that the transitional
>> nature is clearly labeled and the fact that the default config will
>> generate a warning when nested cgroups are created in memcg.  We can
>> then coordinate the flip with distros.  Can you please repost the
>> Kconfig patch?
>>
>
> Just wait a bit. If you are merging your earlier patch, I'd like to take
> that in consideration. In that case, I'd rebase.
>
>>>> Setting mark on a parent should be reflected on all its children w/o
>>>> their own explicit settings.
>>>
>>> That is clear, and better behavior than we have today. What I mean, is
>>> that by setting its own marking, the child can pretty much "escape" the
>>> group.

To escape net_prio the process needs CAP_NET_ADMIN to overwrite 
SO_PRIORITY. net_cls has already its own marking.

>>> The ideal solution - from this point of view only - would be to have
>>> more than one marking, and mark with all the way down to the root. So if
>>> you have an iptables rule to match one marking, it still applies to the
>>> kids. And you can still have extra markings.

I think what you are describing is something like a generic socket 
marker which and a cgroup matcher for iptables, no? What about SO_MARK. 
As noted above it would be nice if the processes could not escape with 
setting SO_MARK (it also need SO_NET_ADMIN).

>>> I am not sure this is feasible, though, in which case your solution
>>> could be a good compromise. But please let's aim for it.
>>
>> I don't think it supports multiple tags.  If that's possible, it would
>> be nice but I don't think it's a must.
>>
>
> It is not about "it supports", but more about "can it support?"
> But I honestly can't answer this question. net_cls people need to
> come and tell us about it.

I struggle to understand for what the multiple tags are good for. Any 
examples?

Another question on hierarchies on the networking controllers: Are there 
any real dependencies between a cgroup and its children. For resources 
like CPU cycles or memory it makes perfectly sense.

I don't see a *direct* relation ship between the parent cgroup and it's 
children for the networking controllers. There seems to be some sort of 
relation ship for SO_PRIORITY. As the current net_prio implementation 
does not allow hierarchies it avoids to answer this question.

net_cls allows hierarchies but has no restriction on setting the classid 
for TC. The traffic shaping happens completely independent of the cgroup 
hierarchies and there is no relation ship at all.

Do we need any sort of formal definition for hierarchal dependencies for 
the networking controlllers?


