Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330Ab1HQAdB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 20:33:01 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:36161 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab1HQAc7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 20:32:59 -0400
MIME-Version: 1.0
In-Reply-To: <20110816131010.7a6e9a99.akpm@linux-foundation.org>
References: <1311897706.16657.2.camel@mop> <20110816131010.7a6e9a99.akpm@linux-foundation.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 17 Aug 2011 02:32:39 +0200
Message-ID: <CAPXgP11n54=M8dVhtpJ3h_nuFivYKtqXXue5sATbXu80RXfqHA@mail.gmail.com>
Subject: Re: [PATCH] prctl: add PR_{SET,GET}_CHILD_REAPER to allow simple
 process supervision
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Lennart Poettering <lennart@poettering.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 22:10, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Fri, 29 Jul 2011 02:01:44 +0200
> Kay Sievers <kay.sievers@vrfy.org> wrote:
>
>> From: Lennart Poettering <lennart@poettering.net>
>> Subject: prctl: add PR_{SET,GET}_CHILD_REAPER to allow simple process supervision
>>
>> Userspace service managers/supervisors need to track their started
>> services. Many services daemonize by double-forking and get implicitely
>> re-parented to PID 1. The process manager will no longer be able to
>> receive the SIGCHLD signals for them.
>>
>> With this prctl, a service manager can mark itself as a sort of
>> 'sub-init' process, able to stay as the parent process for all processes
>> created by the started services. All SIGCHLD signals will be delivered
>> to the service manager.
>>
>> As a side effect, the relevant parent PID information does not get lost
>> by a double-fork, which results in a more elaborate process tree and 'ps'
>> output.
>>
>> This is orthogonal to PID namespaces. PID namespaces are isolated
>> from each other, while a service management process usually requires
>> the serices to live in the same namespace, to be able to talk to each
>> other.
>>
>> Users of this will be the systemd per-user instance, which provides
>> init-like functionality for the user's login session and D-Bus, which
>> activates bus services on on-demand. Both will need init-like capabilities
>> to be able to properly keep track of the services they start.
>>
>
> Interesting patch.  I can't immediately see any nasty effects from it..
>
> Did you consider using the existing taskstats capability for this?

Yes, but as it always is with buffered async interfaces, they are
tricky regarding ordering, races and possible overflows.

SIGCHLD is async too, but it has important differences in this case:
If the service-manager is the reaper, it will do the waitpid() itself,
and before it reaps the child, it can still investigate the existing
task and it will also directly receive the return values from
waitpid(). If we let the pids re-parent to PID 1, then the dead pids
and most of their information is gone before the service manager sees
the taskstats event.

The service-manager needs to handle SIGCHLD and waitpid() anyway for
all the stuff that does not double-fork, so the code is already there
and does all what we need without involving a second interface just
for re-parenting processes.

My very personal favourite is that 'ps afx' looks so nice now. The
tree of the processes of the login session start to make sense, and we
don't have half of the user processes hanging off PID 1. But that's
surely just cosmetics, and no reason to do that. I just like pretty
things. :)

> The comment block over find_new_reaper() is now incomplete.  Please
> update it?

'... give it to the child reaper process (ie "init") in out pid
space.' still kind of fits, I think?

Would:
'... give it to the child reaper process (ie 'init' or parent marked
as reaper) in our pid space.' sound better?

> prctl(2) has a manpage.  What's the plan for updating it?

I'll send the update to Michael when it hits the repo.

Thanks,
Kay
