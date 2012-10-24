Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934713Ab2JXLOW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 07:14:22 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:3651 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934677Ab2JXLOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 07:14:21 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
Message-ID: <5087CD85.4010201@broadcom.com>
Date: Wed, 24 Oct 2012 13:14:13 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011
 Thunderbird/16.0.1
MIME-Version: 1.0
To: "Stanislaw Gruszka" <sgruszka@redhat.com>
cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        "Ben Skeggs" <bskeggs@redhat.com>
Subject: Re: [BUG 3.7-rc1] nouveau cli->mutex possible recursive locking
 detected
References: <20121016124348.GB2274@redhat.com>
In-Reply-To: <20121016124348.GB2274@redhat.com>
X-WSS-ID: 7C99135A3SK3234513-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2012 02:43 PM, Stanislaw Gruszka wrote:
> I have this lockdep warning on wireless-testing tree based
> on 3.7-rc1 (no other patches except wireless bits).
>
> =============================================
> Restarting tasks ... done.
> [ INFO: possible recursive locking detected ]
> 3.7.0-rc1-wl+ #2 Not tainted
> ---------------------------------------------
> Xorg/2269 is trying to acquire lock:
>   (&cli->mutex){+.+.+.}, at: [<ffffffffa012a27f>] nouveau_bo_move_m2mf+0x5f/0x170 [nouveau]
>
> but task is already holding lock:
>   (&cli->mutex){+.+.+.}, at: [<ffffffffa012f3c4>] nouveau_abi16_get+0x34/0x100 [nouveau]
>

I have observed the same bug so I built and tested v3.7-rc2 tag with 
lockdep enabled. It has the same problem and it results in a failure to 
resume after suspend. See below.

Gr. AvS

[   76.272795] PM: suspend of devices complete after 2149.188 msecs
[   76.273110] PM: suspend devices took 2.152 seconds
[   76.273354] suspend debug: Waiting for 5 seconds.
[   81.233082] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[   81.233369] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[   81.233422] pci 0000:00:1e.0: setting latency timer to 64
[   81.248934] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[   81.249398] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[   81.249903] ahci 0000:00:1f.2: setting latency timer to 64
[   81.249982] snd_hda_intel 0000:00:1b.0: irq 43 for MSI/MSI-X
[   81.250515] nouveau  [     DRM] re-enabling device...
[   81.250548] nouveau  [     DRM] resuming client object trees...
[   81.250557] nouveau  [   VBIOS][0000:01:00.0] running init tables
[   81.701998] nouveau  [     DRM] resuming display...
[   81.803923] firewire_core 0000:04:00.4: rediscovered device fw0
[   81.823913] dell_wmi: Received unknown WMI event (0x11)
[   81.824521] serial 00:08: activated
[   82.135333] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   82.187115] ata6: SATA link down (SStatus 0 SControl 300)
[   82.232290] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   82.284002] ata5: SATA link down (SStatus 0 SControl 300)
[   82.330629] ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by 
device (Stat=0x51 Err=0x04)
[   82.408079] ata2.00: configured for UDMA/133
[   84.073571] ata1.00: failed to get Identify Device Data, Emask 0x1
[   84.127965] ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by 
device (Stat=0x51 Err=0x04)
[   84.202292] ata1.00: failed to get Identify Device Data, Emask 0x1
[   84.254039] ata1.00: configured for UDMA/133
[   84.303718] sd 0:0:0:0: [sda] Starting disk
[   84.360186] PM: resume of devices complete after 3132.774 msecs
[   84.410322] PM: resume devices took 3.180 seconds
[   84.449642] PM: Finishing wakeup.
[   84.505964]
[   84.506716] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow 
Control: Rx
[   84.477326] Restarting tasks ... done.
[   84.575294] video LNXVIDEO:00: Restoring backlight state
[   84.623825] =============================================
[   84.623825] [ INFO: possible recursive locking detected ]
[   84.623826] 3.7.0-rc2-testing-lockdep #1 Not tainted
[   84.623827] ---------------------------------------------
[   84.623827] Xorg/1369 is trying to acquire lock:
[   84.623828]  (&cli->mutex){+.+.+.}, at: [<f8974ca8>] 
nouveau_bo_move_m2mf.isra.13+0x38/0x120 [nouveau]
[   84.623856]
[   84.623856] but task is already holding lock:
[   84.623856]  (&cli->mutex){+.+.+.}, at: [<f8979346>] 
nouveau_abi16_get+0x26/0x110 [nouveau]
[   84.623871]
[   84.623871] other info that might help us debug this:
[   84.623872]  Possible unsafe locking scenario:
[   84.623872]
[   84.623872]        CPU0
[   84.623872]        ----
[   84.623873]   lock(&cli->mutex);
[   84.623874]   lock(&cli->mutex);
[   84.623874]
[   84.623874]  *** DEADLOCK ***
[   84.623874]
[   84.623874]  May be due to missing lock nesting notation
[   84.623874]
[   84.623875] 1 lock held by Xorg/1369:
[   84.623889]  #0:  (&cli->mutex){+.+.+.}, at: [<f8979346>] 
nouveau_abi16_get+0x26/0x110 [nouveau]
[   84.623890]


