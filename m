Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186Ab1JPThv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 15:37:51 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51792 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902Ab1JPThu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 15:37:50 -0400
Message-ID: <4E9B328A.3030508@gmail.com>
Date: Sun, 16 Oct 2011 21:37:46 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
CC: Jiri Slaby <jslaby@suse.cz>, gregkh@suse.de, linux-kernel@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@us.ibm.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, hpa@zytor.com
Subject: Re: [PATCH 4/4] TTY: call tty_driver_lookup_tty unconditionally
References: <4E8C6836.1090601@suse.cz> <1318411965-23917-1-git-send-email-jslaby@suse.cz> <1318411965-23917-4-git-send-email-jslaby@suse.cz> <4E95FFCA.2090604@gmail.com> <20111016192057.GB14883@us.ibm.com>
In-Reply-To: <20111016192057.GB14883@us.ibm.com>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing Alan's address. Somehow I put there a RH (defunct) one.

On 10/16/2011 09:20 PM, Sukadev Bhattiprolu wrote:
> Jiri Slaby [jirislaby@gmail.com] wrote:
> | On 10/12/2011 11:32 AM, Jiri Slaby wrote:
> | > Commit 4a2b5fddd5 (Move tty lookup/reopen to caller) made the call to
> | > tty_driver_lookup_tty conditional in tty_open. It doesn't look like it
> | > was an intention. Or if it was, it was not documented in the changelog
> | > and the code now looks weird. For example there would be no need to
> | > remember the tty driver and tty index. Further the condition depends
> | > on a tty which we drop a reference of already.
> | > 
> | > If I'm looking correctly, this should not matter thanks to the locking
> | > currently done there. Thus, tty_driver->ttys[idx] cannot change under
> | > our hands. But anyway, it makes sense to change that to the old
> | > behaviour.
> | 
> | Well, this doesn't work for ptys. devpts lookup code expects an inode to
> | be one of devpts filesystem (/dev/pts/*), not something on tmpfs like
> | /dev/tty. So it looks like the change was intentional, but very
> | undocumented and leaving there some unused code.
> 
> Yes this was intentional - even though the tty_driver_lookup() was
> unconditional in tty_init_dev() I believe it did not do anything useful
> when called from ptmx_open(). ptmx_open() would be setting up a new pty and
> the lookup would not find a tty.

Yes, I'm not arguing against moving the code from tty_init_dev to
tty_open change. That is perfectly OK.

What I mind is that now we do:
=====
  tty = get_current_tty();
  if (!tty)
        return -ENXIO;
  driver = tty_driver_kref_get(tty->driver); /* ZZZ */
  index = tty->index;                        /* ZZZ */
...
  tty_kref_put(tty); /* XXX */
  goto got_driver;
...
got_driver:
  if (!tty) {   /* YYY */
  }
=====

But at the point of YYY, the tty may be invalid due to reference drop at
XXX. I *hope* it is not the case thanks to the current locking there
(namely BTM) but I'm really *not sure*. And if it is the case, there
should definitely be a note. (Or better the reference should be held
while necessary.)

> Would the following change to tty_open() help ?

No, it doesn't matter now. I would prefer a description of the change to
be a part of the commit log. And it missed such a notice.

> I am not sure about the unused code you refer to above. Can you please
> clarify ?

It is index and driver assigned in the branch above (see ZZZ). When we
have a live tty (which I'm not sure we have -- see above), it is
guaranteed that the driver is reff'ed. And we need neither driver nor
index when we have such a tty.

thanks,
-- 
js
