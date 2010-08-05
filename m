Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759601Ab0HEAMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 20:12:42 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:50540 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759424Ab0HEAMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 20:12:38 -0400
To: Michael Leun <lkml20100708@newton.leun.net>
Cc: Greg KH <greg@kroah.com>, netdev@vger.kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: Re: NET_NS: unregister_netdevice: waiting for lo to become free (after using openvpn) (was Re: sysfs bug when using tun with network namespaces)
References: <loom.20100708T183152-326@post.gmane.org>
	<20100709235744.GA12752@kroah.com>
	<20100710101540.2799c9ef@xenia.leun.net>
	<20100710140800.GA20424@kroah.com>
	<20100710165208.59272ae6@xenia.leun.net>
	<20100710235323.5336f627@xenia.leun.net>
	<20100711192939.1c25dcaf@xenia.leun.net>
	<20100804153543.56f6ecad@xenia.leun.net>
	<20100804214618.GA6289@kroah.com>
	<20100805001105.5a3453ed@xenia.leun.net>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 04 Aug 2010 17:12:29 -0700
In-Reply-To: <20100805001105.5a3453ed@xenia.leun.net> (Michael Leun's message of "Thu\, 5 Aug 2010 00\:11\:05 +0200")
Message-ID: <m1lj8l29zm.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.188.4.80;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.4.80
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Leun <lkml20100708@newton.leun.net> writes:

> Hi,
>
> On Wed, 4 Aug 2010 14:46:18 -0700
> Greg KH <greg@kroah.com> wrote:
>
>> Eric, here's a bug with the network namespace stuff, care to work on
>> resolving it?
>
> Just in case I provide the complete scenario again below.
>
> If I can help somehow (provide further information, test something...)
> of course I'll happily do so.
>
> In an network namespace I can use an tun/tap tunnel through ssh and
> when closing that namespace then eveything is fine.
>
> But when using openvpn (also tunnel trough tun/tap) in an network
> namespace and then closing that namespace I get:
>
> unregister_netdevice: waiting for lo to become free
> [repeated]
>
> Please see the following two examples showing that difference:
>
> # > unshare -n /bin/bash
> # > # how to setup veth device pair to get connectivity into namespace not shown here
> # > tunctl -u ml -t tap1
> # > ssh -o Tunnel=Ethernet -w 1:1 somewhere
> [ running some traffic over tap1 not shown here ]
> ^d # logging out from somewhere
> # > tunctl -d tap1
> # > exit # logging out from shell in network namespace
>
> Now the veth device pair used automagically vanishes and nothing
> from that different network namespace remains - very well.
>
> but
>
> # > unshare -n /bin/bash
> # > # how to setup veth device pair to get connectivity into namespace not shown here
> # > openvpn --config some.config
> [ running some traffic over vpn device not shown here ]
> ^c # stopping openvpn
> # > lsof -i
> # > netstat -an
> Active Internet connections (servers and established)
> Proto Recv-Q Send-Q Local Address           Foreign Address
> State Active UNIX domain sockets (servers and established)
> Proto RefCnt Flags       Type       State         I-Node Path
> # > ps ax|grep openvpn|grep -v grep
> # > # cannot find anything that suggests there is anything left from that openvpn session 
> # > exit # logging out from shell in network namespace
>
> Now I get
>
> Jul 10 20:02:36 doris kernel: unregister_netdevice: waiting for lo to
> become free. Usage count = 3 [repeated]

How many times?

> Now one might say it is fault of openvpn (used OpenVPN 2.1_rc20
> i586-suse-linux - the one in openSuSE 11.2 package - EDIT: meanwhile it
> is 2.1.1, openSuSE 11.3 ), openvpn didn't close some ressource and ssh
> does fine.
>
> But: should'nt kernel clean up after process when it exits?
> And/or: Should'nt kernel clean up if last process in network namespace
> exits - there is nothing left which might use that interface?!

We do, and the only place you will see:
 unregister_netdevice: waiting for lo to become free. Usage count = 3 [repeated]
is when the a network namespace is being cleaned up.

However it looks like something is either taking a long time to get
cleaned up, or there is a bug and something is failing to get cleaned
up altogether thus resulting in an infinite stream of messages about waiting
for lo to become free.

I know of cases where a recent kernel can be slow to cleanup everything
attached to lo.  I don't know of any cases where it will actually fail
to clean up lo.  So I suspect all you are seeing is clean up process that
is slow and annoying not wrong.

Eric
