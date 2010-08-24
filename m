Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab0HXItw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 04:49:52 -0400
Received: from mx3.sophos.com ([74.202.89.160]:44340 "EHLO mx3.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752979Ab0HXItt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 04:49:49 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [PATCH 1/4] fanotify: flush outstanding perm requests on group destroy
Date: Tue, 24 Aug 2010 09:49:45 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
CC: Eric Paris <eparis@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1282523830-27751-1-git-send-email-eparis@redhat.com> <201008240313.11593.agruen@suse.de>
In-Reply-To: <201008240313.11593.agruen@suse.de>
MIME-Version: 1.0
Message-ID: <201008240949.46243.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 24/08/2010 09:49:46,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 24/08/2010 09:49:47,
	Serialize complete at 24/08/2010 09:49:47
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 Aug 2010 02:13:11 Andreas Gruenbacher wrote:
> On Monday 23 August 2010 02:37:07 Eric Paris wrote:
> > When an fanotify listener is closing it may cause a deadlock between the
> > listener and the original task doing an fs operation.  If the original
> > task is waiting for a permissions response it will be holding the srcu
> > lock. The listener cannot clean up and exit until after that srcu lock
> > is syncronized. Thus deadlock.  The fix introduced here is to stop
> > accepting new permissions events when a listener is shutting down and to
> > grant permission for all outstanding events.  Thus the original task
> > will eventually release the srcu lock and the listener can complete
> > shutdown.
>
> This seems to work now.
>
> The one remaining issue is that processes blocked on perm events cannot be
> killed even with SIGKILL.  I don't know how hard it will be to fix this.

I think just switching to interruptible sleep in
fanotify_get_response_from_access should be fine. And it should probably deny
the current event when signal is received.

Tvrtko

Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, United Kingdom.
Company Reg No 2096520. VAT Reg No GB 348 3873 20.
