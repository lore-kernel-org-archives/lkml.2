Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab2LQUFj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 15:05:39 -0500
Received: from mail.skyhub.de ([78.46.96.112]:49566 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642Ab2LQUFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 15:05:37 -0500
Date: Mon, 17 Dec 2012 21:05:35 +0100
From: Borislav Petkov <bp@alien8.de>
To: Joe Perches <joe@perches.com>
Cc: Jacob Shin <jacob.shin@amd.com>, Doug Thompson <dougthompson@xmission.com>,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] MCE, AMD: Make MC2 decoding part of amd_decoder_ops
 as well
Message-ID: <20121217200535.GF31866@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Joe Perches <joe@perches.com>, Jacob Shin <jacob.shin@amd.com>,
	Doug Thompson <dougthompson@xmission.com>,
	linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1355773188-5241-1-git-send-email-jacob.shin@amd.com>
 <1355774221.13361.48.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1355774221.13361.48.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 11:57:01AM -0800, Joe Perches wrote:
> It'd be better to change the pr_cont uses to pr_emerg
> 
> []
> 
> > +static void decode_mc2_mce(struct mce *m)
> > +{
> > +	u16 ec = EC(m->status);
> > +	u8 xec = XEC(m->status, xec_mask);
> > +
> > +	pr_emerg(HW_ERR "MC2 Error: ");
> 
> Remove this and
> 
> > +	if (fam_ops->mc2_mce(ec, xec))
> > +		;
> > +	else
> > +		pr_emerg(HW_ERR "Corrupted MC2 MCE info?\n");
> >  }
> 
> And make this
> 
> 	if (!fam_ops->mc2_mce(ec, xec))
> 		pr_emerg(etc...);

No, this is not how we do this here. We do pr_emerg in the main per-bank
function, i.e. mc0, mc1, mc2... and we finish the line in the respective
function with pr_cont.

If your fear is line interleaving, then this shouldn't happen in most
cases because we're in atomic #MC context and nothing else is executing
in that case. (And I haven't seen it interleave in all my testing so
far).

If it does interleave when we have a non-critical error detected and
reported in process context, then this whole decoding code needs a lot
more work than this.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
