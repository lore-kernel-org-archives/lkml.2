Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932837Ab2LGQOL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 11:14:11 -0500
Received: from mail.ch.keymile.com ([193.17.201.103]:48964 "HELO
	mail.ch.keymile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932795Ab2LGQOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 11:14:10 -0500
X-Greylist: delayed 723 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Dec 2012 11:14:09 EST
Message-ID: <50C212E6.9010200@keymile.com>
Date: Fri, 07 Dec 2012 17:01:42 +0100
From: Gerlando Falauto <gerlando.falauto@keymile.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121120 Thunderbird/10.0.11
MIME-Version: 1.0
To: Sergei Trofimovich <slyich@gmail.com>
CC: Ian Campbell <ijc@hellion.org.uk>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: arm: CONFIG_ARM_PATCH_PHYS_VIRT=y is broken on kirkwood
References: <20120408115920.4d7d2197@sf.home> <1334006908.12209.150.camel@dagon.hellion.org.uk> <20120410211210.310b65ea@sf.home>
In-Reply-To: <20120410211210.310b65ea@sf.home>
Content-Type: text/plain;
	charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Dec 2012 16:01:42.0658 (UTC) FILETIME=[264F1E20:01CDD494]
X-ESAFE-STATUS: [srvchber1306.keymile.net] Mail allowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

On 04/10/2012 08:12 PM, Sergei Trofimovich wrote:
> On Mon, 09 Apr 2012 22:28:28 +0100
> Ian Campbell<ijc@hellion.org.uk>  wrote:
>
>> On Sun, 2012-04-08 at 11:59 +0300, Sergei Trofimovich wrote:
>>> In order to make the box boot I had to set:
>>>      CONFIG_EMBEDDED=y
>>>      # CONFIG_ARM_PATCH_PHYS_VIRT is not set
>>>     CONFIG_PHYS_OFFSET=0x0
>>>
>>> Do you have an idea why it does not boot anymore by default?
>>
>> There is a u-boot commit which fixes this issue:
>>
>> commit 679530278d5a79d34e356ad2d452f4400953bfc2
>> Author: Michael Walle<[michael@walle.cc]>
>> Date:   Mon Feb 6 22:42:10 2012 +0530
>>
>>      arm, arm-kirkwood: disable l2c before linux boot
>>
>>      The decompressor expects the L2 cache to be disabled. This fixes booting
>>      some kernels, which have CONFIG_ARM_PATCH_PHYS_VIRT enabled.
>>
>>      Signed-off-by: Michael Walle<michael@walle.cc>
>>      Acked-by: Prafulla Wadaskar<prafulla@marvell.com>
>>      Cc: Albert ARIBAUD<albert.u.boot@aribaud.net>
>>      Cc: Prafulla Wadaskar<prafulla@marvell.com>
>>      Cc: Wolfgang Denk<wd@denx.de>
>
> Thank you, Ian. Updating u-boot helped!
>
> Sorry for the noise.

I guess if updating u-boot is not an option, there's no other way around 
it than disabling CONFIG_ARM_PATCH_PHYS_VIRT altogether.

Could someone (Russell?) simply state what the consequences are of 
disabling such option? (Or, conversely, what its advantages are?)
Only reference I found is the original commit, but I couldn't really 
understand what it does (or to what purpose), see at the bottom.

Thank you very much!
Gerlando

commit dc21af99fadcfa0ae65b52fd0895f85824f0c288
Author: Russell King <rmk+kernel@arm.linux.org.uk>
Date:   Tue Jan 4 19:09:43 2011 +0000

     ARM: P2V: introduce phys_to_virt/virt_to_phys runtime patching

     This idea came from Nicolas, Eric Miao produced an initial version,
     which was then rewritten into this.

     Patch the physical to virtual translations at runtime.  As we modify
     the code, this makes it incompatible with XIP kernels, but allows us
     to achieve this with minimal loss of performance.

     As many translations are of the form:

         physical = virtual + (PHYS_OFFSET - PAGE_OFFSET)
         virtual = physical - (PHYS_OFFSET - PAGE_OFFSET)

     we generate an 'add' instruction for __virt_to_phys(), and a 'sub'
     instruction for __phys_to_virt().  We calculate at run time 
(PHYS_OFFSET
     - PAGE_OFFSET) by comparing the address prior to MMU initialization 
with
     where it should be once the MMU has been initialized, and place this
     constant into the above add/sub instructions.

     Once we have (PHYS_OFFSET - PAGE_OFFSET), we can calculate the real
     PHYS_OFFSET as PAGE_OFFSET is a build-time constant, and save this for
     the C-mode PHYS_OFFSET variable definition to use.

     At present, we are unable to support Realview with Sparsemem enabled
     as this uses a complex mapping function, and MSM as this requires a
     constant which will not fit in our math instruction.

     Add a module version magic string for this feature to prevent
     incompatible modules being loaded.

     Tested-by: Tony Lindgren <tony@atomide.com>
     Reviewed-by: Nicolas Pitre <nicolas.pitre@linaro.org>
     Tested-by: Nicolas Pitre <nicolas.pitre@linaro.org>
     Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>


