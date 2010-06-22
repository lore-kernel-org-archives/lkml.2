Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758769Ab0FVDIu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 23:08:50 -0400
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:47058 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756683Ab0FVDIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 23:08:49 -0400
Subject: Re: [RFC] tpm_tis: Fix subsequent suspend failures
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: tpmdd-devel@lists.sourceforge.net,
       Debora Velarde <debora@linux.vnet.ibm.com>,
       David Safford <safford@watson.ibm.com>, akpm@linux-foundation.org,
       jmorris@namei.org, linux-kernel@vger.kernel.org
In-Reply-To: <201006091511.09810.helmut.schaa@googlemail.com>
References: <201006091227.15729.helmut.schaa@googlemail.com>
	 <201006091511.09810.helmut.schaa@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Tue, 22 Jun 2010 00:08:44 -0300
Message-ID: <1277176124.32011.4.camel@blackbox.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry the ones on CC, previous message got messed up by the mail client.

This patch fixes https://bugzilla.kernel.org/show_bug.cgi?id=16256

Link to original post given it wasn't submitted to LKML originally:
http://marc.info/?l=tpmdd-devel&m=127609160616162&w=2

Acked-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>


On Wed, 2010-06-09 at 15:11 +0200, Helmut Schaa wrote:
> Fix subsequent suspends by issuing tpm_continue_selftest during resume.
> Otherwise, the tpm chip seems to be not fully initialized and will reject
> the save state command during suspend, thus preventing the whole system
> to suspend.
> 
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> ---
> 
> Not sure if the platform resume method should be fixed in the same way.
> Plase review.
> 
> Thanks,
> Helmut
> 
>  drivers/char/tpm/tpm_tis.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
> index 24314a9..1030f84 100644
> --- a/drivers/char/tpm/tpm_tis.c
> +++ b/drivers/char/tpm/tpm_tis.c
> @@ -623,7 +623,14 @@ static int tpm_tis_pnp_suspend(struct pnp_dev *dev, pm_message_t msg)
> 
>  static int tpm_tis_pnp_resume(struct pnp_dev *dev)
>  {
> -	return tpm_pm_resume(&dev->dev);
> +	struct tpm_chip *chip = pnp_get_drvdata(dev);
> +	int ret;
> +
> +	ret = tpm_pm_resume(&dev->dev);
> +	if (!ret)
> +		tpm_continue_selftest(chip);
> +
> +	return ret;
>  }
> 
>  static struct pnp_device_id tpm_pnp_tbl[] __devinitdata = {


