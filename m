Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab0F3MbC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 08:31:02 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51624 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab0F3MbA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 08:31:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YbbufsR5MB0WMfH5mWBdXmzKfoldqj5uUjQ0bRzLtQSpkPaDMYJUuFijj1NXmcrIGf
         vcRgSDsBFJDXK1+sxD0605CS/23+e5o/xeKvyiqFuzWyc0+4Icq2Ld1/Dus6jzgyxoYb
         uoftpKuWIemftzpsHE9PbY459EB5pEIEMuIMQ=
MIME-Version: 1.0
In-Reply-To: <AANLkTikeQO1v-ag_DDbkgxoZRTk1_fomn1kbHKqH9vkD@mail.gmail.com>
References: <AANLkTinYuxwsLQKGRd6joRSCcbnns930DDienlhfEB8i@mail.gmail.com>
	<4C257E67.9090101@gmail.com>
	<AANLkTikeQO1v-ag_DDbkgxoZRTk1_fomn1kbHKqH9vkD@mail.gmail.com>
Date: Wed, 30 Jun 2010 18:00:59 +0530
Message-ID: <AANLkTimOu5GfUN848EOiMIZONHrRjgYyexmwBL3OCAMs@mail.gmail.com>
Subject: Re: Setting up Silicon image 3114 in DMA mode
From: amruth pattanada <amruth.vamadev@gmail.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
I need some clarification regarding read DMA data from silicon image
controller. How do know that DMA transfer happened and where to look
for the data after the transfer. Should we look at BAR2 channel X Task
file register data word or look into allocated DMA buffer which is
specified in the PRD table. I am reading 0x00 in the PRD table scatter
gather list and it hangs in the when I tried to read data word of
channel task file register. Please let me know how to read data buffer
after the DMA is complete.
Thanks
Amruth p.v

On Sat, Jun 26, 2010 at 8:36 PM, amruth pattanada
<amruth.vamadev@gmail.com> wrote:
> Thanks for the info Robert. I checked the code for open solaris and
> see the following below. It basically uses BAR5 indirect access
> method.
>
> /* Base Register 5 Indirect Address Offset */
>
> #define PCI_CONF_BA5_IND_ADDRESS        0xc0
> #define PCI_CONF_BA5_IND_ACCESS         0xc4
>
> #define PUT_BAR5_INDIRECT(handle, address, value) \
> {\
>                pci_config_put32(handle, PCI_CONF_BA5_IND_ADDRESS, address); \
>                pci_config_put32(handle, PCI_CONF_BA5_IND_ACCESS, value); \
> }
>
> #define GET_BAR5_INDIRECT(handle, address, rval) \
> {\
>                pci_config_put32(handle, PCI_CONF_BA5_IND_ADDRESS, address); \
>                rval = pci_config_get32(handle, PCI_CONF_BA5_IND_ACCESS); \
> }
>
> /*
>         * The following BAR5 registers are accessed via an indirect register
>         * in the PCI configuration space rather than mapping BAR5.
>         */
>        for (i = 0; i < ports; i++) {
>                GET_BAR5_INDIRECT(pci_conf_handle, fifocntctl[i],
>                    fifo_cnt_ctl);
>                fifo_cnt_ctl = (fifo_cnt_ctl & ~0x7) | (frrc & 0x7);
>                PUT_BAR5_INDIRECT(pci_conf_handle, fifocntctl[i],
>                    fifo_cnt_ctl);
>                /*
>                 * Correct default setting for FIS0cfg
>                 */
> #ifdef  DEBUG
>                GET_BAR5_INDIRECT(pci_conf_handle, sfiscfg[i],
>                        sfiscfg_val);
>                ADBG_WARN(("sil3xxx_init_controller: old val SFISCfg "
>                        "ch%d: %x\n", i, sfiscfg_val));
> #endif
>                PUT_BAR5_INDIRECT(pci_conf_handle, sfiscfg[i],
>                        SFISCFG_ERRATA);
> #ifdef  DEBUG
>                GET_BAR5_INDIRECT(pci_conf_handle, sfiscfg[i],
>                        sfiscfg_val);
>                ADBG_WARN(("sil3xxx_init_controller: new val SFISCfg "
>                        "ch%d: %x\n", i, sfiscfg_val));
> #endif
>
> I need to setup DMA transfer mode for silicon image 3114 chipset for
> dma write/read operation.Where can I find the initialisation steps for
> DMA in libata(Programming Bus Master Registers,setup PRD table and
> Issue ATA commands). Do we have any sample implementation in libata.
> Please let me know.
> Thanks
> Amruth p.v
> Sr.Embedded Engineer
> On Sat, Jun 26, 2010 at 9:43 AM, Robert Hancock <hancockrwd@gmail.com> wrote:
>> On 06/25/2010 02:25 AM, amruth pattanada wrote:
>>>
>>> Hi
>>> Can anybody please guide me what minimal steps to follow for setting
>>> up 3114 for operating in DMA mode and looked into linux 2.6.32.7 code.
>>> I am porting 3114 driver to RTOS but have problems in using BAR5 PCI
>>> config space because of Memory mapped region issues. I can access BAR4
>>> and plan to set up DMA mode.
>>> How do we access entire BAR5 memory space without using BAR5, is there
>>> any indirect way to access BAR5 using BAR4. Please let me know.
>>> Thanks
>>> Amruth p.v
>>> Sr.Embedded Engineer
>>
>> See the datasheet (PCI Configuration Space section), there's a way to access
>> BAR5 registers using indirect access registers in configuration space. I
>> expect this will be relatively slow, however.
>>
>
