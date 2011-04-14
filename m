Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758878Ab1DNO2p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 10:28:45 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:50182 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758837Ab1DNO2o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 10:28:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jR+wwPJiUgcJz03vjeQlQzHZUyRF1FdTGFaOlyDiGsZcfV6/gHUTwM7L/vZMcY51r/
         M49FSzXd2uc9ADPtOJ+LhDlIHtRnaKHC0U908msoGL1m6w0ZJF0GAdN3TzaIUe7zkKW5
         V21M734w/BiMqf4VnBDlfJ8EVewFIrq3PWKsA=
MIME-Version: 1.0
In-Reply-To: <20110414085624.GC18463@8bytes.org>
References: <BANLkTimNvX=U6qy2FgvDpWE6HY7cehWvyQ@mail.gmail.com>
	<20110412090207.GE19819@8bytes.org>
	<BANLkTimSgAmT5a1s0ciBr2jsE-Nu7n4buQ@mail.gmail.com>
	<20110412184433.GF19819@8bytes.org>
	<20110413064609.GA18777@elte.hu>
	<20110413172147.GI19819@8bytes.org>
	<4DA5F62F.3030504@kernel.org>
	<4DA654D6.2060103@zytor.com>
	<20110414085624.GC18463@8bytes.org>
Date: Thu, 14 Apr 2011 10:28:43 -0400
Message-ID: <BANLkTintewt4kadNLEZ-RAew0Gx6=gUOfQ@mail.gmail.com>
Subject: Re: Linux 2.6.39-rc3
From: Alex Deucher <alexdeucher@gmail.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Thomas Gleixner <tglx@linutronix.de>,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 4:56 AM, Joerg Roedel <joro@8bytes.org> wrote:
> On Wed, Apr 13, 2011 at 06:58:46PM -0700, H. Peter Anvin wrote:
>> On 04/13/2011 12:14 PM, Yinghai Lu wrote:
>> >
>> > so looks bios program wrong address to the radon card?
>> >
>>
>> Okay, staring at this, it definitely seems toxic to overlay the GART
>> over memory areas reserved by the BIOS.  If I were to guess, I would say
>> that the problem here seems to be that the kernel thinks it is
>> overlaying 64 MiB of memory, but the actual GART is in fact 512 MiB in
>> size -- 131072 CPU pages -- which now overlaps the BIOS reserved areas.
>>
>> Alex D., could you comment on the "num cpu pages" bit?
>
> Okay, I tried the debug-patch from Yinghai (posted to the bugzilla):
>
> --- a/drivers/gpu/drm/radeon/radeon_device.c
> +++ b/drivers/gpu/drm/radeon/radeon_device.c
> @@ -325,6 +325,8 @@ void radeon_gtt_location(struct radeon_device *rdev, struct radeon_mc *mc)
>                        mc->gtt_size = size_bf;
>                }
>                mc->gtt_start = (mc->vram_start & ~mc->gtt_base_align) - mc->gtt_size;
> +               if (mc->gtt_start == 0xa0000000)
> +                       mc->gtt_start = 0x80000000;
>        } else {
>                if (mc->gtt_size > size_af) {
>                        dev_warn(rdev->dev, "limiting GTT\n");
>
> And this makes a difference, with this change on-top of -rc3 the box boots
> fine. So there seems to be some dependency between the GART base and the GTT
> base even when they are in different address spaces.
>
> Alex, can you comment on this?

As Dave said, they are completely different addresses spaces.  You
could put the GPU aperture at 0 if you wanted (in fact we do on some
chips).  Perhaps there's some strange interaction with the nb gart
since the nb gart on that chipset was designed to be used for graphics
and the rs780/880 can be configured to use an agp aperture.
Unfortunately, I'm not that familiar with the nb gart.

Alex

>
> Regards,
>
>        Joerg
>
>
