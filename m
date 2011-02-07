Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073Ab1BGFe5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 00:34:57 -0500
Received: from gate.crashing.org ([63.228.1.57]:59264 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597Ab1BGFe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 00:34:56 -0500
Subject: Re: Sun GEM PPC32 Bug?
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "R. Herbst" <ruediger.herbst@googlemail.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        Matt <jackdachef@gmail.com>, geert@linux-m68k.org
In-Reply-To: <AANLkTin4ha5tkU_xgxkq7Kr6dG1-C2xR_04kBOrAngLH@mail.gmail.com>
References: <AANLkTin4ha5tkU_xgxkq7Kr6dG1-C2xR_04kBOrAngLH@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Feb 2011 16:34:38 +1100
Message-ID: <1297056878.14982.65.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What's your machine model (cat /proc/cpuinfo) and what do you do to
trigger the problem ? I'm trying to reproduce here and so far had
no success doing so.

Cheers,
Ben.

On Sun, 2011-02-06 at 16:01 +0100, R. Herbst wrote:
> Am 06.02.2011 00:45, schrieb Benjamin Herrenschmidt:
> >
> >
> > Actually, the second one is trivial, just modify gem_rxmac_interrupt()
> > as follow:
> >
> > 	if (rxmac_stat & MAC_RXSTAT_OFLW) {
> > 		u32 smac = readl(gp->regs + MAC_SMACHINE);
> >
> > 		netdev_err(dev, "RX MAC fifo overflow smac[%08x]\n", smac);
> > 		gp->net_stats.rx_over_errors++;
> > 		gp->net_stats.rx_fifo_errors++;
> >
> > -		ret = gem_rxmac_reset(gp);
> > +		ret = 1;
> > 	}
> >
> > And tell us if that makes a difference.
> >
> > Cheers,
> > Ben.
> >
> 
> Okay. I have made the change. The only difference is that:
> 
>      In /var/log/messages
> Feb  6 15:52:12 G4 kernel: gem 0002:20:0f.0: eth0: RX MAC fifo
> overflow smac[00810400]
> Feb  6 15:52:12 G4 kernel: gem 0002:20:0f.0: eth0: Link is up at 1000
> Mbps, full-duplex
> Feb  6 15:52:12 G4 kernel: gem 0002:20:0f.0: eth0: Pause is disabled
> Feb  6 15:57:10 G4 kernel: NETDEV WATCHDOG: eth0 (gem): transmit queue
> 0 timed out
> Feb  6 15:57:10 G4 kernel: ------------[ cut here ]------------
> Feb  6 15:57:10 G4 kernel: WARNING: at net/sched/sch_generic.c:258
> Feb  6 15:57:10 G4 kernel: Modules linked in: radeon ttm
> drm_kms_helper drm hwmon power_supply ipv6 snd_pcm_oss snd_mixer_oss
> snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
> snd_powermac snd_pcm snd_timer snd soundcore snd_page_alloc dm_mod
> uninorth_agp sungem agpgart sungem_phy
> Feb  6 15:57:10 G4 kernel: NIP: c03dceec LR: c03dceec CTR: 00000001
> Feb  6 15:57:10 G4 kernel: REGS: effefe20 TRAP: 0700   Not tainted
> (2.6.37-gentoo)
> Feb  6 15:57:10 G4 kernel: MSR: 00029032 <EE,ME,CE,IR,DR>  CR:
> 44200084  XER: 20000000
> Feb  6 15:57:10 G4 kernel: TASK = ef854cb0[0] 'swapper' THREAD: ef878000 CPU: 1
> Feb  6 15:57:10 G4 kernel: GPR00: c03dceec effefed0 ef854cb0 0000003e
> 00001032 ffffffff c059f182 2074696d
> Feb  6 15:57:10 G4 kernel: GPR08: 000069f7 effee000 01ea1000 00000004
> ffffffff fff80b18 fff80154 00000000
> Feb  6 15:57:10 G4 kernel: GPR16: 00000420 c03dcd4c c0589084 00200200
> c04c9786 ef888814 ef888a14 ef888c14
> Feb  6 15:57:10 G4 kernel: GPR24: 00000001 ffffffff ef12e7a0 00000002
> 00000001 00000000 ef8141d4 ef814000
> Feb  6 15:57:10 G4 kernel: NIP [c03dceec] dev_watchdog+0x1a0/0x2e4
> Feb  6 15:57:10 G4 kernel: LR [c03dceec] dev_watchdog+0x1a0/0x2e4
> Feb  6 15:57:10 G4 kernel: Call Trace:
> Feb  6 15:57:10 G4 kernel: [effefed0] [c03dceec]
> dev_watchdog+0x1a0/0x2e4 (unreliable)
> Feb  6 15:57:10 G4 kernel: [effeff40] [c0043db4] run_timer_softirq+0x1ac/0x260
> Feb  6 15:57:10 G4 kernel: [effeffa0] [c003d9cc] __do_softirq+0x118/0x1ec
> Feb  6 15:57:10 G4 kernel: [effefff0] [c0011398] call_do_softirq+0x14/0x24
> Feb  6 15:57:10 G4 kernel: [ef879ea0] [c000687c] do_softirq+0x88/0xb4
> Feb  6 15:57:10 G4 kernel: [ef879ec0] [c003d178] irq_exit+0x54/0x74
> Feb  6 15:57:10 G4 kernel: [ef879ed0] [c000ead4] timer_interrupt+0x154/0x190
> Feb  6 15:57:10 G4 kernel: [ef879ee0] [c0012080] ret_from_except+0x0/0x14
> Feb  6 15:57:10 G4 kernel: --- Exception: 901 at cpu_idle+0xe0/0x180
> Feb  6 15:57:10 G4 kernel: LR = cpu_idle+0xd4/0x180
> Feb  6 15:57:10 G4 kernel: [ef879fa0] [c000a4f8] cpu_idle+0x170/0x180
> (unreliable)
> Feb  6 15:57:10 G4 kernel: [ef879fc0] [c044952c] start_secondary+0x314/0x350
> Feb  6 15:57:10 G4 kernel: [ef879ff0] [00003270] 0x3270
> Feb  6 15:57:10 G4 kernel: Instruction dump:
> Feb  6 15:57:10 G4 kernel: 2f800001 41be003c 38810008 7fe3fb78
> 38a00040 4bfe77c9 7fa6eb78 7fe4fb78
> Feb  6 15:57:10 G4 kernel: 7c651b78 3c60c050 3863ed12 48068721
> <0fe00000> 38000001 3d20c05c 9809d3bc
> Feb  6 15:57:10 G4 kernel: ---[ end trace 876ff0d47c88271d ]---
> Feb  6 15:57:10 G4 kernel: gem 0002:20:0f.0: eth0: transmit timed out, resetting
> Feb  6 15:57:10 G4 kernel: gem 0002:20:0f.0: eth0:
> TX_STATE[00000001:00000000:00000001]
> Feb  6 15:57:10 G4 kernel: gem 0002:20:0f.0: eth0:
> RX_STATE[0609441d:00000001:00000001]
> Feb  6 15:57:10 G4 kernel: gem 0002:20:0f.0: eth0: Link is up at 1000
> Mbps, full-duplex
> Feb  6 15:57:10 G4 kernel: gem 0002:20:0f.0: eth0: Pause is disabled
> ---
> It seems that the Network dies and halt for ca. 25 seconds. After a
> while it comes a call trace and the rsync session is dead. But not the
> hole system dies.
> 
> Regards
> Rüdi


