Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab1F1CxW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 22:53:22 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33763 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756160Ab1F1Cvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 22:51:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=QkR7mNAF9Nqs6Q9oq42tnORARc5Jg4kTB4jtKqfaSD8oROZTbckpjMfrD9xN8GJz0T
         DMFYhAkxVhHzvSZXQmC4Jliw1AgZQ3ucoUuQqpAiuySKXhkzt9XjHl2XMPUDnz17HZWt
         dQwM1zQWwfxnYp6A2aE5HyMu84laqSUviSAMM=
MIME-Version: 1.0
In-Reply-To: <BANLkTinacDgzZenwmG4==1gYfEaQg-YQ-g@mail.gmail.com>
References: <BANLkTikKRnQb_T5x1BA=WopbBA_weLNFoQ@mail.gmail.com>
	<4E0321AD.2080308@linux.vnet.ibm.com>
	<BANLkTinacDgzZenwmG4==1gYfEaQg-YQ-g@mail.gmail.com>
Date: Tue, 28 Jun 2011 10:51:31 +0800
Message-ID: <BANLkTi=87P3RoTF_UEtamNfc_XGxQXE__Q@mail.gmail.com>
Subject: [PATCH V2] sched: skip autogroup when looking for all rt sched groups
From: Yong Zhang <yong.zhang0@gmail.com>
To: Cheng Xu <chengxu@linux.vnet.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>
Content-Type: multipart/mixed; boundary=20cf302d49c6c9964504a6bcbedd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf302d49c6c9964504a6bcbedd
Content-Type: text/plain; charset=UTF-8

From: Yong Zhang <yong.zhang0@gmail.com>
Subject: [PATCH V2] sched: skip autogroup when looking for all rt sched groups

Since [commit ec514c48: sched: Fix rt_rq runtime leakage bug],
'cat /proc/sched_debug' will print data of root_task_group.rt_rq
multi times, this is due to autogroup has no its own rt group,
instead rt group of autogroup is linked to root_task_group.

So skip it when we are looking for all rt sched groups, and it
will also save some noop operation against root_task_group when
__disable_runtime()/__enable_runtime().

V2: Based on Cheng Xu's idea which uses less code.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Cheng Xu <chengxu@linux.vnet.ibm.com>
---

Attach it too in case webmail will mangle the patch.

 kernel/sched_autogroup.h |    1 +
 kernel/sched_rt.c        |   22 +++++++++++++++++-----
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/kernel/sched_autogroup.h b/kernel/sched_autogroup.h
index 0557705..c2f0e72 100644
--- a/kernel/sched_autogroup.h
+++ b/kernel/sched_autogroup.h
@@ -13,6 +13,7 @@ struct autogroup {
 	int			nice;
 };

+static inline bool task_group_is_autogroup(struct task_group *tg);
 static inline struct task_group *
 autogroup_task_group(struct task_struct *p, struct task_group *tg);

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 10d0182..8c04cb2 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -185,11 +185,23 @@ static inline u64 sched_rt_period(struct rt_rq *rt_rq)

 typedef struct task_group *rt_rq_iter_t;

-#define for_each_rt_rq(rt_rq, iter, rq) \
-	for (iter = list_entry_rcu(task_groups.next, typeof(*iter), list); \
-	     (&iter->list != &task_groups) && \
-	     (rt_rq = iter->rt_rq[cpu_of(rq)]); \
-	     iter = list_entry_rcu(iter->list.next, typeof(*iter), list))
+static inline struct task_group *next_task_group(struct task_group *tg)
+{
+	do {
+		tg = list_entry_rcu(tg->list.next,
+			typeof(struct task_group), list);
+	} while (&tg->list != &task_groups && task_group_is_autogroup(tg));
+
+	if (&tg->list == &task_groups)
+		tg = NULL;
+
+	return tg;
+}
+
+#define for_each_rt_rq(rt_rq, iter, rq)					\
+	for (iter = container_of(&task_groups, typeof(*iter), list);	\
+		(iter = next_task_group(iter)) &&			\
+		(rt_rq = iter->rt_rq[cpu_of(rq)]);)

 static inline void list_add_leaf_rt_rq(struct rt_rq *rt_rq)
 {
-- 
1.7.4.1

--20cf302d49c6c9964504a6bcbedd
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-sched-skip-autogroup-when-looking-for-all-rt-sched-g.patch"
Content-Disposition: attachment; 
	filename="0001-sched-skip-autogroup-when-looking-for-all-rt-sched-g.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gpg9f25b0

RnJvbSBlOGZmY2NhOTcxODE1YmE1MGQ2YTgzZTBhY2Q2OTJhZWU4NzRlMTA2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBZb25nIFpoYW5nIDx5b25nLnpoYW5nMEBnbWFpbC5jb20+CkRh
dGU6IFdlZCwgMjIgSnVuIDIwMTEgMTI6NTI6NDAgKzA4MDAKU3ViamVjdDogW1BBVENIIFYyXSBz
Y2hlZDogc2tpcCBhdXRvZ3JvdXAgd2hlbiBsb29raW5nIGZvciBhbGwgcnQgc2NoZWQgZ3JvdXBz
CgpTaW5jZSBbY29tbWl0IGVjNTE0YzQ4OiBzY2hlZDogRml4IHJ0X3JxIHJ1bnRpbWUgbGVha2Fn
ZSBidWddLAonY2F0IC9wcm9jL3NjaGVkX2RlYnVnJyB3aWxsIHByaW50IGRhdGEgb2Ygcm9vdF90
YXNrX2dyb3VwLnJ0X3JxCm11bHRpIHRpbWVzLCB0aGlzIGlzIGR1ZSB0byBhdXRvZ3JvdXAgaGFz
IG5vIGl0cyBvd24gcnQgZ3JvdXAsCmluc3RlYWQgcnQgZ3JvdXAgb2YgYXV0b2dyb3VwIGlzIGxp
bmtlZCB0byByb290X3Rhc2tfZ3JvdXAuCgpTbyBza2lwIGl0IHdoZW4gd2UgYXJlIGxvb2tpbmcg
Zm9yIGFsbCBydCBzY2hlZCBncm91cHMsIGFuZCBpdAp3aWxsIGFsc28gc2F2ZSBzb21lIG5vb3Ag
b3BlcmF0aW9uIGFnYWluc3Qgcm9vdF90YXNrX2dyb3VwIHdoZW4KX19kaXNhYmxlX3J1bnRpbWUo
KS9fX2VuYWJsZV9ydW50aW1lKCkuCgpWMjogQmFzZWQgb24gQ2hlbmcgWHUncyBpZGVhIHdoaWNo
IHVzZXMgbGVzcyBjb2RlLgoKU2lnbmVkLW9mZi1ieTogWW9uZyBaaGFuZyA8eW9uZy56aGFuZzBA
Z21haWwuY29tPgpDYzogSW5nbyBNb2xuYXIgPG1pbmdvQGVsdGUuaHU+CkNjOiBQZXRlciBaaWps
c3RyYSA8cGV0ZXJ6QGluZnJhZGVhZC5vcmc+CkNjOiBNaWtlIEdhbGJyYWl0aCA8ZWZhdWx0QGdt
eC5kZT4KQ2M6IENoZW5nIFh1IDxjaGVuZ3h1QGxpbnV4LnZuZXQuaWJtLmNvbT4KLS0tCgpBdHRh
Y2ggaXQgdG9vIGluIGNhc2Ugd2VibWFpbCB3aWxsIG1hbmdsZSB0aGUgcGF0Y2guCgoga2VybmVs
L3NjaGVkX2F1dG9ncm91cC5oIHwgICAgMSArCiBrZXJuZWwvc2NoZWRfcnQuYyAgICAgICAgfCAg
IDIyICsrKysrKysrKysrKysrKysrLS0tLS0KIDIgZmlsZXMgY2hhbmdlZCwgMTggaW5zZXJ0aW9u
cygrKSwgNSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9rZXJuZWwvc2NoZWRfYXV0b2dyb3Vw
LmggYi9rZXJuZWwvc2NoZWRfYXV0b2dyb3VwLmgKaW5kZXggMDU1NzcwNS4uYzJmMGU3MiAxMDA2
NDQKLS0tIGEva2VybmVsL3NjaGVkX2F1dG9ncm91cC5oCisrKyBiL2tlcm5lbC9zY2hlZF9hdXRv
Z3JvdXAuaApAQCAtMTMsNiArMTMsNyBAQCBzdHJ1Y3QgYXV0b2dyb3VwIHsKIAlpbnQJCQluaWNl
OwogfTsKIAorc3RhdGljIGlubGluZSBib29sIHRhc2tfZ3JvdXBfaXNfYXV0b2dyb3VwKHN0cnVj
dCB0YXNrX2dyb3VwICp0Zyk7CiBzdGF0aWMgaW5saW5lIHN0cnVjdCB0YXNrX2dyb3VwICoKIGF1
dG9ncm91cF90YXNrX2dyb3VwKHN0cnVjdCB0YXNrX3N0cnVjdCAqcCwgc3RydWN0IHRhc2tfZ3Jv
dXAgKnRnKTsKIApkaWZmIC0tZ2l0IGEva2VybmVsL3NjaGVkX3J0LmMgYi9rZXJuZWwvc2NoZWRf
cnQuYwppbmRleCAxMGQwMTgyLi44YzA0Y2IyIDEwMDY0NAotLS0gYS9rZXJuZWwvc2NoZWRfcnQu
YworKysgYi9rZXJuZWwvc2NoZWRfcnQuYwpAQCAtMTg1LDExICsxODUsMjMgQEAgc3RhdGljIGlu
bGluZSB1NjQgc2NoZWRfcnRfcGVyaW9kKHN0cnVjdCBydF9ycSAqcnRfcnEpCiAKIHR5cGVkZWYg
c3RydWN0IHRhc2tfZ3JvdXAgKnJ0X3JxX2l0ZXJfdDsKIAotI2RlZmluZSBmb3JfZWFjaF9ydF9y
cShydF9ycSwgaXRlciwgcnEpIFwKLQlmb3IgKGl0ZXIgPSBsaXN0X2VudHJ5X3JjdSh0YXNrX2dy
b3Vwcy5uZXh0LCB0eXBlb2YoKml0ZXIpLCBsaXN0KTsgXAotCSAgICAgKCZpdGVyLT5saXN0ICE9
ICZ0YXNrX2dyb3VwcykgJiYgXAotCSAgICAgKHJ0X3JxID0gaXRlci0+cnRfcnFbY3B1X29mKHJx
KV0pOyBcCi0JICAgICBpdGVyID0gbGlzdF9lbnRyeV9yY3UoaXRlci0+bGlzdC5uZXh0LCB0eXBl
b2YoKml0ZXIpLCBsaXN0KSkKK3N0YXRpYyBpbmxpbmUgc3RydWN0IHRhc2tfZ3JvdXAgKm5leHRf
dGFza19ncm91cChzdHJ1Y3QgdGFza19ncm91cCAqdGcpCit7CisJZG8geworCQl0ZyA9IGxpc3Rf
ZW50cnlfcmN1KHRnLT5saXN0Lm5leHQsCisJCQl0eXBlb2Yoc3RydWN0IHRhc2tfZ3JvdXApLCBs
aXN0KTsKKwl9IHdoaWxlICgmdGctPmxpc3QgIT0gJnRhc2tfZ3JvdXBzICYmIHRhc2tfZ3JvdXBf
aXNfYXV0b2dyb3VwKHRnKSk7CisKKwlpZiAoJnRnLT5saXN0ID09ICZ0YXNrX2dyb3VwcykKKwkJ
dGcgPSBOVUxMOworCisJcmV0dXJuIHRnOworfQorCisjZGVmaW5lIGZvcl9lYWNoX3J0X3JxKHJ0
X3JxLCBpdGVyLCBycSkJCQkJCVwKKwlmb3IgKGl0ZXIgPSBjb250YWluZXJfb2YoJnRhc2tfZ3Jv
dXBzLCB0eXBlb2YoKml0ZXIpLCBsaXN0KTsJXAorCQkoaXRlciA9IG5leHRfdGFza19ncm91cChp
dGVyKSkgJiYJCQlcCisJCShydF9ycSA9IGl0ZXItPnJ0X3JxW2NwdV9vZihycSldKTspCiAKIHN0
YXRpYyBpbmxpbmUgdm9pZCBsaXN0X2FkZF9sZWFmX3J0X3JxKHN0cnVjdCBydF9ycSAqcnRfcnEp
CiB7Ci0tIAoxLjcuNC4xCgo=
--20cf302d49c6c9964504a6bcbedd--
