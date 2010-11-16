Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759008Ab0KPBTN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 20:19:13 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41133 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754553Ab0KPBTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 20:19:12 -0500
MIME-Version: 1.0
In-Reply-To: <1289865870.14719.185.camel@maggy.simson.net>
References: <1287479765.9920.9.camel@marge.simson.net> <1287487757.24189.40.camel@marge.simson.net>
 <AANLkTik08s=S7gZOGWEEhPW-zJtNRCse2h6jH3HAjoJH@mail.gmail.com>
 <1287511983.7417.45.camel@marge.simson.net> <1287514410.7368.10.camel@marge.simson.net>
 <20101020025652.GB26822@elte.hu> <1287648715.9021.20.camel@marge.simson.net>
 <20101021105114.GA10216@Krystal> <1287660312.3488.103.camel@twins>
 <20101021162924.GA3225@redhat.com> <1288076838.11930.1.camel@marge.simson.net>
 <1288078144.7478.9.camel@marge.simson.net> <AANLkTimOJAv2uRfq4bW_QPngkGCmJDjNX5n_izpX=eB8@mail.gmail.com>
 <1289489200.11397.21.camel@maggy.simson.net> <30291.1289860866@localhost>
 <1289864780.14719.172.camel@maggy.simson.net> <AANLkTikztvdgFucCUjZ+A5Je-LUKLknV5+aznVvL98oQ@mail.gmail.com>
 <1289865870.14719.185.camel@maggy.simson.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 15 Nov 2010 17:18:50 -0800
Message-ID: <AANLkTik53N7HMyXMOEzh2Qr_4gg9eXSmXiT6TQ9gFC+h@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
To: Mike Galbraith <efault@gmx.de>
Cc: Valdis.Kletnieks@vt.edu, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        Paul Menage <menage@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm. Just found a bug. I'm not sure if it's the autogroup patches
themselves, or whether it's just the cgroup code that the autogroup
patch enables for me.

When I do

   echo t > /proc/sysrq-trigger

(or "w") I get a NULL pointer dereference (offset 0x38 - decimal 56)
in "cgroup_path+0x7", with a call trace of sched_debug_show,
show_state_filter, sysrq_handle_showstate_blocked. I don't have the
whole oops, because the machine is really dead at that point
(presumably died holding the runqueue lock or some other critical
resource), but if required I could take a photo of it. However, I bet
it is repeatable, so I doubt you need it.

Anyway, that "cgroup_path+0x7" is the very first memory dereference:

    movq    56(%rdi), %rsi  # cgrp_5(D)->dentry, _________p1

so sched_debug_show() is apparently calling cgroup_path() with a NULL
cgroup. I think it's "print_task()" that is to blame, it does

     cgroup_path(task_group(p)->css.cgroup, ..

without checking whether there _is_ any css.cgroup.

Peter, that looks like your code (commit d19ca30874f2)

Guys?

                      Linus
