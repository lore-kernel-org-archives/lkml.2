Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab0G0Gkb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 02:40:31 -0400
Received: from smtp-out.google.com ([216.239.44.51]:58844 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab0G0Gka convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 02:40:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=VKg2GD7us66XoOIZCEbxud9DBIJIE5TVpLnFosxioUs+KjmLje4r5E2ba0dqXsndJ
	O9U2/K2Al0frR5xSCZfxQ==
MIME-Version: 1.0
In-Reply-To: <20100726064149.GP14369@balbir.in.ibm.com>
References: <4C369009.80503@ds.jp.nec.com> <20100726064149.GP14369@balbir.in.ibm.com>
From: Greg Thelen <gthelen@google.com>
Date: Mon, 26 Jul 2010 23:40:07 -0700
Message-ID: <AANLkTi=HrZoBL8MKJDOX-==iC5OcBJ4EmSG41BvO4Yqe@mail.gmail.com>
Subject: Re: [RFC][PATCH 00/11] blkiocg async support
To: balbir@linux.vnet.ibm.com
Cc: Munehiro Ikeda <m-ikeda@ds.jp.nec.com>, linux-kernel@vger.kernel.org,
        jens.axboe@oracle.com, Vivek Goyal <vgoyal@redhat.com>,
        Ryo Tsuruta <ryov@valinux.co.jp>, taka@valinux.co.jp,
        kamezawa.hiroyu@jp.fujitsu.com, Andrea Righi <righi.andrea@gmail.com>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 25, 2010 at 11:41 PM, Balbir Singh
<balbir@linux.vnet.ibm.com> wrote:
> * Munihiro Ikeda <m-ikeda@ds.jp.nec.com> [2010-07-08 22:57:13]:
>
>> These RFC patches are trial to add async (cached) write support on blkio
>> controller.
>>
>> Only test which has been done is to compile, boot, and that write bandwidth
>> seems prioritized when pages which were dirtied by two different processes in
>> different cgroups are written back to a device simultaneously.  I know this
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
>> process which dirtied a page belongs to.  Blkio controller will read the info
>> later and prioritize when the page is actually written to a block device.
>> This work is originated from Ryo Tsuruta and Hirokazu Takahashi and includes
>> Andrea Righi's idea.  It was posted as a part of dm-ioband which was one of
>> proposals for IO controller.
>>
>
> Does this reuse the memcg infrastructure, if so could you please add a
> summary of the changes here.
>
>>
>> (2) blkio controller modification (07/11 -- 11/11)
>>
>> The main part of blkio controller async write support.
>> Currently async queues are device-wide and async write IOs are always treated
>> as root group.
>> These patches make async queues per a cfq_group per a device to control them.
>> Async write is handled by flush kernel thread.  Because queue pointers are
>> stored in cfq_io_context, io_context of the thread has to have multiple
>> cfq_io_contexts per a device.  So these patches make cfq_io_context per an
>> io_context per a cfq_group, which means per an io_context per a cgroup per a
>> device.
>>
>>
>> This might be a piece of puzzle for complete async write support of blkio
>> controller.  One of other pieces in my head is page dirtying ratio control.
>> I believe Andrea Righi was working on it...how about the situation?
>>
>
> Greg posted the last set of patches, we are yet to see another
> iteration.

I am waiting to post the next iteration of memcg dirty limits and ratios until
Kame-san posts light-weight lockless update_stat().  I can post the dirty ratio
patches before the lockless updates are available, but I imagine there will be
a significant merge.  So I prefer to wait, assuming that thee changes will be
coming in the near future.

>> And also, I'm thinking that async write support is required by bandwidth
>> capping policy of blkio controller.  Bandwidth capping can be done in upper
>> layer than elevator.  However I think it should be also done in elevator layer
>> in my opinion.  Elevator buffers and sort requests.  If there is another
>> buffering functionality in upper layer, it is doubled buffering and it can be
>> harmful for elevator's prediction.
>>
>
>
> --
>        Three Cheers,
>        Balbir
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
