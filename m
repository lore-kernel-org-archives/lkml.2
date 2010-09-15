Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab0IOK6j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 06:58:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717Ab0IOK6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 06:58:38 -0400
Message-ID: <4C90A6C7.9050607@redhat.com>
Date: Wed, 15 Sep 2010 12:58:15 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Thunderbird/3.1.3
MIME-Version: 1.0
To: Christopher Yeoh <cyeoh@au1.ibm.com>
CC: linux-kernel@vger.kernel.org,
        Linux Memory Management List <linux-mm@kvack.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH] Cross Memory Attach
References: <20100915104855.41de3ebf@lilo>
In-Reply-To: <20100915104855.41de3ebf@lilo>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/15/2010 03:18 AM, Christopher Yeoh wrote:
> The basic idea behind cross memory attach is to allow MPI programs doing
> intra-node communication to do a single copy of the message rather than
> a double copy of the message via shared memory.

If the host has a dma engine (many modern ones do) you can reduce this 
to zero copies (at least, zero processor copies).

> The following patch attempts to achieve this by allowing a
> destination process, given an address and size from a source process, to
> copy memory directly from the source process into its own address space
> via a system call. There is also a symmetrical ability to copy from
> the current process's address space into a destination process's
> address space.
>
>

Instead of those two syscalls, how about a vmfd(pid_t pid, ulong start, 
ulong len) system call which returns an file descriptor that represents 
a portion of the process address space.  You can then use preadv() and 
pwritev() to copy memory, and io_submit(IO_CMD_PREADV) and 
io_submit(IO_CMD_PWRITEV) for asynchronous variants (especially useful 
with a dma engine, since that adds latency).

With some care (and use of mmu_notifiers) you can even mmap() your vmfd 
and access remote process memory directly.

A nice property of file descriptors is that you can pass them around 
securely via SCM_RIGHTS.  So a process can create a window into its 
address space and pass it to other processes.

(or you could just use a shared memory object and pass it around)

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

