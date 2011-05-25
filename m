Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab1EYR2x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 13:28:53 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:43956 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab1EYR2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 13:28:52 -0400
Subject: Re: Mysterious CFQ crash and RCU
From: Paul Bolle <pebolle@tiscali.nl>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Date: Wed, 25 May 2011 19:28:48 +0200
In-Reply-To: <4DDCC1E4.706@fusionio.com>
References: <20110519222404.GG12600@redhat.com>
			 <20110521210013.GJ2271@linux.vnet.ibm.com>
			 <20110523152141.GB4019@redhat.com>
			 <20110523153848.GC2310@linux.vnet.ibm.com>
		 <1306189249.15900.10.camel@t41.thuisdomein> <4DDB7D36.60905@fusionio.com>
	 <1306312155.9059.8.camel@t41.thuisdomein> <4DDCC1E4.706@fusionio.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.1 (3.1.1-3.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1306344530.21978.5.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-25 at 10:46 +0200, Jens Axboe wrote:
> I don't think we are dealing with bad RCU usage in CFQ. My gut tells me
> that this is related to the merging of cooperating queues. It fits
> roughly with the time frame of when this issue started occuring, and
> some of that reference logic looks fragile/racy.
> 
> So if you _can_ test a patch easily, please try this one. It'll disable
> that logic.

I'm sorry, but with that patch (adapted to out previous discussion, so
simply returning NULL) applied I still hit the same Oops:

[  417.526021] Oops: 0000 [#1] SMP 
[  417.526021] last sysfs file: /sys/devices/pci0000:00/0000:00:1f.1/host0/target0:0:0/0:0:0:0/block/sda/queue/scheduler
[  417.526021] Modules linked in: cfq_iosched cpufreq_ondemand acpi_cpufreq mperf bnep bluetooth nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_ipv4 ip6t_REJECT nf_defrag_ipv4 nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables arc4 ppdev ath5k snd_intel8x0m snd_intel8x0 ath snd_ac97_codec mac80211 microcode ac97_bus snd_seq snd_seq_device snd_pcm cfg80211 joydev pcspkr thinkpad_acpi parport_pc e1000 rfkill parport snd_timer snd iTCO_wdt soundcore snd_page_alloc i2c_i801 iTCO_vendor_support uinput ipv6 yenta_socket video radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
[  417.526021] 
[  417.526021] Pid: 30030, comm: mandb Not tainted 2.6.39-0.local5.fc16.i686 #1 IBM        /       
[  417.526021] EIP: 0060:[<f7efe929>] EFLAGS: 00010202 CPU: 0
[  417.526021] EIP is at call_for_each_cic+0x29/0x44 [cfq_iosched]
[  417.526021] EAX: 00000001 EBX: 6b6b6b6b ECX: 00000246 EDX: c0aa4a98
[  417.526021] ESI: f2f53580 EDI: f7efec18 EBP: edda5f18 ESP: edda5f0c
[  417.526021]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  417.526021] Process mandb (pid: 30030, ti=edda4000 task=f6a1d4c0 task.ti=edda4000)
[  417.526021] Stack:
[  417.526021]  f2f53580 f6a1d4c0 f6a1d890 edda5f20 f7efe956 edda5f2c c05e0506 f2f53580
[  417.526021]  edda5f40 c05e0596 f6a1d4c0 00000012 edda5f74 edda5f8c c044149f f646631c
[  417.526021]  f64662c0 00000009 f6a1d4c0 00000007 f6a1d6c4 f6a1d4b8 f6a1d6c4 00000001
[  417.526021] Call Trace:
[  417.526021]  [<f7efe956>] cfq_free_io_context+0x12/0x14 [cfq_iosched]
[  417.526021]  [<c05e0506>] put_io_context+0x34/0x5c
[  417.526021]  [<c05e0596>] exit_io_context+0x68/0x6d
[  417.526021]  [<c044149f>] do_exit+0x63e/0x661
[  417.526021]  [<c04416d9>] do_group_exit+0x63/0x86
[  417.526021]  [<c0441714>] sys_exit_group+0x18/0x18
[  417.526021]  [<c081cc9f>] sysenter_do_call+0x12/0x38
[  417.526021] Code: 5d c3 55 89 e5 57 56 53 3e 8d 74 26 00 89 c6 89 d7 e8 01 db ff ff 8b 5e 4c e8 50 5b 55 c8 85 c0 74 05 e8 b7 ff ff ff 85 db 74 11 <8b> 03 0f 18 00 90 8d 53 d8 89 f0 ff d7 8b 1b eb dd e8 10 db ff 
[  417.526021] EIP: [<f7efe929>] call_for_each_cic+0x29/0x44 [cfq_iosched] SS:ESP 0068:edda5f0c
[  417.526021] CR2: 000000006b6b6b6b
[  417.717510] ---[ end trace 24344cc07101e5e5 ]---

(That last sysfs file apparently was because I now had to switch to from
deadline to cfq manually.)



Paul Bolle

