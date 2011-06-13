Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab1FMMrc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 08:47:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542Ab1FMMr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 08:47:28 -0400
Message-ID: <4DF606C9.90308@redhat.com>
Date: Mon, 13 Jun 2011 15:47:05 +0300
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
References: <4df13a522720782e51@agluck-desktop.sc.intel.com> <4df13cea27302b7ccf@agluck-desktop.sc.intel.com> <20110612223840.GA23218@aftab> <BANLkTi=-A5PYj8zpjGB4Xb-_VNq0qr+CGQ@mail.gmail.com> <4DF5C36A.1040707@redhat.com> <20110613095521.GA26316@aftab> <4DF5F729.4060609@redhat.com> <20110613124003.GA27918@aftab>
In-Reply-To: <20110613124003.GA27918@aftab>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2011 03:40 PM, Borislav Petkov wrote:

<snippage>

> >
> >  So: MCE uses irq_work_queue() ->  wake up a realtime task ->  process the
> >  mce, unmap the page, go back to sleep.
>
> Yes, this is basically it. However, the other cores cannot schedule a
> task which maps the compromized page until we haven't finished finding
> and 'fixing' all the mappers.
>
> So we either hold off the cores from executing userspace - in that
> case no need to mark a task as unsuitable to run - or use the task
> return notifiers in patch 10/10.
>
> HOWEVER, AFAICT, if the page is mapped multiple times,
> killing/recovering the current task doesn't help from another core
> touching it and causing a follow-up MCE. So holding off all the cores
> from scheduling userspace in some manner might be the superior solution.
> Especially if you don't execute the #MC handler on all CPUs as is the
> case on AMD.
>

That's basically impossible, since the other cores may be in fact 
executing userspace, with the next instruction accessing the bad page.  
In fact the access may have been started simultaneously with the one 
that triggered the #MC.

The best you can do is IPI everyone as soon as you've caught the #MC, 
but you have to be prepared for multiple #MC for the same page.  Once 
you have that, global synchronization is not so important anymore.

-- 
error compiling committee.c: too many arguments to function

