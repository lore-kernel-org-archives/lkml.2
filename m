Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413Ab2KVTN3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:13:29 -0500
Received: from intranet.asianux.com ([58.214.24.6]:60363 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754437Ab2KVTN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:13:26 -0500
X-Spam-Score: -100.7
Message-ID: <50ADAF18.7090404@asianux.com>
Date: Thu, 22 Nov 2012 12:50:32 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: arnd@arndb.de, gregkh@linuxfoundation.org
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [Suggestion] drivers/char: in hpet.c, check for hdp->hd_nirqs
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Arnd Bergmann, Greg Kroah-Hartman

  in drivers/char/hpet.c:1009
    I suggest to add check for hdp->hd_nirqs whether equal or larger than 32 (HPET_MAX_TIMERS)
      the type of irqp->interrupt_count is u8 (include/acpi/acrestyp.h:349)
      the type of hdp->hd_irq is "unsigned int hd_irq[HPET_MAX_TIMERS]" (include/linux/hpet.h:99)
      #define HPET_MAX_TIMERS (32) (include/linux/hpet.h:38)

  additional information:
    acpi_register_gsi() not check the boundaries of how many irqs (at least, unlimited for u8).
    maybe (only maybe) the irqp->interrupt_count is always less than 32 by hardware limitation.
    I do not know whether it is a bug, so as a suggestion.


 regards

gchen.

----------------------------------------------------------------------------------------

in include/linux/hpet.h

 38 #define HPET_MAX_TIMERS (32)
 39 #define HPET_MAX_IRQ    (32)
 ...

 94 struct hpet_data {
 95         unsigned long hd_phys_address;
 96         void __iomem *hd_address;
 97         unsigned short hd_nirqs;
 98         unsigned int hd_state;  /* timer allocated */
 99         unsigned int hd_irq[HPET_MAX_TIMERS];
100 };

in include/acpi/acrestyp.h

344 struct acpi_resource_extended_irq {
345         u8 producer_consumer;
346         u8 triggering;
347         u8 polarity;
348         u8 sharable;
349         u8 interrupt_count;
350         struct acpi_resource_source resource_source;
351         u32 interrupts[1];
352 };




in drivers/char/hpet.c:

 964 static acpi_status hpet_resources(struct acpi_resource *res, void *data)
 965 {
 966         struct hpet_data *hdp;
 967         acpi_status status;
 968         struct acpi_resource_address64 addr;
 969 
 970         hdp = data;
 971 
 972         status = acpi_resource_to_address64(res, &addr);
 973 
 974         if (ACPI_SUCCESS(status)) {
 975                 hdp->hd_phys_address = addr.minimum;
 976                 hdp->hd_address = ioremap(addr.minimum, addr.address_length);
 977 
 978                 if (hpet_is_known(hdp)) {
 979                         iounmap(hdp->hd_address);
 980                         return AE_ALREADY_EXISTS;
 981                 }
 982         } else if (res->type == ACPI_RESOURCE_TYPE_FIXED_MEMORY32) {
 983                 struct acpi_resource_fixed_memory32 *fixmem32;
 984 
 985                 fixmem32 = &res->data.fixed_memory32;
 986                 if (!fixmem32)
 987                         return AE_NO_MEMORY;
 988 
 989                 hdp->hd_phys_address = fixmem32->address;
 990                 hdp->hd_address = ioremap(fixmem32->address,
 991                                                 HPET_RANGE_SIZE);
 992 
 993                 if (hpet_is_known(hdp)) {
 994                         iounmap(hdp->hd_address);
 995                         return AE_ALREADY_EXISTS;
 996                 }
 997         } else if (res->type == ACPI_RESOURCE_TYPE_EXTENDED_IRQ) {
 998                 struct acpi_resource_extended_irq *irqp;
 999                 int i, irq;
1000 
1001                 irqp = &res->data.extended_irq;
1002 
1003                 for (i = 0; i < irqp->interrupt_count; i++) {
1004                         irq = acpi_register_gsi(NULL, irqp->interrupts[i],
1005                                       irqp->triggering, irqp->polarity);
1006                         if (irq < 0)
1007                                 return AE_ERROR;
1008 
1009                         hdp->hd_irq[hdp->hd_nirqs] = irq;
1010                         hdp->hd_nirqs++;
1011                 }
1012         }
1013 
1014         return AE_OK;
1015 }
1016 

