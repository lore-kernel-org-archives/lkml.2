Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab0EGDDz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 23:03:55 -0400
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:50663 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350Ab0EGDDy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 23:03:54 -0400
Subject: Re: [PATCH] TPM: ACPI/PNP dependency removal
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
In-Reply-To: <20100504150026.907f3ed3.randy.dunlap@oracle.com>
Date: Fri, 7 May 2010 00:03:47 -0300
Cc: linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com, jmorris@namei.org
Content-Transfer-Encoding: 8BIT
Message-Id: <6449985E-CFA7-4974-B1D0-19626102B5BD@linux.vnet.ibm.com>
References: <1273009760.3532.41.camel@blackbox.ibm.com> <20100504150026.907f3ed3.randy.dunlap@oracle.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
X-Mailer: Apple Mail (2.1078)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 4, 2010, at 7:00 PM, Randy Dunlap wrote:

> On Tue, 04 May 2010 18:49:20 -0300 Rajiv Andrade wrote:
> 
>> This patch pushes the ACPI dependency into the device driver code
>> itself. Now, even without ACPI/PNP enabled, the device can be registered
>> using the TIS specified memory space. This will however result in the
>> lack of access to the bios event log, being the only implication of such
>> ACPI removal.
>> 
>> Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
>> Acked-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
>> ---
>> drivers/char/tpm/Kconfig   |   14 +++++++++++---
>> drivers/char/tpm/tpm_tis.c |   42 ++++++++++++++++++++++--------------------
>> 2 files changed, 33 insertions(+), 23 deletions(-)
>> 
>> diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
>> index f5fc64f..0a9ec0b 100644
>> --- a/drivers/char/tpm/Kconfig
>> +++ b/drivers/char/tpm/Kconfig
>> @@ -17,20 +17,28 @@ menuconfig TCG_TPM
>> 	  obtained at: <http://sourceforge.net/projects/trousers>.  To 
>> 	  compile this driver as a module, choose M here; the module 
>> 	  will be called tpm. If unsure, say N.
>> -	  Note: For more TPM drivers enable CONFIG_PNP, CONFIG_ACPI
>> -	  and CONFIG_PNPACPI.
>> +	  Note: For more TPM drivers and BIOS LOG access enable 
>> +	  CONFIG_PNP, CONFIG_ACPI and CONFIG_PNPACPI.
>> 
>> if TCG_TPM
>> 
>> config TCG_TIS
>> 	tristate "TPM Interface Specification 1.2 Interface"
>> -	depends on PNP
>> 	---help---
>> 	  If you have a TPM security chip that is compliant with the
>> 	  TCG TIS 1.2 TPM specification say Yes and it will be accessible
>> 	  from within Linux.  To compile this driver as a module, choose
>> 	  M here; the module will be called tpm_tis.
>> 
>> +config TCG_BIOS_LOG
>> +	bool "TPM bios mesurement log"
> 
> 	          BIOS measurement
> 
>> +	depends on X86
>> +	select ACPI
>> +	---help---
>> +	  ACPI is required for access to bios measurements lists and therefore
> 
> 	                                 BIOS
> 
> and if I had any say-so, I would Nack this part of the patch.
> Selecting ACPI adds a huge amount of code, so it should just depend on ACPI IMO.
> 
> Also, ACPI depends on PCI and PM, so if this "select" part remains,
> this should be more like:
> 
> 	  depends on X86 && PCI && PM
> 
> (unless that's already enforced somewhere else).

Ok, this option here was just to enforce the warning 'You won't be able to validate PCRs 0-7 if without ACPI enabled'. I'll then just document this and remove this option. In the end, we'll be left with the ACPI code and Kconfig dependency removal from the TPM device driver.

Thanks,
Rajiv

