Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758504Ab2CBPKX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 10:10:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758420Ab2CBPKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 10:10:20 -0500
Date: Fri, 2 Mar 2012 16:03:10 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file
Message-ID: <20120302150310.GA28313@redhat.com>
References: <20120229151634.GE4796@moon> <20120229192400.GA13194@redhat.com> <20120229200103.GJ11326@moon> <20120301180616.GA7652@redhat.com> <20120301191714.GF9930@moon> <20120301194120.GA11400@redhat.com> <20120301200026.GG9930@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120301200026.GG9930@moon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02, Cyrill Gorcunov wrote:
>
> On Thu, Mar 01, 2012 at 08:41:20PM +0100, Oleg Nesterov wrote:
> ...
> >
> > Still can't understand. I think you need:
> >
> > 	file = fget(fd);
> > 	if (!file)
> > 		return -EBADF;
> >
> > 	down_write(&mm->mmap_sem);
> > 	if (mm->num_exe_file_vmas) {
> > 		fput(mm->exe_file);
> > 		mm->exe_file = file;
> > 		file = NULL;
> > 	}
> > 	up_write(&mm->mmap_sem);
> >
> > 	if (!file)
> > 		return 0;
> >
> > 	fput(file);
> > 	return -ESOMETHING;
> >
> > and that is all.
>
> This breaks overall logic of num_exe_file_vmas.

Why? In my opinion, your patch breaks the logic ;)

> What the point to have it at all then?

I think it should die. I already suggested to do

	- struct file *exe_file;
	+ struct path *exe_path;

and kill this counter, but this is off-topic.

> I mean,
> if there several executable sections in elf file,
> once loader finish its work we will have
> num_exe_file_vmas more than 1.

Yes. And?

> Then the process calls for prctl and replaces
> own exe_file (I'm talking about possible scenario
> since for our own tool we know that there will be
> only one .text section and we're more-less safe
> in replacing own exe_file,

confused. I do not see the "num_exe_file_vmas == 1" check in the
last version. (yes, I think it is not needed).

OTOH, you should check num_exe_file_vmas != 0, otherwise you break
the current logic.

> but this interface
> will be available for everyone who has c/r config
> entry turned on,

Yes, and thus it should work in any case.

> so I'm trying to find which
> negative impact this feature might have,

If you find something negative - please explain and correct me ;)

Your message starts with "This breaks overall logic" without any
explanation.

> so once process has replaced own exe_file
> to something else the code which depends on
> num_exe_file_vmas become broken.

Again, why???

> May not we have a scenario when removed_exe_file_vma
> is be called somewhere else later, once this prctl
> finished its work? That's what I fear of.

Of course, removed_exe_file_vma() or added_exe_file_vma() can
be called after prctl(). And we should keep the current logic:
mm->exe_file exists until num_exe_file_vmas != 0.

To simplify, currently we have:

	- num_exe_file_vmas is equal to the number of
	  MAP_EXECUTABLE vmas

	- (num_exe_file_vmas != 0) <=> (exe_file != NULL)

You should keep this. Or you should change the rules and explain
why you are doing this.

Oleg.

