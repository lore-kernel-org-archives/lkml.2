Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592Ab0JWLvb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 07:51:31 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35945 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218Ab0JWLva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 07:51:30 -0400
Date: Sat, 23 Oct 2010 12:51:29 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        "Dr. Werner Fink" <werner@suse.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 28/49] tty: Add a new file /proc/tty/consoles
Message-ID: <20101023115129.GM19804@ZenIV.linux.org.uk>
References: <20101022175112.GC13489@kroah.com>
 <1287771688-14805-28-git-send-email-gregkh@suse.de>
 <4CC2C9A8.1040003@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC2C9A8.1040003@suse.cz>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 23, 2010 at 01:40:24PM +0200, Jiri Slaby wrote:
> On 10/22/2010 08:21 PM, Greg Kroah-Hartman wrote:
> > +/*
> > + * Used for open /proc/tty/consoles. Before this detect
> > + * the device ID of file descriptor 0 of the current
> > + * reading task if a character device...
> > + */
> > +static int tty_consoles_open(struct inode *inode, struct file *file)
> > +{
> > +	struct files_struct *curfiles;
> > +
> > +	current_dev = 0;
> > +	curfiles = get_files_struct(current);
> > +	if (curfiles) {
> > +		const struct file *curfp;
> > +		spin_lock(&curfiles->file_lock);
> > +		curfp = fcheck_files(curfiles, 0);
> > +		if (curfp && curfp->private_data) {
> > +			const struct inode *inode;
> > +			dget(curfp->f_dentry);
> > +			inode = curfp->f_dentry->d_inode;
> > +			if (S_ISCHR(inode->i_mode)) {
> > +				struct tty_struct *tty;
> > +				tty = (struct tty_struct *)curfp->private_data;
> > +				if (tty && tty->magic == TTY_MAGIC) {
> 
> Ah, I've just understood what this code does. It seems, that the 'tty'
> at this point may be already freed (e.g. people don't set private_data
> to NULL). Please explain in the code why it can't...

Please, don't.  Even leaving aside the fact that it's mind-bogglingly
broken (->private_data can be _ANYTHING_, including arbitrary number cast
to pointer), you really shouldn't screw your way through the descriptor
table in the first place.

Strongly NACKed.
