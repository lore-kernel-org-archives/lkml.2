Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750972Ab2APFX2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 00:23:28 -0500
Received: from mga03.intel.com ([143.182.124.21]:43047 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715Ab2APFX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 00:23:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="96190510"
Subject: Re: [git patches] libata updates for 3.3
From: Lin Ming <ming.m.lin@intel.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1326676534.13517.3.camel@minggr>
References: <20120109003255.GA6598@havoc.gtf.org>
	 <CA+55aFwcBQSoWfqdT9CxV=GAr5ex0=RnqtBDFty+=_Lua2VXGw@mail.gmail.com>
	 <4F12E57E.3090805@garzik.org>  <1326676534.13517.3.camel@minggr>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Jan 2012 13:23:23 +0800
Message-ID: <1326691403.13517.21.camel@minggr>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-16 at 09:15 +0800, Lin Ming wrote:
> On Sun, 2012-01-15 at 09:41 -0500, Jeff Garzik wrote:
> > On 01/14/2012 12:21 AM, Linus Torvalds wrote:
> > > On Sun, Jan 8, 2012 at 4:32 PM, Jeff Garzik<jeff@garzik.org>  wrote:
> > >>
> > >> Summary (very little excitement at all this time):
> > >>
> > >> 0) Will play around with git signed tags with the next update.
> > >>
> > >> 1) PM improvements, including runtime suspend/resume work
> > >
> > > Hmm. I don't know if this comes from the PM improvements or even this
> > > particular pull, but links that aren't connected are *really* slow.
> > >
> > > Annoyingly so.
> > >
> > > My Macbook Air that I finally can resume reliably again used to come
> > > back almost immediately from resume. No longer. And the reason seems
> > > to be this:
> > >
> > >   [  243.306149] ata_piix 0000:00:1f.2: setting latency timer to 64
> > >   [  243.306180] bcma: Found rev 6 PMU (capabilities 0x108C2606)
> > >   [  246.579648] ata1.01: failed to resume link (SControl 0)
> > >   [  246.735472] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> > >   [  246.735485] ata1.01: SATA link down (SStatus 0 SControl 0)
> > >   [  246.743632] ata1.00: ACPI cmd ef/03:46:00:00:00:a0 (SET FEATURES)
> > > filtered out
> > >   [  246.744353] ata1.00: configured for UDMA/100
> > >   [  246.744537] sd 0:0:0:0: [sda] Starting disk
> > >   [  247.769806] ata2.00: failed to resume link (SControl 0)
> > >   [  248.796207] ata2.01: failed to resume link (SControl 0)
> > >   [  248.807665] ata2.00: SATA link down (SStatus 4 SControl 0)
> > >   [  248.807681] ata2.01: SATA link down (SStatus 0 SControl 0)
> > >   [  248.808338] PM: resume of devices complete after 5511.027 msecs
> > >   [  248.882074] PM: Finishing wakeup.
> > >
> > > Notice the basically five-second timeout all basically for "failed to
> > > resume link: for things that didn't have anything connected to them
> > > anyway.
> > >
> > > This is a bog-standard Intel controller, there's nothing odd there.
> > >
> > > I'm pretty sure this used to be much faster, but I haven't bisected
> > > any of it (and with all the problems I had with resume both due to
> > > wireless and MCE, I really wouldn't want to even try).
> > >
> > > Taking 5.5 seconds to come back from suspend-to-ram really is too
> > > long. Not *all* of it is the SATA part, but a lot of it is.
> > >
> > > For ATA suspend/resume, could we perhaps only resume the ports that
> > > *used* to have something on them? And then, if somebody has plugged
> > > something into the others, not consider that a resume thing at all,
> > > but a hotplug thing that happens *after* the resume?
> > >
> > > If it takes five seconds to notice new hardware after a resume, nobody
> > > cares. But the disk we had before obviously needs to get resumed.. But
> > > it does seem like it's the "no link" part that takes long.
> > 
> > We definitely notice new hardware after a resume, but you're right -- it 
> > should not take that long to work through ports that are empty.
> > 
> > Will take a look tomorrow (kid->doctor+relatives today, uff) at the most 
> > recent PM push; my quick testing did not show any problems, but 
> > suspend/resume varies widely across hardware platforms.  I think I might 
> > even have a MacBook I can test.  Apple platforms test to be weird too...  ;)
> 
> I just did a quick test with latest git head(122804e) and didn't find
> the problem either.
> 
> I'll test other machines.

Set SATA mode to IDE on my machine can reproduce this problem.
The cause is that ata port async suspend was not enabled yet.

Linus,

Could you please try below patch?

>From ba9cba4df9e9389c4f11202e335bee6383b2868c Mon Sep 17 00:00:00 2001
From: Lin Ming <ming.m.lin@intel.com>
Date: Mon, 16 Jan 2012 13:09:02 +0800
Subject: [PATCH] ata: enable ata port async suspend

This saves devices suspend/resume time.

Tested system suspend/resume with SATA IDE/AHCI mode 3 times.
Below is the time took for devices suspend/resume.

SATA mode    vanilla-kernel           patched-kernel
---------    ---------------------    ---------------------
IDE          suspend: 0.744           suspend: 0.432
             (0.716, 0.768, 0.748)    (0.440, 0.428, 0.428)

             resume: 5.084            resume: 2.209
             (5.100, 5.064, 5.088)    (2.168, 2.232, 2.228)

AHCI:        suspend: 0.725           suspend: 0.449
             (0.740, 0.708, 0.728)    (0.456, 0.448, 0.444)

             resume: 2.556            resume: 1.896
             (2.604, 2.492, 2.572)    (1.932, 1.872, 1.884)

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/ata/libata-transport.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/libata-transport.c b/drivers/ata/libata-transport.c
index 9a7f0ea..74aaee3 100644
--- a/drivers/ata/libata-transport.c
+++ b/drivers/ata/libata-transport.c
@@ -291,6 +291,7 @@ int ata_tport_add(struct device *parent,
 		goto tport_err;
 	}
 
+	device_enable_async_suspend(dev);
 	pm_runtime_set_active(dev);
 	pm_runtime_enable(dev);
 
-- 
1.7.2.5



