Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227Ab1EWS5I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 14:57:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49566 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756219Ab1EWS5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 14:57:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Milton Miller <milltonm@bga.com>
Subject: Re: linux-next: build warning after merge of the suspend tree
Date: Mon, 23 May 2011 20:57:36 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39+; KDE/4.6.0; x86_64; ; )
Cc: mgross <markgross@thegnar.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
References: <20110523150636.ccd83777.sfr@canb.auug.org.au> <20110523141846.GA8122@gvim.org> <pm-qos-needs-fixing@mdm.bga.com>
In-Reply-To: <pm-qos-needs-fixing@mdm.bga.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201105232057.36247.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 23, 2011, Milton Miller wrote:
> On Mon, 23 May 2011 about 14:18:46 -0000, mgross wrote:
> > On Mon, May 23, 2011 at 03:06:36PM +1000, Stephen Rothwell wrote:
> > > Hi Rafael,
> > > 
> > > After merging the suspend tree, today's linux-next build (i386 defconfig
> > > among others) produced this warning:
> > > 
> > > kernel/pm_qos_params.c: In function 'pm_qos_power_write':
> > > kernel/pm_qos_params.c:420: warning: passing argument 3 of 'kstrtol' from incompatible pointer type
> > > include/linux/kernel.h:210: note: expected 'long int *' but argument is of type 's32 *'
> > > 
> > > Intreoduced by commit 365daa955e03 ("PM: Correct PM QOS's user mode
> > > interface to work with ascii input per").
> > 
> > Gah!  I'm sorry about that.
> > 
> > attached is a fix.
> > 
> > 
> > --mark
> > 
> > signed-off-by:markgross <markgross@thegnar.org>
> > 
> 
> (1) This should be in the patch, not the enclosing letter

That message is for me, actually.  I can fold the fix into the patch.

> (2) Incorrect capitalization

Doesn't matter, I can fix it up.

> (3) Incorrect spacing

Likewise.

> Please read Documentation/SubmittingPatches again.
> 
> > 
> > 
> > >From a8f0587b9ae598be5ca4c3cdda4e0ced6ca9baaf Mon Sep 17 00:00:00 2001
> > From: mgross <mgross@cr48>
> > Date: Mon, 23 May 2011 07:14:09 -0700
> > Subject: [PATCH] clean up a compile time warning in the use of strict_strtol but that was
> >  passing an s32 * when it should be passing a long *
> > 
> 
> From should match Signed-off-by:

Not necessarily.

> Please seperate title (subject) and description body

Doesn't matter here.

> Maybe: pm_qos: strict_strtol takes a long, not s32
> 
> strict_strtol takes a pointer to long to store the converted value.
> introduced in xxxx ("change set title here")
> 
> So that the reviewers can quickly see if it needs to be backported
> to stable etc.
> 
> except read below
> 
> 
> > ---
> > kernel/pm_qos_params.c |    6 ++++--
> >  1 files changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel/pm_qos_params.c b/kernel/pm_qos_params.c
> > index d61ecf3..dd37c56 100644
> > --- a/kernel/pm_qos_params.c
> > +++ b/kernel/pm_qos_params.c
> > @@ -405,6 +405,7 @@ static ssize_t pm_qos_power_write(struct file *filp, const char __user *buf,
> >  		size_t count, loff_t *f_pos)
> >  {
> >  	s32 value;
> > +	long safe_int;
> >  	int x;
> >  	char ascii_value[11];
> >  	struct pm_qos_request_list *pm_qos_req;
> > @@ -417,10 +418,11 @@ static ssize_t pm_qos_power_write(struct file *filp, const char __user *buf,
> >  		ascii_value[count] = 0;
> >  		if (copy_from_user(ascii_value, buf, count))
> >  			return -EFAULT;
> > -		if ((x=strict_strtol(ascii_value, 16, &value)) != 0){
> > -			pr_debug("%s, 0x%x, 0x%x\n",ascii_value, value, x);
> > +		if ((x=strict_strtol(ascii_value, 16, &safe_int)) != 0){
> 
> Why are you doing an assignment in the if?  Why not assign first and
> compare later?

Because that's what the original code does?

> > +			pr_debug("%s, 0x%lx, 0x%x\n",ascii_value, safe_int, x);
> >  			return -EINVAL;
> 
> Nit: Some reason not to return -ERANGE if thats what strtol returned?  
> Folding to -EINVAL is ok but hides information.
> 
> >  		}
> > +		value = (s32) safe_int;
> 
> You call strict checking, which includes overflow checking, but
> only that the value fits in a long.  You then defeat that checking
> by casting to int.

That actually is a good point.

Thanks,
Rafael
