Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908Ab2GHLhv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 07:37:51 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:49825 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751450Ab2GHLhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 07:37:50 -0400
X-IronPort-AV: E=Sophos;i="4.77,546,1336341600"; 
   d="scan'208";a="166023135"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH 0/7] remove invalid reference to list iterator variable
Date: Sun,  8 Jul 2012 13:37:37 +0200
Message-Id: <1341747464-1772-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If list_for_each_entry, etc complete a traversal of the list, the iterator
variable ends up pointing to an address at an offset from the list head,
and not a meaningful structure.  Thus this value should not be used after
the end of the iterator.

The complete semantic match that finds this problem is:
(http://coccinelle.lip6.fr/)

@@
identifier c,member;
expression E,x;
iterator name list_for_each_entry;
iterator name list_for_each_entry_reverse;
iterator name list_for_each_entry_continue;
iterator name list_for_each_entry_continue_reverse;
iterator name list_for_each_entry_from;
iterator name list_for_each_entry_safe;
iterator name list_for_each_entry_safe_continue;
iterator name list_for_each_entry_safe_from;
iterator name list_for_each_entry_safe_reverse;
iterator name hlist_for_each_entry;
iterator name hlist_for_each_entry_continue;
iterator name hlist_for_each_entry_from;
iterator name hlist_for_each_entry_safe;
statement S;
@@

(
list_for_each_entry(c,...,member) { ... when != break;
                                 when forall
                                 when strict
}
|
list_for_each_entry_reverse(c,...,member) { ... when != break;
                                 when forall
                                 when strict
}
|
list_for_each_entry_continue(c,...,member) { ... when != break;
                                 when forall
                                 when strict
}
|
list_for_each_entry_continue_reverse(c,...,member) { ... when != break;
                                 when forall
                                 when strict
}
|
list_for_each_entry_from(c,...,member) { ... when != break;
                                 when forall
                                 when strict
}
|
list_for_each_entry_safe(c,...,member) { ... when != break;
                                 when forall
                                 when strict
}
|
list_for_each_entry_safe_continue(c,...,member) { ... when != break;
                                 when forall
                                 when strict
}
|
list_for_each_entry_safe_from(c,...,member) { ... when != break;
                                 when forall
                                 when strict
}
|
list_for_each_entry_safe_reverse(c,...,member) { ... when != break;
                                 when forall
                                 when strict
}
)
...
(
list_for_each_entry(c,...) S
|
list_for_each_entry_reverse(c,...) S
|
list_for_each_entry_continue(c,...) S
|
list_for_each_entry_continue_reverse(c,...) S
|
list_for_each_entry_from(c,...) S
|
list_for_each_entry_safe(c,...) S
|
list_for_each_entry_safe(x,c,...) S
|
list_for_each_entry_safe_continue(c,...) S
|
list_for_each_entry_safe_continue(x,c,...) S
|
list_for_each_entry_safe_from(c,...) S
|
list_for_each_entry_safe_from(x,c,...) S
|
list_for_each_entry_safe_reverse(c,...) S
|
list_for_each_entry_safe_reverse(x,c,...) S
|
hlist_for_each_entry(c,...) S
|
hlist_for_each_entry_continue(c,...) S
|
hlist_for_each_entry_from(c,...) S
|
hlist_for_each_entry_safe(c,...) S
|
list_remove_head(x,c,...)
|
sizeof(<+...c...+>)
|
&c->member
|
c = E
|
*c
)

