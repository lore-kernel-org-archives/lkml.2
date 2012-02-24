Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091Ab2BXF3H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 00:29:07 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:53008 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab2BXF3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 00:29:05 -0500
MIME-Version: 1.0
In-Reply-To: <CAHGf_=oi8_s0Bxn4qSD7S_FBSgp29BPXor4hCf5-kekGnf3qEw@mail.gmail.com>
References: <4F32B776.6070007@gmail.com>
	<1328972596-4142-1-git-send-email-siddhesh.poyarekar@gmail.com>
	<CAHGf_=oi8_s0Bxn4qSD7S_FBSgp29BPXor4hCf5-kekGnf3qEw@mail.gmail.com>
Date: Fri, 24 Feb 2012 10:59:03 +0530
Message-ID: <CAAHN_R2Awa5X3B09541grAPLkm9RzL9DnixUKFJXpz=1ZkPTFg@mail.gmail.com>
Subject: Re: [PATCH] Mark thread stack correctly in proc/<pid>/maps
From: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Jamie Lokier <jamie@shareable.org>,
        vapier@gentoo.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 4:47 AM, KOSAKI Motohiro
<kosaki.motohiro@gmail.com> wrote:
> How protect this loop from task exiting? AFAIK, while_each_thread
> require rcu_read_lock or task_list_lock.

I missed this, thanks. I'll send a patch for this on top of my earlier
patch since Andrew has already included the earlier patch.

> Sigh. No, I missed one thing. If application use
> makecontext()/swapcontext() pair,
> ESP is not reliable way to detect pthread stack. At that time the
> stack is still marked
> as anonymous memory.

This is not wrong, because it essentially gives the correct picture of
the state of that task -- the task is using another vma as a stack
during that point and not the one it was allotted by pthreads during
thread creation.

I don't think we can successfully stick to the idea of trying to mark
stack space allocated by pthreads but not used by any task *currently*
as stack as long as the allocation happens outside the kernel space.
The only way to mark this is either by marking the stack as
VM_GROWSDOWN (which will make the stack grow and break some pthreads
functions) or create a new flag, which a simple display such as this
does not deserve. So it's best that this sticks to what the kernel
*knows* is being used as stack.

-- 
Siddhesh Poyarekar
http://siddhesh.in
