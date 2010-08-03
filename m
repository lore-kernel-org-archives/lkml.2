Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853Ab0HCOfh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 10:35:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756092Ab0HCOff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 10:35:35 -0400
Message-ID: <4C582845.6070408@ds.jp.nec.com>
Date: Tue, 03 Aug 2010 10:31:33 -0400
From: Munehiro Ikeda <m-ikeda@ds.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, Ryo Tsuruta <ryov@valinux.co.jp>,
        taka@valinux.co.jp, kamezawa.hiroyu@jp.fujitsu.com,
        Andrea Righi <righi.andrea@gmail.com>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>, akpm@linux-foundation.org,
        balbir@linux.vnet.ibm.com
Subject: Re: [RFC][PATCH 00/11] blkiocg async support
References: <4C369009.80503@ds.jp.nec.com> <20100802205834.GD24697@redhat.com>
In-Reply-To: <20100802205834.GD24697@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote, on 08/02/2010 04:58 PM:
> On Thu, Jul 08, 2010 at 10:57:13PM -0400, Munehiro Ikeda wrote:
>> These RFC patches are trial to add async (cached) write support on blkio
>> controller.
>>
>> Only test which has been done is to compile, boot, and that write bandwidth
>> seems prioritized when pages which were dirtied by two different processes in
>> different cgroups are written back to a device simultaneously.  I know this
>> is the minimum (or less) test but I posted this as RFC because I would like
>> to hear your opinions about the design direction in the early stage.
>>
>> Patches are for 2.6.35-rc4.
>>
>> This patch series consists of two chunks.
>>
>> (1) iotrack (patch 01/11 -- 06/11)
>>
>> This is a functionality to track who dirtied a page, in exact which cgroup a
>> process which dirtied a page belongs to.  Blkio controller will read the info
>> later and prioritize when the page is actually written to a block device.
>> This work is originated from Ryo Tsuruta and Hirokazu Takahashi and includes
>> Andrea Righi's idea.  It was posted as a part of dm-ioband which was one of
>> proposals for IO controller.
>>
>>
>> (2) blkio controller modification (07/11 -- 11/11)
>>
>> The main part of blkio controller async write support.
>> Currently async queues are device-wide and async write IOs are always treated
>> as root group.
>> These patches make async queues per a cfq_group per a device to control them.
>> Async write is handled by flush kernel thread.  Because queue pointers are
>> stored in cfq_io_context, io_context of the thread has to have multiple
>> cfq_io_contexts per a device.  So these patches make cfq_io_context per an
>> io_context per a cfq_group, which means per an io_context per a cgroup per a
>> device.
>>
>>
>
> Muuh,
>
> You will require one more piece and that is support for per cgroup request
> descriptors on request queue. With writes, it is so easy to consume those
> 128 request descriptors.

Hi Vivek,

Yes.  Thank you for the comment.
I have two concerns to do that.

(1) technical concern
If there is fixed device-wide limitation and there are so many groups,
the number of request descriptors distributed to each group can be too
few.  My only idea for this is to make device-wide limitation flexible,
but I'm not sure if it is the best or even can be allowed.

(2) implementation concern
Now the limitation is done by generic block layer which doesn't know
about grouping.  The idea in my head to solve this is to add a new
interface on elevator_ops to ask IO scheduler if a new request can
be allocated.

Anyway, simple RFC patch first and testing it would be preferable,
I think.


Thanks,
Muuhh


-- 
IKEDA, Munehiro
   NEC Corporation of America
     m-ikeda@ds.jp.nec.com

