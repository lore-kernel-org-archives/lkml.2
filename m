Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573Ab2DFVbs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 17:31:48 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61506 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861Ab2DFVbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 17:31:47 -0400
Message-ID: <4F7F60BF.9070500@suse.cz>
Date: Fri, 06 Apr 2012 23:31:43 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120404 Thunderbird/13.0a2
MIME-Version: 1.0
To: Chris Wilson <chris@chris-wilson.co.uk>
CC: Jiri Slaby <jirislaby@gmail.com>, Keith Packard <keithp@keithp.com>,
        dri-devel@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>,
        daniel@ffwll.ch, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: i915_driver_irq_handler: irq 42: nobody cared [generic IRQ handling
 broken?]
References: <4F717CE3.4040206@suse.cz> <4F717D80.9040207@suse.cz> <4F758400.3080907@suse.cz> <1333104359_155028@CP5-2952> <4F75A303.3030409@suse.cz> <1333110296_156038@CP5-2952>
In-Reply-To: <1333110296_156038@CP5-2952>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2012 02:24 PM, Chris Wilson wrote:
> On Fri, 30 Mar 2012 14:11:47 +0200, Jiri Slaby <jslaby@suse.cz> wrote:
>> On 03/30/2012 12:45 PM, Chris Wilson wrote:
>>> On Fri, 30 Mar 2012 11:59:28 +0200, Jiri Slaby <jslaby@suse.cz> wrote:
>>>> I don't know what to dump more, because iir is obviously zero too. What
>>>> other sources of interrupts are on the (G33) chip?
>>>
>>> IIR is the master interrupt, with chained secondary interrupt statuses.
>>> If IIR is 0, the interrupt wasn't raised by the GPU.
>>
>> This does not make sense, the handler does something different. Even if
>> IIR is 0, it still takes a look at pipe stats.
> 
> That was introduced in 05eff845a28499762075d3a72e238a31f4d2407c to close
> a race where the pipestat triggered an interrupt after we processed the
> secondary registers and before reseting the primary.
> 
> But the basic premise that we should only enter the interrupt handler
> with IIR!=0 holds (presuming non-shared interrupt lines such as MSI).

Ok, this behavior is definitely new. I get several "nobody cared" about
this interrupt a week. This never used to happen. And something weird
emerges in /proc/interrupts when this happens:
 42:    1003292    1212890   PCI-MSI-edge      �s����:0000:00:02.0
instead of
 42:    1006715    1218472   PCI-MSI-edge      i915@pci:0000:00:02.0

It very looks like the generic IRQ handling code is broken. Like it
frees/corrupts irq_desc and then as well calls random handlers.

Suspend/resume cycle helps in this case and "i915@pci:0000:00:02.0" is
back in /proc/interrupts as can be seen above.

Running 3.3.0-next-20120326_64+ now.

thanks,
-- 
js
suse labs

