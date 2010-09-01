Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab0IAVNn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 17:13:43 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16240 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab0IAVNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 17:13:42 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6092"; a="52928528"
Subject: RE: [PATCH 1/2] msm: Install the Google-Android gpio driver.
From: Daniel Walker <dwalker@codeaurora.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Gregory Bean <gbean@codeaurora.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
In-Reply-To: <0D753D10438DA54287A00B027084269764447830F3@AUSP01VMBX24.collaborationhost.net>
References: <1283213906-17671-1-git-send-email-gbean@codeaurora.org>
	 <0D753D10438DA54287A00B027084269764447830F3@AUSP01VMBX24.collaborationhost.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Sep 2010 14:13:26 -0700
Message-ID: <1283375606.21049.20.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-01 at 13:59 -0500, H Hartley Sweeten wrote:
> On Monday, August 30, 2010 5:18 PM, Gregory Bean wrote:
> > Subject: [PATCH 1/2] msm: Install the Google-Android gpio driver.
> > 
> > From: Arve Hjønnevåg <arve@android.com>
> > 
> > As part of the ongoing effort to converge on a common code base,
> > adopt the Google-Android msmgpio driver, as it has a stronger pedigree
> > than the previous submission from codeaurora.
> > 
> > Cc: Arve Hjønnevåg <arve@android.com>
> > Signed-off-by: Gregory Bean <gbean@codeaurora.org>
> 
> Hello Greg,
> 
> A couple comments on this.
> 
> > +struct msm_gpio_chip msm_gpio_chips[] = {
> > +	{
> > +		.regs = {
> > +			.out =         GPIO_OUT_0,
> > +			.in =          GPIO_IN_0,
> > +			.int_status =  GPIO_INT_STATUS_0,
> > +			.int_clear =   GPIO_INT_CLEAR_0,
> > +			.int_en =      GPIO_INT_EN_0,
> > +			.int_edge =    GPIO_INT_EDGE_0,
> > +			.int_pos =     GPIO_INT_POS_0,
> > +			.oe =          GPIO_OE_0,
> > +		},
> > +		.chip = {
> > +			.base = 0,
> > +			.ngpio = 16,
> > +			.get = msm_gpio_get,
> > +			.set = msm_gpio_set,
> > +			.direction_input = msm_gpio_direction_input,
> > +			.direction_output = msm_gpio_direction_output,
> > +			.to_irq = msm_gpio_to_irq,
> > +		}
> > +	},
> 
> This is a bit ugly... A 204 line struct definition is a bit hard to follow,
> especially the way it's broken up with all the #if defined stuff.
> 
> Each gpio "bank" is code duplication other than the .base and .ngpio.  The
> whole thing can be reduced using a helper macro.  Something like this:
> 
> #define MSM_GPIO_BANK(bank, base_gpio, num_gpio)			\
> 	{										\
> 		.regs = {								\
> 			.out			= GPIO_OUT_##bank,		\
> 			.in			= GPIO_IN_##bank,			\
> 			.int_status		= GPIO_INT_STATUS_##bank,	\
> 			.int_clear		= GPIO_INT_CLEAR_##bank,	\
> 			.int_en		= GPIO_INT_EN_##bank,		\
> 			.int_edge		= GPIO_INT_EDGE_##bank,		\
> 			.int_pos		= GPIO_INT_POS_##bank,		\
> 			.oe			= GPIO_OE_##bank,			\
> 		},									\
> 		.chip = {								\
> 			.direction_input	= msm_gpio_direction_input,	\
> 			.direction_output	= msm_gpio_direction_output,	\
> 			.get			= msm_gpio_get,			\
> 			.set			= msm_gpio_set,			\
> 			.to_irq		= msm_gpio_to_irq,		\
> 			.base			= base_gpio,			\
> 			.ngpio		= num_gpio,				\
> 		},									\
> 	}
> 
> Then the struct definition can be reduced to this:
> 
> struct msm_gpio_chip msm_gpio_chips[] = {
> #if defined(CONFIG_ARCH_MSM7X30)
> 	MSM_GPIO_BANK(0, 0, 16),	/* gpio 0-15 */
> 	MSM_GPIO_BANK(1, 16, 28),	/* gpio 16-43 */
> 	MSM_GPIO_BANK(2, 44, 24),	/* gpio 44-67 */
> 	MSM_GPIO_BANK(3, 68, 27),	/* gpio 68-94 */
> 	MSM_GPIO_BANK(4, 95, 12),	/* gpio 95-106 */
> 	MSM_GPIO_BANK(5, 107, 27),	/* gpio 107-133 */
> 	MSM_GPIO_BANK(6, 134, 17),	/* gpio 134-150 */
> 	MSM_GPIO_BANK(7, 151, 31),	/* gpio 151-181 */
> #elif defined(CONFIG_ARCH_QSD8X50)
> 	MSM_GPIO_BANK(0, 0, 16),	/* gpio 0-15 */
> 	MSM_GPIO_BANK(1, 16, 27),	/* gpio 16-42 */
> 	MSM_GPIO_BANK(2, 43, 25),	/* gpio 43-67 */
> 	MSM_GPIO_BANK(3, 68, 27),	/* gpio 68-94 */
> 	MSM_GPIO_BANK(4, 95, 9),	/* gpio 95-103 */
> 	MSM_GPIO_BANK(5, 104, 18),	/* gpio 104-121 */
> 	MSM_GPIO_BANK(6, 122, 31),	/* gpio 122-152 */
> 	MSM_GPIO_BANK(7, 153, 12),	/* gpio 153-164 */
> #else
> 	MSM_GPIO_BANK(0, 0, 16),	/* gpio 0-15 */
> 	MSM_GPIO_BANK(1, 16, 27),	/* gpio 16-42 */
> 	MSM_GPIO_BANK(2, 43, 25),	/* gpio 43-67 */
> 	MSM_GPIO_BANK(3, 68, 27),	/* gpio 68-94 */
> 	MSM_GPIO_BANK(4, 95, 12),	/* gpio 95-106 */
> 	MSM_GPIO_BANK(5, 107, 15),	/* gpio 107-121 */
> #endif
> };
> 

Yeah, this macro method is much nicer. It drops 204 lines down to less
than half that.. Less duplication and less lines to maintain.

Thanks for the review Hartley.

Daniel

-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

