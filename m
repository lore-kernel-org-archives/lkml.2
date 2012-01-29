Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506Ab2A2RpF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 12:45:05 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36262 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab2A2RpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 12:45:03 -0500
MIME-Version: 1.0
In-Reply-To: <20120129160711.GA20803@redhat.com>
References: <20120117174031.3118.E1E9C6FF@jp.fujitsu.com> <tip-b5740f4b2cb3503b436925eb2242bc3d75cd3dfe@git.kernel.org>
 <CA+55aFyO0KxGQxYYUqmVrNqG6qVFnRT2g-kYYKtH5QG3vTnO=A@mail.gmail.com> <20120129160711.GA20803@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 29 Jan 2012 09:44:42 -0800
X-Google-Sender-Auth: SmWaVp1XC8FDH7UACTkp0dCXots
Message-ID: <CA+55aFz20=H0ZubZEAmEbv0gL8j3C5Kgt4m2+5MU63uVipZt0Q@mail.gmail.com>
Subject: Re: [tip:sched/core] sched: Fix ancient race in do_exit()
To: Oleg Nesterov <oleg@redhat.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, y-goto@jp.fujitsu.com,
        akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
Content-Type: multipart/mixed; boundary=005045017caa190bd504b7ae4ae3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--005045017caa190bd504b7ae4ae3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 29, 2012 at 8:07 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 01/28, Linus Torvalds wrote:
>>
>> It would be much nicer to just clear the rwsem waiter->task thing
>> *after* waking the task up, which would avoid this race entirely,
>> afaik.
>
> How? The problem is that wake_up_process(tsk) sees this task in
> TASK_UNINTERRUPTIBLE state (the first "p->state & state" check in
> try_to_wake_up), but then this task changes its state to TASK_DEAD
> without schedule() and ttwu() does s/TASK_DEAD/TASK_RUNNING/.

Exactly.

The problem is that THE TASK HAS LONG SINCE GONE AWAY FROM THE RWSEM!

The task is already finishing up the exit (it might even have
*completed* the exit, which is why we take the extra reference count
to the task) when the wakeup happens.

THAT is the problem. The fact that in that big problem ("we do a
spurious wakeup for the rwsem long after the task no longer waits for
it") we then have a really small and tiny race (the race between
TASK_UNINTERRUPTIBLE -> (TASK_RUNNING ->) TASK_DEAD) is just a tiny
small detail.

So the real problem is that rwsem's are broken. Normal wakeups never
have this issue, because they use the spinlock for the waitqueue to
serialize: either a process wakes up in a timely manner, or the
process has removed itself from the wait-queue - you never see wakeups
long after the process has stopped caring.

The whole problem with the exit sequence is just a random detail. The
same spurious wakeup could happen in other places too - it just
doesn't happen to cause an Oops anywhere else (that we know about -
who knows if some code woudl be unhappy with getting woken up
unexpectedly).




>> Tell me, why wouldn't that work? rwsem_down_failed_common() does
>>
>> =A0 =A0 =A0 =A0 /* wait to be given the lock */
>> =A0 =A0 =A0 =A0 for (;;) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!waiter.task)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0...
>>
>> so then we wouldn't need the task refcount crap in rwsem either etc,
>> and we'd get rid of all races with wakeup.
>>
>> I wonder why we're clearing that whole waiter->task so early.
>
> I must have missed something. I can't understand how this can help,
> and "clear the rwsem waiter->task thing *after* waking" looks
> obviously wrong.

Why? It helps because it means that the task that did the "down()" on
the rwsem will *never* leave its task pointer around to be spuriously
woken later: it will wait for the waiter->task entry to be NULL - so
that we know that the wakeup path has used the task _and_ woken it up,
so there is no possibility for the task pointer still being active and
used to wake up some *random* state later.

> If we do this, then we can miss the "!!waiter.task"
> condition. The loop above actually does
>
> =A0 =A0 =A0 =A0set_task_state(TASK_UNINTERRUPTIBLE);
>
> =A0 =A0 =A0 =A0if (!waiter.task)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0schedule();
>
> and
> =A0 =A0 =A0 =A0wake_up_process(tsk);
> =A0 =A0 =A0 =A0waiter->task =3D NULL;
>
> can happen right after set_task_state().

So? That's the *point*. We want to wait until the wakeup is *done*
before we return from down(). We do *not* want to "break" (and go off
doing something else) while some other CPU may still be using 'task'.

But yes, if you're talking about TASK_UNINTERRUPTIBLE, we do need to
just remove the setting of that entirely. It needs to be set *before*
adding us to the list, not after. That's just a bug - we get woken up
when we've been given the lock.

IOW, I think the fix should look like the attched.  TOTALLY UNTESTED!
This is certainly a much scarier patch, but I think it fixes the
actual *reason* for the problem, rather than just working around the
symptom.

So it may be completely and utterly broken for some subtle reason, but
I don't see what it would be. It seems to clean up and simplify the
logic, and remove all the bogus workarounds for the fact that we used
to do things stupidly.

But maybe there's some reason for those "stupid" things. I just don't see i=
t.

                   Linus

--005045017caa190bd504b7ae4ae3
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gy0cww0b0

IGxpYi9yd3NlbS5jIHwgICAxMCArKy0tLS0tLS0tCiAxIGZpbGVzIGNoYW5nZWQsIDIgaW5zZXJ0
aW9ucygrKSwgOCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9saWIvcndzZW0uYyBiL2xpYi9y
d3NlbS5jCmluZGV4IDQxMGFhMTE4OWIxMy4uN2FmYjQwMzkxOGRhIDEwMDY0NAotLS0gYS9saWIv
cndzZW0uYworKysgYi9saWIvcndzZW0uYwpAQCAtOTIsMTAgKzkyLDkgQEAgX19yd3NlbV9kb193
YWtlKHN0cnVjdCByd19zZW1hcGhvcmUgKnNlbSwgaW50IHdha2VfdHlwZSkKIAkgKi8KIAlsaXN0
X2RlbCgmd2FpdGVyLT5saXN0KTsKIAl0c2sgPSB3YWl0ZXItPnRhc2s7CisJd2FrZV91cF9wcm9j
ZXNzKHRzayk7CiAJc21wX21iKCk7CiAJd2FpdGVyLT50YXNrID0gTlVMTDsKLQl3YWtlX3VwX3By
b2Nlc3ModHNrKTsKLQlwdXRfdGFza19zdHJ1Y3QodHNrKTsKIAlnb3RvIG91dDsKIAogIHJlYWRl
cnNfb25seToKQEAgLTE0NiwxMCArMTQ1LDkgQEAgX19yd3NlbV9kb193YWtlKHN0cnVjdCByd19z
ZW1hcGhvcmUgKnNlbSwgaW50IHdha2VfdHlwZSkKIAkJd2FpdGVyID0gbGlzdF9lbnRyeShuZXh0
LCBzdHJ1Y3QgcndzZW1fd2FpdGVyLCBsaXN0KTsKIAkJbmV4dCA9IHdhaXRlci0+bGlzdC5uZXh0
OwogCQl0c2sgPSB3YWl0ZXItPnRhc2s7CisJCXdha2VfdXBfcHJvY2Vzcyh0c2spOwogCQlzbXBf
bWIoKTsKIAkJd2FpdGVyLT50YXNrID0gTlVMTDsKLQkJd2FrZV91cF9wcm9jZXNzKHRzayk7Ci0J
CXB1dF90YXNrX3N0cnVjdCh0c2spOwogCX0KIAogCXNlbS0+d2FpdF9saXN0Lm5leHQgPSBuZXh0
OwpAQCAtMTgzLDcgKzE4MSw2IEBAIHJ3c2VtX2Rvd25fZmFpbGVkX2NvbW1vbihzdHJ1Y3Qgcndf
c2VtYXBob3JlICpzZW0sCiAJcmF3X3NwaW5fbG9ja19pcnEoJnNlbS0+d2FpdF9sb2NrKTsKIAl3
YWl0ZXIudGFzayA9IHRzazsKIAl3YWl0ZXIuZmxhZ3MgPSBmbGFnczsKLQlnZXRfdGFza19zdHJ1
Y3QodHNrKTsKIAogCWlmIChsaXN0X2VtcHR5KCZzZW0tPndhaXRfbGlzdCkpCiAJCWFkanVzdG1l
bnQgKz0gUldTRU1fV0FJVElOR19CSUFTOwpAQCAtMjExLDExICsyMDgsOCBAQCByd3NlbV9kb3du
X2ZhaWxlZF9jb21tb24oc3RydWN0IHJ3X3NlbWFwaG9yZSAqc2VtLAogCQlpZiAoIXdhaXRlci50
YXNrKQogCQkJYnJlYWs7CiAJCXNjaGVkdWxlKCk7Ci0JCXNldF90YXNrX3N0YXRlKHRzaywgVEFT
S19VTklOVEVSUlVQVElCTEUpOwogCX0KIAotCXRzay0+c3RhdGUgPSBUQVNLX1JVTk5JTkc7Ci0K
IAlyZXR1cm4gc2VtOwogfQogCg==
--005045017caa190bd504b7ae4ae3--
