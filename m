Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993Ab2HOVEC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 17:04:02 -0400
Received: from cobra.newdream.net ([66.33.216.30]:35283 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756489Ab2HOVEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 17:04:00 -0400
Date: Wed, 15 Aug 2012 14:03:59 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: "Atchley, Scott" <atchleyes@ornl.gov>
cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Subject: Re: regression with poll(2)?
In-Reply-To: <43EC24BD-D7FF-4611-9D88-DF9C496A620A@ornl.gov>
Message-ID: <alpine.DEB.2.00.1208151402220.18862@cobra.newdream.net>
References: <alpine.DEB.2.00.1208151226250.15721@cobra.newdream.net> <43EC24BD-D7FF-4611-9D88-DF9C496A620A@ornl.gov>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Aug 2012, Atchley, Scott wrote:
> On Aug 15, 2012, at 3:46 PM, Sage Weil wrote:
> 
> > I'm experiencing a stall with Ceph daemons communicating over TCP that 
> > occurs reliably with 3.6-rc1 (and linus/master) but not 3.5.  The basic 
> > situation is:
> > 
> > - the socket is two processes communicating over TCP on the same host, e.g. 
> > 
> > tcp        0 2164849 10.214.132.38:6801      10.214.132.38:51729     ESTABLISHED
> > 
> > - one end writes a bunch of data in
> > - the other end consumes data, but at some point stalls.
> > - reads are nonblocking, e.g.
> > 
> >  int got = ::recv( sd, buf, len, MSG_DONTWAIT );
> > 
> > and between those calls we wait with
> > 
> >  struct pollfd pfd;
> >  short evmask;
> >  pfd.fd = sd;
> >  pfd.events = POLLIN;
> > #if defined(__linux__)
> >  pfd.events |= POLLRDHUP;
> > #endif
> > 
> >  if (poll(&pfd, 1, msgr->timeout) <= 0)
> >    return -1;
> > 
> > - in my case the timeout is ~15 minutes.  at that point it errors out, 
> > and the daemons reconnect and continue for a while until hitting this 
> > again.
> > 
> > - at the time of the stall, the reading process is blocked on that 
> > poll(2) call.  There are a bunch of threads stuck on poll(2), some of them 
> > stuck and some not, but they all have stacks like
> > 
> > [<ffffffff8118f6f9>] poll_schedule_timeout+0x49/0x70
> > [<ffffffff81190baf>] do_sys_poll+0x35f/0x4c0
> > [<ffffffff81190deb>] sys_poll+0x6b/0x100
> > [<ffffffff8163d369>] system_call_fastpath+0x16/0x1b
> > 
> > - you'll note that the netstat output shows data queued:
> > 
> > tcp        0 1163264 10.214.132.36:6807      10.214.132.36:41738     ESTABLISHED
> > tcp        0 1622016 10.214.132.36:41738     10.214.132.36:6807      ESTABLISHED
> > 
> > etc.
> > 
> > Is this a known regression?  Or might I be misusing the API?  What 
> > information would help track it down?
> > 
> > Thanks!
> > sage
> 
> 
> Sage,
> 
> Do you see the same behavior when using two hosts (i.e. not loopback)? If different, how much data is in the pipe in the localhost case?

I have only seen it in the loopback case, and have independently diagnosed 
it a half dozen or so times now.

:/
sage


> 
> Scott
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe ceph-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
