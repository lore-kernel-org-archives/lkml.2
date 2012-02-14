Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759773Ab2BNTJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 14:09:19 -0500
Received: from fieldses.org ([174.143.236.118]:44677 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757028Ab2BNTJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 14:09:18 -0500
Date: Tue, 14 Feb 2012 14:09:06 -0500
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dave@gnu.org, Matthew Wilcox <matthew@wil.cx>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] locks: export device name
Message-ID: <20120214190906.GA5115@fieldses.org>
References: <1328907967.3138.1.camel@offbook>
 <20120213163425.dd9adfde.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120213163425.dd9adfde.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 13, 2012 at 04:34:25PM -0800, Andrew Morton wrote:
> On Fri, 10 Feb 2012 22:06:07 +0100
> Davidlohr Bueso <dave@gnu.org> wrote:
> 
> > From: Davidlohr Bueso <dave@gnu.org>
> > 
> > The lslk(8) program has not been maintained for over a decade and has recently been rewritten as lslocks(8).
> > It will be available for the next 2.22 release, in a couple of months. This is a good opportunity to delete
> > that nasty WE_CAN_BREAK_LSLK_NOW and start exporting the device name instead of the maj:min numbers.
> > 
> > For backward compatibility the new version can be in charge of checking older kernel versions and parsing the old
> > output if necessary.
> > 
> > ...
> >
> > --- a/fs/locks.c
> > +++ b/fs/locks.c
> > @@ -2199,15 +2199,8 @@ static void lock_get_status(struct seq_file *f, struct file_lock *fl,
> >  			       : (fl->fl_type & F_WRLCK) ? "WRITE" : "READ ");
> >  	}
> >  	if (inode) {
> > -#ifdef WE_CAN_BREAK_LSLK_NOW
> >  		seq_printf(f, "%d %s:%ld ", fl_pid,
> >  				inode->i_sb->s_id, inode->i_ino);
> > -#else
> > -		/* userspace relies on this representation of dev_t ;-( */
> > -		seq_printf(f, "%d %02x:%02x:%ld ", fl_pid,
> > -				MAJOR(inode->i_sb->s_dev),
> > -				MINOR(inode->i_sb->s_dev), inode->i_ino);
> > -#endif
> >  	} else {
> >  		seq_printf(f, "%d <none>:0 ", fl_pid);
> >  	}
> 
> I don't get it.  This is an immediate and non-back-compatible change to
> the format of /proc/locks.  The only way this can avoid breaking things
> is if there are no programs or scripts in use by anyone which use
> this field.  What am I missing here?

I'm a little surprised anything parses that file.

But, yes, looks like I can "yum install" lslk on Fedora 16, as an
example.  Can't get it to do anything useful, though.  Does it actually
work on any recent distro?

Perhaps safest would be to replace /proc/locks by another interface and
deprecate this one.

--b.
