Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757982Ab2CFDiX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 22:38:23 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:37664 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757361Ab2CFDiW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 22:38:22 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of arve@android.com designates 10.224.95.210 as permitted sender) smtp.mail=arve@android.com
MIME-Version: 1.0
In-Reply-To: <20120305063707.GH23916@ZenIV.linux.org.uk>
References: <20120305063707.GH23916@ZenIV.linux.org.uk>
Date: Mon, 5 Mar 2012 19:38:21 -0800
Message-ID: <CAMP5XgeWQpMP2Q_29aybHwfMJ1_k5GkGozqocSVVYDoRTpKD2w@mail.gmail.com>
Subject: Re: [patches] VM-related fixes
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, airlied@linux.ie, carsteno@de.ibm.com,
        steiner@sgi.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 4, 2012 at 10:37 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>        I'd been crawling through VMA-related code for the last couple
> of weeks; the obvious parts of fallout are in followups and IMO they
> need to go into -stable as well; there's more, including some bugs I
> don't know what to do about and patches that need more testing...
>
...
> [unsolved] binder is insane, even more than usual for drivers/staging.
> It stores a reference to mm at open() time,

It stores a reference to the task struct, not the mm.

> then it stores a reference to
> vma at mmap() time, then it cheerfully works with that ->vma assuming that
> ->mmap_sem on stored reference to ->mm would suffice.  Guess what happens
> if somebody opens it and then forks and does mmap in child?

mmap succeeds, but binder_update_page_range will fail when trying to
create a transaction? (assuming you are talking about the current
version of the driver)

>  Moreover, if
> we fork() and have child exit(), we get ->close() called on each VMA we'd
> copied into child.

The driver sets VM_DONTCOPY which should avoid this.

>  Since they have stored reference to vma invalidated by
> ->close(), that has unpleasant side effects, to put it mildly.

The side effect of ->close() should be the same as when the process
that opened the driver exits. In other words, the process that
misbehaved is considered dying. It does not however send death
notifications until the driver is closed, so other processes do not
notice until they try to talk to it.

>  And yes,
> I realize that android userland probably doesn't do anything of that kind;
> fat lot of good it does us...
>

What usage case do you have in mind? The binder driver uses the file
pointer as the binder process identifier, so you need to open and mmap
the driver in every process that want to use the driver. While it is
not common to fork a process in android, the driver should work as
expected if you do (assuming each process opens and mmaps the driver
on its own and don't share the file).

-- 
Arve Hjønnevåg
