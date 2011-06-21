Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495Ab1FUNSz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 09:18:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:41169 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab1FUNSy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 09:18:54 -0400
Subject: Re: [PATCH v4 3.0-rc2-tip 7/22]  7: uprobes: mmap and fork hooks.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Hugh Dickins <hughd@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1308303665.2355.11.camel@twins>
References: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6>
	 <20110607125931.28590.12362.sendpatchset@localhost6.localdomain6>
	 <1308161486.2171.61.camel@laptop>
	 <20110616032645.GF4952@linux.vnet.ibm.com>
	 <1308225626.13240.34.camel@twins>
	 <20110616130012.GL4952@linux.vnet.ibm.com>
	 <1308248588.13240.267.camel@twins>
	 <20110617045000.GM4952@linux.vnet.ibm.com>
	 <1308297836.13240.380.camel@twins>
	 <20110617090504.GN4952@linux.vnet.ibm.com> <1308303665.2355.11.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 21 Jun 2011 15:17:23 +0200
Message-ID: <1308662243.26237.144.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-17 at 11:41 +0200, Peter Zijlstra wrote:
> 
> On thing I was thinking of to fix that initial problem of spurious traps
> was to leave the uprobe in the tree but skip all probes without
> consumers in mmap_uprobe().

Can you find fault with using __unregister_uprobe() as a cleanup path
for __register_uprobe() so that we do a second vma-rmap walk, and
ignoring empty probes on uprobe_mmap()?

We won't get spurious traps because the empty (no consumers) uprobe is
still in the tree, we won't get any 'lost' probe insn because the
cleanup does a second vma-rmap walk which will include the new mmap().
And double probe insertion is harmless.


