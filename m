Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757711Ab0LBOmh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 09:42:37 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:22825 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757394Ab0LBOmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 09:42:36 -0500
X-IronPort-AV: E=Sophos;i="4.59,288,1288569600"; 
   d="scan'208";a="3156064"
Date: Thu, 2 Dec 2010 14:42:28 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: Re: [Xen-devel] [PATCH 0/5] Xen PV on HVM fixes
In-Reply-To: <4CF69840.3040704@goop.org>
Message-ID: <alpine.DEB.2.00.1012020518200.14723@kaball-desktop>
References: <alpine.DEB.2.00.1012011442280.14723@kaball-desktop> <4CF69840.3040704@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Dec 2010, Jeremy Fitzhardinge wrote:
> On 12/01/2010 10:22 AM, Stefano Stabellini wrote:
> > Hi all,
> > this patch series is a collection of fixes for Xen PV on HVM.
> >
> > The first two patches fix two pirq remapping problems with MSIs, they
> > have been sent to the list few times already for comments.
> > The three following patches are new and fix save/restore bugs.
> 
> Are you targeting these at 3.6.37-rc?

Yes, because the bugs are pretty serious.


> If so, each changelog commit
> should explicitly say what bug is being fixed, and what the impact of
> the bug is.  The last 3 are OK, but it isn't clear to me whether the
> first two are strictly bugfixes or not.
> 

The first patch fixes find_unbound_pirq that otherwise would be based on
PHYSDEVOP_get_nr_pirqs that is actually not supported by Xen,
therefore it would fail. So find_unbound_pirq would return a number
starting from nr_irqs that might very well be out of range in Xen.

The symptom of this bug is that when you passthrough an MSI capable pci
device to a PV on HVM guest, Linux would fail to enable MSIs on the
device.


The second patch fixes a bug in xen_hvm_setup_msi_irqs that manifests
itself when trying to enable the same MSI for the second time: qemu is
responsible for remapping MSIs into pirqs and considers the old MSI to
pirq mapping still valid at this point but xen_hvm_setup_msi_irqs
would try to assign a new pirq anyway.

A simple way to reproduce this bug is to assign an MSI capable network
card to a PV on HVM guest, if the user brings down the corresponding
ethernet interface and up again, Linux would fail to enable MSIs on the
device.



I have updated the first two commit messages with these info, the branch
is still the same:

git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git 2.6.37-rc4-pvhvm-fixes

