Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab0GJV5q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 17:57:46 -0400
Received: from serv04.lahn.de ([213.239.197.57]:50327 "EHLO serv04.lahn.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121Ab0GJV5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 17:57:44 -0400
Date: Sat, 10 Jul 2010 23:53:23 +0200
From: Michael Leun <lkml20100708@newton.leun.net>
To: linux-kernel@vger.kernel.org
Cc: Greg KH <greg@kroah.com>
Subject: NET_NS: unregister_netdevice: waiting for lo to become free (after
 using openvpn) (was Re: sysfs bug when using tun with network namespaces)
Message-ID: <20100710235323.5336f627@xenia.leun.net>
In-Reply-To: <20100710165208.59272ae6@xenia.leun.net>
References: <loom.20100708T183152-326@post.gmane.org>
	<20100709235744.GA12752@kroah.com>
	<20100710101540.2799c9ef@xenia.leun.net>
	<20100710140800.GA20424@kroah.com>
	<20100710165208.59272ae6@xenia.leun.net>
Organization: Not Organized
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.6; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, 10 Jul 2010 16:52:08 +0200
Michael Leun <lkml20100708@newton.leun.net> wrote:

> # tunctl -u ml -t tap1

> works as expected, but

> # unshare -n /bin/bash
> # tunctl -u ml -t tap1
[bug solved in 2.6.35-rcX - I used 2.6.34.1]

Now that we have solved that last one I've another glitch (this time using 2.6.35-rc4):

In an network namespace I can use an tun/tap tunnel through ssh and
when closing that namespace then eveything is fine.

But when using openvpn (also tunnel trough tun/tap) in an network
namespace and then closing that namespace I get:

unregister_netdevice: waiting for lo to become free
[repeated]

Please see the following two examples showing that difference:

# > unshare -n /bin/bash
# > # how to setup veth device pair to get connectivity into namespace not shown here
# > tunctl -u ml -t tap1
# > ssh -o Tunnel=Ethernet -w 1:1 somewhere
[ running some traffic over tap1 not shown here ]
^d # logging out from somewhere
# > tunctl -d tap1
# > exit # logging out from shell in network namespace

Now the veth device pair used automagically vanishes and nothing
from that different network namespace remains - very well.

but

# > unshare -n /bin/bash
# > # how to setup veth device pair to get connectivity into namespace not shown here
# > openvpn --config some.config
[ running some traffic over vpn device not shown here ]
^c # stopping openvpn
# > lsof -i
# > netstat -an
Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address           Foreign Address         State
Active UNIX domain sockets (servers and established)
Proto RefCnt Flags       Type       State         I-Node Path
# > ps ax|grep openvpn|grep -v grep
# > # cannot find anything that suggests there is anything left from that openvpn session
# > exit # logging out from shell in network namespace

Now I get

Jul 10 20:02:36 doris kernel: unregister_netdevice: waiting for lo to become free. Usage count = 3
[repeated]

Now one might say it is fault of openvpn (used OpenVPN 2.1_rc20
i586-suse-linux - the one in openSuSE 11.2 package), openvpn didn't
close some ressource and ssh does fine.

But: should'nt kernel clean up after process when it exits?
And/or: Should'nt kernel clean up if last process in network namespace
exits - there is nothing left which might use that interface?!

-- 
MfG,

Michael Leun

