Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab1IWLyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 07:54:19 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:34900 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240Ab1IWLyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 07:54:18 -0400
X-AuditID: b753bd60-a3c7dba0000050a4-16-4e7c7367ec3c
X-AuditID: b753bd60-a3c7dba0000050a4-16-4e7c7367ec3c
Message-ID: <4E7C7353.50802@hitachi.com>
Date: Fri, 23 Sep 2011 20:53:55 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Andi Kleen <andi@firstfloor.org>,
        Thomas Gleixner <tglx@linutronix.de>, Jonathan Corbet <corbet@lwn.net>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 3.1.0-rc4-tip 8/26]   x86: analyze instruction and
 determine fixups.
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com> <20110920120127.25326.71509.sendpatchset@srdronam.in.ibm.com> <20110920171310.GC27959@stefanha-thinkpad.localdomain> <20110920181225.GA5149@infradead.org> <20110920205317.GA1508@stefanha-thinkpad.localdomain>
In-Reply-To: <20110920205317.GA1508@stefanha-thinkpad.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/09/21 5:53), Stefan Hajnoczi wrote:
> On Tue, Sep 20, 2011 at 02:12:25PM -0400, Christoph Hellwig wrote:
>> On Tue, Sep 20, 2011 at 06:13:10PM +0100, Stefan Hajnoczi wrote:
>>> You've probably thought of this but it would be nice to skip XOL for
>>> nops.  This would be a common case with static probes (e.g. sdt.h) where
>>> the probe template includes a nop where we can easily plant int $0x3.
>>
>> Do we now have sdt.h support for uprobes?  That's one of the killer
>> features that always seemed to get postponed.
> 
> Not yet but it's a question of doing roughly what SystemTap does to
> parse the appropriate ELF sections and then putting those probes into
> uprobes.
> 
> Masami looked at this and found that SystemTap sdt.h currently requires
> an extra userspace memory store in order to activate probes.  Each probe
> has a "semaphore" 16-bit counter which applications may test before
> hitting the probe itself.  This is used to avoid overhead in
> applications that do expensive argument processing (e.g. creating
> strings) for probes.

Indeed, originally, those semaphores designed for such use cases.
However, some applications *always* use it (e.g. qemu-kvm).

> 
> But this should be solvable so it would be possible to use perf-probe(1)
> on a std.h-enabled binary.  Some distros already ship such binaries!

I'm not sure that we should stick on the current implementation
of the sdt.h. I think we'd better modify the sdt.h to replace
such semaphores with checking whether the tracepoint is changed from nop.

Or, we can introduce an add-hoc ptrace code to perftools for modifying
those semaphores. However, this means that user always has to use
perf to trace applications, and it's hard to trace multiple applications
at a time (can we attach all of them?)...

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
