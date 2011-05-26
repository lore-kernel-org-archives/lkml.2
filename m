Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757093Ab1EZKy5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 06:54:57 -0400
Received: from DMZ-MAILSEC-SCANNER-8.MIT.EDU ([18.7.68.37]:61233 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756856Ab1EZKy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 06:54:56 -0400
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 May 2011 06:54:56 EDT
X-AuditID: 12074425-b7b78ae000007e02-4a-4dde30434619
Subject: Re: [rfc] Ignore Fsync Calls in Laptop_Mode
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <BANLkTincvGV735PKb60Kg0dLX6a1CZ-iNA@mail.gmail.com>
Date: Thu, 26 May 2011 06:49:46 -0400
Cc: Oliver Neukum <oneukum@suse.de>, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Transfer-Encoding: 7bit
Message-Id: <410B37BE-E380-40D0-82AA-48B56F389E16@mit.edu>
References: <BANLkTikGxbcMBD=3W_9_mpZBoVDc8HrX8A@mail.gmail.com> <201105231012.06928.oneukum@suse.de> <20110525000003.GJ32466@dastard> <201105250850.12179.oneukum@suse.de> <BANLkTincvGV735PKb60Kg0dLX6a1CZ-iNA@mail.gmail.com>
To: "D. Jansen" <d.g.jansen@googlemail.com>
X-Mailer: Apple Mail (2.1084)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCKsWRmVeSWpSXmKPExsUixCmqretscM/X4O5aZYs569ewWVy7PYnN
	Ysuxe4wWl3fNYbNYfHE2qwOrx6lFEh5PJ0xm9zgx4zeLx+bT1R6fN8kFsEZx2aSk5mSWpRbp
	2yVwZZzYcI61YIt0RUfDT+YGxm+iXYycHBICJhKft9xlhrDFJC7cW8/WxcjFISSwj1Gi/fNv
	ZghnA6PE9X2NrBDOaSaJ1U09TCAtwkDtE7dPAGvnFTCUWLqpnR3EZhbQkrjx7yVYDZuAksSd
	T/tZQGxOAUeJacv+Ag3i4GARUJVo6UgCmcks0MkoMbNzDyNEr7zE9rdzoGZaSbybvBjqpAeM
	Ei3H1oEtEBHQljg66QITyCAJAVmJpmUZExgFZyE5YxaSM2YhGbuAkXkVo2xKbpVubmJmTnFq
	sm5xcmJeXmqRroVebmaJXmpK6SZGUOCzu6juYJxwSOkQowAHoxIP70KFu75CrIllxZW5hxgl
	OZiURHmb9O/5CvEl5adUZiQWZ8QXleakFh9ilOBgVhLhbWIBKudNSaysSi3Kh0lJc7AoifPO
	l1T3FRJITyxJzU5NLUgtgsnKcHAoSfCeBRkqWJSanlqRlplTgpBm4uAEGc4DNHw3SA1vcUFi
	bnFmOkT+FKOilDjvcZCEAEgiozQPrheWmF4xigO9IgxRxQNManDdr4AGMwEN1vkNcnVxSSJC
	SqqBsXTV2482Fz8t3hCkL37e6FrNPd9rD0IuvG4VWH+f+cQ6p1Ut12snnnK2ub7wUO+UZvEX
	S/oi2Waa/Z04zZztRMW5j+4Llu7hjQo//fFqD3tHnmnB/0/Be2Zo7JH7oCEZtSPhcuov6zV7
	Jx8vcz99uGD1hdku15zmK5YeOdLPvrf/hXK3v8bz2qtKLMUZiYZazEXFiQC1arjIJwMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 26, 2011, at 3:01 AM, D. Jansen wrote:

> That seems to be the big ordering issue. I had always assumed that
> user space writes (by the same app to the same file) would be
> committed in order. Is that really not the case?
> 
> Wouldn't most app programmers assume ordering? Wouldn't that always
> possibly be an issue? Or do all the apps that require ordered writes
> use fsync. There will surely be some who require ordering but don't
> fsync. And without ordering, some apps won't be able to avoid fsync
> without data safety issues.

I really don't like using the word "ordering" the way Dave used it,
because it's a file system lingo that *always* confuses civilians.
And "Insider" language like that isn't help for communication,
unless you're certain there are only experts in the room...

As Dave said earlier, "ordering" in the sense he was using it
refers strictly to ensuring consistency after a crash.

Now, there are two levels of consistency; one is file system
level consistency, and the other is application level 
consistency.   It used to be that desktop drives would
lie about forcing data to disk in response to a FLUSH 
CACHE command, "yes sir, I promise the data is on
the disk, sir!", because it resulted in higher WINBENCH
scores.  File systems engineers hated this, because
a primary tool we have for assuring that file systems
don't look like swiss cheese after a crash was completely
unreliable.   Fortunately, those disks have largely
disappeared from the market place.

The suggestion of making fsync a no-op is essentially
asking for a knob that breaks application-level consistency
the same way those broken hard drives broke file system
consistency by making the FLUSH CACHE command
unreliable.   Maybe improving battery lifetime is a more
honorable excuse than the purely mercenary goal of
selling more disk drives, but it can still break applications
after a crash.

Now, you may think that you're prepared by that.   After all,
you're already prepared to say that you're willing to lose
the last 15 minutes of work or whatever, right?

Well, wrong.  It's not so simple as that.  If you're only
talking about simple, flat, human-readable text files,
maybe it would work that way.   But what about complex,
binary databases?  Like sqllite databases used by 
Firefox and Chrome?   Or MySQL databases?   More
and more, sophisticated applications, even desktop
applications, are using these complex data stores,
and the libraries which update these complex data
stores rely on fsync() to prevent their database files
from looking like swiss cheese.   If you crash while
fsync() has been disabled, the entire database file
could be completely trashed, which could be hours,
days, weeks, or months of work lost.

So the resistance that people like Dave have to your 
proposal can be summed up by Confucious if you are
Chinese: ""Never impose on others what you would
not choose for yourself."  Or if you are Jewish, the Rabbi
Hillel said: "That which is hateful to you, do not do to
your fellow. That is the whole Torah; the rest is the
explanation; go and learn."   Or if you are a Muslim,
the Prophet Mohammed: "Hurt no one so that no one
may hurt you."   Breaking fsync() is like hard drives that
break faith with file system authors by lying when they 
say everything is safely written to stable storage.  And 
what are databases but complex file systems living inside
a single file?

-- Ted

