Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952Ab1FCWDV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 18:03:21 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58395 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752902Ab1FCWDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 18:03:20 -0400
Date: Fri, 3 Jun 2011 23:05:14 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Russ Gorby <russ.gorby@intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        suhail.ahmed@intel.com
Subject: Re: [PATCH 4/5] tty: n_gsm: initiate close of all DLCIs during mux
 shutdown
Message-ID: <20110603230514.334df229@lxorguk.ukuu.org.uk>
In-Reply-To: <1307127821-21665-5-git-send-email-russ.gorby@intel.com>
References: <[PATCH 0/5] N_GSM patchset : 06/03/2011>
	<1307127821-21665-5-git-send-email-russ.gorby@intel.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  3 Jun 2011 12:03:40 -0700
Russ Gorby <russ.gorby@intel.com> wrote:

> Although DLCI-0 is closed during ldisc close, we found the
> applications were better served when open DLCI shutdowns where
> initiated at that time as well.

They should all see a hangup on the gsm client tty anyway ?

> -	for (i = 0; i < NUM_DLCI; i++)
> +	for (i = NUM_DLCI-1; i >= 0; i--) {
> +		dlci = gsm->dlci[i];
> +		if (dlci) {
> +			if (i != 0)
> +				gsm_dlci_begin_close(dlci);
> +			else {
> +				dlci->dead = 1;
> +				gsm_dlci_begin_close(dlci);
> +				t = wait_event_timeout(gsm->event,
> +					   dlci->state == DLCI_CLOSED,
> +					   gsm->t2 * HZ / 100);
> +				if (!t) {
> +					pr_info("%s: timeout dlci0 close",
> +						__func__);
> +					gsm_dlci_close(dlci);
> +				}
> +			}
> +		}
> +	}
> +	for (i = NUM_DLCI-1; i >= 0; i--)

I'd like to understand better why it is needed and also why you don't
want for the others to close but just set it off ?
