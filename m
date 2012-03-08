Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab2CHIrB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 03:47:01 -0500
Received: from mail-ww0-f74.google.com ([74.125.82.74]:48430 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab2CHIrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 03:47:00 -0500
From: Greg Thelen <gthelen@google.com>
To: linux-mm <linux-mm@kvack.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: Re: Control page reclaim granularity
References: <20120308073412.GA6975@gmail.com>
Date: Thu, 08 Mar 2012 00:39:49 -0800
In-Reply-To: <20120308073412.GA6975@gmail.com> (Zheng Liu's message of "Thu, 8
	Mar 2012 15:34:13 +0800")
Message-ID: <xr93haxzo59m.fsf@gthelen.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zheng Liu <gnehzuil.liu@gmail.com> writes:
> Hi list,
>
> Recently we encounter a problem about page reclaim.  I abstract it in here.
> The problem is that there are two different file types.  One is small index
> file, and another is large data file.  The index file is mmaped into memory,
> and application hope that they can be kept in memory and don't be reclaimed
> too frequently.  The data file is manipulted by read/write, and they should
> be reclaimed more frequently than the index file.
>
> As previously discussion [1], Konstantin suggest me to mmap index file with
> PROT_EXEC flag.  Meanwhile he provides a patch to set a flag in mm_flags to
> increase the priority of mmaped file pages.  However, these solutions are
> not perfect.  I review the related patches (8cab4754 and c909e993) and I
> think that mmaped index file with PROT_EXEC flag is too tricky.  From the
> view of applicaton programmer, index file is a regular file that stores
> some data.  So they should be mmap with PROT_READ | PROT_WRITE rather than
> with PROT_EXEC.  As commit log said (8cab4754), the purpose of this patch
> is to keep executable code in memory to improve the response of application.
> In addition, Kongstantin's patch needs to adjust the application program.
> So in some cases, we cannot touch the code of application, and this patch is
> useless.
>
> I have discussed with Kongstantin about this problem and we think maybe
> kernel should provide some mechanism.  For example, user can set memory
> pressure priorities for vma or inode, or mmaped pages and file pages can be
> reclaimed separately.  If someone has thought about it, please let me know.
> Any feedbacks are welcomed.  Thank you.
>
> Previously discussion:
> 1. http://marc.info/?l=linux-mm&m=132947026019538&w=2
>
> Regards,
> Zheng

It's not exactly the same approach, but we have toyed with the idea of
charging different inodes to different cgroups.  Each cgroup would have
different soft/hard limits to allow for different cache behavior.

http://www.spinics.net/lists/linux-mm/msg06006.html
