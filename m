Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab1FPDew (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 23:34:52 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:35907 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615Ab1FPDev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 23:34:51 -0400
Date: Thu, 16 Jun 2011 08:56:45 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
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
Subject: Re: [PATCH v4 3.0-rc2-tip 7/22]  7: uprobes: mmap and fork hooks.
Message-ID: <20110616032645.GF4952@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6>
 <20110607125931.28590.12362.sendpatchset@localhost6.localdomain6>
 <1308161486.2171.61.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1308161486.2171.61.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2011-06-15 20:11:26]:

> On Tue, 2011-06-07 at 18:29 +0530, Srikar Dronamraju wrote:
> > +       up_write(&mm->mmap_sem);
> > +       mutex_lock(&uprobes_mutex);
> > +       down_read(&mm->mmap_sem); 
> 
> egads, and all that without a comment explaining why you think that is
> even remotely sane.
> 
> I'm not at all convinced, it would expose the mmap() even though you
> could still decide to tear it down if this function were to fail, I bet
> there's some funnies there.

The problem is with lock ordering.  register/unregister operations
acquire uprobes_mutex (which serializes register unregister and the
mmap_hook) and then holds mmap_sem for read before they insert a
breakpoint.

But the mmap hook would be called with mmap_sem held for write. So
acquiring uprobes_mutex can result in deadlock. Hence we release the
mmap_sem, take the uprobes_mutex and then again hold the mmap_sem.

After we re-acquire the mmap_sem, we do check if the vma is valid.

Do we have better solutions?

-- 
Thanks and Regards
Srikar

