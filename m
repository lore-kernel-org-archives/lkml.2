Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab0C2OnO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 10:43:14 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:57132 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab0C2OnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 10:43:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [GIT, RFC] Killing the Big Kernel Lock II
Date: Mon, 29 Mar 2010 15:43:00 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Jiri Kosina <jkosina@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
       Thomas Gleixner <tglx@linutronix.de>, jblunck@suse.de,
       Alan Cox <alan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       gregkh@suse.de
References: <201003242240.54907.arnd@arndb.de> <201003291348.37997.arnd@arndb.de> <87fx3jqpi3.fsf@basil.nowhere.org>
In-Reply-To: <87fx3jqpi3.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003291643.01214.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/Ne043Raz9hW15LlUGso5uh7XWKU4r6uvau40
 P1jIVVTYjwZ3HUWH2kV6//eC9g33tR6A8VVH1RXK0pGR1mlZYv
 rfm3lkfpX+YYHjaO5d1dg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 March 2010, Andi Kleen wrote:
> Arnd Bergmann <arnd@arndb.de> writes:
> 
> >> - The seek function in uhci-debug.c probably is still racy.
> >
> > That function could be removed in favor of using generic_file_ioctl
> > and setting i_size to up->size.
> 
> Does that lock against read in libfs? 

No.

> > Also, the race is only between concurrent calls of llseek on
> > the same file descriptor, which is undefined anyway.
> > The current code also doesn't protect you against partial updates
> > of f_pos during ->read() on 32 bit systems (nothing ever does),
> 
> That is not what I meant.
> 
> > and it even fails to protect against the concurrent llseek race
> > because the assignment is done outside of the f_pos update.
> 
> I wasn't sure it would protect against parallel reads.
> 
> Does it?

There is no way for any driver or file system right now to protect
against that, nor has there been for a long time[1]. The sys_read and
sys_write functions use file_pos_write() to update the file->f_pos
without taking any lock, and they pass a local variable into the
*ppos argument of the ->read/->write file operations, which means
that the file operation itself cannot add locking to the update
either.

We never do in-place updates of file->f_pos, but on architectures
where a 64 bit load can see incorrect data from a 64 bit store,
any concurrent read/write/llseek combinations may cause problems,
except for two concurrent lseek. Also, llseek is usually serialized
with readdir/getdents for file systems.

> > The patch looks correct, but I probably wouldn't bother with the rename,
> > and simply drop the BKL in the caller.
> 
> I think a rename is better, I take compile errors over subtle
> breakage any day.

ok, fine with me.

	Arnd

[1] http://git.kernel.org/?p=linux/kernel/git/tglx/history.git;a=commitdiff;h=55f09ec0087c160533eab791607d92c9ce6222ae
was merged in linux-2.6.8, which opened this race. 
