Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137Ab2CTHIB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 03:08:01 -0400
Received: from mail-wi0-f194.google.com ([209.85.212.194]:52083 "EHLO
	mail-wi0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755959Ab2CTHH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 03:07:59 -0400
Date: Tue, 20 Mar 2012 08:07:55 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf events changes for v3.4
Message-ID: <20120320070755.GB27423@gmail.com>
References: <20120319155342.GA5113@gmail.com>
 <CA+55aFy5h1_ybF-7D9Jy-DW-3V+O8LxTWzEwHKORA+bqECWtOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFy5h1_ybF-7D9Jy-DW-3V+O8LxTWzEwHKORA+bqECWtOA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, Mar 19, 2012 at 8:53 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > Please pull the latest perf-core-for-linus git tree from:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-core-for-linus
> 
> This seems to be another pull request that really could have 
> done with some high-level overview of what the changes are for 
> 3.4

Yeah, you are right, will do that next time around for the 
larger trees (or trees that are not obviously single-topic at 
first sight).

Here is a short (and incomplete) high-level summary of the perf 
events changes of the v3.4 cycle:

 - New "hardware based branch profiling" feature both on the 
   kernel and the tooling side, on CPUs that support it. (modern 
   x86 Intel CPUs with the 'LBR' hardware feature currently.)

   This new feature is basically a sophisticated 'magnifying 
   glass' for branch execution - something that is pretty 
   difficult to extract from regular, function histogram centric 
   profiles.

   The simplest mode is activated via 'perf record -b', and the 
   result looks like this in perf report:

    $ perf record -b any_call,u -e cycles:u branchy

    $ perf report -b --sort=symbol
        52.34%  [.] main                   [.] f1
        24.04%  [.] f1                     [.] f3
        23.60%  [.] f1                     [.] f2
         0.01%  [k] _IO_new_file_xsputn    [k] _IO_file_overflow
         0.01%  [k] _IO_vfprintf_internal  [k] _IO_new_file_xsputn
         0.01%  [k] _IO_vfprintf_internal  [k] strchrnul
         0.01%  [k] __printf               [k] _IO_vfprintf_internal
         0.01%  [k] main                   [k] __printf

   This output shows from/to branch columns and shows the 
   highest percentage (from,to) jump combinations - i.e. the 
   most likely taken branches in the system. "branches" can also 
   include function calls and any other synchronous and 
   asynchronous transitions of the instruction pointer that are 
   not 'next instruction' - such as system calls, traps, 
   interrupts, etc.

   This feature comes with (hopefully intuitive) flat ascii and 
   TUI support in perf report.

 - Various 'perf annotate' visual improvements for us assembly
   junkies. It will now recognize function calls in the TUI and
   by hitting enter you can follow the call (recursively) and 
   back, amongst other improvements.

 - Multiple threads/processes recording support in perf record,
   perf stat, perf top - which is activated via a comma-list of 
   PIDs:

     perf top -p 21483,21485
     perf stat -p 21483,21485 -ddd
     perf record -p 21483,21485

 - Support for per UID views, via the --uid paramter to perf 
   top, perf report, etc. For example 'perf top --uid mingo' 
   will only show the tasks that I am running, excluding other 
   users, root, etc.

 - Jump label restructurings and improvements - this
   includes the factoring out of the (hopefully much clearer)
   include/linux/static_key.h generic facility:

	struct static_key key = STATIC_KEY_INIT_FALSE;

	...

        if (static_key_false(&key))
                do unlikely code
        else
                do likely code

	...
	static_key_slow_inc();
	...
	static_key_slow_inc();
	...

   The static_key_false() branch will be generated into the code 
   with as little impact to the likely code path as possible.  
   the static_key_slow_*() APIs flip the branch via live kernel 
   code patching.

   This facility can now be used more widely within the
   kernel to micro-optimize hot branches whose likelihood 
   matches the static-key usage and fast/slow cost patterns.

 - SW function tracer improvements: perf support and filtering
   support.

 - Various hardenings of the perf.data ABI, to make older 
   perf.data's smoother on newer tool versions, to make new 
   features integrate more smoothly, to support cross-endian
   recording/analyzing workflows better, etc.

 - Restructuring of the kprobes code, the splitting out of 
   'optprobes', and a corner case bugfix.

 - Allow the tracing of kernel console output (printk).

 - Improvements/fixes to user-space RDPMC support, allowing 
   user-space self-profiling code to extract PMU counts without
   performing any system calls, while playing nice with the 
   kernel side.

 - 'perf bench' improvements

 - ... and lots of internal restructurings, cleanups and fixes 
   that made these features possible. And, as usual this list is 
   incomplete as there were also lots of other
   improvements:

     165 files changed, 6107 insertions(+), 1984 deletions(-)

Thanks,

	Ingo
