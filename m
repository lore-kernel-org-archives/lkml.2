Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab0C2R7m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 13:59:42 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49644 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124Ab0C2R7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 13:59:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TvouziqcnpUxDK98w0972qcUvow6fweKl+eBA3lvJvp5C5GYqruH4gvjzuRBlAS6bQ
         ovkEmKdgXBNj2+nNnGyAcM2W4L2JwJEU6Uw9Fo/pNwily7HRZLOzn4lJhtxTqodV8JVQ
         N6LUJSOrn9zj3OD1ej4/zB3Hjn+2qedOqb9y4=
Date: Mon, 29 Mar 2010 19:59:39 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
       Thomas Gleixner <tglx@linutronix.de>, jblunck@suse.de,
       Alan Cox <alan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT, RFC] Killing the Big Kernel Lock
Message-ID: <20100329175935.GD5101@nowhere>
References: <201003242240.54907.arnd@arndb.de> <20100328231847.GH5116@nowhere> <20100328233847.GJ5116@nowhere> <201003291304.24629.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003291304.24629.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 12:04:24PM +0100, Arnd Bergmann wrote:
> On Monday 29 March 2010, Frederic Weisbecker wrote:
> > On Mon, Mar 29, 2010 at 01:18:48AM +0200, Frederic Weisbecker wrote:
> > > @@ -1943,7 +1949,7 @@ static ssize_t proc_fdinfo_read(struct file *file, char __user *buf,
> > >  }
> > >  
> > >  static const struct file_operations proc_fdinfo_file_operations = {
> > > -     .open           = nonseekable_open,
> > > +     .llseek         = generic_file_llseek,
> > >       .read           = proc_fdinfo_read,
> > >  };
> > >  
> > > 
> > > Replacing default_llseek() by generic_file_llseek() as you
> > > did for most of the other parts is fine.
> > > 
> > > But the above changes the semantics as it makes it seekable.
> > > Why not just keeping it as is? It just ends up in no_llseek().
> 
> The default is default_llseek, which uses the BKL and cannot be
> used if procfs is builtin and the BKL is a module.



Yeah, but you removed the nonseekable_open and made generic_file_llseek
in llseek on this one.
This makes it seekable while it wasn't, changing its ABI.
It wasn't taking the bkl before that as it was calling
no_llseek().

May be its non seekable property is irrelevant, I don't know,
but if this behaviour must be changed, it should be in a
separate patch as that dosn't deal with the bkl.

  
> > There is also the ioctl part that takes the bkl in procfs.
> > I'll just check nothing weird happens there wrt file pos.
> > We probably first need to pushdown the bkl in the procfs
> > ioctl handlers.
> 
> The BKL in procfs is only for proc files that have registered
> their own .ioctl instead of .unlocked_ioctl method. Converting
> every file_operations instance to provide an unlocked_ioctl
> (as one of the other patches does) makes sure that this path
> is never taken. BTW, there are less than a handful of procfs files
> that provide an ioctl operation, and those probably should never
> have been merged.


There are three of them. I'm going to make them .unlocked_ioctl
and push the bkl inside, and warn on further uses of .ioctl,
without applying the bkl there anymore.

That plus your bkl removal in proc seek, should totally remove the
bkl from procfs.

