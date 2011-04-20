Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166Ab1DTPZa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 11:25:30 -0400
Received: from msux-gh1-uea01.nsa.gov ([63.239.65.39]:52525 "EHLO
	msux-gh1-uea01.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab1DTPZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 11:25:29 -0400
X-Greylist: delayed 543 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Apr 2011 11:25:28 EDT
Subject: Re: [PATCH v3 2.6.39-rc1-tip 12/26] 12: uprobes: slot allocation
 for uprobes
From: Stephen Smalley <sds@tycho.nsa.gov>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Eric Paris <eparis@parisplace.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        int-list-linux-mm@kvack.org, linux-mm@kvack.org,
        Peter Zijlstra <peterz@infradead.org>,
        James Morris <jmorris@namei.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Eric Paris <eparis@redhat.com>
In-Reply-To: <y0m7hapc6wu.fsf@fche.csb>
References: <20110401143223.15455.19844.sendpatchset@localhost6.localdomain6>
	 <20110401143457.15455.64839.sendpatchset@localhost6.localdomain6>
	 <1303145171.32491.886.camel@twins>
	 <20110419062654.GB10698@linux.vnet.ibm.com>
	 <BANLkTimw7dV9_aSsrUfzwSdwr6UwZDsRwg@mail.gmail.com>
	 <y0m7hapc6wu.fsf@fche.csb>
Content-Type: text/plain; charset="UTF-8"
Organization: National Security Agency
Date: Wed, 20 Apr 2011 11:16:21 -0400
Message-ID: <1303312581.3739.22.camel@moss-pluto>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-20 at 10:51 -0400, Frank Ch. Eigler wrote:
> eparis wrote:
> 
> > [...]
> > Now how to fix the problems you were seeing.  If you run a modern
> > system with a GUI I'm willing to bet the pop-up window told you
> > exactly how to fix your problem.  [...]
> >
> > 1) chcon -t unconfined_execmem_t /path/to/your/binary
> > 2) setsebool -P allow_execmem 1
> > [...]
> > I believe there was a question about how JIT's work with SELinux
> > systems.  They work mostly by method #1.
> 
> Actually, that's a solution to a different problem.  Here, it's not
> particular /path/to/your/binaries that want/need selinux provileges.
> It's a kernel-driven debugging facility that needs it temporarily for
> arbitrary processes.
> 
> It's not like JITs, with known binary names.  It's not like GDB, which
> simply overwrites existing instructions in the text segment.  To make
> uprobes work fast (single-step-out-of-line), one needs one or emore
> temporary pages with unusual mapping permissions.

I would expect that (2) would solve it, but couldn't distinguish the
kernel-created mappings from userspace doing the same thing.
Alternatively, you could temporarily switch your credentials around the
mapping operation, e.g.:
old_cred = override_creds(&init_cred);
do_mmap_pgoff(...);
revert_creds(old_cred);

devtmpfs does something similar to avoid triggering permission checks on
userspace when it is internally creating and deleting nodes.

How is this ability to use this facility controlled?

-- 
Stephen Smalley
National Security Agency

