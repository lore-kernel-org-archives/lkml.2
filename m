Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762040Ab2FHQ0X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 12:26:23 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38462 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756885Ab2FHQ0V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 12:26:21 -0400
MIME-Version: 1.0
In-Reply-To: <1339051157.26966.97.camel@edumazet-glaptop>
References: <CAHFgRy9jgxOrF=b=oQd-zK5CKxDacOKdBAX_BEuyW+R+sK_GyQ@mail.gmail.com>
	<1339051157.26966.97.camel@edumazet-glaptop>
Date: Fri, 8 Jun 2012 12:26:20 -0400
Message-ID: <CAHFgRy-u3Xh=1XjrZi2x+=6bBdQ=Ve8i6jer9ppjYEWun70hxQ@mail.gmail.com>
Subject: Re: 3.5.0+ - Linus GIT - WARNING: at net/sched/sch_generic.c:255 dev_watchdog+0xeb/0x15f()
From: Miles Lane <miles.lane@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wim Van Sebroeck <wim@iguana.be>, Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>, netdev <netdev@vger.kernel.org>,
        Huang Xiong <xiong@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 7, 2012 at 2:39 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On Thu, 2012-06-07 at 02:16 -0400, Miles Lane wrote:
>> WARNING: at net/sched/sch_generic.c:255 dev_watchdog+0xeb/0x15f()
>> Hardware name: UL50VT
>> NETDEV WATCHDOG: eth0 (atl1c): transmit queue 0 timed out
>> Modules linked in: hfsplus hfs vfat msdos fat snd_hrtimer ipv6
>> snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep
>> snd_pcm_oss snd_seq_dummy snd_mixer_oss uvcvideo videobuf2_core
>> snd_pcm videodev snd_seq_oss snd_seq_midi snd_rawmidi media
>> snd_seq_midi_event acpi_cpufreq videobuf2_vmalloc videobuf2_memops
>> snd_seq iwlwifi snd_timer snd_seq_device asus_laptop mac80211
>> sparse_keymap snd cfg80211 coretemp soundcore psmouse snd_page_alloc
>> rtc_cmos mperf processor evdev rfkill battery led_class input_polldev
>> ac i915 nouveau sr_mod cdrom sd_mod ehci_hcd atl1c uhci_hcd intel_agp
>> ttm usbcore intel_gtt usb_common drm_kms_helper thermal video
>> thermal_sys hwmon button
>> Pid: 3025, comm: hud-service Not tainted 3.5.0-rc1+ #128
>> Call Trace:
>>  <IRQ>  [<ffffffff8102d42f>] warn_slowpath_common+0x7e/0x97
>>  [<ffffffff8102d4dc>] warn_slowpath_fmt+0x41/0x43
>>  [<ffffffff81360f1c>] dev_watchdog+0xeb/0x15f
>>  [<ffffffff8103af44>] run_timer_softirq+0x20e/0x356
>>  [<ffffffff8103ae7e>] ? run_timer_softirq+0x148/0x356
>>  [<ffffffff81360e31>] ? netif_tx_unlock+0x57/0x57
>>  [<ffffffff810344f8>] __do_softirq+0x103/0x239
>>  [<ffffffff8107122a>] ? clockevents_program_event+0x9c/0xb9
>>  [<ffffffff8140a4cc>] call_softirq+0x1c/0x30
>>  [<ffffffff81003bb9>] do_softirq+0x37/0x82
>>  [<ffffffff81034888>] irq_exit+0x4c/0xb1
>>  [<ffffffff8101ba71>] smp_apic_timer_interrupt+0x76/0x84
>>  [<ffffffff81409adc>] apic_timer_interrupt+0x6c/0x80
>>  <EOI>  [<ffffffff81105161>] ? fget_raw_light+0x4c/0x7d
>>  [<ffffffff81105161>] ? fget_raw_light+0x4c/0x7d
>>  [<ffffffff8111153b>] sys_fcntl+0x23/0x53b
>>  [<ffffffff81004b68>] ? print_context_stack+0x44/0xb1
>>  [<ffffffff81408fe2>] system_call_fastpath+0x16/0x1b
>> ---[ end trace c1f284d9c873031d ]---
>
> CC netdev and Huang Xiong
>
> Atheros drivers are known to have buggy tx completion, its incredible...
>
> You could try following patch, not a 'perfect' solution, but a fix.
>
> Thanks
>
> diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> index 9cc1570..31224f3 100644
> --- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> +++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> @@ -1551,10 +1551,12 @@ static bool atl1c_clean_tx_irq(struct atl1c_adapter *adapter,
>                atomic_set(&tpd_ring->next_to_clean, next_to_clean);
>        }
>
> +       spin_lock(&adapter->tx_lock);
>        if (netif_queue_stopped(adapter->netdev) &&
>                        netif_carrier_ok(adapter->netdev)) {
>                netif_wake_queue(adapter->netdev);
>        }
> +       spin_unlock(&adapter->tx_lock);
>
>        return true;
>  }
>
>
>
>

I tested this patch as well and got the following (identical to the
warning with the other patch you sent):

[  704.534177] atl1c 0000:04:00.0: atl1c: eth0 NIC Link is Up<100 Mbps
Full Duplex>
[  714.346649] ------------[ cut here ]------------
[  714.346670] WARNING: at net/sched/sch_generic.c:255 dev_watchdog+0xeb/0x15f()
[  714.346674] Hardware name: UL50VT
[  714.346679] NETDEV WATCHDOG: eth0 (atl1c): transmit queue 0 timed out
[  714.346854] Modules linked in: snd_hrtimer ipv6
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep
snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss
snd_seq_midi snd_rawmidi snd_seq_midi_event acpi_cpufreq snd_seq
iwlwifi uvcvideo snd_timer videobuf2_core snd_seq_device mac80211
videodev snd media videobuf2_vmalloc videobuf2_memops coretemp psmouse
cfg80211 soundcore snd_page_alloc rtc_cmos ac mperf battery processor
asus_laptop evdev sparse_keymap rfkill led_class input_polldev
acpi_call(O) i915 nouveau ttm fbcon tileblit font bitblit softcursor
drm_kms_helper drm fb fbdev intel_agp sr_mod cdrom ehci_hcd uhci_hcd
sd_mod cfbcopyarea i2c_algo_bit intel_gtt agpgart i2c_core mxm_wmi
atl1c usbcore cfbimgblt cfbfillrect usb_common thermal video backlight
thermal_sys hwmon wmi button
[  714.346864] Pid: 3230, comm: unity-panel-ser Tainted: G           O
3.5.0-rc1+ #132
[  714.346867] Call Trace:
[  714.346882]  <IRQ>  [<ffffffff8102d42f>] warn_slowpath_common+0x7e/0x97
[  714.346890]  [<ffffffff8102d4dc>] warn_slowpath_fmt+0x41/0x43
[  714.346914]  [<ffffffff81302028>] dev_watchdog+0xeb/0x15f
[  714.346923]  [<ffffffff8103af44>] run_timer_softirq+0x20e/0x356
[  714.346930]  [<ffffffff8103ae7e>] ? run_timer_softirq+0x148/0x356
[  714.346938]  [<ffffffff81301f3d>] ? netif_tx_unlock+0x57/0x57
[  714.346946]  [<ffffffff810344f8>] __do_softirq+0x103/0x239
[  714.346954]  [<ffffffff81071246>] ? clockevents_program_event+0x9c/0xb9
[  714.346964]  [<ffffffff813ab38c>] call_softirq+0x1c/0x30
[  714.346971]  [<ffffffff81003bb9>] do_softirq+0x37/0x82
[  714.346977]  [<ffffffff81034888>] irq_exit+0x4c/0xb1
[  714.346987]  [<ffffffff8101ba71>] smp_apic_timer_interrupt+0x76/0x84
[  714.346994]  [<ffffffff813aa99c>] apic_timer_interrupt+0x6c/0x80
[  714.347006]  <EOI>  [<ffffffff813a9ec7>] ? sysret_check+0x1b/0x56
[  714.347011] ---[ end trace 8a2db16274f46b16 ]---
