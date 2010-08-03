Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab0HCHh4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 03:37:56 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:42344 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab0HCHhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 03:37:54 -0400
To: Hui Zhu <teawater@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Simon Kagstrom <simon.kagstrom@netinsight.net>,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kexec: set prstatus.pr_pid to cpu id when current->pid is 0
References: <AANLkTikuUi=i6Lk-ZpE65Gr0tWOeVnrnpWPe85T=J=Ph@mail.gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 03 Aug 2010 00:37:46 -0700
In-Reply-To: <AANLkTikuUi=i6Lk-ZpE65Gr0tWOeVnrnpWPe85T=J=Ph@mail.gmail.com> (Hui Zhu's message of "Tue\, 3 Aug 2010 15\:21\:49 +0800")
Message-ID: <m1zkx4w3hx.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.4.80;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.4.80
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hui Zhu <teawater@gmail.com> writes:

> Hi,
>
> I found that from gdb 7.1 to gdb-cvs-head cannot analyze the core file
> that get from kdump.
> What I got:
> [New <main task>]
> [New Thread 2719]
> ../../src/gdb/thread.c:884: internal-error: switch_to_thread:
> Assertion `inf != NULL' failed.
> A problem internal to GDB has been detected,
> further debugging may prove unreliable.
> Quit this debugging session? (y or n)
> That is because:
>  objdump -h ./vmcore
>
> ./vmcore:     file format elf64-x86-64
>
> Sections:
> Idx Name          Size      VMA               LMA               File off  Algn
>   0 note0         00000a48  0000000000000000  0000000000000000  00000238  2**0
>                   CONTENTS, READONLY
>   1 .reg/0        000000d8  0000000000000000  0000000000000000  000002bc  2**2
>                   CONTENTS
>   2 .reg          000000d8  0000000000000000  0000000000000000  000002bc  2**2
>                   CONTENTS
>   3 .reg/2719     000000d8  0000000000000000  0000000000000000  00000420  2**2
>                   CONTENTS
>   4 .reg/0        000000d8  0000000000000000  0000000000000000  00000584  2**2
>                   CONTENTS
>   5 .reg/0        000000d8  0000000000000000  0000000000000000  000006e8  2**2
>                   CONTENTS
> Each of reg/n is a cpu core note.  It will be a GDB thread.  n is the
> prstatus.pr_pid that will be the thread lwpid.  Because the 3 threads
> pid is same, so GDB get error.
>
> current->pid is 0 because this cpu is in idle.  So I add a check, set
> prstatus.pr_pid to cpu id when current->pid is 0.  Then GDB work OK
> with the core.

That is a gdb limitation.  It looks to me like applying this patch will
loose information, and give you no guarantee that prstatus.pr_pid will
not equal 0.

If you want to change something please do it in a post processing tool.

Eric


> Thanks,
> Hui
>
> Signed-off-by: Hui Zhu <teawater@gmail.com>
> ---
>  kernel/kexec.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -1191,7 +1191,10 @@ void crash_save_cpu(struct pt_regs *regs
>  	if (!buf)
>  		return;
>  	memset(&prstatus, 0, sizeof(prstatus));
> -	prstatus.pr_pid = current->pid;
> +	if (current->pid)
> +		prstatus.pr_pid = current->pid;
> +	else
> +		prstatus.pr_pid = cpu;
>  	elf_core_copy_kernel_regs(&prstatus.pr_reg, regs);
>  	buf = append_elf_note(buf, KEXEC_CORE_NOTE_NAME, NT_PRSTATUS,
>  		      	      &prstatus, sizeof(prstatus));
