Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab2EXKHA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 06:07:00 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:59896 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753381Ab2EXKG6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 06:06:58 -0400
MIME-Version: 1.0
In-Reply-To: <1337853048.9783.92.camel@laptop>
References: <1337801535-12865-1-git-send-email-jolsa@redhat.com>
	<1337801535-12865-3-git-send-email-jolsa@redhat.com>
	<1337853048.9783.92.camel@laptop>
Date: Thu, 24 May 2012 12:06:57 +0200
Message-ID: <CABPqkBR9hewjNUJf9ByD-jHc42e_qwQiKoP68RyL7BU8Q7BGgQ@mail.gmail.com>
Subject: Re: [PATCH 02/16] perf: Add ability to attach registers dump to sample
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jiri Olsa <jolsa@redhat.com>, acme@redhat.com, mingo@elte.hu,
        paulus@samba.org, cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        gorcunov@openvz.org, tzanussi@gmail.com, mhiramat@redhat.com,
        robert.richter@amd.com, fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com, asharma@fb.com,
        benjamin.redelings@nescent.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 11:50 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Wed, 2012-05-23 at 21:32 +0200, Jiri Olsa wrote:
>>  /*
>> + * Values for sample_regs when PERF_SAMPLE_REGS is set.
>> + * Defines register set to be attached to the sample.
>> + */
>> +enum perf_sample_regs {
>> +       PERF_SAMPLE_REGS_USER   = 1U << 0, /* user registers */
>> +       PERF_SAMPLE_REGS_MAX    = 1U << 1, /* non-ABI */
>> +};
>
>
>
>> +       __u64   sample_regs; /* enum perf_sample_regs */
>> +
>> +       /*
>> +        * Arch specific mask for PERF_SAMPLE_REGS_USER setup.
>> +        * Defines set of user regs to dump on samples.
>> +        * See asm/perf_regs.h for details.
>> +        */
>> +       __u64   sample_regs_user;
>
> This all just smells.. :/
>
> So you're wasting 64 bits to specify PERF_SAMPLE_REGS_USER while also
> implying we'll need another u64 for every other value of
> perf_sample_regs?
>
> What are we doing here and why?
>
I think this is related to a discusion we had earlier about which
machine state you want
to sample.

There are 3 possible machine states:
  1- user level (even when sample is in kernel AND assuming you did
not hit a kernel only thread)
  2- interrupted state (@ PMU interrupt)
  3- precise state (state captured by PEBS on Intel, for instance)

Jiri is only interested in 1/. I am interested in the other two as well.

Question: is there a situation where we could need more than one machine
state per sample?

If not, then a single bitmask is enough.
