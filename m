Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932552Ab2JURyq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 13:54:46 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:50557 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932346Ab2JURyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 13:54:45 -0400
MIME-Version: 1.0
In-Reply-To: <20121021165523.GA29247@gmail.com>
References: <1350658326-14715-1-git-send-email-eranian@google.com>
	<1350658326-14715-3-git-send-email-eranian@google.com>
	<1350664077.2768.32.camel@twins>
	<CABPqkBQ5kCyGByFS-D62RYg2VUf_W-rJKDH=AzyrcaBPVY-eFQ@mail.gmail.com>
	<1350665152.2768.41.camel@twins>
	<20121019172018.GA2095@tassilo.jf.intel.com>
	<20121021165523.GA29247@gmail.com>
Date: Sun, 21 Oct 2012 19:54:43 +0200
Message-ID: <CABPqkBR_BSf6Akzxn+2gOrksUMXmAgPi3xY0KJUbhT0Eddo3Kw@mail.gmail.com>
Subject: Re: [PATCH 2/2] perf: SNB exclusive PMU access for INST_RETIRED:PREC_DIST
From: Stephane Eranian <eranian@google.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 21, 2012 at 6:55 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Andi Kleen <ak@linux.intel.com> wrote:
>
>> > > > This isn't limited to admin, right? So the above turns into a DoS on the
>> > > > console.
>> > > >
>> > > Ok, so how about a WARN_ON_ONCE() instead?
>> >
>> > That should be fine I guess ;-)
>>
>> imho there is need for a generic mechanism to return an error
>> string to the user program without such hacks.
>
> Agreed - we could return an 'extended errno' long error return
> value, which in reality is a pointer to an error string (in
> perf_attr::error_str), and copy that string to user-space at
> perf syscall return time.
>
I assume by perf_attr:error_str, you actually mean:

struct perf_event_attr {
   char error_str[PERF_ERR_LEN];
};

Right?

> Thus error-string aware tooling could print the error string.
>
> So PMU drivers could do something obvious like:
>
>         return (long)"perf: INST_RETIRED.PREC_DIST only works in exclusive mode";
>
> The perf syscall notices these pointers by noticing that the
> error code returned is outside the errno range.
>
Is that always the case on all archs?

> Old userspace will get a -EINVAL and no string copied into the
> error string buffer.
>
> New userspace would get the error string copied into
> perf_attr::error_str, plus a 'normal' -EINVAL error code.
>
> The only cost on the kernel side is to make sure all "string
> errors" are returned as long.
>
> Thanks,
>
>         Ingo
