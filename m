Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758805Ab0I0DQZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 23:16:25 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:40017 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758362Ab0I0DQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 23:16:23 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: Tomoyo compile failure on alpha: sys_get[p]pid undefined
Cc: kosaki.motohiro@jp.fujitsu.com, Meelis Roos <mroos@linux.ee>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-alpha@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Kentaro Takeda <takedakn@nttdata.co.jp>
In-Reply-To: <20100924075116.GA2303@infradead.org>
References: <alpine.SOC.1.00.1009240906200.9058@math.ut.ee> <20100924075116.GA2303@infradead.org>
Message-Id: <20100927121505.6B42.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 27 Sep 2010 12:16:19 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

I agree.

The problem function is here.

---------------------------------------------------------------
static char *tomoyo_print_header(struct tomoyo_request_info *r)
{
        struct timeval tv;
        const pid_t gpid = task_pid_nr(current);
        static const int tomoyo_buffer_len = 4096;
        char *buffer = kmalloc(tomoyo_buffer_len, GFP_NOFS);
        if (!buffer)
                return NULL;
        do_gettimeofday(&tv);
        snprintf(buffer, tomoyo_buffer_len - 1,
                 "#timestamp=%lu profile=%u mode=%s (global-pid=%u)"
                 " task={ pid=%u ppid=%u uid=%u gid=%u euid=%u"
                 " egid=%u suid=%u sgid=%u fsuid=%u fsgid=%u }",
                 tv.tv_sec, r->profile, tomoyo_mode[r->mode], gpid,
                 (pid_t) sys_getpid(), (pid_t) sys_getppid(),
                 current_uid(), current_gid(), current_euid(),
                 current_egid(), current_suid(), current_sgid(),
                 current_fsuid(), current_fsgid());
        return buffer;
}
---------------------------------------------------------------

It has alread used task_pid_nr(). there is no reason to avoid
to call task_tgid_vnr() directly. I bet.

IOW, I think tomoyo can fix this issue easily.



