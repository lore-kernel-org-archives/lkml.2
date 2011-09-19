Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836Ab1ISFtg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 01:49:36 -0400
Received: from mail-wy0-f170.google.com ([74.125.82.170]:46506 "EHLO
	mail-wy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab1ISFtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 01:49:35 -0400
MIME-Version: 1.0
In-Reply-To: <20110919041459.GJ2333@linux.vnet.ibm.com>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
	<1315332049-2604-41-git-send-email-paulmck@linux.vnet.ibm.com>
	<20110918040923.GA2363@zhy>
	<20110919041459.GJ2333@linux.vnet.ibm.com>
Date: Mon, 19 Sep 2011 13:49:33 +0800
Message-ID: <CAM2zO=B3FM3QrTB7yCTEoUZ5tF2734s8VEzgBnXLJK1uWkZdFA@mail.gmail.com>
Subject: Re: [PATCH tip/core/rcu 41/55] rcu: Permit rt_mutex_unlock() with
 irqs disabled
From: Yong Zhang <yong.zhang0@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Content-Type: multipart/mixed; boundary=0016364c7eaf4b850904ad44e86e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016364c7eaf4b850904ad44e86e
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 19, 2011 at 12:14 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Sun, Sep 18, 2011 at 12:09:23PM +0800, Yong Zhang wrote:
>> > diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
>> > index d3127e8..f6c63ea 100644
>> > --- a/kernel/rcutree_plugin.h
>> > +++ b/kernel/rcutree_plugin.h
>> > @@ -1149,6 +1149,8 @@ static void rcu_initiate_boost_trace(struct rcu_=
node *rnp)
>> >
>> > =C2=A0#endif /* #else #ifdef CONFIG_RCU_TRACE */
>> >
>> > +static struct lock_class_key rcu_boost_class;
>> > +
>> > =C2=A0/*
>> > =C2=A0 * Carry out RCU priority boosting on the task indicated by ->ex=
p_tasks
>> > =C2=A0 * or ->boost_tasks, advancing the pointer to the next task in t=
he
>> > @@ -1211,10 +1213,14 @@ static int rcu_boost(struct rcu_node *rnp)
>> > =C2=A0 =C2=A0 =C2=A0*/
>> > =C2=A0 =C2=A0 t =3D container_of(tb, struct task_struct, rcu_node_entr=
y);
>> > =C2=A0 =C2=A0 rt_mutex_init_proxy_locked(&mtx, t);
>> > + =C2=A0 /* Avoid lockdep false positives. =C2=A0This rt_mutex is its =
own thing. */
>> > + =C2=A0 lockdep_set_class_and_name(&mtx.wait_lock, &rcu_boost_class,
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0"rcu_boost_mutex");
>> > =C2=A0 =C2=A0 t->rcu_boost_mutex =3D &mtx;
>>
>> =C2=A0 =C2=A0 =C2=A0 raw_spin_unlock_irqrestore(&rnp->lock, flags); =C2=
=A0<=3D=3D=3D=3DA
>>
>> > =C2=A0 =C2=A0 rt_mutex_lock(&mtx); =C2=A0/* Side effect: boosts task t=
's priority. */
>> > =C2=A0 =C2=A0 rt_mutex_unlock(&mtx); =C2=A0/* Keep lockdep happy. */
>> > + =C2=A0 local_irq_restore(flags);
>>
>> Does it help here?
>> irq is enabled at A. So we still call rt_mutex_lock() with irq enabled.
>>
>> Seems should s/raw_spin_unlock_irqrestore/raw_spin_unlock ?
>
> Hmmm... =C2=A0The above works at least by accident, but I am clearly not
> testing calling rt_mutex_lock(&mtx) and rt_mutex_unlock(&mtx) with
> interrupts disabled anywhere near as heavily as I thought I was.
>
> I will fix this one way or the other.

Forget to mention: if we want to suppress the lockdep warning on
overlapping usage of rcu_read_*()/local_irq_*() like below:

rcu_read_lock();
...
local_irq_disable();
...
rcu_read_unlock();
...
local_irq_enable();

'rt_mutex_unlock(rbmp);' must also be surrounded by
local_irq_irqsave()/restore().

Untested patch is attached.

Thanks,
Yong

---
From: Yong Zhang <yong.zhang0@gmail.com>
Subject: [PATCH] rcu: Permit rt_mutex_unlock() with irqs disabled take#2

This make the below rcu usage really valid(AKA: lockdep
will not warn on it):

rcu_read_lock();
local_irq_disable();
rcu_read_unlock();
local_irq_enable();

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
---
 kernel/rcutree_plugin.h |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index e7eea74..d41a9b0 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -398,8 +398,11 @@ static noinline void
rcu_read_unlock_special(struct task_struct *t)

 #ifdef CONFIG_RCU_BOOST
 		/* Unboost if we were boosted. */
-		if (rbmp)
+		if (rbmp) {
+			local_irq_save(flags);
 			rt_mutex_unlock(rbmp);
+			local_irq_restore(flags);
+		}
 #endif /* #ifdef CONFIG_RCU_BOOST */

 		/*
@@ -1225,7 +1228,7 @@ static int rcu_boost(struct rcu_node *rnp)
 	lockdep_set_class_and_name(&mtx.wait_lock, &rcu_boost_class,
 				   "rcu_boost_mutex");
 	t->rcu_boost_mutex =3D &mtx;
-	raw_spin_unlock_irqrestore(&rnp->lock, flags);
+	raw_spin_unlock(&rnp->lock);
 	rt_mutex_lock(&mtx);  /* Side effect: boosts task t's priority. */
 	rt_mutex_unlock(&mtx);  /* Keep lockdep happy. */
 	local_irq_restore(flags);
--=20
1.7.4.1

--0016364c7eaf4b850904ad44e86e
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-rcu-Permit-rt_mutex_unlock-with-irqs-disabled-take-2.patch"
Content-Disposition: attachment; 
	filename="0001-rcu-Permit-rt_mutex_unlock-with-irqs-disabled-take-2.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gsr1c2dq0

RnJvbSA3ZDc0ZDFiODlhNGNkNGMwM2IzMGU0NzA0NGI3MTY5MTNmNjhiZDFkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBZb25nIFpoYW5nIDx5b25nLnpoYW5nMEBnbWFpbC5jb20+CkRh
dGU6IE1vbiwgMTkgU2VwIDIwMTEgMTM6NDI6MzIgKzA4MDAKU3ViamVjdDogW1BBVENIXSByY3U6
IFBlcm1pdCBydF9tdXRleF91bmxvY2soKSB3aXRoIGlycXMgZGlzYWJsZWQgdGFrZSMyCgpUaGlz
IG1ha2UgdGhlIGJlbG93IHJjdSB1c2FnZSByZWFsbHkgdmFsaWQoQUtBOiBsb2NrZGVwCndpbGwg
bm90IHdhcm4gb24gaXQpOgoKcmN1X3JlYWRfbG9jaygpOwpsb2NhbF9pcnFfZGlzYWJsZSgpOwpy
Y3VfcmVhZF91bmxvY2soKTsKbG9jYWxfaXJxX2VuYWJsZSgpOwoKU2lnbmVkLW9mZi1ieTogWW9u
ZyBaaGFuZyA8eW9uZy56aGFuZzBAZ21haWwuY29tPgotLS0KIGtlcm5lbC9yY3V0cmVlX3BsdWdp
bi5oIHwgICAgNyArKysrKy0tCiAxIGZpbGVzIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKSwgMiBk
ZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9rZXJuZWwvcmN1dHJlZV9wbHVnaW4uaCBiL2tlcm5l
bC9yY3V0cmVlX3BsdWdpbi5oCmluZGV4IGU3ZWVhNzQuLmQ0MWE5YjAgMTAwNjQ0Ci0tLSBhL2tl
cm5lbC9yY3V0cmVlX3BsdWdpbi5oCisrKyBiL2tlcm5lbC9yY3V0cmVlX3BsdWdpbi5oCkBAIC0z
OTgsOCArMzk4LDExIEBAIHN0YXRpYyBub2lubGluZSB2b2lkIHJjdV9yZWFkX3VubG9ja19zcGVj
aWFsKHN0cnVjdCB0YXNrX3N0cnVjdCAqdCkKIAogI2lmZGVmIENPTkZJR19SQ1VfQk9PU1QKIAkJ
LyogVW5ib29zdCBpZiB3ZSB3ZXJlIGJvb3N0ZWQuICovCi0JCWlmIChyYm1wKQorCQlpZiAocmJt
cCkgeworCQkJbG9jYWxfaXJxX3NhdmUoZmxhZ3MpOwogCQkJcnRfbXV0ZXhfdW5sb2NrKHJibXAp
OworCQkJbG9jYWxfaXJxX3Jlc3RvcmUoZmxhZ3MpOworCQl9CiAjZW5kaWYgLyogI2lmZGVmIENP
TkZJR19SQ1VfQk9PU1QgKi8KIAogCQkvKgpAQCAtMTIyNSw3ICsxMjI4LDcgQEAgc3RhdGljIGlu
dCByY3VfYm9vc3Qoc3RydWN0IHJjdV9ub2RlICpybnApCiAJbG9ja2RlcF9zZXRfY2xhc3NfYW5k
X25hbWUoJm10eC53YWl0X2xvY2ssICZyY3VfYm9vc3RfY2xhc3MsCiAJCQkJICAgInJjdV9ib29z
dF9tdXRleCIpOwogCXQtPnJjdV9ib29zdF9tdXRleCA9ICZtdHg7Ci0JcmF3X3NwaW5fdW5sb2Nr
X2lycXJlc3RvcmUoJnJucC0+bG9jaywgZmxhZ3MpOworCXJhd19zcGluX3VubG9jaygmcm5wLT5s
b2NrKTsKIAlydF9tdXRleF9sb2NrKCZtdHgpOyAgLyogU2lkZSBlZmZlY3Q6IGJvb3N0cyB0YXNr
IHQncyBwcmlvcml0eS4gKi8KIAlydF9tdXRleF91bmxvY2soJm10eCk7ICAvKiBLZWVwIGxvY2tk
ZXAgaGFwcHkuICovCiAJbG9jYWxfaXJxX3Jlc3RvcmUoZmxhZ3MpOwotLSAKMS43LjQuMQoK
--0016364c7eaf4b850904ad44e86e--
