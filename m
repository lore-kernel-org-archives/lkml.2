Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758232Ab0E0LGU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 07:06:20 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:13168 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143Ab0E0LGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 07:06:19 -0400
X-SpamScore: -23
X-BigFish: VPS-23(zz1432P98dN936eM148cMab9bhzz1202hzz6d525hz32i2a8h87h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L32S68-01-LKZ-02
X-M-MSG: 
Date: Thu, 27 May 2010 13:06:09 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Julia Lawall <julia@diku.dk>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
       "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH 6/17] arch/x86/kernel: Add missing spin_unlock
Message-ID: <20100527110608.GU3266@amd.com>
References: <Pine.LNX.4.64.1005261755260.23743@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1005261755260.23743@ask.diku.dk>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 11:55:59AM -0400, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Add a spin_unlock missing on the error path.  The locks and unlocks are
> balanced in other functions, so it seems that the same should be the case
> here.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)

Applied the attached version of the patch. Thanks for catching this.

	Joerg

>From 84fe6c19e4a598e8071e3bd1b2c923454eae1268 Mon Sep 17 00:00:00 2001
From: Julia Lawall <julia@diku.dk>
Date: Thu, 27 May 2010 12:31:51 +0200
Subject: [PATCH] arch/x86/kernel: Add missing spin_unlock

Add a spin_unlock missing on the error path.  The locks and unlocks are
balanced in other functions, so it seems that the same should be the case
here.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression E1;
@@

* spin_lock(E1,...);
  <+... when != E1
  if (...) {
    ... when != E1
*   return ...;
  }
  ...+>
* spin_unlock(E1,...);
// </smpl>

Cc: stable@kernel.org
Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index fa5a147..8a9aaa8 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1487,6 +1487,7 @@ static int __attach_device(struct device *dev,
 			   struct protection_domain *domain)
 {
 	struct iommu_dev_data *dev_data, *alias_data;
+	int ret;
 
 	dev_data   = get_dev_data(dev);
 	alias_data = get_dev_data(dev_data->alias);
@@ -1498,13 +1499,14 @@ static int __attach_device(struct device *dev,
 	spin_lock(&domain->lock);
 
 	/* Some sanity checks */
+	ret = -EBUSY;
 	if (alias_data->domain != NULL &&
 	    alias_data->domain != domain)
-		return -EBUSY;
+		goto out_unlock;
 
 	if (dev_data->domain != NULL &&
 	    dev_data->domain != domain)
-		return -EBUSY;
+		goto out_unlock;
 
 	/* Do real assignment */
 	if (dev_data->alias != dev) {
@@ -1520,10 +1522,14 @@ static int __attach_device(struct device *dev,
 
 	atomic_inc(&dev_data->bind);
 
+	ret = 0;
+
+out_unlock:
+
 	/* ready */
 	spin_unlock(&domain->lock);
 
-	return 0;
+	return ret;
 }
 
 /*
-- 
1.7.1


