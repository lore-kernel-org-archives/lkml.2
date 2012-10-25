Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932525Ab2JYEQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 00:16:34 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42383 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab2JYEQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 00:16:23 -0400
Date: Thu, 25 Oct 2012 05:16:21 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-fsdevel@vger.kernel.org, halfdog <me@halfdog.net>
Subject: Re: [PATCH] exec: do not leave bprm->interp on stack
Message-ID: <20121025041620.GH2616@ZenIV.linux.org.uk>
References: <20121024232032.GA31129@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121024232032.GA31129@www.outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 04:20:32PM -0700, Kees Cook wrote:
> If a series of scripts are executed, each triggering module loading via
> unprintable bytes in the script header, kernel stack contents can leak
> into the command line.
> 
> Normally execution of binfmt_script and binfmt_misc happens
> recursively. However, when modules are enabled, and unprintable bytes
> exist in the bprm->buf, execution will restart after attempting to load
> matching binfmt modules. Unfortunately, the logic in binfmt_script and
> binfmt_misc does not expect to get restarted. They leave bprm->interp
> pointing to their local stack. This means on restart bprm->interp is
> left pointing into unused stack memory which can then be copied into
> the userspace argv areas.
> 
> This changes the logic to require allocation for any changes to the
> bprm->interp. To avoid adding a new kmalloc to every exec, the default
> value is left as-is. Only when passing through binfmt_script or
> binfmt_misc does an allocation take place.

I really don't like that.  It papers over the problem, but doesn't really
solve the underlying stupidity.  We have no good reason to retry a binfmt
we'd already attempted on this level of recursion.  And your patch doesn't
deal with that at all.
