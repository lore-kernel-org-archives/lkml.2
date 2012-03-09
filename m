Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337Ab2CIM5l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 07:57:41 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35787 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab2CIM5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 07:57:40 -0500
Date: Fri, 9 Mar 2012 16:57:35 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Matt Helsley <matthltc@us.ibm.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file v3
Message-ID: <20120309125735.GB13346@moon>
References: <20120308165112.GF21812@moon>
 <20120308182623.GA17221@redhat.com>
 <20120308190303.GG21812@moon>
 <20120308190534.GA19827@redhat.com>
 <20120308192504.GH21812@moon>
 <20120308192559.GA20782@redhat.com>
 <20120308214817.GO21812@moon>
 <20120309124811.GA610@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120309124811.GA610@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2012 at 01:48:11PM +0100, Oleg Nesterov wrote:
...
> > +
> > +	/*
> > +	 * Setting new mm::exe_file is only allowed
> > +	 * when no executable VMAs left. This is
>                    ^^^^^^^^^^
> Perhaps this is just me, but imho "executable" is not clear enough.
> I'd suggest VM_EXECUTABLE to avoid the confusion with VM_EXEC.

OK

> 
> > +	 * special C/R case when a restored program
> > +	 * need to change own /proc/$pid/exe symlink.
> > +	 * After this call mm::num_exe_file_vmas become
> > +	 * meaningless.
> > +	 */
> > +	down_write(&mm->mmap_sem);
> > +	if (mm->num_exe_file_vmas == 0) {
> 
> You can check this at the very start lockless and simplify the code.
> Once it is zero, it can never grow (or we have a bug anyway).

sure

> 
> > +		set_mm_exe_file(mm, exe_file);
> > +		exe_file = NULL;
> > +	} else
> > +		err = -EBUSY;
> > +	up_write(&mm->mmap_sem);
> > +
> > +exit:
> > +	if (exe_file)
> > +		fput(exe_file);
> 
> This doesn't look correct, you need fput() in any case.
> set_mm_exe_file() does another get_file().

yeah, thanks, will update.

	Cyrill
