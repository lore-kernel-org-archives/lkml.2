Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151Ab2DZLDt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 07:03:49 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:36477 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755421Ab2DZLDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 07:03:48 -0400
Message-ID: <4F992B80.6040207@marvell.com>
Date: Thu, 26 Apr 2012 19:03:28 +0800
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
        Ning Jiang <njiang1@marvell.com>
Subject: Re: [PATCH] ARM: cache-l2x0.c: save aux ctrl for resume in case that
 l2x0 is enabled before init
References: <20120424082810.GA9367@arm.com> <4F98D659.4030709@marvell.com> <20120426083554.GB18136@arm.com> <4F99148B.4020900@marvell.com> <20120426094400.GD18136@arm.com> <4F991ED6.8060109@marvell.com> <20120426102815.GE18136@arm.com> <4F9924FB.7070308@marvell.com> <20120426103840.GA6294@arm.com> <4F9927F2.5060408@marvell.com> <20120426105651.GB6294@arm.com>
In-Reply-To: <20120426105651.GB6294@arm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2012 06:56 PM, Catalin Marinas wrote:
> On Thu, Apr 26, 2012 at 11:48:18AM +0100, Yilu Mao wrote:
>> On 04/26/2012 06:38 PM, Catalin Marinas wrote:
>>> On Thu, Apr 26, 2012 at 11:35:39AM +0100, Yilu Mao wrote:
>>>> On 04/26/2012 06:28 PM, Catalin Marinas wrote:
>>>>> On Thu, Apr 26, 2012 at 11:09:26AM +0100, Yilu Mao wrote:
>>>>>> On 04/26/2012 05:44 PM, Catalin Marinas wrote:
>>>>>>> On Thu, Apr 26, 2012 at 10:25:31AM +0100, Yilu Mao wrote:
>>>>>>>> On 04/26/2012 04:35 PM, Catalin Marinas wrote:
>>>>>>>>> On Thu, Apr 26, 2012 at 06:00:09AM +0100, Yilu Mao wrote:
>>>>>>>>>> On 04/24/2012 04:28 PM, Catalin Marinas wrote:
>>>>>>>>>>> On Tue, Apr 24, 2012 at 03:41:20AM +0100, Yilu Mao wrote:
>>>>>>>>>>>> +	l2x0_saved_regs.aux_ctrl = aux;
>>>>>>>>>>>> +
>>>>>>>>>>>>        	aux&= aux_mask;
>>>>>>>>>>>>        	aux |= aux_val;
>>>>>>>>>>>
>>>>>>>>>>> I think that's the wrong place to save it, it should be after the
>>>>>>>>>>> masking was done.
>>>>>>>>>>>
>>>>>>>>>>> Anyway, if we cannot write this register in l2x0_init() because the L2
>>>>>>>>>>> was enabled, do we expect the L2 to be disabled during resume?
>>>>>>>>>>>
>>>>>>>>>> Sorry, I don't think so.
>>>>>>>>>> This is the right place to save it because we must make sure the saved
>>>>>>>>>> aux_ctrl is the same as what it is set.
>>>>>>>>>> If we save it after masking was done, the saved value will be different
>>>>>>>>>> because we can't actually change the real setting.
>>>>>>>>>
>>>>>>>>> And since we can't actually change the real setting on the resume path,
>>>>>>>>> why do we need to save it anyway. Is your L2 cache disabled on the
>>>>>>>>> resume path but not on the cold boot one?
>>>>>>>>
>>>>>>>> We can't change L2 aux ctrl setting when do init because it has been
>>>>>>>> enabled.
>>>>>>>
>>>>>>> This is normally for the case where the kernel running in non-secure
>>>>>>> mode is not allowed to write the L2 aux ctrl register. Does this
>>>>>>> permission change with core idle?
>>>>>>>
>>>>>> Yes, your understanding of previous mail is right. The L2 is enabled on
>>>>>> code boot and it is disabled on the resume in our case.
>>>>>
>>>>> But the kernel either runs in secure mode or the non-secure access to
>>>>> this register is allowed.
>>>>>
>>>>>> So if we don't have such patch, when core idle exit, L2 cache aux ctrl
>>>>>> register will be set to 0x0 because l2x0_saved_regs.aux_ctrl is not
>>>>>> initialized.
>>>>>
>>>>> You could still make sure that the mask passed doesn't affect the
>>>>> original setting and save it after masking.
>>>>>
>>>> Do you mean the code is like this:
>>>> aux = readl_relaxed(l2x0_base + L2X0_AUX_CTRL);
>>>> aux&= aux_mask;
>>>> l2x0_saved_regs.aux_ctrl = aux;
>>>>
>>>> Then the saved value is not the same as real setting. So the restored
>>>> value after core idle will not the same as before... This is not what we
>>>> expected.
>>>
>>> My point was that on your platform you pass an aux_mask that is meant to
>>> change the already set aux_ctlr value. Why do you pass such mask to be
>>> anything other than ~0UL in this case?
>>>
>> Sorry I still can't catch your point...
>> In our platform, we actually use ~0UL as aux mask.
>>
>> Anyway, the two arguments, aux_value and aux_mask, are both for changing
>> the original value set before kernel bootup. If L2 cache is enabled in
>> cold boot, both two arguments are useless because we can't set the
>> register. So we must make sure we can restore the original value after
>> core idle.
>
> So if your platform passes aux_mask = ~0UL and aux_val = 0, there is no
> change to the read aux_ctlr value.
>
> If for whatever reason (same binary running in different configuration)
> you need to pass the aux_mask and aux_val different from the above, then
> your argument makes sense. But I just want to be clear.
>
Actually, our arguments are aux_value = 0x30000000 and aux_mask = ~0UL.
I think it is also ok with my patch.
What do you think?

-- 
Thanks.

Best Wishes,
Yilu Mao
