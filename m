Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758322Ab2HXQq3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 12:46:29 -0400
Received: from relay1.sgi.com ([192.48.179.29]:57415 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754643Ab2HXQq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 12:46:26 -0400
Message-ID: <5037AFB9.5010001@sgi.com>
Date: Fri, 24 Aug 2012 11:45:45 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <adobriyan@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] fs/proc: Move kfree outside pde_unload_lock
References: <1345653510-22000-1-git-send-email-nzimmer@sgi.com>  <1345660110.5158.1969.camel@edumazet-glaptop>  <1345671778.5158.2369.camel@edumazet-glaptop>  <20120824144852.GA18850@gulag1.americas.sgi.com> <1345820311.4824.2.camel@edumazet-laptop>
In-Reply-To: <1345820311.4824.2.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [128.162.233.129]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2012 09:58 AM, Eric Dumazet wrote:
> Le vendredi 24 août 2012 à 09:48 -0500, Nathan Zimmer a écrit :
>> On Wed, Aug 22, 2012 at 11:42:58PM +0200, Eric Dumazet wrote:
>>> On Wed, 2012-08-22 at 20:28 +0200, Eric Dumazet wrote:
>>>
>>>> Thats interesting, but if you really want this to fly, one RCU
>>>> conversion would be much better ;)
>>>>
>>>> pde_users would be an atomic_t and you would avoid the spinlock
>>>> contention.
>>> Here is what I had in mind, I would be interested to know how it helps a 512 core machine ;)
>>>
>> Here are the results and they look great.
>>
>> cpuinfo	baseline	moved kfree	Rcu
>> tasks	read-sec	read-sec	read-sec
>> 1	0.0141		0.0141		0.0141
>> 2	0.0140		0.0140		0.0142
>> 4	0.0140		0.0141		0.0141
>> 8	0.0145		0.0145		0.0140
>> 16	0.0553		0.0548		0.0168
>> 32	0.1688		0.1622		0.0549
>> 64	0.5017		0.3856		0.1690
>> 128	1.7005		0.9710		0.5038
>> 256	5.2513		2.6519		2.0804
>> 512	8.0529		6.2976		3.0162
>>
>>
>>
> Indeed...
>
> Could you explicit the test you are actually doing ?
>
> Thanks
>
>


It is a dead simple test.
The test starts by forking off X number of tasks
assigning each their own cpu.
Each task then allocs a bit of memory.
All tasks wait on a memory cell for the go order.
We measure the read time starting here.
Once the go order is given they all read a chunk of the selected proc file.
I was using /proc/cpuinfo to test.
Once everyone has finished we take the end read time.




