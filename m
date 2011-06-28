Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab1F1B0R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 21:26:17 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53851 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517Ab1F1BYZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 21:24:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=I0zT1eNEsc8VUbxOQnN38zDisMxs9zYUAv2R4sPdmcYIPTnvnMuhBChztno5QfOi3c
         lwlWS0Y5VCW7JZOUgu+y/Spx1U9q92ebEnoJ3Z3SUQX8oF7JYMHV0A5NVPyHU0sOzR+w
         pYd6K/cLsISbs3D/+PTVoGjpgf1+AWFXfJ+L0=
MIME-Version: 1.0
In-Reply-To: <20110627085242.GA6635@albatros>
References: <1308917318-4749-1-git-send-email-segoon@openwall.com>
	<4E07F1C0.2070305@jp.fujitsu.com>
	<20110627070300.GA4463@albatros>
	<4E08324D.9040605@jp.fujitsu.com>
	<20110627085242.GA6635@albatros>
Date: Tue, 28 Jun 2011 06:54:25 +0530
Message-ID: <BANLkTimFkb1TK_u+Xqp6LnRgzMAv21jFHg@mail.gmail.com>
Subject: Re: [PATCH 1/2] proc: restrict access to /proc/PID/io
From: Balbir Singh <bsingharora@gmail.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com,
        akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        rientjes@google.com, wilsons@start.ca, security@kernel.org,
        eparis@redhat.com, kernel-hardening@lists.openwall.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 27, 2011 at 2:22 PM, Vasiliy Kulikov <segoon@openwall.com> wrote:
> (cc'ed Linus)
>
> On Mon, Jun 27, 2011 at 16:33 +0900, KOSAKI Motohiro wrote:
>> (2011/06/27 16:03), Vasiliy Kulikov wrote:
>> > On Mon, Jun 27, 2011 at 11:58 +0900, KOSAKI Motohiro wrote:
>> >> (2011/06/24 21:08), Vasiliy Kulikov wrote:
>> >>> /proc/PID/io may be used for gathering private information.  E.g. for
>> >>> openssh and vsftpd daemons wchars/rchars may be used to learn the
>> >>> precise password length.  Restrict it to processes being able to ptrace
>> >>> the target process.
>> >>>
>> >>> ptrace_may_access() is needed to prevent keeping open file descriptor of
>> >>> "io" file, executing setuid binary and gathering io information of the
>> >>> setuid'ed process.
>> >>>
>> >>> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
>> >>
>> >> This description seems makes sense to me. But Vasilly, I have one question.
>> >> Doesn't this change break iotop command or other userland tools?
>> >
>> > I don't use iotop, but after reading the sources it looks like it uses
>> > taskstats for information gathering, which will be broken for sure by
>> > the second patch.  All other userland tools using alien io files will be
>> > broken too.
>> >
>> > I'd say the whole approach of world readable debugging/statistics
>> > information was broken from the beginning, now we are stuck with these
>> > interfaces because of acient mistakes.
>>
>> Just idea. (perhaps it's too dumb).
>>
>> If a user want to know throughput, usually they only need KB/s granularity.
>> If a user want to know password hints, they need to know strict bytes granularity.
>> So, adding some random bytes to this statistics may help to obscure key data,
>> or just "stat = ROUND_UP(stat, 1024)".
>>
>> But, I hope to wait another experts response. they may know better approach. :)
>
> Yep, Linus has already suggested a similar thing:
> http://www.openwall.com/lists/oss-security/2011/06/27/4
>

I think this is a good idea

> As to random bytes - if it is very predictable (e.g. rand() % 10000) one
> may restore the original value.  But it would still do much harm to good
> programs (io stats going up and down!).  Adding really random bytes
> seems somewhat too complicated for these needs to me.
>
> As to rounding - this is a workaround, not a fix.  What if some program
> reads one byte from tty and then do some io activity exactly of 1kb-1?
> Then you just measure kbs and get original tty activity.  (just a crazy
> example to show that it is not a full solution.)
>

That would happen with a probability of 1/1024

>
> Without any proof/estimate, just an idea: it's possible to get not only
> password length, which needs as much granularity as possible, but
> another information, which doesn't need any strict value.  E.g.
> statistics changing, what should indicate that some significant event
> has just happened.
>

Statistics would change a KB granularity, so yes if large KB's of IO
happen, you can figure things are changing (even top can give that
information), but that also means you have larger area to look at,
with small changes they might go unnoticed unless the KB boundary is
hit.

>
>> >>> ---
>> >>>  fs/proc/base.c |    7 +++++--
>> >>>  1 files changed, 5 insertions(+), 2 deletions(-)
>> >>>
>> >>> diff --git a/fs/proc/base.c b/fs/proc/base.c
>> >>> index 14def99..5ae25d1 100644
>> >>> --- a/fs/proc/base.c
>> >>> +++ b/fs/proc/base.c
>> >>> @@ -2712,6 +2712,9 @@ static int do_io_accounting(struct task_struct *task, char *buffer, int whole)
>> >>>   struct task_io_accounting acct = task->ioac;
>> >>>   unsigned long flags;
>> >>>
>> >>> + if (!ptrace_may_access(task, PTRACE_MODE_READ))
>> >>> +         return -EACCES;
>> >>> +
>> >>
>> >> I think this check need a comment. Usually procfs don't use ptrace_may_access() directly
>> >> (see mm_for_maps) because it's racy against exec().
>> >
>> > This makes sense.  Reading /proc/self/io and exec'ing setuid program
>> > would cause the race.  What lock should I use to block execve()?
>> >
>> >
>> > Also I'm worried about these statistics after dropping the privileges.
>> > After setuid() and similar things not changing pid unprivileged user
>> > gets some information about the previous io activity of this task being
>> > privileged.  In some situations it doesn't reveal any sensitive
>> > information, in some it might.  Clearing taskstats on credential
>> > changing functions would totally break taskstats' interfaces; and should
>> > be temporary changing fsuid/euid followed by reverting it considered
>> > harmfull?  I don't know.
>>
>> Can you please explain more? I'm feeling "reset at credential change" is
>> reasonable idea. How broken is there?
>
> In the code I see taskstats statistics is kept untouched, so it would
> break userspace assumptions about the statistics.
>

Could you please elaborate on this point?

>
>> >> However I think your code is ok.
>> >> because a few bytes io accounting leak has no big matter.
>> >
>> > Please don't do any assumptions about the significance of these few
>> > bytes.  It can be not "few" bytes if either the scheduler's granularity
>> > is significant or the scheduler does wrong assumptions about CPU speeds.
>> > Also if someone gets CAP_SYS_NICE he may totally break these assumptions.
>> >
>> > My ssh example is just a proof that io stat is harmfull *sometimes*.
>> > I didn't investigate in what cases it is harmless for sure (if it's
>> > possible at all).
>>
>> Umm. reasonable. task->signal->cred_guard_mutex can be used for preventing
>> exec() race, I think. (see check_mem_permission() and et al).
>
> (the same should go into the taskstats fix)
>
> Looks sane, thank you!

Balbir Singh
