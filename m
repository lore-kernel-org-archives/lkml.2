Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676Ab1LCRin (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 12:38:43 -0500
Received: from ffm.saftware.de ([83.141.3.46]:38220 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753329Ab1LCRil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 12:38:41 -0500
Message-ID: <4EDA5E98.4080205@linuxtv.org>
Date: Sat, 03 Dec 2011 18:38:32 +0100
From: Andreas Oberritter <obi@linuxtv.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: HoP <jpetrous@gmail.com>, Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver because
 of worrying about possible misusage?
References: <CAJbz7-2T33c+2uTciEEnzRTaHF7yMW9aYKNiiLniH8dPUYKw_w@mail.gmail.com> <4ED6C5B8.8040803@linuxtv.org> <4ED75F53.30709@redhat.com> <CAJbz7-0td1FaDkuAkSGQRdgG5pkxjYMUGLDi0Y5BrBF2=6aVCw@mail.gmail.com> <20111202231909.1ca311e2@lxorguk.ukuu.org.uk> <4EDA4AB4.90303@linuxtv.org> <20111203164252.3a66d638@lxorguk.ukuu.org.uk>
In-Reply-To: <20111203164252.3a66d638@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03.12.2011 17:42, Alan Cox wrote:
>> FWIW, the virtual DVB device we're talking about doesn't have any
>> networking capabilities by itself. It only allows to create virtual DVB
>> adapters and to relay DVB API ioctls to userspace in a
>> transport-agnostic way.
> 
> Which you can do working from CUSE already, as has been pointed out or
> with LD_PRELOAD. This btw makes the proprietary thing seem a rather odd
> objection - they could do it too.

Yes, both CUSE and LD_PRELOADED have already been suggested. But I
already explained in previous mails why both options are unsuitable:

- For LD_PRELOAD to intercept any calls to open, ioctl, read, write, the
character device to be intercepted must exist first. But it doesn't
exist, unless it was created by vtuner first. Of course you could also
intercept stat(), readdir() and all other possible functions to list or
access devices and fake entries, but I hope you're not suggesting this
seriously. Well, proprietary drivers doing that already exist today
(e.g. by sundtek), but implementing somthing like that if an easier
solution is possible would be crazy at best.

Additionaly, preloaded libraries conflict with other preloaded libraries
overwriting the same functions. Preloaded libraries don't work with
statically linked programs. Preloaded libraries can't be used
transparently, because you need to edit init scripts to use them, unless
you want them to be used globally (in /etc/ld.so.preload).

- CUSE would conflict with dvb-core. Once CUSE created a DVB adapter,
registering another non-virtual DVB adapter (by plugging in a USB device
for example) will try to assign the same adapter number.

The following only applies to the original version of the interface, but
is likely to apply to future development of the proposed interface: In
order to add virtual tuners to existing DVB adapters, to be able to use
their hardware demux or MPEG decoders with CUSE, the whole device driver
of this adapter has to be implemented in userspace.

Regards,
Andreas
