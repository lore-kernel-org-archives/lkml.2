Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab2L1TEl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:04:41 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:42445 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711Ab2L1TEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:04:40 -0500
Date: Fri, 28 Dec 2012 23:04:35 +0400
From: Vasily Kulikov <segoon@openwall.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: kernel-hardening@lists.openwall.com,
        Containers <containers@lists.linux-foundation.org>,
        "Serge E. Hallyn" <serge.hallyn@ubuntu.com>,
        linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH/RFC] user_ns: fix missing limiting of user_ns counts
Message-ID: <20121228190435.GA8690@cachalot>
References: <20121228175627.GA7683@cachalot>
 <20121228184334.GZ4939@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121228184334.GZ4939@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2012 at 18:43 +0000, Al Viro wrote:
> On Fri, Dec 28, 2012 at 09:56:27PM +0400, Vasily Kulikov wrote:
> > The included patch is a basic fix for both or them.  Both values are
> > hardcoded here to 100 max depth and 1000 max in total.  I'm not sure how
> > better to make them configurable.  Looks like it needs some sysctl value
> > like kernel.max_user_ns_per_user, but also something more configurable
> > like new rlimit'ish limit may be created for user_ns needs.  E.g. in
> > case root wants one user to contain hundreds of private containers
> > (container owner user), but he doesn't want anybody to fill the kernel
> > with hundreds of containers multiplied by number of system users (equals
> > to thousands).
> 
> I'm sorry, but this is not a solution.  Kernel is not x86-only; there are
> architectures with far bigger minimal stack frame size.  E.g. on sparc64
> every fucking stack frame is at least 176 bytes.  So your 100 calls deep
> call chain will happily overflow the damn stack all by itself - kernel
> stack on sparc64 is 16Kb total, including struct thread_info living there.

Understood.  How to properly fix it then?  Looks like there are quite
many kernel structures which may reference other structures which
indirectly reference each other via kref, IOW it is not user_ns specific
issue.  With unprivileged user_ns the way it should be freed must be
somehow changed.

Thanks,

-- 
Vasily Kulikov
http://www.openwall.com - bringing security into open computing environments
