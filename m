Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab0FWTTn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 15:19:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45213 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752983Ab0FWTTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 15:19:41 -0400
Date: Wed, 23 Jun 2010 12:18:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
       tpmdd-devel@lists.sourceforge.net,
       Debora Velarde <debora@linux.vnet.ibm.com>,
       David Safford <safford@watson.ibm.com>, jmorris@namei.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] tpm_tis: Fix subsequent suspend failures
Message-Id: <20100623121850.e000ac8b.akpm@linux-foundation.org>
In-Reply-To: <1277176124.32011.4.camel@blackbox.ibm.com>
References: <201006091227.15729.helmut.schaa@googlemail.com>
	<201006091511.09810.helmut.schaa@googlemail.com>
	<1277176124.32011.4.camel@blackbox.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jun 2010 00:08:44 -0300
Rajiv Andrade <srajiv@linux.vnet.ibm.com> wrote:

> On Wed, 2010-06-09 at 15:11 +0200, Helmut Schaa wrote:
> > Fix subsequent suspends by issuing tpm_continue_selftest during resume.
> > Otherwise, the tpm chip seems to be not fully initialized and will reject
> > the save state command during suspend, thus preventing the whole system
> > to suspend.
> > 
> > Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> > ---
> > 
> > Not sure if the platform resume method should be fixed in the same way.
> > Plase review.
> > 
> > Thanks,
> > Helmut
> > 
> >  drivers/char/tpm/tpm_tis.c |    9 ++++++++-
> >  1 files changed, 8 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
> > index 24314a9..1030f84 100644
> > --- a/drivers/char/tpm/tpm_tis.c
> > +++ b/drivers/char/tpm/tpm_tis.c
> > @@ -623,7 +623,14 @@ static int tpm_tis_pnp_suspend(struct pnp_dev *dev, pm_message_t msg)
> > 
> >  static int tpm_tis_pnp_resume(struct pnp_dev *dev)
> >  {
> > -	return tpm_pm_resume(&dev->dev);
> > +	struct tpm_chip *chip = pnp_get_drvdata(dev);
> > +	int ret;
> > +
> > +	ret = tpm_pm_resume(&dev->dev);
> > +	if (!ret)
> > +		tpm_continue_selftest(chip);
> > +
> > +	return ret;
> >  }
> > 
> >  static struct pnp_device_id tpm_pnp_tbl[] __devinitdata = {
>
> Sorry the ones on CC, previous message got messed up by the mail client.
> 
> This patch fixes https://bugzilla.kernel.org/show_bug.cgi?id=16256
> 
> Link to original post given it wasn't submitted to LKML originally:
> http://marc.info/?l=tpmdd-devel&m=127609160616162&w=2
> 
> Acked-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
> 

(top-posting repaired.  Please don't do that).

This wasn't a very good way to send a patch.  I edited the diff,
reconstructed the patch and then assembled a decent-looking changelog. 
I also changed your acked-by to the required signed-off-by, because you
were on the patch's delivery path.

Pretty please: next time, prepare a proper mergeable patch with the
correct attributions and signoffs?  Thanks.
