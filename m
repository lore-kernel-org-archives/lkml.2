Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760905Ab0HLVxe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 17:53:34 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39828 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649Ab0HLVxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 17:53:31 -0400
Date: Thu, 12 Aug 2010 22:52:46 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Takashi Iwai <tiwai@suse.de>, Eric Paris <eparis@redhat.com>,
        Jiri Slaby <jirislaby@gmail.com>, Pekka Enberg <penberg@kernel.org>,
        Thomas Meyer <thomas@m3y3r.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.36: Sound stop working
Message-ID: <20100812215246.GK31363@ZenIV.linux.org.uk>
References: <201008122200.05598.thomas@m3y3r.de>
 <AANLkTikZ4wA4jJ0AnWMXYmgWVBShRW=Yu67J0QvebRx0@mail.gmail.com>
 <s5hpqxntw64.wl%tiwai@suse.de>
 <4C646110.1040104@gmail.com>
 <s5hbp97ttt5.wl%tiwai@suse.de>
 <AANLkTi=s-KFuUnmNaDN6OYaiwZiaBLbYB5MCwde7tvvw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=s-KFuUnmNaDN6OYaiwZiaBLbYB5MCwde7tvvw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 02:41:51PM -0700, Linus Torvalds wrote:

> Yeah. The f_count stuff is disgusting. This revert patch makes things
> work for me again. And I suspect it's the right thing to do
> regardless. I reacted to that ugly __fput() hackery when I pulled the
> fanotify tree, but I let it slide. I clearly should have let my taste
> guide me more.
> 
> fsnotify playing games with fput/fget is almost certainly totally wrong.
> 
> Al, what was the problem that caused you to think that we want to have
> a 'struct file' here? Is it just the fact that some of those fsnotify
> things use that 'path' structure that is embedded in the parent? But
> isn't the simplest fix for that to just _copy_ the "struct path"
> rather than pass the "struct file" around?

I agree that what this crap is doing to f_count is blatantly wrong,
of course - no arguments here.  I *do* have a reason to want struct
file, but not that way, TYVM.

Basically, dentry_open() is not even promised to work on arbitrary
dentry.  Thanks to !@#!@#!@#!@# intents crap we are not promised
that the damn thing won't need setup by ->lookup/->d_revalidate.
We _are_ more or less promised that it'll work while the file is
opened (provided that /proc/*/fd/* is openable), but that's it.

It's not an API that can be made to work on an arbitrary dentries.  If
caller knows what it's dealing with, it's OK, but not in general.  And
no, I'm not fond of that situation, to put it mildly.

I'll see what can be done to fix that mess more or less right way...
