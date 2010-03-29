Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab0C2VSZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 17:18:25 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:64916 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768Ab0C2VSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 17:18:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [GIT, RFC] Killing the Big Kernel Lock
Date: Mon, 29 Mar 2010 23:18:09 +0200
User-Agent: KMail/1.13.1 (Linux/2.6.33-00063-g0795fff; KDE/4.4.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
       Thomas Gleixner <tglx@linutronix.de>, jblunck@suse.de,
       Alan Cox <alan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
References: <201003242240.54907.arnd@arndb.de> <201003291304.24629.arnd@arndb.de> <20100329175935.GD5101@nowhere>
In-Reply-To: <20100329175935.GD5101@nowhere>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003292318.10212.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+XsMCERTghpWUs3A1h8dHwo2vNQvUekIH4QMF
 7YI7D20YW4xhjt+73QNteHiNWovVBjjFAG0pNPScAuCPQzdO3P
 u5ol/81gUcdHsVHH15dTQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 March 2010 19:59:39 Frederic Weisbecker wrote:
> On Mon, Mar 29, 2010 at 12:04:24PM +0100, Arnd Bergmann wrote:
> > On Monday 29 March 2010, Frederic Weisbecker wrote:
> > > On Mon, Mar 29, 2010 at 01:18:48AM +0200, Frederic Weisbecker wrote:
> > > > @@ -1943,7 +1949,7 @@ static ssize_t proc_fdinfo_read(struct file *file, char __user *buf,
> > > >  }
> > > >  
> > > >  static const struct file_operations proc_fdinfo_file_operations = {
> > > > -     .open           = nonseekable_open,
> > > > +     .llseek         = generic_file_llseek,
> > > >       .read           = proc_fdinfo_read,
> > > >  };
> > > >  
> > > > 
> > > > Replacing default_llseek() by generic_file_llseek() as you
> > > > did for most of the other parts is fine.
> > > > 
> > > > But the above changes the semantics as it makes it seekable.
> > > > Why not just keeping it as is? It just ends up in no_llseek().
> > 
> > The default is default_llseek, which uses the BKL and cannot be
> > used if procfs is builtin and the BKL is a module.
> 
> Yeah, but you removed the nonseekable_open and made generic_file_llseek
> in llseek on this one.
> This makes it seekable while it wasn't, changing its ABI.
> It wasn't taking the bkl before that as it was calling
> no_llseek().

Ah, I see what you mean. That change was certainly not intentional
an should be reverted. Thanks for pointing this out.

> > The BKL in procfs is only for proc files that have registered
> > their own .ioctl instead of .unlocked_ioctl method. Converting
> > every file_operations instance to provide an unlocked_ioctl
> > (as one of the other patches does) makes sure that this path
> > is never taken. BTW, there are less than a handful of procfs files
> > that provide an ioctl operation, and those probably should never
> > have been merged.
> 
> 
> There are three of them. I'm going to make them .unlocked_ioctl
> and push the bkl inside, and warn on further uses of .ioctl,
> without applying the bkl there anymore.
> 
> That plus your bkl removal in proc seek, should totally remove the
> bkl from procfs.

Ok

	Arnd
