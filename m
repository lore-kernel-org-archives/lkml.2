Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab2BDM5J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 07:57:09 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:63294 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab2BDM5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 07:57:07 -0500
X-Nat-Received: from [202.181.97.72]:64768 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1328360211.17963
To: oleg@redhat.com, tj@kernel.org
Cc: rusty@rustcorp.com.au, akpm@linux-foundation.org, arjan@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: + kmod-avoid-deadlock-by-recursive-kmod-call.patch added to-mm tree
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <87aa56qedn.fsf@rustcorp.com.au>
	<20120130002511.GF17211@htj.dyndns.org>
	<20120130130335.GB11414@redhat.com>
	<20120130172851.GD3355@google.com>
	<20120203180030.GA8842@redhat.com>
In-Reply-To: <20120203180030.GA8842@redhat.com>
Message-Id: <201202042156.HCJ57836.OQMFSVJHLtFOFO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 4 Feb 2012 21:56:49 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 04022012 #6814676, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> What do you think about s/khelper/system/ instead of this patch?

I'm not catching up with this topic. But I'm fine with any solution provided
that it can handle

  some kernel function calls request_module()

    request_module() triggers call_usermodehelper("/sbin/modprobe", UMH_WAIT_PROC)

      /sbin/modprobe loads a kernel module

        loading a kernel module triggers kobject_uevent_env()

          kobject_uevent_env() calls call_usermodehelper("/sbin/hotplug", UMH_WAIT_EXEC)

            do_execve("/sbin/hotplug") calls request_module("binfmt-0000")

              request_module("binfmt-0000") triggers call_usermodehelper("/sbin/modprobe", UMH_WAIT_PROC)

                /sbin/modprobe fails to load binfmt-0000 module

call trace on an UP machine.

kmod-avoid-deadlock-by-recursive-kmod-call.patch is for avoiding
call_usermodehelper("/sbin/modprobe", UMH_WAIT_PROC) called from
call_usermodehelper("/sbin/hotplug", UMH_WAIT_EXEC).
