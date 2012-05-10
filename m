Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab2EJGTx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 02:19:53 -0400
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:48851 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754560Ab2EJGTs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 02:19:48 -0400
MIME-Version: 1.0
In-Reply-To: <331ABD5ECB02734CA317220B2BBEABC13E9B667C@DBDE01.ent.ti.com>
References: <1335462041-4949-1-git-send-email-j-keerthy@ti.com>
	<1335462041-4949-6-git-send-email-j-keerthy@ti.com>
	<331ABD5ECB02734CA317220B2BBEABC13E9B1B40@DBDE01.ent.ti.com>
	<CAJ6a13aA9nutZvRkcj8GHok9cEe8A=J2bwzSXt=Sd0Hu_WPaPw@mail.gmail.com>
	<331ABD5ECB02734CA317220B2BBEABC13E9B667C@DBDE01.ent.ti.com>
Date: Thu, 10 May 2012 11:49:47 +0530
Message-ID: <CAJ6a13Z4AuDccR2o0nzQO+tnL59PbAVtFkzYDCd1FU_VuiZOVw@mail.gmail.com>
Subject: Re: [PATCH V3 05/10] ARM: OMAP2+: SmartReflex: introduce a busy loop
 condition test macro
From: "J, KEERTHY" <j-keerthy@ti.com>
To: "AnilKumar, Chimata" <anilkumar@ti.com>
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Hilman, Kevin" <khilman@ti.com>, "rjw@sisk.pl" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "Pihet-XID, Jean" <j-pihet@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 8, 2012 at 3:47 PM, AnilKumar, Chimata <anilkumar@ti.com> wrote:
> On Mon, May 07, 2012 at 10:51:53, J, KEERTHY wrote:
>> On Fri, May 4, 2012 at 2:42 PM, AnilKumar, Chimata <anilkumar@ti.com> wrote:
>> > On Thu, Apr 26, 2012 at 23:10:36, J, KEERTHY wrote:
>> >> From: Jean Pihet <j-pihet@ti.com>
>> >>
>> >> Now that omap_test_timeout is only accessible from mach-omap2/,
>> >> introduce a similar function for SR.
>> >>
>> >> This change makes the SmartReflex implementation ready for the move
>> >> to drivers/.
>> >>
>> >> Signed-off-by: Jean Pihet <j-pihet@ti.com>
>> >> Signed-off-by: J Keerthy <j-keerthy@ti.com>
>> >> ---
>> >>  arch/arm/mach-omap2/smartreflex.c |   12 ++++++------
>> >>  include/linux/power/smartreflex.h |   23 ++++++++++++++++++++++-
>> >>  2 files changed, 28 insertions(+), 7 deletions(-)
>> >>
>> >> diff --git a/arch/arm/mach-omap2/smartreflex.c b/arch/arm/mach-omap2/smartreflex.c
>> >> index d859277..acef08d 100644
>> >> --- a/arch/arm/mach-omap2/smartreflex.c
>> >> +++ b/arch/arm/mach-omap2/smartreflex.c
>> >> @@ -289,9 +289,9 @@ static void sr_v1_disable(struct omap_sr *sr)
>> >>        * Wait for SR to be disabled.
>> >>        * wait until ERRCONFIG.MCUDISACKINTST = 1. Typical latency is 1us.
>> >>        */
>> >> -     omap_test_timeout((sr_read_reg(sr, ERRCONFIG_V1) &
>> >> -                     ERRCONFIG_MCUDISACKINTST), SR_DISABLE_TIMEOUT,
>> >> -                     timeout);
>> >> +     sr_test_cond_timeout((sr_read_reg(sr, ERRCONFIG_V1) &
>> >> +                          ERRCONFIG_MCUDISACKINTST), SR_DISABLE_TIMEOUT,
>> >> +                          timeout);
>> >>
>> >>       if (timeout >= SR_DISABLE_TIMEOUT)
>> >>               dev_warn(&sr->pdev->dev, "%s: Smartreflex disable timedout\n",
>> >> @@ -334,9 +334,9 @@ static void sr_v2_disable(struct omap_sr *sr)
>> >>        * Wait for SR to be disabled.
>> >>        * wait until IRQSTATUS.MCUDISACKINTST = 1. Typical latency is 1us.
>> >>        */
>> >> -     omap_test_timeout((sr_read_reg(sr, IRQSTATUS) &
>> >> -                     IRQSTATUS_MCUDISABLEACKINT), SR_DISABLE_TIMEOUT,
>> >> -                     timeout);
>> >> +     sr_test_cond_timeout((sr_read_reg(sr, IRQSTATUS) &
>> >> +                          IRQSTATUS_MCUDISABLEACKINT), SR_DISABLE_TIMEOUT,
>> >> +                          timeout);
>> >>
>> >>       if (timeout >= SR_DISABLE_TIMEOUT)
>> >>               dev_warn(&sr->pdev->dev, "%s: Smartreflex disable timedout\n",
>> >> diff --git a/include/linux/power/smartreflex.h b/include/linux/power/smartreflex.h
>> >> index 884eaee..78b795e 100644
>> >> --- a/include/linux/power/smartreflex.h
>> >> +++ b/include/linux/power/smartreflex.h
>> >> @@ -22,7 +22,7 @@
>> >>
>> >>  #include <linux/types.h>
>> >>  #include <linux/platform_device.h>
>> >> -
>> >> +#include <linux/delay.h>
>> >>  #include <plat/voltage.h>
>> >>
>> >>  /*
>> >> @@ -168,6 +168,27 @@ struct omap_sr {
>> >>  };
>> >>
>> >>  /**
>> >> + * test_cond_timeout - busy-loop, testing a condition
>> >> + * @cond: condition to test until it evaluates to true
>> >> + * @timeout: maximum number of microseconds in the timeout
>> >> + * @index: loop index (integer)
>> >> + *
>> >> + * Loop waiting for @cond to become true or until at least @timeout
>> >> + * microseconds have passed.  To use, define some integer @index in the
>> >> + * calling code.  After running, if @index == @timeout, then the loop has
>> >> + * timed out.
>> >> + *
>> >> + * Copied from omap_test_timeout */
>> >> +#define sr_test_cond_timeout(cond, timeout, index)           \
>> >> +({                                                           \
>> >> +     for (index = 0; index < timeout; index++) {             \
>> >> +             if (cond)                                       \
>> >> +                     break;                                  \
>> >> +             udelay(1);                                      \
>> >> +     }                                                       \
>> >> +})
>> >
>> > I think we can use time_after()/time_before() APIs for timeout and cpu_relax() for
>> > tight loops instead of udelay().
>>
>> cpu_relax() changes the priority everytime to low and will yield to
>> another thread.
>> Considering that we are checking the condition every microsecond does it make
>> some saving using cpu_relax().
>>
>
> cpu_relax() does not involve any priority changes or scheduling AFAICS.
> Have a look at this thread:
>
> http://www.spinics.net/lists/netdev/msg151699.html

Thanks. My bad. I meant yielding to another thread with in a space
of 1uS.

>
> Regards
> AnilKumar
>



-- 
Regards and Thanks,
Keerthy
