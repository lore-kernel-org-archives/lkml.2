Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966092Ab2ERRkm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 13:40:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965970Ab2ERRkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 13:40:24 -0400
Message-ID: <4FB68981.7060408@redhat.com>
Date: Fri, 18 May 2012 14:40:17 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: linux-next@vger.kernel.org, Chris Metcalf <cmetcalf@tilera.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [linux-next] "edac: Remove the legacy EDAC ABI"
References: <20120518162216.GB15256@windriver.com>
In-Reply-To: <20120518162216.GB15256@windriver.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 18-05-2012 13:22, Paul Gortmaker escreveu:
> Hi Guys,
> 
> This commit:
> 
> -----------
> commit 90b40d5cadba20d7fe2fce12d61f97e0870c1ba6
> Author: Mauro Carvalho Chehab <mchehab@redhat.com>
> Date:   Wed May 2 14:37:00 2012 -0300
> 
>     edac: Remove the legacy EDAC ABI
> 
>     Now that all drivers got converted to use the new ABI, we can
>     drop the old one.
> ----------
> 
> breaks linux-next i386 allmodconfig:
> 
> drivers/edac/amd76x_edac.c:254:25: error: too few arguments to function
> 'edac_mc_alloc'
> make[3]: *** [drivers/edac/amd76x_edac.o] Error 1
> drivers/edac/i82875p_edac.c:424:3: error: label 'fail0' used but not
> defined
> drivers/edac/i82875p_edac.c:427:2: error: expected identifier or '('
> before 'do'
> 
> http://kisskb.ellerman.id.au/kisskb/buildresult/6341714/
> 
> Please have a look.

Thanks for it! This was due to a rebase, where one of the arguments for
edac_mc_alloc() got removed.

The enclosed patch should fix it.

I'll merge the fix with the affected patches.

-

edac: Fix compilation breakage on amd76x_edac and i82875p

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/edac/amd76x_edac.c b/drivers/edac/amd76x_edac.c
index c974da7..a015fba 100644
--- a/drivers/edac/amd76x_edac.c
+++ b/drivers/edac/amd76x_edac.c
@@ -251,7 +251,7 @@ static int amd76x_probe1(struct pci_dev *pdev, int dev_idx)
 	layers[1].type = EDAC_MC_LAYER_CHANNEL;
 	layers[1].size = 1;
 	layers[1].is_virt_csrow = false;
-	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), 0);
+	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, 0);
 
 	if (mci == NULL)
 		return -ENOMEM;
diff --git a/drivers/edac/i82875p_edac.c b/drivers/edac/i82875p_edac.c
index ae15359..db64bd7 100644
--- a/drivers/edac/i82875p_edac.c
+++ b/drivers/edac/i82875p_edac.c
@@ -420,6 +420,7 @@ static int i82875p_probe1(struct pci_dev *pdev, int dev_idx)
 	layers[1].size = nr_chans;
 	layers[1].is_virt_csrow = false;
 	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, sizeof(*pvt));
+	if (!mci) {
 		rc = -ENOMEM;
 		goto fail0;
 	}
