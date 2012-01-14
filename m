Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab2ANOGv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 09:06:51 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:32825 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513Ab2ANOGu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 09:06:50 -0500
MIME-Version: 1.0
In-Reply-To: <20120113163558.a662e7c5.akpm@linux-foundation.org>
References: <1325951797.860.10.camel@mop> <124669.1325952830@turing-police.cc.vt.edu>
 <20120109150701.GB1777@redhat.com> <20120113163558.a662e7c5.akpm@linux-foundation.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sat, 14 Jan 2012 14:59:03 +0100
Message-ID: <CAPXgP116b7GTzjTczXWq_v8bjATXuogJs7PU7oSY-5CimU4umQ@mail.gmail.com>
Subject: Re: [PATCH] prctl: add PR_{SET,GET}_CHILD_SUBREAPER to allow simple
 process supervision
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org,
        Lennart Poettering <lennart@poettering.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 14, 2012 at 01:35, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Mon, 9 Jan 2012 16:07:01 +0100
> Oleg Nesterov <oleg@redhat.com> wrote:
>
>> > > +         /* find the first ancestor marked as child_subreaper */
>> > > +         for (reaper = father->real_parent;
>> > > +              reaper != &init_task;
>> > > +              reaper = reaper->real_parent) {
>> >
>> > I admit being insufficiently caffienated - does this DTRT in a PID namespace? That
>> > &init_task looks fishy to me...
>>
>> Probably this needs a comment. Initially I was confused too.
>>
>> Note that the code below checks same_thread_group(reaper, pid_ns->child_reaper),
>> this is what we need to DTRT in a PID namespace. However we still need the
>> check above, see http://marc.info/?l=linux-kernel&m=131385460420380
>
> In light of Kay's haughty silence, I did this:
>
> --- a/kernel/exit.c~prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix
> +++ a/kernel/exit.c
> @@ -724,7 +724,13 @@ static struct task_struct *find_new_reap
>        } else if (father->signal->has_child_subreaper) {
>                struct task_struct *reaper;
>
> -               /* find the first ancestor marked as child_subreaper */
> +               /*
> +                * Find the first ancestor marked as child_subreaper.
> +                * Note that the code below checks same_thread_group(reaper,
> +                * pid_ns->child_reaper).  This is what we need to DTRT in a
> +                * PID namespace. However we still need the check above, see
> +                * http://marc.info/?l=linux-kernel&m=131385460420380
> +                */
>                for (reaper = father->real_parent;
>                     reaper != &init_task;
>                     reaper = reaper->real_parent) {

Oleg and I got nowhere really, discussing if we should switch the
check in the for() parameters and the one inside the loop; so we just
decided to keep it the way it is, and did not reply any further. It
wasn't that we didn't care, we just couldn't decide. Sorry for that.

The comment indeed sounds good to have. Thanks for adding this.

Kay
