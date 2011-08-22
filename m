Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab1HVStR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 14:49:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57853 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752840Ab1HVStN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 14:49:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [GIT PULL pm-next] freezer: fix various bugs and simplify implementation
Date: Mon, 22 Aug 2011 20:50:59 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        arnd@arndb.de, oleg@redhat.com, lizf@cn.fujitsu.com,
        paul@paulmenage.org, Matt Helsley <matthltc@us.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
References: <20110820094434.GA24151@htj.dyndns.org> <201108212003.14722.rjw@sisk.pl> <20110822095857.GD24151@htj.dyndns.org>
In-Reply-To: <20110822095857.GD24151@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108222050.59374.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 22, 2011, Tejun Heo wrote:
> Hello, Rafael.
> 
> On Sun, Aug 21, 2011 at 08:03:14PM +0200, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > Subject: PM / Freezer: Move might_sleep() from try_to_freeze()
> > 
> > There are some code paths that call try_to_freeze() from interrupt
> > context, but doing so they know that the current process cannot
> > possible be freezing (e.g. during reboot on ARM).  However, the
> > recently added might_sleep() annotation in try_to_freeze()
> > triggers in those cases, making it look like there were bugs in
> > those places, which really isn't the case.
> > 
> > Therefore move might_sleep() from try_to_freeze() to
> > __refrigerator() so that it doesn't produce false positives.
> 
> Hmmm... I can't quite agree with this change.  Some invocations of
> try_to_freeze() can be very difficult to trigger.  Freezing isn't a
> frequent operation after some try_to_freeze() can be buried in weird
> places.  might_sleep() is exactly to detect context bugs in these
> situations.  If a code path is called from both sleepable and
> unsleepable context and it knows that the latter wouldn't happen if
> the system is freezing, that code path should conditionalize
> invocation of try_to_freeze() based on its knowledge of context.  That
> way, all other normal cases get the might_sleep() protection and the
> peculiar logic in that code path is explicitly described - win win.
> 
> Can you please point me to where the problem was?

Apparently, during reboot on ARM try_to_freeze() is called via
do_signal() with interrupts disabled.

Thanks,
Rafael
