Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024Ab2ILMbn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 08:31:43 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:54924 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551Ab2ILMbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:31:42 -0400
Date: Wed, 12 Sep 2012 13:36:13 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jens Axboe <axboe@kernel.dk>, Ric Wheeler <rwheeler@redhat.com>,
        linux-iscsi@vger.kernel.org
Subject: Re: [PATCH 2/3] scsi: create an all-zero filter for scanners
Message-ID: <20120912133613.1255aa52@pyramind.ukuu.org.uk>
In-Reply-To: <1347449024-26387-3-git-send-email-pbonzini@redhat.com>
References: <1347449024-26387-1-git-send-email-pbonzini@redhat.com>
	<1347449024-26387-3-git-send-email-pbonzini@redhat.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Sep 2012 13:23:43 +0200
Paolo Bonzini <pbonzini@redhat.com> wrote:

> Using /dev/sg for scanners is blocked from unprivileged users.  Reimplement
> this using customizable command filters, so that the sysfs knobs will work
> in this case too.
> 
> Cc: linux-iscsi@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  drivers/scsi/scsi_scan.c |    6 +++++-
>  drivers/scsi/sg.c        |    3 ---
>  2 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 56a9379..d168c15 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -773,13 +773,17 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
>  	}
>  
>  	switch (sdev->type) {
> +	case TYPE_SCANNER:
> +		sdev->request_queue->cmd_filter =
> +			kzalloc(sizeof(struct blk_cmd_filter), GFP_KERNEL);
> +		/* fallthrough */

Is that really desireable in the kzalloc failing case ?

