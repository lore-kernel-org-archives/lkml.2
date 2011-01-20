Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab1ATXgO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 18:36:14 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45982 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754115Ab1ATXgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 18:36:13 -0500
Date: Thu, 20 Jan 2011 15:35:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Kim Kyuwon <q1.kim@samsung.com>, Kim Kyuwon <chammoru@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] leds: Convert bd2802 driver to dev_pm_ops
Message-Id: <20110120153528.4a535065.akpm@linux-foundation.org>
In-Reply-To: <20110120232409.GA23862@opensource.wolfsonmicro.com>
References: <1295559395-28942-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	<20110120151201.8dca7a7e.akpm@linux-foundation.org>
	<20110120232409.GA23862@opensource.wolfsonmicro.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jan 2011 23:24:09 +0000
Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> On Thu, Jan 20, 2011 at 03:12:01PM -0800, Andrew Morton wrote:
> 
> > CONFIG_PM=n:
> 
> To be honest I've been forming the opinion that this is just cruft these
> days - it's hard to see a modern Linux system where you're sufficiently
> space constrained to want to turn it off without also being sufficiently
> power constrained to want to turn it on and it's hassle to maintain it.

Could be.  It's hard to think of a machine which is small enough to
care about ~10k of kernel text but which doesn't care about power
consumption.

> That said...
> 
> > It would be nice to fix all this via automagic within the
> > SIMPLE_DEV_PM_OPS() implementation but I can't see a way of doing that :(
> 
> ...the problem here is that the macro is doing roughly the right magic
> but the original driver wasn't ifdefing the suspend and resume stuff at
> all.  If the were only defining the suspend and resume functions under
> CONFIG_PM_SLEEP it should build cleanly.  Since the original driver
> didn't have the ifdefs I didn't add or update them.
> 
> This means the pm_ops can be unconditionally defined which seems to be
> the preferred idiom for this stuff.  If SIMPLE_DEV_PM_OPS() didn't do
> the stuff it's doing then the warnings would vanish in the same way they
> did originally, by virtue of the functions being unconditionally
> referenced from the vtable.

It's tricky to get the compiler/linker to discard code and data without
triggering an unused-var warning.  cpu_notifier() does it by emitting a
reference:

static void foo(..)
{
	...
}

bar()
{	
	...
	do { (void)(foo); } while (0)
	...
}

but this is only possible because cpu_notifier() is "called" within a
function.  Whereas SIMPLE_DEV_PM_OPS() is a static initialisation
thingy.

We could emit a dummy function but then we get a warning about the
unused dummy function.

Can the dummy function refer to itself and thus squish the warning?

akpm:/home/akpm> cat t.c
static void foo(void)
{
	        do { (void)(foo); } while (0);
}
akpm:/home/akpm> gcc -c -Wall t.c
t.c:1: warning: 'foo' defined but not used

Nope.


This works.  lol.

akpm:/home/akpm> cat t.c
static void bar(void);
static void foo(void)
{
        do { (void)(bar); } while (0);
}
static void bar(void)
{
        do { (void)(foo); } while (0);
}
akpm:/home/akpm> gcc -O2 -c -Wall t.c
akpm:/home/akpm> size t.o
   text    data     bss     dec     hex filename
      0       0       0       0       0 t.o

