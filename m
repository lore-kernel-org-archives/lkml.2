Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760679Ab0HLWUD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 18:20:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36486 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752553Ab0HLWUC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 18:20:02 -0400
MIME-Version: 1.0
In-Reply-To: <20100812215246.GK31363@ZenIV.linux.org.uk>
References: <201008122200.05598.thomas@m3y3r.de> <AANLkTikZ4wA4jJ0AnWMXYmgWVBShRW=Yu67J0QvebRx0@mail.gmail.com>
 <s5hpqxntw64.wl%tiwai@suse.de> <4C646110.1040104@gmail.com>
 <s5hbp97ttt5.wl%tiwai@suse.de> <AANLkTi=s-KFuUnmNaDN6OYaiwZiaBLbYB5MCwde7tvvw@mail.gmail.com>
 <20100812215246.GK31363@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 12 Aug 2010 15:19:31 -0700
Message-ID: <AANLkTimesXb7Ut3aO71HjmNjV_Q53p0Jr5j4kLTwsRGh@mail.gmail.com>
Subject: Re: 2.6.36: Sound stop working
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Takashi Iwai <tiwai@suse.de>, Eric Paris <eparis@redhat.com>,
        Jiri Slaby <jirislaby@gmail.com>, Pekka Enberg <penberg@kernel.org>,
        Thomas Meyer <thomas@m3y3r.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 2:52 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Thu, Aug 12, 2010 at 02:41:51PM -0700, Linus Torvalds wrote:
>
>> Yeah. The f_count stuff is disgusting. This revert patch makes things
>> work for me again. And I suspect it's the right thing to do
>> regardless. I reacted to that ugly __fput() hackery when I pulled the
>> fanotify tree, but I let it slide. I clearly should have let my taste
>> guide me more.
>>
>> fsnotify playing games with fput/fget is almost certainly totally wrong.
>>
>> Al, what was the problem that caused you to think that we want to have
>> a 'struct file' here? Is it just the fact that some of those fsnotify
>> things use that 'path' structure that is embedded in the parent? But
>> isn't the simplest fix for that to just _copy_ the "struct path"
>> rather than pass the "struct file" around?
>
> I agree that what this crap is doing to f_count is blatantly wrong,
> of course - no arguments here.  I *do* have a reason to want struct
> file, but not that way, TYVM.
>
> Basically, dentry_open() is not even promised to work on arbitrary
> dentry.  Thanks to !@#!@#!@#!@# intents crap we are not promised
> that the damn thing won't need setup by ->lookup/->d_revalidate.
> We _are_ more or less promised that it'll work while the file is
> opened (provided that /proc/*/fd/* is openable), but that's it.

Hmm. We do basically dentry_open() these days with the whole
path_init() of a dfd. Yes, we have the 'struct file', but the only
thing we take from there is the dentry.

So why not just say that 'dentry_open()' is exactly that path_init()
setup, and then look up an empty path. Allow a non-directory, and
leave it to the filesystems to then say "I can't do that at all" if
they really want to. fanotify seems to be perfectly happy with the
lookup failing.

So I'm not convinced this is really a fanotify problem, as much as a
VFS layer thing.

> It's not an API that can be made to work on an arbitrary dentries.  If
> caller knows what it's dealing with, it's OK, but not in general.  And
> no, I'm not fond of that situation, to put it mildly.

So I think it's probably doable for arbitrary dentries too, although
maybe we need to have a special "reopen()" function. I suspect few
filesystems will care, and if you can fail it, the ones that do care
deeply are home free too. No?

> I'll see what can be done to fix that mess more or less right way...

.. but I assume you don't wan tto keep those "struct file" games in
fanotify regardless, right? So we can fix the sound issue by the
revert I sent out, no?

                    Linus
