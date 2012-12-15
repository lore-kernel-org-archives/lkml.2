Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932746Ab2LOAuv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 19:50:51 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46008 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932151Ab2LOAuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 19:50:50 -0500
Date: Fri, 14 Dec 2012 19:50:44 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] core_pattern: set core helpers root and namespace to
 crashing process
Message-ID: <20121215005044.GB10508@neilslaptop.think-freely.org>
References: <1355255996-25953-1-git-send-email-nhorman@tuxdriver.com>
 <1355519048-28473-1-git-send-email-nhorman@tuxdriver.com>
 <87d2ycut5l.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d2ycut5l.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 03:10:30PM -0800, Eric W. Biederman wrote:
> Neil Horman <nhorman@tuxdriver.com> writes:
> 
> > As its currently implemented, redirection of core dumps to a pipe reader should
> > be executed such that the reader runs in the namespace of the crashing process,
> > and it currently does not. This is the only sane way to deal with namespaces
> > properly it seems to me, and this patch implements that functionality.
> 
> I actually rather strongly disagree.
> 
> While we have a global core dump pattern core dumps to a a pipe reader
> should be executed such that the reader runs in the namespace of the
> process that set the pattern.  We can easily restrict that to the
> initial namespaces to make the implementation simpler.
> 
> If you want to play namespace games you can implement all of those in
> user space once my tree merges for v3.8.
> 
> I am really not a fan of the trigger process being able to control the
> environment of a privileged process.  It makes writing the privileged
> process much trickier.
> 
Why?  What specific problem do you see with allowing a privlidged process to
execute within a specific namespace, that doesn't also exist with having the
pipe reader execute in the init namespace?  Note I'm not saying that a poorly
constructed pipe reader application doesn't have security problems if it doesn't
validate the environment that its running in, but thats something that the pipe
reader needs to be sure about.

Note also, that if the token in core_pattern is set such that the core_pattern
is namespace/root relative, that container needs to install the application
relative its root as well (e.g. positive action still needs to be taken on the
part of the container admin to make this work).  For example, if you set
core_pattern="||/usr/bin/foo"
Then a process running in a chroot based at /sub/root/ still needs to install a
file /sub/root/usr/bin/foo, or the core dump will fail.  So its not like a
container can just have a core reader execute without first making an
administrative decision to do so.

Neil

