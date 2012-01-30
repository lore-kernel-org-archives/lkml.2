Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335Ab2A3X6f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 18:58:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35349 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754156Ab2A3X6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 18:58:34 -0500
Date: Tue, 31 Jan 2012 00:58:28 +0100
From: Jan Kara <jack@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jan Kara <jack@suse.cz>, Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>,
        Nigel Cunningham <nigel@tuxonice.net>, Pavel Machek <pavel@ucw.cz>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC][PATCH] PM / Sleep: Freeze filesystems during system
 suspend/hibernation
Message-ID: <20120130235828.GG7827@quack.suse.cz>
References: <201201281445.49377.rjw@sisk.pl>
 <20120130200040.GB7827@quack.suse.cz>
 <201201302205.34159.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201201302205.34159.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 30-01-12 22:05:33, Rafael J. Wysocki wrote:
> On Monday, January 30, 2012, Jan Kara wrote:
> > On Sat 28-01-12 14:45:49, Rafael J. Wysocki wrote:
> > > +/**
> > > + *	freeze_supers - call freeze_super() for all superblocks
> > > + */
> > > +int freeze_supers(void)
> > > +{
> > > +	struct super_block *sb, *p = NULL;
> > > +	int error = 0;
> > > +
> > > +	spin_lock(&sb_lock);
> > > +	/*
> > > +	 * Freeze in reverse order so filesystems depending on others are
> > > +	 * frozen in the right order (eg. loopback on ext3).
> > > +	 */
> >   Ho, hum, are you sure the order in super_blocks list is the one you need?
> > Maybe it is but I'm not sure you are guaranteed it is.
> 
> Well, is there any way I can get the right order?
  None I'm aware of :( I think your reverse order scanning is the best you
can do now as we don't track the "freeze dependency" in any way. I was just
warning that noone really guarantees this is the right order. So we should
probably at least document somewhere that super_blocks list order matters
for freeze_supers().

> > > +	list_for_each_entry_reverse(sb, &super_blocks, s_list) {
> > > +		if (list_empty(&sb->s_instances))
> > > +			continue;
> > > +		sb->s_count++;
> > > +		spin_unlock(&sb_lock);
> > > +
> > > +		if (sb->s_root && sb->s_frozen != SB_FREEZE_TRANS
> > > +		    && !(sb->s_flags & MS_RDONLY)) {
> > > +			error = freeze_super(sb);
> > > +			if (!error)
> > > +				sb->s_flags |= MS_FROZEN;
> > > +		}
> > > +
> > > +		spin_lock(&sb_lock);
> > > +		if (error)
> > > +			break;
> > > +		if (p)
> > > +			__put_super(p);
> > > +		p = sb;
> > > +	}
> > > +	if (p)
> > > +		__put_super(p);
> > > +	spin_unlock(&sb_lock);
> > > +
> > > +	if (error)
> > > +		thaw_supers();
> > > +
> > > +	return error;
> > > +}
> > > +
> > > +
> > > +/**
> > >   *	get_super - get the superblock of a device
> > >   *	@bdev: device to get the superblock for
> > >   *	

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
