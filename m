Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755Ab2BMFe3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 00:34:29 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:47108 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab2BMFe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 00:34:28 -0500
Date: Mon, 13 Feb 2012 13:34:10 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Venki Pallipadi <venki@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Aaron Durbin <adurbin@google.com>, Paul Turner <pjt@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] Extend mwait idle to optimize away IPIs when possible
Message-ID: <20120213053410.GB24636@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1328560933-3037-1-git-send-email-venki@google.com>
 <1328901567.25989.51.camel@laptop>
 <CABeCy1aUj9MM8YabvvQCYYFm4FNMsomU3PZ1ZyoKikL9hnc9uQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CABeCy1aUj9MM8YabvvQCYYFm4FNMsomU3PZ1ZyoKikL9hnc9uQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 06:11:58PM -0800, Venki Pallipadi wrote:
> On Fri, Feb 10, 2012 at 11:19 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Mon, 2012-02-06 at 12:42 -0800, Venkatesh Pallipadi wrote:
> >> smp_call_function_single and ttwu_queue_remote sends unconditional IPI
> >> to target CPU. However, if the target CPU is in mwait based idle, we can
> >> do IPI-less wakeups using the magical powers of monitor-mwait.
> >
> > So I was thinking, why not change native_smp_send_reschedule() and
> > native_send_call_func_single_ipi() and keep the change entirely inside
> > the arch?
> >
> > Ideally its only APIC/idle that know about this detail, the scheduler
> > (or other consumers) really don't care about how the other cpu comes to
> > run the callback.
> >
> 
> OK. Moving most of this into arch code will be cleaner. But, Yong
> mentioned in this thread that he was looking to do something similar
> on MIPS. So, we may end up with some code duplication though..

Yeah, most of the things could be shared. Such as the added logic when
return from idle and the hooks into ttwu_queue_remote() and
generic_exec_single().

BTW, I think we should also let the arch provide a wrapper for
TIF_IPI_PENDING, such as tsk_ipi_pending().

Thanks,
Yong
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Only stand for myself
