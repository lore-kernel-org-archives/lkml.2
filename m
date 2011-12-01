Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776Ab1LAMEN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 07:04:13 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37472 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691Ab1LAMEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 07:04:11 -0500
Date: Thu, 1 Dec 2011 20:04:01 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [3.2-rc3] 100% CPU usage while in del_timer_sync from
 iwl3945_rs_free_sta
Message-ID: <20111201120400.GA2112@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <20111129100727.GD2675@tiehlicka.suse.cz>
 <20111129113906.GA7299@redhat.com>
 <20111130101028.GA2906@tiehlicka.suse.cz>
 <20111130142316.GA2466@redhat.com>
 <20111130140316.GA4153@tiehlicka.suse.cz>
 <20111130153929.GA2144@redhat.com>
 <20111201085845.GA4602@tiehlicka.suse.cz>
 <20111201105538.GA4504@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20111201105538.GA4504@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 01, 2011 at 11:55:38AM +0100, Michal Hocko wrote:
> On Thu 01-12-11 09:58:45, Michal Hocko wrote:
> [...]
> > I will try to turn on timer debugging suggested by Yong Zhang in other
> > email.
> 
> OK, so applied the following commits:
> $ git shortlog master..
> Christine Chan (2):
>       timer: Use debugobjects to catch deletion of uninitialized timers
>       debugobjects: Extend to assert that an object is initialized
> 
> Michal Hocko (1):
>       Debugging patch
> 
> Stephen Boyd (2):
>       timer: Setup uninitialized timer with a stub callback
>       debugobjects: Be smarter about static objects
> 
> Debugging patch is the one from Stanislaw posted earlier in the thread.
> It prevents del_timer_sync and warns on NULL timer in iwl3945_rs_free_sta.
> Also turned on the suggested DEBUG_OBJECTS_TIMERS.
> 
> I do not see any timer related warnings. I will try it with the slightly
> modified Debugging patch and just warn without returning before calling
> del_timer_sync.
> 
> [  349.316076] ------------[ cut here ]------------
> [  349.316097] WARNING: at drivers/net/wireless/iwlegacy/iwl-3945-rs.c:438 iwl3945_rs_free_sta+0x33/0x42 [iwl3945]()
> [  349.316105] Hardware name: LIFEBOOK S7110
> [  349.316110] Modules linked in: aes_i586 aes_generic i915 fbcon font bitblit softcursor drm_kms_helper drm fb fbdev i2c_algo_bit cfbcopyarea i2c_core cfbimgblt cfbfillrect fuse tun coretemp hwmon snd_hda_codec_realtek arc4 snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss iwl3945 snd_pcm iwl_legacy snd_seq_oss snd_seq_midi_event mac80211 snd_seq snd_timer snd_seq_device cfg80211 snd video snd_page_alloc fujitsu_laptop backlight [last unloaded: scsi_wait_scan]
> [  349.316203] Pid: 12, comm: kworker/u:1 Tainted: G        W    3.2.0-rc3-timerstest-00009-g762dd0e #20

                                                              ^
			seems there was warning but we did't catch it, right?
			not sure if it's related.
Thanks,
Yong

> [  349.316209] Call Trace:
> [  349.316223]  [<c01331b4>] warn_slowpath_common+0x68/0x7d
> [  349.316237]  [<f8169454>] ? iwl3945_rs_free_sta+0x33/0x42 [iwl3945]
> [  349.316247]  [<c01331dd>] warn_slowpath_null+0x14/0x18
> [  349.316260]  [<f8169454>] iwl3945_rs_free_sta+0x33/0x42 [iwl3945]
> [  349.316283]  [<f8102f94>] __sta_info_free.isra.24+0x28/0x60 [mac80211]
> [  349.316304]  [<f8103df9>] __sta_info_destroy+0x259/0x283 [mac80211]
> [  349.316328]  [<f8104194>] sta_info_flush+0x43/0x6e [mac80211]
> [  349.316353]  [<f8109453>] ieee80211_set_disassoc+0x1a3/0x1d7 [mac80211]
> [  349.316379]  [<f81095e8>] ieee80211_sta_connection_lost+0x31/0x8a [mac80211]
> [  349.316390]  [<c031208f>] ? dev_printk+0x2b/0x2d
> [  349.316416]  [<f810bde2>] ieee80211_sta_work+0x1b0/0x1c3 [mac80211]
> [  349.316446]  [<f810e38a>] ieee80211_iface_work+0x23e/0x250 [mac80211]
> [  349.316457]  [<c01468af>] process_one_work+0x19b/0x2e6
> [  349.316483]  [<f810e14c>] ? ieee80211_netdev_select_queue+0x14/0x14 [mac80211]
> [  349.316492]  [<c0146ddd>] worker_thread+0x136/0x1ee
> [  349.316501]  [<c0146ca7>] ? manage_workers.isra.23+0x14f/0x14f
> [  349.316509]  [<c014a0f5>] kthread+0x67/0x6c
> [  349.316517]  [<c014a08e>] ? kthread_worker_fn+0x119/0x119
> [  349.316527]  [<c04762f6>] kernel_thread_helper+0x6/0x10
> [  349.316532] ---[ end trace 5cf96275a244e7ca ]---
> [  349.316538] ieee80211 phy0: Destroyed STA 00:0b:6b:3c:8c:e4
> [  349.316556] ieee80211 phy0: device now idle
> [  349.328105] cfg80211: Calling CRDA to update world regulatory domain
> [  349.416952] ieee80211 phy0: device no longer idle - scanning
> [  353.091211] ieee80211 phy0: device now idle
> [  358.092230] ieee80211 phy0: device no longer idle - scanning
> [  361.772470] ieee80211 phy0: device now idle
> [  366.774826] ieee80211 phy0: device no longer idle - scanning
> [  370.448401] ieee80211 phy0: device now idle
> [  375.455127] ieee80211 phy0: device no longer idle - scanning
> [  379.127638] ieee80211 phy0: device now idle
> [  384.131847] ieee80211 phy0: device no longer idle - scanning
> [  387.806711] ieee80211 phy0: device now idle
> [  396.708125] sky2 0000:02:00.0: lan0: Link is up at 1000 Mbps, full duplex, flow control both
> [  407.120063] lan0: no IPv6 routers present
> [  434.003896] ieee80211 phy0: device no longer idle - scanning
> [  438.694843] ieee80211 phy0: device now idle
> [  441.485602] process `skype' is using obsolete setsockopt SO_BSDCOMPAT
> [  494.004619] ieee80211 phy0: device no longer idle - scanning
> [  498.698796] ieee80211 phy0: device now idle
> [  554.004822] ieee80211 phy0: device no longer idle - scanning
> [  558.697908] ieee80211 phy0: device now idle
> [  614.003956] ieee80211 phy0: device no longer idle - scanning
> [  618.700408] ieee80211 phy0: device now idle
> [  674.004164] ieee80211 phy0: device no longer idle - scanning
> [  678.702423] ieee80211 phy0: device now idle
> 
> -- 
> Michal Hocko
> SUSE Labs
> SUSE LINUX s.r.o.
> Lihovarska 1060/12
> 190 00 Praha 9    
> Czech Republic
