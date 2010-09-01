Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab0IATBH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 15:01:07 -0400
Received: from p01c12o144.mxlogic.net ([208.65.145.67]:43545 "EHLO
	p01c12o144.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954Ab0IATBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 15:01:05 -0400
X-MXL-Hash: 4c7ea2f16c913a8f-6b64ec97d0aa56542e4c460e7e3617eb25a9ed81
X-MXL-Hash: 4c7ea2ee01ca4b20-0c82d72a325879293457e6879341ee9f37744ccb
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Gregory Bean <gbean@codeaurora.org>,
        "dwalker@codeaurora.org" <dwalker@codeaurora.org>
CC: "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        =?utf-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Wed, 1 Sep 2010 13:59:54 -0500
Subject: RE: [PATCH 1/2] msm: Install the Google-Android gpio driver.
Thread-Topic: [PATCH 1/2] msm: Install the Google-Android gpio driver.
Thread-Index: ActIor5ElgdfAmvOTfK9/sn/G6wbnQBYt2kg
Message-ID: <0D753D10438DA54287A00B027084269764447830F3@AUSP01VMBX24.collaborationhost.net>
References: <1283213906-17671-1-git-send-email-gbean@codeaurora.org>
In-Reply-To: <1283213906-17671-1-git-send-email-gbean@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010073001)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.72]
X-AnalysisOut: [v=1.0 c=1 a=vPEevKMDgl8A:10 a=VphdPIyG4kEA:10 a=IkcTkHD0fZ]
X-AnalysisOut: [MA:10 a=jM3uHZP82BWpxjlUuN2t4A==:17 a=n8i27M1mAAAA:8 a=LpQ]
X-AnalysisOut: [P-O61AAAA:8 a=hIjjri4SuRBbAIhgU70A:9 a=9dJlGpMuiajN4iixyFg]
X-AnalysisOut: [AdWUKDqoA:4 a=QEXdDO2ut3YA:10 a=rXZLD9m7qZoA:10 a=YDjxKKMX]
X-AnalysisOut: [svQA:10 a=ifqTDN6FDLLM6nLf:21 a=EIhsgOtVkIYneLhW:21]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o81J1CVV009793

On Monday, August 30, 2010 5:18 PM, Gregory Bean wrote:
> Subject: [PATCH 1/2] msm: Install the Google-Android gpio driver.
> 
> From: Arve HjÃ¸nnevÃ¥g <arve@android.com>
> 
> As part of the ongoing effort to converge on a common code base,
> adopt the Google-Android msmgpio driver, as it has a stronger pedigree
> than the previous submission from codeaurora.
> 
> Cc: Arve HjÃ¸nnevÃ¥g <arve@android.com>
> Signed-off-by: Gregory Bean <gbean@codeaurora.org>

Hello Greg,

A couple comments on this.

> +struct msm_gpio_chip msm_gpio_chips[] = {
> +	{
> +		.regs = {
> +			.out =         GPIO_OUT_0,
> +			.in =          GPIO_IN_0,
> +			.int_status =  GPIO_INT_STATUS_0,
> +			.int_clear =   GPIO_INT_CLEAR_0,
> +			.int_en =      GPIO_INT_EN_0,
> +			.int_edge =    GPIO_INT_EDGE_0,
> +			.int_pos =     GPIO_INT_POS_0,
> +			.oe =          GPIO_OE_0,
> +		},
> +		.chip = {
> +			.base = 0,
> +			.ngpio = 16,
> +			.get = msm_gpio_get,
> +			.set = msm_gpio_set,
> +			.direction_input = msm_gpio_direction_input,
> +			.direction_output = msm_gpio_direction_output,
> +			.to_irq = msm_gpio_to_irq,
> +		}
> +	},

This is a bit ugly... A 204 line struct definition is a bit hard to follow,
especially the way it's broken up with all the #if defined stuff.

Each gpio "bank" is code duplication other than the .base and .ngpio.  The
whole thing can be reduced using a helper macro.  Something like this:

#define MSM_GPIO_BANK(bank, base_gpio, num_gpio)			\
	{										\
		.regs = {								\
			.out			= GPIO_OUT_##bank,		\
			.in			= GPIO_IN_##bank,			\
			.int_status		= GPIO_INT_STATUS_##bank,	\
			.int_clear		= GPIO_INT_CLEAR_##bank,	\
			.int_en		= GPIO_INT_EN_##bank,		\
			.int_edge		= GPIO_INT_EDGE_##bank,		\
			.int_pos		= GPIO_INT_POS_##bank,		\
			.oe			= GPIO_OE_##bank,			\
		},									\
		.chip = {								\
			.direction_input	= msm_gpio_direction_input,	\
			.direction_output	= msm_gpio_direction_output,	\
			.get			= msm_gpio_get,			\
			.set			= msm_gpio_set,			\
			.to_irq		= msm_gpio_to_irq,		\
			.base			= base_gpio,			\
			.ngpio		= num_gpio,				\
		},									\
	}

Then the struct definition can be reduced to this:

struct msm_gpio_chip msm_gpio_chips[] = {
#if defined(CONFIG_ARCH_MSM7X30)
	MSM_GPIO_BANK(0, 0, 16),	/* gpio 0-15 */
	MSM_GPIO_BANK(1, 16, 28),	/* gpio 16-43 */
	MSM_GPIO_BANK(2, 44, 24),	/* gpio 44-67 */
	MSM_GPIO_BANK(3, 68, 27),	/* gpio 68-94 */
	MSM_GPIO_BANK(4, 95, 12),	/* gpio 95-106 */
	MSM_GPIO_BANK(5, 107, 27),	/* gpio 107-133 */
	MSM_GPIO_BANK(6, 134, 17),	/* gpio 134-150 */
	MSM_GPIO_BANK(7, 151, 31),	/* gpio 151-181 */
#elif defined(CONFIG_ARCH_QSD8X50)
	MSM_GPIO_BANK(0, 0, 16),	/* gpio 0-15 */
	MSM_GPIO_BANK(1, 16, 27),	/* gpio 16-42 */
	MSM_GPIO_BANK(2, 43, 25),	/* gpio 43-67 */
	MSM_GPIO_BANK(3, 68, 27),	/* gpio 68-94 */
	MSM_GPIO_BANK(4, 95, 9),	/* gpio 95-103 */
	MSM_GPIO_BANK(5, 104, 18),	/* gpio 104-121 */
	MSM_GPIO_BANK(6, 122, 31),	/* gpio 122-152 */
	MSM_GPIO_BANK(7, 153, 12),	/* gpio 153-164 */
#else
	MSM_GPIO_BANK(0, 0, 16),	/* gpio 0-15 */
	MSM_GPIO_BANK(1, 16, 27),	/* gpio 16-42 */
	MSM_GPIO_BANK(2, 43, 25),	/* gpio 43-67 */
	MSM_GPIO_BANK(3, 68, 27),	/* gpio 68-94 */
	MSM_GPIO_BANK(4, 95, 12),	/* gpio 95-106 */
	MSM_GPIO_BANK(5, 107, 15),	/* gpio 107-121 */
#endif
};

I'm not sure if that macro will actually work correctly.  But you should
get the idea.

> +#if defined(CONFIG_ARCH_MSM7X30)
> +#define GPIO1_REG(off) (MSM_GPIO1_BASE + (off))
> +#define GPIO2_REG(off) (MSM_GPIO2_BASE + 0x400 + (off))
> +#else
> +#define GPIO1_REG(off) (MSM_GPIO1_BASE + 0x800 + (off))
> +#define GPIO2_REG(off) (MSM_GPIO2_BASE + 0xC00 + (off))
> +#endif
> +
> +#if defined(CONFIG_ARCH_MSM7X00A) || defined(CONFIG_ARCH_MSM7X27)
> +
> +/* output value */
> +#define GPIO_OUT_0         GPIO1_REG(0x00)  /* gpio  15-0  */
> +#define GPIO_OUT_1         GPIO2_REG(0x00)  /* gpio  42-16 */
> +#define GPIO_OUT_2         GPIO1_REG(0x04)  /* gpio  67-43 */
> +#define GPIO_OUT_3         GPIO1_REG(0x08)  /* gpio  94-68 */
> +#define GPIO_OUT_4         GPIO1_REG(0x0C)  /* gpio 106-95 */
> +#define GPIO_OUT_5         GPIO1_REG(0x50)  /* gpio 107-121 */

I realize this header is private (i.e. in the mach-msm directory) but
you should probably prefix all of these GPIO_* defines with something
to prevent any namespace clashes.

Regards,
Hartleyÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
