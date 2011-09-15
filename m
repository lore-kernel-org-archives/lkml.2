Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612Ab1IORJn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 13:09:43 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:57916 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756479Ab1IORJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 13:09:41 -0400
From: Kevin Hilman <khilman@ti.com>
To: "Koyamangalath\, Abhilash" <abhilash.kv@ti.com>
Cc: "linux-omap\@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tony\@atomide.com" <tony@atomide.com>,
        "linux\@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "Lohithakshan\, Ranjith" <ranjithl@ti.com>
Subject: Re: [PATCH 1/4] AM3517 : support for suspend/resume
Organization: Texas Instruments, Inc.
References: <1313754927-11992-1-git-send-email-abhilash.kv@ti.com>
	<1313754927-11992-2-git-send-email-abhilash.kv@ti.com>
	<87fwkild5k.fsf@ti.com>
	<FCCFB4CDC6E5564B9182F639FC356087037B3D8823@dbde02.ent.ti.com>
	<8739g0b8sa.fsf@ti.com>
	<FCCFB4CDC6E5564B9182F639FC356087037AF843DD@dbde02.ent.ti.com>
Date: Thu, 15 Sep 2011 10:09:32 -0700
In-Reply-To: <FCCFB4CDC6E5564B9182F639FC356087037AF843DD@dbde02.ent.ti.com>
	(Abhilash Koyamangalath's message of "Wed, 14 Sep 2011 18:30:51
	+0530")
Message-ID: <87wrd97mwj.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Koyamangalath, Abhilash" <abhilash.kv@ti.com> writes:

> hi  Kevin
>
> On Tue, Sep 13, 2011 at 11:54 PM, Hilman, Kevin wrote:
>> Hi Abhilash,
>>
>> "Koyamangalath, Abhilash" <abhilash.kv@ti.com> writes:
>>
>>> Hi
>>>
>>> On Wed, Aug 31, 2011 at 4:28 AM, Hilman, Kevin wrote:
>>>>
>>>> Abhilash K V <abhilash.kv@ti.com> writes:
>>>>
> <snip>
>>>>
>>>> In addition to Russell's comments about using the latest code from
>>>> mainline, I have some comments below.
>>> [Abhilash K V] I have reworked the patch against the tip (as suggested by
>>> Russell).
>>> And I've incorporated all of Kevin's comments too.
>>
>> Great, thanks!
>>
>>> There is one "known" issue left which needs to be closed before I can submit v2 of this patch.
>>> With no_console_suspend, suspend to RAM hangs right now on AM3517, after
>>> the message:
>>>           Disabling non-boot CPUs ...
>>> There is no error message or dump.
>>> I found that this crash is happening in a call to pr_warning(), from _omap_device_deactivate().
>>> The same code does not produce this issue on omap34xx due to this snippet from omap_sram_idle() :
>>>         /* PER */
>>>         if (per_next_state < PWRDM_POWER_ON) {
>>>                 per_going_off = (per_next_state == PWRDM_POWER_OFF) ? 1 : 0;
>>>                 omap_uart_prepare_idle(2);
>>>                 omap_uart_prepare_idle(3);
>>>                 omap2_gpio_prepare_for_idle(per_going_off);
>>>                 if (per_next_state == PWRDM_POWER_OFF)
>>>                                 omap3_per_save_context();
>>>         }
>>>         /* CORE */
>>>         if (core_next_state < PWRDM_POWER_ON) {
>>>                 omap_uart_prepare_idle(0);
>>>                 omap_uart_prepare_idle(1);
>>>                 if (core_next_state == PWRDM_POWER_OFF) {
>>>                         omap3_core_save_context();
>>>                         omap3_cm_save_context();
>>>                 }
>>>         }
>>> This happens in preparation to the suspend operation (I,e. the WFI).
>>> As seen here, on 34xx the sequence in which the uarts are disabled is 2, 3, 0 and 1.The console-uart, which is uart-1 here (starting from uart-0) is disabled last.
>>
>>> For AM3517 EVM, the console-uart is uart-2 and this ought to be
>>> disabled at the last to prevent this crash from occurring.
>>
>> There are several other OMAP3 platforms (n900, Beagle, etc.) where the
>> UART console is also UART2, so console ordering is not the problem.
>
> [Abhilash K V] OK. Yet changing the order so that uart-2 is disabled
> at the last seems to rid me of the crash on AM35x.  I understand that
> holding the console_sem before suspend (your fix below) is the way to
> go, but I'm just curious over what's happening here.  

You're unlucky.  :)

Each time an omap_device is disabled, we print a message if it's a new
worst case value.

What's happening to you is that one of the UARTs disabled after the
console is getting a new worst case value.  Because of the missing
console locking, it's trying to write to the console, and boom.

> Simply put what is the rationale behind choosing this order of
> UART-disables ?

The order is not important at all.

Changing the order might fix this problem for your current situation,
but the same problem could pop up elsewhere.

In fact, even if you disable the console UART last, we can still try to
print the "new worst case" messages after the console is disabled.
That's why the console locking is important.

>>
>> The fact that that pr_warning is making it to the console suggests that
>> the console is not locked.  In the idle path, we take the console lock
>> (using console_trylock(), just above the code you showed above.)
>>
>> But during suspend, there was an assumption (by me[2]) that the console
>> would always be locked in the suspend path.  During no_console_suspend,
>> it appears that is not the case.
>>
>> Can you try the patch below[1] to see if that fixes your problem?  I
>> think it should.
> [Abhilash K V] Yes it does, thanks.

Great, thanks for testing.  I'll add a Tested-by for you, and post it
to the list.  

Kevin
