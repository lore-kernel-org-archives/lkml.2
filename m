Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461Ab0IVDSf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 23:18:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43263 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750933Ab0IVDSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 23:18:34 -0400
Date: Tue, 21 Sep 2010 20:17:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: Richard Purdie <rpurdie@rpsys.net>, Chris Ball <cjb@laptop.org>,
        Hein_Tibosch <hein_tibosch@yahoo.es>, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: mmotm 2010-09-15 - BUG in mmc driver calling
 led_trigger_event()
Message-Id: <20100921201758.66841897.akpm@linux-foundation.org>
In-Reply-To: <8581.1285124507@localhost>
References: <201009152352.o8FNqXGr022752@imap1.linux-foundation.org>
	<8581.1285124507@localhost>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Sep 2010 23:01:47 -0400 Valdis.Kletnieks@vt.edu wrote:

> On Wed, 15 Sep 2010 16:21:43 PDT, akpm@linux-foundation.org said:
> > The mm-of-the-moment snapshot 2010-09-15-16-21 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> 
> Dell Latitude E6500. lspci -v says:

Thanks again for testing this lot.

> 03:01.2 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (rev 21) (prog-if 01)
>         Subsystem: Dell Device 024f
>         Flags: bus master, medium devsel, latency 64, IRQ 18
>         Memory at f1bff600 (32-bit, non-prefetchable) [size=256]
>         Capabilities: [80] Power Management version 2
>         Kernel driver in use: sdhci-pci
> 
> Not consistently repeatable - I had 3 clean boots of this kernel, hit this the 4th time.
> 
> [    2.928661] Freeing unused kernel memory: 892k freed
> [    2.934051] BUG: sleeping function called from invalid context at kernel/mutex.c:278
> [    2.934440] in_atomic(): 1, irqs_disabled(): 0, pid: 11, name: kworker/0:1
> [    2.934777] 3 locks held by kworker/0:1/11:
> [    2.934780]  #0:  (((dev_name(&(mmc)->class_dev)))){+.+...}, at: [<ffffffff81052388>] process_one_work+0x1b5/0x49d
> [    2.934796]  #1:  ((&host->finish_work)){+.+...}, at: [<ffffffff81052388>] process_one_work+0x1b5/0x49d
> [    2.934806]  #2:  (&trigger->leddev_list_lock){.+.+..}, at: [<ffffffff813d464e>] led_trigger_event+0x22/0x75
> [    2.934821] Pid: 11, comm: kworker/0:1 Not tainted 2.6.36-rc4-mmotm0915 #2
> [    2.934825] Call Trace:
> [    2.934833]  [<ffffffff8102e456>] __might_sleep+0x124/0x129
> [    2.934840]  [<ffffffff8156559e>] mutex_lock_nested+0x20/0x39
> [    2.934846]  [<ffffffff813d1412>] sdhci_led_control+0x24/0x52
> [    2.934852]  [<ffffffff813d464e>] ? led_trigger_event+0x22/0x75
> [    2.934858]  [<ffffffff813d4682>] led_trigger_event+0x56/0x75
> [    2.934865]  [<ffffffff813c74c8>] mmc_request_done+0x5c/0x7a
> [    2.934871]  [<ffffffff813d1aba>] sdhci_finish_work+0xe6/0xef
> [    2.934877]  [<ffffffff81052472>] process_one_work+0x29f/0x49d
> [    2.934882]  [<ffffffff81052388>] ? process_one_work+0x1b5/0x49d
> [    2.934888]  [<ffffffff813d19d4>] ? sdhci_finish_work+0x0/0xef
> [    2.934895]  [<ffffffff81052d10>] worker_thread+0x17e/0x251
> [    2.934901]  [<ffffffff81052b92>] ? worker_thread+0x0/0x251
> [    2.934908]  [<ffffffff81056882>] kthread+0x7d/0x85
> [    2.934915]  [<ffffffff81003554>] kernel_thread_helper+0x4/0x10
> [    2.934922]  [<ffffffff815676c0>] ? restore_args+0x0/0x30
> [    2.934928]  [<ffffffff81056805>] ? kthread+0x0/0x85
> [    2.934934]  [<ffffffff81003550>] ? kernel_thread_helper+0x0/0x10
> [    2.941048] mmc0: mmc_rescan: trying to init card at 200000 Hz
> 

led_trigger_event() does read_lock() then calls led_set_brightness()
which indirectly calls sdhci_led_control() which does mutex_lock().  

That mutex_lock() was added by sdhci-turn-host-lock-into-a-mutex.patch.

Anton, those patches aren't going very well - I think I'll drop

sdhci-turn-timeout-timer-into-delayed-work.patch
sdhci-use-work-structs-instead-of-tasklets.patch
sdhci-use-work-structs-instead-of-tasklets-fix.patch
sdhci-clear-interrupt-status-register-just-once.patch
sdhci-use-threaded-irq-handler.patch
sdhci-turn-host-lock-into-a-mutex.patch
sdhci-get-rid-of-card-detect-work.patch
sdhci-get-rid-of-card-detect-work-fix.patch
sdhci-get-rid-of-mdelays-where-it-is-safe-and-makes-sense.patch
sdhci-use-jiffies-instead-of-a-timeout-counter.patch

