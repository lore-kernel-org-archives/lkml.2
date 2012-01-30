Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495Ab2A3W4t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 17:56:49 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:57857 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754005Ab2A3W4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 17:56:48 -0500
Date: Mon, 30 Jan 2012 22:56:38 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jiri Slaby <jslaby@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        systemd-devel@lists.freedesktop.org
Subject: Re: sysfs regression: wrong link counts
Message-ID: <20120130225638.GO23916@ZenIV.linux.org.uk>
References: <4F27120A.4040106@suse.cz>
 <20120130220611.GA26655@kroah.com>
 <20120130221059.26ab5edf@pyramind.ukuu.org.uk>
 <20120130222717.GA6393@kroah.com>
 <20120130224350.GN23916@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120130224350.GN23916@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 10:43:50PM +0000, Al Viro wrote:
> On Mon, Jan 30, 2012 at 02:27:17PM -0800, Greg KH wrote:
> > On Mon, Jan 30, 2012 at 10:10:59PM +0000, Alan Cox wrote:
> > > > Isn't there some other "proper" way of doing this in userspace, or is
> > > > this really the correct way?
> > > 
> > > You can look at the S_IFMT bits and stuff however link count indicating
> > > number of subdirectories is a standard Unix thing and used by many quite
> > > mundane tools as an optimisation.
> > 
> > Ah, yeah, that is easier.
> > 
> > Eric, care to fix this or want me to revert it?
> 
> Fix _what_?  Userland shite quoted upthread?  Because that's where the bug
> is - the mundane tools mentioned by Alan treat 1 in st_nlink as "no
> information about the number of subdirectories".  And shite might be too
> mild a term for the little gem in question, really...

To repeat this piece of bogosity for those who might've missed it:

/* returns !0 if sysfs filesystem was found, 0 otherwise */
int sensors_init_sysfs(void)
{
        struct stat statbuf;

        snprintf(sensors_sysfs_mount, NAME_MAX, "%s", "/sys");
        if (stat(sensors_sysfs_mount, &statbuf) < 0
         || statbuf.st_nlink <= 2)      /* Empty directory */
                return 0;

        return 1;
}

which is completely bogus - contrary to what it says in comments, it does
*not* check anything about sysfs (or directories being empty).  Checking
that sysfs is mounted on /sys could be done by statfs(2) and checking
->f_type, or, considering what the code in lib/sysfs.c is doing, just
checking that /sys/class is readable and failing otherwise.

Sigh...
