Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812Ab0KDT55 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 15:57:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52355 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038Ab0KDT5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 15:57:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [linux-pm] [GIT PULL] One more power management fix for 2.6.37
Date: Thu, 4 Nov 2010 20:55:31 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.35-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <201010292358.27975.rjw@sisk.pl> <201011041424.44215.rjw@sisk.pl> <AANLkTikfGJOMpnvwJ4tTW3EXVGayyT=3s5iyhGbhKz8_@mail.gmail.com>
In-Reply-To: <AANLkTikfGJOMpnvwJ4tTW3EXVGayyT=3s5iyhGbhKz8_@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011042055.31779.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 04, 2010, Linus Torvalds wrote:
> On Thu, Nov 4, 2010 at 9:24 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >
> > OK, so I think we can relax the locking in dpm_[suspend/resume]_noirq() to
> > avoid executing callbacks under dpm_list_mtx, like in the (untested) patch
> > below.
> 
> ABSOLUTELY NOT.
> 
> If you drop the lock in the middle of the loop, you should remove the
> lock around the loop entirely. There is absolutely no difference
> between "drop lock in the middle" and "don't take lock at all".
> 
> Either that list traversal needs the lock or it does not. There is no
> "it needs the lock, but not while doing random crap X in the middle of
> traversal".

Your're right,  it only makes sense to either leave it or remove it entirely.

> If nothing can possibly change the list while calling the device, then
> you don't need the lock. And if something _can_ change the list,
> dropping the lock means that the list is no longer trustworthy and you
> can't just continue in the middle.

At this point, if everyone does everything right, there should be nothing
running in parallel with us that will attempt to modify the list.  So, I'd say
let's drop the lock completely.

Thanks,
Rafael
