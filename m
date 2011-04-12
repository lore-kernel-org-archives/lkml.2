Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201Ab1DLMog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 08:44:36 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39253 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab1DLMof convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 08:44:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oSibPUO2XyNLqFq1jdBfmZEajd8wxIDt4Rlkgt92wNk/7xqzF0ZkeGgV6+xz1HCB7p
         jvbwlg8IQdvC+i6V0hnRPtSunD63KtY0OpcASitXElutC3SPdC/SYwnsPaqD4rqa6656
         qijt4nuuIe9sSr0uSbZu2ww5bTTIiS7RMN1f0=
MIME-Version: 1.0
In-Reply-To: <BANLkTin3gtiBk8nvsWEiJetKHq2+9HTi4w@mail.gmail.com>
References: <BANLkTin3gtiBk8nvsWEiJetKHq2+9HTi4w@mail.gmail.com>
Date: Tue, 12 Apr 2011 20:44:35 +0800
Message-ID: <BANLkTimJLcfsYAhV+3=-F14YZvX12-yXgA@mail.gmail.com>
Subject: Re: Processes hang in an unkillable state
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>
Cc: linux-kernel@vger.kernel.org, oleg@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/12 Robert Święcki <robert@swiecki.net>:
> Hi, while fuzzing Linux system calls (32bit fuzzer, 64bi linux
> kernel), it happens after some time (10-20mins) that some processes
> enter a state which makes them un-killable. They are either in R or D
> state.
>
> # strace ps wwuax
> ...
> ...
> open("/proc/450/cmdline", O_RDONLY)     = 6
> read(6,  -             hangs....
>
> # kill -9 450
> # kill -9 450 (no ESRCH)
>
> More data in the attachment - I'll keep it in the kdb session for
> further examination.

Hmm, it must be stuck at

lib/rwsem.c

        /* wait to be given the lock */
        for (;;) {
                if (!waiter.task)
                        break;
                schedule();
                set_task_state(tsk, TASK_UNINTERRUPTIBLE);
        }

don't know why it still can't acquire the ->mmap_sem...

Cc'ing Oleg...
