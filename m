Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689Ab0JHThP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 15:37:15 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42753 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481Ab0JHThM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 15:37:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qi4wj2JmWBOGBNzBcy7IUlpYtl3t6jL0ZsIJzg6oNfHxk4/2m6aSZF65XdeqGca5KW
         X2ARDO9rgWxG9/XZnZH8nDfWEvq3ULkOatWUqno0e861rDN5Hs+YsWFem8cx86X9nh3i
         2Q4G2ZWFOs0Eez0PcCk26FmQyt7SJxvBUoHdA=
MIME-Version: 1.0
In-Reply-To: <20101008175308.GA10975@n2100.arm.linux.org.uk>
References: <1286444662-16843-1-git-send-email-felipe.contreras@gmail.com>
	<20101007192245.GC26435@n2100.arm.linux.org.uk>
	<AANLkTikQKY7pOobD+==uT5Cy0poT=O5wDMKtbVyJVNbO@mail.gmail.com>
	<20101008175308.GA10975@n2100.arm.linux.org.uk>
Date: Fri, 8 Oct 2010 22:37:10 +0300
Message-ID: <AANLkTi=ERZjVDS=Q7aw1zA23KF68irUP3vvKLZw5meBU@mail.gmail.com>
Subject: Re: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Greg KH <greg@kroah.com>, linux-main <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Arnd Hannemann <arnd@arndnet.de>,
        Han Jonghun <jonghun79.han@gmail.com>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Hemant Pedanekar <hemantp@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 8, 2010 at 8:53 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Fri, Oct 08, 2010 at 12:32:35PM +0300, Felipe Contreras wrote:
>> I think when _you_ remove functionality from the architecture, you
>> should provide a mechanism that drivers can migrate to. Since there's
>> nothing like that, not even a guideline, you are breaking the drivers
>> willingly, and expecting other people to fix a difficult problem that
>> you yourself have no idea how to fix properly.
>
> We can either wait for people to complain about silent data corruption
> or we can be compliant with the architecture specification.  Which is
> better - to avoid data corruption and be correct, or allow a system to
> become flakey and corrupt people's data.

The data corruption would happen only on the memory areas that are
doubly mapped, right? So the misbehavior would only be visible on the
driver. Then what is better? A driver that works 99% of the time, or a
driver that doesn't work at all?

Besides, there are many ARMv6 and ARMv7 devices that are already
shipping with this "wrong" ioremap() and I don't see them blowing up,
so I presume whatever issue is caused by this cannot be so drastic as
to not allow anybody doing this ever from the exact point you found
the issue.

Do you have a test that provides numbers on how often do issues popup,
and under which situations?

> What I care about is system correctness and people's data - having
> multiple mappings with different attributes is documented in very clear
> terms as being 'unpredictable' and therefore it isn't permissible to
> allow the practice that worked with previous processors (inherently
> due to their cache architecture) to continue forward onto processors
> with a different cache architecture.

Of course, it shouldn't be permissible, but you shouldn't just disable
features from one release to the next, each time you find out they are
not proper; there should be some grace period, specially if there's no
alternative.

> As already discussed, it's nigh on impossible to unmap the existing
> direct mapped region (read the previous discussions about why this is)
> - which is precisely why there is no direct alternative solution.
>
> The only possible solution is to exclude some memory at boot time from
> the system direct map so that it never appears in the direct map, and
> use ioremap on _that_.  Another possible alternative is to use highmem,
> obtain highmem pages (making sure that it doesn't fall back to lowmem)
> and remap them using interfaces such as vmap.
>
> So there are solutions to the problem, but it seems that _no one_ is
> willing to discuss it other than "we want our old way back".

People have been discussing them, but you can't expect a perfect
solution to pop up within one release cycle, specially when people
have real issues to deal with.

Be realistic, what is going to happen is that people are going to give
up on having their drivers working on .26, revert the patch, and since
the drivers are already not working, the fix can wait, right? Maybe
after .27, or some other time, a seasoned developer would have time to
get this fixed properly, or they are going to come with workarounds
like manually reserving memory with mem= bootarg:
http://article.gmane.org/gmane.linux.ports.arm.omap/44516

> If you want the old way back, apply pressure to silicon vendors and
> ARM Ltd to change the architecture to lift this restriction - which
> will probably mean doing away with aggressive speculative prefetching
> so that it's possible to predict what will be in the cache at any
> point in time.

Nobody is asking for the old way back, what is being asked is a *grace
period*, have a warning right now, then disable completely later on.

-- 
Felipe Contreras
