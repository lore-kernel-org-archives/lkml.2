Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab2APQuD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 11:50:03 -0500
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:60773 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752654Ab2APQuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 11:50:01 -0500
Message-ID: <4F14552B.1030203@ti.com>
Date: Mon, 16 Jan 2012 22:19:47 +0530
From: Shubhrajyoti <shubhrajyoti@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: ext-denis.2.karpov@nokia.com
CC: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] mmc : omap_hsmmc : Save and restore the sysc across
 reset
References: <1326713587-26463-1-git-send-email-shubhrajyoti@ti.com> <5E7C2FE2AE03DF4CA6AC500032BF8F77C1762A@008-AM1MPN1-072.mgdnok.nokia.com> <4F143296.8090802@ti.com> <5E7C2FE2AE03DF4CA6AC500032BF8F77C176F7@008-AM1MPN1-072.mgdnok.nokia.com>
In-Reply-To: <5E7C2FE2AE03DF4CA6AC500032BF8F77C176F7@008-AM1MPN1-072.mgdnok.nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 January 2012 08:23 PM, ext-denis.2.karpov@nokia.com wrote:
> ext Shubhrajyoti wrote on 2012-01-16:
>> On Monday 16 January 2012 06:41 PM, ext-denis.2.karpov@nokia.com wrote:
>>> ext Shubhrajyoti D wrote on 2012-01-16:
>>>> The commit 11dd62:[omap_hsmmc: context save/restore support]
>>>>
>>>> does a reset and restores AUTOIDLE settings.
>>>> This patch saves the register does a reset and restores
>>>> the same configuration.
>>> ...
>>>>  	if (pdata->get_context_loss_count) {
>>>> @@ -700,6 +700,7 @@ static int omap_hsmmc_context_restore(struct
>>>> omap_hsmmc_host *host)
>>>>  		&& time_before(jiffies, timeout)) 		; +	sysc =
>>>>  OMAP_HSMMC_READ(host->base, SYSCONFIG); 	/* Do software reset */
>>>>  	OMAP_HSMMC_WRITE(host->base, SYSCONFIG, SOFTRESET); 	timeout =
>>>>  jiffies + msecs_to_jiffies(MMC_TIMEOUT_MS);
>>>> @@ -707,8 +708,7 @@ static int omap_hsmmc_context_restore(struct
>>>> omap_hsmmc_host *host)
>>>>  		&& time_before(jiffies, timeout))
>>>>  		;
>>>> -	OMAP_HSMMC_WRITE(host->base, SYSCONFIG,
>>>> -			OMAP_HSMMC_READ(host->base, SYSCONFIG) | AUTOIDLE);
>>>> +	OMAP_HSMMC_WRITE(host->base, SYSCONFIG, sysc);
>>> The meaning of the code is to restore the register context after it was lost
>> during transition into low power consumption state. SW reset is needed to bring
>> all the registers in a consistent state before reconfiguring some of them.
>> Agreed thanks.
>>> Saving and restoring the SYSCONFIG register across SW reset is not needed.
>>>
>>> Also re-configuring AUTOIDLE feature is not necessary since SYSCONFIG reset
>> value has is 1 already, according to TRM. I guess it was done to make things
>> more explicit.
>> However in addition to autoidle there are other bits in the register
>> like the sidle mode , enable wakeup which will get not get overwritten now.
>>
>> Do you agree?
> No, there's no need to do that - after SW reset the registers have predefined reset values; the reset value is correct in case of SYSCONFIG register for most of omap3|4 boards based, doesn't need any update after SW reset.
>
> If in case of your board the reset value of SYSCONFIG register is not what you want - you still cannot rely on the contents of the SYSCONFIG register once the context was lost, i.e. saving its value before SW reset doesn't help. 
> You would need to initialize it to the proper value after the SW reset manually, probably the same value that you used during initialization.

if you check the following code
arch/arm/mach-omap2/omap_hwmod_44xx_data.c

/*
 * 'mmc' class
 * multimedia card high-speed/sd/sdio (mmc/sd/sdio) host controller
 */

static struct omap_hwmod_class_sysconfig omap44xx_mmc_sysc = {
        .rev_offs       = 0x0000,
        .sysc_offs      = 0x0010,
        .sysc_flags     = (SYSC_HAS_EMUFREE | SYSC_HAS_MIDLEMODE |
                           SYSC_HAS_RESET_STATUS | SYSC_HAS_SIDLEMODE |
                           SYSC_HAS_SOFTRESET),
        .idlemodes      = (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
                           SIDLE_SMART_WKUP | MSTANDBY_FORCE | MSTANDBY_NO |
                           MSTANDBY_SMART | MSTANDBY_SMART_WKUP),
        .sysc_fields    = &omap_hwmod_sysc_type2,

<>
arch/arm/mach-omap2/omap_hwmod.c

 * upon error or 0 upon success.
 */
static int _enable_wakeup(struct omap_hwmod *oh, u32 *v)
{
        if (!oh->class->sysc ||
            !((oh->class->sysc->sysc_flags & SYSC_HAS_ENAWAKEUP) ||
              (oh->class->sysc->idlemodes & SIDLE_SMART_WKUP) ||
              (oh->class->sysc->idlemodes & MSTANDBY_SMART_WKUP)))
                return -EINVAL;

        if (!oh->class->sysc->sysc_fields) {
                WARN(1, "omap_hwmod: %s: offset struct for sysconfig not
provided in class\n", oh->name);
                return -EINVAL;
        }

        if (oh->class->sysc->sysc_flags & SYSC_HAS_ENAWAKEUP)
                *v |= 0x1 << oh->class->sysc->sysc_fields->enwkup_shift;

        if (oh->class->sysc->idlemodes & SIDLE_SMART_WKUP)
                _set_slave_idlemode(oh, HWMOD_IDLEMODE_SMART_WKUP, v);
        if (oh->class->sysc->idlemodes & MSTANDBY_SMART_WKUP)
                _set_master_standbymode(oh, HWMOD_IDLEMODE_SMART_WKUP, v);

however, I agree we could use hwmod framework to reset.


> Denis

