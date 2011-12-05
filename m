Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932728Ab1LERjZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 12:39:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29386 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932512Ab1LERjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 12:39:23 -0500
Message-ID: <4EDD01BA.40208@redhat.com>
Date: Mon, 05 Dec 2011 15:39:06 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: HoP <jpetrous@gmail.com>
CC: Florian Fainelli <f.fainelli@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Andreas Oberritter <obi@linuxtv.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver because
 of worrying about possible misusage?
References: <CAJbz7-2T33c+2uTciEEnzRTaHF7yMW9aYKNiiLniH8dPUYKw_w@mail.gmail.com> <4ED6C5B8.8040803@linuxtv.org> <4ED75F53.30709@redhat.com> <CAJbz7-0td1FaDkuAkSGQRdgG5pkxjYMUGLDi0Y5BrBF2=6aVCw@mail.gmail.com> <20111202231909.1ca311e2@lxorguk.ukuu.org.uk> <CAJbz7-0Xnd30nJsb7SfT+j6uki+6PJpD77DY4zARgh_29Z=-+g@mail.gmail.com> <4EDC9B17.2080701@gmail.com> <CAJbz7-2maWS6mx9WHUWLiW8gC-2PxLD3nc-3y7o9hMtYxN6ZwQ@mail.gmail.com>
In-Reply-To: <CAJbz7-2maWS6mx9WHUWLiW8gC-2PxLD3nc-3y7o9hMtYxN6ZwQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05-12-2011 12:28, HoP wrote:

>> And here is a new hack.
>
> I'm really tired from all those "hack, crap, pigback ..." wordings.
>
> What exactly vtuner aproach does so hackish (other then exposing
> DVB internals, what is every time made if virtualization support is developing)?
>
> The code itself no need to patch any line of vanilla kernel source, it even
> doesn't change any processing of the rest of kernel, it is very simple
> driver/code/whatever.
>
> I can understand that some developers don't like to get dvb-core opened,
> I don't agree with them, but I don't really need to fight with them.
> Its theirs opinion.
> But even I try to see what is so hackish in vtuner implementation, I don't catch
> anything. Simplicity? I thought that simplicity is a big advanatge (simple code,
> easy to analyze). What else?

You solution is called a hack becaus it is used to fool applications to think that a
remote device is actually a local device. Being it at kernelspace or at userspace
(with CUSE, LD_PRELOADER of whatever other solution) doesn't change this fact.

As applications know nothing about it, they'll still use timeouts and other coding logic
that fits well for a locally-accessible device, but that won't fit well for a remote
connection. You should remind that, by remote, this could mean a cross-ethernet
connection dedicated to it or a 20,000 Km far away machine, using satellite links.

When you put someone via the network, issues like latency,  package drops, IP
congestion, QoS issues, cryptography, tunneling, etc should be taken into account
by the application, in order to properly address the network issues.

Those network-specific issues affect applications badly, if they're not prepared to
handle with that, and if the used protocol is not adequate. It is not for a reason that
there are lots of different protocols designed for streaming broadcast, and a lot of
money is spent on improving it.

Can you warrant that 100% of DVB applications you claimed to support will work well
if a high latency network with a few satellite links is used, even if it has enough
bandwidth)? If you think so, a typical satellite latency is 240 ms per link, in
the best case [1]. A round trip takes twice this time.

So, a 10 GB connection with just one satellite link would mean about 480 ms of round trip.
I doubt that scan or w_scan would support it. Even if it supports, that would mean that,
for each ioctl that would be sent to the remote server, the error code would take 480 ms
to return. Try to calculate how many time w_scan would work with that. The calculus is easy:
see how many ioctl's are called by each frequency and multiply by the number of frequencies
that it would be seek. You should then add the delay introduced over streaming the data
from the demux, using the same calculus. This is the additional time over a local w_scan.

A grouch calculus with scandvb: to tune into a single DVB-C frequency, it used 45 ioctls.
Each taking 480 ms round trip would mean an extra delay of 21.6 seconds. There are 155
possible frequencies here. So, imagining that scan could deal with 21.6 seconds of delay
for each channel (with it doesn't), the extra delay added by it is 1 hour (45 * 0.48 * 155).

On the other hand, a solution like the one described by Florian would introduce a delay of
480 ms for the entire scan to happen, as only one data packet would be needed to send a
scan request, and one one stream of packets traveling at 10GB/s would bring the answer
back.

Note: even links without satellite may suffer high delays. The delay introduced by an USB
modem for a 3G data connection is probably high enough to cause applications like w_scan
to fail.

Your approach for sure works on your network scenario, but it is a very sensitive to network
issues, as applications have no idea about the network connection, and would do the wrong
thing when a network error occurs.

What I'm saying you is that the proper way to address it is to create a library that would
abstract the DVB operations (scan, tuning, filtering, ...) into a way that it could
be called either locally or remotely. Then, work with userspace developers to support it.

As I said before, all network-based audio/video stream solutions work this way. They don't
try to hide themselves by emulating a local device, as this don't work in a general case.

If you succeed to create a clean, properly written DVB library that would work fine for
remote devices, I'm sure you will be able to convince most application maintainers to use it.

Regards,
Mauro

[1] http://www.satsig.net/latency.htm

>
> Honza

