Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab2DZKgD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 06:36:03 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:56958 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754850Ab2DZKgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 06:36:01 -0400
Message-ID: <4F9924FB.7070308@marvell.com>
Date: Thu, 26 Apr 2012 18:35:39 +0800
From: Yilu Mao <ylmao@marvell.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Lu Mao <ylmao@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "Baohua.Song@csr.com" <Baohua.Song@csr.com>,
        "santosh.shilimkar@ti.com" <santosh.shilimkar@ti.com>,
        "robherring2@gmail.com" <robherring2@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        <njiang1@marvell.com>
Subject: Re: [PATCH] ARM: cache-l2x0.c: save aux ctrl for resume in case that
 l2x0 is enabled before init
References: <1335235280-25148-1-git-send-email-ylmao@marvell.com> <20120424082810.GA9367@arm.com> <4F98D659.4030709@marvell.com> <20120426083554.GB18136@arm.com> <4F99148B.4020900@marvell.com> <20120426094400.GD18136@arm.com> <4F991ED6.8060109@marvell.com> <20120426102815.GE18136@arm.com>
In-Reply-To: <20120426102815.GE18136@arm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2012 06:28 PM, Catalin Marinas wrote:
> On Thu, Apr 26, 2012 at 11:09:26AM +0100, Yilu Mao wrote:
>> On 04/26/2012 05:44 PM, Catalin Marinas wrote:
>>> On Thu, Apr 26, 2012 at 10:25:31AM +0100, Yilu Mao wrote:
>>>> On 04/26/2012 04:35 PM, Catalin Marinas wrote:
>>>>> On Thu, Apr 26, 2012 at 06:00:09AM +0100, Yilu Mao wrote:
>>>>>> On 04/24/2012 04:28 PM, Catalin Marinas wrote:
>>>>>>> On Tue, Apr 24, 2012 at 03:41:20AM +0100, Yilu Mao wrote:
>>>>>>>> +	l2x0_saved_regs.aux_ctrl = aux;
>>>>>>>> +
>>>>>>>>      	aux&= aux_mask;
>>>>>>>>      	aux |= aux_val;
>>>>>>>
>>>>>>> I think that's the wrong place to save it, it should be after the
>>>>>>> masking was done.
>>>>>>>
>>>>>>> Anyway, if we cannot write this register in l2x0_init() because the L2
>>>>>>> was enabled, do we expect the L2 to be disabled during resume?
>>>>>>>
>>>>>> Sorry, I don't think so.
>>>>>> This is the right place to save it because we must make sure the saved
>>>>>> aux_ctrl is the same as what it is set.
>>>>>> If we save it after masking was done, the saved value will be different
>>>>>> because we can't actually change the real setting.
>>>>>
>>>>> And since we can't actually change the real setting on the resume path,
>>>>> why do we need to save it anyway. Is your L2 cache disabled on the
>>>>> resume path but not on the cold boot one?
>>>>
>>>> We can't change L2 aux ctrl setting when do init because it has been
>>>> enabled.
>>>
>>> This is normally for the case where the kernel running in non-secure
>>> mode is not allowed to write the L2 aux ctrl register. Does this
>>> permission change with core idle?
>>>
>> Yes, your understanding of previous mail is right. The L2 is enabled on
>> code boot and it is disabled on the resume in our case.
>
> But the kernel either runs in secure mode or the non-secure access to
> this register is allowed.
>
>> So if we don't have such patch, when core idle exit, L2 cache aux ctrl
>> register will be set to 0x0 because l2x0_saved_regs.aux_ctrl is not
>> initialized.
>
> You could still make sure that the mask passed doesn't affect the
> original setting and save it after masking.
>
Do you mean the code is like this:
aux = readl_relaxed(l2x0_base + L2X0_AUX_CTRL);
aux &= aux_mask;
l2x0_saved_regs.aux_ctrl = aux;

Then the saved value is not the same as real setting. So the restored 
value after core idle will not the same as before... This is not what we 
expected.

-- 
Thanks.

Best Wishes,
Yilu Mao
