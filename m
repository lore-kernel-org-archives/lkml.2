Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759932Ab1FXQ3c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 12:29:32 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:46267 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab1FXQ32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 12:29:28 -0400
Date: Fri, 24 Jun 2011 09:28:56 -0700
From: Ram Pai <linuxram@us.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        svenkatr@ti.com, yinghai@kernel.org, cjb@laptop.org,
        linux-pci@vger.kernel.org, linux-net-drivers@solarflare.com,
        bhutchings@solarflare.com, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 4/4] PCI: make cardbus-bridge resources nice-to-have
Message-ID: <20110624162856.GL22917@ram-laptop>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <1308610037-6261-1-git-send-email-linuxram@us.ibm.com>
 <20110622004816.GC22917@ram-laptop>
 <20110623133137.03c74ea4@jbarnes-desktop>
 <201106232242.29753.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106232242.29753.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 10:42:29PM +0200, Rafael J. Wysocki wrote:
> On Thursday, June 23, 2011, Jesse Barnes wrote:
> > On Tue, 21 Jun 2011 17:48:16 -0700
> > Ram Pai <linuxram@us.ibm.com> wrote:
> > > I assume majority of the platforms will have enough resources to satisfy all
> > > the resource requests, and their BIOS would have done a decent job.
> > > 
> > > Even if the BIOS has not done a decent job, and there are enough resources
> > > available we should not see a regression.
> > > 
> > > The only platforms that would expose a regression is when resources are under
> > > contention and the BIOS has assigned enough resource to the cardbus bridge but
> > > not to some other device. It will be hard to find such a platform, but I am
> > > sure there is one out somewhere there.
> > > 
> > > I am sure we will see; some day, reports of regression because that platform
> > > would have the exact right characteristics to expose the issue. But then that
> > > platform is a highly constrained platform in the first place. Its debatable if
> > > that should be characterised as a regression, or a platform that was riding on
> > > good luck till now.
> > > 
> > > Even Oliver's platform is a highly constrained platform, and we probably can
> > > treat his platform as 'riding on good luck till now'.
> > > 
> > > We won't be able to satisfy all the platforms with resource constraints.  I
> > > think our probable choice is to select a solution that breaks least number of
> > > platforms and special case those broken platforms through kernel command line
> > > parameters.
> > 
> > Another option is to hide the new allocation behavior behind a kernel
> > parameter.  I know Bjorn has opposed this in the past because really
> > this sort of thing should "just work".  But so far it hasn't, and we've
> > had to revert both Bjorn's resource tracking changes as well as the
> > re-allocation code.
> > 
> > Hiding it behind a boot option would at least let us improve things
> > over time and potentially switch over to new resource code in the
> > future...
> > 
> > Thoughts?
> 
> Do I understand correctly that at the moment we have two set of systems,
> one of which works with the new code and doesn't work with the old code
> and the other one conversely?

Here is the current state:

(a) As of 2.6.39, for platforms whose BIOS have not allocated enough resources to its
devices, those devices will **continue to not work**. An example of such a platform is
the one whose BIOS has not allocated enough resources to SRIOV BARs.

(b) With Yinghai's patch
	the commit "PCI: update bridge resources to get more big ranges when allocating space (again)"
	http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=da7822e5ad71ec9b745b412639f1e5e0ba795a20
Most of the  platforms that were not working in (a) will start working, but will break a few platforms, that
have resource constraints and whose BIOS has not allocated enough resources to some of its devices.
Oliver's and Ben Hutching's platform are two of the known platforms; as of now.

(c) with my patch all the above platforms will start working. But the 4th patch in the series
raises a genuine concern that it might break resource-constrained platforms with cardbus bridges.

The question is which one of these is a lesser-evil  :)

Personally I think we should merge all the patches except the 4th patch, and support
Oliver's platform through kernel command line parameter. And I think we should
revert Yinghai's patch for now and merge it with all other patches in the 3.0.1 timeframe
after thorough testing.

RP
