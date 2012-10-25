Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935863Ab2JYQ1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 12:27:37 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47121 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932998Ab2JYQ1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 12:27:36 -0400
Date: Thu, 25 Oct 2012 17:27:35 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jonas Bonn <jonas@southpole.se>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] openrisc: determine regs directly in copy_thread
Message-ID: <20121025162735.GM2616@ZenIV.linux.org.uk>
References: <1351179999-8376-1-git-send-email-jonas@southpole.se>
 <1351179999-8376-3-git-send-email-jonas@southpole.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351179999-8376-3-git-send-email-jonas@southpole.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 05:46:39PM +0200, Jonas Bonn wrote:
> copy_thread can use current_pt_regs() to get the pt_regs data that
> it needs so there's no need to pass this in as an argument.
> 
> As do_fork() doesn't use the regs argument for anything other than
> to pass it straight through to copy_thread, we just pass in a NULL
> argument in its place.  The plan seems to be to eventually drop the
> regs argument to do_fork altogether.

Hmm...  That's the plan, all right, but we need one more thing before
it's safe to pass NULL here.
        if (!(clone_flags & CLONE_UNTRACED) && likely(user_mode(regs))) {
in do_fork() should (and can right now, no prereqs for that one) become
simply
        if (!(clone_flags & CLONE_UNTRACED)) {
kernel_thread() *always* passes CLONE_UNTRACED, so it's not just "likely",
it's "always true if we get to evaluating that sucker in the first place".

FWIW, I think that merging that into mainline would be a good idea -
it would make life simpler and it's obviously safe.  Another thing I probably
want to push to Linus, for pretty much the same reasons: generic variants
of fork/vfork/clone, selected by matching __ARCH_WANT_SYS_...; obviously
safe and allows to do that unification in per-arch trees.  Less PITA
regarding the merge ordering that way...
