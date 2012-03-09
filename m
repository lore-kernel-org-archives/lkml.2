Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab2CIX7f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 18:59:35 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:44343 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755551Ab2CIX7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 18:59:34 -0500
Date: Fri, 9 Mar 2012 15:59:01 -0800
From: Matt Helsley <matthltc@us.ibm.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Matt Helsley <matthltc@us.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file v3
Message-ID: <20120309235901.GE19584@count0.beaverton.ibm.com>
References: <20120309125735.GB13346@moon>
 <20120309133555.GA23040@moon>
 <20120309134732.GA3696@redhat.com>
 <20120309141349.GC13346@moon>
 <20120309142620.GA5334@redhat.com>
 <20120309144239.GD13346@moon>
 <20120309152122.GA7802@redhat.com>
 <20120309154224.GE13346@moon>
 <20120309220244.GD19584@count0.beaverton.ibm.com>
 <20120309223932.GB725@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120309223932.GB725@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030923-4242-0000-0000-0000010246A8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2012 at 02:39:32AM +0400, Cyrill Gorcunov wrote:
> On Fri, Mar 09, 2012 at 02:02:44PM -0800, Matt Helsley wrote:
> ...
> > 
> > Sorry about the other email -- hadn't full caught up on this thread.
> 
> No problem.
> 
> > This is even better, yes.
> >
> 
> Well, in final version I switched back to
> 
> +	if (mm->num_exe_file_vmas)
> +		return -EBUSY;
> 
> simply because it's more flexible than mm->exe_file.
> 
> With mm->exe_file this prctl option become a one-shot
> only, and while at moment our user-space tool can perfectly
> live with that I thought that there is no strict need to
> limit the option this way from the very beginning.

As far as backward compatibility, isn't it better to lift that restriction
later rather than add it? I think the latter would very likely "break"
things whereas the former would not.

I also prefer that restriction because it establishes a bound on how
frequently the symlink can change. Keeping it a one-shot deal makes the
values that show up in tools like top more reliable for admins.

> 
> > Of course I'd prefer it if there was a way to keep num_exe_file_vmas
> > correct and not special-case c/r. The first approximation of a solution
> 
> It remains correct actually. There is no way to map new VM_EXECUTABLE
> from user-space after we've unmapped previous ones, so num_exe_file_vmas
> will remain 0.
> 
> > might be to increment the count whenever a new mmap filp == mm->exe_file
> > and decrement on unmap. I think there are a bunch of details needed to
> > make that work but my feeling is it's do-able. Have you investigated this
> > already and rejected it for some reason (did I miss that discussion
> > somehow?)?
> 
> As far as I understand overall num_exe_file_vmas concept -- we track
> a number of VM_EXECUTABLE with it, so setting new exe_file should not
> change num_exe_file_vmas I think.

True, it's literally correct. However the whole reason for having it
is to turn the mm->exe_file reference into a sort of weak reference
which happens to coincide with counting the number of VM_EXECUTABLE vmas
until you do c/r (really just the restart side of c/r).

Cheers,
	-Matt

