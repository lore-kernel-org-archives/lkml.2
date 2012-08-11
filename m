Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab2HKNcK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 09:32:10 -0400
Received: from relay.parallels.com ([195.214.232.42]:47554 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651Ab2HKNcH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 09:32:07 -0400
Message-ID: <50265EC9.5020602@parallels.com>
Date: Sat, 11 Aug 2012 17:31:53 +0400
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Manfred Spraul <manfred@colorfullife.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "eparis@parisplace.org" <eparis@parisplace.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "arnd@arndb.de" <arnd@arndb.de>, "hughd@google.com" <hughd@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "yeohc@au1.ibm.com" <yeohc@au1.ibm.com>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "casey@schaufler-ca.com" <casey@schaufler-ca.com>,
        "sds@tycho.nsa.govjames.l.morris" <sds@tycho.nsa.govjames.l.morris>,
        "devel@openvz.org" <devel@openvz.org>
Subject: Re: [PATCH v3 08/10] IPC: message queue copy feature introduced
References: <20120810141517.12411.83398.stgit@localhost6.localdomain6> <20120810142602.12411.63440.stgit@localhost6.localdomain6> <CALgW_8X_gSDG0GdoU4WShohsyhdXOXTh8o9KsYPFtnkzcJXpCQ@mail.gmail.com>
In-Reply-To: <CALgW_8X_gSDG0GdoU4WShohsyhdXOXTh8o9KsYPFtnkzcJXpCQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

11.08.2012 15:20, Manfred Spraul пишет:
> Hi Stanislav,
>
> 2012/8/10 Stanislav Kinsbursky <skinsbursky@parallels.com>:
>> This patch is required for checkpoint/restore in userspace.
>> IOW, c/r requires some way to get all pending IPC messages without deleting
>> them from the queue (checkpoint can fail and in this case tasks will be resumed,
>> so queue have to be valid).
>> To achive this, new operation flag MSG_COPY for sys_msgrcv() system call was
>> introduced. Also, copy counter was added to msg_queue structure. It's set to
>> zero by default and increases by one on each copy operation and decreased by
>> one on each receive operation until reaches zero.
> Is msq->q_copy_cnt really necessary?
> As far as I can see user space needs the ability to read the n-th message.
>
> The implementation adds a state variable to the kernel, adds two
> automatic updates of the state into msgrcv() (an increase during
> MSG_COPY, a decrease during normal receives) and adds a msgctl() to
> set the state to a certain value.
>
> a) What about the simpler approach:
> - if MSG_COPY is set, then @mtype is interpreted as the number of the
> message that should be copied.
>    If there are less than @mtype messages, then -ENOMSG is returned.

Hi, Manfred.
Your approach is simplier, but makes the call less generic and adds 
limitations.
I.e. sys_msgrcv() allows you to receive message by type. And from my pow 
this logic have to be preserved - you can specify type and then copy all 
the messages of specified type.

> b) I do not understand the purpose of the decrease of msq->q_copy_cnt:
> Do you want to handle normal msgrcv() calls in parallel with
> msgrcv(|MSG_COPY) calls?

Actually, I'm not going to copy a message from a queue, when somebody is 
reading from it. But better to handle this case by decreasing 
msq->q_copy_cnt, because otherwise this counter becomes invalid in case 
of somebody is reading from queue. And this logic is similar to new 
"peek" logic for sockets (introduced in 3.4 or 3.5).
But I understand, that in case of queue with messages with different 
types this approach works only if mtype is not specified for copy 
operation. Otherwise result is unpredictable.

> I don't think that this will work:
> What if msq->q_copy_cnt is 1 and and msgrcv() call receives the 20th
> message in the queue?

By "receives" you mean "copied"? If so, then it can happen only if mtype 
was specified. And this logic is a part of current implementation.

>
> --
>    Manfred

