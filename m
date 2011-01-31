Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245Ab1AaRpE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 12:45:04 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:55248 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756141Ab1AaRpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 12:45:00 -0500
Date: Mon, 31 Jan 2011 18:44:54 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: walter harms <wharms@bfs.de>
Cc: Lars Ellenberg <drbd-dev@lists.linbit.com>,
        kernel-janitors@vger.kernel.org, drbd-user@lists.linbit.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/block/drbd: add NULL test around call to
 crypto_free_hash
In-Reply-To: <4D46F3E5.7060804@bfs.de>
Message-ID: <Pine.LNX.4.64.1101311843560.16049@pc-004.diku.dk>
References: <1296496263-16362-1-git-send-email-julia@diku.dk> <4D46F3E5.7060804@bfs.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Jan 2011, walter harms wrote:

> 
> 
> Am 31.01.2011 18:51, schrieb Julia Lawall:
> > crypto_free_hash calls the function crypto_hash_tfm and then
> > crypto_free_tfm on the result.  crypto_free_tfm calls crypto_destroy_tfm,
> > which tests this result for NULL and then dereferences it.  crypto_hash_tfm
> > returns &tfm->base where tfm is its argument.  base is actually the first
> > and only field of a crypto_hash-typed structure, so perhaps one can rely on
> > it to return NULL for a NULL value of tfm.  But most calls to
> > crypto_hash_tfm where the argument might be NULL don't rely on this
> > property and test for NULL explicitly.
> > 
> > The semantic match that finds this problem is as follows:
> > (http://coccinelle.lip6.fr/)
> > 
> > // <smpl>
> > @safe@
> > position p;
> > expression x;
> > @@
> > 
> > if (x) { <+... crypto_free_hash@p(x) ...+> }
> > 
> > @@
> > expression x;
> > position p!=safe.p;
> > @@
> > 
> > *x = NULL
> > ...
> > *crypto_free_hash@p(x)
> > // </smpl>
> > 
> > Signed-off-by: Julia Lawall <julia@diku.dk>
> > 
> > ---
> >  drivers/block/drbd/drbd_nl.c       |   18 ++++++++++++------
> >  drivers/block/drbd/drbd_receiver.c |    6 ++++--
> >  2 files changed, 16 insertions(+), 8 deletions(-)
> > 
> > diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
> > index 8cbfaa6..aa5fbc0 100644
> > --- a/drivers/block/drbd/drbd_nl.c
> > +++ b/drivers/block/drbd/drbd_nl.c
> > @@ -1482,13 +1482,16 @@ static int drbd_nl_net_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp,
> >  		mdev->ee_hash = new_ee_hash;
> >  	}
> >  
> > -	crypto_free_hash(mdev->cram_hmac_tfm);
> > +	if (mdev->cram_hmac_tfm)
> > +		crypto_free_hash(mdev->cram_hmac_tfm);
> >  	mdev->cram_hmac_tfm = tfm;
> >  
> > -	crypto_free_hash(mdev->integrity_w_tfm);
> > +	if (mdev->integrity_w_tfm)
> > +		crypto_free_hash(mdev->integrity_w_tfm);
> >  	mdev->integrity_w_tfm = integrity_w_tfm;
> >  
> > -	crypto_free_hash(mdev->integrity_r_tfm);
> > +	if (mdev->integrity_r_tfm)
> > +		crypto_free_hash(mdev->integrity_r_tfm);
> >  	mdev->integrity_r_tfm = integrity_r_tfm;
> >  
> >  	kfree(mdev->int_dig_out);
> > @@ -1509,9 +1512,12 @@ fail:
> >  	kfree(int_dig_out);
> >  	kfree(int_dig_in);
> >  	kfree(int_dig_vv);
> > -	crypto_free_hash(tfm);
> > -	crypto_free_hash(integrity_w_tfm);
> > -	crypto_free_hash(integrity_r_tfm);
> > +	if (tfm)
> > +		crypto_free_hash(tfm);
> > +	if (integrity_w_tfm)
> > +		crypto_free_hash(integrity_w_tfm);
> > +	if (integrity_r_tfm)
> > +		crypto_free_hash(integrity_r_tfm);
> >  	kfree(new_tl_hash);
> >  	kfree(new_ee_hash);
> >  	kfree(new_conf);
> > diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
> > index 24487d4..3453cc3 100644
> > --- a/drivers/block/drbd/drbd_receiver.c
> > +++ b/drivers/block/drbd/drbd_receiver.c
> > @@ -2871,9 +2871,11 @@ static int receive_SyncParam(struct drbd_conf *mdev, enum drbd_packets cmd, unsi
> >  disconnect:
> >  	/* just for completeness: actually not needed,
> >  	 * as this is not reached if csums_tfm was ok. */
> > -	crypto_free_hash(csums_tfm);
> > +	if (csums_tfm)
> > +		crypto_free_hash(csums_tfm);
> >  	/* but free the verify_tfm again, if csums_tfm did not work out */
> > -	crypto_free_hash(verify_tfm);
> > +	if (verify_tfm)
> > +		crypto_free_hash(verify_tfm);
> >  	drbd_force_state(mdev, NS(conn, C_DISCONNECTING));
> >  	return FALSE;
> >  }
> > 
> 
> it looks that it would be more sensibel to change crypto_free_hash() to handle
> NULL that would be more consistent with the free() family.

That was the other option...

julia
