Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812Ab2HOUyv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:54:51 -0400
Received: from mta01.ornl.gov ([128.219.14.70]:39716 "EHLO mta01.ornl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753495Ab2HOUyt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 16:54:49 -0400
X-Greylist: delayed 582 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Aug 2012 16:54:49 EDT
X-SG: RELAYLIST
X-IronPort-AV: E=Sophos;i="4.77,774,1336363200"; 
   d="scan'208";a="41470688"
From: "Atchley, Scott" <atchleyes@ornl.gov>
To: Sage Weil <sage@inktank.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Date: Wed, 15 Aug 2012 16:45:04 -0400
Subject: Re: regression with poll(2)?
Thread-Topic: regression with poll(2)?
Thread-Index: Ac17Jtkxg5PstzHnR9eA1qqKa0Pg6g==
Message-ID: <43EC24BD-D7FF-4611-9D88-DF9C496A620A@ornl.gov>
References: <alpine.DEB.2.00.1208151226250.15721@cobra.newdream.net>
In-Reply-To: <alpine.DEB.2.00.1208151226250.15721@cobra.newdream.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 15, 2012, at 3:46 PM, Sage Weil wrote:

> I'm experiencing a stall with Ceph daemons communicating over TCP that 
> occurs reliably with 3.6-rc1 (and linus/master) but not 3.5.  The basic 
> situation is:
> 
> - the socket is two processes communicating over TCP on the same host, e.g. 
> 
> tcp        0 2164849 10.214.132.38:6801      10.214.132.38:51729     ESTABLISHED
> 
> - one end writes a bunch of data in
> - the other end consumes data, but at some point stalls.
> - reads are nonblocking, e.g.
> 
>  int got = ::recv( sd, buf, len, MSG_DONTWAIT );
> 
> and between those calls we wait with
> 
>  struct pollfd pfd;
>  short evmask;
>  pfd.fd = sd;
>  pfd.events = POLLIN;
> #if defined(__linux__)
>  pfd.events |= POLLRDHUP;
> #endif
> 
>  if (poll(&pfd, 1, msgr->timeout) <= 0)
>    return -1;
> 
> - in my case the timeout is ~15 minutes.  at that point it errors out, 
> and the daemons reconnect and continue for a while until hitting this 
> again.
> 
> - at the time of the stall, the reading process is blocked on that 
> poll(2) call.  There are a bunch of threads stuck on poll(2), some of them 
> stuck and some not, but they all have stacks like
> 
> [<ffffffff8118f6f9>] poll_schedule_timeout+0x49/0x70
> [<ffffffff81190baf>] do_sys_poll+0x35f/0x4c0
> [<ffffffff81190deb>] sys_poll+0x6b/0x100
> [<ffffffff8163d369>] system_call_fastpath+0x16/0x1b
> 
> - you'll note that the netstat output shows data queued:
> 
> tcp        0 1163264 10.214.132.36:6807      10.214.132.36:41738     ESTABLISHED
> tcp        0 1622016 10.214.132.36:41738     10.214.132.36:6807      ESTABLISHED
> 
> etc.
> 
> Is this a known regression?  Or might I be misusing the API?  What 
> information would help track it down?
> 
> Thanks!
> sage


Sage,

Do you see the same behavior when using two hosts (i.e. not loopback)? If different, how much data is in the pipe in the localhost case?

Scott


