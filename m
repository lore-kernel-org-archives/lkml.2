Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605Ab1D1BGE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 21:06:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58583 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329Ab1D1BGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 21:06:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Colin Cross <ccross@google.com>
Subject: Re: [Update][PATCH 7/9] PM / Runtime: Generic clock manipulation rountines for runtime PM (v3)
Date: Thu, 28 Apr 2011 03:06:13 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Kevin Hilman <khilman@ti.com>, LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>, Len Brown <lenb@kernel.org>,
        linux-sh@vger.kernel.org, lethal@linux-sh.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>
References: <201104130205.26988.rjw@sisk.pl> <BANLkTimHkKq9+0z-4CZs=34GNO6Ab0wZPQ@mail.gmail.com> <201104280258.34694.rjw@sisk.pl>
In-Reply-To: <201104280258.34694.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104280306.13262.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 28, 2011, Rafael J. Wysocki wrote:
> On Thursday, April 28, 2011, Colin Cross wrote:
> > On Wed, Apr 27, 2011 at 2:48 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > >
> > > Many different platforms and subsystems may want to disable device
> > > clocks during suspend and enable them during resume which is going to
> > > be done in a very similar way in all those cases.  For this reason,
> > > provide generic routines for the manipulation of device clocks during
> > > suspend and resume.
> > >
> > > Convert the ARM shmobile platform to using the new routines.
> > >
> > > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > > ---
> > >
> > > Hi,
> > >
> > > This (hopefully final) version of the patch has a couple of bugs fixed in
> > > clock_ops.c.
> > >
> > > Thanks,
> > > Rafael
> > >
> > > ---
> > >  arch/arm/mach-shmobile/pm_runtime.c |  140 -----------
> > >  drivers/base/power/Makefile         |    1
> > >  drivers/base/power/clock_ops.c      |  423 ++++++++++++++++++++++++++++++++++++
> > >  include/linux/pm_runtime.h          |   42 +++
> > >  kernel/power/Kconfig                |    4
> > >  5 files changed, 479 insertions(+), 131 deletions(-)
> > >
> > <snip>
> > > +void pm_runtime_clk_remove(struct device *dev, const char *con_id)
> > > +{
> > > +       struct pm_runtime_clk_data *prd = __to_prd(dev);
> > > +       struct pm_clock_entry *ce;
> > > +
> > > +       if (!prd)
> > > +               return;
> > > +
> > > +       mutex_lock(&prd->lock);
> > > +
> > > +       list_for_each_entry(ce, &prd->clock_list, node)
> > Braces
> 
> No, this is correct as is.
> 
> > > +               if (!con_id && !ce->con_id) {
> > > +                       __pm_runtime_clk_remove(ce);
> > > +                       break;
> > > +               } else if (!con_id || !ce->con_id) {
> > > +                       continue;
> > > +               } else if (!strcmp(con_id, ce->con_id)) {
> > > +                       __pm_runtime_clk_remove(ce);
> > > +                       break;
> > > +               }
> > > +
> > > +       mutex_unlock(&prd->lock);
> > > +}
> > >
> > > +/**
> > > + * pm_runtime_clk_acquire - Acquire a device clock.
> > > + * @dev: Device whose clock is to be acquired.
> > > + * @con_id: Connection ID of the clock.
> > > + */
> > > +static void pm_runtime_clk_acquire(struct device *dev,
> > > +                                   struct pm_clock_entry *ce)
> > > +{
> > > +       ce->clk = clk_get(dev, ce->con_id);
> > > +       if (!IS_ERR(ce->clk)) {
> > > +               ce->clock_active = true;
> > > +               dev_dbg(dev, "Clock %s managed by runtime PM.\n", ce->con_id);
> > > +       }
> > > +}
> > > +
> > > +/**
> > > + * pm_runtime_clk_suspend - Disable clocks in a device's runtime PM clock list.
> > > + * @dev: Device to disable the clocks for.
> > > + */
> > > +int pm_runtime_clk_suspend(struct device *dev)
> > > +{
> > > +       struct pm_runtime_clk_data *prd = __to_prd(dev);
> > > +       struct pm_clock_entry *ce;
> > > +
> > > +       dev_dbg(dev, "%s()\n", __func__);
> > > +
> > > +       if (!prd)
> > > +               return 0;
> > > +
> > > +       mutex_lock(&prd->lock);
> > > +
> > > +       list_for_each_entry_reverse(ce, &prd->clock_list, node) {
> > > +               if (!ce->clk) {
> > > +                       dev_err(dev, "Clock is not ready for runtime PM\n");
> > > +                       pm_runtime_clk_acquire(dev, ce);
> > Why delay the call to clk_get until the first suspend?
> 
> Because the clock framework need not be ready at the _add time.
> 
> > Also, this will always print an error during the first call to suspend.
> 
> That actually depends on the initial state of the device and the
> assumption is that will be RPM_SUSPENDED, so _resume will be called
> first.
> 
> I can remove the message, but it's there for backwards compatibility with
> the code this is intended to replace.
> 
> > > +               }
> > > +
> > > +               if (ce->clock_active) {
> > I don't think clock_active is necessary, and the name is misleading.
> 
> It's not strictly necessary and "active" means "being used for runtime PM".
> 
> > Why not use if (ce->clk)?
> 
> Because _that_ would be confusing?

Moreover, if the first clk_get() fails, this avoids repeating it
during every suspend/resume (because it most probably is going to fail too).

Thanks,
Rafael
