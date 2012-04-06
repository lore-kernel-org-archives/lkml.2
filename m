Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757801Ab2DFTX5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 15:23:57 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61135 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757764Ab2DFTX4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 15:23:56 -0400
MIME-Version: 1.0
In-Reply-To: <1333730496.17877.7.camel@satguru>
References: <1333195251-5046-1-git-send-email-consul.kautuk@gmail.com>
	<1333730496.17877.7.camel@satguru>
Date: Sat, 7 Apr 2012 00:53:55 +0530
Message-ID: <CAFPAmTTDjSPYA5bqK8-Xp50rcyB4fZRpGP-Q-JUzMgOZERHvEg@mail.gmail.com>
Subject: Re: [PATCH 04/19 v2] openrisc/mm/fault.c: Port OOM changes to do_page_fault
From: Kautuk Consul <consul.kautuk@gmail.com>
To: Jonas Bonn <jonas@southpole.se>
Cc: Arnd Bergmann <arnd@arndb.de>, linux@openrisc.net,
        linux-kernel@vger.kernel.org, "Mohd. Faris" <mohdfarisq2010@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 6, 2012 at 10:11 PM, Jonas Bonn <jonas@southpole.se> wrote:
> Hi Kautuk,
>
> OK, I had a look at this patch and I think it's fine.  This is a little
> over my head so I'm just going to take you word for it doing the right
> thing... it doesn't seem to fundamentally break anything in any case.
> stress_32k runs and the OOM killer takes it down nicely.
>

Its just something that I was investigating and testing for ARM and
MIPS, so its just
a little "involved" thats all.

In a nutshell:
I observed that process threads used to get stuck via the
handle_mm_fault ---> filemap_fault()
route inside filesystems in the __alloc_pages_slowpath() loop in
mm/page-alloc.c due to non-availability
of physical memory.
Since they keep looping within the __alloc_pages_slowpath(), they are
not killed despite
getting a SIGKILL as they don't return back to the usermode and keep spinning.
Also, since the mmap_sem is taken, other processes trying to do allocate memory
sleep indefinitely over the mmap_sem. So, the process hangs instead of
getting killed
and releasing its pages.

This patch gives a chance for filemap_fault() to release the mmap_sem
in low memory situations
so that the thread can return back to the page-fault handling code to
handle the signal and quit gracefully.

But, the best thing will be to have a low memory killer such as the
one that the Android people are
working on as this hang/livelock situation can still happen even with
this patch file.
So this patch file just tries to improve the reliability of OOM killer
in extreme memory pressure situation, thats all.

> I'll paste the output from running stress_32k (here called testkautuk)
> here in case you haven't seen how elegant the oom-killer output is on
> openrisc...
>
> Thanks for the patch.
>
> Acked-by: Jonas Bonn <jonas@southpole.se>

Thanks for the ACK !
Since I don't have any branch of my own, can you please apply this to
your branch ?
Or else, I'll have to ask someone else to apply this on their branches
and thats a relatively longer process. :-(

>
> /Jonas
>


And thanks for pasting the output.. it looks good ! :-)
