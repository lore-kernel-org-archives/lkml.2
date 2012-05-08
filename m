Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221Ab2EHKR5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 06:17:57 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:49402 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752851Ab2EHKRz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 06:17:55 -0400
From: "AnilKumar, Chimata" <anilkumar@ti.com>
To: "J, KEERTHY" <j-keerthy@ti.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Hilman, Kevin" <khilman@ti.com>, "rjw@sisk.pl" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "Pihet-XID, Jean" <j-pihet@ti.com>
Subject: RE: [PATCH V3 05/10] ARM: OMAP2+: SmartReflex: introduce a busy
 loop condition test macro
Thread-Topic: [PATCH V3 05/10] ARM: OMAP2+: SmartReflex: introduce a busy
 loop condition test macro
Thread-Index: AQHNI9QqacStCvxp2EqO7BVNbqIaSpa5YatQgAQdGYCAAkDsIA==
Date: Tue, 8 May 2012 10:17:41 +0000
Message-ID: <331ABD5ECB02734CA317220B2BBEABC13E9B667C@DBDE01.ent.ti.com>
References: <1335462041-4949-1-git-send-email-j-keerthy@ti.com>
	<1335462041-4949-6-git-send-email-j-keerthy@ti.com>
	<331ABD5ECB02734CA317220B2BBEABC13E9B1B40@DBDE01.ent.ti.com>
 <CAJ6a13aA9nutZvRkcj8GHok9cEe8A=J2bwzSXt=Sd0Hu_WPaPw@mail.gmail.com>
In-Reply-To: <CAJ6a13aA9nutZvRkcj8GHok9cEe8A=J2bwzSXt=Sd0Hu_WPaPw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.133.24]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2012 at 10:51:53, J, KEERTHY wrote:
> On Fri, May 4, 2012 at 2:42 PM, AnilKumar, Chimata <anilkumar@ti.com> wrote:
> > On Thu, Apr 26, 2012 at 23:10:36, J, KEERTHY wrote:
> >> From: Jean Pihet <j-pihet@ti.com>
> >>
> >> Now that omap_test_timeout is only accessible from mach-omap2/,
> >> introduce a similar function for SR.
> >>
> >> This change makes the SmartReflex implementation ready for the move
> >> to drivers/.
> >>
> >> Signed-off-by: Jean Pihet <j-pihet@ti.com>
> >> Signed-off-by: J Keerthy <j-keerthy@ti.com>
> >> ---
> >>  arch/arm/mach-omap2/smartreflex.c |   12 ++++++------
> >>  include/linux/power/smartreflex.h |   23 ++++++++++++++++++++++-
> >>  2 files changed, 28 insertions(+), 7 deletions(-)
> >>
> >> diff --git a/arch/arm/mach-omap2/smartreflex.c b/arch/arm/mach-omap2/smartreflex.c
> >> index d859277..acef08d 100644
> >> --- a/arch/arm/mach-omap2/smartreflex.c
> >> +++ b/arch/arm/mach-omap2/smartreflex.c
> >> @@ -289,9 +289,9 @@ static void sr_v1_disable(struct omap_sr *sr)
> >>        * Wait for SR to be disabled.
> >>        * wait until ERRCONFIG.MCUDISACKINTST = 1. Typical latency is 1us.
> >>        */
> >> -     omap_test_timeout((sr_read_reg(sr, ERRCONFIG_V1) &
> >> -                     ERRCONFIG_MCUDISACKINTST), SR_DISABLE_TIMEOUT,
> >> -                     timeout);
> >> +     sr_test_cond_timeout((sr_read_reg(sr, ERRCONFIG_V1) &
> >> +                          ERRCONFIG_MCUDISACKINTST), SR_DISABLE_TIMEOUT,
> >> +                          timeout);
> >>
> >>       if (timeout >= SR_DISABLE_TIMEOUT)
> >>               dev_warn(&sr->pdev->dev, "%s: Smartreflex disable timedout\n",
> >> @@ -334,9 +334,9 @@ static void sr_v2_disable(struct omap_sr *sr)
> >>        * Wait for SR to be disabled.
> >>        * wait until IRQSTATUS.MCUDISACKINTST = 1. Typical latency is 1us.
> >>        */
> >> -     omap_test_timeout((sr_read_reg(sr, IRQSTATUS) &
> >> -                     IRQSTATUS_MCUDISABLEACKINT), SR_DISABLE_TIMEOUT,
> >> -                     timeout);
> >> +     sr_test_cond_timeout((sr_read_reg(sr, IRQSTATUS) &
> >> +                          IRQSTATUS_MCUDISABLEACKINT), SR_DISABLE_TIMEOUT,
> >> +                          timeout);
> >>
> >>       if (timeout >= SR_DISABLE_TIMEOUT)
> >>               dev_warn(&sr->pdev->dev, "%s: Smartreflex disable timedout\n",
> >> diff --git a/include/linux/power/smartreflex.h b/include/linux/power/smartreflex.h
> >> index 884eaee..78b795e 100644
> >> --- a/include/linux/power/smartreflex.h
> >> +++ b/include/linux/power/smartreflex.h
> >> @@ -22,7 +22,7 @@
> >>
> >>  #include <linux/types.h>
> >>  #include <linux/platform_device.h>
> >> -
> >> +#include <linux/delay.h>
> >>  #include <plat/voltage.h>
> >>
> >>  /*
> >> @@ -168,6 +168,27 @@ struct omap_sr {
> >>  };
> >>
> >>  /**
> >> + * test_cond_timeout - busy-loop, testing a condition
> >> + * @cond: condition to test until it evaluates to true
> >> + * @timeout: maximum number of microseconds in the timeout
> >> + * @index: loop index (integer)
> >> + *
> >> + * Loop waiting for @cond to become true or until at least @timeout
> >> + * microseconds have passed.  To use, define some integer @index in the
> >> + * calling code.  After running, if @index == @timeout, then the loop has
> >> + * timed out.
> >> + *
> >> + * Copied from omap_test_timeout */
> >> +#define sr_test_cond_timeout(cond, timeout, index)           \
> >> +({                                                           \
> >> +     for (index = 0; index < timeout; index++) {             \
> >> +             if (cond)                                       \
> >> +                     break;                                  \
> >> +             udelay(1);                                      \
> >> +     }                                                       \
> >> +})
> >
> > I think we can use time_after()/time_before() APIs for timeout and cpu_relax() for
> > tight loops instead of udelay().
> 
> cpu_relax() changes the priority everytime to low and will yield to
> another thread.
> Considering that we are checking the condition every microsecond does it make
> some saving using cpu_relax().
> 

cpu_relax() does not involve any priority changes or scheduling AFAICS.
Have a look at this thread:

http://www.spinics.net/lists/netdev/msg151699.html

Regards
AnilKumar

