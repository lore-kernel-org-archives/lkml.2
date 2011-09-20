Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018Ab1ITOe5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 10:34:57 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:56177 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684Ab1ITOez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 10:34:55 -0400
Date: Tue, 20 Sep 2011 19:42:04 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hugh Dickins <hughd@google.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 3.1.0-rc4-tip 0/26]   Uprobes patchset with perf
 probe support
Message-ID: <20110920141204.GC6568@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20110920133401.GA28550@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11092014-8974-0000-0000-00000049A4F9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Hellwig <hch@infradead.org> [2011-09-20 09:34:01]:

> On Tue, Sep 20, 2011 at 05:29:38PM +0530, Srikar Dronamraju wrote:
> > - Uses i_mutex instead of uprobes_mutex.
> 
> What for exactly?  I'm pretty strict against introducing even more
> uses for i_mutex, it's already way to overloaded with different
> meanings.
> 


There could be multiple simultaneous requests for adding/removing a
probe for the same location i.e same inode + same offset. These requests
will have to be serialized.

To serialize this we had used uprobes specific mutex (uprobes_mutex) in
the last patchset.  However using uprobes_mutex will mean we will be
serializing requests for unrelated files. I.e if we get a request to
probe libpthread while we are inserting/deleting a probe on libc, 
then we used to make the libpthread request wait unnecessarily.
This also means that I dont need to introduce yet another lock.

After using i_mutex, these two requests can run in parallel.

I had proposed this while answering one of the comments in the last
patchset. Since I didnt hear any complaints, I went ahead and
implemented this.

I could use any other inode/file/mapping based sleepable lock that is of
higher order than mmap_sem. Can you please let me know if we have
alternatives.

-- 
Thanks and Regards
Srikar

