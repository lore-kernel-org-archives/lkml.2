Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403Ab1DHCYZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 22:24:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757347Ab1DHCYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 22:24:23 -0400
Subject: Re: [PATCH] PCI: Enable ASPM state clearing regardless of policy
From: Alex Williamson <alex.williamson@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org,
        linux-kernel@vger.kernel.org, mjg@redhat.com
In-Reply-To: <20110407152310.5bfeab8b.akpm@linux-foundation.org>
References: <20110310185351.3394.54996.stgit@s20.home>
	 <20110407152310.5bfeab8b.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Apr 2011 20:24:16 -0600
Message-ID: <1302229456.3589.5.camel@x201>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-07 at 15:23 -0700, Andrew Morton wrote:
> On Thu, 10 Mar 2011 11:54:16 -0700
> Alex Williamson <alex.williamson@redhat.com> wrote:
> 
> > Commit 2f671e2d allowed us to clear ASPM state when the FADT
> > tells us it isn't supported, but we don't put this into effect
> > if the aspm_policy is set to POLICY_POWERSAVE.  Enable the
> > state to be cleared regardless of policy.
> > 
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > ---
> > 
> >  drivers/pci/pcie/aspm.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
> > index 3188cd9..eb8ac5c 100644
> > --- a/drivers/pci/pcie/aspm.c
> > +++ b/drivers/pci/pcie/aspm.c
> > @@ -607,7 +607,7 @@ void pcie_aspm_init_link_state(struct pci_dev *pdev)
> >  	 * the BIOS's expectation, we'll do so once pci_enable_device() is
> >  	 * called.
> >  	 */
> > -	if (aspm_policy != POLICY_POWERSAVE) {
> > +	if (aspm_policy != POLICY_POWERSAVE || aspm_clear_state) {
> >  		pcie_config_aspm_path(link);
> >  		pcie_set_clkpm(link, policy_to_clkpm_state(link));
> >  	}
> 
> hm.  why.  Presumably this change has some user-observeable effect.
> 
> What is that effect, and why is it desirable? ;)

Without this, the ASPM clearing from 2f671e2d doesn't actually do
anything when aspm_policy is set to POLICY_POWERSAVE.  A recent BIOS
update on one of my systems left ASPM state on a device while reporting
via the FADT that ASPM isn't supported.  Exactly the situation 2f671e2d
is meant to fix, but didn't because the downstream kernel used powersave
as it's default policy.  With this, the ASPM leftovers still get clear
and the system works again.  Thanks,

Alex

