Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759013Ab1JGP7I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 11:59:08 -0400
Received: from tango.0pointer.de ([85.214.72.216]:36062 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab1JGP7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 11:59:04 -0400
Date: Fri, 7 Oct 2011 17:58:59 +0200
From: Lennart Poettering <mzxreary@0pointer.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        harald@redhat.com, david@fubar.dk, greg@kroah.com
Subject: Re: A =?utf-8?Q?Plumber=E2=80=99?=
	=?utf-8?Q?s?= Wish List for Linux
Message-ID: <20111007155858.GA14201@tango.0pointer.de>
References: <1317943022.1095.25.camel@mop>
 <m2lisx3cpl.fsf@firstfloor.org>
 <20111007001356.GA11994@tango.0pointer.de>
 <20111007015732.GZ14482@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111007015732.GZ14482@one.firstfloor.org>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07.10.11 03:57, Andi Kleen (andi@firstfloor.org) wrote:

> 
> > Well, I am aware of PR_SET_NAME, but that modifies comm, not argv[]. And
> > while "top" indeed shows the former, "ps" shows the latter. We are looking
> > for a way to nice way to modify argv[] without having to reuse space
> > from environ[] like most current Linux implementations of
> > setproctitle() do.
> 
> It's not clear to me how the kernel could change argv[] any better than you 
> could in user space.

Well, it can resize the argv[] buffer, which we can't right now in
userspace. See those PR_SET_PROCTITLE_AREA.

> > Well, it's interesting in the syslog case, and it's OK if people can
> > change it. What matters is that this information is available simply for
> > the informational value. Right now, if one combines SCM_CREDENTIALS and
> > /proc/$PID/comm you often end up with no information about the senders
> > name at all, since at the time you try to read comm the PID might
> > actually not exist anymore at all. We are simply trying to close this
> > particular race between receiving SCM_CREDENTIALS and reading
> > /proc/$PID/comm here, we are not looking for a way to make process names
> > trusted.
> 
> The issue with all of these proposals is that the sender currently doesn't
> know if the receiver needs it. Thus it always has to put it in and you
> slow down the fast paths.
> 
> e.g. consider
> 
> sender sends packet
>                                      receiver enables funky option
>                                      receiver reads
> 
> If it was done lazily you would lose.

Would you? I think it's OK if messages queued before the sockopt is
enabled do not carry the SCM_COMM/SCM_CGROUPS data, even if they are
dequeued after the sockopt. At least I wouldn't expect them to
necessarily have the data, and this is probably just a matter of
documentation, i.e. say in the man page explicitly that the control data
will only be attached to newly queued messages. Given that
SCM_COMM/SCM_CGROUPS is a completely new API anyway this should not
create any compatibility problems.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
