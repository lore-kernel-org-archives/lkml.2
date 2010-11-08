Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab0KHUsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 15:48:09 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60373 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754208Ab0KHUsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 15:48:07 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [Regression, post-2.6.35] ath9k occasionally drops out of PCI config space
Date: Mon, 8 Nov 2010 21:47:13 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
References: <201011052150.02245.rjw@sisk.pl> <20101105211931.GA1921@tux>
In-Reply-To: <20101105211931.GA1921@tux>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011082147.14170.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 05, 2010, Luis R. Rodriguez wrote:
> On Fri, Nov 05, 2010 at 01:50:02PM -0700, Rafael J. Wysocki wrote:
> > Hi,
> > 
> > For some time I've been experiencing a regression associated with ath9k
> > that occasionally it drops the connection with the AP and goes into a state
> > in which reading from its PCI config registers (as done by lspci) return all
> > ones.
> > 
> > It may be sort of brought back to life by a suspend/resume afterwards, but
> > then the driver cannot really handle it and realoding the driver doesn't help
> > (probe fails).  Basically, full machine reboot is needed to revive the adapter.
> > 
> > The device is:
> > 
> > 09:00.0 Network controller: Atheros Communications Inc. AR928X Wireless Network Adapter (PCI-Express) (rev 01)
> >         Subsystem: Foxconn International, Inc. Device e01f
> > 
> > and the kernel says:
> > 
> > [    9.623217] ath9k 0000:09:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
> > [    9.631518] ath9k 0000:09:00.0: setting latency timer to 64
> > [   10.071497] ath: EEPROM regdomain: 0x65
> > [   10.071502] ath: EEPROM indicates we should expect a direct regpair map
> > [   10.071510] ath: Country alpha2 being used: 00
> > [   10.071514] ath: Regpair used: 0x65
> > [   10.096025] phy0: Selected rate control algorithm 'ath9k_rate_control'
> > [   10.097803] Registered led device: ath9k-phy0::radio
> > [   10.098035] Registered led device: ath9k-phy0::assoc
> > [   10.098249] Registered led device: ath9k-phy0::tx
> > [   10.098483] Registered led device: ath9k-phy0::rx
> > [   10.098496] phy0: Atheros AR9280 Rev:2 mem=0xffffc900017e0000, irq=19
> > 
> > The issue is not really bisectable, because I'm unable to trigger it on demand
> > and it occurs approx. 1-2 times a day.  So, if you have any ideas what to test,
> > please let me know.
> > 
> > It is not reproducible with the 2.6.35 kernel.
> 
> Please try this patch.

It _appears_ to help.  At least I haven't been able to reproduce the problem
since I applied it, which was on Saturday early in the morning.

Still, I also haven't used wireless a lot since that time, because I've been
traveling mostly.

Thanks,
Rafael


> From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> Date: Tue, 2 Nov 2010 23:57:34 -0700
> Subject: [PATCH] ath9k_hw: Fix AR9280 surprise removal during frequent idle on/off
> 
> Bit 22 of AR_WA should be set to fix the situation where chip reset
> is asynchronous to clock of analog shift registers, such that when
> reset is released, it could mess up the values of analog shift registers
> and cause some hw issue on AR9280.
> 
> This bit is write only, but the driver does a read-modify-write
> on AR_WA without setting bit 22 in ar9002_hw_configpcipowersave()
> during radio disable. This causes surprise removal of hw. It can
> never recover from this state and the hw will become usable only
> after a power on/off cycle, and sometimes only during a cold reboot.
> 
> This issue can be triggered by doing frequent roaming with the
> simple/test-roam script available from the wifi-test project [1]
> when roaming between APs quickly. When roaming there is a is a high
> possibility that the device being put into idle (radio disable) state
> by mac80211 during AUTH->ASSOC. A device hardware reset would fail
> and the kernel would output:
> 
> [40251.363799] ath: AWAKE -> FULL-SLEEP
> [40251.363815] ieee80211 phy17: device no longer idle - working
> [40251.363817] ath: Marking phy17 as not-idle
> [40251.363819] ath: FULL-SLEEP -> AWAKE
> [40251.415978] pciehp 0000:00:1c.3:pcie04: Card not present on Slot(3)
> [40251.419896] ath: ah->misc_mode 0x4
> [40251.428138] pciehp 0000:00:1c.3:pcie04: Card present on Slot(3)
> [40251.532247] ath: timeout (100000 us) on reg 0x9860: 0xffffffff & 0x00000001 != 0x00000000
> [40251.532250] ath: Unable to reset channel (2462 MHz), reset status -5
> [40251.532422] ath: Set channel: 5745 MHz
> [40251.540639] ath: Failed to stop TX DMA in 100 msec after killing last frame
> [40251.548826] ath: Failed to stop TX DMA in 100 msec after killing last frame
> [40251.557023] ath: Failed to stop TX DMA in 100 msec after killing last frame
> [40251.565211] ath: Failed to stop TX DMA in 100 msec after killing last frame
> [40251.573415] ath: Failed to stop TX DMA in 100 msec after killing last frame
> [40251.581603] ath: Failed to stop TX DMA in 100 msec after killing last frame
> [40251.581606] ath: Failed to stop TX DMA. Resetting hardware!
> [40251.592679] ath: DMA failed to stop in 10 ms AR_CR=0xffffffff AR_DIAG_SW=0xffffffff
> [40251.703330] ath: timeout (100000 us) on reg 0x7000: 0xffffffff & 0x00000003 != 0x00000000
> [40251.703333] ath: RTC stuck in MAC reset
> [40251.703334] ath: Chip reset failed
> [40251.703335] ath: Unable to reset hardware; reset status -22
> 
> This is currently only reproducible with some HB92 (Half Mini-PCIE)
> cards but the fix applies to all AR9280 cards. This patch fixes this
> issue by setting bit 22 during radio disable.
> 
> [1] http://wireless.kernel.org/en/developers/Testing/wifi-test
> 
> Cc: Amod.bodas@atheros.com
> Cc: David.Quan@atheros.com
> Cc: Kyungwan.Nam@atheros.com
> Cc: stable@kernel.org
> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> ---
>  drivers/net/wireless/ath/ath9k/ar9002_hw.c |    3 +++
>  drivers/net/wireless/ath/ath9k/reg.h       |    1 +
>  2 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
> index a0471f2..48261b7 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
> @@ -410,6 +410,9 @@ static void ar9002_hw_configpcipowersave(struct ath_hw *ah,
>  			val &= ~(AR_WA_BIT6 | AR_WA_BIT7);
>  		}
>  
> +		if (AR_SREV_9280(ah))
> +			val |= AR_WA_BIT22;
> +
>  		if (AR_SREV_9285E_20(ah))
>  			val |= AR_WA_BIT23;
>  
> diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
> index 42976b0..fa05b71 100644
> --- a/drivers/net/wireless/ath/ath9k/reg.h
> +++ b/drivers/net/wireless/ath/ath9k/reg.h
> @@ -703,6 +703,7 @@
>  #define AR_WA_RESET_EN                  (1 << 18) /* Sw Control to enable PCI-Reset to POR (bit 15) */
>  #define AR_WA_ANALOG_SHIFT              (1 << 20)
>  #define AR_WA_POR_SHORT                 (1 << 21) /* PCI-E Phy reset control */
> +#define AR_WA_BIT22			(1 << 22)
>  #define AR9285_WA_DEFAULT		0x004a050b
>  #define AR9280_WA_DEFAULT           	0x0040073b
>  #define AR_WA_DEFAULT               	0x0000073f
> 

