Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065Ab1HAOeH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 10:34:07 -0400
Received: from cernmx30.cern.ch ([137.138.144.177]:12054 "EHLO
	CERNMX30.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab1HAOd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 10:33:59 -0400
Date: Mon, 1 Aug 2011 16:31:02 +0200
From: Manohar Vanga <manohar.vanga@cern.ch>
To: Martyn Welch <martyn.welch@ge.com>
CC: <gregkh@suse.de>, <cota@braap.org>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/8] staging: vme: allow explicit assignment of bus
 numbers
Message-ID: <20110801143102.GA9705@becoht-mvanga>
Mail-Followup-To: Martyn Welch <martyn.welch@ge.com>, gregkh@suse.de,
	cota@braap.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
References: <1312194053-32310-1-git-send-email-manohar.vanga@cern.ch>
 <1312194053-32310-3-git-send-email-manohar.vanga@cern.ch>
 <4E36A4EA.30404@ge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4E36A4EA.30404@ge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [137.138.192.18]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Martyn,

> I assume this is in a system where there are more than one type of bridge
> (i.e. a ca91c042 and tsi148).

Yes. This is referring to multiple bridges on a single PCI bus (in the case of
the existing bridges). In practice we have only a single bridge of a single
type. We can however have multiple types of bridges (eg. 1 TSI148 and 1 Universe).
This solution is specifically for such situations.

> I'm not sure that passing a list of bus numbers to each driver is the correct
> way to resolve this. This issue also exists for hard drives and ethernet
> devices as well.

This solution won't help the cases where multiple bridges of the same type are
present (as we cannot control probe order) however in the case of multiple
bridges of differing types, it helps in deterministically assigning numbers to
the bridge.

The array was created simply for the reason that the code allows for multiple
bridges of the same kind. In practice we have only one of a specific kind.

> The network subsystem either has or uses a mechanism to allow udev rules to
> rename the devices (this seems to be done by MAC address on my system).
> 
> I believe drive ordering is resolved to some extent with UUIDs. Persistent
> device naming can be provided by using udev rules to create symlinks (such as
> "/dev/cdrom" etc), with the drives are determined by system topology.
> 
> I'm wondering whether re-ordering the bus numbering based on system topology
> using udev rules (where persistent bus numbering is required), or bind based
> on system topology and not need persistent numbering at all).

The problem here is that it is kernel space that requires a consistent
numbering so creating symlinks is not a useful solution for this. (unless the
driver loader script queries each device for its UUID at startup which seems
a little like a roundabout way).

The VME drivers require a list of bus numbers that it passes to the VME
driver so it knows which buses/bridges to probe on. We need to pass this to
the drivers during load time. Are you recommending we change this to UUID's?

Also, if we replace a card entirely (eg. in the case of a malfunction), the
UUID changes and we need to update a lot of local files to maintain the
automated startup (Please correct me if I'm wrong here). This would become a
mess to maintain really quickly.

In this patch, we don't solve the issue of multiple bridges of the same kind
but we solve the automation issue in cases of different types of bridge.
We already maintain a database with configuration options for each crate
and a bus number can be easily added. This won't change in the case of card
replacement.

--
/manohar
