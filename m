Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757884Ab0LTO6m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 09:58:42 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46329 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757781Ab0LTO6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 09:58:41 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTik052sWOtqNyVdg6g6+cvo-NE-TBdSGdmmp_7en@mail.gmail.com>
References: <20100202120457.GA19605@omega> <AANLkTik052sWOtqNyVdg6g6+cvo-NE-TBdSGdmmp_7en@mail.gmail.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 20 Dec 2010 15:51:15 +0100
Message-ID: <AANLkTim1KYjRDR2vF2RE-VJ-8ML9ewcQbW4PuxB13DPP@mail.gmail.com>
Subject: Re: [PATCH] exit: PR_SET_ANCHOR for marking processes as reapers for
 child processes
To: Scott James Remnant <scott@netsplit.com>
Cc: Lennart Poettering <lennart@poettering.net>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 15:26, Scott James Remnant <scott@netsplit.com> wrote:
> On Tue, Feb 2, 2010 at 12:04 PM, Lennart Poettering
> <lennart@poettering.net> wrote:
>
>> Right now, if a process dies all its children are reparented to init.
>> This logic has good uses, i.e. for double forking when daemonizing.
>> However it also allows child processes to "escape" their parents, which
>> is a problem for software like session managers (such as gnome-session)
>> or other process supervisors.
>>
>> This patch adds a simple flag for each process that marks it as an
>> "anchor" process for all its children and grandchildren. If a child of
>> such an anchor dies all its children will not be reparented to init, but
>> instead to this anchor, escaping this anchor process is not possible. A
>> task with this flag set hence acts is little "sub-init".
>>
> Why can't you simply begin a new pid namespace with the session
> manager or other process supervisor?

We do not want to disconnect users from the system. Too much stuff
depends on that for good reasons.

This is only about a "user init" process, which is a much softer
concept which better fits into our current setups. It is not really
about disconnecting the user from the system, by putting him in a
"container".

The systems view from the management/administration perspective, with
users with their own pids, would really get far to complicated, I
think.

> That way the session
> manager/process supervisor is for all intents and purposes an init
> daemon, so shouldn't be surprised about getting SIGCHLD.

That shouldn't be a problem.

> More to the point, it means that as far as the processes themselves
> are concerned, they're being reparented to pid 1 just as they were
> before, so you wouldn't be breaking any assumptions there either.

For now, I don't think that this will break anything. Stuff that
really expects to have ppid() ==  1 should be fixed anyway.

> You could use the existing init daemon to create these pid namespaces
> when it spawns the session manager.

We already use the existing init daemon for that. :)

This is mainly about 'prettifying ps'. The cgroups already provide us
with all the needed information, it would be just nice to localize
SIGCHLD handling to the "user init", where the signal belongs to.

Kay
