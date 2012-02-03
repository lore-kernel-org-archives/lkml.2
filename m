Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab2BCI1o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 03:27:44 -0500
Received: from mga01.intel.com ([192.55.52.88]:1979 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754658Ab2BCI1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 03:27:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="120183756"
Subject: Re: Regression 3.2 -> 3.3-rc1 10 sec hang at boot and resume,
 COMRESET failed
From: Lin Ming <ming.m.lin@intel.com>
To: Norbert Preining <preining@logic.at>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, jeff@garzik.org,
        Tejun Heo <tj@kernel.org>,
        "stern@rowland.harvard.edu >> Alan Stern" <stern@rowland.harvard.edu>,
        linux-ide@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20120203054319.GA25510@gamma.logic.tuwien.ac.at>
References: <20120202051258.GA15550@gamma.logic.tuwien.ac.at>
	 <4F2A4B7E.2090503@linux.vnet.ibm.com> <1328231716.15079.15.camel@minggr>
	 <1328242884.15079.22.camel@minggr>
	 <20120203052452.GC24563@gamma.logic.tuwien.ac.at>
	 <1328247269.15079.26.camel@minggr>
	 <20120203054319.GA25510@gamma.logic.tuwien.ac.at>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Feb 2012 16:27:40 +0800
Message-ID: <1328257660.15079.30.camel@minggr>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-03 at 14:43 +0900, Norbert Preining wrote:
> On Fr, 03 Feb 2012, Lin Ming wrote:
> > > I didn't try to revert that commit on top of HEAD.
> > 
> > Please revert that commit to test.
> > That helps us to make sure we find the exact bad commit.
> 
> Confirmed. Reverted 7faa33da9b7 on top of 6c073a7ee250 made
> the boot delay go away. dmesg from this boot attached.

Dig into the code, but I can't find where the problem is.

Anyway, does below DEBUG patch help?
Let's always stop the engine during hard reset.

diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index a72bfd0..8fef702 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -578,10 +578,6 @@ int ahci_stop_engine(struct ata_port *ap)
 
 	tmp = readl(port_mmio + PORT_CMD);
 
-	/* check if the HBA is idle */
-	if ((tmp & (PORT_CMD_START | PORT_CMD_LIST_ON)) == 0)
-		return 0;
-
 	/* setting HBA to idle */
 	tmp &= ~PORT_CMD_START;
 	writel(tmp, port_mmio + PORT_CMD);


> 
> Best wishes
> 
> Norbert
> ------------------------------------------------------------------------
> Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
> JAIST, Japan                                 TeX Live & Debian Developer
> DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
> ------------------------------------------------------------------------
> PELUTHO (n.) A South American ball game. The balls are whacked against
> a brick wall with a stout wooden bat until the prisoner confesses.
> 			--- Douglas Adams, The Meaning of Liff


