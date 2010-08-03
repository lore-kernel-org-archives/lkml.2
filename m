Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227Ab0HCTYs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 15:24:48 -0400
Received: from smtp-out.google.com ([74.125.121.35]:20347 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991Ab0HCTYq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 15:24:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=BKwwspP7Ks/a6pTKpSD5joUYuh36VjrKRG7qZFpQ2AQl20kJJmVW2JnsWRba72l2K
	DpVEEaq1DB0HcHy2VXz3w==
MIME-Version: 1.0
In-Reply-To: <4C582845.6070408@ds.jp.nec.com>
References: <4C369009.80503@ds.jp.nec.com> <20100802205834.GD24697@redhat.com> 
	<4C582845.6070408@ds.jp.nec.com>
From: Nauman Rafique <nauman@google.com>
Date: Tue, 3 Aug 2010 12:24:20 -0700
Message-ID: <AANLkTikrvWLxrbLavPqk4NkY4YieRW1q6QBv2_n7ASeS@mail.gmail.com>
Subject: Re: [RFC][PATCH 00/11] blkiocg async support
To: Munehiro Ikeda <m-ikeda@ds.jp.nec.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
        Ryo Tsuruta <ryov@valinux.co.jp>, taka@valinux.co.jp,
        kamezawa.hiroyu@jp.fujitsu.com, Andrea Righi <righi.andrea@gmail.com>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>, akpm@linux-foundation.org,
        balbir@linux.vnet.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 3, 2010 at 7:31 AM, Munehiro Ikeda <m-ikeda@ds.jp.nec.com> wrote:
> Vivek Goyal wrote, on 08/02/2010 04:58 PM:
>>
>> On Thu, Jul 08, 2010 at 10:57:13PM -0400, Munehiro Ikeda wrote:
>>>
>>> These RFC patches are trial to add async (cached) write support on blkio
>>> controller.
>>>
>>> Only test which has been done is to compile, boot, and that write
>>> bandwidth
>>> seems prioritized when pages which were dirtied by two different
>>> processes in
>>> different cgroups are written back to a device simultaneously.  I know
>>> this
>>> is the minimum (or less) test but I posted this as RFC because I would
>>> like
>>> to hear your opinions about the design direction in the early stage.
>>>
>>> Patches are for 2.6.35-rc4.
>>>
>>> This patch series consists of two chunks.
>>>
>>> (1) iotrack (patch 01/11 -- 06/11)
>>>
>>> This is a functionality to track who dirtied a page, in exact which
>>> cgroup a
>>> process which dirtied a page belongs to.  Blkio controller will read the
>>> info
>>> later and prioritize when the page is actually written to a block device.
>>> This work is originated from Ryo Tsuruta and Hirokazu Takahashi and
>>> includes
>>> Andrea Righi's idea.  It was posted as a part of dm-ioband which was one
>>> of
>>> proposals for IO controller.
>>>
>>>
>>> (2) blkio controller modification (07/11 -- 11/11)
>>>
>>> The main part of blkio controller async write support.
>>> Currently async queues are device-wide and async write IOs are always
>>> treated
>>> as root group.
>>> These patches make async queues per a cfq_group per a device to control
>>> them.
>>> Async write is handled by flush kernel thread.  Because queue pointers
>>> are
>>> stored in cfq_io_context, io_context of the thread has to have multiple
>>> cfq_io_contexts per a device.  So these patches make cfq_io_context per
>>> an
>>> io_context per a cfq_group, which means per an io_context per a cgroup
>>> per a
>>> device.
>>>
>>>
>>
>> Muuh,
>>
>> You will require one more piece and that is support for per cgroup request
>> descriptors on request queue. With writes, it is so easy to consume those
>> 128 request descriptors.
>
> Hi Vivek,
>
> Yes.  Thank you for the comment.
> I have two concerns to do that.
>
> (1) technical concern
> If there is fixed device-wide limitation and there are so many groups,
> the number of request descriptors distributed to each group can be too
> few.  My only idea for this is to make device-wide limitation flexible,
> but I'm not sure if it is the best or even can be allowed.
>
> (2) implementation concern
> Now the limitation is done by generic block layer which doesn't know
> about grouping.  The idea in my head to solve this is to add a new
> interface on elevator_ops to ask IO scheduler if a new request can
> be allocated.

Muuhh,
We have already done the work of forward porting the request
descriptor patch that Vivek had in his earlier patch sets. We also
taken care of the two concerns you have mentioned above. We have been
testing it, and getting good numbers. So if you want, I can send the
patch your way so it can be included in this same patch series.

Thanks.

>
> Anyway, simple RFC patch first and testing it would be preferable,
> I think.
>
>
> Thanks,
> Muuhh
>
>
> --
> IKEDA, Munehiro
>  NEC Corporation of America
>    m-ikeda@ds.jp.nec.com
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
