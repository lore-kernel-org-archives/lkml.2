Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab1DMR54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 13:57:56 -0400
Received: from lucidpixels.com ([75.144.35.66]:34505 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754959Ab1DMR5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 13:57:54 -0400
Date: Wed, 13 Apr 2011 13:57:52 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Daniel Halperin <dhalperi@cs.washington.edu>
cc: Ivo Van Doorn <ivdoorn@gmail.com>, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.38: rt2800usb: high latency (1000ms)?
In-Reply-To: <BANLkTin6mgFqrGQJz=zNG_buRiLKHOU_BA@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1104131348530.16793@p34.internal.lan>
References: <alpine.DEB.2.02.1104131139380.11270@p34.internal.lan> <BANLkTi==Bw6mWWJidLi+ZRzz87ck4DAqVA@mail.gmail.com> <alpine.DEB.2.02.1104131200220.2954@p34.internal.lan> <BANLkTinxkXi6WnAyXoZLDR+uyL+TmevuPw@mail.gmail.com>
 <BANLkTin6mgFqrGQJz=zNG_buRiLKHOU_BA@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="655872-826444373-1302717472=:16793"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--655872-826444373-1302717472=:16793
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Wed, 13 Apr 2011, Daniel Halperin wrote:

> Ugh! Couldn't you configure the stupid mailing list filter to only
> drop rich text mails that have [PATCH or [RFC or [RFT in the subject,
> e.g.? Original mail below.
>
> (sorry for the resend, Justin and Ivo).
>
> Dan
>
> On Wed, Apr 13, 2011 at 9:23 AM, Daniel Halperin
> <dhalperi@cs.washington.edu> wrote:
>>
>> On Wed, Apr 13, 2011 at 9:01 AM, Justin Piszcz <jpiszcz@lucidpixels.com>=
 wrote:
>>>>
>>>> Can you try disabling powersaving?
>>>> iwconfig wlan0 power off
>>>>
>>> Wow! That was it, now its interactive again.
>>>
>>> 64 bytes from wireless-host (192.168.1.2): icmp_req=3D1 ttl=3D64 time=
=3D0.581 ms
>>> 64 bytes from wireless-host (192.168.1.2): icmp_req=3D2 ttl=3D64 time=
=3D0.647 ms
>>>
>>> Thanks, so its recommend to keep this off then, can that be set as the =
driver default?
>>>
>>
>> That's a bad idea, what you're seeing is likely completely a red herring=
=2E=A0Wi-Fi power saving mode saves energy by putting the RF hardware most =
of the time. This is a Good Thing.
>> Power save is designed to kick in only when the load is very slow; the c=
lient's network stack should automatically disable power save during times =
of high load, e.g., during a download or a VoIP call. You should run some t=
ests to see if this is actually occurring; there may be a bug in the rtl im=
plementation.
>> The real problem here is that your ping test has invalid assumptions. On=
e packet/second is not enough load to disable Wi-Fi power save, so you shou=
ld not see interactive ping times. Again, this is a good thing and somethin=
g I doubt you want to disable! (Assuming that RTL's implementation isn't fu=
ndamentally broken elsewhere) It certainly should NOT be the driver default=
=2E
>> Try again with sudo ping -i 0.01 -s 1400 (e.g., to ping with large packe=
ts every 10 ms); this should probably trigger the logic that automatically =
disables the power saving mode. Or try pinging while doing a 1 Mbit UDP tra=
nsfer (e.g., with iperf).
>> Dan
>

Hi,

When powersave is enabled, it is very jumpy, I've used satellite comms befo=
re
and (~600ms-1200ms was more smooth) as it did not jump around as much.  The
application is just a standalone desktop with minimal activity for the majo=
rity
of the time, maybe thats why..

With powersave disabled, I now see 0% packet loss (802.11n) and low ping
times, this looks like the proper solution for the wireless USB device I
am using.  By the way, is it possible/are there wireless USB devices out th=
ere
that support wake on wireless lan (WOWL?

Your ping command with power off:
1408 bytes from server (192.168.1.2): icmp_req=3D539 ttl=3D64 time=3D1.07 m=
s
1408 bytes from server (192.168.1.2): icmp_req=3D540 ttl=3D64 time=3D1.31 m=
s
1408 bytes from server (192.168.1.2): icmp_req=3D541 ttl=3D64 time=3D1.07 m=
s
1408 bytes from server (192.168.1.2): icmp_req=3D542 ttl=3D64 time=3D1.26 m=
s

Your ping command with power on:
1408 bytes from server (192.168.1.2): icmp_req=3D649 ttl=3D64 time=3D1.80 m=
s
1408 bytes from server (192.168.1.2): icmp_req=3D650 ttl=3D64 time=3D1.85 m=
s
1408 bytes from server (192.168.1.2): icmp_req=3D651 ttl=3D64 time=3D2.86 m=
s
1408 bytes from server (192.168.1.2): icmp_req=3D652 ttl=3D64 time=3D1.46 m=
s

You are correct, if there is a lot of traffic, its good, but if the system
is relatively idle and all that's going on is an SSH session, there is horr=
ible
latency.

So the fix/workaround, for Debian-based distributions (if you come across=
=20
this problem):

File: /etc/network/interfaces

-- snip --

# Wireless
auto wlan0
iface wlan0 inet dhcp
   wpa-ssid your-ssid
   wpa-psk your-private-key
   post-up /sbin/iwconfig wlan0 power off

-- snip --

Justin.

--655872-826444373-1302717472=:16793--
