Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab1FHNI1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 09:08:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21020 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753115Ab1FHNI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 09:08:26 -0400
Message-ID: <4DEF744D.9040702@redhat.com>
Date: Wed, 08 Jun 2011 09:08:29 -0400
From: Mark Wu <dwu@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        tj@kernel.org
Subject: Re: [PATCH 1/1] [virt] virtio-blk: Use ida to allocate disk index
References: <1306913069-23637-1-git-send-email-dwu@redhat.com> <87mxi1xfz0.fsf@rustcorp.com.au>
In-Reply-To: <87mxi1xfz0.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2011 07:57 PM, Rusty Russell wrote:
> On Wed,  1 Jun 2011 03:24:29 -0400, Mark Wu <dwu@redhat.com> wrote:
>> Current index allocation in virtio-blk is based on a monotonically
>>  increasing variable "index". It could cause some confusion about 
>> disk name in the case of hot-plugging disks. And it's impossible
>> to find the lowest available index by just maintaining a simple
>> index. So it's changed to use ida to allocate index via referring
>> to the index allocation in scsi disk.
>> 
>> Signed-off-by: Mark Wu <dwu@redhat.com>
> 
> Hi Mark,
> 
> I don't believe that we do disk probes in parallel, so the spinlock 
> is unnecessary.  Otherwise, this looks good.
> 
> Thanks, Rusty.
Hi Rusty,
Yes, I can't figure out an instance of disk probing in parallel either, but as
per the following commit, I think we still need use lock for safety. What's your opinion?

commit 4034cc68157bfa0b6622efe368488d3d3e20f4e6
Author: Tejun Heo <tj@kernel.org>
Date:   Sat Feb 21 11:04:45 2009 +0900

    [SCSI] sd: revive sd_index_lock

    Commit f27bac2761cab5a2e212dea602d22457a9aa6943 which converted sd to
    use ida instead of idr incorrectly removed sd_index_lock around id
    allocation and free.  idr/ida do have internal locks but they protect
    their free object lists not the allocation itself.  The caller is
    responsible for that.  This missing synchronization led to the same id
    being assigned to multiple devices leading to oops.

