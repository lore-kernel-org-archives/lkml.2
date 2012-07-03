Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756987Ab2GCQxU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 12:53:20 -0400
Received: from exprod7og102.obsmtp.com ([64.18.2.157]:49612 "EHLO
	exprod7og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab2GCQxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 12:53:18 -0400
Message-ID: <4FF32352.5040800@genband.com>
Date: Tue, 03 Jul 2012 10:52:34 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
CC: David Miller <davem@davemloft.net>, vincent.sanders@collabora.co.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: AF_BUS socket address family
References: <4FF1BBD5.8080804@collabora.co.uk>
In-Reply-To: <4FF1BBD5.8080804@collabora.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Jul 2012 16:52:35.0969 (UTC) FILETIME=[3F5EA710:01CD593C]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-19014.005
X-TM-AS-Result: No--23.300300-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2012 09:18 AM, Javier Martinez Canillas wrote:

> We tried different approaches before developing the AF_BUS socket family and one
> of them was extending AF_UNIX to support multicast. We posted our patches [1]
> and the feedback was that the AF_UNIX code was already a complex and difficult
> code to maintain. So, we decided to implement a new family (AF_BUS) that is
> orthogonal to the rest of the networking stack and no added complexity nor
> performance penalty would pay a user not using our IPC solution.

That's what I ended up doing as well.  In our case it's basically a 
stripped-down AF_UNIX with only datagram support, no security, no fd 
passing, etc., but with with the addition of multicast and wildcard (for 
debugging).

> Looking at netdev archives I saw that you both raised the question about
> multicast on unix sockets and post an implementation on early 2003. So if I
> understand correctly you are maintaining an out-of-tree solution for around 9
> years now.

That's correct.

> It would be a great help if you can join the discussion and explain the
> arguments of your company (and the others companies you were talking about) in
> favor of a simpler multicast socket family.
>
> The fact that your company spent lots of engineering resources to maintain an
> out-of-tree patch-set for 9 years should raise some eyebrows and convince more
> than one people that a simpler local multicast solution is needed on the Linux
> kernel (which was one of the reasons why Google also developed Binder I guess).

To be fair, since it was implemented as a separate protocol family the 
maintenance burden actually hasn't been large--it's been fairly simple 
to port between versions.  Also, we do embedded telecom stuff and don't 
jump kernel versions all that often.  (It's a big headache, requires 
coordinating between multiple vendors, etc.)

In our case we typically send small (100-200 byte) messages to a 
smallish (1-10) number of listeners, though there are exceptions of 
course.  Back before I started the original implementation used a 
userspace daemon, but it had a number of issues.  Originally I was 
focussed on the performance gains but I must admit that since then other 
factors have made that less of an issue.

Among other things, this messaging is used on some systems to configure 
the IP addressing for the system, so it does simplify things to not use 
an IP-based protocol for this purpose.

Also, back when I did my original implementation IP multicast wasn't 
supported on the loopback device--David, has that changed since then? 
If it has, then we probably could figure out a way to make it work using 
IP multicast, but I don't know that it would be worth the effort given 
the minimal ongoing maintenance costs for our patch.

Chris
