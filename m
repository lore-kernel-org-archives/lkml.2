Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab2K3GNx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 01:13:53 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47502 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653Ab2K3GNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 01:13:51 -0500
Message-ID: <50B84E90.6090103@gmail.com>
Date: Fri, 30 Nov 2012 14:13:36 +0800
From: Mark Zhang <nvmarkzhang@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>
CC: "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC,v2,3/8] video: tegra: host: Add channel and client support
References: <1353935954-13763-4-git-send-email-tbergstrom@nvidia.com> <50B7325F.20002@gmail.com> <50B73D1E.5090600@nvidia.com>
In-Reply-To: <50B73D1E.5090600@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2012 06:46 PM, Terje Bergström wrote:
> On 29.11.2012 12:01, Mark Zhang wrote:
>>
>> Just for curious, why "pb->mapped + 1K" is the end of a 4K pushbuffer?
> 
> pb->mapped is u32 *, so compiler will take care of multiplying by
> sizeof(u32).
> 

Ah, yes. Sorry, I must be insane at that time. :)

>>> +unsigned int nvhost_cdma_wait_locked(struct nvhost_cdma *cdma,
>>> +		enum cdma_event event)
>>> +{
>>> +	for (;;) {
>>> +		unsigned int space = cdma_status_locked(cdma, event);
>>> +		if (space)
>>> +			return space;
>>> +
>>> +		/* If somebody has managed to already start waiting, yield */
>>> +		if (cdma->event != CDMA_EVENT_NONE) {
>>> +			mutex_unlock(&cdma->lock);
>>> +			schedule();
>>> +			mutex_lock(&cdma->lock);
>>> +			continue;
>>> +		}
>>> +		cdma->event = event;
>>> +
>>> +		mutex_unlock(&cdma->lock);
>>> +		down(&cdma->sem);
>>> +		mutex_lock(&cdma->lock);
>>
>> I'm newbie of nvhost but I feel here is very tricky, about the lock and
>> unlock of this mutex: cdma->lock. Does it require this mutex is locked
>> before calling this function? And do we need to unlock it before the
>> code: "return space;" above? IMHO, this is not a good design and can we
>> find out a better solution?
> 
> Yeah, it's not perfect and good solutions are welcome.
> cdma_status_locked() must be called with a mutex. But, what we generally
> wait for is for space in push buffer. The cleanup code cannot run if we
> keep cdma->lock, so I release it.
> 
> The two ways to loop are because there was a race between two processes
> waiting for space. One of them set cdma->event to indicate what it's
> waiting for and can go to sleep, but the other has to keep spinning.
> 

Alright. I just feel this mutex operations is complicated and
error-prone, but I just get the big picture of nvhost and still don't
know much about a lot of details. So I'll let you know if I find some
better solutions.

> Terje
> 
