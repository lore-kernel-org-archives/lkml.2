Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022Ab2DJTjv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 15:39:51 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:35128 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626Ab2DJTjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 15:39:49 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4F848C7C.5040703@cam.ac.uk>
Date: Tue, 10 Apr 2012 20:39:40 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120314 Thunderbird/11.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, mingo@elte.hu,
        linux-kernel@vger.kernel.org, Jonathan Cameron <jic23@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: Re: [PATCH RESEND] x86, intel_mid: ADC management
References: <20120410131930.28186.85370.stgit@bob.linux.org.uk> <20120410131206.GB31551@sirena.org.uk> <20120410142501.6045c6c0@pyramind.ukuu.org.uk> <20120410133339.GK7499@opensource.wolfsonmicro.com> <20120410144235.1e05efd4@pyramind.ukuu.org.uk> <20120410140749.GL7499@opensource.wolfsonmicro.com> <20120410151529.5bcc5ce6@pyramind.ukuu.org.uk> <20120410151943.GM7499@opensource.wolfsonmicro.com> <20120410175632.5c11c36e@pyramind.ukuu.org.uk> <20120410175846.GQ7499@opensource.wolfsonmicro.com>
In-Reply-To: <20120410175846.GQ7499@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.4
X-Enigmail-Draft-Status: 513
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 04/10/2012 06:58 PM, Mark Brown wrote:
> On Tue, Apr 10, 2012 at 05:56:32PM +0100, Alan Cox wrote:
>>>> We can't go around blocking entire platforms because of the
>>>> IIO blob. I raised this point with the whole previous
>>>> *generation* of Intel SoC devices about IIO and nothing has
>>>> been done about it.
> 
>>> Including by Intel, of course.
> 
>> Given the responses I got to moving it out of staging were of the
>> "not yet" and "no" variety it hardly got a request to be worked
>> upon.
> 
> The "not yet" bit of it certainly seems like something that could
> be worked on, presumably "not yet" included a "we need to do X
> first" element.
> 
Entirely possibly I gave my usual evasive set of a few things that
were top of the pile to knock over!  I've been promising a 'state of
iio email' for a while now. Sorry about that.

I was anxious to not move anything out of staging that we 'knew' needed
a major refactoring.  There is one more such refactoring going through
revisions at the moment. (Push in kernel interfaces to allow for
interrupt driven users such as a client iio driver that pushes data to
input).  Last attempt to move out of staging unfortunately fell foul of
some issues Greg KH raised in a review (correctly!)  These were with the
interfaces for requesting in kernel access to IIO device channels and we
really needed to get that right so I pulled back from sending a pull
request to Linus.  Since then time has been tight on my side. Some
others have been very helpful in picking up the slack.

Anyhow to repeat my whats left comments.

1)  Review of code.  This is crucial. If people have a little time
ripping holes in the core IIO code is what we need.  Arnd did a good job
of this a while back. Others have done bits of it since.

2) Getting the push code tidied up and pushed out.  I'll post it as an
updated rfc to linux-iio shortly.  All I had left that definitely
wanted doing here was cleaning up the example iio to input bridge
driver.  That can happen later.

Other bits that are less than ideal.

* Event passing to consumers else where in the kernel. Right now an
input driver can readings from a sensor, but there is no way of
requesting threshold interrupts.

* Interaction between consumer drivers (e.g. hwmon or input) where some
are requesting data by polling when they want it and others want a
stream of data driven by interrupts. I can give details of one
approach to this to anyone interested but it's basically a simply one
element buffer and some changes to channel requesting (entirely in the
IIO core
- - external drivers will just see requests that would previously be
refused start working).

>>> That's not where the rest of the embedded community has been
>>> coming from on this stuff and from a deployment point of view
>>> staging isn't really that big a blocker to users
> 
>> Non-staging code cannot depend upon staging code. That is the
>> rule GregKH laid down. The Intel drivers involved are established
>> non staging drivers and the gpadc layer is basically cleaning up
>> the fact they all do this themselves in private right now without
>> any central co-ordination or abstraction.
> 
> So, that's a bit different and not at all obvious from your e-mail
> - the diffstat shows only the code you're adding, not the code
> you've factored out of the existing mainline drivers.  The diffstat
> you posted was:
> 
> | arch/x86/include/asm/intel_mid_gpadc.h   |   13 + |
> arch/x86/platform/mrst/Makefile          |    1 |
> arch/x86/platform/mrst/intel_mid_gpadc.c |  645
> ++++++++++++++++++++++++++++++ | arch/x86/platform/mrst/mrst.c
> |    6 | 4 files changed, 665 insertions(+), 0 deletions(-)
> 
> which is a pure addition of code and I'm not seeing anything in
> the changelog about this either.
> 
>>> Frankly at this point I don't understand why we can't just lift
>>> IIO out of staging as-is, perhaps with the userspace ABI
>>> nobbled or moved into debugfs for the time being if that's
>>> still a concern.  Alternatively there is the option of you
>>> proposing some other generic framework.
> 
>> I've been saying this for over a year. It's still a huge blob of
>> code
> 
> I've CCed in Greg and Jonathan here - guys, what is happening with 
> getting IIO out of staging?  It's been there since 2009 and from
> an outside point of view it's really difficult to see progress
> here, the time taken to merge the subsystem seems really long.
Agreed :(

> 
> To me it really feels like the subsystem is pretty mature at this
> point and that if anything staging is blocking things rather than
> helping them, the subsystem feels like it's getting normal
> development rather than work to integrate it into the rest of the
> kernel and being in staging is discouraging users who don't
> absolutely need to use it.
> 
> For example, when we get extcon (or whatever it ends up being
> called) merged we'll either have to start writing a raft of auxadc
> specific drivers for it or we'll have to come up with *some* kind
> of subsystem to use to abstract out the standard DC measurement
> pattern.
> 
> If the code was moved out of staging today what would go wrong?
Churn in interfaces is probably about it.  Maybe a good use of any time
would be for people to take their non IIO drivers that they think might
fit (or data sheets!) and see whether there are things that they would
like to be different.

An initial move would just take (possibly with some file name tidying up!)

industrialio-core.c -> core.c
industrialio-trigger.c -> trigger.c
industrialio-event.c -> event.c
inkern.c -> inkern.c
kfifo-buf.c  -> buffer_kfifo.c

iio.h
buffer.h
driver.h
machine.h
consumer.h
trigger.h
trigger_consumer.h
types.h
iio_core.h
kfifo_buf.h
sysfs.h (stripped of a few legacy bits at the end that can go into a
sysfs-staging.h until the users are all cleaned up).

Some name stripping etc needed and a wholesale switch of headers.

Doing it this way would be a lot less painful than the build up approach
we suggested last time, but more controversial as this is large complex
code drop (to anyone who hasn't followed it in staging).

> 
>> that isn't needed for pure low level stuff, but that's fixable
>> and something which can eventually be worked upon.
> 
> We do have to be careful about this sort of "this is a little bit
> of low level code" thing - it (along with "our hardware is unique")
> comes up rather a lot and it's often missing a good chunk of the
> picture.
> 
>> You are trying to make the tail wag the dog. Staging is basically
>> out of
> 
> You keep saying "you" here.  To repeat once more, this is pretty
> much what the general embedded community has been pushing towards,
> this is not particularly my personal opinion.
> 
>> kernel. The x86 stuff is *in kernel*, this driver is the basis
>> of cleaning it up. We can sort out making it talk to IIO later.
>> Right now all you are doing is blocking a pile of much needed
>> code cleanups, and without them you *won't* have an API for the
>> gpadc on Intel, it'll be hardcoded in each driver still. That
>> will mean you have *zero* change of getting IIO support at all.
> 
> Like I said above you'd not posted the patches which factor the
> code out of the existing users, if that's what you're trying to do
> that's a bit different to what your patch looked like.
> 
>> Whether gpadc then adopts an IIO interface is a question to ask
>> later, after (if) IIO is ever merged. If the platform ever starts
>> using gpadc for non internal hardware stuff then I'm pretty sure
>> it'll end up adopting whatever generic GPADC layer eventually
>> emerges simply because we'll want to share drivers.
> 
> Again, this is the sort of thing that SoC vendors routinely say
> but don't end up doing quite so routinely as one would hope.  This
> is understandable as this sort of thing is more of a problem for
> people working in off-SoC devices and system integration than the
> SoC vendors themselves.

The 'fun' bit for most IIO developers is that we weren't originally
interested in SoCs at all.  The support we've added for in kernel
users of IIO has all come out of Mark and other's comments on how
it would be useful to them.  It's been interesting and there have
been considerable gains for our other usecases, but it has take time
to do.

Anyhow, if people have spare cycles, then as ever review time is what
we need, even better if people are willing to dive in and propose
fixes to stuff they don't like.

Now that was probably mostly irrelevant to the majority of the
the thread :)

Jonathan
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPhIw4AAoJEFSFNJnE9BaIEmAP/2l/Ks11td0SGyU1uDz394V3
PuTPtzAxtGpHPApxafHnN7ci270N2YloSGefP3qZ5bcMwbj8XBOw4VQ8M2rWuSWa
xghMmc1IxfYa4BsazsvEEtlU1QZq6DTjrh51azXv6sgiJcFOttPCnIAxpJnnEQXG
EVb7guUnQhzzgNCAA11up2DHohvB4CGig/jx5d7JO2puhSw483+qEzY71bW0T6FA
NNXZF8zTsppcMg/YKYheCyJ2ihDUQXrhMUDc14Pz3UHiSx9q2sGrygOOnPNBoP5r
HTRe3sKCpEQrPjavX3f6l0BHGd4EW4UHwQ+ZELY2SYiXqcltleuw3EjGMQA9j/6z
p2opkGXMI2Zw7oI4C4XZ6ivpFQxUjpeAnNGhGHNDVQWUuXDsNmc/z6yYwW8CN1sn
BgAueu9hdoxQF7AoQyQ9cl6PC93aUvAkzf5TbNAfP+8Rsboo6xqxKAJGq2ddFkad
KA5Zpxe5VbalmNlMUeNmad6A1KSJe1XfPv+L1heAL+dE+w18pFUmaN8HYghDSOYV
IUqxGJ2VjEA+irYndYv+qjWfojpv8xrUc2WSJaYjclAWEm+CmTHTblzro5oDZE+C
tZjYGz1LobGSIO13hQqW3d1QrIDIt3Vx7Z6iROBSPbll44PaDPXV3DVZh8YiLn97
eLxK5n3x0jNJwVt8ACbO
=AbrL
-----END PGP SIGNATURE-----
