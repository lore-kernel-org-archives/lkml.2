Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090Ab2GHNUB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 09:20:01 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:47504
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751481Ab2GHNTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 09:19:49 -0400
X-IronPort-AV: E=Sophos;i="4.77,547,1336341600"; 
   d="scan'208";a="149981918"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] remove invalid reference to list iterator variable
Date: Sun,  8 Jul 2012 15:19:41 +0200
Message-Id: <1341753582-3943-1-git-send-email-Julia.Lawall@lip6.fr>
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

