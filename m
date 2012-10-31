Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935005Ab2JaJYA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 05:24:00 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:60331 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972Ab2JaJX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 05:23:57 -0400
MIME-Version: 1.0
In-Reply-To: <CABPqkBSRj4FAQpG_vGOmKzvsv+7oWmtAaesJ5+-RuUJmOer2zw@mail.gmail.com>
References: <CABPqkBSRj4FAQpG_vGOmKzvsv+7oWmtAaesJ5+-RuUJmOer2zw@mail.gmail.com>
Date: Wed, 31 Oct 2012 10:23:56 +0100
Message-ID: <CABPqkBQZZWHF5cRdYxmcq4QxaTg_sT_8gomK2mPm+ksML+DHBg@mail.gmail.com>
Subject: Re: [BUG] perf tools: does not process data mmaps correctly
From: Stephane Eranian <eranian@google.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2012 at 9:29 PM, Stephane Eranian <eranian@google.com> wrote:
> Arnaldo,
>
> A long time ago, I brought up the issue of perf failing to resolve
> data symbols despite having the MAP__VARIABLE map type.
>
> Now that I have posted the PEBS-LL patch series, there is a test
> case to debug this.
>
> I looked again at it today. Start from ip__resolve_data() in my patchset.
> IT is looking for a data symbol given an address.
>
> Seems to me the core of the problem is how perf processes the MMAP
> records in machine__process_mmap_event():
>
> int machine__process_mmap_event(struct machine *machine, union
> perf_event *event)
> {
>       ...
>
>         thread = machine__findnew_thread(machine, event->mmap.pid);
>         if (thread == NULL)
>                 goto out_problem;
>         map = map__new(&machine->user_dsos, event->mmap.start,
>                         event->mmap.len, event->mmap.pgoff,
>                         event->mmap.pid, event->mmap.filename,
>                         MAP__FUNCTION);
>
> I don't see any effort to distinguish code from data here. All mmaps are
> treated as code.
>
> That could be fine, if then you drop MAP__VARIABLE.
>
> So how is this supposed to work?
>

Looking at the kernel code for attr->mmap_data shows a corollary
problem with the RECORD_MMAP. Somehow we lose the fact
that this corresponds to data mmap (!VM_EXEC). Having that
info in the header would help the tool process the record properly,
I think.
