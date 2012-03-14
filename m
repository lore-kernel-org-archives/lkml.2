Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031198Ab2CNXit (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 19:38:49 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12857 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760715Ab2CNXiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 19:38:46 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6649"; a="170252571"
Message-ID: <4F612C05.8010301@codeaurora.org>
Date: Wed, 14 Mar 2012 16:38:45 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Saravana Kannan <skannan@codeaurora.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        alan@lxorguk.ukuu.org.uk,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] firmware loader: don't cancel _nowait requests when helper
 is not yet available
References: <201203032122.36745.chunkeey@googlemail.com> <201203150013.45749.rjw@sisk.pl> <4F612706.4060407@codeaurora.org> <201203150034.08863.rjw@sisk.pl>
In-Reply-To: <201203150034.08863.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/12 16:34, Rafael J. Wysocki wrote:
> On Thursday, March 15, 2012, Stephen Boyd wrote:
>> On 03/14/12 16:13, Rafael J. Wysocki wrote:
>>> On Thursday, March 15, 2012, Rafael J. Wysocki wrote:
>>>
>>>> Which is OK, I think.
>>> Moreover, thaw_kernel_threads() is _only_ called by (a) freeze_kernel_threads()
>>> on error and (b) user-space hibernate interface in kernel/power/user.c
>>> (and please read the comment in there describing what it's there for, which
>>> also explains why the schedule() call in there is necessary).
>> Exactly. So in case (a) when the error occurs we'll have this call flow:
>>
>> usermodehelpers_disable()
>> suspend_freeze_processes()
>>     freeze_processes()
>>     freeze_kernel_threads()
>>         try_to_freeze_tasks() <-- returns error
>>         thaw_kernel_threads()
>>             schedule()
>>     thaw_processes()
>> usermodehelpers_enable()
>>
>> Shouldn't we schedule only after we thaw all processes (not just tasks)?
>> Otherwise we may run a kernel thread before userspace is thawed?
> Yes, we may, but that isn't wrong, is it?
>
> Only a few kernel threads are freezable, so definitely kernel threads
> can run while user space is frozen.
>

Yes but if someone calls request_firmware() from a kthread then they
will hit the same problem where the thread runs and requests the
firmware and usermodehelpers are still disabled. Currently my code is
written with kthreads and that thread makes the request firmware call,
so this doesn't seem far fetched (although in my case I can probably fix
it). It looks like before 379e0be (PM / Freezer: Thaw only kernel
threads if freezing of kernel threads fails, 2012-02-03) schedule wasn't
called until userspace was thawed. It looks like that patch was about
hibernation and not suspend?

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

