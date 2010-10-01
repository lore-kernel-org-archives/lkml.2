Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775Ab0JAQfZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 12:35:25 -0400
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:55459 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab0JAQfY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 12:35:24 -0400
Subject: Re: [PATCH 1/3] TPM: new stm i2c device driver
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
In-Reply-To: <0B9F1C5B86169C4EA9D042C251022E49105CEE8FD0@SAFEX1MAIL3.st.com>
Date: Fri, 1 Oct 2010 13:35:16 -0300
Cc: James Morris <jmorris@namei.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "joe@perches.com" <joe@perches.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <4766E5FA-4D3F-4A1B-B3C7-C1BE976A240B@linux.vnet.ibm.com>
References: <cover.1285870690.git.srajiv@linux.vnet.ibm.com> <e828eb98bf5b36fea2bd89760d7bc3cf3d5b6755.1285870690.git.srajiv@linux.vnet.ibm.com> <alpine.LRH.2.00.1010011049370.32042@tundra.namei.org> <0B9F1C5B86169C4EA9D042C251022E49105CEE8F7E@SAFEX1MAIL3.st.com> <C6A315B5-15D9-4DD1-8F1D-2E3D3EC36E70@linux.vnet.ibm.com> <0B9F1C5B86169C4EA9D042C251022E49105CEE8FD0@SAFEX1MAIL3.st.com>
To: Christophe Henri RICARD <christophe-h.ricard@st.com>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christophe,

On 01/10/2010, at 12:44, Christophe Henri RICARD wrote:

> Hi Rajiv,
> 
> I had implemented the ioctl function with TPMIOC_CANCEL/TPMIOC_TRANSMIT because I have seen that when I was trying to run a TSS tcsd(trousers) process some errors or warning messages were displayed.
> I have just checked the trousers source code I have and it use this way in src/tddl/tddl.c .
> 

Trousers supports both methods, device read/write or through ioctl, the warning just notifies that the second isn't going to be used due the device driver's lack of support.

> For your information also, the 2 buffers tpm_i2c_buffer instead of the data buffer in my driver was because I found what I suppose to be an error with the allocation of chip->data_buffer in the tpm_open function.
> When I have done the following test with the tpm_tis driver for example on a pc platform (x86) with a TPM:
> - No TPM application launch such as TSS (trousers).
> - Put the platform in standby
> - Wake up the platform
> dmesg will shows an error during suspend/resume functions execution.
> My understanding is that in that specific case, no buffer is allocated and the driver couldn't save the TPM context (TPM_SaveState).

Sounds like an issue, thanks for reporting, I'll double check/debug this.

> In the case the platform generate a RESET on the LPC bus or on the TPM during standby all the TPM volatile context will be cleared 
> (all the PCR's for example). I think this could be a problem.
> Only for my information, I would like to know if this scenario (TPM RESET during standby) could happen and if it could be a TPM/security issue.

As long as it implies in occurring a full power cycle, it isn't a TPM problem.

> 
> I suppose what you are calling security-next tree is linux-next tree on www.kernel.org or are you referring to another tree ?
> I will try to provide you a patch for the ioctl function asap.
> 

I'm using this one as security-next:
git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/jamesm-security-next.git

Thanks,
Rajiv

> 
> 
> -----Original Message-----
> From: Rajiv Andrade [mailto:srajiv@linux.vnet.ibm.com] 
> Sent: Friday, October 01, 2010 10:26 AM
> To: Christophe Henri RICARD
> Cc: James Morris; linux-kernel@vger.kernel.org; joe@perches.com
> Subject: Re: [PATCH 1/3] TPM: new stm i2c device driver
> 
> Hi Christophe,
> 
> The code must be applied and compiled against the security-next tree, that currently doesn't provide the locked ioctl anymore. Can you implement the locking inside tpm_st19_i2c_ioctl() and set it at the unlocked_ioctl field? Shouldn't be too hard, you can get tpm_write() as an example.
> 
> By the way, I may be missing something, but why the tpm command transmission (TPMIOC_TRANSMIT) should be handled through ioctl instead of a modified tpm_write() that can send the commands through i2c?
> 
> Thanks,
> Rajiv
> 
> On 01/10/2010, at 11:27, Christophe Henri RICARD wrote:
> 
>> Hi James,
>> 
>> Which kernel are you using ?
>> I have made my testing with a 2.6.35.4 kernel.
>> As far as I know kernel 2.6.36 will not provide any ioctl field any more.
>> May be this is the reason ?
>> 
>> Please let me know.
>> Thanks
>> Christophe
>> 
>> -----Original Message-----
>> From: James Morris [mailto:jmorris@namei.org] 
>> Sent: Thursday, September 30, 2010 7:51 PM
>> To: Rajiv Andrade
>> Cc: linux-kernel@vger.kernel.org; joe@perches.com; Christophe Henri RICARD
>> Subject: Re: [PATCH 1/3] TPM: new stm i2c device driver
>> 
>> On Thu, 30 Sep 2010, Rajiv Andrade wrote:
>> 
>>> From: Christophe Henri RICARD <christophe-h.ricard@st.com>
>>> 
>>> This driver uses the Linux I2C, TPM and generic gpio interfaces.
>>> 
>>> Signed-off-by: Christophe Henri RICARD <christophe-h.ricard@st.com>
>>> Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
>> 
>> This does not look to have been compile tested against my tree:
>> 
>> CC [M]  drivers/char/tpm/tpm_stm_st19_i2c.o
>> drivers/char/tpm/tpm_stm_st19_i2c.c:574: error: unknown field ioctl specified in initializer
>> drivers/char/tpm/tpm_stm_st19_i2c.c:574: warning: initialization from incompatible pointer type
>> make[1]: *** [drivers/char/tpm/tpm_stm_st19_i2c.o] Error 1
>> 
>> The locked ioctl was removed in commit
>> b19dd42faf413b4705d4adb38521e82d73fa4249
>> 
>> 
>> 
>> - James
>> -- 
>> James Morris
>> <jmorris@namei.org>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> 

