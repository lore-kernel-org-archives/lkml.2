Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab0KDRIA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 13:08:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46610 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751966Ab0KDRH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 13:07:59 -0400
MIME-Version: 1.0
In-Reply-To: <201011041424.44215.rjw@sisk.pl>
References: <201010292358.27975.rjw@sisk.pl> <201011040604.05183.rjw@sisk.pl>
 <20101104062709.GA3118@isilmar-3.linta.de> <201011041424.44215.rjw@sisk.pl>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 4 Nov 2010 13:07:10 -0400
Message-ID: <AANLkTikfGJOMpnvwJ4tTW3EXVGayyT=3s5iyhGbhKz8_@mail.gmail.com>
Subject: Re: [linux-pm] [GIT PULL] One more power management fix for 2.6.37
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
        Alan Stern <stern@rowland.harvard.edu>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 4, 2010 at 9:24 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> OK, so I think we can relax the locking in dpm_[suspend/resume]_noirq() to
> avoid executing callbacks under dpm_list_mtx, like in the (untested) patch
> below.

ABSOLUTELY NOT.

If you drop the lock in the middle of the loop, you should remove the
lock around the loop entirely. There is absolutely no difference
between "drop lock in the middle" and "don't take lock at all".

Either that list traversal needs the lock or it does not. There is no
"it needs the lock, but not while doing random crap X in the middle of
traversal".

If nothing can possibly change the list while calling the device, then
you don't need the lock. And if something _can_ change the list,
dropping the lock means that the list is no longer trustworthy and you
can't just continue in the middle.

Don't write code like this with nonsensical locking. Not even if it is
a case of "it happens to work because we have those other totally
random rules".

                  Linus
