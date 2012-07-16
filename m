Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109Ab2GPQxR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 12:53:17 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59106 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337Ab2GPQxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 12:53:15 -0400
Date: Mon, 16 Jul 2012 17:53:01 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "Dmitry V. Levin" <ldv@altlinux.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Doug Ledford <dledford@redhat.com>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: Re: [PATCH v2] ns: do not block exit_task_namespaces() for a long
 time
Message-ID: <20120716165301.GN31729@ZenIV.linux.org.uk>
References: <20120713140806.b3d0fda8.akpm@linux-foundation.org>
 <1342451364-14787-1-git-send-email-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342451364-14787-1-git-send-email-kirill.shutemov@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2012 at 06:09:24PM +0300, Kirill A. Shutemov wrote:
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> 
> On exiting of the last task in a namespace we need to trigger freeing of
> the namespace. Currently, we call synchronize_rcu() and free_nsproxy()
> directly on do_exit() path.
> 
> On my machine synchronize_rcu() blocks for about 0.01 seconds. For
> comparing: normal exit_group() syscall takes less than 0.0003 seconds.
> 
> Let's offload synchronize_rcu() and free_nsproxy() to a workqueue.
> 
> I also move synchronize_rcu() inside free_nsproxy(). It fixes racy
> put_nsproxy() which calls free_nsproxy() without synchronize_rcu().
> I guess it was missed during switch to RCU (see cf7b708).

NAK.  Making final umounts of anything in that namespace asynchronous,
even though nothing is holding the stuff on them busy is simply
wrong.  Note that they can take a _long_ time, so we are talking about
minutes worth of delay in the worst case.  It's user-visible and
it's a serious potential for trouble.
