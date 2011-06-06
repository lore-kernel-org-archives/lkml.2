Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209Ab1FFJ1A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 05:27:00 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40215 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754126Ab1FFJ06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 05:26:58 -0400
Date: Mon, 6 Jun 2011 10:28:54 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Russ Gorby <russ.gorby@intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        suhail.ahmed@intel.com
Subject: Re: [PATCH 1/5] tty: n_gsm: Add raw-ip support
Message-ID: <20110606102854.2f689349@lxorguk.ukuu.org.uk>
In-Reply-To: <1307127821-21665-2-git-send-email-russ.gorby@intel.com>
References: <[PATCH 0/5] N_GSM patchset : 06/03/2011>
	<1307127821-21665-2-git-send-email-russ.gorby@intel.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> @@ -1590,6 +1616,7 @@ static struct gsm_dlci *gsm_dlci_alloc(struct gsm_mux *gsm, int addr)
>  	dlci->addr = addr;
>  	dlci->adaption = gsm->adaption;
>  	dlci->state = DLCI_CLOSED;
> +	dlci->net = NULL;	/* network not initially created */

kzalloc ised used anyway so this starts NULL

>
> +int gsm_change_mtu(struct net_device *net, int new_mtu)
> +{
> +	if ((new_mtu < 8) || (new_mtu > MAX_MTU))
> +		return -EINVAL;
> +	net->mtu = new_mtu;
> +	return 0;
> +}

Surely at that point you need to renegotiate the DLCI parameters for the
DLCI in question. At the very least you need to sanity check versus the
current settings ?


> +static int gsm_create_network(struct gsm_dlci *dlci, struct gsm_netconfig *nc)
> +{
> +	char *netname;
> +	int retval = 0;
> +	struct net_device *net;
> +	struct gsm_mux_net *mux_net;
> +
> +	if (!capable(CAP_NET_ADMIN))
> +		return -EPERM;
> +
> +	/* Already in a non tty mode */
> +	if (dlci->adaption > 2)
> +		return -EBUSY;

Only you don't have any locking so two ioctls at once will get very
confused


> +	if (retval) {
> +		pr_err("network register fail %d\n", retval);
> +		free_netdev(net);
> +		goto error_ret;

And this leaves the DLCI messed up

> +	kref_init(&mux_net->ref);

What stops this getting referenced between the net register and here ?

On the destroy side you don't seem to put back the old adaption settings
and restore the state (and also have locking v another ioctl missing)

Doesn't look too hard to fix - save the old dlci states when you go
network, put them back when you destroy the network state. For the ioctls
you probably need to cover most of each one with the mutex.
