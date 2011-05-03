Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab1ECV1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 17:27:52 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36745 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752886Ab1ECV1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 17:27:51 -0400
Date: Tue, 3 May 2011 22:29:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH 01/23] intel_sst: Save audio state across D3 on Medfield
Message-ID: <20110503222903.4200a6bd@lxorguk.ukuu.org.uk>
In-Reply-To: <20110503174254.GA6545@kroah.com>
References: <20110503162919.24853.58699.stgit@bob.linux.org.uk>
	<20110503163128.24853.15446.stgit@bob.linux.org.uk>
	<20110503174254.GA6545@kroah.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Signed-off-by: Vinod Koul <vinod.koul@intel.com>
> > Signed-off-by: Ramesh Babu K V <ramesh.babu@intel.com>
> > Signed-off-by: Alan Cox <alan@linux.intel.com>
> 
> Something is messed up here as:
> 
> > --- a/drivers/staging/intel_sst/intel_sst_drv_interface.c
> > +++ b/drivers/staging/intel_sst/intel_sst_drv_interface.c
> > @@ -508,6 +508,7 @@ int register_sst_card(struct intel_sst_card_ops *card)
> >  			sst_drv_ctx->pmic_state = SND_MAD_INIT_DONE;
> >  			sst_drv_ctx->rx_time_slot_status = 0; /*default AMIC*/
> >  			card->pcm_control = sst_pmic_ops.pcm_control;
> > +			sst_drv_ctx->scard_ops->card_status = SND_CARD_UN_INIT;
> >  			return 0;
> >  		} else {
> >  			pr_err("strcmp fail %s\n", card->module_name);
> 
> This line is in the original patch from Vinod in this function that
> added the driver to the tree (git commit id fffa1cca), so the patch
> doesn't apply at all.  Do you see this too?

I see it present in ffa1cca then removed then added back

I see the problem - Mark Brown took a patch in staging via the ASoC tree
which clashes with this.

fa880004682cf0d10e7a7c71dc8d56bbd67ac3d5

which is not only a staging patch but also breaks compilation of the code
because the sst_drv_ctx symbol isn't even exported or visible to the
intelmid module, which suggests it wasn't even compile tested.

Best plan seems to be for the patch Mark took to go into the staging tree
as well, and I'll then rebuild the patch stack on top of it and fix the
fact it didn't even build.

In general we have a bigger problem here, the ASoC driver appears to be
violating rule #1 of staging - nothing outside of staging should be using
or depending upon staging code in the first place.

Alan
