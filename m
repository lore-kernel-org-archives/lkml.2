Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987Ab2DELnG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 07:43:06 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:3328 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799Ab2DELnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 07:43:04 -0400
Message-ID: <4F7D8524.8030709@parallels.com>
Date: Thu, 05 Apr 2012 15:42:28 +0400
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Lightning/1.0b2 Thunderbird/3.1.20
MIME-Version: 1.0
To: "mtk.manpages@gmail.com" <mtk.manpages@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "serge.hallyn@canonical.com" <serge.hallyn@canonical.com>,
        "criu@openvz.org" <criu@openvz.org>,
        "lucas.demarchi@profusion.mobi" <lucas.demarchi@profusion.mobi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, Linux API <linux-api@vger.kernel.org>
Subject: Re: [PATCH 2/2] IPC: message queue stealing feature introduced
References: <20120215163203.27978.52494.stgit@localhost6.localdomain6> <20120215165439.27978.43513.stgit@localhost6.localdomain6> <20120404161224.dea67733.akpm@linux-foundation.org> <CAKgNAkjpWpHR9Ww0JzZqsACktXzsm9r8=k6e7CJF_9+5cWdJBQ@mail.gmail.com>
In-Reply-To: <CAKgNAkjpWpHR9Ww0JzZqsACktXzsm9r8=k6e7CJF_9+5cWdJBQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

05.04.2012 03:50, Michael Kerrisk (man-pages) пишет:
> On Thu, Apr 5, 2012 at 11:12 AM, Andrew Morton
> <akpm@linux-foundation.org>  wrote:
>> On Wed, 15 Feb 2012 20:54:39 +0400
>> Stanislav Kinsbursky<skinsbursky@parallels.com>  wrote:
>
> Stanislav,
>
> Luckily, Andrew added me to CC. However, as noted in
> Documentation/SubmitChecklist, all patches that change the ABI/API
> should CC linux-api@vger.kernel.org. Please do that for the future.
> (CC added for this thread.)
>

Yep, sure. Next time I'll do that. Sorry.

>>> v2:
>>> 1) compat functions added.
>>> 2) message slot size in array is now aligned by struct msgbuf_a.
>>> 3) check for enough free space in buffer before message copying added.
>>> 4) if MSG_STEAL flag is set, then do_msgrcv() returns number of bytes written
>>> to buffer.
>
> By the way, why the name "MSG_STEAL"? At first glance, it sounds like
> that means we're taking messages that belong to someone else. But I
> gather you are in fact just flushing all messages from a queue. So I
> more intuitive name seems to be in order (MSG_READ_ALL,
> MSG_FLUSH_ALL?).
>

Nice to know, that it sounds to you exactly like it is desired to. I.e. this 
flag was designed to take messages that belong to someone else without any 
trace, visible to the owner of the messages.
But (like you mentioned in following letter) MSG_PEEK_ALL sound better to me. 
Thus I'll replace MSG_STEAL with MSG_PEEK_ALL, if you don't mind.

>>> 5) flag MSG_NOERROR is ignored if MSG_STEAL flag is set.
>
> Would it not be better to return an error if MSG_NOERROR is specified?
>

I don't think so. IOW, error can be returned in this case, but I don't see any 
practical reason for this. If you do - please share.

>>> This patch is required for checkpoint/restore in userspace.
>>> IOW, c/r requires some way to get all pending IPC messages without deleting
>>> them for the queue (checkpoint can fail and in this case tasks will be resumed,
>>> so queue have to be valid).
>>> To achive this, new operation flag MSG_STEAL for sys_msgrcv() system call
>>> introduced.
>>> If this flag is set, then passed struct msgbuf pointer will be used for storing
>>> array of structures:
>>>
>>> struct msgbuf_a {
>>>        long mtype;         /* type of message */
>>>        int msize;          /* size of message */
>>>        char mtext[0];      /* message text */
>>> };
>
> So, I'm not clear on how things look here. We get back array like this:
>
> [0]                     [1]                     [2]
> | mtype | msize | mtext | mtype | msize | mtext | ...
>
> How do I calculate the offset of element 1 of the array? I assume it
> can't be just
> (&item[0].mtext + msize), since there'll be alignment issues to deal
> with, so that there are padding bytes after each mtext. In that case,
> msize on its own seems insufficient (since there is no null-terminator
> in msize).
>

This is easy. You can be sure, that struct msgbuf_a is aligned by sizeof(struct 
msgbuf_a). And since you know the size of this structure and length of data 
segment, then offset of any element of the queue can be calculated like this:

addr_N+1 = addr_N +
round_up(sizeof(struct msgbuf_a) + msize, sizeof(struct msgbuf_a));

>>> each of which will be followed by corresponding message data.
>>>
>>
>> I'd be a bit more comfortable if there was some sign that other c/r
>> developers have reviewed and tested this and have successfully used it
>> in c/r operation testing?
>
> Indeed, do you have a userspace test program that you could post?
>

Yes, sure. I'll add it to the patch set.
But please not, that this test (in it's current state) can be executed only as a 
part of out CRIU test suit.
So you won't be able to execute it as is.

>> We've been trying to isolate the c/r-specific functions inside #ifdef
>> CONFIG_CHECKPOINT_RESTORE, but this patch doesn't do that.  I have been
>> encouraging this isolation so that people who aren't using c/r don't
>> have to carry the overhead it adds and so that we can more easily hunt
>> down and remove everything if the entire c/r project doesn't work out
>> successfully.
>>
>> This patch modifies the sys_msgrcv() API and so we should update the
>> manpage for that syscall.  Please work with Michael on this.
>
> Yes please.
>

Sure. What do you want me to do?

-- 
Best regards,
Stanislav Kinsbursky
