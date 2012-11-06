Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab2KFPt3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 10:49:29 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:57265 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab2KFPt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 10:49:28 -0500
MIME-Version: 1.0
In-Reply-To: <20121106154446.GA13629@infradead.org>
References: <1352123463-7346-1-git-send-email-eranian@google.com>
	<1352123463-7346-15-git-send-email-eranian@google.com>
	<20121106154446.GA13629@infradead.org>
Date: Tue, 6 Nov 2012 16:49:26 +0100
Message-ID: <CABPqkBSh_QGrZrQgmLKavuGLz+jC4fyczLGffo6iWnpzW6BzfA@mail.gmail.com>
Subject: Re: [PATCH v2 14/16] perf tools: add new mem command for memory
 access profiling
From: Stephane Eranian <eranian@google.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 6, 2012 at 4:44 PM, Arnaldo Carvalho de Melo
<acme@redhat.com> wrote:
> Em Mon, Nov 05, 2012 at 02:51:01PM +0100, Stephane Eranian escreveu:
>> +
>> +     if (strcmp(mem_operation, MEM_OPERATION_LOAD))
>> +             sprintf(event, "cpu/mem-stores/pp");
>> +     else
>> +             sprintf(event, "cpu/mem-loads/pp");
>> +
>
> Fails for me on a Sandy Bridge notebook:
>
That's because you need to update the microcode.

$ sudo modprobe microcode
$ cat /proc/cpuinfo

Line with microcode needs to say:
microcode : 0x28

update the microcode package or install directly from
intel download center.

> [root@sandy ~]# perf mem -t store record -a
> Error:
> 'precise' request may not be supported. Try removing 'p' modifier
>
> So if I manually fall back to a less precise mode:
>
> [root@sandy ~]# perf record -g -a -e cpu/mem-stores/p
> Error:
> 'precise' request may not be supported. Try removing 'p' modifier
> [root@sandy ~]#
>
> Still can't, manually fall back a one more level:
>
> [root@sandy ~]# perf record -g -a -e cpu/mem-stores/
> ^C[ perf record: Woken up 25 times to write data ]
> [ perf record: Captured and wrote 7.419 MB perf.data (~324160 samples) ]
>
> Yay, got some numbers.
>
> smpboot: CPU0: Intel(R) Core(TM) i7-2920XM CPU @ 2.50GHz (fam: 06, model: 2a, stepping: 07)
> Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge events, Intel PMU driver.
> perf_event_intel: PEBS disabled due to CPU errata, please upgrade microcode
> ... version:                3
> ... bit width:              48
> ... generic registers:      4
> ... value mask:             0000ffffffffffff
> ... max period:             000000007fffffff
> ... fixed-purpose events:   3
> ... event mask:             000000070000000f
> Disabled fast string operations
> NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
>
> Do you have any test program you use to test if the results make sense that you
> could share?
>
> I could then try to shape it into a new 'perf test' entry that would test
> if requesting this event and then doing synthetic testing would produce
> the experted numbers or in a acceptable range.
>
> One suggestion for such new features, examples of use with the resulting output
> looks great on changeset logs :-)
>
> Ah, I recall seeing some, but that was on the patchset cover letter,
> that doesn't get inserted in the git changelog history, will look at those
> now.
>
> - Arnaldo
