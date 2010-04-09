Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab0DITim (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 15:38:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11912 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753965Ab0DITik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 15:38:40 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] make task_struct->signal immutable/refcountable
In-Reply-To: Oleg Nesterov's message of  Friday, 19 March 2010 19:40:17 +0100 <20100319184017.GA512@redhat.com>
References: <20100319184017.GA512@redhat.com>
Emacs: because you deserve a brk today.
Message-Id: <20100409193816.A3C36B082@magilla.sf.frob.com>
Date: Fri,  9 Apr 2010 12:38:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Roland McGrath <roland@redhat.com>
but some comments:

> This patch adds the reference counter, sigcnt, into signal_struct. This
> reference is owned by task_struct and it is dropped in __put_task_struct().

I'm not thrilled about the field name, but whatever.  We now have three
atomic counts with subtly different meanings, and no comments anywhere
really explaining it all.

* live: created and not yet begun to exit
* count: not yet reaped
* sigcnt: task_struct not yet freed

> Perhaps it makes sense to export get/put_signal_struct() later, but
> currently I don't see the immediate reason.

We should never export those at all.  In fact, I would not even make it a
separate inline.  We're here to simplify the lifetime rules, not give new
ways to complicate them.  If anybody wants to keep a signal_struct alive,
they can do it with get_task_struct().

> 	- with or without this patch signal_struct->count should go away,
> 	  or at least it should be "int nr_threads" for fs/proc. This will
> 	  be addressed later.

Indeed.  IMHO adding yet another atomic count here is OK only on the
proviso that we will be getting rid of the old one RSN.


Thanks,
Roland
