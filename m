Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030350Ab2CBQMx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 11:12:53 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58847 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab2CBQMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 11:12:52 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gorcunov@gmail.com designates 10.204.141.15 as permitted sender) smtp.mail=gorcunov@gmail.com; dkim=pass header.i=gorcunov@gmail.com
Date: Fri, 2 Mar 2012 20:12:47 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file
Message-ID: <20120302161247.GO8681@moon>
References: <20120229151634.GE4796@moon>
 <20120229192400.GA13194@redhat.com>
 <20120229200103.GJ11326@moon>
 <20120301180616.GA7652@redhat.com>
 <20120301191714.GF9930@moon>
 <20120301194120.GA11400@redhat.com>
 <20120302142630.GK8681@moon>
 <20120302152621.GA29744@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120302152621.GA29744@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2012 at 04:26:22PM +0100, Oleg Nesterov wrote:
...
> > Hi Oleg, sure you were right. I even think testing for
> > num_exe_file_vmas is not needed, since until real
> > executable VMA is read and mapped it might remain
> > zero. So I guess something like below should work.
> 
> No, you need to check num_exe_file_vmas != 0.
> 
> > +static int prctl_set_mm_exe_file(struct mm_struct *mm, unsigned int fd)
> > +{
> > +	struct file *new_exe_file, *old_exe_file;
> > +
> > +	new_exe_file = fget(fd);
> > +	if (!new_exe_file)
> > +		return -EBADF;
> > +
> > +	down_write(&mm->mmap_sem);
> > +	old_exe_file = mm->exe_file;
> > +	mm->exe_file = new_exe_file;
> > +	up_write(&mm->mmap_sem);
> 
> This changes the current rule: mm->exe_file goes away once
> num_exe_file_vmas becomes zero.

Yes, Oleg, you're right of course! The set_mm_exe_file confused
me a bit (I didn't reply to your previous emails simply because
you were asking me to prove what exactly is broken when num_exe_file_vmas
greater 2 and we reassign new exe_file, and I didn't know what to reply
since I knew I was wrong in first assumption).

As a conclusion -- sure I need to check for num_exe_file_vmas to
not break current logic, thanks!

	Cyrill
