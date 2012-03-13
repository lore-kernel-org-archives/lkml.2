Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380Ab2CMQAv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 12:00:51 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45052 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579Ab2CMQAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 12:00:49 -0400
Date: Tue, 13 Mar 2012 20:00:44 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Matt Helsley <matthltc@us.ibm.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file v3
Message-ID: <20120313160044.GF1912@moon>
References: <20120309152122.GA7802@redhat.com>
 <20120309154224.GE13346@moon>
 <20120309220244.GD19584@count0.beaverton.ibm.com>
 <20120309223932.GB725@moon>
 <20120309235901.GE19584@count0.beaverton.ibm.com>
 <20120310074854.GA3065@moon>
 <20120313024511.GF19584@count0.beaverton.ibm.com>
 <20120313062625.GA1912@moon>
 <20120313071812.GA6969@moon>
 <20120313154337.GA25711@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120313154337.GA25711@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 04:43:37PM +0100, Oleg Nesterov wrote:
> > +
> > +	/*
> > +	 * For security reason changing mm->exe_file
> > +	 * is one-shot action.
> > +	 */
> > +	down_write(&mm->mmap_sem);
> > +	if (likely(!mm->exe_file))
> 
> This means that the num_exe_file_vmas check at the start is not needed.
> If you want it as a "fast-path" check, please fix the comment. Or just
> remove it. Otherwise the code looks as if we have to check them both.

Yes, I wanted a fast test first, while the second test will give
one-shot condition and the second attempt to setup new exe_file
will fail. OK, I'll update the comment block.

> 
> Matt, is it really possible to hit mm->exe_file = NULL in
> removed_exe_file_vma ? Unless I missed something, this check just
> hides the potentional problem, no?
> 
> IOW, shouldn't it do
> 
> 	void removed_exe_file_vma(struct mm_struct *mm)
> 	{
> 		WARN_ON(!mm->exe_file);
> 		WARN_ON(mm->num_exe_file_vmas <= 0);
> 

I guess if num_exe_file_vmas < 1 here we've a bug somewhere
and should not decrement the counter at all.

	Cyrill
