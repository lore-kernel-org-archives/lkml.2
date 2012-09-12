Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab2ILF52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 01:57:28 -0400
Received: from magic.merlins.org ([209.81.13.136]:42871 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab2ILF51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 01:57:27 -0400
Date: Tue, 11 Sep 2012 22:57:12 -0700
From: Marc MERLIN <marc@merlins.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
        David Rientjes <rientjes@google.com>, sgruszka@redhat.com,
        linux-wireless@vger.kernel.org, johannes.berg@intel.com,
        wey-yi.w.guy@intel.com, ilw@linux.intel.com,
        Andrew Morton <akpm@osdl.org>, Mel Gorman <mgorman@suse.de>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: iwl3945: order 5 allocation during ifconfig up; vm problem?
Message-ID: <20120912055712.GE11613@merlins.org>
References: <20120909213228.GA5538@elf.ucw.cz> <alpine.DEB.2.00.1209091539530.16930@chino.kir.corp.google.com> <20120910111113.GA25159@elf.ucw.cz> <20120911162536.bd5171a1.akpm@linux-foundation.org> <1347426988.13103.684.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347426988.13103.684.camel@edumazet-glaptop>
X-Sysadmin: BOFH
X-URL: http://marc.merlins.org/
X-Operating-System: Proudly running Linux 3.1.5-core2-volpreempt-noide-hm64-20111218/Debian squeeze/sid
X-Mailer: Some Outlooks can't quote properly without this header
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: marc@merlins.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 07:16:28AM +0200, Eric Dumazet wrote:
> On Tue, 2012-09-11 at 16:25 -0700, Andrew Morton wrote:
> 
> > Asking for a 256k allocation is pretty crazy - this is an operating
> > system kernel, not a userspace application.
> > 
> > I'm wondering if this is due to a recent change, but I'm having trouble
> > working out where the allocation call site is.
> > --
> 
> (Adding Marc Merlin to CC, since he reported same problem)
> 
> Thats the firmware loading in iwlwifi driver. Not sure if it can use SG.
> 
> drivers/net/wireless/iwlwifi/iwl-drv.c
> 
> iwl_alloc_ucode() -> iwl_alloc_fw_desc() -> dma_alloc_coherent()
> 
> It seems some sections of /lib/firmware/iwlwifi*.ucode files are above
> 128 Kbytes, so dma_alloc_coherent() try order-5 allocations

Thanks for looping me in, yes, this looks very familiar to me :)

In the other thread, Johannes Berg gave me this patch which is supposed to
help: http://p.sipsolutions.net/11ea33b376a5bac5.txt

Unfortunately due to very long work days, I haven't had the time to try it
out yet, but I will soon.

Would that help in this case too?

And to answer David Rientjes, I also have compaction on:
gandalfthegreat:~# zgrep CONFIG_COMPACTION /proc/config.gz 
CONFIG_COMPACTION=y

Full config:
http://marc.merlins.org/tmp/config-3.5.2-amd64-preempt-noide-20120731

If that helps for comparison, my thread is here:
http://www.spinics.net/lists/linux-wireless/msg96438.html

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
