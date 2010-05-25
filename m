Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932620Ab0EYKZP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 06:25:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8450 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932380Ab0EYKZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 06:25:12 -0400
Date: Tue, 25 May 2010 12:23:45 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Frysinger <vapier@gentoo.org>, linux-sh@vger.kernel.org,
       Paul Mundt <lethal@linux-sh.org>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/1] ptrace: PTRACE_GETFDPIC: fix the unsafe usage
	of child->mm
Message-ID: <20100525102345.GA23574@redhat.com>
References: <20100524234250.F158849A56@magilla.sf.frob.com> <20100522165401.GB19573@redhat.com> <1266280229-18469-1-git-send-email-vapier@gentoo.org> <1274431345-22366-1-git-send-email-vapier@gentoo.org> <20100521162659.GA16193@redhat.com> <20100521183512.4477F40476@magilla.sf.frob.com> <20100522165320.GA19573@redhat.com> <25539.1274711817@redhat.com> <20100524151445.GA6393@redhat.com> <17134.1274778852@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17134.1274778852@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25, David Howells wrote:
>
> Roland McGrath <roland@redhat.com> wrote:
>
> > The mm pointer is only used by these uncommon ptrace operations
>
> Like PEEKTEXT and POKETEXT?

They use access_process_vm().

According to grep, mm is only use to read a couple of members.

Perhaps can even add the simple helper

	struct mm_xxx {
		unsigned long start_code, end_code, start_data, end_data;
		... some more ...
	};

	int get_mm_xxx(struct task_struct *tracee, struct mm_xxx *mm_xxx)
	{
		struct mm_struct *mm = get_task_mm(tracee);
		...
	}

Except:

	- arch/um/kernel/ptrace.c PTRACE_SWITCH_MM does something
	  really strange

	- arch/blackfin/kernel/ptrace.c:is_user_addr_valid()
	  needs mmap_sem around find_vma()

	  The lockless access to mm->context.sram_list doesn't look
	  safe to me.

	  If we add get_task_mm() - this protects us against
	  destroy_context() only. What is the tracee's sub-thread
	  does sys_sram_alloc() or sys_sram_free() in parallel?

Oleg.

