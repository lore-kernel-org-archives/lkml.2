Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969Ab1EXGNH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 02:13:07 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42739 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab1EXGNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 02:13:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:reply-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=Ax3JLOJ5e/bRg/YfbDZ27Zi2wJy5nYGoZbdh5EqXhB5rvy59k+0owdpDkfDlumkzXq
         DoVj+Nu+t3acamPOwVDmhEbImLbrACzV9gXDnGuyZBCl3aL7gPlU3pKOkz+9psW7TSv4
         XEk9T/toIc+Hg+z2dly21pMzRnKysTCucPt2c=
Date: Mon, 23 May 2011 23:13:00 -0700
From: mark gross <markgross@thegnar.org>
To: Milton Miller <miltonm@bga.com>
Cc: mgross <markgross@thegnar.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: build warning after merge of the suspend tree
Message-ID: <20110524061300.GB18075@gvim.org>
Reply-To: markgross@thegnar.org
References: <20110523150636.ccd83777.sfr@canb.auug.org.au>
 <20110523141846.GA8122@gvim.org>
 <pm-qos-needs-fixing@mdm.bga.com>
 <pm-qos-needs-fixing-2@mdm.bga.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <pm-qos-needs-fixing-2@mdm.bga.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 12:42:18PM -0500, Milton Miller wrote:
> [ I managed to botch my own email the first time, how embarrassing!
> So I added Randy and updated the paragraph about negative values.
> And then I need a new Message-Id too. ]

I any more resends from you and I'll have to diff your emails to see
what new comments you have come up with.

FWIW Normally when I submit a patch for quick review this is what
happens.  I should be more careful.  Please note that I didn't start my
subject line with a [patch].


> 
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
> (2) Incorrect capitalization
> (3) Incorrect spacing
> 
> Please read Documentation/SubmittingPatches again.

Yes I will do that. 


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
> 
> Please seperate title (subject) and description body
> 
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
> 
> > +			pr_debug("%s, 0x%lx, 0x%x\n",ascii_value, safe_int, x);
> >  			return -EINVAL;
> 
> Nit: Some reason not to return -ERANGE if thats what strtol returned?  
> While folding the error to -EINVAL is ok, it hides diagnostic informatio
> from the user.
I think EINVAL matches the documentation for this ABI better that
ERANGE.

> 
> >  		}
> > +		value = (s32) safe_int;
> 
> You call strict checking, which includes overflow checking, but
> only that the value fits in a long.  You then defeat that checking
> by casting to int.

The documentation for the ABI says that it has to be a hex value of the
formation 0x12345678 otherwise its not valid.  s32 is big enough for
that.  I thought about masking for a second and decided this is good
enough.


> It looks like you want strict_strtoint except thats not defined.
> Hoever, the pattern for strict_strto* is kstrto* and kstrtos32 is
> defined ...

hmm, I'll look at the strtos32. That is what I would like.

> 
> >  	} else
> >  		return -EINVAL;
> >  
> 
> Oh, and you now may copy 11 characters from userspace into an 11
> character buffer then terminate it by writing the 12th character
> (ascii_value[count == 11]).  Except its an 11 character array.

yes, if count = 11 then this code is overwriting by one byte :(  I must
have gotten luckly because 11 is an odd number and the compiler padded
it from me.  I'll fix that in a future patch. 

> The variable is a s32, aparently in native endian if pased in binary
> as 4 bytes.  What is the magic to set the value to a negative number
> through the ascii interface?  Is yet another character for the -
> required?
No. The ABI documentation is pretty clear about the text format being
simple hex 0x12345678 styled.


--mark

> 
> 
> I see the string from userspace wasn't properly terminated before
> either.  In ed77134bfccf5e75b (PM QOS update), merged in v2.6.35-rc1,
> 11 bytes were copied from user then passed to ssscanf without null
> termination forced.  It was updated in 0109c2c48d (PM QoS: Correct
> pr_debug() misuse and improve parameter checks), which was merged in
> 2.6.36-rc4, to change the the function that walks off the string from
> sscanf to strlen.  That changelog isn't marked for stable (I didn't
> look if it was sent) but it still isn't force terminated.
> 
> happy patching,
> milton
