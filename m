Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572Ab0I1MZW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 08:25:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37180 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752440Ab0I1MZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 08:25:21 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: Dynamic Debug module.ddebug fake param enhancements V4
Date: Tue, 28 Sep 2010 14:25:18 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.31.5-0.1-desktop; KDE/4.4.3; x86_64; ; )
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, jbaron@redhat.com
References: <20100920184441.GA2915@redhat.com> <201009271025.47558.trenn@suse.de> <201009270909.18490.bjorn.helgaas@hp.com>
In-Reply-To: <201009270909.18490.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201009281425.19070.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg: Do you mind pushing the first (1/4, V4) and the last (4/4)
patch into your tree for linux-next and leave the two PNP patches
out, please.

More PNP related discussion, below.

On Monday 27 September 2010 17:09:18 Bjorn Helgaas wrote:
> On Monday, September 27, 2010 02:25:46 am Thomas Renninger wrote:
> 
> > What do you think (dev_dbg vs printk(KERN_DEBUG...)?
...
> With the exception of the ones in pnp/resource.c that I want to convert
> to dev_printk(KERN_DEBUG), I think all the pnp_dbg() uses are things
> I used during PNP development and haven't ever needed since.

Ok. Sounds sane.
I used the PNP parts as it nicely showed what the
module.ddebug boot param is doing, but I agree it hasn't much
advantage for PNP.

Whatabout compiling pnp in one module namespace, the first
of the two PNP patches?
I do not see an urgent need/advantage, it would just be a general
cleanup.
PNP could then make use of moduleparam.h interface instead of using
__setup(..).

E.g. attached patch would be an on top patch which provides no
functional change, just that a pnp.debug would be a module param:
cat /sys/module/pnp/parameters/debug

Again there is not much use for this with pnp as all should be
processed at boot time. But theoretically one could enable pnp.debug
at runtime :) (or it should get hidden with 0000 perms if not needed).
It's more a general cleanup, further pnp boot params can be
pnp.xy module params then.

Bjoern: If you like them I can repost these two:
(PNP build in one module namespace and below)

        Thomas

---------
PNP: Set up pnp_debug via module and not via boot param.

Cleanup only, no functional change (pnp.debug can be enabled
and disabled at runtime, but that's not a real enhancement).

This one depends on another PNP cleanup patch:
PNP: Compile all pnp built-in stuff in one module namespace

Signed-off-by: Thomas Renninger <trenn@suse.de>

diff --git a/drivers/pnp/core.c b/drivers/pnp/core.c
index 88b3cde..9801918 100644
--- a/drivers/pnp/core.c
+++ b/drivers/pnp/core.c
@@ -218,10 +218,5 @@ subsys_initcall(pnp_init);
 int pnp_debug;
 
 #if defined(CONFIG_PNP_DEBUG_MESSAGES)
-static int __init pnp_debug_setup(char *__unused)
-{
-	pnp_debug = 1;
-	return 1;
-}
-__setup("pnp.debug", pnp_debug_setup);
+module_param_named(debug, pnp_debug, int, 0644);
 #endif
