Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab1EGK6g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 06:58:36 -0400
Received: from [195.139.68.2] ([195.139.68.2]:47720 "HELO jensen.inet.no"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1754796Ab1EGK6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 06:58:35 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 May 2011 06:58:34 EDT
Date: Sat, 7 May 2011 12:51:52 +0200
From: Michael Shuldman <michaels@inet.no>
To: linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, karls@inet.no
Subject: bug in select(2) regarding non-blocking connect(2) completion?
Message-ID: <20110507105152.GA13459@jensen.inet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello, I am occasionally encountering what I belive is a bug in the
kernel.

Below is a strace that I believe shows how the bug manifests itself,
with my comments.


# first select.  All fd's in the write set ([15 17 ... 51 55]) are 
# non-blocking sockets that have had a connect(2) previously issued on
# them, and which have yet to finish connecting as far as we know
# at the time we call select(2).
03:55:31.808548 select(58, [4 8 11 12 13 14 16 18 19 20 21 22 23 24 26 27 30 31
32 33 34 35 36 37 39 40 41 43 44 46 48 49 50 52 53 54 57], [15 17 25 29 45 47 51
 55], [11 12 13 14 16 18 19 20 21 22 23 24 26 27 30 31 32 33 34 35 36 37 39 40 4
1 43 44 46 48 49 50 52 53 54 57], {1, 0}) = 3 (in [16 26], out [51], left {1, 0}
)

# As indicated by the results returned by the above select(2), fd 51 should
# have finished the connect attempt, but when we try to find out whether 
# the connect(2) succeeded or failed, the results are conflicting.

03:55:31.808622 getpeername(51, 0x7fff5d2eaa8c, [0]) = -1 ENOTCONN (Transport en
dpoint is not connected)
03:55:31.808900 getsockopt(51, SOL_SOCKET, SO_ERROR, [0], [4]) = 0

# getpeername(2) failing on a socket that has finished connecting should 
# indicate that the connect(2) failed.  Yet when we try to fetch the
# SO_ERROR of the socket, it says no error is currently set.
# We then loop around with select(2) again, and again the same thing
# happens:

03:55:31.809259 select(58, [4 8 11 12 13 14 16 18 19 20 21 22 23 24 26 27 30 31
32 33 34 35 36 37 39 40 41 43 44 46 48 49 50 52 53 54 57], [15 17 25 29 45 47 51
 55], [11 12 13 14 16 18 19 20 21 22 23 24 26 27 30 31 32 33 34 35 36 37 39 40 4
1 43 44 46 48 49 50 52 53 54 57], {1, 0}) = 3 (in [16 26], out [51], left {1, 0}
)
03:55:31.809329 getpeername(51, 0x7fff5d2eaa8c, [0]) = -1 ENOTCONN (Transport en
dpoint is not connected)
03:55:31.809640 getsockopt(51, SOL_SOCKET, SO_ERROR, [0], [4]) = 0

...

# finally, getsockopt(2) returns that the connect(2) failed.
03:55:32.521146 getpeername(51, 0x7fff5d2eaa8c, [0]) = -1 ENOTCONN (Transport en
dpoint is not connected)
03:55:32.521614 getsockopt(51, SOL_SOCKET, SO_ERROR, [101], [4]) = 0

In other words, select(2) says the socket has finished connecting,
getpeername(2) neither confirms nor denies this (it can only confirm
if the connect finished successfully).  getsockopt(2) and SO_ERROR
however says there is no error on the socket, which coupled
with getpeername(2) failing, indicates that the connect(2) has
not yet finished



This does not happen all the time.  E.g., I watched the system for
an hour yesterday, as things were staring up and the number of
concurrent tcp clients gradually increased from zero to around 700,
with no observable problems.  However after a while, the problem
starts occurring, related to an increasing number of clients or
something else, I do not know.

Currently the system has a little over 3,000 clients and the problem
occurs now and then, sometimes several times a minute, while sometimes
it can take dozens of minutes between each time.  At the moment,
the last time the problem was detected was 40 minutes ago.

The software the above strace is related to is a proxy server, and
if there are 3000 clients (incoming TCP sessions), there would
normally be 3000 outgoing TCP sessions also.  

uname -a on the system in question reports 
2.6.18-238.9.1.el5 #1 SMP Tue Apr 12 18:10:13 EDT 2011 x86_64 x86_64
x86_64 GNU/Linux

Thankful for any hints or pointers related to this problem.
With kind regards,

-- 
  _ // 
  \X/ -- Michael Shuldman 

