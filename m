Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab1FNNoB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 09:44:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62961 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864Ab1FNNn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 09:43:57 -0400
Message-ID: <4DF76586.1090308@redhat.com>
Date: Tue, 14 Jun 2011 16:43:34 +0300
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
References: <BANLkTi=-A5PYj8zpjGB4Xb-_VNq0qr+CGQ@mail.gmail.com> <4DF5C36A.1040707@redhat.com> <20110613095521.GA26316@aftab> <4DF5F729.4060609@redhat.com> <20110613124003.GA27918@aftab> <4DF606C9.90308@redhat.com> <20110613151208.GA29045@aftab> <4DF63B7A.1030805@redhat.com> <BANLkTinUEqRni2u0DaMfSc45b3DmMMyYvA@mail.gmail.com> <4DF748C2.10009@redhat.com> <20110614133323.GB2830@aftab>
In-Reply-To: <20110614133323.GB2830@aftab>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2011 04:33 PM, Borislav Petkov wrote:
> >
> >  Even with mce ->  irq_work ->  rt thread, we're unlikely to return to
> >  the task as the rt thread will displace the task. It may be migrated
> >  to an idle cpu, but even then we may be able to drop the page before
> >  it gets back to userspace.
>
> This doesn't give you the guarantee that the realtime task manages to
> unmap the page from all pagetables before another process running on
> another core accesses it.

Right, it's not about a guarantee, it's about maintaining decent 
performance.

> I think your previous suggestion of making the memory failure handling
> code reentrant would cover all holes.

I think it's required, yes.

Since we can't have nested #MC (due to the IST mechanism resetting %rsp 
and cloberring the previous invocation's stack), we have to clear MCIP 
outside the #MC handler.  And that means irq_work_queue()

(note that this changes the behaviour from memory corruption to shutdown 
state; both suck, but one more than the other).

> Even marking all processes mapping a faulty page STOPPED or
> UNINTERRUPTIBLE won't work in all cases since you have to go out and
> find which those processes are. And this is what the rt thread will do.

Yes.

-- 
error compiling committee.c: too many arguments to function

