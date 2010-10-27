Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760679Ab0J0D0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 23:26:21 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:52630 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702Ab0J0D0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 23:26:16 -0400
Date: Wed, 27 Oct 2010 12:25:49 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-arch@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        John Reiser <jreiser@bitwagon.com>
Subject: Re: [PATCH 2/3] ftrace/x86: Add support for C version of recordmcount
Message-ID: <20101027032548.GA5341@linux-sh.org>
References: <20101014210014.895157788@goodmis.org> <20101014210136.230687571@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101014210136.230687571@goodmis.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 14, 2010 at 05:00:16PM -0400, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> This patch adds the support for the C version of recordmcount and
> compile times show ~ 12% improvement.
> 
> After verifying this works, other archs can add:
> 
>  HAVE_C_MCOUNT_RECORD
> 
> in its Kconfig and it will use the C version of recordmcount
> instead of the perl version.
> 
While I haven't had the chance to debug this yet, turning it on for SH
blows up immediately:

ftrace: allocating 15200 entries in 30 pages
------------[ cut here ]------------
WARNING: at /home/pmundt/devel/git/sh-2.6/kernel/trace/ftrace.c:1007
Modules linked in:

Pid : 0, Comm:           swapper
CPU : 0                  Not tainted  (2.6.36-05622-g38ab134-dirty #508)

PC is at ftrace_bug+0x78/0x23c
PR is at ftrace_bug+0x74/0x23c
PC  : 80064df4 SP  : 8056ff70 SR  : 400080f0 TEA : c0000004
R0  : 00000001 R1  : 00000001 R2  : 8064d862 R3  : 8056ff64
R4  : 805b47b4 R5  : 00000001 R6  : 00000000 R7  : 00000001
R8  : 803b15d8 R9  : 00000001 R10 : 9fc38be8 R11 : 00000000
R12 : 8064e88c R13 : 8064e880 R14 : 8056ff70
MACH: 00000000 MACL: 003d0900 GBR : 296e1678 PR  : 80064df0

Call trace:
 [<80066a86>] ftrace_process_locs+0x15a/0x284
 [<803b15d8>] dns_query+0x0/0x26c
 [<805f6a1a>] ftrace_init+0x112/0x1a8
 [<801deec0>] strlen+0x0/0x58
 [<8008f098>] get_zeroed_page+0x0/0x34
 [<805f0918>] start_kernel+0x3e0/0x480
 [<801deec0>] strlen+0x0/0x58
 [<801eb388>] debug_smp_processor_id+0x0/0xe4
 [<80002132>] _stext+0x132/0x140

Code:
  80064dee:  mov       r9, r5
  80064df0:  tst       r9, r9
  80064df2:  bt        80064df6
->80064df4:  trapa     #62
  80064df6:  bra       80064ef2
  80064df8:  mov       r9, r5
  80064dfa:  mov.l     80064f68 <ftrace_bug+0x1ec/0x23c>, r1  ! 8064d862 <__warned.27604+0x0/0x1>
  80064dfc:  mov.b     r2, @r1
  80064dfe:  mov.l     80064f48 <ftrace_bug+0x1cc/0x23c>, r1  ! 8057021c <ftrace_disabled+0x0/0x4>

---[ end trace 4eaa2a86a8e2da22 ]---
ftrace failed to modify [<803b15d8>] dns_query+0x0/0x26c
 actual: 02:d1:22:4f
Testing tracer nop: PASSED

Suggestions?
