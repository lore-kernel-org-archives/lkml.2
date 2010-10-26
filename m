Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296Ab0JZOpi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 10:45:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245Ab0JZOph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 10:45:37 -0400
Message-ID: <4CC6E962.5000203@gmail.com>
Date: Tue, 26 Oct 2010 16:44:50 +0200
From: Edward Shishkin <edward.shishkin@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
CC: linux-fsdevel@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
        lmcilroy@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 2/2] vfs: relax count check in rw_verify_area
References: <201010132246.21744.edward.shishkin@gmail.com> <20101014163047.d909ad5c.akpm@linux-foundation.org>
In-Reply-To: <20101014163047.d909ad5c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 13 Oct 2010 22:46:21 +0200
> Edward Shishkin <edward.shishkin@gmail.com> wrote:
>
>   
>> Increase count limit in rw_verify_area().
>>
>>     
>
> OK, now this is a truly awful attempt to describe a patch.
>   

I was sure I have nicely described everything in the
"[patch 0/2][RFC] vfs: artefact(?) in rw_verify_area"
Well, I'll provide more details..

> afaict what the patch does is to change rw_verify_area() so that the
> kernel now permits single reads and writes of up to 2^63 bytes on
> 64-bit systems.  Whereas it was previously limited to 2^31.  And the
> patch also fixes up a couple of callsites which were assuming that
> rw_verify_area() had that particular behaviour.
>   

I found such assumptions rather strange. Why to not assume
documentation for read(2), write(2), where we can nominate
SSIZE_MAX bytes to read/write?

Now about the bad aspect of this limitation.
There is a so-called concept of transactions, which is very useful.
Sometimes we want some operations to be performed atomically. For
example, when you pay by your credit card. Should I explain what
can happen, if such operation will be half done?

Now note that the 2G restriction in rw_verify_area means that a file
system can not write more then 2G bytes atomically without a special
notification from user space. Do we really need such workarounds?

Large transactions are possible, they can be issued, for example,
by some trusted centre, which has many clients (like commercial
bank, notary, etc). Actually, 2G is not a large value nowadays..

> But that's just my guess, based on a quick read of the implementation. 
> I didn't check how far this change penetrates.  Does it affect all
> filesystems, for example?  If so were they all reviewed (or tested!)
> for correctness?
>   

Currently I have tested 15 callsites, and only 2 of them was failed
(direct-io and ecryptfs). The direct-io has been fixed already:
there was a truncation bug (see
[patch 1/2] vfs: fix overflow in direct-io subsystem).

I am ready to check/fix other ones, if there are any chances, that
this permit of large IOs will be eventually accepted.

> And why was this patch written?  What motivated you?

Our users ask us.

>   What are the user-visible effects?

There must not be any effects: in accordance with documentation
we can nominate SSIZE_MAX bytes to read/write.

>   Do manpages need updating?
>   

No, they don't.

Thanks,
Edward.
