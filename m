Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431Ab2CKEJt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 23:09:49 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:42828 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab2CKEJr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 23:09:47 -0500
MIME-Version: 1.0
In-Reply-To: <2C80D678-F219-4B4E-A7FB-D0F890ECC7DD@gmx.ch>
References: <2C80D678-F219-4B4E-A7FB-D0F890ECC7DD@gmx.ch>
Date: Sun, 11 Mar 2012 12:09:46 +0800
Message-ID: <CAJd=RBBnxKa+roD+G-G_bnVLBKCmw-wtW+pO8BtQRVmPkRoJpw@mail.gmail.com>
Subject: Re: bug in thread_group_times (+possible patch)
From: Hillf Danton <dhillf@gmail.com>
To: Fawzi Mohamed <fawzi@gmx.ch>
Cc: linux-kernel@vger.kernel.org, Thomas Dargel <td@chemie.hu-berlin.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Fawzi,

On Sun, Mar 11, 2012 at 7:11 AM, Fawzi Mohamed <fawzi@gmx.ch> wrote:
> Hi,
>
> a friend of mine asked me about a kernel crash that he was having on a linux cluster (always after long compute intensive task).
> I found the bug causing it, and patched it (in an imperfect way), and as I have seen that in the current git the bug is still there, I am writing it here.
> I am not into kernel development, so I did not subscribe to the list, please CC me if you want me to answer.
> Sorry if this is not the correct way, but I hope this might help to squash just another little bug.
>
> Now the bug is in kernel/sched/core.c in thread_group_times which if CONFIG_VIRT_CPU_ACCOUNTING is not defined looks like this
>
> void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
> {
>        struct signal_struct *sig = p->signal;
>        struct task_cputime cputime;
>        cputime_t rtime, utime, total;
>
>        thread_group_cputime(p, &cputime);
>
>        total = cputime.utime + cputime.stime;
>        rtime = nsecs_to_cputime(cputime.sum_exec_runtime);
>
>        if (total) {
>                u64 temp = (__force u64) rtime;
>
>                temp *= (__force u64) cputime.utime;

Would you please try the tiny change?

-                do_div(temp, (__force u32) total);
+                temp = div64_u64(temp, (__force u64) total);

>                utime = (__force cputime_t) temp;
>        } else
>                utime = rtime;
>
