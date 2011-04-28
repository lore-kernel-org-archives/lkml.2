Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311Ab1D1CLc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 22:11:32 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51201 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168Ab1D1CLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 22:11:31 -0400
Date: Thu, 28 Apr 2011 12:11:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
Cc: ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Santiago Leon <santil@linux.vnet.ibm.com>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: ibmveth runtime errors
Message-Id: <20110428121124.39c036ff.sfr@canb.auug.org.au>
In-Reply-To: <20110427103622.GA22781@rere.qmqm.pl>
References: <20110427144901.4c3f79b3.sfr@canb.auug.org.au>
	<20110427103622.GA22781@rere.qmqm.pl>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michał,

On Wed, 27 Apr 2011 12:36:22 +0200 Michał Mirosław <mirq-linux@rere.qmqm.pl> wrote:
>
> Please test the following patch. It's just a blind guess, as this error
> is not descriptive.
> 
> Best Regards,
> Michał Mirosław
> 
> ---
> 
> net: ibmveth: force reconfiguring checksum settings on startup
> 
> Commit b9367bf3ee6d ("net: ibmveth: convert to hw_features") accidentally
> removed call to ibmveth_set_csum_offload() in ibmveth_probe(). Put the
> call back where it was, but with additional error checking provided
> by ibmveth_set_features().
> 
> Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> 
> ---
>  drivers/net/ibmveth.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/ibmveth.c b/drivers/net/ibmveth.c
> index 4855f1f..0d1fea2 100644
> --- a/drivers/net/ibmveth.c
> +++ b/drivers/net/ibmveth.c
> @@ -1397,6 +1397,8 @@ static int __devinit ibmveth_probe(struct vio_dev *dev,
>  
>  	netdev_dbg(netdev, "registering netdev...\n");
>  
> +	ibmveth_set_features(dev, dev->features);
> +
>  	rc = register_netdev(netdev);
>  
>  	if (rc) {

This worked after I changed both "dev"s to "netdev".  And the boot
succedded.  I will apply this patchg to linux-next today and hopefully
Dave can apply it to the net tree.  I have added a copy fo the patch I
used below.

From: =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Date: Thu, 28 Apr 2011 11:59:15 +1000
Subject: [PATCH] net: ibmveth: force reconfiguring checksum settings on
 startup
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Commit b9367bf3ee6d ("net: ibmveth: convert to hw_features") accidentally
removed call to ibmveth_set_csum_offload() in ibmveth_probe(). Put the
call back where it was, but with additional error checking provided
by ibmveth_set_features().

Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
[sfr: dev -> netdev]
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/net/ibmveth.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ibmveth.c b/drivers/net/ibmveth.c
index 4855f1f..be3fe71 100644
--- a/drivers/net/ibmveth.c
+++ b/drivers/net/ibmveth.c
@@ -1397,6 +1397,8 @@ static int __devinit ibmveth_probe(struct vio_dev *dev,
 
 	netdev_dbg(netdev, "registering netdev...\n");
 
+	ibmveth_set_features(netdev, netdev->features);
+
 	rc = register_netdev(netdev);
 
 	if (rc) {
-- 
1.7.4.4

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
