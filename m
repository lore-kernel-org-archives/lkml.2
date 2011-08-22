Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721Ab1HVJ7J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 05:59:09 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57980 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755842Ab1HVJ7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 05:59:02 -0400
Date: Mon, 22 Aug 2011 11:58:57 +0200
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        arnd@arndb.de, oleg@redhat.com, lizf@cn.fujitsu.com,
        paul@paulmenage.org, Matt Helsley <matthltc@us.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [GIT PULL pm-next] freezer: fix various bugs and simplify
 implementation
Message-ID: <20110822095857.GD24151@htj.dyndns.org>
References: <20110820094434.GA24151@htj.dyndns.org>
 <201108201833.39089.rjw@sisk.pl>
 <20110821091200.GB24151@htj.dyndns.org>
 <201108212003.14722.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201108212003.14722.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Rafael.

On Sun, Aug 21, 2011 at 08:03:14PM +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PM / Freezer: Move might_sleep() from try_to_freeze()
> 
> There are some code paths that call try_to_freeze() from interrupt
> context, but doing so they know that the current process cannot
> possible be freezing (e.g. during reboot on ARM).  However, the
> recently added might_sleep() annotation in try_to_freeze()
> triggers in those cases, making it look like there were bugs in
> those places, which really isn't the case.
> 
> Therefore move might_sleep() from try_to_freeze() to
> __refrigerator() so that it doesn't produce false positives.

Hmmm... I can't quite agree with this change.  Some invocations of
try_to_freeze() can be very difficult to trigger.  Freezing isn't a
frequent operation after some try_to_freeze() can be buried in weird
places.  might_sleep() is exactly to detect context bugs in these
situations.  If a code path is called from both sleepable and
unsleepable context and it knows that the latter wouldn't happen if
the system is freezing, that code path should conditionalize
invocation of try_to_freeze() based on its knowledge of context.  That
way, all other normal cases get the might_sleep() protection and the
peculiar logic in that code path is explicitly described - win win.

Can you please point me to where the problem was?

Thanks.

-- 
tejun
