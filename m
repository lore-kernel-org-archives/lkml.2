Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759303Ab0I0Mr5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 08:47:57 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:35051 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759115Ab0I0Mry convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 08:47:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nmU5hN2HVfxcbH7DhVbKAl7O0QQWT/5KzzpS0K0teVyZZlErkweNKApUZ3wzr7mIO5
         u4U5GYKyIFxBlQVVgdAcAkfVeZ3AgCXK/nZUqxyuOTWvjrCty6yDH8Kte6vnbyzdUujZ
         w1wB3Ik+qmbrInQvThOoZQLUKIri3b+mrPXE8=
MIME-Version: 1.0
In-Reply-To: <20100927100901.GC32222@erda.amd.com>
References: <1285549026-5008-1-git-send-email-ying.huang@intel.com>
	<1285549026-5008-6-git-send-email-ying.huang@intel.com>
	<20100927100901.GC32222@erda.amd.com>
Date: Mon, 27 Sep 2010 20:47:53 +0800
Message-ID: <AANLkTimY5hr3DgN9=v83Z289MkzjgX8k0WzdTWZbGorj@mail.gmail.com>
Subject: Re: [PATCH -v2 6/7] x86, NMI, Add support to notify hardware error
 with unknown NMI
From: huang ying <huang.ying.caritas@gmail.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Huang Ying <ying.huang@intel.com>, Don Zickus <dzickus@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 6:09 PM, Robert Richter <robert.richter@amd.com> wrote:
> On 26.09.10 20:57:05, Huang Ying wrote:
>> On some platforms, fatal hardware error may be notified via unknown
>> NMI.
>>
>> For example, on some platform with APEI firmware first mode support,
>> firmware generates NMI for fatal error but without error record. The
>> unknown NMI should be treated as notification of fatal hardware
>> error. The unknown_nmi_for_hwerr is added for these platform, if it is
>> not zero, system will treat unknown NMI as notification of fatal
>> hardware error.
>>
>> These platforms are identified via the presentation of APEI HEST or
>> some PCI ID of the host bridge. The PCI ID of host bridge instead of
>> DMI ID is used, so that the checking can be done based on the platform
>> type instead of motherboard. This should be simpler and sufficient.
>>
>> The method to identify the platforms is designed by Andi Kleen.
>>
>> Signed-off-by: Huang Ying <ying.huang@intel.com>
>> ---
>>  arch/x86/include/asm/nmi.h |    1
>>  arch/x86/kernel/Makefile   |    2 +
>>  arch/x86/kernel/hwerr.c    |   55 +++++++++++++++++++++++++++++++++++++++++++++
>
> Instead of creating this file the code should be implemented in
>
>  arch/x86/kernel/cpu/intel.c
>
> Similar AMD NB code is implemented in amd.c and k8.c.

Why? This file is not vendor specific.

>>  arch/x86/kernel/traps.c    |   10 ++++++++
>>  drivers/acpi/apei/hest.c   |    8 ++++++
>>  5 files changed, 76 insertions(+)
>>  create mode 100644 arch/x86/kernel/hwerr.c
>>
>> --- a/arch/x86/include/asm/nmi.h
>> +++ b/arch/x86/include/asm/nmi.h
>> @@ -44,6 +44,7 @@ struct ctl_table;
>>  extern int proc_nmi_enabled(struct ctl_table *, int ,
>>                       void __user *, size_t *, loff_t *);
>>  extern int unknown_nmi_panic;
>> +extern int unknown_nmi_for_hwerr;
>>
>>  void arch_trigger_all_cpu_backtrace(void);
>>  #define arch_trigger_all_cpu_backtrace arch_trigger_all_cpu_backtrace
>> --- a/arch/x86/kernel/Makefile
>> +++ b/arch/x86/kernel/Makefile
>> @@ -118,6 +118,8 @@ obj-$(CONFIG_X86_CHECK_BIOS_CORRUPTION)
>>
>>  obj-$(CONFIG_SWIOTLB)                        += pci-swiotlb.o
>>
>> +obj-y                                        += hwerr.o
>> +
>>  ###
>>  # 64 bit specific files
>>  ifeq ($(CONFIG_X86_64),y)
>> --- /dev/null
>> +++ b/arch/x86/kernel/hwerr.c
>> @@ -0,0 +1,55 @@
>> +/*
>> + * Hardware error architecture dependent processing
>> + *
>> + * Copyright 2010 Intel Corp.
>> + *   Author: Huang Ying <ying.huang@intel.com>
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License version
>> + * 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program; if not, write to the Free Software
>> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
>> + */
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/pci.h>
>> +#include <linux/init.h>
>> +#include <linux/nmi.h>
>> +
>> +/*
>> + * On some platform, hardware errors may be notified via unknown
>> + * NMI. These platform is identified via the PCI ID of host bridge.
>> + *
>> + * The PCI ID of host bridge instead of DMI ID is used, so that the
>> + * checking can be done based on the platform instead of motherboard.
>> + * This should be simpler and sufficient.
>> + */
>> +static const
>> +struct pci_device_id unknown_nmi_for_hwerr_platform[] __initdata = {
>> +     { PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x3406) },
>> +     { 0, }
>> +};
>> +
>> +int __init check_unknown_nmi_for_hwerr(void)
>> +{
>> +     struct pci_dev *dev = NULL;
>> +
>> +     for_each_pci_dev(dev) {
>> +             if (pci_match_id(unknown_nmi_for_hwerr_platform, dev)) {
>> +                     pr_info(
>> +"Host bridge is identified, will treat unknown NMI as hardware error!\n");
>> +                     unknown_nmi_for_hwerr = 1;
>> +                     break;
>> +             }
>> +     }
>> +
>> +     return 0;
>> +}
>> +late_initcall(check_unknown_nmi_for_hwerr);
>
> Maybe you can use early pci functions like read_pci_config() to avoid
> late init.

I don't think late init is a big issue. Hardware error is rare after all.

>> --- a/arch/x86/kernel/traps.c
>> +++ b/arch/x86/kernel/traps.c
>> @@ -83,6 +83,8 @@ EXPORT_SYMBOL_GPL(used_vectors);
>>
>>  static int ignore_nmis;
>>
>> +int unknown_nmi_for_hwerr;
>
> If it is an nmi for hwerr, it is no longer an unknown nmi. So we
> should drop 'unknow' in the naming.

I think unkown NMI is the one we can not identify the source.
Something like anonymous.

>> +
>>  /*
>>   * Prevent NMI reason port (0x61) being accessed simultaneously, can
>>   * only be used in NMI handler.
>> @@ -360,6 +362,14 @@ io_check_error(unsigned char reason, str
>>  static notrace __kprobes void
>>  unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
>>  {
>> +     /*
>> +      * On some platforms, hardware errors may be notified via
>> +      * unknown NMI
>> +      */
>> +     if (unknown_nmi_for_hwerr)
>> +             panic("NMI for hardware error without error record: "
>> +                   "Not continuing");
>> +
>
> Instead of checking this flag you should implement and register an nmi
> handler for this case.

I think explicit function calls have better readability than notifier chains.

Best Regards,
Huang Ying
