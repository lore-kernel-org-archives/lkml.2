Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649Ab0FIMYZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 08:24:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:41979 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755020Ab0FIMYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 08:24:23 -0400
Subject: Re: [tip:perf/core] perf: Add non-exec mmap() tracking
From: Peter Zijlstra <peterz@infradead.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: mingo@redhat.com, hpa@zytor.com, anton@samba.org, acme@redhat.com,
       paulus@samba.org, linux-kernel@vger.kernel.org, efault@gmx.de,
       fweisbec@gmail.com, ebmunson@us.ibm.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
In-Reply-To: <AANLkTimsd32TL44V-aXvEoa3SE63X6qaOmMny9Q8uNRi@mail.gmail.com>
References: <1274193049-25997-1-git-send-email-ebmunson@us.ibm.com>
	 <tip-3af9e859281bda7eb7c20b51879cf43aa788ac2e@git.kernel.org>
	 <AANLkTimsd32TL44V-aXvEoa3SE63X6qaOmMny9Q8uNRi@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Jun 2010 14:22:13 +0200
Message-ID: <1276086133.1645.575.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-09 at 13:44 +0300, Pekka Enberg wrote:
> > @@ -3830,6 +3834,14 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
> >                if (!vma->vm_mm) {
> >                        name = strncpy(tmp, "[vdso]", sizeof(tmp));
> >                        goto got_name;
> > +               } else if (vma->vm_start <= vma->vm_mm->start_brk &&
> > +                               vma->vm_end >= vma->vm_mm->brk) {
> > +                       name = strncpy(tmp, "[heap]", sizeof(tmp));
> > +                       goto got_name;
> > +               } else if (vma->vm_start <= vma->vm_mm->start_stack &&
> > +                               vma->vm_end >= vma->vm_mm->start_stack) {
> > +                       name = strncpy(tmp, "[stack]", sizeof(tmp));
> > +                       goto got_name;
> >                }
> >
> >                name = strncpy(tmp, "//anon", sizeof(tmp));
> 
> Doesn't this change here break the JIT generated code region detection
> in map__new() of tools/perf/util/map.c? We generate a new
> "/tmp/perf-<pid>.map" filename for anonymous memory regions and check
> for that in dso__load() of tools/perf/util/symbol.c. 

Not unless you stick your executable code in the heap or on the stack.

If you use something like mmap(NULL, size, PROT_READ|PROT_WRITE|
PROT_EXEC, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0); to allocate your memory
everything should be fine.



