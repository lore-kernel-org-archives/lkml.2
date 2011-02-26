Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618Ab1BZIV4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 03:21:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42821 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528Ab1BZIVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 03:21:55 -0500
Date: Sat, 26 Feb 2011 09:21:49 +0100
From: Michal Hocko <mhocko@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, David Miller <davem@davemloft.net>,
        torvalds@linux-foundation.org, ebiederm@xmission.com
Subject: Another list corruption in networking stack with
 2.6.38-rc6-00020-gd8204a3?
Message-ID: <20110226082149.GA9623@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have just seen another list head corruption when returning back from
suspend to RAM. This time it is caught by LIST_DEBUG code:

[107347.331504] wlan0: deauthenticated from 00:24:01:93:0a:00 (Reason: 6)
[107347.392082] cfg80211: Calling CRDA to update world regulatory domain
[107361.892264] ------------[ cut here ]------------
[107361.892280] WARNING: at lib/list_debug.c:53 __list_del_entry+0x62/0x71()
[107361.892286] Hardware name: LIFEBOOK S7110
[107361.892291] list_del corruption. prev->next should be f3a7105c, but was f2c3c0c4
[107361.892297] Modules linked in: iwl3945(-) iwlcore mac80211 cfg80211 aes_i586 aes_generic i915 fbcon font bitblit softcursor drm_kms_helper drm fb fbdev i2c_algo_bit cfbcopyarea i2c_core cfbimgblt cfbfillrect fuse tun coretemp hwmon snd_hda_codec_realtek snd_hda_intel arc4 ecb snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_oss snd_seq_midi_event snd_seq fujitsu_laptop snd_timer snd_seq_device snd rtc_cmos video rtc_core rtc_lib backlight snd_page_alloc [last unloaded: cfg80211]
[107361.892386] Pid: 9323, comm: rmmod Tainted: G   M        2.6.38-rc6-00020-gd8204a3 #100
[107361.892392] Call Trace:
[107361.892404]  [<c0135243>] ? warn_slowpath_common+0x6a/0x7f
[107361.892412]  [<c02981e2>] ? __list_del_entry+0x62/0x71
[107361.892420]  [<c01352cb>] ? warn_slowpath_fmt+0x2b/0x2f
[107361.892428]  [<c02981e2>] ? __list_del_entry+0x62/0x71
[107361.892439]  [<c03b206c>] ? unregister_netdevice_queue+0x41/0x6e
[107361.892463]  [<f83f7b39>] ? ieee80211_remove_interfaces+0x7b/0x9a [mac80211]
[107361.892481]  [<f83ec19d>] ? ieee80211_unregister_hw+0x48/0xf9 [mac80211]
[107361.892496]  [<f8264906>] ? iwl3945_pci_remove+0x8d/0x4b9 [iwl3945]
[107361.892505]  [<c02a3193>] ? pci_device_remove+0x1e/0x3e
[107361.892514]  [<c0303198>] ? __device_release_driver+0x4a/0x80
[107361.892522]  [<c030323a>] ? driver_detach+0x6c/0x8a
[107361.892529]  [<c03026f2>] ? bus_remove_driver+0x6e/0x8a
[107361.892537]  [<c0303674>] ? driver_unregister+0x50/0x57
[107361.892545]  [<c02a3367>] ? pci_unregister_driver+0x32/0x6b
[107361.892559]  [<f8264d44>] ? iwl3945_exit+0x12/0x2ce [iwl3945]
[107361.892568]  [<c015fa19>] ? sys_delete_module+0x183/0x1db
[107361.892578]  [<c01aa7b4>] ? remove_vma+0x46/0x4c
[107361.892586]  [<c01ab666>] ? do_munmap+0x21c/0x236
[107361.892596]  [<c0102890>] ? sysenter_do_call+0x12/0x26
[107361.892604] ---[ end trace 86d7c6f30bb607c2 ]---
[107362.020197] PM: Removing info for No Bus:wlan0
[107362.052073] PM: Removing info for No Bus:phy0

I am currently on 2.6.38-rc6-00020-gd8204a3 which already contains some
list_del fixes but I remember that there were still some of them
pending. I can really see at least 5f04d5068 which I do not have. Is it
possible that it fixes the above corruption? 

The config is attached.
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
