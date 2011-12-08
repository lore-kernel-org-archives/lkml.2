Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499Ab1LHQ6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 11:58:46 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:50138 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752195Ab1LHQ6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 11:58:43 -0500
X-Sasl-enc: cdsqrefuOpB8pX6DPdqs5CeIHWIdWnINOFBQMmO1kkfN 1323363522
Subject: Re: chroot(2) and bind mounts as non-root
From: Colin Walters <walters@verbum.org>
To: Andy Lutomirski <luto@MIT.EDU>
Cc: LKML <linux-kernel@vger.kernel.org>, Daniel Walsh <dwalsh@redhat.com>,
        Stephen Smalley <sds@tycho.nsa.gov>, kzak <kzak@redhat.com>
In-Reply-To: <4EDFC123.6070003@mit.edu>
References: <1323280461.10724.13.camel@lenny> <4EDFC123.6070003@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Dec 2011 11:58:13 -0500
Message-ID: <1323363493.10724.58.camel@lenny>
Mime-Version: 1.0
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-07 at 11:40 -0800, Andy Lutomirski wrote:

> I will personally always be nervous until something like this happens:
> 
> http://thread.gmane.org/gmane.linux.kernel.lsm/10659
> 
> execve() is IMO scary.

Yeah, this came up in the context of the seccomp filter stuff too.  

So...it's worth noting that as far as SELinux goes, the beautiful thing
is that setuid only changes uid - it doesn't (by default) change the
domain.  So in this case for example, if the calling domain doesn't
have:

  self:capable { setpcap sys_chroot }

The binary is just going to error out.  Very few domains in the
reference policy have either of those, and only one non-unconfined
domain has both - seunshare.  (At least via grep, I didn't try an
analysis tool).

Oh crap, speaking of seunshare:
https://bugzilla.redhat.com/show_bug.cgi?id=633544

They should clearly be using SECBIT_NOROOT too - that would have avoided
the original hole.

In fact, I now notice my program is a safer generalization of seunshare.
I've added dwalsh to CC.

As far as other LSMs go - honestly I'm in the camp that they're stupid,
and SELinux is the only sane one.  That and opt-in application controls
such as seccomp are where we should be headed.

So instead of your execve_nosecurity, why don't we make SECBIT_NOROOT
disable domain transitions too?  (And encourage the other LSMs to treat
it similarly).

Here's some further food for thought - what if we made certain system
calls that were previously privileged suddenly start working if the
process is SECBIT_NOROOT | SECBIT_NOROOT_LOCKED?  I'm specifically
thinking of unshare(2) and chroot(2).  The tricky part is more allowing
a subset of mount system calls (I need to be able to mount procfs, but
clearly we don't want the user to be able to mount real devices).


