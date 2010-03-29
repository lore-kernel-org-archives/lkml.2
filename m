Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434Ab0C2LEb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 07:04:31 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:61703 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755299Ab0C2LEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 07:04:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [GIT, RFC] Killing the Big Kernel Lock
Date: Mon, 29 Mar 2010 12:04:24 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
       Thomas Gleixner <tglx@linutronix.de>, jblunck@suse.de,
       Alan Cox <alan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
References: <201003242240.54907.arnd@arndb.de> <20100328231847.GH5116@nowhere> <20100328233847.GJ5116@nowhere>
In-Reply-To: <20100328233847.GJ5116@nowhere>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003291304.24629.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18acnnLQRYBFZVtyfx73pKITovyfuafBsF7nVH
 sYA5i7s4ciru5nq3JmVevFSyeA6nYy4E+ngVv+Bxq1ah/nBgnW
 ZjyweXPK+izIXZMNU63Bw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 March 2010, Frederic Weisbecker wrote:
> On Mon, Mar 29, 2010 at 01:18:48AM +0200, Frederic Weisbecker wrote:
> > @@ -1943,7 +1949,7 @@ static ssize_t proc_fdinfo_read(struct file *file, char __user *buf,
> >  }
> >  
> >  static const struct file_operations proc_fdinfo_file_operations = {
> > -     .open           = nonseekable_open,
> > +     .llseek         = generic_file_llseek,
> >       .read           = proc_fdinfo_read,
> >  };
> >  
> > 
> > Replacing default_llseek() by generic_file_llseek() as you
> > did for most of the other parts is fine.
> > 
> > But the above changes the semantics as it makes it seekable.
> > Why not just keeping it as is? It just ends up in no_llseek().

The default is default_llseek, which uses the BKL and cannot be
used if procfs is builtin and the BKL is a module.
 
> There is also the ioctl part that takes the bkl in procfs.
> I'll just check nothing weird happens there wrt file pos.
> We probably first need to pushdown the bkl in the procfs
> ioctl handlers.

The BKL in procfs is only for proc files that have registered
their own .ioctl instead of .unlocked_ioctl method. Converting
every file_operations instance to provide an unlocked_ioctl
(as one of the other patches does) makes sure that this path
is never taken. BTW, there are less than a handful of procfs files
that provide an ioctl operation, and those probably should never
have been merged.

	Arnd
