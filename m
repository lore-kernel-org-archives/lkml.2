Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652Ab1FBO56 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 10:57:58 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51778 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab1FBO55 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 10:57:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=VPiw5PBmGiUKaDe1TcJzfk/J/KjquBfJ3nS1Nxa8OtWsbztrn3IEquafq+Z3zu6Sag
         rUya+Mowi7J2NpYAV0gxc+fX3cgmqbMMus8A8LrgGtZMvRNCoEEKIspZAogK4l6ZfQ5q
         jvnOa0naN0Dp70C6oPkZCUXMplsZzA/JFXpww=
MIME-Version: 1.0
In-Reply-To: <20110602123105.GD10410@mtj.dyndns.org>
References: <1306710760-16440-1-git-send-email-tj@kernel.org>
 <20110530154211.GA11325@redhat.com> <20110601053903.GE23067@mtj.dyndns.org> <20110602123105.GD10410@mtj.dyndns.org>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Thu, 2 Jun 2011 16:51:48 +0200
Message-ID: <BANLkTik5hV8dnyspyGz8YAAdtoQNQDyOSw@mail.gmail.com>
Subject: Re: [PATCHSET ptrace] ptrace: implement PTRACE_SEIZE/INTERRUPT and
 group stop notification, take#4
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        pedro@codesourcery.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 2, 2011 at 2:31 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Oleg.
>
> On Wed, Jun 01, 2011 at 02:39:03PM +0900, Tejun Heo wrote:
>> I'll test different corner cases (different thread doing
>> waking/sleeping, race against INTERRUPT kind of things) and let you
>> know how it goes.
>
> I've tested threaded one and INTERRUPT immediate re-triggering and at
> least the apparent cases work fine.  I've re-generated the git tree on
> top of 3.0-rc1 with the updated patches.
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-ptrace-seize
>
> The commit ID should be 7eae14288e745cfaabeb035fa67f89eb63a1aff7.  As
> git.korg seems to be taking quite a while to sync, it might be a
> better idea to pull from master.korg.
>
>  ssh://master.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-ptrace-seize
>
> IIRC, pending issues are...
>
> * Which signo to use in exit_code on STOP traps.

SIGSTOP/TSTP/TTIN/TTOU on entering group-stop,
SIGCONT on leaving group-stop.

> * Implicit signal on clone.

Best if it is converted to STOP trap (the same is one caused by INTERRUPT).

I guess this may be optionally changed
(similar to how PTRACE_O_TRACEEXEC
changes post-execve SIGTRAP into PTRACE_EVENT_EXEC).

Why not turn it on *unconditionally* on SEIZE?
Because otherwise ptrace users will turn into

if (we_used_SEIZE)
    do_something;
else
    do_something_else;

maze, which is maintenance nightmare.
It's possible users will opt to not use new functionality at all
instead of going that way.

If everything is monolithically tied into SEIZE, users won't be able
to opt to use only easy parts of new functionality (such as
PTRACE_INTERRUPT and PTRACE_LISTEN) if this *forces* them
to also use harder parts of new functionality, in this case
forces them to double and obfuscate their existing code
which handles SIGSTOP-on-child-auto-attach. They don't really
want to, since this SIGSTOP *in practice* isn't that problematic.


> * What to do about events which are reported by genuine SIGTRAP
>  generation?

I don't understand what you meant here. Example(s)?


> * Group leader exit issue.

Ohhh this is an ugly one. It turns out it is linked to the question
of "how execve works under ptrace", in a non-obvious way.
I will respond in the second thread, with an example of current
kernel's breakage.

-- 
vda
