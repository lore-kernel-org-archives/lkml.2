Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041Ab0EQD7z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 23:59:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64427 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752877Ab0EQD7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 23:59:54 -0400
Message-ID: <4BF0BF8E.5050407@cn.fujitsu.com>
Date: Mon, 17 May 2010 12:01:18 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Rientjes <rientjes@google.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Paul Menage <menage@google.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH -mm] cpuset,mm: fix no node to alloc memory when changing
 cpuset's mems - fix2
References: <4BEA56D3.6040705@cn.fujitsu.com>	<20100512003246.9f0ee03c.akpm@linux-foundation.org>	<4BEA6E3D.10503@cn.fujitsu.com>	<20100512104817.beeee3b5.akpm@linux-foundation.org>	<4BEB9941.7040609@cn.fujitsu.com> <20100513121123.e105ac97.akpm@linux-foundation.org>
In-Reply-To: <20100513121123.e105ac97.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 2010-5-14 3:11, Andrew Morton wrote:
> On Thu, 13 May 2010 14:16:33 +0800
> Miao Xie <miaox@cn.fujitsu.com> wrote:
> 
>>>
>>> The code you have at present is fairly similar to sequence locks.  I
>>> wonder if there's some way of (ab)using sequence locks for this. 
>>> seqlocks don't have lockdep support either...
>>>
>>
>> We can't use sequence locks here, because the read-side may read the data
>> in changing, but it can't put off cleaning the old bits.
> 
> I don't understand that sentence.  Can you expand on it please?
> 

the mempolicy and mems_allowed tell the task that it should allocates the memory
space on the specified node. so when allocating the memory space, the memory
allocation functions that the task invokes must accesses the mempolicy and
mems_allowed to find a node on which it can do memory allocation.

But those memory allocation functions can be used in both the context that the
task can sleep and the context that the task can't sleep(etc. disable irq). so
the real lock is not suitable.

And it is not a problem that the task allocates the memory space on the old
allowed node when the mempolicy and mems_allowed is in changing, because the
mempolicy and mems_allowed is not mandatory. So I think we needn't use a real
lock to protect the mempolicy and mems_allowed in the read-side, and just use a
real lock in the write-side. But there is a serious problem, that is the read
-side may find no node to allocate memory and oom occurs, just like the
following case(mentioned in the patch's changelog):
(mpol: mempolicy)
	task1			task1's mpol	task2
	alloc page		1
	  alloc on node0? NO	1
				1		change mems from 1 to 0
				0		rebind task1's mpol
	  alloc on node1? NO	0
	  ...
	can't alloc page
	  goto oom

In order to fix this problem, I got an idea that we set the newly allowed nodes
first, and then clean the disallowed nodes, But there is still a problem.
(mpol: mempolicy)
	task1			task1's mpol	task2
	alloc page		1
	  alloc on node0? NO	1
				1		change mems from 1 to 0
				1		rebind task1's mpol
				0-1		  set new bits
				0	  	  clear disallowed bits
	  alloc on node1? NO	0
	  ...
	can't alloc page
	  goto oom
	  
It is because we cleanup disallowed nodes early, so I use a variable to tell the
write-side that the task is accessing the mempolicy and mems_allowed now, the
write-side must cleanup disallowed nodes soon after.

And the seq read lock can't provide this function. And besides that, the read-side
will goto oom and not go back if it find no node to allcate memory, so it won't
check the seq number of lock to find whether the mempolicy and mems_allowed have
been changed. so the seq lock is also not suitable, I think.

Thanks
Miao

