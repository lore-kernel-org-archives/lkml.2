Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762182Ab2DLIlK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 04:41:10 -0400
Received: from mail09.linbit.com ([212.69.161.110]:60570 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab2DLIlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 04:41:01 -0400
X-Greylist: delayed 462 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Apr 2012 04:41:01 EDT
Date: Thu, 12 Apr 2012 10:33:16 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Cong Wang <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        Lars Ellenberg <drbd-dev@lists.linbit.com>
Subject: Re: [Drbd-dev] [Patch] drbd: check MODULE for THIS_MODULE
Message-ID: <20120412083316.GK9163@barkeeper1-xen.linbit>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Cong Wang <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
	Lars Ellenberg <drbd-dev@lists.linbit.com>
References: <1333433616-8315-1-git-send-email-xiyou.wangcong@gmail.com>
 <20120409161427.1decc2c1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120409161427.1decc2c1.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2012 at 04:14:27PM -0700, Andrew Morton wrote:
> On Tue,  3 Apr 2012 14:13:36 +0800
> Cong Wang <xiyou.wangcong@gmail.com> wrote:
> 
> > THIS_MODULE is NULL only when drbd is compiled as built-in,
> > so the #ifdef CONFIG_MODULES should be #ifdef MODULE instead.
> > 
> > This fixes the warning:
> > 
> > drivers/block/drbd/drbd_main.c: In function ___drbd_buildtag___:
> > drivers/block/drbd/drbd_main.c:4187:24: warning: the comparison will always evaluate as ___true___ for the address of _____this_module___ will never be NULL [-Waddress]
> > 
> > Cc: Lars Ellenberg <drbd-dev@lists.linbit.com>
> > Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> > 
> > ---
> > diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
> > index 211fc44..96c432f 100644
> > --- a/drivers/block/drbd/drbd_main.c
> > +++ b/drivers/block/drbd/drbd_main.c
> > @@ -4183,12 +4183,11 @@ const char *drbd_buildtag(void)
> >  	static char buildtag[38] = "\0uilt-in";
> >  
> >  	if (buildtag[0] == 0) {
> > -#ifdef CONFIG_MODULES
> > -		if (THIS_MODULE != NULL)
> > -			sprintf(buildtag, "srcversion: %-24s", THIS_MODULE->srcversion);
> > -		else
> > +#ifdef MODULE
> > +		sprintf(buildtag, "srcversion: %-24s", THIS_MODULE->srcversion);
> > +#else
> > +		buildtag[0] = 'b';
> >  #endif
> > -			buildtag[0] = 'b';
> >  	}
> >  
> >  	return buildtag;
> 
> If the MODULE_SRCVERSION_ALL help in init/Kconfig is to be believed,
> this should depend on CONFIG_MODULE_SRCVERSION_ALL?
> 
> But drbd is the only driver in all of Linux which plays with
> srcversion.  Can we just delete this code?

Technically we sure can.

cat /proc/drbd is the first thing we ask for in problem reports, and it
sure helps and saves a few roundtrips knowing which exact version of
in-tree or out-of-tree drbd version is in use.
For an out-of-tree build, we print the exact git-hash there.
For an in-tree build, the srcversion was the "obvious" substitute.
If it is not too much trouble, I'd like to keep that info.

	Lars
