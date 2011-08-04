Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336Ab1HDOpg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 10:45:36 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:28774 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753507Ab1HDOpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 10:45:35 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: IwdQGgwVM1m5ebo9K3fQQBHIAwmvOwDMd3UNPzIO6Nfugq5
 Mv7IKBMQexWHMYYmG4H4VOZT8lQVNTqs3.uteggvePrZaNGEATCwtZYNgp.z
 _KApX9aL667UbtY1XdKwAfVD9Xh2f1DvrIl8kjFgjlwq_AL.GAA24xqfDHeV
 XSK0G4djAKtPavdorF35oYx4pM66FVoQwEBhcihZP6ZcFQTWG7PZwLyOeY85
 TNZtnkhF2dD0R21I90m4bpva4pKGQaGNdxH13okhpwkBPxbQEwD113kFSclo
 Mn5QrWShw4FfM.iC7NRfpwtEvGM.sE53HWzRNc00RujAavSC2M8eLwAu1uqv
 NHV6O8z5B4F5UksEIhtaJgs7AVP.BPmnHeCNaLzINPbXxZw--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 4 Aug 2011 09:45:32 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Huang Ying <ying.huang@intel.com>
cc: Andi Kleen <ak@linux.intel.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org
Subject: [listll] Fix fetching of head->first in lockless lists.
Message-ID: <alpine.DEB.2.00.1108040942360.24277@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The fetching of head->first must occur in the cmpxchg loop.

With the current code head->first may change after the content were assigned to
the "entry" variable. Entry then not be change anymore in the loop and be
used as old_entry for the cmpxchg. The cmpxchg will then therefore
compare "entry" to list->head. This will always fail if list->head has
changed. The restarting of the loop will not fetch head->first again. So
we could have a hang there.

I guess this only works now because the compiler optimizations pull
the fetching of head->first into the loop.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 lib/llist.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/lib/llist.c
===================================================================
--- linux-2.6.orig/lib/llist.c	2011-08-04 09:34:30.000000000 -0500
+++ linux-2.6/lib/llist.c	2011-08-04 09:35:08.000000000 -0500
@@ -42,8 +42,8 @@ void llist_add(struct llist_node *new, s
 	BUG_ON(in_nmi());
 #endif

-	entry = head->first;
 	do {
+		entry = head->first;
 		old_entry = entry;
 		new->next = entry;
 		cpu_relax();
@@ -66,8 +66,8 @@ void llist_add_batch(struct llist_node *
 	BUG_ON(in_nmi());
 #endif

-	entry = head->first;
 	do {
+		entry = head->first;
 		old_entry = entry;
 		new_last->next = entry;
 		cpu_relax();
@@ -97,8 +97,8 @@ struct llist_node *llist_del_first(struc
 	BUG_ON(in_nmi());
 #endif

-	entry = head->first;
 	do {
+		entry = head->first;
 		if (entry == NULL)
 			return NULL;
 		old_entry = entry;
