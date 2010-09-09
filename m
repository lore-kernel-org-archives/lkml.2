Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554Ab0IIC27 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 22:28:59 -0400
Received: from void.printf.net ([89.145.121.20]:34704 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780Ab0IIC2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 22:28:54 -0400
Date: Thu, 9 Sep 2010 03:28:34 +0100
From: Chris Ball <cjb@laptop.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Vorontsov <avorontsov@mvista.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Albert Herranz <albert_herranz@yahoo.es>,
        Matt Fleming <matt@console-pimps.org>, Ben Dooks <ben-linux@fluff.org>,
        Pierre Ossman <pierre@ossman.eu>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 0/8] sdhci: Move real work out of an atomic context
Message-ID: <20100909022834.GA10542@void.printf.net>
References: <20100714130728.GA27339@oksana.dev.rtsoft.ru> <20100907153813.936db0c6.akpm@linux-foundation.org> <20100908213740.GA7550@void.printf.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100908213740.GA7550@void.printf.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Sep 08, 2010 at 10:37:41PM +0100, Chris Ball wrote:
> Hi Andrew,
> 
> On Tue, Sep 07, 2010 at 03:38:13PM -0700, Andrew Morton wrote:
> > > I noticed no throughput drop neither with PIO transfers nor
> > > with DMA (tested on MPC8569E CPU), while latencies should be
> > > greatly improved.
> > 
> > This patchset isn't causing any problems yet, but may do so in the
> > future and will impact the validity of any testing.  It seems to be
> > kind of stuck.  Should I drop it all?
> 
> I suggest keeping it -- I'll find time to test it out here soon, and
> will keep it in mind as a possible regression cause.

Am running this now.  The first thing I'm noticing is a repeated BUG():

[    7.288186] Write protecting the kernel read-only data: 1072k
[    7.306446] BUG: sleeping function called from invalid context at kernel/mutex.c:94
[    7.324375] in_atomic(): 1, irqs_disabled(): 0, pid: 532, name: mmc2/0
[    7.340989] Pid: 532, comm: mmc2/0 Not tainted 2.6.35.4_xo1.5-20100908.2141.olpc.44f3b38_DIRTY #1
[    7.360129] Call Trace:
[    7.372843]  [<b04193ce>] __might_sleep+0xd9/0xe0
[    7.387864]  [<b07260cc>] mutex_lock+0x1c/0x2a
[    7.402576]  [<b06396e8>] sdhci_led_control+0x1a/0x41
[    7.417727]  [<b063bece>] led_trigger_event+0x42/0x5c
[    7.432807]  [<b06326f8>] mmc_request_done+0x56/0x6f
[    7.447597]  [<b063a2d1>] sdhci_finish_work+0xc8/0xcd
[    7.462643]  [<b063a209>] ? sdhci_finish_work+0x0/0xcd
[    7.477941]  [<b0432776>] worker_thread+0x165/0x1ed
[    7.492856]  [<b063a209>] ? sdhci_finish_work+0x0/0xcd
[    7.508204]  [<b0435591>] ? autoremove_wake_function+0x0/0x34
[    7.524178]  [<b0432611>] ? worker_thread+0x0/0x1ed
[    7.538953]  [<b04352a0>] kthread+0x63/0x68
[    7.552659]  [<b043523d>] ? kthread+0x0/0x68
[    7.566349]  [<b0402cf6>] kernel_thread_helper+0x6/0x10
[    7.709931] udev: starting version 141
[    7.940374] mmc2: new high speed SDHC card at address e4da
[    8.058165] mmcblk0: mmc2:e4da SU04G 3.69 GiB 
[    8.135730]  mmcblk0: p1 p2

Full dmesg is at http://chris.printf.net/anton-mutex-dmesg.txt. 
Anton, the kernel is 2.6.35.4-olpc plus your patchset from -mm.
I can think about how to test on an upstream kernel instead, but
perhaps your own tests simply didn't hit sdhci_led_control(). 

Andrew, if you want to drop this while the BUG() and potential
performance regressions are worked out, I'd be happy to keep 
testing patches from Anton until it's without regressions here.

Thanks,

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
