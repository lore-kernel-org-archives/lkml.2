Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322Ab2CAUAc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 15:00:32 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55951 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663Ab2CAUAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 15:00:30 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gorcunov@gmail.com designates 10.205.132.138 as permitted sender) smtp.mail=gorcunov@gmail.com; dkim=pass header.i=gorcunov@gmail.com
Date: Fri, 2 Mar 2012 00:00:26 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file
Message-ID: <20120301200026.GG9930@moon>
References: <20120229151634.GE4796@moon>
 <20120229192400.GA13194@redhat.com>
 <20120229200103.GJ11326@moon>
 <20120301180616.GA7652@redhat.com>
 <20120301191714.GF9930@moon>
 <20120301194120.GA11400@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120301194120.GA11400@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2012 at 08:41:20PM +0100, Oleg Nesterov wrote:
...
> 
> Still can't understand. I think you need:
> 
> 	file = fget(fd);
> 	if (!file)
> 		return -EBADF;
> 
> 	down_write(&mm->mmap_sem);
> 	if (mm->num_exe_file_vmas) {
> 		fput(mm->exe_file);
> 		mm->exe_file = file;
> 		file = NULL;
> 	}
> 	up_write(&mm->mmap_sem);
> 
> 	if (!file)
> 		return 0;
> 
> 	fput(file);
> 	return -ESOMETHING;
> 
> and that is all.

This breaks overall logic of num_exe_file_vmas.
What the point to have it at all then? I mean,
if there several executable sections in elf file,
once loader finish its work we will have
num_exe_file_vmas more than 1.

Then the process calls for prctl and replaces
own exe_file (I'm talking about possible scenario
since for our own tool we know that there will be
only one .text section and we're more-less safe
in replacing own exe_file, but this interface
will be available for everyone who has c/r config
entry turned on, so I'm trying to find which
negative impact this feature might have, call me
paranoid), so once process has replaced own exe_file
to something else the code which depends on
num_exe_file_vmas become broken.

May not we have a scenario when removed_exe_file_vma
is be called somewhere else later, once this prctl
finished its work? That's what I fear of.

	Cyrill
