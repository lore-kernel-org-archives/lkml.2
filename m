Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508Ab0FIKoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 06:44:23 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56107 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab0FIKoV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 06:44:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=PExvtJr76C2zNn2XgL2bYL55usNrYpISPkNB1/UU9sooBiGC9XjR9m2FfyYamwdANW
         Xu6C1shtjJ74/A+52Pi5Jmjow8RTOuoH7RVOBHD6/ZFF4noD23cpZSkzHoMvH4QDrh1+
         WdWpGvEfnmZyKh5WsIuG6NhcibNLjrdsP07go=
MIME-Version: 1.0
In-Reply-To: <tip-3af9e859281bda7eb7c20b51879cf43aa788ac2e@git.kernel.org>
References: <1274193049-25997-1-git-send-email-ebmunson@us.ibm.com>
	<tip-3af9e859281bda7eb7c20b51879cf43aa788ac2e@git.kernel.org>
Date: Wed, 9 Jun 2010 13:44:19 +0300
X-Google-Sender-Auth: Cl3MWCEImMSP_GO5Z6kf1x10cl8
Message-ID: <AANLkTimsd32TL44V-aXvEoa3SE63X6qaOmMny9Q8uNRi@mail.gmail.com>
Subject: Re: [tip:perf/core] perf: Add non-exec mmap() tracking
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@redhat.com, hpa@zytor.com, anton@samba.org, acme@redhat.com,
       paulus@samba.org, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       efault@gmx.de, fweisbec@gmail.com, ebmunson@us.ibm.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H Eric,

On Wed, Jun 9, 2010 at 1:15 PM, tip-bot for Eric B Munson
<ebmunson@us.ibm.com> wrote:
> Commit-ID:  3af9e859281bda7eb7c20b51879cf43aa788ac2e
> Gitweb:     http://git.kernel.org/tip/3af9e859281bda7eb7c20b51879cf43aa788ac2e
> Author:     Eric B Munson <ebmunson@us.ibm.com>
> AuthorDate: Tue, 18 May 2010 15:30:49 +0100
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Wed, 9 Jun 2010 11:12:34 +0200
>
> perf: Add non-exec mmap() tracking
>
> Add the capacility to track data mmap()s. This can be used together
> with PERF_SAMPLE_ADDR for data profiling.
>
> Signed-off-by: Anton Blanchard <anton@samba.org>
> [Updated code for stable perf ABI]
> Signed-off-by: Eric B Munson <ebmunson@us.ibm.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> LKML-Reference: <1274193049-25997-1-git-send-email-ebmunson@us.ibm.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

> @@ -3830,6 +3834,14 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
>                if (!vma->vm_mm) {
>                        name = strncpy(tmp, "[vdso]", sizeof(tmp));
>                        goto got_name;
> +               } else if (vma->vm_start <= vma->vm_mm->start_brk &&
> +                               vma->vm_end >= vma->vm_mm->brk) {
> +                       name = strncpy(tmp, "[heap]", sizeof(tmp));
> +                       goto got_name;
> +               } else if (vma->vm_start <= vma->vm_mm->start_stack &&
> +                               vma->vm_end >= vma->vm_mm->start_stack) {
> +                       name = strncpy(tmp, "[stack]", sizeof(tmp));
> +                       goto got_name;
>                }
>
>                name = strncpy(tmp, "//anon", sizeof(tmp));

Doesn't this change here break the JIT generated code region detection
in map__new() of tools/perf/util/map.c? We generate a new
"/tmp/perf-<pid>.map" filename for anonymous memory regions and check
for that in dso__load() of tools/perf/util/symbol.c.

                        Pekka
