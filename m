Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760978Ab1D2VP5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 17:15:57 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48047 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760875Ab1D2VPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 17:15:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-pgp-id:x-archive
         :user-agent;
        b=ZP0vvXssRc2812HKmGUFwM4KdgJkVI8Pbkn9xGF/2tstG3IjUIfJYPZo7W7fFwacvz
         2xSFN7RwA1OebEcm0wRs1sxnEjjQNvYuD/vS2Zo2IU1/HHkzRy7Fc5LBL9F+vn4eGGho
         /zRYxBP4roVqWA1bM2ePjHNwzegcrGKDg2+JM=
Date: Fri, 29 Apr 2011 23:15:48 +0200
From: clemens fischer <ino-news@spotteswoode.dnsalias.org>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, wlanfae@realtek.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: r8712u: Fix driver to support ad-hoc mode
Message-ID: <20110429211548.GA4351@spotteswoode.de.eu.org>
References: <4db8436a.NDzkd3ql2wJdwy2L%Larry.Finger@lwfinger.net>
 <20110428150819.GA3713@spotteswoode.de.eu.org>
 <4DB9884F.10409@lwfinger.net>
 <BANLkTin7Nw1ZjK8UHfypHXY5ZuzafXnJbQ@mail.gmail.com>
 <20110428201527.GA3738@spotteswoode.de.eu.org>
 <BANLkTimi4cUzS5-r_ofzLnjbVtNNjwD69Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimi4cUzS5-r_ofzLnjbVtNNjwD69Q@mail.gmail.com>
X-PGP-ID: 0x214190AF
X-Archive: encrypt=none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Jeff Chua:

> Try this. This is my working config.
>
> # /etc/wpa1.conf
> ap_scan=2       # 0 does not work. 1 is ok. 2 is fast.
>
> network={
>         auth_alg=SHARED
>         mode=1          # ad-hoc
>         group=WEP104
>         ssid="yourSSID"
>         wep_key0=1234567890ABCDEF123456678
>         wep_tx_keyidx=0
>         key_mgmt=NONE
>         priority=0
>         scan_ssid=0
>         frequency=2412
> }
>
> # modprobe r8712u
> # iwconfig     <- you should be able to see 'wlan0' or 'wlan1' if
> you've more than 1 wireless
> # ifconfig wlan0 up
> # wpa_supplicant -i wlan0 -c /etc/wpa1.conf

Sorry, no dice here.  But before you start weeping, it doesn't seem to
be a problem with the driver.

  0 3 # iwconfig wlan0
  wlan0     IEEE 802.11bgn  ESSID:"manamana"  Nickname:"rtl_wifi"
            Mode:Ad-Hoc  Frequency:2.412 GHz  Cell: 02:11:87:68:0D:A4
            Bit Rate:150 Mb/s   Sensitivity:0/0
            Retry:off   RTS thr:off   Fragment thr:off
            Encryption key:off
            Power Management:off
            Link Quality=100/100  Signal level=58/100  Noise level=0/100
            Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
            Tx excessive retries:0  Invalid misc:0   Missed beacon:0

  0 4 # wpa_supplicant -i wlan0 -c /etc/wpa_supplicant.conf
  CTRL-EVENT-DISCONNECTED bssid=00:00:00:00:00:00 reason=0
  Trying to associate with SSID 'manamana'
  CTRL-EVENT-DISCONNECTED bssid=00:00:00:00:00:00 reason=0
  Associated with 02:11:87:68:0d:a4
  CTRL-EVENT-CONNECTED - Connection to 02:11:87:68:0d:a4 completed (auth) [id=0 id_str=]
  Associated with 02:11:87:68:0d:a4
  CTRL-EVENT-CONNECTED - Connection to 02:11:87:68:0d:a4 completed (reauth) [id=0 id_str=]

I cannot find out what it is:  "dnsmasq(8)" even gives out a lease, the
firewall doesn't block any packets etc.  Note that "wpa_supplicant(8)"
could set the ESSID while "iwconfig(8)" couldn't.  I think it has to do
with my mobile, a window$-mobile-6.1 device, because I cannot see the
typical log entries:

  client provides name: wince
  vendor class: Microsoft Windows CE
  DHCPREQUEST(wlan0) 192.168.3.2 ...
  DHCPACK(wlan0) 192.168.3.2 ...
  requested options: 1:netmask, ...

The old driver "r8192s_usb" that could be configured with "iwconfig(8)"
made these settings:

  0 3 # iwconfig wlan0
  wlan0     802.11b/g  link  ESSID:"mana"
            Mode:Ad-Hoc  Frequency=2.412 GHz  Cell: 12:7D:42:55:8D:38
            Bit Rate=54 Mb/s
            Retry min limit:7   RTS thr:off   Fragment thr:off
            Encryption key:7370-6F74-74   Security mode:restricted
            Power Management period:5s  mode:All packets received
            Link Quality=0/100  Signal level=0 dBm  Noise level=0 dBm
            Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
            Tx excessive retries:0  Invalid misc:0   Missed beacon:0

Here's a cut out from my setup script:

wlan_settings="${wlan_settings} essid ${station_id}"
wlan_settings="${wlan_settings} mode Ad-Hoc"
wlan_settings="${wlan_settings} channel 5"
wlan_settings="${wlan_settings} power 5s all"
wlan_settings="${wlan_settings} key restricted ${wlan_passkey}"

To match the "iwconfig(8)" output from the working setup better, I put
this line into "/etc/modprobe.d/modprobe.conf":

  options r8712u ht_enable=0

and got this, using "wpa_supplicant(8)":

  0 3 # iwconfig wlan0
  wlan0     IEEE 802.11bg  ESSID:"mana"  Nickname:"rtl_wifi"
            Mode:Ad-Hoc  Frequency:2.412 GHz  Cell: 02:11:87:DB:EC:D7
            Bit Rate:54 Mb/s   Sensitivity:0/0
            Retry:off   RTS thr:off   Fragment thr:off
            Encryption key:off
            Power Management:off
            Link Quality=100/100  Signal level=96/100  Noise level=0/100
            Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
            Tx excessive retries:0  Invalid misc:0   Missed beacon:0

Note the lower "Bit Rate", but this didn't make things better.  BTW,
documentation of the "r8712u" module parameters would be nice.

  wifi_test:int               vrtl_carrier_sense:int
  video_mode:int              vcs_type:int
  chip_version:int            busy_thresh:int
  rfintfs:int                 ht_enable:int
  lbkmode:int                 cbw40_enable:int
  hci:int                     ampdu_enable:int
  network_mode:int            rf_config:int
  channel:int                 power_mgnt:int
  mp_mode:int                 low_power:int
  wmm_enable:int
  ifname: Net interface name, wlan%d=default (string)
  initmac:MAC-Address, default: use FUSE (charp)

I mean, the names can be got from "modinfo(8)", but then people must
read driver sources, which is not exactly user-friendly.

All in all, I think "r8712u" is getting better and I would love to use
it, if only because "r8192s_usb" leaks memory
(CONFIG_ARCH_WANT_FRAME_POINTERS debug/kmemleak).


regards, clemens
