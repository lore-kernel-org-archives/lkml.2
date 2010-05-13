Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab0EMGPO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 02:15:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49810 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753006Ab0EMGPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 02:15:12 -0400
Message-ID: <4BEB9941.7040609@cn.fujitsu.com>
Date: Thu, 13 May 2010 14:16:33 +0800
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
References: <4BEA56D3.6040705@cn.fujitsu.com>	<20100512003246.9f0ee03c.akpm@linux-foundation.org>	<4BEA6E3D.10503@cn.fujitsu.com> <20100512104817.beeee3b5.akpm@linux-foundation.org>
In-Reply-To: <20100512104817.beeee3b5.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 2010-5-13 1:48, Andrew Morton wrote:
>> It may cause the performance regression, so I do my best to abstain from using a real
>> lock.
> 
> Well, the code as-is is pretty exotic with lots of open-coded tricky
> barriers - it's best to avoid inventing new primitives if possible. 
> For example, there's no lockdep support for this new "lock".

I didn't find an existing lock that could fix the problem well till now, so
I had to design this new "lock" to protect the task's mempolicy and mems_allowed.

> 
> mutex_lock() is pretty quick - basically a simgle atomic op.  How
> frequently do these operations occur?

There is another problem that I forgot to mention.
besides the performance problem, the read-side may call it in the context
in which the task can't sleep. so we can't use mutex.

> 
> The code you have at present is fairly similar to sequence locks.  I
> wonder if there's some way of (ab)using sequence locks for this. 
> seqlocks don't have lockdep support either...
> 

We can't use sequence locks here, because the read-side may read the data
in changing, but it can't put off cleaning the old bits.

Thanks
Miao

