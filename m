Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581Ab1BCPx3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 10:53:29 -0500
Received: from brother.balabit.com ([195.70.62.219]:58303 "EHLO
	lists.balabit.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab1BCPx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 10:53:28 -0500
Subject: Re: CAP_SYSLOG, 2.6.38 and user space
From: Gergely Nagy <algernon@balabit.hu>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        James Morris <jmorris@namei.org>
In-Reply-To: <20110203153252.GA24153@mail.hallyn.com>
References: <1296733177.14846.26.camel@moria>
	 <20110203153252.GA24153@mail.hallyn.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Feb 2011 16:53:21 +0100
Message-ID: <1296748401.14846.39.camel@moria>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-03 at 15:32 +0000, Serge E. Hallyn wrote:
> > Back in november, a patch was merged into the kernel (in  commit
> > ce6ada35bdf710d16582cc4869c26722547e6f11), that splits CAP_SYSLOG out of
> > CAP_SYS_ADMIN.
> > 
> > Sadly, this has an unwelcomed consequence, that any userspace syslogd
> > that formerly used CAP_SYS_ADMIN will stop working, unless upgraded, or
> > otherwise adapted to the change.
> > 
> > However, updating userspace isn't that easy, either, if one wants to
> > support multiple kernels with the same userspace binary: pre-2.6.38, one
> > needs CAP_SYS_ADMIN, but later kernels will need CAP_SYS_ADMIN. It would
> > be trivial to keep both, but that kind of defeats the purpose of
> > CAP_SYSLOG,
> 
> The idea would be to only use both when you detect a possibly older
> kernel. 

I was considering that, but... how do I reliably detect an older kernel?

So far, I didn't find a reliable way with which I can detect a kernel
version at run-time (apart from parsing utsname) - but it's entirely
possible, that I missed something obvious.

Furthermore, this still needs an userspace upgrade aswell, so only helps
one half of the problem.

> However, you're right of course, I really should have provided some way
> for userspace to click 'ok, got the message, now continue anyway because
> I'm running older userspace for now,'  i.e. a sysctl perhaps.
> 
> Sorry about the trouble.  Here is a patch to just warn for now, with
> the changelog showing what i intend to push next.
> 
> sorry again,
> -serge
> 
> From 2d7408541dd3a6e19a4265b028233789be6a40f4 Mon Sep 17 00:00:00 2001
> From: Serge Hallyn <serge@peq.(none)>
> Date: Thu, 3 Feb 2011 09:26:15 -0600
> Subject: [PATCH 1/1] cap_syslog: don't refuse cap_sys_admin for now
> 
> At 2.6.39 or 2.6.40, let's add a sysctl which defaults to 0.  When
> 0, refuse if cap_sys_admin, if 1, then allow.  This will allow
> users to acknowledge (permanently, if they must, using /etc/sysctl.conf)
> that they've seen the syslog message about cap_sys_admin being
> deprecated for syslog.

Could we have it the other way around, at least for a while? Otherwise,
if someone happens to upgrade the kernel, and forgets to upgrade the
syslogd, he'll still experience breakage. With defaulting to 1,
compatiblity is kept, and systems that were upgraded properly can set it
to 0 and live happily ever after. The WARNs should prompt people to
upgrade at the first opportunity, so hopefully, it won't go unnoticed
and ignored by userspace.

I'm not sure one would even see the kernel warn with the syslogd not
being able to read the kernel messages (dmesg, of course, would reveal
it, but that's one extra step).

-- 
|8]


