Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549Ab0KUIlV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 03:41:21 -0500
Received: from 81-174-11-161.staticnet.ngi.it ([81.174.11.161]:33914 "EHLO
	mail.enneenne.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752131Ab0KUIlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 03:41:20 -0500
Date: Sun, 21 Nov 2010 09:41:16 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: linux-kernel@vger.kernel.org, "Nikita V. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, Tejun Heo <tj@kernel.org>
Message-ID: <20101121084116.GO13356@enneenne.com>
Mail-Followup-To: Alexander Gordeev <lasaine@lvk.cs.msu.su>,
	linux-kernel@vger.kernel.org,
	"Nikita V. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
	Tejun Heo <tj@kernel.org>
References: <cover.1290087473.git.lasaine@lvk.cs.msu.su>
 <1a1ebcf97b2eb62548c34d2d8fc139c0703a9077.1290087480.git.lasaine@lvk.cs.msu.su>
 <20101120161351.GC13356@enneenne.com>
 <20101121031305.6f233c80@apollo.gnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101121031305.6f233c80@apollo.gnet>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCHv4 10/17] pps: use BUG_ON for kernel API safety checks
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 21, 2010 at 03:13:05AM +0300, Alexander Gordeev wrote:
> ?? Sat, 20 Nov 2010 17:13:51 +0100
> Rodolfo Giometti <giometti@enneenne.com> ??????????:
> 
> > On Thu, Nov 18, 2010 at 07:01:03PM +0300, Alexander Gordeev wrote:
> > > This way less overhead is involved when running production kernel.
> > > If you want to debug a pps client module please define DEBUG to enable
> > > the checks.
> > > 
> > > Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
> > > ---
> > >  drivers/pps/kapi.c |   33 ++++++++++-----------------------
> > >  1 files changed, 10 insertions(+), 23 deletions(-)
> > > 
> > > diff --git a/drivers/pps/kapi.c b/drivers/pps/kapi.c
> > > index fe832aa..54261c4 100644
> > > --- a/drivers/pps/kapi.c
> > > +++ b/drivers/pps/kapi.c
> > > @@ -81,25 +81,14 @@ struct pps_device *pps_register_source(struct pps_source_info *info,
> > >  	int err;
> > >  
> > >  	/* Sanity checks */
> > > -	if ((info->mode & default_params) != default_params) {
> > > -		pr_err("pps: %s: unsupported default parameters\n",
> > > -					info->name);
> > > -		err = -EINVAL;
> > > -		goto pps_register_source_exit;
> > > -	}
> > > -	if ((info->mode & (PPS_ECHOASSERT | PPS_ECHOCLEAR)) != 0 &&
> > > -			info->echo == NULL) {
> > > -		pr_err("pps: %s: echo function is not defined\n",
> > > -					info->name);
> > > -		err = -EINVAL;
> > > -		goto pps_register_source_exit;
> > > -	}
> > > -	if ((info->mode & (PPS_TSFMT_TSPEC | PPS_TSFMT_NTPFP)) == 0) {
> > > -		pr_err("pps: %s: unspecified time format\n",
> > > -					info->name);
> > > -		err = -EINVAL;
> > > -		goto pps_register_source_exit;
> > > -	}
> > > +
> > > +	/* default_params should be supported */
> > > +	BUG_ON((info->mode & default_params) != default_params);
> > > +	/* echo function should be defined if we are asked to call it */
> > > +	BUG_ON((info->mode & (PPS_ECHOASSERT | PPS_ECHOCLEAR)) != 0 &&
> > > +			info->echo == NULL);
> > > +	/* time format should be specified */
> > > +	BUG_ON((info->mode & (PPS_TSFMT_TSPEC | PPS_TSFMT_NTPFP)) == 0);
> > 
> > Nack.
> > 
> > If the userland gives us some wrong parameters this is not the same of
> > a kernel bug (which BUG_ON is used for). The userland must be notified
> > about the wrong input.
> 
> I agree with what you said completely but this is not a user-space API.
> pps_register_source() can only be called from other kernel code.

Yes, but in turn pps_register_source() is called in a function called
from userspace. The user should know if he/she cannot safely register
his/her new PPS source.

The BUG_ON() should be used for a kernel bug like "Ehi! This can't
happen! Data are corrupted"... but here we are just checking some
input parameters.

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
