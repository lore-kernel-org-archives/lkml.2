Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230Ab1FVFW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 01:22:26 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47445 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab1FVFWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 01:22:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=aAmFjrvFGIOmsOovl1vQu9KLHFd4OLKD2BUKmrJp9kizqnk+Iq0gkKLo/6nrsGvxp5
         dxW/ReoD8PQftccE5/mAuNLImrE4wZXyd94vBTCwTCniAqyw0Kz/fR3sL0MmdMG2upI9
         iLgxnWyaUkysKC+W7FO7hUXvdRtqTfgmEBMlI=
MIME-Version: 1.0
Date: Wed, 22 Jun 2011 13:22:24 +0800
Message-ID: <BANLkTikKRnQb_T5x1BA=WopbBA_weLNFoQ@mail.gmail.com>
Subject: [PATCH] sched: skip autogroup when looking for all rt sched groups
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Cheng Xu <chengxu@linux.vnet.ibm.com>
Content-Type: multipart/mixed; boundary=000e0cd6d0204c5cbd04a64627fe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd6d0204c5cbd04a64627fe
Content-Type: text/plain; charset=UTF-8

From: Yong Zhang <yong.zhang0@gmail.com>
Subject: [PATCH] sched: skip autogroup when looking for all rt sched groups

Since [commit ec514c48: sched: Fix rt_rq runtime leakage bug],
'cat /proc/sched_debug' will print data of root_task_group.rt_rq
multi times, this is due to autogroup has no its own rt group,
instead rt group of autogroup is linked to root_task_group.

So skip it when we are looking for all rt sched groups, and it
will also save some noop operation against root_task_group when
__disable_runtime()/__enable_runtime().

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
---

Since webmail may mangle the patch, attach it too.

 kernel/sched_autogroup.h |    1 +
 kernel/sched_rt.c        |   29 ++++++++++++++++++++++++-----
 2 files changed, 25 insertions(+), 5 deletions(-)

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
index 10d0182..8edf487 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -185,11 +185,30 @@ static inline u64 sched_rt_period(struct rt_rq *rt_rq)

 typedef struct task_group *rt_rq_iter_t;

-#define for_each_rt_rq(rt_rq, iter, rq) \
-	for (iter = list_entry_rcu(task_groups.next, typeof(*iter), list); \
-	     (&iter->list != &task_groups) && \
-	     (rt_rq = iter->rt_rq[cpu_of(rq)]); \
-	     iter = list_entry_rcu(iter->list.next, typeof(*iter), list))
+/* autogroup is not related to rt group, skip it */
+#define find_first_valid_task_group(iter)				\
+	({								\
+		list_for_each_entry_rcu(iter, &task_groups, list)	\
+			if (!task_group_is_autogroup(iter))		\
+				break;					\
+		iter;							\
+	})
+
+#define find_next_valid_task_group(iter)				\
+	({								\
+		do {							\
+			iter = list_entry_rcu(iter->list.next,		\
+					typeof(*iter),	list);		\
+		} while (&iter->list != &task_groups &&			\
+			task_group_is_autogroup(iter));			\
+		iter;							\
+	})
+
+#define for_each_rt_rq(rt_rq, iter, rq)					\
+	for (find_first_valid_task_group(iter);				\
+	     (&iter->list != &task_groups) &&				\
+	     (rt_rq = iter->rt_rq[cpu_of(rq)]);				\
+	     find_next_valid_task_group(iter))

 static inline void list_add_leaf_rt_rq(struct rt_rq *rt_rq)
 {
-- 
1.7.4.1

--000e0cd6d0204c5cbd04a64627fe
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-sched-skip-autogroup-when-looking-for-all-rt-sched-g.patch"
Content-Disposition: attachment; 
	filename="0001-sched-skip-autogroup-when-looking-for-all-rt-sched-g.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gp7u5ps80

RnJvbSA0MDExNzYzNWE4ZjIyYTA1YTRlZWQ5OGM0MGZjYWY2N2FkOTBmNzM4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBZb25nIFpoYW5nIDx5b25nLnpoYW5nMEBnbWFpbC5jb20+CkRh
dGU6IFdlZCwgMjIgSnVuIDIwMTEgMTI6NTI6NDAgKzA4MDAKU3ViamVjdDogW1BBVENIXSBzY2hl
ZDogc2tpcCBhdXRvZ3JvdXAgd2hlbiBsb29raW5nIGZvciBhbGwgcnQgc2NoZWQgZ3JvdXBzCgpT
aW5jZSBbY29tbWl0IGVjNTE0YzQ4OiBzY2hlZDogRml4IHJ0X3JxIHJ1bnRpbWUgbGVha2FnZSBi
dWddLAonY2F0IC9wcm9jL3NjaGVkX2RlYnVnJyB3aWxsIHByaW50IGRhdGEgb2Ygcm9vdF90YXNr
X2dyb3VwLnJ0X3JxCm11bHRpIHRpbWVzLCB0aGlzIGlzIGR1ZSB0byBhdXRvZ3JvdXAgaGFzIG5v
IGl0cyBvd24gcnQgZ3JvdXAsCmluc3RlYWQgcnQgZ3JvdXAgb2YgYXV0b2dyb3VwIGlzIGxpbmtl
ZCB0byByb290X3Rhc2tfZ3JvdXAuCgpTbyBza2lwIGl0IHdoZW4gd2UgYXJlIGxvb2tpbmcgZm9y
IGFsbCBydCBzY2hlZCBncm91cHMsIGFuZCBpdAp3aWxsIGFsc28gc2F2ZSBzb21lIG5vb3Agb3Bl
cmF0aW9uIGFnYWluc3Qgcm9vdF90YXNrX2dyb3VwIHdoZW4KX19kaXNhYmxlX3J1bnRpbWUoKS9f
X2VuYWJsZV9ydW50aW1lKCkuCgpTaWduZWQtb2ZmLWJ5OiBZb25nIFpoYW5nIDx5b25nLnpoYW5n
MEBnbWFpbC5jb20+CkNjOiBJbmdvIE1vbG5hciA8bWluZ29AZWx0ZS5odT4KQ2M6IFBldGVyIFpp
amxzdHJhIDxwZXRlcnpAaW5mcmFkZWFkLm9yZz4KQ2M6IE1pa2UgR2FsYnJhaXRoIDxlZmF1bHRA
Z214LmRlPgotLS0KClNpbmNlIHdlYm1haWwgbWF5IG1hbmdsZSB0aGUgcGF0Y2gsIGF0dGFjaCBp
dCB0b28uCgoga2VybmVsL3NjaGVkX2F1dG9ncm91cC5oIHwgICAgMSArCiBrZXJuZWwvc2NoZWRf
cnQuYyAgICAgICAgfCAgIDI5ICsrKysrKysrKysrKysrKysrKysrKysrKy0tLS0tCiAyIGZpbGVz
IGNoYW5nZWQsIDI1IGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEv
a2VybmVsL3NjaGVkX2F1dG9ncm91cC5oIGIva2VybmVsL3NjaGVkX2F1dG9ncm91cC5oCmluZGV4
IDA1NTc3MDUuLmMyZjBlNzIgMTAwNjQ0Ci0tLSBhL2tlcm5lbC9zY2hlZF9hdXRvZ3JvdXAuaAor
KysgYi9rZXJuZWwvc2NoZWRfYXV0b2dyb3VwLmgKQEAgLTEzLDYgKzEzLDcgQEAgc3RydWN0IGF1
dG9ncm91cCB7CiAJaW50CQkJbmljZTsKIH07CiAKK3N0YXRpYyBpbmxpbmUgYm9vbCB0YXNrX2dy
b3VwX2lzX2F1dG9ncm91cChzdHJ1Y3QgdGFza19ncm91cCAqdGcpOwogc3RhdGljIGlubGluZSBz
dHJ1Y3QgdGFza19ncm91cCAqCiBhdXRvZ3JvdXBfdGFza19ncm91cChzdHJ1Y3QgdGFza19zdHJ1
Y3QgKnAsIHN0cnVjdCB0YXNrX2dyb3VwICp0Zyk7CiAKZGlmZiAtLWdpdCBhL2tlcm5lbC9zY2hl
ZF9ydC5jIGIva2VybmVsL3NjaGVkX3J0LmMKaW5kZXggMTBkMDE4Mi4uOGVkZjQ4NyAxMDA2NDQK
LS0tIGEva2VybmVsL3NjaGVkX3J0LmMKKysrIGIva2VybmVsL3NjaGVkX3J0LmMKQEAgLTE4NSwx
MSArMTg1LDMwIEBAIHN0YXRpYyBpbmxpbmUgdTY0IHNjaGVkX3J0X3BlcmlvZChzdHJ1Y3QgcnRf
cnEgKnJ0X3JxKQogCiB0eXBlZGVmIHN0cnVjdCB0YXNrX2dyb3VwICpydF9ycV9pdGVyX3Q7CiAK
LSNkZWZpbmUgZm9yX2VhY2hfcnRfcnEocnRfcnEsIGl0ZXIsIHJxKSBcCi0JZm9yIChpdGVyID0g
bGlzdF9lbnRyeV9yY3UodGFza19ncm91cHMubmV4dCwgdHlwZW9mKCppdGVyKSwgbGlzdCk7IFwK
LQkgICAgICgmaXRlci0+bGlzdCAhPSAmdGFza19ncm91cHMpICYmIFwKLQkgICAgIChydF9ycSA9
IGl0ZXItPnJ0X3JxW2NwdV9vZihycSldKTsgXAotCSAgICAgaXRlciA9IGxpc3RfZW50cnlfcmN1
KGl0ZXItPmxpc3QubmV4dCwgdHlwZW9mKCppdGVyKSwgbGlzdCkpCisvKiBhdXRvZ3JvdXAgaXMg
bm90IHJlbGF0ZWQgdG8gcnQgZ3JvdXAsIHNraXAgaXQgKi8KKyNkZWZpbmUgZmluZF9maXJzdF92
YWxpZF90YXNrX2dyb3VwKGl0ZXIpCQkJCVwKKwkoewkJCQkJCQkJXAorCQlsaXN0X2Zvcl9lYWNo
X2VudHJ5X3JjdShpdGVyLCAmdGFza19ncm91cHMsIGxpc3QpCVwKKwkJCWlmICghdGFza19ncm91
cF9pc19hdXRvZ3JvdXAoaXRlcikpCQlcCisJCQkJYnJlYWs7CQkJCQlcCisJCWl0ZXI7CQkJCQkJ
CVwKKwl9KQorCisjZGVmaW5lIGZpbmRfbmV4dF92YWxpZF90YXNrX2dyb3VwKGl0ZXIpCQkJCVwK
KwkoewkJCQkJCQkJXAorCQlkbyB7CQkJCQkJCVwKKwkJCWl0ZXIgPSBsaXN0X2VudHJ5X3JjdShp
dGVyLT5saXN0Lm5leHQsCQlcCisJCQkJCXR5cGVvZigqaXRlciksCWxpc3QpOwkJXAorCQl9IHdo
aWxlICgmaXRlci0+bGlzdCAhPSAmdGFza19ncm91cHMgJiYJCQlcCisJCQl0YXNrX2dyb3VwX2lz
X2F1dG9ncm91cChpdGVyKSk7CQkJXAorCQlpdGVyOwkJCQkJCQlcCisJfSkKKworI2RlZmluZSBm
b3JfZWFjaF9ydF9ycShydF9ycSwgaXRlciwgcnEpCQkJCQlcCisJZm9yIChmaW5kX2ZpcnN0X3Zh
bGlkX3Rhc2tfZ3JvdXAoaXRlcik7CQkJCVwKKwkgICAgICgmaXRlci0+bGlzdCAhPSAmdGFza19n
cm91cHMpICYmCQkJCVwKKwkgICAgIChydF9ycSA9IGl0ZXItPnJ0X3JxW2NwdV9vZihycSldKTsJ
CQkJXAorCSAgICAgZmluZF9uZXh0X3ZhbGlkX3Rhc2tfZ3JvdXAoaXRlcikpCiAKIHN0YXRpYyBp
bmxpbmUgdm9pZCBsaXN0X2FkZF9sZWFmX3J0X3JxKHN0cnVjdCBydF9ycSAqcnRfcnEpCiB7Ci0t
IAoxLjcuNC4xCgo=
--000e0cd6d0204c5cbd04a64627fe--
