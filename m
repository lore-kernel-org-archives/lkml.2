Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443Ab2H1Ul6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 16:41:58 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:49963 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052Ab2H1Ulz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 16:41:55 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:3803:a800:1ff:fe00:54e9]
In-Reply-To: <1344633496-1873-1-git-send-email-rvaswani@codeaurora.org>
References: <1344633496-1873-1-git-send-email-rvaswani@codeaurora.org>
Date: Tue, 28 Aug 2012 13:41:53 -0700
Message-ID: <CAOesGMgC2OxEs-wGRQku-GeoiaO2Wa_dZ2AuwnKd3Nze4gknqQ@mail.gmail.com>
Subject: Re: [PATCH RESEND 2/2] msm: io: Change the default static iomappings
 to be shared
From: Olof Johansson <olof@lixom.net>
To: Rohit Vaswani <rvaswani@codeaurora.org>
Cc: davidb@codeaurora.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Aug 10, 2012 at 2:18 PM, Rohit Vaswani <rvaswani@codeaurora.org> wrote:
> With 3.4 kernel the static iomappings can be shared with the ioremap
> mappings. If ioremap is called with an address for which a static
> mapping already exists, then that mapping should be used instead
> of creating a new one.
> However, the MT_DEVICE_NONSHARED flag prevents this. Hence, get rid
> of this flag. Some targets (7X00) that require the static iomappings
> to be NONSHARED use the MSM_DEVICE_TYPE and MSM_CHIP_DEVICE_TYPE macros.
>
> Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
> ---
>  arch/arm/mach-msm/io.c |   25 +++++++++++++++++--------
>  1 files changed, 17 insertions(+), 8 deletions(-)
>
> diff --git a/arch/arm/mach-msm/io.c b/arch/arm/mach-msm/io.c
> index 2409c0b..5fc2e48 100644
> --- a/arch/arm/mach-msm/io.c
> +++ b/arch/arm/mach-msm/io.c
> @@ -33,23 +33,32 @@
>                 .virtual = (unsigned long) MSM_##name##_BASE, \
>                 .pfn = __phys_to_pfn(chip##_##name##_PHYS), \
>                 .length = chip##_##name##_SIZE, \
> -               .type = MT_DEVICE_NONSHARED, \
> +               .type = MT_DEVICE, \
> +        }
> +
> +#define MSM_CHIP_DEVICE_TYPE(name, chip, mem_type) {                         \
> +               .virtual = (unsigned long) MSM_##name##_BASE, \
> +               .pfn = __phys_to_pfn(chip##_##name##_PHYS), \
> +               .length = chip##_##name##_SIZE, \
> +               .type = mem_type, \
>          }

The above is partially hidden by lack of context in the diff, but now
you have two defines that do nearly the same thing. It's better to
move to a

#define MSM_CHIP_DEVICE(name, chip)  MSM_CHIP_DEVICE_TYPE(name, chip, MT_DEVICE)

for the exising one, instead of duplicating the open coded macros.


-Olof
