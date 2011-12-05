Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480Ab1LEUls (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 15:41:48 -0500
Received: from ffm.saftware.de ([83.141.3.46]:56091 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932121Ab1LEUlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 15:41:47 -0500
Message-ID: <4EDD2C82.7040804@linuxtv.org>
Date: Mon, 05 Dec 2011 21:41:38 +0100
From: Andreas Oberritter <obi@linuxtv.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: HoP <jpetrous@gmail.com>, Florian Fainelli <f.fainelli@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver because
 of worrying about possible misusage?
References: <CAJbz7-2T33c+2uTciEEnzRTaHF7yMW9aYKNiiLniH8dPUYKw_w@mail.gmail.com> <4ED6C5B8.8040803@linuxtv.org> <4ED75F53.30709@redhat.com> <CAJbz7-0td1FaDkuAkSGQRdgG5pkxjYMUGLDi0Y5BrBF2=6aVCw@mail.gmail.com> <20111202231909.1ca311e2@lxorguk.ukuu.org.uk> <CAJbz7-0Xnd30nJsb7SfT+j6uki+6PJpD77DY4zARgh_29Z=-+g@mail.gmail.com> <4EDC9B17.2080701@gmail.com> <CAJbz7-2maWS6mx9WHUWLiW8gC-2PxLD3nc-3y7o9hMtYxN6ZwQ@mail.gmail.com> <4EDD01BA.40208@redhat.com>
In-Reply-To: <4EDD01BA.40208@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.12.2011 18:39, Mauro Carvalho Chehab wrote:
> On 05-12-2011 12:28, HoP wrote:
> 
>>> And here is a new hack.
>>
>> I'm really tired from all those "hack, crap, pigback ..." wordings.
>>
>> What exactly vtuner aproach does so hackish (other then exposing
>> DVB internals, what is every time made if virtualization support is
>> developing)?
>>
>> The code itself no need to patch any line of vanilla kernel source, it
>> even
>> doesn't change any processing of the rest of kernel, it is very simple
>> driver/code/whatever.
>>
>> I can understand that some developers don't like to get dvb-core opened,
>> I don't agree with them, but I don't really need to fight with them.
>> Its theirs opinion.
>> But even I try to see what is so hackish in vtuner implementation, I
>> don't catch
>> anything. Simplicity? I thought that simplicity is a big advanatge
>> (simple code,
>> easy to analyze). What else?
> 
> You solution is called a hack becaus it is used to fool applications to
> think that a
> remote device is actually a local device. Being it at kernelspace or at
> userspace
> (with CUSE, LD_PRELOADER of whatever other solution) doesn't change this
> fact.
> 
> As applications know nothing about it, they'll still use timeouts and
> other coding logic
> that fits well for a locally-accessible device, but that won't fit well
> for a remote
> connection.

See (*) below.

> You should remind that, by remote, this could mean a
> cross-ethernet
> connection dedicated to it or a 20,000 Km far away machine, using
> satellite links.
> 
> When you put someone via the network, issues like latency,  package
> drops, IP
> congestion, QoS issues, cryptography, tunneling, etc should be taken
> into account
> by the application, in order to properly address the network issues.

Are you serious? Lower networking layers should be transparent to the
upper layers. You don't implement VPN or say TCP in all of your
applications, do you? These are just some more made-up arguments which
don't have anything to do with the use cases I explained earlier.

> Those network-specific issues affect applications badly, if they're not
> prepared to
> handle with that, and if the used protocol is not adequate. It is not
> for a reason that
> there are lots of different protocols designed for streaming broadcast,
> and a lot of
> money is spent on improving it.

(*) DVB isn't local either. It's using broadcast media after all. It's
designed to cope with packet loss and includes relative decoding and
presentation time stamps in its media payloads. Although DVB specifies
some minimal repetition rates for repeatedly sent data, real life
applications need to handle much lower repetition rates anyway (i.e.
higher timeouts), in order to cope with individual settings of
broadcasters trying to save some bandwidth in their multiplexes. Real
life applications also need to handle high timeouts due to possible
packet loss, especially in satellite and terrestrial networks.

However, the TS transport between the client and server components may
very well use one of the protocols you're referring to, yes.

> Can you warrant that 100% of DVB applications you claimed to support
> will work well
> if a high latency network with a few satellite links is used, even if it
> has enough
> bandwidth)? If you think so, a typical satellite latency is 240 ms per
> link, in
> the best case [1]. A round trip takes twice this time.
> 
> So, a 10 GB connection with just one satellite link would mean about 480
> ms of round trip.

Again, are you serious? Virtually all users I expect will use their
local network and you're using a satellite link as an example to explain
why you think it's going to suck for everybody? I don't know anybody
who's voluntarily using a satellite link for his internet connection.
Roundtrip time in my LAN is about 0.25 ms, which is 1/1920th of your
"typical" example.

I also don't understand how your 10 GB (sic!) of bandwidth come into
play, if only few MBit/s are required to transfer a DVB video service
(or few KBit/s for audio or data). You're suggesting high bandwidth
usage to uninformed readers, where maybe only few bytes are to be
transferred.

You're suggesting that this project is still a theory, but it's already
there and it's already in use by many people, who are happy with it. So
latency can't be such a big problem as you're trying to point out.

Regarding increased latency for ioctls: The Linux DVB API doesn't
specifiy any time frames within which ioctls must return. Most ioctls
are known to block, the few others handle non-blocking mode. Adding some
ms delay for the network transfer really is no problem at all.

Regarding the asynchronous nature of networking: USB transfers are
asynchronous too, but USB tuners work well using in-kernel drivers. The
usbip even combines both asynchronous worlds. Oh wait, usbip already
resides in staging. How come?

[stripped off-topic latency calculations for satellite IP networks]

> On the other hand, a solution like the one described by Florian would
> introduce a delay of
> 480 ms for the entire scan to happen, as only one data packet would be
> needed to send a
> scan request, and one one stream of packets traveling at 10GB/s would
> bring the answer
> back.

What you didn't take into account: Whatever you'll try to do
interactively over a satellite link (or even over most 3G connections),
it sucks. Florian's solution won't be an exemption, no matter how it's
implemented.

Have you ever tried SSH over a satellite link? It sucks. Does SSH suck
because of that? Rather not.

> Note: even links without satellite may suffer high delays. The delay
> introduced by an USB
> modem for a 3G data connection is probably high enough to cause
> applications like w_scan
> to fail.
> 
> Your approach for sure works on your network scenario, but it is a very
> sensitive to network
> issues, as applications have no idea about the network connection, and
> would do the wrong
> thing when a network error occurs.

There's no difference between network errors in this case and USB
errors/disconnects in the case of USB tuners.

> What I'm saying you is that the proper way to address it is to create a
> library that would
> abstract the DVB operations (scan, tuning, filtering, ...) into a way
> that it could
> be called either locally or remotely. Then, work with userspace
> developers to support it.
> 
> As I said before, all network-based audio/video stream solutions work
> this way. They don't
> try to hide themselves by emulating a local device, as this don't work
> in a general case.
> 
> If you succeed to create a clean, properly written DVB library that
> would work fine for
> remote devices, I'm sure you will be able to convince most application
> maintainers to use it.

Unfortunately, you still wouldn't have solved the issue vtunerc is
trying to solve, if you built such a library and included it in szap et al.

Regards,
Andreas
