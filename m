Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab1HQU4x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 16:56:53 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62108 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919Ab1HQU4v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 16:56:51 -0400
MIME-Version: 1.0
In-Reply-To: <20110817185709.GA27663@redhat.com>
References: <201108162011.p7GKBcY0023134@imap1.linux-foundation.org>
 <20110817115543.GA8745@redhat.com> <CAPXgP12rYf2HmmsJAuJw=nrtcjTRR1WzDhLNM47eKhKA1UTfJQ@mail.gmail.com>
 <20110817134516.GA14136@redhat.com> <CAPXgP101N_GESzpqu=P_H8cLoekMzb2_W2eWyAqATSjm4Gj9CA@mail.gmail.com>
 <20110817162041.GA21406@redhat.com> <CAPXgP13Dn2c-OnYg-Cty5r4JbqeH_zYPtXDj5GAfK1btoKYmDg@mail.gmail.com>
 <20110817185709.GA27663@redhat.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 17 Aug 2011 22:56:29 +0200
Message-ID: <CAPXgP12+zL=RNgCksCGuOCBKEFiTQvemBM3tqwS4ndH9x88nGA@mail.gmail.com>
Subject: Re: + prctl-add-pr_setget_child_reaper-to-allow-simple-process-supervision
 .patch added to -mm tree
To: Oleg Nesterov <oleg@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        lennart@poettering.net, linux-man@vger.kernel.org,
        roland@hack.frob.com, torvalds@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 17, 2011 at 20:57, Oleg Nesterov <oleg@redhat.com> wrote:
> On 08/17, Kay Sievers wrote:
>> Async notifications like
>> taskstats just can not provide what SIGCHLD, /proc and wait() offer.
>
> Why not? Async notifications can't delay the reaping, yes. But I am
> not sure /proc/ is that useful when the task exits. OK, I won't argue.

I guess parents usually prefer to pick up their children themselves
that ran away from home, instead of getting calls from somebody else
telling them that they already took care of everything. :)

The most prominent issue with async messages is the re-use of the same
keys/ids they carry, during the window the event happened and the
async message is received. If we reap PIDs ourselves, the PID is
pinned until we take care of it, it can not be another process be
created in the meantime with the same PID.

>> > Once again, if pid_ns->child_reaper exits, you should
>> > not even try to find the sub-reaper in its parents chain.
>>
>> That would mean we can never run a sub-init in a pid namespace? Why not?
>>
>> Or do you mean that we *are* already the pid_ns->child_reaper, not
>> that one *exists*?
>
> I already got lost a bit, not sure I understand.
> I meant we *are* (the caller) the exiting pid_ns->child_reaper thread.

Right, that's what I meant. And what can be avoided if we move the
parent walk below the current check.

>> > In this case we should kill the children, not reparent them. Or panic
>> > if it is the global init (see above).
>> >
>> > See?
>>
>> Not sure. You mean that the lookup for a possible task->cild_reaper
>> should be _before_ the check for pid_ns->child_reaper == father which
>> is currently below?
>
> Hmm. I am even more confused.

Yeah, sorry, it sounds confusing, but I think we arrived now for that
specific part. :)

> So. I actually applied your patch. The code is
>
>        for (reaper = father->parent;
>             reaper != &init_task && reaper != pid_ns->child_reaper;
>             reaper = reaper->parent)
>                if (reaper->child_reaper)
>                        return reaper;
>
>        if (unlikely(pid_ns->child_reaper == father)) {
>                ...
>
> The lookup is already _before_ the check for pid_ns->child_reaper == father,
> what do you mean?

Yeah, it is before, but should be after.

> And, ignoring the mt problems I mentioned, I mean we should do
>
>        if (pid_ns->child_reaper == father) {
>
>                panic_or_kill_this_namespace;   // the current code
>
>        } else {
>                for (reaper = father->parent;
>                     reaper != pid_ns->child_reaper;
>                     reaper = reaper->parent)
>                        if (reaper->child_reaper)
>                                return reaper;
>        }

Yeah, clear now, it looks better to keep it in that order.

Thanks,
Kay
