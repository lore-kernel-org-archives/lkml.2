Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab1C0Ncy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 09:32:54 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53894 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751577Ab1C0Ncw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 09:32:52 -0400
Date: Sun, 27 Mar 2011 14:30:24 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
Cc: linux-serial@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        stable@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty/n_gsm: fix bug in CRC calculation for gsm1 mode
Message-ID: <20110327143024.66c1fb0f@lxorguk.ukuu.org.uk>
In-Reply-To: <1301184300-9158-1-git-send-email-mikhail.kshevetskiy@gmail.com>
References: <1301184300-9158-1-git-send-email-mikhail.kshevetskiy@gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>   gsm->received_fcs is not used for GSM1 mode. Thus we put an
>   additional byte to CRC calculation. As result we get a wrong CRC
>   and reject incoming frame.

That much is true except that it was originally tested with gsm encoding
1 on various modems for a while and not seen the problem. So I am trying
to work out why or whether some of the GSM0 patches broke GSM1 somewhere.

What hardware was it tested on ?

It looks right - probably the code wants pushing into
gsm0_receive/gsm1_receive appropriately so no special cases leak into
gsm_queue.



> 
> Signed-off-by: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
> ---
>  drivers/tty/n_gsm.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
> index 176f632..4806276 100644
> --- a/drivers/tty/n_gsm.c
> +++ b/drivers/tty/n_gsm.c
> @@ -1658,8 +1658,12 @@ static void gsm_queue(struct gsm_mux *gsm)
>  
>  	if ((gsm->control & ~PF) == UI)
>  		gsm->fcs = gsm_fcs_add_block(gsm->fcs, gsm->buf, gsm->len);
> -	/* generate final CRC with received FCS */
> -	gsm->fcs = gsm_fcs_add(gsm->fcs, gsm->received_fcs);
> +	if (gsm->encoding == 0){
> +		/* WARNING: gsm->received_fcs is used for gsm->encoding = 0 only.
> +		            In this case it contain the last piece of data
> +		            required to generate final CRC */
> +		gsm->fcs = gsm_fcs_add(gsm->fcs, gsm->received_fcs);
> +	}
>  	if (gsm->fcs != GOOD_FCS) {
>  		gsm->bad_fcs++;
>  		if (debug & 4)


-- 
--
	"Alan, I'm getting a bit worried about you."
				-- Linus Torvalds
