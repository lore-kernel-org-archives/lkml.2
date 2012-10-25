Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935846Ab2JYQhB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 12:37:01 -0400
Received: from mail.x86-64.org ([217.9.48.20]:41959 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757154Ab2JYQhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 12:37:00 -0400
Date: Thu, 25 Oct 2012 18:36:53 +0200
From: Borislav Petkov <bp@amd64.org>
To: Denis Kirjanov <kirjanov@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] handle error path in edac_mc_sysfs_init()
Message-ID: <20121025163653.GD2623@aftab.osrc.amd.com>
References: <1351179778-6591-1-git-send-email-kirjanov@gmail.com>
 <20121025155606.GF308@x1.osrc.amd.com>
 <20121025155729.GG308@x1.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121025155729.GG308@x1.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(remove Doug's email from CC since it bounces)

On Thu, Oct 25, 2012 at 05:57:29PM +0200, Borislav Petkov wrote:
> On Thu, Oct 25, 2012 at 05:56:06PM +0200, Borislav Petkov wrote:
> > Would you be willing to fix that too, while you're at it? Btw, I can
> > totally understand if you say no - I'll take care of it myself instead
> > then :-).
> 
> Ah, maybe I should look at the second patch before replying to this one.
> Nevermind, I'll merge the two into one and test.

Ok, here's the final version I'm sending upstream soon:

--
>From a8373ecc0c26d8afafd0d2e88f96756e26b7f3ee Mon Sep 17 00:00:00 2001
From: Denis Kirjanov <kirjanov@gmail.com>
Date: Thu, 25 Oct 2012 19:42:58 +0400
Subject: [PATCH] EDAC: Handle error path in edac_mc_sysfs_init() properly

Make sure proper deregistration happens on all error paths in
edac_mc_sysfs_init.

Signed-off-by: Denis Kirjanov <kirjanov@gmail.com>
[ Boris: cleanup and concretize commit message ]
Signed-off-by: Borislav Petkov <bp@alien8.de>
---
 drivers/edac/edac_mc_sysfs.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index 52813b8b0f5f..de2df92f9c77 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -1126,10 +1126,15 @@ int __init edac_mc_sysfs_init(void)
 	edac_subsys = edac_get_sysfs_subsys();
 	if (edac_subsys == NULL) {
 		edac_dbg(1, "no edac_subsys\n");
-		return -EINVAL;
+		err = -EINVAL;
+		goto out;
 	}
 
 	mci_pdev = kzalloc(sizeof(*mci_pdev), GFP_KERNEL);
+	if (!mci_pdev) {
+		err = -ENOMEM;
+		goto out_put_sysfs;
+	}
 
 	mci_pdev->bus = edac_subsys;
 	mci_pdev->type = &mc_attr_type;
@@ -1138,11 +1143,18 @@ int __init edac_mc_sysfs_init(void)
 
 	err = device_add(mci_pdev);
 	if (err < 0)
-		return err;
+		goto out_dev_free;
 
 	edac_dbg(0, "device %s created\n", dev_name(mci_pdev));
 
 	return 0;
+
+ out_dev_free:
+	kfree(mci_pdev);
+ out_put_sysfs:
+	edac_put_sysfs_subsys();
+ out:
+	return err;
 }
 
 void __exit edac_mc_sysfs_exit(void)
@@ -1150,4 +1162,5 @@ void __exit edac_mc_sysfs_exit(void)
 	put_device(mci_pdev);
 	device_del(mci_pdev);
 	edac_put_sysfs_subsys();
+	kfree(mci_pdev);
 }
-- 
1.8.0

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
