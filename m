Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab3ADLQ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 06:16:58 -0500
Received: from mail.pr.hu ([87.242.0.5]:44033 "EHLO mail.pr.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164Ab3ADLQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 06:16:56 -0500
Message-ID: <50E6BA0D.6030602@pr.hu>
Date: Fri, 04 Jan 2013 12:16:29 +0100
From: Boszormenyi Zoltan <zboszor@pr.hu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Alex Deucher <alexdeucher@gmail.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Jerome Glisse <j.glisse@gmail.com>, Antti Palosaari <crope@iki.fi>,
        Shuah Khan <shuahkhan@gmail.com>, Andy Furniss <andyqos@ukfsn.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        dri-devel@lists.freedesktop.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: radeon 0000:02:00.0: GPU lockup CP stall for more than 10000msec
References: <20121223122210.GA4460@liondog.tnic> <20121223133102.GA8153@liondog.tnic> <CAKocOOPO7ZhybEgKfCkpna+KbpGgajMp6HuHbO9m9uT3gUtP0g@mail.gmail.com> <50E3907C.4040106@iki.fi> <20130102120248.GC6181@x1.alien8.de> <CAH3drwYSrfsbKg-BYpMF3Nkxrw1toK=EmcvJfKGzdbT_BK-1HQ@mail.gmail.com> <50E4755E.7030209@iki.fi> <CAH3drwZsNL6kwufTPGR8h-U9gfrsoYj_+C+8Ei1Ab-PPXrSuTQ@mail.gmail.com> <20130102223807.GA242@x4> <CADnq5_OuhJordwCQArknpdvzYLryouZ+u+a+tm37n3K+hmB9uw@mail.gmail.com> <20130104074054.GB20905@x1.alien8.de>
In-Reply-To: <20130104074054.GB20905@x1.alien8.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -0.2 (/)
X-Scan-Signature: fbcd1a6926db1c1d448730ed27ac6ca3
X-Spam-Tracer: backend.mail.pr.hu -0.2 20130104111521Z
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-01-04 08:40 keltezéssel, Borislav Petkov írta:
> On Wed, Jan 02, 2013 at 06:37:23PM -0500, Alex Deucher wrote:
>> From: Alex Deucher <alexander.deucher@amd.com>
>> Date: Wed, 2 Jan 2013 18:30:21 -0500
>> Subject: [PATCH] drm/radeon/r6xx: fix DMA engine for ttm bo transfers
>>
>> count must be a multiple of 2.
>>
>> Cc: Borislav Petkov <bp@alien8.de>
>> Cc: Markus Trippelsdorf <markus@trippelsdorf.de>
>> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Thanks, will run it on the box in question next week when I have access.
>
> Btw, you could add the note about count needing to be a multiple of 2 as
> a comment in the code below, for future reference.
>
>> ---
>>   drivers/gpu/drm/radeon/r600.c |    4 ++--
>>   1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
>> index 2aaf147..9f4ce5e 100644
>> --- a/drivers/gpu/drm/radeon/r600.c
>> +++ b/drivers/gpu/drm/radeon/r600.c
>> @@ -2636,8 +2636,8 @@ int r600_copy_dma(struct radeon_device *rdev,
>>   
>>   	for (i = 0; i < num_loops; i++) {
>>   		cur_size_in_dw = size_in_dw;
>> -		if (cur_size_in_dw > 0xFFFF)
>> -			cur_size_in_dw = 0xFFFF;
>> +		if (cur_size_in_dw > 0xFFFE)
>> +			cur_size_in_dw = 0xFFFE;

How about any other odd numbers? Like 0xFFFB, or 0x0003?
They will get passed as is after this change, no? Shouldn't they
be also fixed? Something like this below?

               if (cur_size_in_dw & 0x0001)
                    cur_size_in_dw &= ~1;



>>   		size_in_dw -= cur_size_in_dw;
>>   		radeon_ring_write(ring, DMA_PACKET(DMA_PACKET_COPY, 0, 0, cur_size_in_dw));
>>   		radeon_ring_write(ring, dst_offset & 0xfffffffc);
>> -- 
>> 1.7.7.5

