Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932492Ab1AKWrY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 17:47:24 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:52695 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756357Ab1AKWrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 17:47:22 -0500
Date: Tue, 11 Jan 2011 23:48:09 +0100
From: Borislav Petkov <bp@amd64.org>
To: Mike Waychison <mikew@google.com>
Cc: "mingo@elte.hu" <mingo@elte.hu>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Duncan Laurie <dlaurie@google.com>
Subject: Re: [PATCH] x86: Add an option to disable decoding of MCE
Message-ID: <20110111224809.GA20839@aftab>
References: <43835.148.87.67.136.1294700112.squirrel@xenotime.net>
 <1294700597-24239-1-git-send-email-mikew@google.com>
 <20110111065540.GA16036@aftab>
 <AANLkTimXfUH-PYpdRcLR4+QkG7uOzYzSC6VZ6HnkB9jE@mail.gmail.com>
 <20110111204909.GE17619@aftab>
 <AANLkTimQNnxnoFPWjh6cHp_x9ZayDdcXdV+qbee8XK_r@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimQNnxnoFPWjh6cHp_x9ZayDdcXdV+qbee8XK_r@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 04:51:57PM -0500, Mike Waychison wrote:
> On Tue, Jan 11, 2011 at 12:49 PM, Borislav Petkov <bp@amd64.org> wrote:
> > Ok, let me preface this with an even easier suggestion: Can you simply
> > not compile EDAC (which includes CONFIG_EDAC_DECODE_MCE) in your kernels
> > and the whole issue with decoding disappears simply because no module
> > registers as a decoder...?
> 
> The trouble here is that default_decode_mce() is still getting called
> no matter what :(  It didn't really cause problems until you added
> atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, &m) to
> machine_check_poll().

Yeah, I figured as much... after hitting send :(. Feel free to add my

Acked-by: Borislav Petkov <borislav.petkov@amd.com>

to your patch.

> > Right, and this means that you need to know all the memory controller
> > topologies of all the different architectures and also the SPD accessing
> > based on a board type could be a pain. One of the main reasons for
> > fleshing out MCE decoding in the kernel was to avoid needless trouble
> > like that.
> 
> It's not that painful for us.  Our firmware guys own this userland
> code :)  I can see it being a pain for others however.

Yeah, what we actually need is a chipset-agnostic way (ACPI maybe?)
of mapping chip selects to the actual DIMMs so all that above can be
avoided...

> Doing this all in userland does have it's upsides as well fwiw. For
> example, MC4 is usually kept around across a reset, which means
> that the firmware can pick it up when the system goes down due to a
> processor context corruption.

True, although not always reliable due to that context corruption. Tony
Luck is adding code for writing the error information to a persistent
storage _before_ you reset so on platforms with such a device you'll
be able to look at MC4 (or any of the MCE regs, for that matter) after
reset, which, I think, would make error analysis much more convenient.
See http://marc.info/?l=linux-arch&m=129356804427008&w=2.

> We rely on these libraries as well to decode egregious uncorrectable
> memory errors as well as bus errors (like hypertransport sync floods).

Yeah, I don't think error decoding would help, at least on AMD, with
uncorrectable errors causing syncflood. We might do something about it
though :).

> > I've
> > heard similar troubles reported by other big server farm people and
> > what I'm currently working on is a RAS daemon that hooks into perf thus
> > enabling persistent performance events. This way, you could open a
> > debugfs file (this'll move to sysfs someday) and read the same decoded
> > data by mmaping the perf ringbuffer.
> 
> I'll definitely keep an eye out for your developments with RAS :)

Cool, I think I have the bulk of your requirements now, from your and
Duncan's mails. I'm always open for other suggestions too.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
