Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759330Ab2BJNtU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 08:49:20 -0500
Received: from mail-lpp01m020-f174.google.com ([209.85.217.174]:40803 "EHLO
	mail-lpp01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757937Ab2BJNtT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 08:49:19 -0500
MIME-Version: 1.0
In-Reply-To: <20120210134646.GB4998@infradead.org>
References: <20120209103016.GA1999@quad>
	<20120209144844.GA4998@infradead.org>
	<CABPqkBRdbn+UasvWgVco-NZ_LasFeG+7bLzTDVcQO-e6J+AW-Q@mail.gmail.com>
	<20120210134646.GB4998@infradead.org>
Date: Fri, 10 Feb 2012 14:49:17 +0100
Message-ID: <CABPqkBSuSmnGB2J53kvwJYcUndC5RRC76w_kzZjSCX49n_iyFg@mail.gmail.com>
Subject: Re: [PATCH] perf: add sanity check on addr in symbol__inc_addr_samples()
From: Stephane Eranian <eranian@google.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 2:46 PM, Arnaldo Carvalho de Melo
<acme@redhat.com> wrote:
> Em Thu, Feb 09, 2012 at 03:53:14PM +0100, Stephane Eranian escreveu:
>> On Thu, Feb 9, 2012 at 3:48 PM, Arnaldo Carvalho de Melo
>> <acme@redhat.com> wrote:
>> > Em Thu, Feb 09, 2012 at 11:30:16AM +0100, Stephane Eranian escreveu:
>> >>
>> >> Check the value of addr against the bounds of the symbol.
>> >> This is needed given we compute an offset:
>> >>       offset = addr - sym->start
>> >>
>> >> And we don't want the offset to become negative.
>> >
>> > I'll try and add a debug option to show the backtrace and values of
>> > addr, sym, etc, so that we can fix the real problem.
>
>> > I.e. this function shouldn't be receiving any such invalid addresses, as
>> > the symbol lookup was done, the symbol was found to be this one, then
>> > why it would be out of bounds at this point?!
>
>> I tend to agree with you on this. But then I don't see why the first test
>> was there.
>
> Its wrong as well, we should leave it there, together with the new test,
> but as:
>
>        BUG_ON(addr >= sym->end || addr < sym->start)
>
Fine with me. It makes more sense.

> - Arnaldo
>
>> > - Arnaldo
>> >
>> >> Signed-off-by: Stephane Eranian <eranian@google.com>
>> >>
>> >> diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
>> >> index 011ed26..8248d80 100644
>> >> --- a/tools/perf/util/annotate.c
>> >> +++ b/tools/perf/util/annotate.c
>> >> @@ -64,7 +64,7 @@ int symbol__inc_addr_samples(struct symbol *sym, struct map *map,
>> >>
>> >>       pr_debug3("%s: addr=%#" PRIx64 "\n", __func__, map->unmap_ip(map, addr));
>> >>
>> >> -     if (addr >= sym->end)
>> >> +     if (addr >= sym->end || addr < sym->start)
>> >>               return 0;
>> >>
>> >>       offset = addr - sym->start;
