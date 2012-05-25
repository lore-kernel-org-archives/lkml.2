Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964972Ab2EYRFP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 13:05:15 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:57143 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964791Ab2EYRFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 13:05:12 -0400
Message-ID: <1337965507.2932.39.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH] scsi: fix async probe regression
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Meelis Roos <mroos@linux.ee>, Alan Stern <stern@rowland.harvard.edu>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        David Miller <davem@davemloft.net>
Date: Fri, 25 May 2012 18:05:07 +0100
In-Reply-To: <20120525163529.28315.92813.stgit@dwillia2-linux.jf.intel.com>
References: <20120525163529.28315.92813.stgit@dwillia2-linux.jf.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-25 at 09:39 -0700, Dan Williams wrote:
> Commit a7a20d1 "[SCSI] sd: limit the scope of the async probe domain"
> moved sd probe work out of reach of wait_for_device_probe().  Allow it
> to be synced via scsi_complete_async_scans().
> 
> Cc: David Miller <davem@davemloft.net>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Reported-by: Meelis Roos <mroos@linux.ee>
> Tested-by: Meelis Roos <mroos@linux.ee>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> 
>  So this is the stop gap that allows us to keep a7a20d1 as a fix for a
>  resume deadlock, and gives us time to figure out how to clarify
>  async_synchronize_full() properly in the 3.6 timeframe.
> 
>  drivers/scsi/scsi_scan.c |   12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 01b0374..41f9192 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -141,13 +141,13 @@ struct async_scan_data {
>   * started scanning after this function was called may or may not have
>   * finished.
>   */
> -int scsi_complete_async_scans(void)
> +static void __scsi_complete_async_scans(void)

Rather than wrappering the function, can we just fix it?

Put the async_synchronize_full_domain(&scsi_sd_probe_domain); at the
bottom with an out: label and make the only other return in the function
become a goto out;

Thanks,

James




