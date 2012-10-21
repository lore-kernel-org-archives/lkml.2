Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367Ab2JUQz3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 12:55:29 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:35075 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932337Ab2JUQz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 12:55:28 -0400
Date: Sun, 21 Oct 2012 18:55:23 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 2/2] perf: SNB exclusive PMU access for
 INST_RETIRED:PREC_DIST
Message-ID: <20121021165523.GA29247@gmail.com>
References: <1350658326-14715-1-git-send-email-eranian@google.com>
 <1350658326-14715-3-git-send-email-eranian@google.com>
 <1350664077.2768.32.camel@twins>
 <CABPqkBQ5kCyGByFS-D62RYg2VUf_W-rJKDH=AzyrcaBPVY-eFQ@mail.gmail.com>
 <1350665152.2768.41.camel@twins>
 <20121019172018.GA2095@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121019172018.GA2095@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <ak@linux.intel.com> wrote:

> > > > This isn't limited to admin, right? So the above turns into a DoS on the
> > > > console.
> > > >
> > > Ok, so how about a WARN_ON_ONCE() instead?
> > 
> > That should be fine I guess ;-)
> 
> imho there is need for a generic mechanism to return an error 
> string to the user program without such hacks.

Agreed - we could return an 'extended errno' long error return 
value, which in reality is a pointer to an error string (in 
perf_attr::error_str), and copy that string to user-space at 
perf syscall return time.

Thus error-string aware tooling could print the error string.

So PMU drivers could do something obvious like:

	return (long)"perf: INST_RETIRED.PREC_DIST only works in exclusive mode";

The perf syscall notices these pointers by noticing that the 
error code returned is outside the errno range.

Old userspace will get a -EINVAL and no string copied into the 
error string buffer.

New userspace would get the error string copied into 
perf_attr::error_str, plus a 'normal' -EINVAL error code.

The only cost on the kernel side is to make sure all "string 
errors" are returned as long.

Thanks,

	Ingo
