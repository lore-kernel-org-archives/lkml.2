Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933524Ab0I0TyI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 15:54:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47130 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933483Ab0I0TyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 15:54:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nishanth Menon <nm@ti.com>
Subject: Re: [PATCH v4] power: introduce library for device-specific OPPs
Date: Mon, 27 Sep 2010 21:53:13 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc5-rjw+; KDE/4.4.4; x86_64; ; )
Cc: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "linux-pm" <linux-pm@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-arm" <linux-arm-kernel@lists.infradead.org>,
        "linux-omap" <linux-omap@vger.kernel.org>
References: <1285332640-16736-1-git-send-email-nm@ti.com> <20100926005636.GB3396@linux.vnet.ibm.com> <4CA0A95A.4000408@ti.com>
In-Reply-To: <4CA0A95A.4000408@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009272153.13232.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 27, 2010, Nishanth Menon wrote:
> Paul E. McKenney had written, on 09/25/2010 07:56 PM, the following:
> > On Sat, Sep 25, 2010 at 10:55:20PM +0200, Rafael J. Wysocki wrote:
> >> On Friday, September 24, 2010, Paul E. McKenney wrote:
> >>> On Fri, Sep 24, 2010 at 07:50:40AM -0500, Nishanth Menon wrote:
> >> ...
> >>> Looks like a good start!!!  Some questions and suggestions about RCU
> >>> usage interspersed below.
> >> ...
> >>>> + * Locking: RCU reader.
> >>>> + */
> >>>> +int opp_get_opp_count(struct device *dev)
> >>>> +{
> >>>> +	struct device_opp *dev_opp;
> >>>> +	struct opp *temp_opp;
> >>>> +	int count = 0;
> >>>> +
> >>>> +	dev_opp = find_device_opp(dev);
> >>>> +	if (IS_ERR(dev_opp))
> >>>> +		return PTR_ERR(dev_opp);
> >>>> +
> >>>> +	rcu_read_lock();
> >>>> +	list_for_each_entry_rcu(temp_opp, &dev_opp->opp_list, node) {
> >>>> +		if (temp_opp->available)
> >>>> +			count++;
> >>>> +	}
> >>>> +	rcu_read_unlock();
> >>> This one is OK as well.  You are returning a count, so if all of the
> >>> counted structures are freed at this point, no problem.  The count was
> >>> valid when it was accumulated, and the fact that it might now be obsolete
> >>> is (usually) not a problem.
> >> However, it looks like it should run rcu_read_lock() before calling
> >> find_device_opp(dev), shouldn't it?
> > 
> > Indeed it does appear that you are right -- good catch!!!
> > 
> > 							Thanx, Paul
> dev_opp as discussed before is safe as it is never freed 
> (find_device_opp uses it's own rcu_read_lock, the rcu_read_lock in this 
> context is for the opp list. what am I missing?

It's simply safer to put the rcu_read_lock() before find_device_opp(), in case
someone will make it possible to remove things from the opp list in the future.

Besides, your entire data structure consists of the opp list and the per-power
domain lists, so you should really tell the writers when you have finished to
traverse it entirely, not in the middle of the operation.

Thanks,
Rafael
