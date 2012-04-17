Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156Ab2DQKIu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 06:08:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:45569 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096Ab2DQKIt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 06:08:49 -0400
Message-ID: <1334657287.28150.77.camel@twins>
Subject: Re: [PATCH 2/6] uprobes: introduce is_swbp_at_addr_fast()
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Anton Arapov <anton@redhat.com>
Date: Tue, 17 Apr 2012 12:08:07 +0200
In-Reply-To: <20120416153408.GA8852@redhat.com>
References: <20120405222024.GA19154@redhat.com>
	 <20120405222106.GB19166@redhat.com> <1334570935.28150.25.camel@twins>
	 <20120416144457.GA7018@redhat.com> <1334588109.28150.59.camel@twins>
	 <20120416153408.GA8852@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-16 at 17:34 +0200, Oleg Nesterov wrote:
> On 04/16, Peter Zijlstra wrote:
> >
> > Can't we 'optimize' read_opcode() by doing the pagefault_disable() +
> > __copy_from_user_inatomic() optimistically before going down the whole
> > gup()+lock+kmap path?
> 
> Unlikely, the task is not current.

Easy enough to test that though.. and that should make the regular path
fast enough, no?


---
 kernel/events/uprobes.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 985be4d..7f5d8c5 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -312,6 +312,15 @@ static int read_opcode(struct mm_struct *mm, unsigned long vaddr, uprobe_opcode_
 	void *vaddr_new;
 	int ret;
 
+	if (mm == current->mm) {
+		pagefault_disable();
+		ret = __copy_from_user_inatomic(opcode, (void __user *)vaddr, 
+						sizeof(*opcode));
+		pagefault_enable();
+		if (!ret)
+			return 0;
+	}
+
 	ret = get_user_pages(NULL, mm, vaddr, 1, 0, 0, &page, NULL);
 	if (ret <= 0)
 		return ret;

