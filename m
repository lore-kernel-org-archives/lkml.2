Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075Ab1AVDSF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 22:18:05 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45591 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab1AVDSE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 22:18:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=v1/tf45IqWIjj+hcOSt3eKdxZPYJxQNOyWXzkH9hNFUDk+Q+CNwL0VhYQFULddKTqB
         fWDcgs1lxe2f0lHZuBT9Qsslj01XwN6pkGXWuyg6bylbJGbLnFkYMndsA8fhA1So+FPd
         kMrbEPGLohG+BaH/RTCE6MW2YthDXMdDrNjz8=
MIME-Version: 1.0
In-Reply-To: <20110122021226.GQ9506@random.random>
References: <web-444048714@zbackend1.aha.ru>
	<20110121191757.GO9506@random.random>
	<20110122021226.GQ9506@random.random>
Date: Sat, 22 Jan 2011 12:18:02 +0900
Message-ID: <AANLkTi=XmwRN6n5Ud_JGH=+PZShgdfE=-H96ije5uCm2@mail.gmail.com>
Subject: Re: [PATCH] thp: fix PARAVIRT x86 32bit noPAE
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: werner <w.landgraf@ru.ru>, akpm@linux-foundation.org, hannes@cmpxchg.org,
        idryomov@gmail.com, rostedt@goodmis.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, Johannes Weiner <jweiner@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 22, 2011 at 11:12 AM, Andrea Arcangeli <aarcange@redhat.com> wrote:
> I reproduced your 32bit x86 problem with an initramfs with a hugepage
> benchmark placed as /init inside KVM (not exactly an extensive test
> but it was trivial to reproduce). I tested below fix with HIGHMEM4G
> and HIGHMEM64G with PARAVIRT=y (and verified setting PARAVIRT=n fixed
> it, in other email Minchan also verified that setting HIGHMEM64G=y
> also fixed it, to confirm my theory the problem was the below #ifdef).
>
> The stress test reaches exit() successfully now (before the fix it
> crashed in out_of_memory() instead of do_exit as expected):
>
> NMI watchdog disabled for cpu0: unable to create perf event: -2
> �Kernel panic - not syncing: Attempted to kill init!
> Pid: 1, comm: init Not tainted 2.6.37+ #17
> Call Trace:
>  [<c14351d2>] ? panic+0x57/0x161
>  [<c107439b>] ? trace_hardirqs_on+0xb/0x10
>  [<c1045321>] ? do_exit+0x6b1/0x6e0
>  [<c10728ab>] ? trace_hardirqs_off+0xb/0x10
>  [<c1045389>] ? do_group_exit+0x39/0xa0
>  [<c1045403>] ? sys_exit_group+0x13/0x20
>  [<c1002d9c>] ? sysenter_do_call+0x12/0x3c
> QEMU 0.12.1 monitor - type 'help' for more information
> (qemu) quit
>
> ====
> Subject: thp: fix PARAVIRT x86 32bit noPAE
>
> From: Andrea Arcangeli <aarcange@redhat.com>
>
> This fixes TRANSPARENT_HUGEPAGE=y with PARAVIRT=y and HIGHMEM64=n.
>
> The #ifdef that this patch removes was erratically introduced to fix a build
> error for noPAE (where pmd.pmd doesn't exist). So then the kernel built but it
> failed at runtime because set_pmd_at was a noop. This will correct it by
> enabling set_pmd_at for noPAE mode too.
>
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>

It works well in my system until kernel compile completed while dd
if=/dev/sda3 of=/dev/zero and really slow web browsing.

Thanks, Andrea.

Reported-by: Minchan Kim <minchan.kim@gmail.com>
Tested-by: Minchan Kim <minchan.kim@gmail.com>


-- 
Kind regards,
Minchan Kim
