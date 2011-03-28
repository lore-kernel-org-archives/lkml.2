Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519Ab1C1XK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 19:10:59 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:36109 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752598Ab1C1XK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 19:10:57 -0400
Message-ID: <4D91157F.2020502@linux.vnet.ibm.com>
Date: Mon, 28 Mar 2011 19:10:55 -0400
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Jeff Layton <jlayton@poochiereds.net>
CC: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
Subject: Re: TPM chip prevents machine from suspending
References: <20110328100846.0ba2e039@tlielax.poochiereds.net> <4D90C472.3090908@linux.vnet.ibm.com> <20110328141241.06a435f8@tlielax.poochiereds.net> <20110328154543.1bb979fd@tlielax.poochiereds.net>
In-Reply-To: <20110328154543.1bb979fd@tlielax.poochiereds.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2011 03:45 PM, Jeff Layton wrote:
> On Mon, 28 Mar 2011 14:12:41 -0400
> Jeff Layton<jlayton@poochiereds.net>  wrote:
>
>> On Mon, 28 Mar 2011 13:25:06 -0400
>> Stefan Berger<stefanb@linux.vnet.ibm.com>  wrote:
>>
>>> On 03/28/2011 10:08 AM, Jeff Layton wrote:
>>>> My wife's machine apparently has a TPM chip in it. Since I upgraded it
>>>> to Fedora 14, it fails to suspend consistently. On the first attempt to
>>>> suspend it, it works fine. Once it has woken back up however, it will
>>>> not suspend again. Here's the dmesg log from such an attempt:
>>>>
>>>> [  202.460967] PM: Syncing filesystems ... done.
>>>> [  202.464818] PM: Preparing system for mem sleep
>>>> [  202.485968] Freezing user space processes ... (elapsed 0.01 seconds) done.
>>>> [  202.497079] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
>>>> [  202.508067] PM: Entering mem sleep
>>>> [  202.508086] Suspending console(s) (use no_console_suspend to debug)
>>>> [  202.508451] sd 3:0:0:0: [sdb] Synchronizing SCSI cache
>>>> [  202.508562] sd 2:0:0:0: [sda] Synchronizing SCSI cache
>>>> [  202.508616] sd 3:0:0:0: [sdb] Stopping disk
>>>> [  202.511956] parport_pc 00:0b: disabled
>>>> [  202.512127] serial 00:09: disabled
>>>> [  202.512134] serial 00:09: wake-up capability disabled by ACPI
>>>> [  202.536058] legacy_suspend(): pnp_bus_suspend+0x0/0x82 returns 38
>>>> [  202.536061] PM: Device 00:02 failed to suspend: error 38
>>>> [  202.997517] sd 2:0:0:0: [sda] Stopping disk
>>>> [  202.997806] PM: Some devices failed to suspend
>>>> [  202.998085] sd 2:0:0:0: [sda] Starting disk
>>>> [  202.998144] sd 3:0:0:0: [sdb] Starting disk
>>>> [  202.998614] serial 00:09: activated
>>>> [  202.999158] parport_pc 00:0b: activated
>>>> [  204.543094] PM: resume of devices complete after 1545.282 msecs
>>>> [  204.543268] PM: Finishing wakeup.
>>>> [  204.543270] Restarting tasks ... done.
>>>>
>>>> ...error 38 is ENOSYS, and the 00:02 is this:
>>>>
>>>> # cat /sys/bus/pnp/devices/00\:02/id
>>>> IFX0102
>>>> PNP0c31
>>> Also the tpm_tis driver handles both of these. Can you confirm which
>>> module that laptop was using  (tpm_tis or tpm_infineon) and try whether
>>> one of them works better than the other one? Please do a reboot between
>>> trying one and then the other.
>>>
>> It's using tpm_tis:
>>
>> lrwxrwxrwx. 1 root root 0 Mar 28 13:40 /sys/bus/pnp/devices/00:02/driver ->  ../../../bus/pnp/drivers/tpm_tis
>>
>> FWIW, the fedora kernels have this:
>>
>> CONFIG_TCG_TPM=y
>> CONFIG_TCG_TIS=y
>> CONFIG_TCG_NSC=m
>> CONFIG_TCG_ATMEL=m
>> CONFIG_TCG_INFINEON=m
>>
>> When I boot, tpm_infineon is also plugged in, but I can remove that
>> module and nothing seems to change (not sure what's plugging it in).
>>
>> I can try using tpm_infineon, but I'm not sure how to disable tpm_tis
>> with it compiled in like this -- is that possible?
>>
>>> Try the following before and after a suspend/resume:
>>>
>>> cd /sys
>>> find . | grep caps$ | xargs cat
>>>
>>> It should display manufacturer data.
>>>
>> There's only one "caps" file. Here's the before (after a fresh reboot):
>>
>> # cat ./devices/pnp0/00:02/caps
>> Manufacturer: 0x49465800
>> TCG version: 1.2
>> Firmware version: 1.0
>>
>> ...after a successful suspend/resume cycle:
>>
>> # cat ./devices/pnp0/00:02/caps
>>
>> ...it gives no output at all. Guess that lends some weight to the
>> theory of it not being reset properly on resume?
>>
>> Thanks for the help so far...
> FWIW, I turned up dynamic debugging on the tpm files and got this in
> the ring buffer when I tried to read from "caps":
>
> [ 6880.495071] tpm_tis 00:02: A TPM error (38) occurred attempting to determine the manufacturer
>
> I don't see any obvious places that return ENOSYS in the tpm code, so
> I'm not clear on where that's coming from...
>
Ok, so this error code means TPM_INVALID_POSTINIT  (not a posix code) 
and means that this command was received in the wrong sequence relative 
to a TPM_Startup command. Well, what's supposed to be happening is this:

When the machines (S3) suspends then the OS needs to send a 
TPM_SaveState() to the TPM. This is done by the Linux driver. Once the 
VM resumes, the BIOS is supposed to send a TPM_Startup(ST_STATE) to the TPM.

Now the fun starts when a BIOS isn't doing that (even though the spec 
says it's supposed to), which could very well be the case in your case 
(don't know what broken BIOSes are out there...  Did it ever work before 
with the TPM driver in the kernel ?). I could try to send you a small 
tool that you would have to run from user space upon resume so that we 
can see that this error goes away. If that's verified we could 
subsequently write a patch for the TPM driver to also send the 
TPM_Startup(ST_STATE) to the TPM, which then in the case of most BIOSes 
would be the 2nd time that the TPM receives such a command. I think TPMs 
should be able to digest this 2nd TPM_Startup() well, but I'd have to 
check -- but really we would ill-fix it just because of one (possibly) 
buggy BIOS.

The failure of the 2nd suspend then likely stems from the TPM not 
accepting the TPM_SaveState() anymore since it hasn't seen the 
TPM_Startup(ST_STATE) that we expected the BIOS to send.

Another possibility would be for you to check for BIOS updates from the 
laptop manufacturer...

    Stefan

