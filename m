Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759271Ab1D0Qdx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 12:33:53 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:58176 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab1D0Qdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 12:33:52 -0400
Content-Type: text/plain; charset=UTF-8
From: Chris Mason <chris.mason@oracle.com>
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] fatal hang untarring 90GB file, possibly writeback related.
In-reply-to: <1303920553.2583.7.camel@mulgrave.site>
References: <1303920553.2583.7.camel@mulgrave.site>
Date: Wed, 27 Apr 2011 12:33:37 -0400
Message-Id: <1303921583-sup-4021@think>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4DB8456E.0005:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from James Bottomley's message of 2011-04-27 12:09:13 -0400:
> The bug manifests as a soft lockup in kswapd:
> 
> [  155.759084] netconsole: network logging started
> [  598.920430] BUG: soft lockup - CPU#1 stuck for 67s! [kswapd0:46]
> [  598.920472] Modules linked in: netconsole configfs fuse sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_intel snd_hda_codec snd_hwdep arc4 snd_seq snd_seq_device snd_pcm iwlagn mac80211 snd_timer uvcvideo btusb bluetooth snd cfg80211 videodev soundcore v4l2_compat_ioctl32 iTCO_wdt xhci_hcd e1000e snd_page_alloc rfkill i2c_i801 wmi iTCO_vendor_support microcode pcspkr joydev uinput ipv6 sdhci_pci sdhci mmc_core i915 drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: netconsole]
> [  598.920834] CPU 1 
> [  598.920843] Modules linked in: netconsole configfs fuse sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_intel snd_hda_codec snd_hwdep arc4 snd_seq snd_seq_device snd_pcm iwlagn mac80211 snd_timer uvcvideo btusb bluetooth snd cfg80211 videodev soundcore v4l2_compat_ioctl32 iTCO_wdt xhci_hcd e1000e snd_page_alloc rfkill i2c_i801 wmi iTCO_vendor_support microcode pcspkr joydev uinput ipv6 sdhci_pci sdhci mmc_core i915 drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: netconsole]
> [  598.926818] 

Probably easier to debug with a sysrq-l and sysrq-w.  If you get stuck
on the filesystem, it is probably waiting on ram, which it probably
can't get because kswapd is spinning.  Eventually everyone backs up
waiting for the transaction that never ends.  If we're really lucky it
is just GFP_KERNEL where it should NOFS.

Since you're often stuck in different spots inside shrink_slab, we're
probably not stuck on a lock.  But, trying with lock debugging, lockdep
enabled and preempt on is a good idea to rule out locking mistakes.

Does the fedora debug kernel enable preempt?

-chris
