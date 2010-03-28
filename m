Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab0C1XYw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 19:24:52 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:52273 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755336Ab0C1XYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 19:24:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YxYWZCMjeI5Xan7niL1CJq/E18F0Iu+NYwPNT+l6RywuIc6jNdvN6BSSBBPXG6QpCb
         CNzcxNyjiByIrISTVoByM4Sh+e05G9KNX2Ut7FhIOYDz/kc1lv5g9GSuxDt4grU0Qdf6
         u9eDg5bDNtbST4xbWstiFLbf/oLbhR0BM2wjY=
Date: Mon, 29 Mar 2010 01:24:53 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Jiri Kosina <jkosina@suse.cz>,
       linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
       Thomas Gleixner <tglx@linutronix.de>, jblunck@suse.de,
       Alan Cox <alan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       John Kacur <jkacur@redhat.com>
Subject: Re: [GIT, RFC] Killing the Big Kernel Lock
Message-ID: <20100328232451.GI5116@nowhere>
References: <201003242240.54907.arnd@arndb.de> <201003282205.50886.arnd@arndb.de> <20100328201516.GE5116@nowhere> <201003282334.55253.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003282334.55253.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 28, 2010 at 10:34:54PM +0100, Arnd Bergmann wrote:
> On Sunday 28 March 2010, Frederic Weisbecker wrote:
> > On Sun, Mar 28, 2010 at 09:05:50PM +0100, Arnd Bergmann wrote:
> > > > General thoughts:
> > > > 
> > > > ".llseek = NULL," so far meant "do the Right Thing on lseek() and
> > > > friends, as far as the fs core can tell".  Shouldn't we keep it that
> > > > way?  It's as close to other ".method = NULL," as it can get, which
> > > > either mean "silently skip this method if it doesn't matter" (e.g.
> > > > .flush) or "fail attempts to use this method with a fitting errno" (e.g.
> > > > .write).
> > > 
> > > My series changes the default from 'default_llseek' to 'generic_file_llseek',
> > > which is almost identical, except for taking the inode mutex instead of the
> > > BKL. 
> > 
> > 
> > What if another file operation changes the file pointer while holding the bkl?
> > You're not protected anymore in this case.
> > 
> 
> Exactly, that's why I changed all the drivers to set default_llseek explicitly.


Ah ok.


> Even this is very likely not needed in more than a handful of drivers (if any),
> for a number of reasons:
> 
> - sys_read/sys_write *never* hold any locks while calling file_pos_write(),
>   which is the only place they get updated for regular files.


Yeah sure. But the pushdown (or step by step replacement
with generic_file_llseek) is still necessary to ensure every
places are fine.



> - concurrent llseek plus other file operations on the same file descriptor
>   usually already have an undefined outcome.


Yeah.



> - when I started inspecting drivers that look at file->f_pos themselves (not
>   the read/write operation arguments), I found that practically all of them
>   are doing this in a totally broken way!


Hehe :)



> - The only think we'd probably ever want to lock against in llseek
>   is readdir, which is not used in any drivers, but only in file systems.


Right.

