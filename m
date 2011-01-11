Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab1AKUs2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 15:48:28 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:41994 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab1AKUsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 15:48:23 -0500
Date: Tue, 11 Jan 2011 21:49:09 +0100
From: Borislav Petkov <bp@amd64.org>
To: Mike Waychison <mikew@google.com>
Cc: "mingo@elte.hu" <mingo@elte.hu>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Duncan Laurie <dlaurie@google.com>
Subject: Re: [PATCH] x86: Add an option to disable decoding of MCE
Message-ID: <20110111204909.GE17619@aftab>
References: <43835.148.87.67.136.1294700112.squirrel@xenotime.net>
 <1294700597-24239-1-git-send-email-mikew@google.com>
 <20110111065540.GA16036@aftab>
 <AANLkTimXfUH-PYpdRcLR4+QkG7uOzYzSC6VZ6HnkB9jE@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimXfUH-PYpdRcLR4+QkG7uOzYzSC6VZ6HnkB9jE@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, let me preface this with an even easier suggestion: Can you simply
not compile EDAC (which includes CONFIG_EDAC_DECODE_MCE) in your kernels
and the whole issue with decoding disappears simply because no module
registers as a decoder...?

On Tue, Jan 11, 2011 at 02:56:50PM -0500, Mike Waychison wrote:
> >> On our systems, we do not want to have any "decoders" called on machine
> >> check events.  These decoders can easily spam our logs and cause space
> >> problems on machines that have a lot of correctable error events.  We
> >> _do_ however want to get the messages delivered via /dev/mcelog for
> >> userland processing.
> >
> > Ok, question: how do you guys process DRAM ECCs? And more specifically,
> > with a large number of machines, how do you do the mapping from the DRAM
> > ECC error address reported by MCA to a DIMM that's failing in userspace
> > on a particular machine?
> 
> We process machine checks in userland, using carnal knowledge of the
> memory controller and the board specific addressing of the SPDs on the
> various i2c busses to deswizzle and make sense of the addresses and
> symptoms.  We then expose this digested data on the network, which is
> dealt with at the cluster level.

Right, and this means that you need to know all the memory controller
topologies of all the different architectures and also the SPD accessing
based on a board type could be a pain. One of the main reasons for
fleshing out MCE decoding in the kernel was to avoid needless trouble
like that.

> > Also, I've worked on trimming down all that decoding output to 3-5
> > lines. Now it looks like this:
> >
> > [  521.677316] [Hardware Error]: MC4_STATUS[Over|UE|MiscV|PCC|AddrV|UECC]: 0xfe00200000080a0f
> > [  521.686467] [Hardware Error]: Northbridge Error (node 0): DRAM ECC error detected on the NB.
> > [  521.686498] EDAC MC0: UE page 0x0, offset 0x0, grain 0, row 0, labels ":": amd64_edac
> > [  521.686501] EDAC MC0: UE - no information available: UE bit is set
> > [  521.686503] [Hardware Error]: cache level: L3/GEN, mem/io: GEN, mem-tx: GEN, part-proc: RES (no timeout)
> >
> > and the two lines starting with "EDAC MC0" will get trimmed even
> > more with time. I'm assuming this is not a lot but if you get a lot
> > of correctable error events, then output like that accumulates over
> > time.
> 
> This decoded information is great, but it's only really consumable by
> a human.  We'd _much_ rather have structured data that we know isn't
> as volatile (in terms of regexes that break with development churn)
> nor susceptible to corruption (as the logs are not transactional and
> are shared by all CPUs concurrently).   For the most part, we rarely
> rely on the anything automated consuming kernel printk logs, and the
> bits that do are there only for historical reasons (read: we haven't
> figured out how to replace them yet).  With almost every single kernel
> version bump we've had, we've found numerous places where strings in
> the logs have subtly changed, breaking our infrastructure :(  Finding
> these is a painful process and often shows up late in the deployment
> process.  This is disastrous to our deployment schedules as rebooting
> our number of machines, well, it takes a while...

I know exactly what you mean, maybe I should say that the error format
is continuously changing because development is still ongoing. But
also, I don't think that parsing dmesg is the correct approach; I've
heard similar troubles reported by other big server farm people and
what I'm currently working on is a RAS daemon that hooks into perf thus
enabling persistent performance events. This way, you could open a
debugfs file (this'll move to sysfs someday) and read the same decoded
data by mmaping the perf ringbuffer.

This is still in an alpha stage, though, but once we have something
working we could freeze the exported format (think stable tracepoints)
so that you can plug your tools into it and forget all dmesg
parsing. Here's a link to give you an impression of what I mean:
http://lwn.net/Articles/413260/

This is -v3 and I'm currently working on -v4 which should be better.

> I'm sorry if this is tangential to your comment above, but I feel the
> need to have folks recognize that printk() is _not_ a good foundation
> on which to build automation.

Agreed.

> As for using EDAC, I know we tried using it a few years ago, but have
> since reverted to processing MCE ourselves.  I don't know all the
> details as to why, however Duncan Laurie might be able to share more
> (CCed).

It should be in much better shape now :).

> > How about an error thresholding scheme in software then which
> > accumulates the error events and reports only when some configurable
> > thresholds per DRAM device in error have been reached?
> 
> This is pretty much the opposite of what we'd want.   We have no use
> for anything printed in the logs, though emitting these messages
> wouldn't be a problem except for those machines which very frequently
> have MCA events to report.  On those machines, the chatter in the logs
> can potentially wedge our root filesystem (which is tiny) and has the
> downside that it forces logs to rotate quickly (which means there is
> less useful data for a human to consume when analyzing what happened
> on the host).  Our policy has been to neuter bits of the kernel that
> don't know when to stfu :)

Ok, see above. I think with the RAS daemon you could easily make
it even send _decoded_ error records over the network to a central
collecting machine instead of parsing the logs. Then you can simplify
your userspace post-processing too.

[..]

> > Also, there's another hook in the function above that does
> > edac_mce_parse(mce) (which shouldnt've been there actually) which is
> > used by the Nehalem driver i7core_edac which does also decode DRAM ECCs.
> 
> What should we do with this guy?  I'd be happy to send a patch in, but
> as I mentioned above, we don't use EDAC at all (which is probably why
> I didn't notice this guy).

I think this is also easy disabled by not configuring EDAC, as I said
above. Basically, if you don't enable EDAC, you can drop that patch
too and run your kernels without any modification, or am I missing
something..?

Thoughts?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
