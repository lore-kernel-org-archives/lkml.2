Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab1CJSbL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 13:31:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020Ab1CJSbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 13:31:09 -0500
Message-ID: <4D7918E5.4090104@redhat.com>
Date: Thu, 10 Mar 2011 15:31:01 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Sucky dependencies found in video saa7134 rc
References: <1299778653.15854.370.camel@gandalf.stny.rr.com>
In-Reply-To: <1299778653.15854.370.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 10-03-2011 14:37, Steven Rostedt escreveu:
> Running randconfigs with ktest seems to find this crap all over. It's
> not just saa7134, it happens else where too, but this is the one that
> I'm currently looking at.
> 
> I'm also not blaming the saa7134 driver, but I think we need to find a
> way to fix Kconfig to handle this. Maybe it is in the works. I don't
> know.
> 
> Here's the issue:
> 
> 1) in the Makefile in drivers/media/video/saa7134/ we have:
> 
> aa7134-y :=	saa7134-cards.o saa7134-core.o saa7134-i2c.o
> saa7134-y +=	saa7134-ts.o saa7134-tvaudio.o saa7134-vbi.o
> saa7134-y +=	saa7134-video.o
> saa7134-$(CONFIG_VIDEO_SAA7134_RC) += saa7134-input.o
> 
> 2) in the Kconfig of that directory:
> 
> config VIDEO_SAA7134_RC
> 	bool "Philips SAA7134 Remote Controller support"
> 	depends on RC_CORE
> 	depends on VIDEO_SAA7134
> 	default y
> 
> 3) in the Makefile of drivers/media/rc
> 
> obj-$(CONFIG_RC_CORE) += rc-core.o
> 
> 4) in the Kconfig of that directory:
> 
> menuconfig RC_CORE
> 	tristate "Remote Controller adapters"
> 	depends on INPUT
> 	default INPUT
> 
> And finally in the .config produced by randconfig:
> 
> CONFIG_RC_CORE=m
> CONFIG_VIDEO_SAA7134=y
> CONFIG_VIDEO_SAA7134_RC=y
> 
> Thus, RC_CORE is a module and the SAA7134 input file is built in, which
> gives me the following error:
> 
> drivers/built-in.o: In function `saa7134_input_init1':
> /home/rostedt/work/autotest/nobackup/linux-test.git/drivers/media/video/saa7134/saa7134-input.c:737: undefined reference to `rc_allocate_device'
> /home/rostedt/work/autotest/nobackup/linux-test.git/drivers/media/video/saa7134/saa7134-input.c:780: undefined reference to `rc_register_device'
> /home/rostedt/work/autotest/nobackup/linux-test.git/drivers/media/video/saa7134/saa7134-input.c:787: undefined reference to `rc_free_device'
> drivers/built-in.o: In function `saa7134_input_fini':
> /home/rostedt/work/autotest/nobackup/linux-test.git/drivers/media/video/saa7134/saa7134-input.c:799: undefined reference to `rc_unregister_device'
> drivers/built-in.o: In function `ir_raw_decode_timer_end':
> /home/rostedt/work/autotest/nobackup/linux-test.git/drivers/media/video/saa7134/saa7134-input.c:400: undefined reference to `ir_raw_event_handle'
> drivers/built-in.o: In function `build_key':
> /home/rostedt/work/autotest/nobackup/linux-test.git/drivers/media/video/saa7134/saa7134-input.c:93: undefined reference to `rc_keydown_notimeout'
> /home/rostedt/work/autotest/nobackup/linux-test.git/drivers/media/video/saa7134/saa7134-input.c:101: undefined reference to `rc_keydown_notimeout'
> /home/rostedt/work/autotest/nobackup/linux-test.git/drivers/media/video/saa7134/saa7134-input.c:102: undefined reference to `rc_keyup'
> drivers/built-in.o: In function `saa7134_raw_decode_irq':
> /home/rostedt/work/autotest/nobackup/linux-test.git/drivers/media/video/saa7134/saa7134-input.c:920: undefined reference to `ir_raw_event_store_edge'
> make[1]: *** [.tmp_vmlinux1] Error 1
> 
> I know this is just a randconfig and I doubt that people will actually
> run into this problem, but randconfig should always produce a kernel
> that can compile, and preferably boot ;)
> 
> I think the issue here is that we should never allowed that SAA7134_RC
> be set to 'y' when RC_CORE is 'm'. I need to look at the kconfig code
> and see if there's a way to prevent that 'y' if its dependencies have
> 'm'.
> 
> Hmm, but that may not work either :( This may be a Makefile issue, as
> that 'y' is not really a builtin to the kernel but a builtin to a module
> that may or may not be built into the kernel. Which makes this
> dependency agnostic to the Kconfigs. God what a horrible tangled web we
> weave!

One solution would be to convert CONFIG_VIDEO_SAA7134_RC into a module,
and change its Kconfig item to tri-state. This way, everything should work
properly.

It is not that hard to convert it to be a module. Like the approach it
was taken for saa7134-alsa and saa7134-dvb, but this would require to move
the IR init code from saa7134 into saa7134-rc, as the -rc module will be
initialized late, and asynchronous.

Unfortunately, I don't have any time soon for doing that. Perhaps an easier
way would be to disable CONFIG_VIDEO_SAA7134_RC if RC_CORE=m and SAA7134=y.

Cheers,
Mauro
