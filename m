Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604Ab1J0AFt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 20:05:49 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36097 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414Ab1J0AFr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 20:05:47 -0400
MIME-Version: 1.0
In-Reply-To: <CABDyM6S9XK64n374AKCu5YUq4PBAmaB0jCgE9+snnM9XeQo1yg@mail.gmail.com>
References: <20111019060108.GA11588@gamma.logic.tuwien.ac.at>
	<CABDyM6S9XK64n374AKCu5YUq4PBAmaB0jCgE9+snnM9XeQo1yg@mail.gmail.com>
Date: Wed, 26 Oct 2011 20:05:47 -0400
X-Google-Sender-Auth: 1_c4otz7n96HJn4VEX0_0hHOGOs
Message-ID: <CABDyM6R-BBV1_oci2vMoxcybT=0cxPRfHELvtrQTRfSf6WO9Eg@mail.gmail.com>
Subject: Fwd: iwlagn is getting very shaky
From: Richard Yao <ryao@cs.stonybrook.edu>
To: wey-yi.w.guy@intel.com
Cc: Norbert Preining <preining@logic.at>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Wey,

Here is the message that I sent earlier.

Yours truly,
Richard Yao

---------- Forwarded message ----------
From: Richard Yao <ryao@cs.stonybrook.edu>
Date: Wed, Oct 26, 2011 at 12:19 AM
Subject: Re: iwlagn is getting very shaky
To: linux-kernel@vger.kernel.org
Cc: preining@logic.at


Dear Everyone,

I have always had issues with Wi-Fi at my university, although they
became particularly acute. The problem is characterized by an
inordinate number of Tx excessive retries like what Norbert posted. I
had been holding off on reporting this out of fear that my report
wouldn't be good enough, but now that I see Norbert reported it, I
thought I would contribute my findings.

When I looked into this, I found that the wireless spectrum on my
university is absurdly crowded. "iwlist wlan0 scan" reveals roughly
100 access points at any given time, many of which have the same SSID.
It is worst in the library, which probably one of the most densely
populated buildings. This appears to be linked to the hidden node
problem:

http://en.wikipedia.org/wiki/Hidden_node_problem

I found a few issues in the wireless stack that appear to exacerbate
this problem. The first of which is a kernel problem. The iwlagn
driver does not support "auto" for the rts and frag settings, so they
default to off. I tried fiddling with various settings, but the only
one that seems to make a difference is rts, which at the moment I have
set to 0, which should turn it on and transmit a request to send for
all traffic. I configured my laptop to set rts to 0 on boot and the
results were remarkable. I went from having to wait 30 minutes to an
hour to get a connection that would only last for 2 minutes if I was
lucky to being able to obtain a relatively stable connection within a
few minutes.

I also encountered another kernel issue, but I haven't seen it in a
while. That issue was characterized by "iwlagn 0000:03:00.0: Stopping
AGG while state not ON or starting". After that went into the dmesg
output, it looked like I was transmitting, but I never saw a single
response from the outside world until I did "modprobe -r iwlagn &&
modprobe iwlagn". I believe that this issue was present in kernel
3.1.0-rc4, but I could be off by an rc or two. It normally occurred
within 5 to 15 mnutes and only occurred if I had passed 11n_disable=1
to the kernel module. I don't pass that anymore, so I don't know if it
is still a problem.

With that said, I discovered issues in other areas of the wireless
stack. One is that Network Manager has a 25-second hard-coded timeout
(in nm-device-wifi.c) when controlling WPA Supplicant. Ignoring the
hard-coded part, having the time-out isn't so bad until you consider
that WPA Supplicant will enter an infinite retry loop whenever Network
Manager asks it to try connecting to an access point that is either
malfunctioning or cannot hear your wireless NIC. Furthermore, if you
are in an area where multiple access points use the same SSID, WPA
supplicant will try to connect to each one with its own 9 second
timeout, so Network Manager will kill it before it has gone through
the entire list. I don't know if the 9 second timeout is hard coded,
but the kernel lists 3 direct probe attempts in the dmesg output and
if all 3 fail, WPA Supplicant will wait precisely 9 seconds (from the
first one) before it tries something else. I imgaine that if someone
patched the stack to implements some callbacks, things would become
much better when they don't work the first time. With that said, WPA
Supplicant needs a callback from the kernel when association fails and
either WPA Supplicant, Network Manager or both need to be patched so
that WPA Supplicant will not enter an infinite retry loop and instead
it will give Network Manager a failure callback so that it can try
something else.

This might be the wrong mailing list to discuss issues that reside
entirely in userland, but since I described a few other issues that
were sort of a mix of both, I think I will throw in the other two that
I found for completeness. With that said, another issue that sometimes
happens is that the kernel loses the wireless access point
association. If I do this manually, I can just use iwconfig to make
the kerenl reassociate, but if that happens with Network Manager, it
kills the entire connection and starts from scratch. This leads us to
the last issue I identified, which is that dhclient can be horribly
slow at times such that even if things work perfectly, getting a DHCP
lease takes what feels like ages. This can be fixed by implementing
RFC 4436 like Apple did in its products. It can also be worked around
by configuring it to make an attempt every few seconds rather than
every minute, which coincidentally, is the exact time that it takes
for dhclient to time itself out and quit, making Network Manager kill
an otherwise good connection. I reported this last year to my
distribution, which has since changed the default config file, but in
the course of diagnosing this year's problems, I managed to find
various LUG mailing lists discussing this problem. Their workaround
was to run dhclient manually, which causes zombie processes to be made
and it really doesn't seem like the right solution to this issue.

Anyway, that is everything that I know about this issue. I am right
now sitting on as many as three other issues in other parts of the
kernel, but I don't plan to report them until I understand them well
enough to either write patches or post how to reliably reproduce them.
The last time I posted something on the mailing list, someone named
Ted yelled at me for asking a stupid question. If that happens again,
I will probably just unsubscribe and let that be the end of it. I have
only used Linux for less than 2 years and I am not paid to do this, so
please be nice.

Yours truly,
Richard Yao

On Wed, Oct 19, 2011 at 2:01 AM, Norbert Preining <preining@logic.at> wrote:
> Hi everyone
>
> (please Cc),
>
> I am currently running 3.1.0-rc10, and I am having a hard time with
> the wlan network here at the university.
>
> For quite some time, like 10min, it is fine, then suddently the
> iwlagn driver gives up on me and connection is dropped.
>
> In the log file I see:
> [  172.137011] iwlagn 0000:06:00.0: Tx aggregation enabled on ra = 00:24:c4:ab:bd:ef tid = 0
> [  821.841016] iwlagn 0000:06:00.0: Tx aggregation enabled on ra = 00:24:c4:ab:bd:ef tid = 6
> [ 1095.580735] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 1/3)
> [ 1095.780076] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 2/3)
> [ 1095.980101] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 3/3)
> [ 1096.180117] wlan0: direct probe to 00:24:c4:ab:bd:e0 timed out
> [ 1105.255464] wlan0: deauthenticating from 00:24:c4:ab:bd:ef by local choice (reason=2)
> [ 1105.255519] iwlagn 0000:06:00.0: Stopping AGG while state not ON or starting
> [ 1105.265581] cfg80211: Calling CRDA for country: JP
> [ 1105.271476] wlan0: authenticate with 00:24:c4:ab:bd:e0 (try 1)
> [ 1105.468105] wlan0: authenticate with 00:24:c4:ab:bd:e0 (try 2)
> [ 1105.668110] wlan0: authenticate with 00:24:c4:ab:bd:e0 (try 3)
> [ 1105.868090] wlan0: authentication with 00:24:c4:ab:bd:e0 timed out
> [ 1113.667890] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 1/3)
> [ 1113.864116] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 2/3)
> [ 1114.064095] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 3/3)
> [ 1114.264109] wlan0: direct probe to 00:24:c4:ab:bd:e0 timed out
>
> Somewhere around 1100 the connection is gone and never comes back again.
>
> I tried removing the driver module from the kernel and reinserting it,
> tried to turn on and off the hardware swithc (rfkill), all without
> no success, the wlan connection remains dead until I reboot.
>
> I am not sure exactely when it started, I guess somewhere in the
> 3.1 cycle, before I was permanently working wiht wlan, now I always
> plug in the cable.
>
> If there is any way to track down this, or any suggestions how I can
> debug it, please let me know.
>
> Hardware: Sony VGN-Z11, Intel(R) WiFi Link 5100 AGN, REV=0x54
> L1 Enabled; Disabling L0S
> device EEPROM VER=0x11e, CALIB=0x4
> Device SKU: 0Xf0
> Tunable channels: 13 802.11bg, 24 802.11a channels
> loaded firmware version 8.83.5.1 build 33692 (EXP)
>
>
> On the other hand, the same laptop with the very same configuration
> works very nicely in my flat's wlan, which is some dirt cheap Japanese
> only wlan router.
>
> Best wishes and thanks a lot
>
> Norbert
> ------------------------------------------------------------------------
> Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
> JAIST, Japan                                 TeX Live & Debian Developer
> DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
> ------------------------------------------------------------------------
> DITHERINGTON (n)
> Sudden access to panic experienced by one who realises that he is
> being drawn inexorably into a clabby (q.v.) conversation, i.e. one he
> has no hope of enjoying, benefiting from or understanding.
>                        --- Douglas Adams, The Meaning of Liff
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
