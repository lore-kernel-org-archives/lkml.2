Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723Ab1JXKC0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 06:02:26 -0400
Received: from brick.kernel.dk ([87.104.106.3]:51238 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754565Ab1JXKCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 06:02:25 -0400
Message-ID: <4EA537AA.3090804@kernel.dk>
Date: Mon, 24 Oct 2011 12:02:18 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 1/1] [virt] virtio-blk: Use ida to allocate disk index
References: <1306913069-23637-1-git-send-email-dwu@redhat.com> <87mxi1xfz0.fsf@rustcorp.com.au> <4DEF744D.9040702@redhat.com> <87mxhrgba6.fsf@rustcorp.com.au> <20110609091433.GB11773@htj.dyndns.org> <4DF0A374.6090504@redhat.com> <20111019101220.GE25794@redhat.com> <20111024100238.GA27444@redhat.com>
In-Reply-To: <20111024100238.GA27444@redhat.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-10-24 12:02, Michael S. Tsirkin wrote:
> On Wed, Oct 19, 2011 at 12:12:20PM +0200, Michael S. Tsirkin wrote:
>> On Thu, Jun 09, 2011 at 06:41:56AM -0400, Mark Wu wrote:
>>> On 06/09/2011 05:14 AM, Tejun Heo wrote:
>>>> Hello,
>>>>
>>>> On Thu, Jun 09, 2011 at 08:51:05AM +0930, Rusty Russell wrote:
>>>>> On Wed, 08 Jun 2011 09:08:29 -0400, Mark Wu <dwu@redhat.com> wrote:
>>>>>> Hi Rusty,
>>>>>> Yes, I can't figure out an instance of disk probing in parallel either, but as
>>>>>> per the following commit, I think we still need use lock for safety. What's your opinion?
>>>>>>
>>>>>> commit 4034cc68157bfa0b6622efe368488d3d3e20f4e6
>>>>>> Author: Tejun Heo <tj@kernel.org>
>>>>>> Date:   Sat Feb 21 11:04:45 2009 +0900
>>>>>>
>>>>>>     [SCSI] sd: revive sd_index_lock
>>>>>>
>>>>>>     Commit f27bac2761cab5a2e212dea602d22457a9aa6943 which converted sd to
>>>>>>     use ida instead of idr incorrectly removed sd_index_lock around id
>>>>>>     allocation and free.  idr/ida do have internal locks but they protect
>>>>>>     their free object lists not the allocation itself.  The caller is
>>>>>>     responsible for that.  This missing synchronization led to the same id
>>>>>>     being assigned to multiple devices leading to oops.
>>>>>
>>>>> I'm confused.  Tejun, Greg, anyone can probes happen in parallel?
>>>>>
>>>>> If so, I'll have to review all my drivers.
>>>>
>>>> Unless async is explicitly used, probe happens sequentially.  IOW, if
>>>> there's no async_schedule() call, things won't happen in parallel.
>>>> That said, I think it wouldn't be such a bad idea to protect ida with
>>>> spinlock regardless unless the probe code explicitly requires
>>>> serialization.
>>>>
>>>> Thanks.
>>>>
>>> Since virtio blk driver doesn't use async probe, it needn't use spinlock to protect ida.
>>> So remove the lock from patch.
>>>
>>> >From fbb396df9dbf8023f1b268be01b43529a3993d57 Mon Sep 17 00:00:00 2001
>>> From: Mark Wu <dwu@redhat.com>
>>> Date: Thu, 9 Jun 2011 06:34:07 -0400
>>> Subject: [PATCH 1/1] [virt] virtio-blk: Use ida to allocate disk index
>>>
>>> Current index allocation in virtio-blk is based on a monotonically
>>> increasing variable "index". It could cause some confusion about disk
>>> name in the case of hot-plugging disks. And it's impossible to find the
>>> lowest available index by just maintaining a simple index. So it's
>>> changed to use ida to allocate index via referring to the index
>>> allocation in scsi disk.
>>>
>>> Signed-off-by: Mark Wu <dwu@redhat.com>
>>
>> Acked-by: Michael S. Tsirkin <mst@redhat.com>
>>
>> This got lost in the noise and missed 3.1 which is unfortunate.
>> How about we apply this as is and look at cleanups as a next step?
> 
> Rusty, any opinion on merging this for 3.2?
> I expect merge window will open right after the summit,

I can toss it into for-3.2/drivers, if there's consensus to do that now.

-- 
Jens Axboe

