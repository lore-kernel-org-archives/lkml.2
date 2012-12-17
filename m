Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592Ab2LQUQS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 15:16:18 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:57671 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752642Ab2LQUQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 15:16:16 -0500
Message-ID: <1355775376.19706.1.camel@joe-AO722>
Subject: Re: [PATCH 1/2] MCE, AMD: Make MC2 decoding part of amd_decoder_ops
 as well
From: Joe Perches <joe@perches.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Jacob Shin <jacob.shin@amd.com>, Doug Thompson <dougthompson@xmission.com>,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 17 Dec 2012 12:16:16 -0800
In-Reply-To: <20121217200535.GF31866@liondog.tnic>
References: <1355773188-5241-1-git-send-email-jacob.shin@amd.com>
	 <1355774221.13361.48.camel@joe-AO722> <20121217200535.GF31866@liondog.tnic>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-12-17 at 21:05 +0100, Borislav Petkov wrote:
> On Mon, Dec 17, 2012 at 11:57:01AM -0800, Joe Perches wrote:
> > It'd be better to change the pr_cont uses to pr_emerg
> > 
> > []
> > 
> > > +static void decode_mc2_mce(struct mce *m)
> > > +{
> > > +	u16 ec = EC(m->status);
> > > +	u8 xec = XEC(m->status, xec_mask);
> > > +
> > > +	pr_emerg(HW_ERR "MC2 Error: ");

> > 
> > Remove this and
> > 
> > > +	if (fam_ops->mc2_mce(ec, xec))
> > > +		;
> > > +	else
> > > +		pr_emerg(HW_ERR "Corrupted MC2 MCE info?\n");
> > >  }
> > 
> > And make this
> > 
> > 	if (!fam_ops->mc2_mce(ec, xec))
> > 		pr_emerg(etc...);
> 
> No, this is not how we do this here. We do pr_emerg in the main per-bank
> function, i.e. mc0, mc1, mc2... and we finish the line in the respective
> function with pr_cont.
> 
> If your fear is line interleaving, then this shouldn't happen in most
> cases because we're in atomic #MC context and nothing else is executing
> in that case. (And I haven't seen it interleave in all my testing so
> far).
> 
> If it does interleave when we have a non-critical error detected and
> reported in process context, then this whole decoding code needs a lot
> more work than this.
> 

You also have paths where you start a pr_emerg and do not terminate
it when there is no apparent error at all.


