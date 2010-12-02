Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619Ab0LBAB1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 19:01:27 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46333 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475Ab0LBAB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 19:01:26 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: 2.6.35.5: hibernation broken... AGAIN
Date: Thu, 2 Dec 2010 01:00:39 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc4+; KDE/4.4.4; x86_64; ; )
Cc: Hugh Dickins <hughd@google.com>, Ondrej Zary <linux@rainbow-software.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@in.ibm.com>
References: <201011171139.33398.linux@rainbow-software.org> <201012012323.31311.rjw@sisk.pl> <20101202083753.eaed2963.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20101202083753.eaed2963.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012020100.39574.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 02, 2010, KAMEZAWA Hiroyuki wrote:
> On Wed, 1 Dec 2010 23:23:31 +0100
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Wednesday, December 01, 2010, Rafael J. Wysocki wrote:
> > > On Wednesday, December 01, 2010, KAMEZAWA Hiroyuki wrote:
> > > > On Wed, 1 Dec 2010 01:38:53 +0100
> > > > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > > > 
> > > > > On Wednesday, December 01, 2010, Rafael J. Wysocki wrote:
> > > > > > On Tuesday, November 30, 2010, Hugh Dickins wrote:
> > > > > > > On Sat, 27 Nov 2010, Rafael J. Wysocki wrote:
> > > > > > > > On Saturday, November 27, 2010, Ondrej Zary wrote:
> > > > > ...
> > > > > > > 
> > > > > > > Trivial point, I suppose, but it bothers me that PM is accumulating
> > > > > > > wrappers around wrappers around gfp_allowed_mask.  Looks like
> > > > > > > clear_gfp_allowed_mask and set_gfp_allowed_mask (oddly asymmetrical)
> > > > > > > were not really what we need.  How about scrapping them, and putting
> > > > > > > pm_restrict_gfp_mask() and pm_restore_gfp_mask() into page_alloc.c?
> > > > > > 
> > > > > > Sure, that sounds like a good idea indeed.
> > > > > 
> > > > > Below is an updated patch in which I tried to address your comments.
> > > > > 
> > > > > I didn't find it very useful to couple pm_restore_gfp_mask() with the thawing
> > > > > of tasks, but nevertheless I think all of the spots where it's needed are
> > > > > covered now.
> > > > > 
> > > > > The patch has only been compile-tested for now, so caveat emptor.
> > > > > 
> > > > 
> > > > Hmm, can't we have some error check as 
> > > > 
> > > > > +static gfp_t saved_gfp_mask;
> > > > 
> > > > atomic_t gfp_mask_save_mode_counter;
> > > > 
> > > > > +
> > > > > +void pm_restore_gfp_mask(void)
> > > > >  {
> > > > >  	WARN_ON(!mutex_is_locked(&pm_mutex));
> > > > > -	gfp_allowed_mask = mask;
> > > > 
> > > > 	if (atomic_dec_return(&gfp_mask_save_mode_counter))
> > > > 		WARN_ONCE()
> > > > 
> > > > > +	if (saved_gfp_mask) {
> > > > > +		gfp_allowed_mask = saved_gfp_mask;
> > > > > +		saved_gfp_mask = 0;
> > > > > +	}
> > > > >  }
> > > > 
> > > > > +void pm_restrict_gfp_mask(void)
> > > > >  {
> > > > > -	gfp_t ret = gfp_allowed_mask;
> > > > > -
> > > > >  	WARN_ON(!mutex_is_locked(&pm_mutex));
> > > > > -	gfp_allowed_mask &= ~mask;
> > > > > -	return ret;
> > > > > +	saved_gfp_mask = gfp_allowed_mask;
> > > > > +	gfp_allowed_mask &= ~GFP_IOFS;
> > > > 
> > > > 	if (atomic_inc_return(&gfp_mask_save_mode_counter) > 1)
> > > > 		WARN_ONCE()
> > > > 
> > > > or some ?
> > > 
> > > What exactly would that be useful for?
> > 
> > Please note that pm_restore_gfp_mask() can be legitimately called before
> > pm_restrict_gfp_mask() via the SNAPSHOT_CREATE_IMAGE hibernate ioctl, so the
> > test you're suggesting wouldn't really work.
> > 
> 
> Hm, I just wonder some tests not for breaking gfp_allowed_mask by
>  - double call

That's easy.  It's sufficient to do WARN_ON(saved_gfp_mask) at the beginning
of pm_restrict_gfp_mask().  This also takes care of the "forget to restore"
case to some extent, because pm_restrict_gfp_mask() will generally be only
called twice in a row if there's a missing pm_restore_gfp_mask() in between.

>  - forget to restore

This is kind of difficult in general.  You can't detect a missing
pm_restore_gfp_mask() other than by checking if pm_restrict_gfp_mask() is not
called twice in a row IMHO.

> That will be fatal.

Yes, it will.

> I'm not very interested in implementation detail

Well ...

Thanks,
Rafael
