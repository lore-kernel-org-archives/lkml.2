Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812Ab1LMJDj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 04:03:39 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:16293 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497Ab1LMJDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 04:03:32 -0500
Message-ID: <4EE714BC.5040408@parallels.com>
Date: Tue, 13 Dec 2011 13:02:52 +0400
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Lightning/1.0b2 Thunderbird/3.1.15
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "mingo@elte.hu" <mingo@elte.hu>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        Pavel Emelianov <xemul@parallels.com>,
        "drosenberg@vsecurity.com" <drosenberg@vsecurity.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "eparis@redhat.com" <eparis@redhat.com>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        James Bottomley <jbottomley@parallels.com>,
        "devel@openvz.org" <devel@openvz.org>
Subject: Re: [PATCH 1/2] SYSCTL: root unregister routine introduced
References: <20111212174709.7084.54702.stgit@localhost6.localdomain6>	<20111212175000.7084.94219.stgit@localhost6.localdomain6> <20111212145208.75490b41.akpm@linux-foundation.org>
In-Reply-To: <20111212145208.75490b41.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

13.12.2011 02:52, Andrew Morton пишет:
> On Mon, 12 Dec 2011 21:50:00 +0300
> Stanislav Kinsbursky<skinsbursky@parallels.com>  wrote:
>
>> This routine is required for SUNRPC sysctl's, which are going to be allocated,
>> processed and destroyed per network namespace context.
>> IOW, new sysctl root will be registered on network namespace creation and
>> thus have to unregistered before network namespace destruction.
>>
>
> It's a bit suspicious that such a mature subsystem as sysctl newly
> needs its internals exported like this.  Either a) the net namespaces
> work is doing something which hasn't been done before or b) it is doing
> something wrong.
>
> So, please explain further so we can confirm that it is a) and not b).
>

Hello, Andrew.
The goal is to provide an ability to control and modify data by sysctl's in 
network namespace context. This is done by "net" sysctl's.
But there are two more issues to solve:
1) Sysctl's have to be in /proc/sys/sunrpc
2) Sysctl's content should be accessible from creator's network context (not 
current user ones's).

>> --- a/kernel/sysctl.c
>> +++ b/kernel/sysctl.c
>> @@ -1701,6 +1701,13 @@ void register_sysctl_root(struct ctl_table_root *root)
>>   	spin_unlock(&sysctl_lock);
>>   }
>>
>> +void unregister_sysctl_root(struct ctl_table_root *root)
>> +{
>> +	spin_lock(&sysctl_lock);
>> +	list_del(&root->root_list);
>> +	spin_unlock(&sysctl_lock);
>> +}
>> +
>
> This requires the addition of a declaration to include/linux/sysctl.h.
>
> Once that is done and review is complete, I'd suggest that these two
> patches be joined into a single patch, and that patch become part of
> whatever patch series it is which needs them.
>

Ok, I'll do so.

-- 
Best regards,
Stanislav Kinsbursky
