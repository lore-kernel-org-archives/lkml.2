Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113Ab1C0RdK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 13:33:10 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45596 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423Ab1C0RdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 13:33:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=iT27UH1Tyg1wgMq06RoWFaCgN60RUWib86aqbxhHpXGjPYTjN0nb/xGWyHoz21C40U
         U3mcUefgeyfwoIlAGuBHGbhDi4rH0If/C4xALUEG3dxSkYhn8ekqNtPA6wDxUaW59bz7
         z+3RxmadUThhoGWVJ6bYxmehzK9zA2OASj7mU=
Date: Sun, 27 Mar 2011 21:33:00 +0400
From: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-serial@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        stable@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty/n_gsm: fix bug in CRC calculation for gsm1 mode
Message-ID: <20110327213300.6ce7d1f2@laska.campus-ws.pu.ru>
In-Reply-To: <20110327143024.66c1fb0f@lxorguk.ukuu.org.uk>
References: <1301184300-9158-1-git-send-email-mikhail.kshevetskiy@gmail.com>
	<20110327143024.66c1fb0f@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Mar 2011 14:30:24 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> >   gsm->received_fcs is not used for GSM1 mode. Thus we put an
> >   additional byte to CRC calculation. As result we get a wrong CRC
> >   and reject incoming frame.
> 
> That much is true except that it was originally tested with gsm encoding
> 1 on various modems for a while and not seen the problem. So I am trying
> to work out why or whether some of the GSM0 patches broke GSM1 somewhere.

as i can see, it's your commit c2f2f0000bb69f067fea12624272e6a58a811702.

Why we need received_fcs variable? We can completely drop it and calculate
fsc in gsm0_receive() and gsm1_receive(). gsm_queue() in this case will
contain only fsc checking code.

> What hardware was it tested on ?

Enfora, Inc. Enabler-III G Modem

> It looks right - probably the code wants pushing into
> gsm0_receive/gsm1_receive appropriately so no special cases leak into
> gsm_queue.

It's possible, see my comment about received_fcs variable above

> 
> 
> > 
> > Signed-off-by: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
> > ---
> >  drivers/tty/n_gsm.c |    8 ++++++--
> >  1 files changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
> > index 176f632..4806276 100644
> > --- a/drivers/tty/n_gsm.c
> > +++ b/drivers/tty/n_gsm.c
> > @@ -1658,8 +1658,12 @@ static void gsm_queue(struct gsm_mux *gsm)
> >  
> >  	if ((gsm->control & ~PF) == UI)
> >  		gsm->fcs = gsm_fcs_add_block(gsm->fcs, gsm->buf, gsm->len);
> > -	/* generate final CRC with received FCS */
> > -	gsm->fcs = gsm_fcs_add(gsm->fcs, gsm->received_fcs);
> > +	if (gsm->encoding == 0){
> > +		/* WARNING: gsm->received_fcs is used for gsm->encoding = 0 only.
> > +		            In this case it contain the last piece of data
> > +		            required to generate final CRC */
> > +		gsm->fcs = gsm_fcs_add(gsm->fcs, gsm->received_fcs);
> > +	}
> >  	if (gsm->fcs != GOOD_FCS) {
> >  		gsm->bad_fcs++;
> >  		if (debug & 4)
> 
> 
> -- 
> --
> 	"Alan, I'm getting a bit worried about you."
> 				-- Linus Torvalds
