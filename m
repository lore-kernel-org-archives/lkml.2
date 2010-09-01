Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab0IAVaH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 17:30:07 -0400
Received: from mail.bluewatersys.com ([202.124.120.130]:55275 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754725Ab0IAVaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 17:30:06 -0400
Message-ID: <4C7EC5E3.8030504@bluewatersys.com>
Date: Thu, 02 Sep 2010 09:30:11 +1200
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Daniel Walker <dwalker@codeaurora.org>
CC: H Hartley Sweeten <hartleys@visionengravers.com>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        Gregory Bean <gbean@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] msm: Install the Google-Android gpio driver.
References: <1283213906-17671-1-git-send-email-gbean@codeaurora.org>	<0D753D10438DA54287A00B027084269764447830F3@AUSP01VMBX24.collaborationhost.net> <1283375606.21049.20.camel@c-dwalke-linux.qualcomm.com>
In-Reply-To: <1283375606.21049.20.camel@c-dwalke-linux.qualcomm.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2010 09:13 AM, Daniel Walker wrote:
> On Wed, 2010-09-01 at 13:59 -0500, H Hartley Sweeten wrote:
>> On Monday, August 30, 2010 5:18 PM, Gregory Bean wrote:
>>> Subject: [PATCH 1/2] msm: Install the Google-Android gpio driver.
>>>
>>> From: Arve Hjønnevåg <arve@android.com>
>>>
>>> As part of the ongoing effort to converge on a common code base,
>>> adopt the Google-Android msmgpio driver, as it has a stronger pedigree
>>> than the previous submission from codeaurora.
>>>
>>> Cc: Arve Hjønnevåg <arve@android.com>
>>> Signed-off-by: Gregory Bean <gbean@codeaurora.org>
>>
>> Hello Greg,
>>
>> A couple comments on this.
>>
>>> +struct msm_gpio_chip msm_gpio_chips[] = {
>>> +	{
>>> +		.regs = {
>>> +			.out =         GPIO_OUT_0,
>>> +			.in =          GPIO_IN_0,
>>> +			.int_status =  GPIO_INT_STATUS_0,
>>> +			.int_clear =   GPIO_INT_CLEAR_0,
>>> +			.int_en =      GPIO_INT_EN_0,
>>> +			.int_edge =    GPIO_INT_EDGE_0,
>>> +			.int_pos =     GPIO_INT_POS_0,
>>> +			.oe =          GPIO_OE_0,
>>> +		},
>>> +		.chip = {
>>> +			.base = 0,
>>> +			.ngpio = 16,
>>> +			.get = msm_gpio_get,
>>> +			.set = msm_gpio_set,
>>> +			.direction_input = msm_gpio_direction_input,
>>> +			.direction_output = msm_gpio_direction_output,
>>> +			.to_irq = msm_gpio_to_irq,
>>> +		}
>>> +	},
>>
>> This is a bit ugly... A 204 line struct definition is a bit hard to follow,
>> especially the way it's broken up with all the #if defined stuff.
>>
>> Each gpio "bank" is code duplication other than the .base and .ngpio.  The
>> whole thing can be reduced using a helper macro.  Something like this:
>>
>> #define MSM_GPIO_BANK(bank, base_gpio, num_gpio)			\
>> 	{										\
>> 		.regs = {								\
>> 			.out			= GPIO_OUT_##bank,		\
>> 			.in			= GPIO_IN_##bank,			\
>> 			.int_status		= GPIO_INT_STATUS_##bank,	\
>> 			.int_clear		= GPIO_INT_CLEAR_##bank,	\
>> 			.int_en		= GPIO_INT_EN_##bank,		\
>> 			.int_edge		= GPIO_INT_EDGE_##bank,		\
>> 			.int_pos		= GPIO_INT_POS_##bank,		\
>> 			.oe			= GPIO_OE_##bank,			\
>> 		},									\
>> 		.chip = {								\
>> 			.direction_input	= msm_gpio_direction_input,	\
>> 			.direction_output	= msm_gpio_direction_output,	\
>> 			.get			= msm_gpio_get,			\
>> 			.set			= msm_gpio_set,			\
>> 			.to_irq		= msm_gpio_to_irq,		\
>> 			.base			= base_gpio,			\
>> 			.ngpio		= num_gpio,				\
>> 		},									\
>> 	}
>>
>> Then the struct definition can be reduced to this:
>>
>> struct msm_gpio_chip msm_gpio_chips[] = {
>> #if defined(CONFIG_ARCH_MSM7X30)
>> 	MSM_GPIO_BANK(0, 0, 16),	/* gpio 0-15 */
>> 	MSM_GPIO_BANK(1, 16, 28),	/* gpio 16-43 */
>> 	MSM_GPIO_BANK(2, 44, 24),	/* gpio 44-67 */
>> 	MSM_GPIO_BANK(3, 68, 27),	/* gpio 68-94 */
>> 	MSM_GPIO_BANK(4, 95, 12),	/* gpio 95-106 */
>> 	MSM_GPIO_BANK(5, 107, 27),	/* gpio 107-133 */
>> 	MSM_GPIO_BANK(6, 134, 17),	/* gpio 134-150 */
>> 	MSM_GPIO_BANK(7, 151, 31),	/* gpio 151-181 */
>> #elif defined(CONFIG_ARCH_QSD8X50)
>> 	MSM_GPIO_BANK(0, 0, 16),	/* gpio 0-15 */
>> 	MSM_GPIO_BANK(1, 16, 27),	/* gpio 16-42 */
>> 	MSM_GPIO_BANK(2, 43, 25),	/* gpio 43-67 */
>> 	MSM_GPIO_BANK(3, 68, 27),	/* gpio 68-94 */
>> 	MSM_GPIO_BANK(4, 95, 9),	/* gpio 95-103 */
>> 	MSM_GPIO_BANK(5, 104, 18),	/* gpio 104-121 */
>> 	MSM_GPIO_BANK(6, 122, 31),	/* gpio 122-152 */
>> 	MSM_GPIO_BANK(7, 153, 12),	/* gpio 153-164 */
>> #else
>> 	MSM_GPIO_BANK(0, 0, 16),	/* gpio 0-15 */
>> 	MSM_GPIO_BANK(1, 16, 27),	/* gpio 16-42 */
>> 	MSM_GPIO_BANK(2, 43, 25),	/* gpio 43-67 */
>> 	MSM_GPIO_BANK(3, 68, 27),	/* gpio 68-94 */
>> 	MSM_GPIO_BANK(4, 95, 12),	/* gpio 95-106 */
>> 	MSM_GPIO_BANK(5, 107, 15),	/* gpio 107-121 */
>> #endif
>> };

Which could also be further reduced to:

struct msm_gpio_chip msm_gpio_chips[] = {
	MSM_GPIO_BANK(0,   0, 16),	/* gpio 0-15 */
#if defined(CONFIG_ARCH_MSM7X30)
	MSM_GPIO_BANK(1,  16, 28),	/* gpio 16-43 */
 	MSM_GPIO_BANK(2,  44, 24),	/* gpio 44-67 */
 	MSM_GPIO_BANK(3,  68, 27),	/* gpio 68-94 */
 	MSM_GPIO_BANK(4,  95, 12),	/* gpio 95-106 */
 	MSM_GPIO_BANK(5, 107, 27),	/* gpio 107-133 */
 	MSM_GPIO_BANK(6, 134, 17),	/* gpio 134-150 */
 	MSM_GPIO_BANK(7, 151, 31),	/* gpio 151-181 */
#else
	MSM_GPIO_BANK(1,  16, 27),	/* gpio 16-42 */
	MSM_GPIO_BANK(2,  43, 25),	/* gpio 43-67 */
 	MSM_GPIO_BANK(3,  68, 27),	/* gpio 68-94 */
#if defined(CONFIG_ARCH_QSD8X50)
	MSM_GPIO_BANK(4,  95,  9),	/* gpio 95-103 */
 	MSM_GPIO_BANK(5, 104, 18),	/* gpio 104-121 */
 	MSM_GPIO_BANK(6, 122, 31),	/* gpio 122-152 */
 	MSM_GPIO_BANK(7, 153, 12),	/* gpio 153-164 */	
#else
	MSM_GPIO_BANK(4,  95, 12),	/* gpio 95-106 */
 	MSM_GPIO_BANK(5, 107, 15),	/* gpio 107-121 */
#endif
#endif

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
