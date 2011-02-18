Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab1BRCqg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 21:46:36 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49641 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753249Ab1BRCqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 21:46:35 -0500
Message-ID: <4D5DDDD7.509@cn.fujitsu.com>
Date: Fri, 18 Feb 2011 10:47:51 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        =?UTF-8?B?57yqIOWLsA==?= <miaox@cn.fujitsu.com>, linux-mm@kvack.org
Subject: Re: [PATCH 3/4] cpuset: Fix unchecked calls to NODEMASK_ALLOC()
References: <4D5C7EA7.1030409@cn.fujitsu.com> <4D5C7ED1.2070601@cn.fujitsu.com> <20110217144643.0d60bef4.akpm@linux-foundation.org> <AANLkTin6TqQMHSpQjNXNrgGAHG8DL6CvzhTm3KHoxv0y@mail.gmail.com>
In-Reply-To: <AANLkTin6TqQMHSpQjNXNrgGAHG8DL6CvzhTm3KHoxv0y@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-18 10:45:32,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-18 10:45:34,
	Serialize complete at 2011-02-18 10:45:34
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Thu, Feb 17, 2011 at 2:46 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
>> On Thu, 17 Feb 2011 09:50:09 +0800
>> Li Zefan <lizf@cn.fujitsu.com> wrote:
>>
>>> +/*
>>> + * In functions that can't propogate errno to users, to avoid declaring a
>>> + * nodemask_t variable, and avoid using NODEMASK_ALLOC that can return
>>> + * -ENOMEM, we use this global cpuset_mems.
>>> + *
>>> + * It should be used with cgroup_lock held.
>>
>> I'll do s/should/must/ - that would be a nasty bug.
>>
>> I'd be more comfortable about the maintainability of this optimisation
>> if we had
>>
>>        WARN_ON(!cgroup_is_locked());
>>
>> at each site.
>>
> 
> Agreed - that was my first thought on reading the patch. How about:
> 
> static nodemask_t *cpuset_static_nodemask() {

Then this should be 'noinline', otherwise we'll have one copy for each
function that calls it.

>   static nodemask_t nodemask;
>   WARN_ON(!cgroup_is_locked());
>   return &nodemask;
> }
> 
> and then just call cpuset_static_nodemask() in the various locations
> being patched?
> 

I think a defect of this is people might call it twice in one function
but don't know it returns the same variable?

For example in cpuset_attach():

void cpuset_attach(...)
{
	nodemask_t *from = cpuset_static_nodemask();
	nodemask_t *to = cpuset_static_nodemask();
	...
}
