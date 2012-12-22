Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496Ab2LVPJN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 10:09:13 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:60732 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab2LVPJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 10:09:11 -0500
Date: Sun, 23 Dec 2012 00:09:09 +0900
From: Norbert Preining <preining@logic.at>
To: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: dire state of rtl driver in 3.7
Message-ID: <20121222150909.GA3979@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

I have no idea who is responsible or how to continue, but the rtl driver
is in such a dire state and it seems nobody cares. I have no reported
several times about it, without the slightest reactions. How can it be
that after so many years we still not be able to do wireless.

Ok, here are some facts to make people happy:
kernel 3.7.0
rtl8192se
AP infos:distance: 3m
NEC Aterm WR8600N ATERM-B45459
firmware 1.0.11

Network card is built in into a Lenovo Thinkpad Edge
# lspci -nnv -s  03:00.0
03:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd. RTL8191SEvB
Wireless LAN Controller [10ec:8172] (rev 10)
        Subsystem: Realtek Semiconductor Co., Ltd. Device [10ec:e020]
        Flags: bus master, fast devsel, latency 0, IRQ 17
        I/O ports at 2000 [size=256]
        Memory at f0500000 (32-bit, non-prefetchable) [size=16K]
        Capabilities: [40] Power Management version 3
        Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
        Capabilities: [70] Express Legacy Endpoint, MSI 00
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [140] Virtual Channel
        Capabilities: [160] Device Serial Number 88-55-22-fe-ff-4c-e0-00
        Kernel driver in use: rtl8192se

# iwconfig wlan0
wlan0     IEEE 802.11bgn  ESSID:"norbujp"
          Mode:Managed  Frequency:2.442 GHz  Access Point: 00:3A:9D:B4:54:5A
          Bit Rate=150 Mb/s   Tx-Power=20 dBm
          Retry  long limit:7   RTS thr=2347 B   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality=70/70  Signal level=-35 dBm


Effects:
- either does not associate at all with the AP
- or the kernel believes it is associated and packages ping to the router
  get stuck for up to 50+ seconds!!!
- the kernel believes everything is fine but actually nothing gets out
  (Destination unreachable)
- wild ping time up-down:
64 bytes from 192.168.0.1: icmp_req=73 ttl=255 time=3.05 ms
64 bytes from 192.168.0.1: icmp_req=74 ttl=255 time=6.42 ms
64 bytes from 192.168.0.1: icmp_req=75 ttl=255 time=1.21 ms
64 bytes from 192.168.0.1: icmp_req=76 ttl=255 time=6808 ms
64 bytes from 192.168.0.1: icmp_req=77 ttl=255 time=5800 ms
64 bytes from 192.168.0.1: icmp_req=78 ttl=255 time=4792 ms
64 bytes from 192.168.0.1: icmp_req=79 ttl=255 time=3784 ms
64 bytes from 192.168.0.1: icmp_req=80 ttl=255 time=2776 ms
64 bytes from 192.168.0.1: icmp_req=81 ttl=255 time=1768 ms
64 bytes from 192.168.0.1: icmp_req=82 ttl=255 time=760 ms
64 bytes from 192.168.0.1: icmp_req=83 ttl=255 time=2.19 ms
64 bytes from 192.168.0.1: icmp_req=84 ttl=255 time=1.67 ms
64 bytes from 192.168.0.1: icmp_req=85 ttl=255 time=4.99 ms
64 bytes from 192.168.0.1: icmp_req=86 ttl=255 time=1.40 ms
64 bytes from 192.168.0.1: icmp_req=87 ttl=255 time=583 ms
64 bytes from 192.168.0.1: icmp_req=88 ttl=255 time=4.96 ms
64 bytes from 192.168.0.1: icmp_req=89 ttl=255 time=1.26 ms


Then, when one tries to reset the driver by echoing 1 onto /sys/debug/.../reset
it hoses the driver even more, going into DMAR fault:
Dec 22 23:37:35 tofuschnitzel kernel: [ 3383.668663] dmar: DRHD: handling fault status reg 2
Dec 22 23:37:35 tofuschnitzel kernel: [ 3383.668674] dmar: DMAR:[DMA Read] Request device [03:00.0] fault addr fff35000
Dec 22 23:37:35 tofuschnitzel kernel: [ 3383.668674] DMAR:[fault reason 06] PTE Read access is not set
Dec 22 23:37:36 tofuschnitzel kernel: [ 3384.666158] rtlwifi:rtl_pci_tx():<300-1> No more TX desc@1, ring->idx = 9, idx = 9, skb_queue_len = 0x0
Dec 22 23:37:37 tofuschnitzel kernel: [ 3385.680919] rtlwifi:rtl_pci_tx():<600-1> No more TX desc@1, ring->idx = 9, idx = 9, skb_queue_len = 0x0
Dec 22 23:37:38 tofuschnitzel kernel: [ 3386.677098] rtlwifi:rtl_pci_tx():<300-1> No more TX desc@1, ring->idx = 9, idx = 9, skb_queue_len = 0x0
Dec 22 23:37:39 tofuschnitzel kernel: [ 3387.674602] rtlwifi:rtl_pci_tx():<300-1> No more TX desc@1, ring->idx = 9, idx = 9, skb_queue_len = 0x0
Dec 22 23:37:40 tofuschnitzel kernel: [ 3388.689394] rtlwifi:rtl_pci_tx():<600-1> No more TX desc@1, ring->idx = 9, idx = 9, skb_queue_len = 0x0
Dec 22 23:37:41 tofuschnitzel kernel: [ 3389.685531] rtlwifi:rtl_pci_tx():<300-1> No more TX desc@1, ring->idx = 9, idx = 9, skb_queue_len = 0x0



Then it often hangs in endless loops where it does not associate:
Dec 22 23:43:11 tofuschnitzel kernel: [ 3718.925859] wlan0: authentication with 00:3a:9d:b4:54:5a timed out
Dec 22 23:43:11 tofuschnitzel kernel: [ 3718.925954] rtlwifi:rtl_op_bss_info_changed():<0-0> 00:00:00:00:00:00
Dec 22 23:43:11 tofuschnitzel NetworkManager[7546]: <info> (wlan0): supplicant interface state: authenticating -> disconnected
Dec 22 23:43:11 tofuschnitzel kernel: [ 3719.025581] rtl8192se:rtl92s_phy_set_rf_power_state():<0-0> IPS Set eRf nic disable
Dec 22 23:43:11 tofuschnitzel NetworkManager[7546]: <info> (wlan0): supplicant interface state: disconnected -> scanning
Dec 22 23:43:12 tofuschnitzel kernel: [ 3719.089498] rtl8192se:rtl92s_phy_set_rf_power_state():<0-1> IPS Set eRf nic enable
Dec 22 23:43:12 tofuschnitzel kernel: [ 3719.112723] rtl8192se:_rtl92se_macconfig_after_fwdownload():<0-1> EFUSE CONFIG OK
Dec 22 23:43:12 tofuschnitzel kernel: [ 3719.112726] rtl8192se:_rtl92se_macconfig_after_fwdownload():<0-1> OK
^LDec 22 23:43:12 tofuschnitzel wpa_supplicant[4641]: wlan0: SME: Trying to authenticate with 00:3a:9d:b4:54:5a (SSID='norbujp' freq=2447 MHz)
Dec 22 23:43:12 tofuschnitzel kernel: [ 3719.996208] wlan0: authenticate with 00:3a:9d:b4:54:5a
Dec 22 23:43:12 tofuschnitzel NetworkManager[7546]: <info> (wlan0): supplicant interface state: scanning -> authenticating
Dec 22 23:43:12 tofuschnitzel kernel: [ 3720.015206] rtlwifi:rtl_op_bss_info_changed():<0-0> 00:3a:9d:b4:54:5a
Dec 22 23:43:12 tofuschnitzel kernel: [ 3720.015285] wlan0: send auth to 00:3a:9d:b4:54:5a (try 1/3)
Dec 22 23:43:12 tofuschnitzel kernel: [ 3720.015301] rtlwifi:rtl_pci_tx():<200-1> MAC80211_LINKING
Dec 22 23:43:13 tofuschnitzel kernel: [ 3720.218612] wlan0: send auth to 00:3a:9d:b4:54:5a (try 2/3)
Dec 22 23:43:13 tofuschnitzel kernel: [ 3720.218630] rtlwifi:rtl_pci_tx():<200-1> MAC80211_LINKING
Dec 22 23:43:13 tofuschnitzel kernel: [ 3720.422100] wlan0: send auth to 00:3a:9d:b4:54:5a (try 3/3)
Dec 22 23:43:13 tofuschnitzel kernel: [ 3720.422120] rtlwifi:rtl_pci_tx():<200-1> MAC80211_LINKING
Dec 22 23:43:13 tofuschnitzel kernel: [ 3720.625545] wlan0: authentication with 00:3a:9d:b4:54:5a timed out

==================

It seems that often when something happens it is related to WPA Group rekeying or somethin, because
immediately afterwards it starts hanging.

Dec 22 23:55:50 tofuschnitzel wpa_supplicant[4650]: wlan0: WPA: Group rekeying completed with 00:3a:9d:b4:54:5a [GTK=CCMP]
Dec 22 23:55:50 tofuschnitzel kernel: [  487.278193] rtlwifi:rtl_op_set_key():<0-0> Disabling hardware based encryption for keyidx: 1, mac: ff:ff:ff
:ff:ff:ff
Dec 22 23:55:50 tofuschnitzel kernel: [  487.278200] rtlwifi:rtl_op_set_key():<0-0> alg:CCMP
Dec 22 23:55:50 tofuschnitzel kernel: [  487.278203] rtlwifi:rtl_op_set_key():<
0-0> disable key delete one entry
Dec 22 23:55:50 tofuschnitzel kernel: [  487.278206] rtlwifi:rtl_cam_delete_one_entry():<0-0> key_idx:1
Dec 22 23:55:50 tofuschnitzel kernel: [  487.278209] rtlwifi:rtl_cam_delete_one_entry():<0-0> rtl_cam_delete_one_entry(): WRITE A4: 0
Dec 22 23:55:50 tofuschnitzel kernel: [  487.278212] rtlwifi:rtl_cam_delete_one_entry():<0-0> rtl_cam_delete_one_entry(): WRITE A0: 80010008
Dec 22 23:55:50 tofuschnitzel kernel: [  487.278275] rtlwifi:rtl_op_set_key():<0-0> Using hardware based encryption for keyidx: 1, mac: ff:ff:ff:ff:ff:ff
Dec 22 23:55:50 tofuschnitzel kernel: [  487.278278] rtlwifi:rtl_op_set_key():<0-0> alg:CCMP
Dec 22 23:55:50 tofuschnitzel kernel: [  487.278281] rtlwifi:rtl_op_set_key():<0-0> set enable_hw_sec, key_type:4(OPEN:0 WEP40:1 TKIP:2 AES:4 WEP104:5)
Dec 22 23:55:50 tofuschnitzel kernel: [  487.278284] rtlwifi:rtl_op_set_key():<0-0> set group key
Dec 22 23:55:50 tofuschnitzel kernel: [  487.278288] rtl8192se:rtl92se_set_key():<0-0> add one entry
Dec 22 23:55:50 tofuschnitzel kernel: [  487.278290] rtl8192se:rtl92se_set_key():<0-0> set group key
Dec 22 23:55:50 tofuschnitzel kernel: [  487.278891] rtlwifi:rtl_cam_add_one_entry():<0-0> <===
Dec 22 23:55:52 tofuschnitzel kernel: [  489.272265] wlan0: deauthenticated from 00:3a:9d:b4:54:5a (Reason: 2)

========================


Another strange message I got was this beautiful one:
Dec 22 23:45:55 tofuschnitzel kernel: [ 3882.413599] rtl8192se:rtl92s_phy_set_rf_power_state():<0-1> awake, sleeped:3591952 ms state_inap:0

***sleeped:3591952 ms***

This is *VERY* close to exactely 1 hours 60*60 = 360000 ms .... whatever that might be....

================

I don't know what other information I can provide.
I don't know if there is anyone who feels responsible.
I am willing to test and provide more data.

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
CRANLEIGH (n.)
A mood of irrational irritation with everyone and everything.
			--- Douglas Adams, The Meaning of Liff
