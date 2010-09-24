Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab0IXKXX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 06:23:23 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:50220 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752250Ab0IXKXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 06:23:22 -0400
To: hch@infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: Tomoyo compile failure on alpha: sys_get[p]pid undefined
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <alpine.SOC.1.00.1009240906200.9058@math.ut.ee>
	<20100924075116.GA2303@infradead.org>
In-Reply-To: <20100924075116.GA2303@infradead.org>
Message-Id: <201009241923.GFE89377.tQFMFFOJSHOOVL@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 24 Sep 2010 19:23:13 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Fri, Sep 24, 2010 at 09:10:37AM +0300, Meelis Roos wrote:
> > 2.6.36-rc5+git as of yesterday:
> > 
> >   LD      .tmp_vmlinux1
> > security/built-in.o: In function `tomoyo_supervisor':(.text+0xea98): undefined reference to `sys_getpid'
> > security/built-in.o: In function `tomoyo_supervisor':(.text+0xeab0): undefined reference to `sys_getpid'
> > security/built-in.o: In function `tomoyo_supervisor':(.text+0xeac0): undefined reference to `sys_getppid'
> > security/built-in.o: In function `tomoyo_supervisor':(.text+0xeac4): undefined reference to `sys_getppid'
> > 
> > Seems alpha has different mechanisms for using these syscalls from 
> > inside the kernel?
> 
> The real problem is that kernel code should never call system calls.
> The correct fix is to get rid of this abuse.
> 
AUDITSYSCALL (kernel/auditsc.c) is using sys_getppid().
What is your plan for getting rid of below abuse?

static void audit_log_exit(struct audit_context *context, struct task_struct *tsk)
{
        const struct cred *cred;
        int i, call_panic = 0;
        struct audit_buffer *ab;
        struct audit_aux_data *aux;
        const char *tty;

        /* tsk == current */
        context->pid = tsk->pid;
        if (!context->ppid)
                context->ppid = sys_getppid();
        cred = current_cred();
...(snipped)...
}
