Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab2EYOUu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 10:20:50 -0400
Received: from thoth.sbs.de ([192.35.17.2]:28009 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305Ab2EYOUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 10:20:49 -0400
Message-ID: <4FBF9529.6030906@siemens.com>
Date: Fri, 25 May 2012 11:20:25 -0300
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Alexander Graf <agraf@suse.de>, kvm <kvm@vger.kernel.org>
Subject: Re: [PATCH] PCI: Mark INTx masking support of Chelsio T310 10GbE
 NIC as broken
References: <4FBF90E5.8030800@siemens.com> <CAErSpo78Pp7YW3tLbT7QR0oOeSUHzxf55CBW8bDW3kWx0Gy1ug@mail.gmail.com>
In-Reply-To: <CAErSpo78Pp7YW3tLbT7QR0oOeSUHzxf55CBW8bDW3kWx0Gy1ug@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-05-25 11:11, Bjorn Helgaas wrote:
> On Fri, May 25, 2012 at 8:02 AM, Jan Kiszka <jan.kiszka@siemens.com> wrote:
>> According to Alexey, the T310 does not properly support INTx masking as
>> it fails to keep the PCI_STATUS_INTERRUPT bit updated once the interrupt
>> is masked. Mark this adapter as broken so that pci_intx_mask_supported
>> won't report it as compatible.
> 
> Please include a reference to a bugzilla, mailing list discussion, or
> other details about how this was found and debugged.  Thanks!

Sorry, it's documented here:
http://thread.gmane.org/gmane.comp.emulators.kvm.devel/91388. Will
repost with this information included once Alexey provided his tested-by.

Jan

> 
>> Reported-by: Alexey Kardashevskiy <aik@ozlabs.ru>
>> Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
>> ---
>>
>> Alexey, please test if this catches your case correctly.
>>
>>  drivers/pci/pci.c    |    3 +++
>>  drivers/pci/quirks.c |   12 ++++++++++++
>>  include/linux/pci.h  |    2 ++
>>  3 files changed, 17 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
>> index 8f16900..3a1aeb5 100644
>> --- a/drivers/pci/pci.c
>> +++ b/drivers/pci/pci.c
>> @@ -2876,6 +2876,9 @@ bool pci_intx_mask_supported(struct pci_dev *dev)
>>        bool mask_supported = false;
>>        u16 orig, new;
>>
>> +       if (dev->broken_intx_masking)
>> +               return false;
>> +
>>        pci_cfg_access_lock(dev);
>>
>>        pci_read_config_word(dev, PCI_COMMAND, &orig);
>> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
>> index 2a75216..151e174 100644
>> --- a/drivers/pci/quirks.c
>> +++ b/drivers/pci/quirks.c
>> @@ -2929,6 +2929,18 @@ static void __devinit disable_igfx_irq(struct pci_dev *dev)
>>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x0102, disable_igfx_irq);
>>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x010a, disable_igfx_irq);
>>
>> +/*
>> + * Some devices may pass our check in pci_intx_mask_supported if
>> + * PCI_COMMAND_INTX_DISABLE works though they actually do not properly
>> + * support this feature.
>> + */
>> +static void __devinit quirk_broken_intx_masking(struct pci_dev *dev)
>> +{
>> +       dev->broken_intx_masking = 1;
>> +}
>> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_CHELSIO, 0x0010,
>> +                       quirk_broken_intx_masking);
>> +
>>  static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f,
>>                          struct pci_fixup *end)
>>  {
>> diff --git a/include/linux/pci.h b/include/linux/pci.h
>> index 17b7b5b..c7cfd73 100644
>> --- a/include/linux/pci.h
>> +++ b/include/linux/pci.h
>> @@ -324,6 +324,8 @@ struct pci_dev {
>>        unsigned int    is_hotplug_bridge:1;
>>        unsigned int    __aer_firmware_first_valid:1;
>>        unsigned int    __aer_firmware_first:1;
>> +       unsigned int    broken_intx_masking:1;  /* device's INTx masking
>> +                                                  support is not working */
>>        pci_dev_flags_t dev_flags;
>>        atomic_t        enable_cnt;     /* pci_enable_device has been called */
>>
>> --
>> 1.7.3.4

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
