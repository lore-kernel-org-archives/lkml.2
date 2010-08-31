Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757133Ab0HaKgT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 06:36:19 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:28877 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756177Ab0HaKgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 06:36:18 -0400
X-SpamScore: 5
X-BigFish: VPS5(zzbb2cK1432N98dNzz1202hzz8275bh8275dhz32i2a8h5bep5bfs61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 0,
X-WSS-ID: 0L80IFY-02-3ZS-02
X-M-MSG: 
Date: Tue, 31 Aug 2010 12:28:48 +0200
From: Robert Richter <robert.richter@amd.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Carl E. Love" <cel@us.ibm.com>,
        Michael Ellerman <michaele@au1.ibm.com>,
        oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: Re: [PATCH] oprofile: fix crash when accessing freed task structs
Message-ID: <20100831102848.GB22783@erda.amd.com>
References: <1279775680.1970.13.camel@pasglop>
 <20100728122111.GO26154@erda.amd.com>
 <1280799573.1902.81.camel@pasglop>
 <20100813153910.GD26154@erda.amd.com>
 <1281910924.2811.0.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1281910924.2811.0.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.08.10 18:22:04, Benjamin Herrenschmidt wrote:
> > >From 4435322debc38097e9e863e14597ab3f78814d14 Mon Sep 17 00:00:00 2001
> > From: Robert Richter <robert.richter@amd.com>
> > Date: Fri, 13 Aug 2010 16:29:04 +0200
> > Subject: [PATCH] oprofile: fix crash when accessing freed task structs
> > 
> > This patch fixes a crash during shutdown reported below. The crash is
> > caused be accessing already freed task structs. The fix changes the
> > order for registering and unregistering notifier callbacks.
> > 
> > All notifiers must be initialized before buffers start working. To
> > stop buffer synchronization we cancel all workqueues, unregister the
> > notifier callback and then flush all buffers. After all of this we
> > finally can free all tasks listed.
> > 
> > This should avoid accessing freed tasks.
> > 
> > On 22.07.10 01:14:40, Benjamin Herrenschmidt wrote:
> > 
> > > So the initial observation is a spinlock bad magic followed by a crash
> > > in the spinlock debug code:
> > >
> > > [ 1541.586531] BUG: spinlock bad magic on CPU#5, events/5/136
> > > [ 1541.597564] Unable to handle kernel paging request for data at address 0x6b6b6b6b6b6b6d03
> > >
> > > Backtrace looks like:
> > >
> > >       spin_bug+0x74/0xd4
> > >       ._raw_spin_lock+0x48/0x184
> > >       ._spin_lock+0x10/0x24
> > >       .get_task_mm+0x28/0x8c
> > >       .sync_buffer+0x1b4/0x598
> > >       .wq_sync_buffer+0xa0/0xdc
> > >       .worker_thread+0x1d8/0x2a8
> > >       .kthread+0xa8/0xb4
> > >       .kernel_thread+0x54/0x70
> > >
> > > So we are accessing a freed task struct in the work queue when
> > > processing the samples.
> > 
> > Reported-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > Signed-off-by: Robert Richter <robert.richter@amd.com>

I have applied the patch to

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git urgent

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

