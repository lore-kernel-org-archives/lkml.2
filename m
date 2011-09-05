Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084Ab1IERos (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 13:44:48 -0400
Received: from smarthost1.greenhost.nl ([195.190.28.78]:37155 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab1IERom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 13:44:42 -0400
Message-ID: <a9c6784bdb67df6d1eb8ccbdefec4e7f.squirrel@webmail.greenhost.nl>
In-Reply-To: <1315231572.1888.35.camel@dhcp-25-63.brq.redhat.com>
References: <201109042311.18793.vda.linux@googlemail.com>
    <d1aa7eeee449fe4402a999ab686ed921.squirrel@webmail.greenhost.nl>
    <201109051124.09775.vda.linux@googlemail.com>
    <bb2c259961b62bb8759df7d1f9ebc8f7.squirrel@webmail.greenhost.nl>
    <1315231572.1888.35.camel@dhcp-25-63.brq.redhat.com>
Date: Mon, 5 Sep 2011 19:44:20 +0200
Subject: Re: RFC: PTRACE_SEIZE needs API cleanup?
From: "Indan Zupancic" <indan@nul.nu>
To: "Denys Vlasenko" <dvlasenk@redhat.com>
Cc: "Denys Vlasenko" <vda.linux@googlemail.com>,
        "Oleg Nesterov" <oleg@redhat.com>, "Tejun Heo" <tj@kernel.org>,
        linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.0
X-Scan-Signature: 5a1627636b35b65657045ef62631cd80
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, September 5, 2011 16:06, Denys Vlasenko wrote:
> In case you meant that "if we request group-stop notifications by using
> __WALL | WSTOPPED, and we get group-stop notification, and we do
> PTRACE_CONT, then task does not run (it sits in group-stop until SIGCONT
> or death)", then we have a problem: gdb can't use this interface, it
> needs to be able to restart the thread (only one thread, not all of
> them, so sending SIGCONT is not ok!) from the group-stop. Yes, it's
> weird, but it's the real requirement from gdb users.
[...]
> SIGCONT's side effect of waking up from group-stop can't be blocked.
> SIGCONT always wakes up all threads in thread group.
> Using SIGCONT to control tracee will race with SIGCONTs from other
> sources.
>
> This makes SIGCONT a too coarse instrument for the job.
[...]
> Yes... until gdb will want to give user a choice after SIGSTOP: continue
> to sit in group-stop until SIGCONT (wasn't possible until
> PTRACE_LISTEN), or continue executing (gdb's current behavior if user
> uses "continue" command). Therefore, gdb needs a way to do both.

Having thought a bit more about this, I think this is less of a problem
than it seems, because for a group stop we get a ptrace event for each
task, and this should be true for SIGCONT as well. So gdb could also
always let the group stop happen, and only when prompted to do so by
a user, continue one thread by sending SIGCONT and letting all the other
threads hang in trapped state. So the above choice doesn't have to be
given, it can be made explicitly by the user at SIGCONT time (continue
all threads, or just one).

Regards,

Indan


