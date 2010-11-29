Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab0K2PmA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 10:42:00 -0500
Received: from e24smtp03.br.ibm.com ([32.104.18.24]:55874 "EHLO
	e24smtp03.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315Ab0K2Pl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 10:41:59 -0500
Message-ID: <4CF3C9BB.20802@linux.vnet.ibm.com>
Date: Mon, 29 Nov 2010 13:41:47 -0200
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Debora Velarde <debora@linux.vnet.ibm.com>,
        Marcel Selhorst <m.selhorst@sirrix.com>, linux-kernel@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net, "Rafael J. Wysocki" <rjw@suse.com>,
        jmorris@namei.org, mjg@redhat.com
Subject: Re: [REGRESSION] Suspend fails because of TPM modules
References: <alpine.LNX.2.00.1011291554570.981@pobox.suse.cz> <alpine.LNX.2.00.1011291614060.981@pobox.suse.cz> <4CF3C547.6020302@linux.vnet.ibm.com> <alpine.LNX.2.00.1011291625120.981@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1011291625120.981@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2010 01:26 PM, Jiri Kosina wrote:
> On Mon, 29 Nov 2010, Rajiv Andrade wrote:
>
>>>> on my thinkpad x200s (and I have seen reports on different HW as well),
>>>> suspend fails when TPM modules are loaded.
>>>>
>>>> 	tpm_tis 00:0a: tpm_transmit: tpm_send: error -5
>>>> 	legacy_suspend(): pnp_bus_suspend+0x0/0xa0 returns -5
>>>> 	PM: Device 00:0a failed to suspend: error -5
>>>> 	PM: Some devices failed to suspend
>>>>
>>>> Once tpm, tpm_bios, tpm_tis and tpm modules are unloaded, suspend/resume
>>>> works.
>>>>
>>>> This is a regression. It definitely worked on this very same hardware on
>>>> 2.6.34. Any kernel between .34 and .37 wasn't booted there, so I don't
>>>> have any data of that kind.
>>>>
>>>> I can try bisecting it, but if anyone sees immediately what the culprit
>>>> might be, that'd be helpful.
>>> I just found out, that if I modprobe tpm_tis module with
>>>
>>> 	itpm=1
>>>
>>> parameter, the problem doesn't happen any more and suspend works fine.
>>>
>>> This definitely wasn't needed on older kernels though, so I'd consider
>>> that still a regression.
>>>
>>> Also, can't we make the module automatically detect the machines on which
>>> to apply the workaround? Let's say, based on DMI?
>>>
>> There's a patch already submitted that solves this:
>> http://marc.info/?l=linux-kernel&m=128769741101534&w=2
>> <http://marc.info/?l=linux-kernel&m=128769741101534&w=2>
>>
>> This side effect (to solve the suspend issue) should increase its urgency I
>> think.
>> James, any thoughts?
> Yeah, Matthew has already pointed me to that patch, thanks. I will be
> testing it shortly and providing my Tested-by: eventually.
>
> Any ideas why other kernels were OK (.34) and didn't require this quirk on
> my machine at all?
>
The TPM device driver wasn't probably being built/loaded, can you check 
that?
The device driver must send the TPM a command prior to suspend to save 
its state, what's happening here is that this particular model, iTPM, 
doesn't change the status register as expected to acknowledge the code 
that a send command operation finished successfully, the driver then 
returns -EIO. The same obviously happens during suspend, returning 
failure to save its state, since the command the driver sent to do so 
failed, halting the suspend operation.

Matthew's patch implements automatic detection of such TPMs so that a 
workaround implemented in a previous commit can be activated to bypass 
that status register check, making the device usable and therefore able 
to save its state when asked to by the device driver during suspend.

Rajiv
