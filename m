Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206Ab2DBDx5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 23:53:57 -0400
Received: from gate.crashing.org ([63.228.1.57]:59773 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065Ab2DBDxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 23:53:47 -0400
Message-ID: <1333338803.30734.37.camel@pasglop>
Subject: Re: broken nouveau dependency on power supply
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-kernel@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>
Date: Mon, 02 Apr 2012 13:53:23 +1000
In-Reply-To: <1333328762.30734.24.camel@pasglop>
References: <1333328762.30734.24.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-02 at 11:06 +1000, Benjamin Herrenschmidt wrote:
> Hi folks !
> 
> With CONFIG_POWER_SUPPLY=m & nouveau built-in we get a build failure:
> 
> drivers/built-in.o: In function `.nouveau_pm_trigger':
> (.text+0xa56e8): undefined reference to `.power_supply_is_system_supplied'
> 
> nouveau probably needs to depends on CONFIG_POWER_SUPPLY to force a module
> build with the latter is =m

Ok, not that trivial...

The problem is more like POWER_SUPPLY should be a bool, not a tristate.

If you think about it: you don't want things like nouveau to depend on a
random subsystem like that, people will never get it. In fact,
POWER_SUPPLY provides empty inline stubs when not enabled, so that's
really designed to not have depends...

However that -cannot- work if POWER_SUPPLY is modular and the drivers
who use it are not. The only fixes here that make sense I can think of
that don't also involve Kconfig horrors are:

 - Ugly: in power_supply.h, use the extern variant if

	defined(CONFIG_POWER_SUPPLY) ||
	 (defined(CONFIG_POWER_SUPPLY_MODULE) && defined(MODULE))

IE. use the stub if power supply is a module and what is being built is
built-in. Of course that's not only ugly, it somewhat sucks from a user
perspective as the subsystem now exists but can't be used by some
drivers...

 - Better: Just make the bloody thing a bool :-) The power supply
framework itself is small enough, just make it a boolean option and
avoid the problem entirely. The actual power supply sub drivers can
remain modular of course.

Cheers,
Ben.


