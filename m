Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436Ab2KEQ0b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 11:26:31 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:18181 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab2KEQ03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 11:26:29 -0500
Message-ID: <1352132785.2606.14.camel@lorien2>
Subject: Re: [PATCH] wireless: iwlwifi - add dma_mapping_error() checks to
 avoid warnings
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Johannes Berg <johannes@sipsolutions.net>
Cc: johannes.berg@intel.com, wey-yi.w.guy@intel.com, linville@tuxdriver.com,
        ilw@linux.intel.com, emmanuel.grumbach@intel.com,
        donald.h.fry@intel.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        shuahkhan@gmail.com
Date: Mon, 05 Nov 2012 09:26:25 -0700
In-Reply-To: <1352020617.10072.0.camel@jlt4.sipsolutions.net>
References: <1351993233.4369.2.camel@lorien2>
	 (sfid-20121104_024119_271188_5372C13E) <1352020617.10072.0.camel@jlt4.sipsolutions.net>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-11-04 at 10:16 +0100, Johannes Berg wrote:
> On Sat, 2012-11-03 at 19:40 -0600, Shuah Khan wrote:
> > Add missing dma_mapping_error() checks to validate dma addresses returned by
> > dma_map_page() calls to avoid the following warning:
> > 
> > [   28.475686] WARNING: at lib/dma-debug.c:933 check_unmap+0x459/0x8a0()
> > [   28.475688] Hardware name: HP EliteBook 6930p
> > [   28.475690] iwlwifi 0000:03:00.0: DMA-API: device driver failed to check map error[device address=0x00000000ffffa000] [size=8192 bytes] [mapped as page]
> > [   28.475691] Modules linked in: arc4 bnep rfcomm iwldvm mac80211 snd_hda_codec_analog radeon snd_hda_intel snd_hda_codec coretemp kvm_intel snd_hwdep snd_pcm iwlwifi kvm btusb bluetooth snd_seq_midi snd_rawmidi ttm cfg80211 snd_seq_midi_event drm_kms_helper pata_pcmcia drm snd_seq binfmt_misc pcmcia snd_timer snd_seq_device tpm_infineon snd dm_multipath yenta_socket joydev pcmcia_rsrc pcmcia_core hp_wmi psmouse hp_accel microcode soundcore i2c_algo_bit sparse_keymap wmi ppdev lpc_ich lis3lv02d snd_page_alloc video tpm_tis serio_raw parport_pc input_polldev mac_hid lp parport firewire_ohci firewire_core crc_itu_t sdhci_pci sdhci e1000e
> 
> Thanks for the report. Since I think doing BUG_ON() in such a scenario
> is a really bad idea, I've applied a different patch with your
> Reported-by.

Yeah. I wasn't sure about BUS() either. Did you notice the other cases
of BUG_ON() in this path in iwl_rx_allocate()? I would think those need
fixing as well.

              rxb->page_dma =
                        dma_map_page(trans->dev, page, 0,
                                     PAGE_SIZE <<
trans_pcie->rx_page_order,
                                     DMA_FROM_DEVICE);
                /* dma address must be no more than 36 bits */
                BUG_ON(rxb->page_dma & ~DMA_BIT_MASK(36));
                /* and also 256 byte aligned! */
                BUG_ON(rxb->page_dma & DMA_BIT_MASK(8));

Could you please send me commitID for the patch you did. I am interested
in seeing the failure handling in your patch?

-- Shuah


