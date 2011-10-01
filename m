Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab1JAHfq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 03:35:46 -0400
Received: from 1wt.eu ([62.212.114.60]:33292 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189Ab1JAHfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 03:35:40 -0400
Date: Sat, 1 Oct 2011 09:35:33 +0200
From: Willy Tarreau <w@1wt.eu>
To: Greg KH <greg@kroah.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel.org status: hints on how to check your machine for intrusion
Message-ID: <20111001073533.GA18690@1wt.eu>
References: <4E8655CD.90107@zytor.com> <20110930235924.GA25176@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110930235924.GA25176@kroah.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Fri, Sep 30, 2011 at 04:59:24PM -0700, Greg KH wrote:
> The compromise of kernel.org and related machines has made it clear that
> some developers, at least, have had their systems penetrated.  As we
> seek to secure our infrastructure, it is imperative that nobody falls
> victim to the belief that it cannot happen to them.  We all need to
> check our systems for intrusions.  Here are some helpful hints as
> proposed by a number of developers on how to check to see if your Linux
> machine might be infected with something:

I would like to add here a few controls I ran on firewall and system logs,
that are easy to perform and which report few false positives :

  - check that communications between your local machines are expected ;
    for instance if you have an SSH bouncing machine, it probably receives
    tens of thousands of SSH connection attempts from outside every day,
    but it should never ever attempt to connect to another machine unless
    it's you who are doing it. So checking the firewall logs for SSH
    connections on port 22 from local machines should only report your
    activity (and nothing should happen when you sleep).

  - no SSH log should report failed connection attempts between your
    local machines (you do have your keys and remember your password).
    And if it happens from time to time (eg: user mismatch between
    machines), it should look normal to you. You should never observe
    a connection attempt for a user you're not familiar with (eg: admin).

     $ grep sshd /var/log/messages
     $ grep sshd /var/log/messages | grep 'Invalid user'

  - outgoing connections from your laptop, desktop or anything should
    never happen when you're not there, unless there is a well known
    reason (package updates, browser left open and refreshing ads). All
    unexpected activity should be analysed (eg: connections to port 80
    not coming from a browser should only match one distro mirror).
    This is particularly true for cheap appliances which become more
    and more common and are rarely secured. A NAS or media server, a
    switch, a WiFi router, etc... has no reason to ever connect anywhere
    without you being aware of it (eg: download a firmware update).

  - check for suspicious DNS requests from machines that are normally
    not accessed. A number of services perform DNS requests when
    connected to, in order to log a resolved address. If the machine
    was penetrated and the logs wiped, the DNS requests will probably
    still lie in the firewall logs. While there's nothing suspect from
    a machine that does tens of thousands DNS requests a day, one that
    does 10 might be suspect.

  - check for outgoing SMTP connections. Most machines probably never
    send any mail outside or route them through a specific relay. If
    one machine suddenly tries to send mails directly to the outside,
    it might be someone trying to steal some data (eg: mail ssh keys).

  - check for long holes in logs various service logs. The idea is that
    if a system was penetrated and the guy notices he left a number of
    traces, he will probably have wiped some logs. A simple way to check
    for this is to count the number of events per hour and observe huge
    variations. Eg:

       $ cut -c1-9 < /var/log/syslog |uniq -c
       8490 Oct  1 00
       7712 Oct  1 01
       8316 Oct  1 02
       6743 Oct  1 03
       7428 Oct  1 04
       7041 Oct  1 05
       7762 Oct  1 06
       6562 Oct  1 07
       7137 Oct  1 08
        160 Oct  1 09

    Activity looks normal here. Something like this however would be
    extremely suspect :

       8490 Oct  1 00
        712 Oct  1 01
       6743 Oct  1 03

  - check that you never observe in logs a local address that you
    don't know. For instance, if your reverse proxy is on a DMZ which
    is provided by the same physical switch as your LAN and your switch
    becomes ill and loses all its VLAN configuration, it them becomes
    easy to add an alias to the reverse-proxy to connect directly to
    LAN machines and bypass a firewall (and its logs).

  - it's always a good exercise to check for setuids on all your machines.
    You'll generally discover a number of things you did not even suspect
    existed and will likely want to remove them. For instance, my file
    server had dbus-daemon-launch-helper setuid root. I removed this crap
    as dbus has nothing to do on such a machine. Similarly I don't need
    fdmount to mount floppies. I might not use floppies often, and if I do,
    I know how to use sudo.

       $ find / -user root -perm -4000 -ls

  - last considerations to keep in mind is that machines which receive
    incoming connections from outside should never be able to go out, and
    should be isolated in their own LAN. It's not hard to do at all, and
    it massively limits the ability to bounce between systems and to steal
    information. It also makes firewall logs much more meaningful, provided
    they are stored on a support with limited access, of course :-)

Regards,
Willy

