Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464Ab1IPEbO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 00:31:14 -0400
Received: from mail.f5.com ([208.85.209.139]:63995 "EHLO mail.f5.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826Ab1IPEbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 00:31:13 -0400
X-Greylist: delayed 574 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Sep 2011 00:31:13 EDT
X-IronPort-AV: E=Sophos;i="4.68,357,1312156800"; 
   d="scan'208";a="32961758"
Message-ID: <4E72CED0.1020200@f5.com>
Date: Fri, 16 Sep 2011 00:21:36 -0400
From: David Bein <d.bein@f5.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20110318)
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
Subject: Re: /proc/sys/net/ipv4/ip_local_reserved_ports
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.100.150]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the reserved port bitmap to be truly useful, there needs to be a way to
have the kernel bind (+ implicit bind in connect, datagram sendmsg, etc)
be told to use a "privileged" port range.

Has anyone ever considered adding the IP_PORTRANGE socket option
which would add 2 other port ranges: LOW (privileged -- e.g. 600-1023)
and HIGH (for high end ports, e.g. 55000-65535) for running around 
firewalls.
This interface was added to FreeBSD maybe 15 years ago and in practical
terms means that glibc bindresvport() would select the privileged port 
range,
set sin->sin_port to 0 and lets the kernel do the rest. Similar dance 
for AF_INET6.

This does require tweaking glibc bindresvport() to handle the details.
The FreeBSD folks have the details in their versions of libc.
It is in fact faster because in the presence of a number of busy ports
the overhead of a few hundred bind() system calls is eliminated.
The kernel is very good at picking free ports, so this is just extending
where it does it without hacking ip_local_port_range to include
privileged ports (which IMO is a very bad idea).

I've prototyped the kernel ip socket option support for IP_PORTRANGE
(along with the sysctl glue for 2 more port ranges).

Using this and ip_local_reserved_ports, it is indeed possible to use
the reserved ports set in the bitmap and prevent all the usual problems
when some program innocently picks a privileged port that some other
daemon will expect to be free for a specific binding on a well known port.

