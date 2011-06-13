Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131Ab1FMLkw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 07:40:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967Ab1FMLkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 07:40:51 -0400
Message-ID: <4DF5F729.4060609@redhat.com>
Date: Mon, 13 Jun 2011 14:40:25 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH 08/10] NOTIFIER: Take over TIF_MCE_NOTIFY and implement
 task return notifier
References: <4df13a522720782e51@agluck-desktop.sc.intel.com> <4df13cea27302b7ccf@agluck-desktop.sc.intel.com> <20110612223840.GA23218@aftab> <BANLkTi=-A5PYj8zpjGB4Xb-_VNq0qr+CGQ@mail.gmail.com> <4DF5C36A.1040707@redhat.com> <20110613095521.GA26316@aftab>
In-Reply-To: <20110613095521.GA26316@aftab>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2011 12:55 PM, Borislav Petkov wrote:
> >
> >  If running into the MCE again is really bad, then you need something
> >  more, since other threads (or other processes) could run into the same
> >  page as well.
>
> Well, the #MC handler runs on all CPUs on Intel so what we could do is
> set the current task to TASK_STOPPED or _UNINTERRUPTIBLE or something
> that doesn't make it viable for scheduling anymore.
>
> Then we can take our time running the notifier since the "problematic"
> task won't get scheduled until we're done. Then, when we finish
> analyzing the MCE, we either kill it so it has to handle SIGKILL the
> next time it gets scheduled or we unmap its page with error in it so
> that it #PFs on the next run.

If all cpus catch it, do we even know which task it is?

On the other hand, it makes user return notifiers attractive, since they 
are per-cpu, and combined with MCE broadcast that turns them into a 
global event.

> But no, I don't think we can catch all possible situations where a page
> is mapped by multiple tasks ...
>
> >  If not, do we care?  Let it hit the MCE again, as long as
> >  we'll catch it eventually.
>
> ... and in that case we are going to have to let it hit again. Or is
> there a way to get to the tasklist of all the tasks mapping a page in
> atomic context, stop them from scheduling and run the notifier work in
> process context?
>
> Hmmm..

Surely not in atomic context, but you can use rmap to find all mappers 
of a given page.

So: MCE uses irq_work_queue() -> wake up a realtime task -> process the 
mce, unmap the page, go back to sleep.

-- 
error compiling committee.c: too many arguments to function

