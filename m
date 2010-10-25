Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab0JYHva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 03:51:30 -0400
Received: from cantor.suse.de ([195.135.220.2]:37211 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154Ab0JYHv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 03:51:29 -0400
Date: Mon, 25 Oct 2010 09:51:25 +0200
From: "Dr. Werner Fink" <werner@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        "Dr. Werner Fink" <werner@suse.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 28/49] tty: Add a new file /proc/tty/consoles
Message-ID: <20101025075125.GA29179@boole.suse.de>
Mail-Followup-To: Jiri Slaby <jslaby@suse.cz>,
	Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
	"Dr. Werner Fink" <werner@suse.de>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20101022175112.GC13489@kroah.com>
 <1287771688-14805-28-git-send-email-gregkh@suse.de>
 <4CC2C9A8.1040003@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4CC2C9A8.1040003@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
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
> 
> Maybe I wouldn't bother with marking the "current" console by star at
> all as it seems not to pay off.

This is the main reason for what I've done this patch:
To see on which console line the reading process is
located. Please do not skip this part as this is
currently the only way to detect the real console below
/dev/console ... it could be used in user space: e.g. in
plymouth or bootlogd (to deterime the main console) or
sulogin (to be able to provide a prompt on all console
lines).

> 
> > +					tty = tty_pair_get_tty(tty);
> > +					current_dev = tty_devnum(tty);
> > +				}
> > +			}
> > +			dput(curfp->f_dentry);
> > +		}
> > +		spin_unlock(&curfiles->file_lock);
> > +		put_files_struct(curfiles);
> > +	}
> > +	return seq_open(file, &tty_consoles_op);
> > +}

Werner

-- 
  "Having a smoking section in a restaurant is like having
          a peeing section in a swimming pool." -- Edward Burr
