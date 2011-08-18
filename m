Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab1HRVzX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 17:55:23 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44467 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab1HRVzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 17:55:19 -0400
Subject: Re: +
 prctl-add-pr_setget_child_reaper-to-allow-simple-process-supervision .patch
 added to -mm tree
From: Kay Sievers <kay.sievers@vrfy.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Lennart Poettering <mzxreary@0pointer.de>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-man@vger.kernel.org, roland@hack.frob.com
Date: Thu, 18 Aug 2011 23:55:15 +0200
In-Reply-To: <CA+55aFxGDbNOhNQJe_LpUMcJCGcW8qFFWzC9H0_KW26Xzb0cXw@mail.gmail.com>
References: <201108162011.p7GKBcY0023134@imap1.linux-foundation.org>
	 <20110817115543.GA8745@redhat.com>
	 <CAPXgP12rYf2HmmsJAuJw=nrtcjTRR1WzDhLNM47eKhKA1UTfJQ@mail.gmail.com>
	 <20110817134516.GA14136@redhat.com>
	 <20110818124353.GA2839@tango.0pointer.de>
	 <20110818142508.GA30959@redhat.com> <1313691091.1107.9.camel@mop>
	 <CA+55aFxGDbNOhNQJe_LpUMcJCGcW8qFFWzC9H0_KW26Xzb0cXw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.4 (3.1.4-1.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1313704516.15082.5.camel@mop>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 18, 2011 at 23:23, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Thu, Aug 18, 2011 at 11:11 AM, Kay Sievers <kay.sievers@vrfy.org> wrote:
>>
>> How about this? It:
>> - uses task->real_parent to walk up the chain of parents.
>
> If I read this right, it does that for all the normal cases too.
> Disgusting. Slowing down the *usual* UNIX case for your new made-up
> case that nobody actually uses is not acceptable.

Re-parenting is not a *usual* operation, usual exit()s have a parent and
do not trigger that code. And in most cases of double-forking it is a
one step, which is almost the same than it was before. Only if we skip
multiple parents it will get the check, which is cheap anyway.

> So NAK. We're not slowing down normal code for some new feature that
> realistically will never be used by any normal applications.

It will be used for all new service managers. UNIX is a pain if you want
to watch your children regarding double-forking, if you are not init.

And it will clean up the mess the desktop stuff is putting in 'ps afx'.
Here is the before/after output:

  253 ?        Ss     0:00 /bin/dbus-daemon --system --address=systemd: --nofork --systemd-activation
  294 ?        Sl     0:00 /usr/libexec/polkit-1/polkitd
  328 ?        S      0:00 /usr/sbin/modem-manager
  608 ?        Sl     0:00 /usr/libexec/colord
  658 ?        Sl     0:00 /usr/libexec/upowerd
  819 ?        Sl     0:00 /usr/libexec/imsettings-daemon
  916 ?        Sl     0:00 /usr/libexec/udisks-daemon
  917 ?        S      0:00  \_ udisks-daemon: not polling any devices


  294 ?        Ss     0:00 /bin/dbus-daemon --system --address=systemd: --nofork --systemd-activation
  426 ?        Sl     0:00  \_ /usr/libexec/polkit-1/polkitd
  449 ?        S      0:00  \_ /usr/sbin/modem-manager
  635 ?        Sl     0:00  \_ /usr/libexec/colord
  705 ?        Sl     0:00  \_ /usr/libexec/upowerd
  959 ?        Sl     0:00  \_ /usr/libexec/udisks-daemon
  960 ?        S      0:00  |   \_ udisks-daemon: not polling any devices
  977 ?        Sl     0:00  \_ /usr/libexec/packagekitd

It's a pretty nice way for an admin too see what's going on on that box,
even with good old 'ps'.

It will also dramatically simplify the handling of started services from
a service manager which double-fork for only historic reasons and make
proper service supervision a nightmare if you are not PID 1.

Upstart ptraces all started services to accomplish something similar. I
doubt we want to go that road, but if you prefer ... :)

If you want, we can make the forked processes inherit a flag if the
'subreaper' should be looked up at all. Then we have almost zero
overhead if the feature isn't used. You think that's needed?

Thanks,
Kay


