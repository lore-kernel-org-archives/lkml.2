Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758695Ab2BJCRJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 21:17:09 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52436 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683Ab2BJCRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 21:17:07 -0500
MIME-Version: 1.0
In-Reply-To: <20120209021855.GA26152@zhy>
References: <1328560933-3037-1-git-send-email-venki@google.com>
	<20120208065115.GA19691@zhy>
	<CABeCy1bAB6PSAUabk8zO8oh_sLVo3sOPVrr_kSovLdmOOtkfTg@mail.gmail.com>
	<20120209021855.GA26152@zhy>
Date: Thu, 9 Feb 2012 18:17:06 -0800
Message-ID: <CABeCy1YcELDiFB0rdSCKGgPm7RE5MkQL9v-9xOHfwn5SP3iVeA@mail.gmail.com>
Subject: Re: [RFC] Extend mwait idle to optimize away IPIs when possible
From: Venki Pallipadi <venki@google.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Aaron Durbin <adurbin@google.com>, Paul Turner <pjt@google.com>,
        linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=e89a8f6465ada7ff6804b892b90d
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e89a8f6465ada7ff6804b892b90d
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 8, 2012 at 6:18 PM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> On Wed, Feb 08, 2012 at 03:28:45PM -0800, Venki Pallipadi wrote:
>> On Tue, Feb 7, 2012 at 10:51 PM, Yong Zhang <yong.zhang0@gmail.com> wrot=
e:
>> > On Mon, Feb 06, 2012 at 12:42:13PM -0800, Venkatesh Pallipadi wrote:
>> >> smp_call_function_single and ttwu_queue_remote sends unconditional IP=
I
>> >> to target CPU. However, if the target CPU is in mwait based idle, we =
can
>> >> do IPI-less wakeups using the magical powers of monitor-mwait.
>> >> Doing this has certain advantages:
>> >
>> > Actually I'm trying to do the similar thing on MIPS.
>> >
>> > The difference is that I want task_is_polling() to do something. The b=
asic
>> > idea is:
>> >
>> >> + ? ? ? ? ? ? ? ? ? ? if (ipi_pending()) {
>> >> + ? ? ? ? ? ? ? ? ? ? ? ? ? ? clear_ipi_pending();
>> >> + ? ? ? ? ? ? ? ? ? ? ? ? ? ? local_bh_disable();
>> >> + ? ? ? ? ? ? ? ? ? ? ? ? ? ? local_irq_disable();
>> >> + ? ? ? ? ? ? ? ? ? ? ? ? ? ? generic_smp_call_function_single_interr=
upt();
>> >> + ? ? ? ? ? ? ? ? ? ? ? ? ? ? scheduler_wakeup_self_check();
>> >> + ? ? ? ? ? ? ? ? ? ? ? ? ? ? local_irq_enable();
>> >> + ? ? ? ? ? ? ? ? ? ? ? ? ? ? local_bh_enable();
>> >
>> > I let cpu_idle() check if there is anything to do as your above code.
>> >
>> > And task_is_polling() handle the others with below patch:
>> > ---
>> > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> > index 5255c9d..09f633d 100644
>> > --- a/kernel/sched/core.c
>> > +++ b/kernel/sched/core.c
>> > @@ -527,15 +527,16 @@ void resched_task(struct task_struct *p)
>> > ? ? ? ? ? ? ? ?smp_send_reschedule(cpu);
>> > ?}
>> >
>> > -void resched_cpu(int cpu)
>> > +int resched_cpu(int cpu)
>> > ?{
>> > ? ? ? ?struct rq *rq =3D cpu_rq(cpu);
>> > ? ? ? ?unsigned long flags;
>> >
>> > ? ? ? ?if (!raw_spin_trylock_irqsave(&rq->lock, flags))
>> > - ? ? ? ? ? ? ? return;
>> > + ? ? ? ? ? ? ? return 0;
>> > ? ? ? ?resched_task(cpu_curr(cpu));
>> > ? ? ? ?raw_spin_unlock_irqrestore(&rq->lock, flags);
>> > + ? ? ? return 1;
>> > ?}
>>
>
> I assume we are talking about 'return from idle' but seems I don't
> make it clear.
>
>> Two points -
>> rq->lock: I tried something similar first. One hurdle with checking
>> task_is_polling() is that you need rq->lock to check it. And adding
>> lock+unlock (without wait) in wakeup path ended up being no net gain
>> compared to IPI. And when we actually end up spinning on that lock,
>> thats going to add overhead in the common path. That is the reason I
>> switched to atomic compare exchange and moving any wait onto the
>> target CPU coming out of idle.
>
> I see. But actually we will not spinning on that lock because we
> use 'trylock' in resched_cpu().

Ahh. Sorry I missed the trylock in there...

> And you are right there is indeed a
> little overhead (resched_task()) if we hold the lock but it can be
> tolerated IMHO.

One advantage I got by using atomic stuff instead of rq->lock was as I
mentioned in the patch description, if 2 CPUs are trying to send IPI
to same target CPU around same time (50-100 us if CPU is in deep
C-state in x86).

>
> BTW, mind showing you test case thus we can collect some common data?

Test case was a silly clock measure around
__smp_call_function_single() with optimization I had in
generic_exec_single(). Attaching the patch I had..

>>
>> resched_task: ttwu_queue_remote() does not imply that the remote CPU
>> will do a resched. Today there is a IPI and IPI handler calls onto
>> check_preempt_wakeup() and if the current task has higher precedence
>> than the waking up task, then there will be just an activation of new
>> task and no resched. Using resched_task above breaks
>> check_preempt_wakeup() and always calls a resched on remote CPU after
>> the IPI, which would be change in behavior.
>
> Yeah, if the remote cpu is not idle, mine will change the behavior; but
> if the remote cpu is idle, it will always rescheduled, right?
>
> So maybe we could introduce resched_idle_cpu() to make things more clear:
>
> int resched_idle_cpu(int cpu)
> {
> =A0 =A0 =A0 =A0struct rq *rq =3D cpu_rq(cpu);
> =A0 =A0 =A0 =A0unsigned long flags;
> =A0 =A0 =A0 =A0int ret =3D 0;
>
> =A0 =A0 =A0 =A0if (!raw_spin_trylock_irqsave(&rq->lock, flags))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> =A0 =A0 =A0 =A0if (!idle_cpu(cpu))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out_unlock;
> =A0 =A0 =A0 =A0resched_task(cpu_curr(cpu));
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D 1;
> out_unlock:
> =A0 =A0 =A0 =A0raw_spin_unlock_irqrestore(&rq->lock, flags);
> out:
> =A0 =A0 =A0 =A0return ret;
> }
>

This should likely work. But, if you do want to use similar logic in
smp_call_function() or idle load balance kick etc, you need additional
bit other than need_resched() as there we only need irq+softirq and
not necessarily a resched.
At this time I am not sure how poll wakeup logic works in MIPS. But,
if it is something that is similar to x86 mwait and we can wakeup with
a bit other than TIF_NEED_RESCHED, we can generalize most of the
changes in my RFC and share it across archs.

-Venki

>>
>> >
>> > ?#ifdef CONFIG_NO_HZ
>> > @@ -1484,7 +1485,8 @@ void scheduler_ipi(void)
>> >
>> > ?static void ttwu_queue_remote(struct task_struct *p, int cpu)
>> > ?{
>> > - ? ? ? if (llist_add(&p->wake_entry, &cpu_rq(cpu)->wake_list))
>> > + ? ? ? if (llist_add(&p->wake_entry, &cpu_rq(cpu)->wake_list) &&
>> > + ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? !resched_cpu(cpu))
>> > ? ? ? ? ? ? ? ?smp_send_reschedule(cpu);
>> > ?}
>> >
>> > Thought?
>> >
>> > Thanks,
>> > Yong
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" =
in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at =A0http://www.tux.org/lkml/
>
> --
> Only stand for myself

--e89a8f6465ada7ff6804b892b90d
Content-Type: text/x-patch; charset=US-ASCII; name="0003-test-ipicost-test-routine.patch"
Content-Disposition: attachment; 
	filename="0003-test-ipicost-test-routine.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gygl4l8p1

RnJvbSBmZDBmMzQ5YmZmZGY2MWZkYThhODA4NWI0MzVlYzQwZDlkZGZiYTMzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBWZW5rYXRlc2ggUGFsbGlwYWRpIDx2ZW5raUBnb29nbGUuY29t
PgpEYXRlOiBXZWQsIDEgRmViIDIwMTIgMTc6MDI6NTkgLTA4MDAKU3ViamVjdDogW1BBVENIIDMv
NV0gdGVzdDogaXBpY29zdCB0ZXN0IHJvdXRpbmUKClNpbGx5IHRlc3QgdG8gbWVhc3VyZSBpcGlj
b3N0LgokIHRhc2tzZXQgMHgxIGNhdCAvcHJvYy9pcGljb3N0OyBkbWVzZyB8IHRhaWwgLSQoKCQo
Z3JlcCBwcm9jZXNzb3IgL3Byb2MvY3B1aW5mbyB8IHdjIC1sKSoyKSkKClNpZ25lZC1vZmYtYnk6
IFZlbmthdGVzaCBQYWxsaXBhZGkgPHZlbmtpQGdvb2dsZS5jb20+Ci0tLQogZnMvcHJvYy9NYWtl
ZmlsZSAgfCAgICAyICstCiBmcy9wcm9jL2lwaWNvc3QuYyB8ICAxMDcgKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysKIDIgZmlsZXMgY2hhbmdlZCwg
MTA4IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb25zKC0pCiBjcmVhdGUgbW9kZSAxMDA2NDQgZnMv
cHJvYy9pcGljb3N0LmMKCmRpZmYgLS1naXQgYS9mcy9wcm9jL01ha2VmaWxlIGIvZnMvcHJvYy9N
YWtlZmlsZQppbmRleCBjMWM3MjkzLi40NDA3YzZmIDEwMDY0NAotLS0gYS9mcy9wcm9jL01ha2Vm
aWxlCisrKyBiL2ZzL3Byb2MvTWFrZWZpbGUKQEAgLTgsNyArOCw3IEBAIHByb2MteQkJCTo9IG5v
bW11Lm8gdGFza19ub21tdS5vCiBwcm9jLSQoQ09ORklHX01NVSkJOj0gbW11Lm8gdGFza19tbXUu
bwogCiBwcm9jLXkgICAgICAgKz0gaW5vZGUubyByb290Lm8gYmFzZS5vIGdlbmVyaWMubyBhcnJh
eS5vIFwKLQkJcHJvY190dHkubworCQlwcm9jX3R0eS5vIGlwaWNvc3QubwogcHJvYy15CSs9IGNt
ZGxpbmUubwogcHJvYy15CSs9IGNvbnNvbGVzLm8KIHByb2MteQkrPSBjcHVpbmZvLm8KZGlmZiAt
LWdpdCBhL2ZzL3Byb2MvaXBpY29zdC5jIGIvZnMvcHJvYy9pcGljb3N0LmMKbmV3IGZpbGUgbW9k
ZSAxMDA2NDQKaW5kZXggMDAwMDAwMC4uOTY3MjAxZAotLS0gL2Rldi9udWxsCisrKyBiL2ZzL3By
b2MvaXBpY29zdC5jCkBAIC0wLDAgKzEsMTA3IEBACisjaW5jbHVkZSA8bGludXgvZnMuaD4KKyNp
bmNsdWRlIDxsaW51eC9zbXAuaD4KKyNpbmNsdWRlIDxsaW51eC9pbml0Lmg+CisjaW5jbHVkZSA8
bGludXgvZGVsYXkuaD4KKyNpbmNsdWRlIDxsaW51eC90aW1lci5oPgorI2luY2x1ZGUgPGxpbnV4
L3Byb2NfZnMuaD4KKyNpbmNsdWRlIDxsaW51eC9zZXFfZmlsZS5oPgorCisjZGVmaW5lIFJFUF9D
T1VOVAkxMDAKKworc3RhdGljIGludCBkdW1teV9jb3VudDsKK3N0YXRpYyB1NjQgcmVjdl9zdW07
CisKK3N0YXRpYyB2b2lkIGR1bW15X2lwaSh2b2lkICppbnRpbWUpCit7CisJdTY0IHN0YXJ0LCBj
dXJyOworCXN0YXJ0ID0gKHU2NClpbnRpbWU7CisJcmR0c2NsbChjdXJyKTsKKwlyZWN2X3N1bSAr
PSAoY3VyciAtIHN0YXJ0KTsKKwlkdW1teV9jb3VudCsrOworfQorCitzdGF0aWMgaW50IHNob3df
aXBpY29zdChzdHJ1Y3Qgc2VxX2ZpbGUgKm0sIHZvaWQgKnYpCit7CisJaW50IGk7CisJaW50IGNv
dW50OworCXN0cnVjdCBjYWxsX3NpbmdsZV9kYXRhIGNzZDsKKworCWNzZC5mbGFncyA9IDA7CisJ
Y3NkLmZ1bmMgPSAmZHVtbXlfaXBpOworCWNzZC5pbmZvID0gTlVMTDsKKworCWZvcl9lYWNoX29u
bGluZV9jcHUoaSkgeworCQl1NjQgc3RhcnQsIHN0b3AsIHN1bTsKKworCQlzdW0gPSAwOworCQly
ZWN2X3N1bSA9IDA7CisJCWR1bW15X2NvdW50ID0gMDsKKwkJZm9yIChjb3VudCA9IDA7IGNvdW50
IDwgUkVQX0NPVU5UOyBjb3VudCsrKSB7CisJCQlyZHRzY2xsKHN0YXJ0KTsKKwkJCWNzZC5pbmZv
ID0gKHZvaWQgKilzdGFydDsKKwkJCV9fc21wX2NhbGxfZnVuY3Rpb25fc2luZ2xlKGksICZjc2Qs
IDApOworCQkJcmR0c2NsbChzdG9wKTsKKwkJCXN1bSArPSAoc3RvcCAtIHN0YXJ0KTsKKwkJCW1z
bGVlcCgxKTsKKwkJfQorCQlwcmludGsoIjAgQ1BVICVkLCB0aW1lICVMdSwgcmVjdiAlTHUsIGNv
dW50ICVkXG4iLCBpLCBzdW0gLyBSRVBfQ09VTlQsIHJlY3Zfc3VtIC8gUkVQX0NPVU5ULCBkdW1t
eV9jb3VudCk7CisJfQorCisJZm9yX2VhY2hfb25saW5lX2NwdShpKSB7CisJCXU2NCBzdGFydCwg
c3RvcCwgc3VtOworCisJCXN1bSA9IDA7CisJCXJlY3Zfc3VtID0gMDsKKwkJZHVtbXlfY291bnQg
PSAwOworCQlmb3IgKGNvdW50ID0gMDsgY291bnQgPCBSRVBfQ09VTlQ7IGNvdW50KyspIHsKKwkJ
CXJkdHNjbGwoc3RhcnQpOworCQkJY3NkLmluZm8gPSAodm9pZCAqKXN0YXJ0OworCQkJX19zbXBf
Y2FsbF9mdW5jdGlvbl9zaW5nbGUoaSwgJmNzZCwgMSk7CisJCQlyZHRzY2xsKHN0b3ApOworCQkJ
c3VtICs9IChzdG9wIC0gc3RhcnQpOworCQkJbXNsZWVwKDEpOworCQl9CisJCXByaW50aygiMSBD
UFUgJWQsIHRpbWUgJUx1LCByZWN2ICVMdSwgY291bnQgJWRcbiIsIGksIHN1bSAvIFJFUF9DT1VO
VCwgcmVjdl9zdW0gLyBSRVBfQ09VTlQsIGR1bW15X2NvdW50KTsKKwl9CisJcmV0dXJuIDA7Cit9
CisKK3N0YXRpYyB2b2lkICpjX3N0YXJ0KHN0cnVjdCBzZXFfZmlsZSAqbSwgbG9mZl90ICpwb3Mp
Cit7CisJcmV0dXJuICh2b2lkICopMTsKK30KKworc3RhdGljIHZvaWQgKmNfbmV4dChzdHJ1Y3Qg
c2VxX2ZpbGUgKm0sIHZvaWQgKnYsIGxvZmZfdCAqcG9zKQoreworCXJldHVybiBOVUxMOworfQor
CitzdGF0aWMgdm9pZCBjX3N0b3Aoc3RydWN0IHNlcV9maWxlICptLCB2b2lkICp2KQoreworfQor
CitzdGF0aWMgY29uc3Qgc3RydWN0IHNlcV9vcGVyYXRpb25zIGlwaWNvc3Rfb3AgPSB7CisJLnN0
YXJ0CT0gY19zdGFydCwKKwkubmV4dAk9IGNfbmV4dCwKKwkuc3RvcAk9IGNfc3RvcCwKKwkuc2hv
dwk9IHNob3dfaXBpY29zdCwKK307CisKK3N0YXRpYyBpbnQgaXBpY29zdF9vcGVuKHN0cnVjdCBp
bm9kZSAqaW5vZGUsIHN0cnVjdCBmaWxlICpmaWxlKQoreworCXJldHVybiBzZXFfb3BlbihmaWxl
LCAmaXBpY29zdF9vcCk7Cit9CisKK3N0YXRpYyBjb25zdCBzdHJ1Y3QgZmlsZV9vcGVyYXRpb25z
IHByb2NfaXBpY29zdF9vcGVyYXRpb25zID0geworCS5vcGVuCQk9IGlwaWNvc3Rfb3BlbiwKKwku
cmVhZAkJPSBzZXFfcmVhZCwKKwkubGxzZWVrCQk9IHNlcV9sc2VlaywKKwkucmVsZWFzZQk9IHNl
cV9yZWxlYXNlLAorfTsKKworc3RhdGljIGludCBfX2luaXQgcHJvY19pcGljb3N0X2luaXQodm9p
ZCkKK3sKKwlwcm9jX2NyZWF0ZSgiaXBpY29zdCIsIDAsIE5VTEwsICZwcm9jX2lwaWNvc3Rfb3Bl
cmF0aW9ucyk7CisJcmV0dXJuIDA7Cit9Cittb2R1bGVfaW5pdChwcm9jX2lwaWNvc3RfaW5pdCk7
Ci0tIAoxLjcuNy4zCgo=
--e89a8f6465ada7ff6804b892b90d--
