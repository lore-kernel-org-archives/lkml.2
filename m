Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab0HXJvf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 05:51:35 -0400
Received: from mx3.sophos.com ([74.202.89.160]:43945 "EHLO mx3.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754188Ab0HXJvc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 05:51:32 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [PATCH 1/4] fanotify: flush outstanding perm requests on group destroy
Date: Tue, 24 Aug 2010 10:51:29 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
CC: Eric Paris <eparis@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1282523830-27751-1-git-send-email-eparis@redhat.com> <201008240949.46243.tvrtko.ursulin@sophos.com> <201008241136.30064.agruen@suse.de>
In-Reply-To: <201008241136.30064.agruen@suse.de>
MIME-Version: 1.0
Message-ID: <201008241051.29656.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 24/08/2010 10:51:30,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 24/08/2010 10:51:30,
	Serialize complete at 24/08/2010 10:51:30
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 Aug 2010 10:36:29 Andreas Gruenbacher wrote:
> On Tuesday 24 August 2010 10:49:45 Tvrtko Ursulin wrote:
> > I think just switching to interruptible sleep in
> > fanotify_get_response_from_access should be fine. And it should probably
> > deny the current event when signal is received.
>
> Well the result would be -EINTR from the system call that blocked on the
> perm event, the same as with an interruptible nfs mount.  The process would
> never get -EPERM.  Processes may
> not be prepared to handle -EINTR in all cases, and so it may make more
> sense to use the same behavior as NFS and only allow SIGKILL to kill a
> process blocked on a perm event (which the blocked process will never
> see).

That would be wait_event_killable then, even simpler change.

I agree that hiding -EINTR from open, from userspace code is probably a more
compatible way of doing it. If I remember correctly POSIX does allow EINTR
from open but form our experience there are indeed applications which do not
handle it. Some version of X immediately spring to mind who used to set up a
periodic signal delivery (something like internal jiffy, I think they called
it smart scheduler) to themselves and would not handle -EINTR from open. Samba
also had a problem here in specific circumstances.

Tvrtko


Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, United Kingdom.
Company Reg No 2096520. VAT Reg No GB 348 3873 20.
