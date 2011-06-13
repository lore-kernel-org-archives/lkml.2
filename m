Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671Ab1FMQcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 12:32:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751926Ab1FMQcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 12:32:17 -0400
Message-ID: <4DF63B7A.1030805@redhat.com>
Date: Mon, 13 Jun 2011 19:31:54 +0300
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
References: <4df13a522720782e51@agluck-desktop.sc.intel.com> <4df13cea27302b7ccf@agluck-desktop.sc.intel.com> <20110612223840.GA23218@aftab> <BANLkTi=-A5PYj8zpjGB4Xb-_VNq0qr+CGQ@mail.gmail.com> <4DF5C36A.1040707@redhat.com> <20110613095521.GA26316@aftab> <4DF5F729.4060609@redhat.com> <20110613124003.GA27918@aftab> <4DF606C9.90308@redhat.com> <20110613151208.GA29045@aftab>
In-Reply-To: <20110613151208.GA29045@aftab>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2011 06:12 PM, Borislav Petkov wrote:
> >  The best you can do is IPI everyone as soon as you've caught the #MC,
> >  but you have to be prepared for multiple #MC for the same page. Once
> >  you have that, global synchronization is not so important anymore.
>
> Yeah, in the multiple #MC case the memory_failure() thing should
> probably be made reentrant-safe (if it is not yet). And in that case,
> we'll be starting a worker thread on each CPU that caused an MCE from
> accessing that page. The thread that manages to clear all the mappings
> of our page simply does so while the others should be able to 'see' that
> there's no work to be done anymore (PFN is not mapped in the pagetables
> anymore) and exit without doing anything. Yeah, sounds doable with the
> irq_work_queue ->  user_return_notifier flow.

I don't think a user_return_notifier is needed here.  You don't just 
want to do things before a userspace return, you also want to do them 
soon.  A user return notifier might take a very long time to run, if a 
context switch occurs to a thread that spends a lot of time in the 
kernel (perhaps a realtime thread).

So I think the best choice here is MCE -> irq_work -> realtime kernel 
thread (or work queue)

-- 
error compiling committee.c: too many arguments to function

