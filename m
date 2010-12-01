Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105Ab0LAV0h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 16:26:37 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46059 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876Ab0LAV0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 16:26:36 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: 2.6.35.5: hibernation broken... AGAIN
Date: Wed, 1 Dec 2010 22:25:40 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc4+; KDE/4.4.4; x86_64; ; )
Cc: Hugh Dickins <hughd@google.com>, Ondrej Zary <linux@rainbow-software.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@in.ibm.com>
References: <201011171139.33398.linux@rainbow-software.org> <201012010138.53575.rjw@sisk.pl> <20101201095349.c1f3ac46.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20101201095349.c1f3ac46.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012012225.40329.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 01, 2010, KAMEZAWA Hiroyuki wrote:
> On Wed, 1 Dec 2010 01:38:53 +0100
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Wednesday, December 01, 2010, Rafael J. Wysocki wrote:
> > > On Tuesday, November 30, 2010, Hugh Dickins wrote:
> > > > On Sat, 27 Nov 2010, Rafael J. Wysocki wrote:
> > > > > On Saturday, November 27, 2010, Ondrej Zary wrote:
> > ...
> > > > 
> > > > Trivial point, I suppose, but it bothers me that PM is accumulating
> > > > wrappers around wrappers around gfp_allowed_mask.  Looks like
> > > > clear_gfp_allowed_mask and set_gfp_allowed_mask (oddly asymmetrical)
> > > > were not really what we need.  How about scrapping them, and putting
> > > > pm_restrict_gfp_mask() and pm_restore_gfp_mask() into page_alloc.c?
> > > 
> > > Sure, that sounds like a good idea indeed.
> > 
> > Below is an updated patch in which I tried to address your comments.
> > 
> > I didn't find it very useful to couple pm_restore_gfp_mask() with the thawing
> > of tasks, but nevertheless I think all of the spots where it's needed are
> > covered now.
> > 
> > The patch has only been compile-tested for now, so caveat emptor.
> > 
> 
> Hmm, can't we have some error check as 
> 
> > +static gfp_t saved_gfp_mask;
> 
> atomic_t gfp_mask_save_mode_counter;
> 
> > +
> > +void pm_restore_gfp_mask(void)
> >  {
> >  	WARN_ON(!mutex_is_locked(&pm_mutex));
> > -	gfp_allowed_mask = mask;
> 
> 	if (atomic_dec_return(&gfp_mask_save_mode_counter))
> 		WARN_ONCE()
> 
> > +	if (saved_gfp_mask) {
> > +		gfp_allowed_mask = saved_gfp_mask;
> > +		saved_gfp_mask = 0;
> > +	}
> >  }
> 
> > +void pm_restrict_gfp_mask(void)
> >  {
> > -	gfp_t ret = gfp_allowed_mask;
> > -
> >  	WARN_ON(!mutex_is_locked(&pm_mutex));
> > -	gfp_allowed_mask &= ~mask;
> > -	return ret;
> > +	saved_gfp_mask = gfp_allowed_mask;
> > +	gfp_allowed_mask &= ~GFP_IOFS;
> 
> 	if (atomic_inc_return(&gfp_mask_save_mode_counter) > 1)
> 		WARN_ONCE()
> 
> or some ?

What exactly would that be useful for?

Rafael
