Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541Ab0IFS2S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 14:28:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51824 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab0IFS2O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 14:28:14 -0400
Subject: Re: [PATCHv11 2.6.36-rc2-tip 3/15]  3: uprobes: Slot allocation
 for Execution out of line(XOL)
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
In-Reply-To: <20100906175957.GH14891@linux.vnet.ibm.com>
References: <20100825134117.5447.55209.sendpatchset@localhost6.localdomain6>
	 <20100825134156.5447.43216.sendpatchset@localhost6.localdomain6>
	 <1283415812.2059.1825.camel@laptop>
	 <20100902174712.GA14891@linux.vnet.ibm.com>
	 <1283498777.1783.45.camel@laptop>
	 <20100906175957.GH14891@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 06 Sep 2010 20:28:03 +0200
Message-ID: <1283797683.1930.758.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-06 at 23:29 +0530, Srikar Dronamraju wrote:
> > The current approach limits the number of probes to what fits in a page.
> > The slot per cpu approach will have no such limit.
> 
> 
> yes the limit on number of probes is a limitation. For now the
> implementation would be straight and easy. We could either rework on the
> algorithm or add more pages depending on how often uprobes gets used.


Right, but with the proposed slot-per-cpu we'd be able to have unlimited
active probes within that single page, even with boosted probes,
assuming 16 bytes per instruction:

 push reg
 mov reg,foo
 insn
 pop reg
 jmp

and cacheline alignment we'd end up with 128 bytes per slot, we can
service 32 cpus per page. Which, for now, means that all my machines
need but a single page.
