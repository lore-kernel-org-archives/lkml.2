Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474Ab2GMWW4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 18:22:56 -0400
Received: from shutemov.name ([176.9.204.213]:44126 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918Ab2GMWWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 18:22:55 -0400
Date: Sat, 14 Jul 2012 01:23:24 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@openvz.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Dmitry V. Levin" <ldv@altlinux.org>,
        Doug Ledford <dledford@redhat.com>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: Re: [PATCH] ns: move free_nsproxy() out of do_exit() path
Message-ID: <20120713222319.GA13343@shutemov.name>
References: <1342180088-22647-1-git-send-email-kirill.shutemov@linux.intel.com>
 <20120713140806.b3d0fda8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120713140806.b3d0fda8.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 02:08:06PM -0700, Andrew Morton wrote:
> On Fri, 13 Jul 2012 14:48:08 +0300
> "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com> wrote:
> 
> > From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> > 
> > free_nsproxy() is too heavy to be on exit path. Let's free namespaces
> > asynchronously to not block exit_group() syscall.
> 
> Please be specific, and complete.
> 
> Why is it "too heavy"?  Where is the time being spent?  Is it spent in
> D state or is it spent burning CPU cycles?  Does the patch simply
> offload the work into kernel threads, providing no net gain?

Unpatched switch_task_namespaces() takes 0.010 - 0.011 seconds on my
machine. About 0.008 of the time is synchronize_rcu().

So it's mostly waiting with wait_for_completion() in wait_rcu_gp().
It means D state.

> > The patch also fixes bug with free namespace without synchronize_rcu() through
> > put_nsproxy().
> 
> I just don't understand this description.

IIUC current locking model requires synchronize_rcu() before
free_nsproxy(). put_nsproxy() calls free_nsproxy() without
synchronize_rcu(). So it's racy.

I guess it was missed during switch to RCU (see cf7b708).
Pavel, am I right?

> Please send a new one which
> includes all details about the bug, including a description of
> the user-visible effects of the bug.

Okay, I will.

-- 
 Kirill A. Shutemov
