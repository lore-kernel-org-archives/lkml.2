Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262Ab0C1VfL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 17:35:11 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:62471 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755235Ab0C1VfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 17:35:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [GIT, RFC] Killing the Big Kernel Lock
Date: Sun, 28 Mar 2010 22:34:54 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Jiri Kosina <jkosina@suse.cz>,
       linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
       Thomas Gleixner <tglx@linutronix.de>, jblunck@suse.de,
       Alan Cox <alan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       John Kacur <jkacur@redhat.com>
References: <201003242240.54907.arnd@arndb.de> <201003282205.50886.arnd@arndb.de> <20100328201516.GE5116@nowhere>
In-Reply-To: <20100328201516.GE5116@nowhere>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003282334.55253.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+cGB9N6z6HrBFI/l1z4Ul0LAG7Kb0eJQpFRLY
 gn8VZpJA5mdoNIELm857i6r/qDp+XBl7rq/9HOz95fSzjQA/5Z
 toYSp9L0QvnBj5jgTAhBA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 28 March 2010, Frederic Weisbecker wrote:
> On Sun, Mar 28, 2010 at 09:05:50PM +0100, Arnd Bergmann wrote:
> > > General thoughts:
> > > 
> > > ".llseek = NULL," so far meant "do the Right Thing on lseek() and
> > > friends, as far as the fs core can tell".  Shouldn't we keep it that
> > > way?  It's as close to other ".method = NULL," as it can get, which
> > > either mean "silently skip this method if it doesn't matter" (e.g.
> > > .flush) or "fail attempts to use this method with a fitting errno" (e.g.
> > > .write).
> > 
> > My series changes the default from 'default_llseek' to 'generic_file_llseek',
> > which is almost identical, except for taking the inode mutex instead of the
> > BKL. 
> 
> 
> What if another file operation changes the file pointer while holding the bkl?
> You're not protected anymore in this case.
> 

Exactly, that's why I changed all the drivers to set default_llseek explicitly.
Even this is very likely not needed in more than a handful of drivers (if any),
for a number of reasons:

- sys_read/sys_write *never* hold any locks while calling file_pos_write(),
  which is the only place they get updated for regular files.
- concurrent llseek plus other file operations on the same file descriptor
  usually already have an undefined outcome.
- when I started inspecting drivers that look at file->f_pos themselves (not
  the read/write operation arguments), I found that practically all of them
  are doing this in a totally broken way!
- The only think we'd probably ever want to lock against in llseek
  is readdir, which is not used in any drivers, but only in file systems.

	Arnd
