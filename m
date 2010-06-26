Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132Ab0FZPGv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 11:06:51 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39566 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575Ab0FZPGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 11:06:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Ks1l/df0kFh0F2GIMor61dnozKHJCQYk2g9M+JkoOSQkkh9+x6pPT2I/G8TfmXN6IK
         hapwMEfBqmX1NQerkHoTn9+JdlN6apgSru7SkUxjqdRmctdP14/tGf+6AZ19Zpb77DD9
         8w4RhmDmchzQJ3blzvgR63fzyyXRKDZ81TnO8=
MIME-Version: 1.0
In-Reply-To: <4C257E67.9090101@gmail.com>
References: <AANLkTinYuxwsLQKGRd6joRSCcbnns930DDienlhfEB8i@mail.gmail.com>
	<4C257E67.9090101@gmail.com>
Date: Sat, 26 Jun 2010 20:36:45 +0530
Message-ID: <AANLkTikeQO1v-ag_DDbkgxoZRTk1_fomn1kbHKqH9vkD@mail.gmail.com>
Subject: Re: Setting up Silicon image 3114 in DMA mode
From: amruth pattanada <amruth.vamadev@gmail.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the info Robert. I checked the code for open solaris and
see the following below. It basically uses BAR5 indirect access
method.

/* Base Register 5 Indirect Address Offset */

#define	PCI_CONF_BA5_IND_ADDRESS	0xc0
#define	PCI_CONF_BA5_IND_ACCESS		0xc4

#define	PUT_BAR5_INDIRECT(handle, address, value) \
{\
		pci_config_put32(handle, PCI_CONF_BA5_IND_ADDRESS, address); \
		pci_config_put32(handle, PCI_CONF_BA5_IND_ACCESS, value); \
}

#define	GET_BAR5_INDIRECT(handle, address, rval) \
{\
		pci_config_put32(handle, PCI_CONF_BA5_IND_ADDRESS, address); \
		rval = pci_config_get32(handle, PCI_CONF_BA5_IND_ACCESS); \
}

/*
	 * The following BAR5 registers are accessed via an indirect register
	 * in the PCI configuration space rather than mapping BAR5.
	 */
	for (i = 0; i < ports; i++) {
		GET_BAR5_INDIRECT(pci_conf_handle, fifocntctl[i],
		    fifo_cnt_ctl);
		fifo_cnt_ctl = (fifo_cnt_ctl & ~0x7) | (frrc & 0x7);
		PUT_BAR5_INDIRECT(pci_conf_handle, fifocntctl[i],
		    fifo_cnt_ctl);
		/*
		 * Correct default setting for FIS0cfg
		 */
#ifdef	DEBUG
		GET_BAR5_INDIRECT(pci_conf_handle, sfiscfg[i],
			sfiscfg_val);
		ADBG_WARN(("sil3xxx_init_controller: old val SFISCfg "
			"ch%d: %x\n", i, sfiscfg_val));
#endif
		PUT_BAR5_INDIRECT(pci_conf_handle, sfiscfg[i],
			SFISCFG_ERRATA);
#ifdef	DEBUG
		GET_BAR5_INDIRECT(pci_conf_handle, sfiscfg[i],
			sfiscfg_val);
		ADBG_WARN(("sil3xxx_init_controller: new val SFISCfg "
			"ch%d: %x\n", i, sfiscfg_val));
#endif

I need to setup DMA transfer mode for silicon image 3114 chipset for
dma write/read operation.Where can I find the initialisation steps for
DMA in libata(Programming Bus Master Registers,setup PRD table and
Issue ATA commands). Do we have any sample implementation in libata.
Please let me know.
Thanks
Amruth p.v
Sr.Embedded Engineer
On Sat, Jun 26, 2010 at 9:43 AM, Robert Hancock <hancockrwd@gmail.com> wrote:
> On 06/25/2010 02:25 AM, amruth pattanada wrote:
>>
>> Hi
>> Can anybody please guide me what minimal steps to follow for setting
>> up 3114 for operating in DMA mode and looked into linux 2.6.32.7 code.
>> I am porting 3114 driver to RTOS but have problems in using BAR5 PCI
>> config space because of Memory mapped region issues. I can access BAR4
>> and plan to set up DMA mode.
>> How do we access entire BAR5 memory space without using BAR5, is there
>> any indirect way to access BAR5 using BAR4. Please let me know.
>> Thanks
>> Amruth p.v
>> Sr.Embedded Engineer
>
> See the datasheet (PCI Configuration Space section), there's a way to access
> BAR5 registers using indirect access registers in configuration space. I
> expect this will be relatively slow, however.
>
