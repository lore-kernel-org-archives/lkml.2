Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047Ab0GXOpN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 10:45:13 -0400
Received: from lo.gmane.org ([80.91.229.12]:39183 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754870Ab0GXOpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 10:45:11 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: Re: Introducing the LCD-Linux project
Date: Sat, 24 Jul 2010 14:43:31 +0000 (UTC)
Message-ID: <loom.20100724T155117-833@post.gmane.org>
References: <AANLkTikitTGpiE5Oe_P5a4f2OCOnlB9j_LVm5CQhQIno@mail.gmail.com> <20100722122111.4cf4ca2f@lxorguk.ukuu.org.uk> <AANLkTilKJx18oyc815DhKfPv-Yjdv8UmfJ4WTDxZxaab@mail.gmail.com> <AANLkTimnxkn5eLRHOAs6v_TJE0hM5=dQ3OWaiQP6tPJd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 92.74.233.170 (Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.0.19) Gecko/2010033100 Iceweasel/3.0.6 (Debian-3.0.6-3))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Mattia Jona-Lasinio <mattia.jona <at> gmail.com> writes:
> Moreover I wanted something that COULD be used as a console but not
> necessarily, that is
> something that could run happily in the presence of a normal monitor
> as well. It seems to me, but I may be
> wrong, that through the standard console system only the current
> visible console is actually updated
> while other consoles are just "software" updated. An external LCD
> would therefore be updated
> only when you "switch" to it, so it would not be possible to use it to
> display diagnostics.

True, that's a general problem one has when multiple framebuffers exist.
Therefore I'd be very happy if someone could come up with a general solution.
The problem I see is as follows:
If multiple framebuffers exist there is no finegrained control which
applications draws to which framebuffer. Common practice seems to be to only
draw from the application running in the active vt. But that's not always what
is wanted so a little extension to the kernel deciding whether an application
may or may not draw would be helpful (of course such a thing would require
changes in userspace as well for applications that directly access the
framebuffer).

Example:
Having two framebuffers (fb0, fb1) and three applications (a0, a1, a2) where a0
wants to draw to fb0, a1 to fb1 and a2 to fb0 & fb1.
At first only a0 is running so only fb0 is used. You than start a1:
current: only fb1 is updated by a1
desired (?): fb0 is updated by a0 and fb1 is updated by a1
After you start a2
current = desired: fb0 & fb1 are updated by fb2
You than switch back to a0:
current: only fb0 is updated by a0
desired (?): fb0 is updated by a0 and fb1 is updated by a2

At least that's how I see the problem. So what must a solution provide:
- keep the old interface consistent to not break old applications
- avoid race-conditions while providing direct graphic access
So for each applications that does not know about this interface it has to
behave as if this application draws to all framebuffers. But if the active
application knows it it can allow the last application updating the "unused"
framebuffers as long as the current application does not request access to it.
But I'm unsure how to implement a clean, race-free and efficient solution.

Any suggestions?


Thanks,

Florian Tobias Schandinat

