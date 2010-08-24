Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab0HXJg7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 05:36:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44271 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769Ab0HXJg5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 05:36:57 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell Inc.
To: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Subject: Re: [PATCH 1/4] fanotify: flush outstanding perm requests on group destroy
Date: Tue, 24 Aug 2010 11:36:29 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
Cc: Eric Paris <eparis@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1282523830-27751-1-git-send-email-eparis@redhat.com> <201008240313.11593.agruen@suse.de> <201008240949.46243.tvrtko.ursulin@sophos.com>
In-Reply-To: <201008240949.46243.tvrtko.ursulin@sophos.com>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201008241136.30064.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 August 2010 10:49:45 Tvrtko Ursulin wrote:
> I think just switching to interruptible sleep in
> fanotify_get_response_from_access should be fine. And it should probably
> deny the current event when signal is received.

Well the result would be -EINTR from the system call that blocked on the
perm event, the same as with an interruptible nfs mount.  The process would 
never get -EPERM.  Processes may
not be prepared to handle -EINTR in all cases, and so it may make more sense
to use the same behavior as NFS and only allow SIGKILL to kill a process 
blocked on a perm event (which the blocked process will never see).

>From the nfs man page:
> intr / nointr
> 
> Selects whether to allow signals to interrupt file operations on this mount
> point.  If neither option is specified (or if nointr is specified),
> signals do not interrupt NFS file operations.  If intr is  specified, 
> system  calls return EINTR if an in-progress NFS operation is interrupted
> by a signal.
> 
> Using  the  intr option is preferred to using the soft option because it is
> significantly less likely to result in data corruption.  The intr / nointr
> mount option is deprecated  after  kernel  2.6.25.   Only SIGKILL  can 
> interrupt  a  pending  NFS operation on these kernels, and if specified,
> this mount option is ignored to provide backwards  compatibility with
> older kernels.

Andreas
