Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543Ab1HJN2B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 09:28:01 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:45743 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab1HJN17 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 09:27:59 -0400
MIME-Version: 1.0
In-Reply-To: <1312968271.14630.189.camel@thor.local>
References: <4E417AF8.7090202@gmail.com>
	<1312968271.14630.189.camel@thor.local>
Date: Wed, 10 Aug 2011 09:27:58 -0400
Message-ID: <CADnq5_Mk3oUHU+iABeFiGz=FaPnLVbtyYCA_6KnWA_QTfigfew@mail.gmail.com>
Subject: Re: [PATCH 2.6.38-10-generic] device driver: fix oops in radeon
 driver due to incorrect value from hardware
From: Alex Deucher <alexdeucher@gmail.com>
To: =?ISO-8859-1?Q?Michel_D=E4nzer?= <michel@daenzer.net>
Cc: Mayank Rungta <mr.mynk@gmail.com>, "A.R Karthick" <a.r.karthick@gmail.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        karthick.linuxdreamer@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/8/10 Michel Dänzer <michel@daenzer.net>:
> On Die, 2011-08-09 at 23:52 +0530, Mayank Rungta wrote:
>> Added a check for the radeon ring buffer write index in r600.c which
>> reads 0xffffffff on resume. This results in an Oops during
>> radeon_ring_write. Masking the value averts this.
>>
>> This problem is not seen to be fixed in 3.0 r600.c as well.
>>
>> Detailed analysis of the problem can be found at -
>>
>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/820746/
>>
>> ---
>>
>> BUG: unable to handle kernel paging request at fa501ffc - Oops at
>> r600_cp_start+0x48/0x380 in r600_cp_resume+0x345/0x580 [radeon]
>>
>> drivers/gpu/drm/radeon/r600.c
>>
>>
>>
>> --- linux-2.6.38/drivers/gpu/drm/radeon/r600.c.orig    2011-08-05
>> 15:39:40.824612700 +0530
>> +++ linux-2.6.38/drivers/gpu/drm/radeon/r600.c    2011-08-08
>> 05:29:21.744417857 +0530
>> @@ -2218,6 +2218,8 @@ int r600_cp_resume(struct radeon_device
>>
>>       rdev->cp.rptr = RREG32(CP_RB_RPTR);
>>       rdev->cp.wptr = RREG32(CP_RB_WPTR);
>> +    /* protect against crazy HW on resume */
>> +    rdev->cp.wptr &= rdev->cp.ptr_mask;
>
> The indentation of the lines you're adding doesn't match the surrounding
> lines.
>
>
> Although the same workaround is already in r100.c, I wonder if we
> shouldn't rather try and eliminate all reads from the CP_RB_WPTR
> register, at least other than for debugging purposes. Alex, what do you
> think?

Either this or reset the registers to 0 or a saved value on resume
rather than reading from them.

>
> Otherwise, this should probably be added in evergreen.c as well.
>

Yes, and ni.c as well.

Alex

>
>>          Developer's Certificate of Origin 1.1
>>
>>          [...]
>
> No need to include all this text, just the *-by: tags are enough.
>
>
> --
> Earthling Michel Dänzer           |                   http://www.amd.com
> Libre software enthusiast         |          Debian, X and DRI developer
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>
