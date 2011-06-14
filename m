Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260Ab1FNPId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 11:08:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:37413 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab1FNPIb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 11:08:31 -0400
Subject: Re: [PATCH v4 3.0-rc2-tip 2/22]  2: uprobes: Breakground page
 replacement.
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20110614142710.GB5139@redhat.com>
References: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6>
	 <20110607125835.28590.25476.sendpatchset@localhost6.localdomain6>
	 <20110613170020.GA27137@redhat.com> <1308056477.19856.35.camel@twins>
	 <20110614142710.GB5139@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 14 Jun 2011 17:07:33 +0200
Message-ID: <1308064053.19856.75.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-14 at 16:27 +0200, Oleg Nesterov wrote:
> On 06/14, Peter Zijlstra wrote:
> >
> > On Mon, 2011-06-13 at 19:00 +0200, Oleg Nesterov wrote:
> > >
> > > Also. This is called under down_read(mmap_sem), can't we race with
> > > access_process_vm() modifying the same memory?
> >
> > Shouldn't matter COW and similar things are serialized using the pte
> > lock.
> 
> Yes, but afaics this doesn't matter. Suppose that write_opcode() is
> called when access_process_vm() does copy_to_user_page(). We can cow
> the page before memcpy() completes.

access_process_vm() will end up doing a FOLL_WRITE itself when
copy_to_user_page() is called since write=1 in that case.

At that point we have a COW-race, someone wins, but the other will then
return the same page.

At this point further PTRACE pokes can indeed race with the memcpy in
write_opcode(). A possible fix would be to lock_page() around
copy_to_user_page() (its already done in set_page_dirty_lock(), so
pulling it out shouldn't matter much).


