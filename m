Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297Ab0CRXeY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 19:34:24 -0400
Received: from mail-fx0-f219.google.com ([209.85.220.219]:42739 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107Ab0CRXeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 19:34:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Rp/9Fcr64IaB1piOH3DJU/GXCvNZYjBnnX0z+CILkmOC3h2hQ28MrfwJxHErFQ4qKi
         G0EBJPLGNYf15DJRgVyu7jOlv7HA6MHcJ990PYsoRqFmMikQKHHz6eOuIrHndV1U/X6z
         FMNyIgSWIljzIbhudVC9G4tix6mrHUkkZr7p0=
Message-ID: <4BA2B87E.8050404@googlemail.com>
Date: Fri, 19 Mar 2010 00:34:22 +0100
From: =?UTF-8?B?UmVuw6kgQm9sbGRvcmY=?= <xsecute@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] drivers/pci/pci.c Section mismatch
References: <4BA2A46E.5090008@googlemail.com> <4BA2B028.8060705@oracle.com>
In-Reply-To: <4BA2B028.8060705@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/10 23:58, Randy Dunlap wrote:
> On 03/18/10 15:08, Ren� Bolldorf wrote:
>> Signed-off-by: Rene Bolldorf<xsecute@googlemail.com>
>>
>> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
>> index ddd55dc..a1f7d93 100644
>> --- a/drivers/pci/pci.c
>> +++ b/drivers/pci/pci.c
>> @@ -2773,7 +2773,7 @@ int pci_resource_bar(struct pci_dev *dev, int
>> resno, enum pci_bar_type *type)
>>   /* Some architectures require additional programming to enable VGA */
>>   static arch_set_vga_state_t arch_set_vga_state;
>>
>> -void __init pci_register_set_vga_state(arch_set_vga_state_t func)
>> +void pci_register_set_vga_state(arch_set_vga_state_t func)
>>   {
>>       arch_set_vga_state = func;    /* NULL disables */
>>   }
>> --
>
> Hi,
>
> Please put the offending/warning messages in the patch description.
> Include your analysis if it isn't obvious.
>
> thanks,

Hi,

the warning message was:
WARNING: drivers/pci/built-in.o(__ksymtab+0x190): Section mismatch in 
reference from the variable __ksymtab_pci_register_set_vga_state to the 
function .init.text:pci_register_set_vga_state()
The symbol pci_register_set_vga_state is exported and annotated __init
Fix this by removing the __init annotation of pci_register_set_vga_state 
or drop the export.

$fgrep "pci_register_set_vga_state" `find .`

$./arch/x86/kernel/apic/x2apic_uv_x.c: 
pci_register_set_vga_state(uv_set_vga_state);
$./include/linux/pci.h:extern void 
pci_register_set_vga_state(arch_set_vga_state_t func);
$./drivers/pci/pci.c:void 
pci_register_set_vga_state(arch_set_vga_state_t func)
$./drivers/pci/pci.c:EXPORT_SYMBOL(pci_register_set_vga_state);

this is a volatile function that set's a spec. state and is only used 
from uv_system_init(arch/x86/kernel/apic/x2apic_uv_x.c), the macro can 
also be removed.
