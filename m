Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab1BOQys (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 11:54:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23386 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751209Ab1BOQyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 11:54:46 -0500
Date: Tue, 15 Feb 2011 17:54:43 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC,PATCH] kprobes - optimized kprobes might crash before
 setting kernel stack
Message-ID: <20110215165443.GC3135@jolsa.brq.redhat.com>
References: <1297696354-6990-1-git-send-email-jolsa@redhat.com>
 <4D5A4A66.4010503@hitachi.com>
 <20110215123058.GB3135@jolsa.brq.redhat.com>
 <4D5AA209.7070309@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D5AA209.7070309@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 12:55:53AM +0900, Masami Hiramatsu wrote:
> (2011/02/15 21:30), Jiri Olsa wrote:
> > On Tue, Feb 15, 2011 at 06:41:58PM +0900, Masami Hiramatsu wrote:
> >> (2011/02/15 0:12), Jiri Olsa wrote:
> >>> hi,
> >>>
> >>> you can crash the kernel using kprobe tracer via:
> >>>
> >>> echo "p system_call_after_swapgs" > ./kprobe_events
> >>> echo 1 > ./events/kprobes/enable
> >>
> >> Ah, thank you very much!
> >>
> >>> The reason is that at the system_call_after_swapgs label,
> >>> the kernel stack is not set up. If optimized kprobes are
> >>> enabled, the user space stack is being used in this case
> >>> (see optimized kprobe template) and this might result in a crash.
> >>
> >> Verified here, and also it didn't occur when turning optimization
> >> off by sysctl. So this is a bug of kprobe jump optimization, not
> >> kprobes itself.
> >>
> >>> Looks like there are several places like this over the entry_$(BIT)
> >>> code. First I thought it'd be ok to localize those places, but
> >>> I haven't found any reasonable/maintainable way to disable only those
> >>> places.
> >>
> >> Hmm, agreed.
> >>
> >>> So I switched off the whole entry code from optimizing, but this
> >>> also switch many safe places (attached patch - tested on x86_64).
> >>
> >> I'm OK for this solution. I think possible another solution is using
> >> interrupt stack in optprobe template too. Anyway in short term, this
> >> solution will be good.
> > 
> > ok, I'll test on 32 bits and resend to Ingo
> 
> Thanks!
> And also, with deeply thinking about this problem, it seems that
> your idea could be the best way to fix, because kprobes can not
> know where the kernel stack is ready without those text section.
> 
> 
> >>> Also not sure this crash falls in to the area of that once such
> >>> probe is used, user should know consequences..
> >>
> >> User can see that those probe is not optimized via sysfs.
> > 
> > I cannot find this, where can I see this info?
> 
> Ah, actually, that is under debugfs, which is usually mounted on
> /sys/kernel/debug. You can read "/sys/kernel/debug/kprobes/list"
> for getting a list of currently registered probes.

I see, thanks

jirka

> 
> Thank you,
> -- 
> Masami HIRAMATSU
> 2nd Dept. Linux Technology Center
> Hitachi, Ltd., Systems Development Laboratory
> E-mail: masami.hiramatsu.pt@hitachi.com
