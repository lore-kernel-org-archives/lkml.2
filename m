Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab2FSTrf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 15:47:35 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:45976
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753482Ab2FSTre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 15:47:34 -0400
X-Forefront-Antispam-Report: CIP:160.33.194.230;KIP:(null);UIP:(null);IPV:NLI;H:usculsndmail03v.am.sony.com;RD:mail03.sonyusa.com;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zzbb2dI98dI1432Izz1202hzz8275bhz2fh2a8h668h839hd25hf0ah)
Message-ID: <4FE0D70F.2000607@am.sony.com>
Date: Tue, 19 Jun 2012 12:46:23 -0700
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Aaditya Kumar <aaditya.kumar.30@gmail.com>, <shaohua.li@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "C.Emde@osadl.org" <C.Emde@osadl.org>,
        "jkacur@redhat.com" <jkacur@redhat.com>,
        "Rowand, Frank" <Frank_Rowand@sonyusa.com>,
        "Bird, Tim" <Tim.Bird@am.sony.com>,
        "Ohara, Takuzo" <Takuzo.Ohara@ap.sony.com>,
        "Iibuchi, Kan (TDG)" <Kan.Iibuchi@jp.sony.com>
Subject: Re: [RFC][RT][PATCH] mm: Do not use stop_machine() for __zone_pcp_udpate()
 for CONFIG_PREEMPT_RT_FULL
References: <CAEtiSauEdKP3Jsi_O6Q=yc9AWkSKDvNrLe0faicQWJGqdKxLwg@mail.gmail.com>
In-Reply-To: <CAEtiSauEdKP3Jsi_O6Q=yc9AWkSKDvNrLe0faicQWJGqdKxLwg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding to the distribution list: the author of the patch that included
the call to stop_machine() (commit 112067f0905b2de862c607ee62411cf47d2fe5c4).

On 06/19/12 11:32, Aaditya Kumar wrote:
> The code path of __zone_pcp_update() has following locks, which in
> CONFIG_PREEMPT_RT_FULL=y are rt-mutex.
>   - pa_lock locked by cpu_lock_irqsave()
>   - zone->lock locked by free_pcppages_bulk()
> 
> Since __zone_pcp_update() is called from stop_machine(), so with
> CONFIG_PREEMPT_RT_FULL=y
> we get following backtrace when __zone_pcp_update() is called during
> memory hot plugging while
> doing heavy file I/O.
> 
> I think stop_machine() may not be required for calling __zone_pcp_update()
> in case of CONFIG_PREEMPT_RT_FULL=y as acquiring pa_lock in __zone_pcp_update()
> should be sufficient to isolate pcp pages and to setup per cpu pagesets.
> 
> Can someone please let me know if am missing anything here?
> 
> 
> The backtrace that this patch fixes:
>  BUG: scheduling while atomic: migration/0/7/0x00000002
>  Modules linked in: v2p
>  Backtrace:
>  [<800111a0>] (dump_backtrace+0x0/0x10c) from [<802d7b7c>]
> (dump_stack+0x18/0x1c)
>   r6:80c8fc28 r5:80c8f9a0 r4:00000000 r3:60000013
>  [<802d7b64>] (dump_stack+0x0/0x1c) from [<8001e81c>] (__schedule_bug+0x64/0x74)
>  [<8001e7b8>] (__schedule_bug+0x0/0x74) from [<802d7fa0>]
> (__schedule+0x68/0x604)
>   r4:8051bf00 r3:00000000
>  [<802d7f38>] (__schedule+0x0/0x604) from [<802d8a78>] (schedule+0x98/0xbc)
>  [<802d89e0>] (schedule+0x0/0xbc) from [<802d9e14>]
> (rt_spin_lock_slowlock+0x168/0x240)
>   r4:805228f4 r3:00000000
>  [<802d9cac>] (rt_spin_lock_slowlock+0x0/0x240) from [<802da234>]
> (rt_spin_lock+0x10/0x14)
>  [<802da224>] (rt_spin_lock+0x0/0x14) from [<8008694c>]
> (__zone_pcp_update+0x58/0xd8)
>  [<800868f4>] (__zone_pcp_update+0x0/0xd8) from [<800603ec>]
> (stop_machine_cpu_stop+0xb0/0x104)
>  [<8006033c>] (stop_machine_cpu_stop+0x0/0x104) from [<80060200>]
> (cpu_stopper_thread+0xd4/0x188)
> 
> 
> Signed-off-by: Aaditya Kumar <aaditya.kumar@ap.sony.com>
> 
> ---
>  mm/page_alloc.c |    4 	4 +	0 -	0 !
>  1 file changed, 4 insertions(+)
> 
> Index: b/mm/page_alloc.c
> ===================================================================
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3868,7 +3868,11 @@ static int __zone_pcp_update(void *data)
> 
>  void zone_pcp_update(struct zone *zone)
>  {
> +#ifndef CONFIG_PREEMPT_RT_FULL
>  	stop_machine(__zone_pcp_update, zone, NULL);
> +#else
> +	__zone_pcp_update(zone);
> +#endif
>  }
> 
>  static __meminit void zone_pcp_init(struct zone *zone)
> 
> .
> 


