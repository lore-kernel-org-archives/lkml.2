Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381Ab0DUObz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 10:31:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34136 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755360Ab0DUObx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 10:31:53 -0400
Message-ID: <4BCF0C39.1080907@redhat.com>
Date: Wed, 21 Apr 2010 10:31:21 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Oleg Nesterov <oleg@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Ingo Molnar <mingo@elte.hu>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH -mm v6] tracepoint: Add signal coredump tracepoint
References: <20100412164830.514.85103.stgit@localhost6.localdomain6> <20100421001856.83743D10E@magilla.sf.frob.com>
In-Reply-To: <20100421001856.83743D10E@magilla.sf.frob.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roland,

Roland McGrath wrote:
>> Add signal coredump tracepoint which shows signal number,
>> mm->flags, core file size limitation, the result of
>> coredump, and core file name.
> 
> The "retval" encoding seems a bit arcane.  I wonder if it might be better
> to just have separate tracepoints for successful and failed dump attempts.
> Note that whether or not the dump succeeded is already available in
> (task->signal->group_exit_code & 0x80) as seen at exit or death tracing
> events.

OK, please read the previous discussion and tell me what you think about...
https://patchwork.kernel.org/patch/64345/
---
> > What do you think this tracepoint's use case?
> 
> Frankly to say, our first attempt was tracing mm->flags because
> it can be changed by users without asking, and they sometimes
> ask why core is not perfect or why core file is so big.
> 
> Perhaps, covering all of those failure cases and succeed cases,
> gives better information for them. In that case, we might better
> tweak execution(goto) path to leave some error code on retval.

This is enough acceptable to me.
---

> 
>> This tracepoint requirement comes mainly from the viewpoint of
>> administrators. [...]
> 
> The purposes you mention seem to be served well enough by this tracepoint.
> But I recall having the impression that one of the original motivating
> interests for tracing core-dump details was to understand when a giant core
> dump was responsible for huge amounts of i/o and/or memory thrashing.
> (Once you notice that happening, you might adjust coredump_filter settings
> to reduce the problem.)  Your new tracepoint doesn't help directly with
> tracking those sorts of issues, because it only happens after all the work
> is done.  If you are monitoring trace_signal_deliver, then you can filter
> those for SIG_DFL cases of sig_kernel_coredump() signals and recognize that
> as the beginning of the coredump.  Still, it might be preferable to have
> explicit start-core-dump and end-core-dump tracepoints.

No, that's not our interests. We are just interested in recording
coredump parameters when the coredump is done. After dumping core
(or failing to dump), we'd like to check what was wrong (wrong filter setting?),
or correctly dumped (and removed after).

> Furthermore, I can see potential use for tracepoints before and after
> coredump_wait(), which synchronizes other threads before actually starting
> to calculate and write the dump.  The window after coredump_wait() and
> before the post-dump tracepoint is where the actual work of writing the
> core file takes place, in case you want to monitor i/o load between those
> marks or suchlike.

Hmm, currently, we don't mention that.

> 
>> -	char corename[CORENAME_MAX_SIZE + 1];
>> +	char corename[CORENAME_MAX_SIZE + 1] = "";
> 
> This initialization of a stack array means the same as:
> 
> 	memset(corename, '\0', sizeof corename);
> 
> So the compiler generates that because those are the semantics.
> All you need is:
> 
> 	corename[0] = '\0';
> 
> since this is a string.

hm, ok. that's nice to fix.

Thank you,

> 
> 
> Thanks,
> Roland

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
