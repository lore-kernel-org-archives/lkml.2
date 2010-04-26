Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250Ab0DZBcG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 21:32:06 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65195 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753387Ab0DZBcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 21:32:04 -0400
Message-ID: <4BD4ED7A.5020205@cn.fujitsu.com>
Date: Mon, 26 Apr 2010 09:33:46 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Vivek Goyal <vgoyal@redhat.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH] blk-cgroup: Fix RCU correctness warning in cfq_init_queue()
References: <20100422155452.GD3228@redhat.com> <20100422231556.GW2524@linux.vnet.ibm.com> <20100422235555.GA12004@redhat.com> <20100423001751.GX2524@linux.vnet.ibm.com> <20100423144138.GA5026@redhat.com> <20100423194649.GF2589@linux.vnet.ibm.com>
In-Reply-To: <20100423194649.GF2589@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>>> With RCU correctness on, We see following warning. This patch fixes it.
>>>>> This is in initialization code, so that there cannot be any concurrent
>>>>> updates, correct?  If so, looks good.
>>>>>
>>>> I think theoritically two instances of cfq_init_queue() can be running
>>>> in parallel (for two different devices), and they both can call
>>>> blkiocg_add_blkio_group(). But then we use a spin lock to protect
>>>> blkio_cgroup.
>>>>
>>>> spin_lock_irqsave(&blkcg->lock, flags);
>>>>
>>>> So I guess two parallel updates should be fine.
>>> OK, in that case, would it be possible add this spinlock to the condition
>>> checked by css_id()'s rcu_dereference_check()?
>> Hi Paul,
>>
>> I think adding these spinlock to condition checked might become little
>> messy. And the reason being that this lock is subsystem (controller)
>> specific and maintained by controller. Now if any controller implements
>> a lock and we add that lock in css_id() rcu_dereference_check(), it will
>> look ugly.
>>
>> So probably a better way is to make sure that css_id() is always called
>> under rcu read lock so that we don't hit this warning?
> 
> As long as holding rcu_read_lock() prevents css_id() from the usual
> problems such as access memory that was concurrently freed, yes.
> 

blkiocg_add_blkio_group() also calls cgroup_path(), which also needs to
be called within rcu_read_lock, so I think Vivek's patch is better than
the one you posted in another mail thread.

