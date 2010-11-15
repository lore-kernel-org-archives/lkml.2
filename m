Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758359Ab0KOXZZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 18:25:25 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55557 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752128Ab0KOXZY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 18:25:24 -0500
MIME-Version: 1.0
In-Reply-To: <30291.1289860866@localhost>
References: <1287479765.9920.9.camel@marge.simson.net> <1287487757.24189.40.camel@marge.simson.net>
 <AANLkTik08s=S7gZOGWEEhPW-zJtNRCse2h6jH3HAjoJH@mail.gmail.com>
 <1287511983.7417.45.camel@marge.simson.net> <1287514410.7368.10.camel@marge.simson.net>
 <20101020025652.GB26822@elte.hu> <1287648715.9021.20.camel@marge.simson.net>
 <20101021105114.GA10216@Krystal> <1287660312.3488.103.camel@twins>
 <20101021162924.GA3225@redhat.com> <1288076838.11930.1.camel@marge.simson.net>
 <1288078144.7478.9.camel@marge.simson.net> <AANLkTimOJAv2uRfq4bW_QPngkGCmJDjNX5n_izpX=eB8@mail.gmail.com>
 <1289489200.11397.21.camel@maggy.simson.net> <30291.1289860866@localhost>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 15 Nov 2010 15:25:01 -0800
Message-ID: <AANLkTikeLeLvYcZJ4HcAUH1ax13scgnrT27CSR=YzO_C@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
To: Valdis.Kletnieks@vt.edu
Cc: Mike Galbraith <efault@gmx.de>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 2:41 PM,  <Valdis.Kletnieks@vt.edu> wrote:
>
> So the set of all tasks that never call proc_set_tty() ends up in the same one
> big default group, correct?

Well, yes and no.

Yes, that's what the code currently does. But I did ask Mike (and he
delivered) to try to make the code look and work in a way where the
whole "tty thing" is just one of the heuristics.

It's not clear exactly what the non-tty heuristics would be, but I do
have a few suggestions:

 -  I think it might be a good idea to associate a task group with the
current "cred" of a process, and fall back on it in the absense of a
tty-provided one.

   Now, for desktop use, that probably doesn't often matter, but even
for just the desktop it would mean that "system daemons" would at
least get a group of their own, rather than be grouped with
"everything else"

   (As is, I think the autogroup thing already ends up protecting
system daemons more than _not_ having the autogroup, since it will
basically mean that a "make -j64" won't be stealing all the CPU time
from everybody else - even if the system daemons all end up in that
single "default" group together with the non-tty graphical apps.)

 - I suspect we could make kernel daemons be a group of their own.

> Do we have any provisions for making sure that if
> a user has 8 or 10 windows open doing heavy work, the default group (with a lot
> of important daemons/etc in it) doesn't get starved with only a 1/10th share of
> the CPU? Or am I missing something here?

I think you're missing the fact that without the autogroups, it's
_worse_. If you do "make -j64" without autogroups, those important
daemons get starved by all that work. With the autogroups, they end up
being protected by being in the default group.

So the fact that they are in the default group with lots of other
users doesn't hurt, quite the reverse. User apps are likely to be in
their own groups, so they affect system apps less than they do now.

But I do agree that we might be able to make that all much more explicit.

                    Linus
