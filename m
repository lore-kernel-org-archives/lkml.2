Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817Ab1E1Oky (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 10:40:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46795 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753550Ab1E1Oks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 10:40:48 -0400
Date: Sat, 28 May 2011 16:40:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        David Miller <davem@davemloft.net>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Fixes to the module.h splitup tree
Message-ID: <20110528144003.GC12059@elte.hu>
References: <20110520161210.81bbef3a.sfr@canb.auug.org.au>
 <BANLkTi=Dn_jvJ8mLY0Bc6C1Ptoqa-kJrCg@mail.gmail.com>
 <20110523090918.GA5474@elte.hu>
 <BANLkTi=_=wmzWm79RTVzw09VX-Feb6zpwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=_=wmzWm79RTVzw09VX-Feb6zpwA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -0.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.3 required=5.9 tests=BAYES_00,URIBL_BLACK autolearn=no SpamAssassin version=3.3.1
	1.7 URIBL_BLACK            Contains an URL listed in the URIBL blacklist
	[URIs: sednacomputer.com]
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Gortmaker <paul.gortmaker@windriver.com> wrote:

> On Mon, May 23, 2011 at 5:09 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> 
> [...]
> 
> >
> > A surprisingly large chunk are all the module.h details which brings in details
> > like large elf.h definitions - despite pid.c only relying on the module code
> > for the spurious use of EXPORT_SYMBOL primitives. Fixing this would cause no
> > runtime overhead AFAICS.
> 
> I started working on the above since it seemed like it would be an interesting
> puzzle to untangle - that is before I realized how involved it would be.  :)
> 
> It is do-able, but not as simple as it 1st might seem.  At the moment, if you
> touch linux/module.h and rebuild, the time is within one or two seconds of
> a fresh build - some 1670 compiles (for a typical x86-64 defconfig).  So
> module.h is pretty much 99% pervasive.  With my tree so far, the same
> touch builds close to 500 less files, is done in ~20% less time, and I've
> still many changes yet to make....
> 
> Things that become evident upon attacking this:
> 
> 1) Separating out the EXPORT_SYMBOL stuff just alone by itself largely
> does nothing, because there are ~35 files in include/* which will directly
> include linux/module.h regardless of whether your file wanted it or not.
> 
> 2) The biggest culprit is linux/device.h, since it finds its way into almost
> everything it seems.  One has to clean everything else up, and then
> rebase this type of change to last, so the tree remains bisectable.
> 
> 3) Dealing with #2 reveals that *lots* of drivers/files never even had a line
> for #include <linux/module.h> -- they were happy to have it implicitly
> appear via some unknown include chain and simply ride the wave.

Yeah, i'd suggest you start with a smart grep like Linus used in the 
prefetch discussion:

find files that use module APIs but do not include module.h. You can 
add module.h to them and then remove all spurious module.h inclusions 
from include/linux/ and build allyesconfig - this will show you the 
remaining places that manage to rely on module.h in some roundabout 
way your grep did not detect.

> 4) It isn't just the presence of module.h that people were 
> implicitly taking advantage of -- since module.h itself includes 
> 95% of the known world, I found files that were getting stat.h, 
> sched.h, even asm/*.h etc. via the implicit presence of module.h

Indeed :-/ It's 15 years of almost uncontrolled mess!

> 5) The combination of #3 and #4 makes for a lot of commits, as I'm 
> trying to keep them separated along subsystem/maintainer 
> boundaries.

Oh, i'd *definitely* suggest to not bother splitting this up along 
100+ maintainer trees! The point is that even if you conflict with 
them, header file conflicts are *trivial* to resolve.

So please, after an RFC posting, just find the time window where this 
should be done best, do it quickly, send it to Linus so he can pull 
it quickly - before anyone notices it's upstream and we can fix the 
fallout quickly as well ...

You have my acked-by to touch arch/x86/, scheduler, perf and locking 
bits as you wish to.

> Anyways, I just wanted to mention this was underway, but I don't 
> see it being 100% done in the small amount of time left in this 
> merge window.

I think the ideal place wouldnt even be the merge window, but the two 
weeks between -rc1 and -rc3. That is when there is the least number 
of commits 'in flight' in maintainer trees.

> The current tree is here if anyone wants to poke at it and comment 
> on it while I continue to plug away at the task.  x86, x86-64 and 
> powerpc-64 defconfigs have been tested to build OK.
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/paulg/linux-2.6.git
> module.h-split-May27
> 
> http://git.kernel.org/?p=linux/kernel/git/paulg/linux-2.6.git;a=shortlog;h=refs/heads/module.h-split-May27

Okay, so i test-pulled your module.h-split-May27 branch and it looks 
absolutely lovely!

Have you tried to measure how much practical effect this has on .i 
size of a file that currently needlessly includes modules.h (and half 
the world)?

[ a few minutes later ]

Ok, so you've used Linus's 98b98d316349 commit as a base tree. I have 
tested your base tree plus your module.h-split-May27 full tree, on 
x86 defconfig.

I have done two tests: a .i size test and a kernel build performance 
test.

The .i size test was a very simple extraction of all .i files from 
arch/x86/kernel/, which i used as a reference target build directory 
that has a good mix of module.h relevant and module.h irrelevant 
files: it has 178 .c files there, 71 of which now have module.h and 
107 do not have it.

I extracted all .i files on a fully built tree via a simple:

 ( for N in $(find arch/x86/kernel/ -name '*.o' | sed 's/.o$/.i/g'); do make $N; cat $N; done; ) > kernel.i

           base -git tree:  2841325 lines of preprocessed .c code
      module.h-split tree:  2783051 lines of preprocessed .c code

So there's a very significant 2.1% reduction of work for the compiler 
to do, very nice!

Then i tested what impact this has on kernel build speed, which i 
tested via this small script:

            make -j64 arch/x86/kernel/ >/dev/null 2>/dev/null
            find arch/x86/kernel/ -name '*.o' | xargs rm -f

[ Sidenote: this method of removing the .o's immediately after they 
  got built has the measurement advantage of making perf stat --sync 
  produce very stable and largely IO invariant numbers. ]

       $ perf stat --repeat 10 --sync -e task-clock ./build-x86 

       # Performance counter stats for './build-x86' (10 runs):


 | base -git tree:
 -------------------------
      35284.361328 task-clock                #   11.452 CPUs utilized            ( +-  0.11% )
      35240.124984 task-clock                #   11.431 CPUs utilized            ( +-  0.11% )

       3.081192522 seconds time elapsed                                          ( +-  0.42% )
       3.082811752 seconds time elapsed                                          ( +-  0.42% )

 | module.h-split tree:
 ----------------------
      34807.362189 task-clock                #   11.511 CPUs utilized            ( +-  0.06% )
      34792.156504 task-clock                #   11.511 CPUs utilized            ( +-  0.06% )

       3.023727829 seconds time elapsed                                          ( +-  0.68% )
       3.022577206 seconds time elapsed                                          ( +-  0.47% )

That's a 1.9% kernel build performance improvement (!) in terms of 
elapsed time and a 1.3% performance improvement in terms of CPU time 
used, the measured speedup is well above the noise of the 
measurements.

I also tested your tree with all[yes|no|mod]config[32|64], and a 
handful of randconfigs, and with the few fixes below [*] they all 
build just fine:

 Acked-by: Ingo Molnar <mingo@elte.hu>
 Tested-by: Ingo Molnar <mingo@elte.hu>

All in one, these results make me want your tree upstream like 
yesterday! :-)

Linus: if you'd like to be tempted with this module.h header 
dependency splitup then i could send you a pull request with Paul's 
stuff + fixes today, tested on x86 and cross-built to most other 
architectures. It is absolutely doable and low-risk.

Thanks,

	Ingo

[*] they were created in a brute-force fashion, to keep things simple

Subject: module.h splitup: Build fixes on x86 allno/allyes 32-bit/64-bit kernels
From: Ingo Molnar <mingo@elte.hu>
Date: Sat May 28 15:19:32 CEST 2011

Only module.h or stat.h additions.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/crypto/aesni-intel_glue.c                    |    1 +
 arch/x86/kernel/e820.c                                |    1 +
 arch/x86/kernel/pci-dma.c                             |    1 +
 arch/x86/kernel/rtc.c                                 |    1 +
 arch/x86/platform/mrst/vrtc.c                         |    1 +
 arch/x86/platform/uv/bios_uv.c                        |    4 +++-
 block/blk-integrity.c                                 |    1 +
 crypto/async_tx/raid6test.c                           |    1 +
 drivers/acpi/ec_sys.c                                 |    1 +
 drivers/acpi/sbshc.c                                  |    1 +
 drivers/base/dma-coherent.c                           |    1 +
 drivers/base/hypervisor.c                             |    2 ++
 drivers/base/power/runtime.c                          |    1 +
 drivers/bcma/main.c                                   |    1 +
 drivers/block/aoe/aoechr.c                            |    1 +
 drivers/block/virtio_blk.c                            |    1 +
 drivers/char/hw_random/virtio-rng.c                   |    1 +
 drivers/char/ttyprintk.c                              |    1 +
 drivers/char/virtio_console.c                         |    1 +
 drivers/dca/dca-core.c                                |    1 +
 drivers/dca/dca-sysfs.c                               |    1 +
 drivers/dma/intel_mid_dma.c                           |    1 +
 drivers/edac/mce_amd_inj.c                            |    1 +
 drivers/firewire/core-iso.c                           |    1 +
 drivers/firmware/google/gsmi.c                        |    1 +
 drivers/firmware/sigma.c                              |    1 +
 drivers/gpio/74x164.c                                 |    1 +
 drivers/gpio/mc33880.c                                |    1 +
 drivers/gpio/mcp23s08.c                               |    1 +
 drivers/gpio/ml_ioh_gpio.c                            |    1 +
 drivers/gpio/pcf857x.c                                |    1 +
 drivers/gpio/pch_gpio.c                               |    1 +
 drivers/gpu/drm/ttm/ttm_tt.c                          |    1 +
 drivers/hid/hid-axff.c                                |    1 +
 drivers/hid/hid-dr.c                                  |    1 +
 drivers/hid/hid-emsff.c                               |    1 +
 drivers/hid/hid-gaff.c                                |    1 +
 drivers/hid/hid-picolcd.c                             |    1 +
 drivers/hid/hid-roccat-common.c                       |    1 +
 drivers/hid/hid-roccat.c                              |    1 +
 drivers/hid/hid-sjoy.c                                |    1 +
 drivers/hid/hid-tmff.c                                |    1 +
 drivers/hid/hid-zpff.c                                |    1 +
 drivers/ide/cmd640.c                                  |    1 +
 drivers/ide/ide-acpi.c                                |    1 +
 drivers/ide/ide-pnp.c                                 |    1 +
 drivers/ide/tc86c001.c                                |    1 +
 drivers/idle/intel_idle.c                             |    1 +
 drivers/infiniband/hw/ipath/ipath_diag.c              |    1 +
 drivers/infiniband/hw/ipath/ipath_file_ops.c          |    2 ++
 drivers/infiniband/hw/ipath/ipath_sysfs.c             |    1 +
 drivers/infiniband/hw/ipath/ipath_verbs.c             |    1 +
 drivers/infiniband/hw/qib/qib_diag.c                  |    1 +
 drivers/infiniband/hw/qib/qib_file_ops.c              |    1 +
 drivers/infiniband/hw/qib/qib_iba7220.c               |    1 +
 drivers/infiniband/hw/qib/qib_iba7322.c               |    1 +
 drivers/infiniband/hw/qib/qib_pcie.c                  |    1 +
 drivers/infiniband/hw/qib/qib_sd7220.c                |    1 +
 drivers/infiniband/hw/qib/qib_verbs.c                 |    1 +
 drivers/input/joystick/as5011.c                       |    1 +
 drivers/input/misc/ad714x.c                           |    1 +
 drivers/input/misc/adxl34x.c                          |    1 +
 drivers/input/misc/ati_remote2.c                      |    1 +
 drivers/input/misc/cma3000_d0x.c                      |    1 +
 drivers/input/touchscreen/ad7877.c                    |    1 +
 drivers/input/touchscreen/ad7879-spi.c                |    1 +
 drivers/input/touchscreen/ad7879.c                    |    1 +
 drivers/input/touchscreen/ads7846.c                   |    1 +
 drivers/input/touchscreen/bu21013_ts.c                |    1 +
 drivers/isdn/capi/kcapi_proc.c                        |    1 +
 drivers/leds/dell-led.c                               |    1 +
 drivers/leds/leds-88pm860x.c                          |    1 +
 drivers/leds/leds-gpio.c                              |    1 +
 drivers/leds/leds-lm3530.c                            |    1 +
 drivers/leds/leds-lt3593.c                            |    1 +
 drivers/leds/leds-net48xx.c                           |    1 +
 drivers/leds/leds-net5501.c                           |    1 +
 drivers/leds/leds-wm831x-status.c                     |    1 +
 drivers/leds/leds-wm8350.c                            |    1 +
 drivers/leds/leds-wrap.c                              |    1 +
 drivers/lguest/lguest_device.c                        |    1 +
 drivers/md/dm-log-userspace-base.c                    |    1 +
 drivers/md/dm-raid.c                                  |    1 +
 drivers/md/dm-service-time.c                          |    1 +
 drivers/md/dm-uevent.c                                |    1 +
 drivers/media/common/saa7146_core.c                   |    1 +
 drivers/media/common/saa7146_fops.c                   |    1 +
 drivers/media/common/saa7146_hlp.c                    |    1 +
 drivers/media/common/saa7146_video.c                  |    1 +
 drivers/media/common/tuners/tuner-types.c             |    1 +
 drivers/media/dvb/frontends/dibx000_common.c          |    1 +
 drivers/media/dvb/siano/sms-cards.c                   |    1 +
 drivers/media/dvb/siano/smsendian.c                   |    1 +
 drivers/media/dvb/siano/smssdio.c                     |    1 +
 drivers/media/dvb/siano/smsusb.c                      |    1 +
 drivers/media/media-device.c                          |    1 +
 drivers/media/radio/radio-timb.c                      |    1 +
 drivers/media/radio/radio-wl1273.c                    |    1 +
 drivers/media/radio/si4713-i2c.c                      |    1 +
 drivers/media/radio/wl128x/fmdrv_v4l2.c               |    1 +
 drivers/media/rc/ir-jvc-decoder.c                     |    1 +
 drivers/media/rc/ir-lirc-codec.c                      |    1 +
 drivers/media/rc/ir-nec-decoder.c                     |    1 +
 drivers/media/rc/ir-raw.c                             |    1 +
 drivers/media/rc/ir-rc5-decoder.c                     |    1 +
 drivers/media/rc/ir-rc5-sz-decoder.c                  |    1 +
 drivers/media/rc/ir-rc6-decoder.c                     |    1 +
 drivers/media/rc/ir-sony-decoder.c                    |    1 +
 drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c       |    1 +
 drivers/media/rc/keymaps/rc-alink-dtu-m.c             |    1 +
 drivers/media/rc/keymaps/rc-anysee.c                  |    1 +
 drivers/media/rc/keymaps/rc-apac-viewcomp.c           |    1 +
 drivers/media/rc/keymaps/rc-asus-pc39.c               |    1 +
 drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c    |    1 +
 drivers/media/rc/keymaps/rc-avermedia-a16d.c          |    1 +
 drivers/media/rc/keymaps/rc-avermedia-cardbus.c       |    1 +
 drivers/media/rc/keymaps/rc-avermedia-dvbt.c          |    1 +
 drivers/media/rc/keymaps/rc-avermedia-m135a.c         |    1 +
 drivers/media/rc/keymaps/rc-avermedia-m733a-rm-k6.c   |    1 +
 drivers/media/rc/keymaps/rc-avermedia-rm-ks.c         |    1 +
 drivers/media/rc/keymaps/rc-avermedia.c               |    1 +
 drivers/media/rc/keymaps/rc-avertv-303.c              |    1 +
 drivers/media/rc/keymaps/rc-azurewave-ad-tu700.c      |    1 +
 drivers/media/rc/keymaps/rc-behold-columbus.c         |    1 +
 drivers/media/rc/keymaps/rc-behold.c                  |    1 +
 drivers/media/rc/keymaps/rc-budget-ci-old.c           |    1 +
 drivers/media/rc/keymaps/rc-cinergy-1400.c            |    1 +
 drivers/media/rc/keymaps/rc-cinergy.c                 |    1 +
 drivers/media/rc/keymaps/rc-dib0700-nec.c             |    1 +
 drivers/media/rc/keymaps/rc-em-terratec.c             |    1 +
 drivers/media/rc/keymaps/rc-encore-enltv-fm53.c       |    1 +
 drivers/media/rc/keymaps/rc-encore-enltv.c            |    1 +
 drivers/media/rc/keymaps/rc-encore-enltv2.c           |    1 +
 drivers/media/rc/keymaps/rc-evga-indtube.c            |    1 +
 drivers/media/rc/keymaps/rc-eztv.c                    |    1 +
 drivers/media/rc/keymaps/rc-flydvb.c                  |    1 +
 drivers/media/rc/keymaps/rc-flyvideo.c                |    1 +
 drivers/media/rc/keymaps/rc-fusionhdtv-mce.c          |    1 +
 drivers/media/rc/keymaps/rc-gadmei-rm008z.c           |    1 +
 drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c      |    1 +
 drivers/media/rc/keymaps/rc-gotview7135.c             |    1 +
 drivers/media/rc/keymaps/rc-hauppauge.c               |    1 +
 drivers/media/rc/keymaps/rc-imon-mce.c                |    1 +
 drivers/media/rc/keymaps/rc-imon-pad.c                |    1 +
 drivers/media/rc/keymaps/rc-iodata-bctv7e.c           |    1 +
 drivers/media/rc/keymaps/rc-kaiomy.c                  |    1 +
 drivers/media/rc/keymaps/rc-kworld-315u.c             |    1 +
 drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c   |    1 +
 drivers/media/rc/keymaps/rc-leadtek-y04g0051.c        |    1 +
 drivers/media/rc/keymaps/rc-lirc.c                    |    1 +
 drivers/media/rc/keymaps/rc-lme2510.c                 |    1 +
 drivers/media/rc/keymaps/rc-manli.c                   |    1 +
 drivers/media/rc/keymaps/rc-msi-digivox-ii.c          |    1 +
 drivers/media/rc/keymaps/rc-msi-digivox-iii.c         |    1 +
 drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c     |    1 +
 drivers/media/rc/keymaps/rc-msi-tvanywhere.c          |    1 +
 drivers/media/rc/keymaps/rc-nebula.c                  |    1 +
 drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c |    1 +
 drivers/media/rc/keymaps/rc-norwood.c                 |    1 +
 drivers/media/rc/keymaps/rc-npgtech.c                 |    1 +
 drivers/media/rc/keymaps/rc-pctv-sedna.c              |    1 +
 drivers/media/rc/keymaps/rc-pinnacle-color.c          |    1 +
 drivers/media/rc/keymaps/rc-pinnacle-grey.c           |    1 +
 drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c        |    1 +
 drivers/media/rc/keymaps/rc-pixelview-002t.c          |    1 +
 drivers/media/rc/keymaps/rc-pixelview-mk12.c          |    1 +
 drivers/media/rc/keymaps/rc-pixelview-new.c           |    1 +
 drivers/media/rc/keymaps/rc-pixelview.c               |    1 +
 drivers/media/rc/keymaps/rc-powercolor-real-angel.c   |    1 +
 drivers/media/rc/keymaps/rc-proteus-2309.c            |    1 +
 drivers/media/rc/keymaps/rc-purpletv.c                |    1 +
 drivers/media/rc/keymaps/rc-pv951.c                   |    1 +
 drivers/media/rc/keymaps/rc-rc6-mce.c                 |    1 +
 drivers/media/rc/keymaps/rc-real-audio-220-32-keys.c  |    1 +
 drivers/media/rc/keymaps/rc-streamzap.c               |    1 +
 drivers/media/rc/keymaps/rc-tbs-nec.c                 |    1 +
 drivers/media/rc/keymaps/rc-technisat-usb2.c          |    1 +
 drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c     |    1 +
 drivers/media/rc/keymaps/rc-terratec-slim-2.c         |    1 +
 drivers/media/rc/keymaps/rc-terratec-slim.c           |    1 +
 drivers/media/rc/keymaps/rc-tevii-nec.c               |    1 +
 drivers/media/rc/keymaps/rc-tivo.c                    |    1 +
 drivers/media/rc/keymaps/rc-total-media-in-hand.c     |    1 +
 drivers/media/rc/keymaps/rc-trekstor.c                |    1 +
 drivers/media/rc/keymaps/rc-tt-1500.c                 |    1 +
 drivers/media/rc/keymaps/rc-twinhan1027.c             |    1 +
 drivers/media/rc/keymaps/rc-videomate-m1f.c           |    1 +
 drivers/media/rc/keymaps/rc-videomate-s350.c          |    1 +
 drivers/media/rc/keymaps/rc-videomate-tv-pvr.c        |    1 +
 drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c    |    1 +
 drivers/media/rc/keymaps/rc-winfast.c                 |    1 +
 drivers/media/rc/rc-main.c                            |    1 +
 drivers/media/video/cpia2/cpia2_usb.c                 |    1 +
 drivers/media/video/cx25840/cx25840-ir.c              |    1 +
 drivers/media/video/hdpvr/hdpvr-i2c.c                 |    1 +
 drivers/media/video/hexium_gemini.c                   |    1 +
 drivers/media/video/hexium_orion.c                    |    1 +
 drivers/media/video/imx074.c                          |    1 +
 drivers/media/video/mt9m001.c                         |    1 +
 drivers/media/video/mt9m111.c                         |    1 +
 drivers/media/video/mt9t031.c                         |    1 +
 drivers/media/video/mt9v011.c                         |    1 +
 drivers/media/video/mt9v022.c                         |    1 +
 drivers/media/video/mxb.c                             |    1 +
 drivers/media/video/noon010pc30.c                     |    1 +
 drivers/media/video/ov6650.c                          |    1 +
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c            |    1 +
 drivers/media/video/rj54n1cb0c.c                      |    1 +
 drivers/media/video/sr030pc30.c                       |    1 +
 drivers/media/video/timblogiw.c                       |    1 +
 drivers/media/video/tvp5150.c                         |    1 +
 drivers/media/video/usbvision/usbvision-cards.c       |    1 +
 drivers/media/video/v4l2-ctrls.c                      |    1 +
 drivers/media/video/v4l2-device.c                     |    1 +
 drivers/media/video/v4l2-event.c                      |    1 +
 drivers/media/video/v4l2-fh.c                         |    1 +
 drivers/media/video/v4l2-int-device.c                 |    1 +
 drivers/media/video/v4l2-subdev.c                     |    1 +
 drivers/memstick/core/memstick.c                      |    1 +
 drivers/memstick/core/mspro_block.c                   |    1 +
 drivers/memstick/host/jmb38x_ms.c                     |    1 +
 drivers/memstick/host/tifm_ms.c                       |    1 +
 drivers/message/i2o/pci.c                             |    1 +
 drivers/mfd/ab3100-core.c                             |    1 +
 drivers/mfd/ab3550-core.c                             |    1 +
 drivers/mfd/ab8500-debugfs.c                          |    1 +
 drivers/mfd/ab8500-sysctrl.c                          |    1 +
 drivers/mfd/abx500-core.c                             |    1 +
 drivers/mfd/max8997.c                                 |    1 +
 drivers/mfd/mfd-core.c                                |    1 +
 drivers/mfd/pcf50633-irq.c                            |    1 +
 drivers/mfd/twl-core.c                                |    1 +
 drivers/mfd/twl6030-irq.c                             |    1 +
 drivers/mfd/wl1273-core.c                             |    1 +
 drivers/mfd/wm8400-core.c                             |    1 +
 drivers/misc/bh1780gli.c                              |    2 ++
 drivers/misc/kgdbts.c                                 |    1 +
 drivers/misc/ti-st/st_kim.c                           |    1 +
 drivers/misc/tifm_7xx1.c                              |    1 +
 drivers/misc/tifm_core.c                              |    1 +
 drivers/mmc/card/mmc_test.c                           |    1 +
 drivers/mmc/core/bus.c                                |    1 +
 drivers/mmc/core/debugfs.c                            |    1 +
 drivers/mmc/core/host.c                               |    1 +
 drivers/mmc/core/mmc.c                                |    1 +
 drivers/mmc/core/quirks.c                             |    1 +
 drivers/mmc/core/sd.c                                 |    1 +
 drivers/mmc/core/sd_ops.c                             |    1 +
 drivers/mmc/core/sdio_bus.c                           |    1 +
 drivers/mmc/core/sdio_io.c                            |    1 +
 drivers/mmc/core/sdio_irq.c                           |    1 +
 drivers/mmc/host/mmc_spi.c                            |    1 +
 drivers/mmc/host/sdhci-pci.c                          |    1 +
 drivers/mmc/host/sdhci-pltfm.c                        |    1 +
 drivers/mmc/host/sdhci.c                              |    1 +
 drivers/mmc/host/sdricoh_cs.c                         |    1 +
 drivers/mmc/host/tifm_sd.c                            |    1 +
 drivers/mmc/host/via-sdmmc.c                          |    1 +
 drivers/mtd/ar7part.c                                 |    1 +
 drivers/mtd/cmdlinepart.c                             |    1 +
 drivers/mtd/lpddr/lpddr_cmds.c                        |    1 +
 drivers/mtd/nand/cafe_nand.c                          |    1 +
 drivers/mtd/nand/diskonchip.c                         |    1 +
 drivers/mtd/nand/nand_bbt.c                           |    1 +
 drivers/mtd/nand/sm_common.c                          |    1 +
 drivers/mtd/onenand/onenand_bbt.c                     |    1 +
 drivers/mtd/redboot.c                                 |    1 +
 drivers/mtd/rfd_ftl.c                                 |    1 +
 drivers/mtd/ubi/vmt.c                                 |    1 +
 drivers/net/phy/realtek.c                             |    1 +
 drivers/pci/hotplug/pciehp_acpi.c                     |    1 +
 drivers/platform/x86/intel_scu_ipc.c                  |    1 +
 drivers/platform/x86/msi-wmi.c                        |    1 +
 drivers/platform/x86/wmi.c                            |    1 +
 drivers/power/max17042_battery.c                      |    1 +
 drivers/rapidio/switches/idt_gen2.c                   |    2 ++
 drivers/regulator/ab8500.c                            |    1 +
 drivers/regulator/bq24022.c                           |    1 +
 drivers/regulator/da903x.c                            |    1 +
 drivers/regulator/dummy.c                             |    1 +
 drivers/regulator/fixed.c                             |    1 +
 drivers/regulator/lp3971.c                            |    1 +
 drivers/regulator/lp3972.c                            |    1 +
 drivers/regulator/max8925-regulator.c                 |    1 +
 drivers/regulator/max8997.c                           |    1 +
 drivers/regulator/mc13783-regulator.c                 |    1 +
 drivers/regulator/mc13892-regulator.c                 |    1 +
 drivers/regulator/mc13xxx-regulator-core.c            |    1 +
 drivers/regulator/tps6586x-regulator.c                |    1 +
 drivers/regulator/userspace-consumer.c                |    1 +
 drivers/regulator/virtual.c                           |    1 +
 drivers/regulator/wm8400-regulator.c                  |    1 +
 drivers/rtc/rtc-ds1305.c                              |    1 +
 drivers/rtc/rtc-ds1511.c                              |    1 +
 drivers/rtc/rtc-ds1553.c                              |    1 +
 drivers/rtc/rtc-ds1672.c                              |    1 +
 drivers/rtc/rtc-ds1742.c                              |    1 +
 drivers/rtc/rtc-isl12022.c                            |    1 +
 drivers/rtc/rtc-pcf2123.c                             |    1 +
 drivers/rtc/rtc-pcf8563.c                             |    1 +
 drivers/rtc/rtc-rs5c348.c                             |    1 +
 drivers/rtc/rtc-rs5c372.c                             |    1 +
 drivers/rtc/rtc-x1205.c                               |    1 +
 drivers/scsi/aacraid/aachba.c                         |    1 +
 drivers/scsi/bfa/bfad_debugfs.c                       |    1 +
 drivers/scsi/bfa/bfad_im.c                            |    1 +
 drivers/scsi/device_handler/scsi_dh.c                 |    1 +
 drivers/scsi/device_handler/scsi_dh_alua.c            |    1 +
 drivers/scsi/device_handler/scsi_dh_emc.c             |    1 +
 drivers/scsi/device_handler/scsi_dh_hp_sw.c           |    1 +
 drivers/scsi/device_handler/scsi_dh_rdac.c            |    1 +
 drivers/scsi/libfc/fc_disc.c                          |    1 +
 drivers/scsi/libfc/fc_elsct.c                         |    1 +
 drivers/scsi/libfc/fc_exch.c                          |    1 +
 drivers/scsi/libfc/fc_libfc.c                         |    1 +
 drivers/scsi/libfc/fc_lport.c                         |    1 +
 drivers/scsi/libsrp.c                                 |    1 +
 drivers/scsi/lpfc/lpfc_debugfs.c                      |    1 +
 drivers/scsi/megaraid/megaraid_mbox.c                 |    1 +
 drivers/scsi/osd/osd_initiator.c                      |    1 +
 drivers/scsi/scsi_pm.c                                |    1 +
 drivers/spi/dw_spi.c                                  |    1 +
 drivers/spi/dw_spi_pci.c                              |    1 +
 drivers/spi/pxa2xx_spi_pci.c                          |    1 +
 drivers/spi/spi.c                                     |    1 +
 drivers/spi/spi_altera.c                              |    1 +
 drivers/spi/spi_bitbang.c                             |    1 +
 drivers/spi/spi_butterfly.c                           |    1 +
 drivers/spi/spi_oc_tiny.c                             |    1 +
 drivers/spi/tle62x0.c                                 |    1 +
 drivers/tty/serial/max3100.c                          |    1 +
 drivers/tty/serial/max3107-aava.c                     |    1 +
 drivers/tty/serial/max3107.c                          |    1 +
 drivers/tty/serial/timbuart.c                         |    1 +
 drivers/tty/serial/xilinx_uartps.c                    |    1 +
 drivers/uio/uio_pdrv.c                                |    1 +
 drivers/uio/uio_pdrv_genirq.c                         |    1 +
 drivers/usb/wusbcore/devconnect.c                     |    1 +
 drivers/usb/wusbcore/mmc.c                            |    1 +
 drivers/usb/wusbcore/rh.c                             |    1 +
 drivers/usb/wusbcore/security.c                       |    1 +
 drivers/usb/wusbcore/wa-rpipe.c                       |    1 +
 drivers/usb/wusbcore/wa-xfer.c                        |    1 +
 drivers/uwb/est.c                                     |    1 +
 drivers/uwb/i1480/dfu/dfu.c                           |    1 +
 drivers/uwb/ie.c                                      |    1 +
 drivers/uwb/lc-dev.c                                  |    1 +
 drivers/uwb/neh.c                                     |    1 +
 drivers/uwb/pal.c                                     |    1 +
 drivers/uwb/radio.c                                   |    1 +
 drivers/uwb/reset.c                                   |    1 +
 drivers/uwb/rsv.c                                     |    1 +
 drivers/uwb/scan.c                                    |    1 +
 drivers/video/backlight/88pm860x_bl.c                 |    1 +
 drivers/video/backlight/adp5520_bl.c                  |    1 +
 drivers/video/backlight/da903x_bl.c                   |    1 +
 drivers/video/backlight/l4f00242t03.c                 |    1 +
 drivers/video/backlight/ld9040.c                      |    1 +
 drivers/video/backlight/lms283gf05.c                  |    1 +
 drivers/video/backlight/max8925_bl.c                  |    1 +
 drivers/video/backlight/s6e63m0.c                     |    1 +
 drivers/video/backlight/wm831x_bl.c                   |    1 +
 drivers/video/carminefb.c                             |    1 +
 drivers/video/mb862xx/mb862xxfb.c                     |    1 +
 drivers/video/savage/savagefb_accel.c                 |    1 +
 drivers/video/via/via-gpio.c                          |    1 +
 drivers/virtio/virtio.c                               |    1 +
 drivers/virtio/virtio_balloon.c                       |    1 +
 drivers/virtio/virtio_ring.c                          |    1 +
 drivers/w1/w1_family.c                                |    1 +
 drivers/xen/balloon.c                                 |    1 +
 drivers/xen/manage.c                                  |    1 +
 drivers/xen/swiotlb-xen.c                             |    1 +
 fs/bio-integrity.c                                    |    1 +
 fs/exofs/super.c                                      |    1 +
 fs/gfs2/ops_fstype.c                                  |    1 +
 fs/jfs/jfs_logmgr.c                                   |    1 +
 fs/logfs/super.c                                      |    1 +
 include/linux/bcma/bcma.h                             |    1 +
 include/linux/gameport.h                              |    1 +
 include/linux/ssb/ssb.h                               |    1 +
 include/linux/uio_driver.h                            |    1 +
 include/xen/xenbus.h                                  |    1 +
 kernel/debug/kdb/kdb_debugger.c                       |    1 +
 kernel/jump_label.c                                   |    1 +
 kernel/ksysfs.c                                       |    1 +
 kernel/rcutorture.c                                   |    1 +
 kernel/rcutree_trace.c                                |    1 +
 kernel/trace/ftrace.c                                 |    1 +
 kernel/trace/trace_syscalls.c                         |    2 ++
 kernel/watchdog.c                                     |    1 +
 lib/dma-debug.c                                       |    1 +
 mm/memory-failure.c                                   |    1 +
 net/caif/cfpkt_skbuff.c                               |    2 ++
 net/netfilter/ipset/pfxlen.c                          |    1 +
 sound/core/jack.c                                     |    1 +
 sound/core/rawmidi.c                                  |    1 +
 sound/core/seq/seq_midi.c                             |    1 +
 sound/core/seq/seq_midi_emul.c                        |    1 +
 sound/core/seq/seq_virmidi.c                          |    1 +
 sound/drivers/mpu401/mpu401.c                         |    1 +
 sound/drivers/mpu401/mpu401_uart.c                    |    1 +
 sound/drivers/mtpav.c                                 |    1 +
 sound/drivers/mts64.c                                 |    1 +
 sound/drivers/opl3/opl3_lib.c                         |    1 +
 sound/drivers/opl3/opl3_oss.c                         |    2 ++
 sound/drivers/opl3/opl3_seq.c                         |    1 +
 sound/drivers/opl3/opl3_synth.c                       |    1 +
 sound/drivers/opl4/opl4_lib.c                         |    1 +
 sound/drivers/opl4/opl4_proc.c                        |    1 +
 sound/drivers/opl4/opl4_seq.c                         |    1 +
 sound/drivers/portman2x4.c                            |    1 +
 sound/drivers/serial-u16550.c                         |    1 +
 sound/drivers/virmidi.c                               |    1 +
 sound/firewire/iso-resources.c                        |    1 +
 sound/firewire/packets-buffer.c                       |    1 +
 sound/i2c/i2c.c                                       |    1 +
 sound/i2c/other/ak4xxx-adda.c                         |    1 +
 sound/i2c/other/pt2258.c                              |    2 ++
 sound/i2c/other/tea575x-tuner.c                       |    1 +
 sound/i2c/tea6330t.c                                  |    1 +
 sound/isa/sb/emu8000.c                                |    1 +
 sound/isa/sb/emu8000_callback.c                       |    1 +
 sound/isa/sb/emu8000_patch.c                          |    1 +
 sound/isa/sb/emu8000_synth.c                          |    1 +
 sound/isa/wavefront/wavefront_fx.c                    |    1 +
 sound/isa/wavefront/wavefront_synth.c                 |    1 +
 sound/pci/asihpi/hpioctl.c                            |    1 +
 sound/pci/ctxfi/xfi.c                                 |    1 +
 sound/pci/oxygen/oxygen_io.c                          |    1 +
 sound/synth/emux/emux.c                               |    1 +
 sound/synth/emux/emux_oss.c                           |    1 +
 sound/synth/emux/emux_seq.c                           |    1 +
 sound/synth/emux/emux_synth.c                         |    1 +
 sound/synth/emux/soundfont.c                          |    1 +
 sound/synth/util_mem.c                                |    1 +
 sound/usb/6fire/firmware.c                            |    1 +
 sound/usb/midi.c                                      |    1 +
 438 files changed, 448 insertions(+), 1 deletion(-)

Index: linux/arch/x86/crypto/aesni-intel_glue.c
===================================================================
--- linux.orig/arch/x86/crypto/aesni-intel_glue.c
+++ linux/arch/x86/crypto/aesni-intel_glue.c
@@ -33,6 +33,7 @@
 #include <crypto/internal/aead.h>
 #include <linux/workqueue.h>
 #include <linux/spinlock.h>
+#include <linux/module.h>
 
 #if defined(CONFIG_CRYPTO_CTR) || defined(CONFIG_CRYPTO_CTR_MODULE)
 #define HAS_CTR
Index: linux/arch/x86/kernel/e820.c
===================================================================
--- linux.orig/arch/x86/kernel/e820.c
+++ linux/arch/x86/kernel/e820.c
@@ -18,6 +18,7 @@
 #include <linux/acpi.h>
 #include <linux/firmware-map.h>
 #include <linux/memblock.h>
+#include <linux/module.h>
 
 #include <asm/e820.h>
 #include <asm/proto.h>
Index: linux/arch/x86/kernel/pci-dma.c
===================================================================
--- linux.orig/arch/x86/kernel/pci-dma.c
+++ linux/arch/x86/kernel/pci-dma.c
@@ -5,6 +5,7 @@
 #include <linux/gfp.h>
 #include <linux/pci.h>
 #include <linux/kmemleak.h>
+#include <linux/module.h>
 
 #include <asm/proto.h>
 #include <asm/dma.h>
Index: linux/arch/x86/kernel/rtc.c
===================================================================
--- linux.orig/arch/x86/kernel/rtc.c
+++ linux/arch/x86/kernel/rtc.c
@@ -7,6 +7,7 @@
 #include <linux/bcd.h>
 #include <linux/pnp.h>
 #include <linux/of.h>
+#include <linux/module.h>
 
 #include <asm/vsyscall.h>
 #include <asm/x86_init.h>
Index: linux/arch/x86/platform/mrst/vrtc.c
===================================================================
--- linux.orig/arch/x86/platform/mrst/vrtc.c
+++ linux/arch/x86/platform/mrst/vrtc.c
@@ -19,6 +19,7 @@
 
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/module.h>
 #include <linux/sfi.h>
 #include <linux/platform_device.h>
 
Index: linux/arch/x86/platform/uv/bios_uv.c
===================================================================
--- linux.orig/arch/x86/platform/uv/bios_uv.c
+++ linux/arch/x86/platform/uv/bios_uv.c
@@ -19,9 +19,11 @@
  *  Copyright (c) Russ Anderson <rja@sgi.com>
  */
 
+#include <linux/io.h>
 #include <linux/efi.h>
+#include <linux/module.h>
+
 #include <asm/efi.h>
-#include <linux/io.h>
 #include <asm/uv/bios.h>
 #include <asm/uv/uv_hub.h>
 
Index: linux/block/blk-integrity.c
===================================================================
--- linux.orig/block/blk-integrity.c
+++ linux/block/blk-integrity.c
@@ -25,6 +25,7 @@
 #include <linux/bio.h>
 #include <linux/scatterlist.h>
 #include <linux/slab.h>
+#include <linux/module.h>
 
 #include "blk.h"
 
Index: linux/crypto/async_tx/raid6test.c
===================================================================
--- linux.orig/crypto/async_tx/raid6test.c
+++ linux/crypto/async_tx/raid6test.c
@@ -20,6 +20,7 @@
  *
  */
 #include <linux/async_tx.h>
+#include <linux/module.h>
 #include <linux/gfp.h>
 #include <linux/random.h>
 
Index: linux/drivers/acpi/ec_sys.c
===================================================================
--- linux.orig/drivers/acpi/ec_sys.c
+++ linux/drivers/acpi/ec_sys.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/acpi.h>
 #include <linux/debugfs.h>
 #include "internal.h"
Index: linux/drivers/acpi/sbshc.c
===================================================================
--- linux.orig/drivers/acpi/sbshc.c
+++ linux/drivers/acpi/sbshc.c
@@ -14,6 +14,7 @@
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
+#include <linux/module.h>
 #include "sbshc.h"
 
 #define PREFIX "ACPI: "
Index: linux/drivers/base/dma-coherent.c
===================================================================
--- linux.orig/drivers/base/dma-coherent.c
+++ linux/drivers/base/dma-coherent.c
@@ -5,6 +5,7 @@
 #include <linux/slab.h>
 #include <linux/kernel.h>
 #include <linux/dma-mapping.h>
+#include <linux/module.h>
 
 struct dma_coherent_mem {
 	void		*virt_base;
Index: linux/drivers/base/hypervisor.c
===================================================================
--- linux.orig/drivers/base/hypervisor.c
+++ linux/drivers/base/hypervisor.c
@@ -10,6 +10,8 @@
 
 #include <linux/kobject.h>
 #include <linux/device.h>
+#include <linux/module.h>
+
 #include "base.h"
 
 struct kobject *hypervisor_kobj;
Index: linux/drivers/base/power/runtime.c
===================================================================
--- linux.orig/drivers/base/power/runtime.c
+++ linux/drivers/base/power/runtime.c
@@ -9,6 +9,7 @@
 
 #include <linux/sched.h>
 #include <linux/pm_runtime.h>
+#include <linux/module.h>
 #include "power.h"
 
 static int rpm_resume(struct device *dev, int rpmflags);
Index: linux/drivers/bcma/main.c
===================================================================
--- linux.orig/drivers/bcma/main.c
+++ linux/drivers/bcma/main.c
@@ -7,6 +7,7 @@
 
 #include "bcma_private.h"
 #include <linux/bcma/bcma.h>
+#include <linux/module.h>
 
 MODULE_DESCRIPTION("Broadcom's specific AMBA driver");
 MODULE_LICENSE("GPL");
Index: linux/drivers/block/aoe/aoechr.c
===================================================================
--- linux.orig/drivers/block/aoe/aoechr.c
+++ linux/drivers/block/aoe/aoechr.c
@@ -11,6 +11,7 @@
 #include <linux/slab.h>
 #include <linux/mutex.h>
 #include <linux/skbuff.h>
+#include <linux/module.h>
 #include "aoe.h"
 
 enum {
Index: linux/drivers/block/virtio_blk.c
===================================================================
--- linux.orig/drivers/block/virtio_blk.c
+++ linux/drivers/block/virtio_blk.c
@@ -6,6 +6,7 @@
 #include <linux/virtio.h>
 #include <linux/virtio_blk.h>
 #include <linux/scatterlist.h>
+#include <linux/module.h>
 
 #define PART_BITS 4
 
Index: linux/drivers/char/hw_random/virtio-rng.c
===================================================================
--- linux.orig/drivers/char/hw_random/virtio-rng.c
+++ linux/drivers/char/hw_random/virtio-rng.c
@@ -23,6 +23,7 @@
 #include <linux/spinlock.h>
 #include <linux/virtio.h>
 #include <linux/virtio_rng.h>
+#include <linux/module.h>
 
 static struct virtqueue *vq;
 static unsigned int data_avail;
Index: linux/drivers/char/ttyprintk.c
===================================================================
--- linux.orig/drivers/char/ttyprintk.c
+++ linux/drivers/char/ttyprintk.c
@@ -17,6 +17,7 @@
 #include <linux/device.h>
 #include <linux/serial.h>
 #include <linux/tty.h>
+#include <linux/module.h>
 
 struct ttyprintk_port {
 	struct tty_port port;
Index: linux/drivers/char/virtio_console.c
===================================================================
--- linux.orig/drivers/char/virtio_console.c
+++ linux/drivers/char/virtio_console.c
@@ -32,6 +32,7 @@
 #include <linux/virtio_console.h>
 #include <linux/wait.h>
 #include <linux/workqueue.h>
+#include <linux/module.h>
 #include "../tty/hvc/hvc_console.h"
 
 /*
Index: linux/drivers/dca/dca-core.c
===================================================================
--- linux.orig/drivers/dca/dca-core.c
+++ linux/drivers/dca/dca-core.c
@@ -28,6 +28,7 @@
 #include <linux/device.h>
 #include <linux/dca.h>
 #include <linux/slab.h>
+#include <linux/module.h>
 
 #define DCA_VERSION "1.12.1"
 
Index: linux/drivers/dca/dca-sysfs.c
===================================================================
--- linux.orig/drivers/dca/dca-sysfs.c
+++ linux/drivers/dca/dca-sysfs.c
@@ -27,6 +27,7 @@
 #include <linux/err.h>
 #include <linux/dca.h>
 #include <linux/gfp.h>
+#include <linux/module.h>
 
 static struct class *dca_class;
 static struct idr dca_idr;
Index: linux/drivers/dma/intel_mid_dma.c
===================================================================
--- linux.orig/drivers/dma/intel_mid_dma.c
+++ linux/drivers/dma/intel_mid_dma.c
@@ -24,6 +24,7 @@
  *
  */
 #include <linux/pci.h>
+#include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/pm_runtime.h>
 #include <linux/intel_mid_dma.h>
Index: linux/drivers/edac/mce_amd_inj.c
===================================================================
--- linux.orig/drivers/edac/mce_amd_inj.c
+++ linux/drivers/edac/mce_amd_inj.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/kobject.h>
+#include <linux/module.h>
 #include <linux/sysdev.h>
 #include <linux/edac.h>
 #include <asm/mce.h>
Index: linux/drivers/firewire/core-iso.c
===================================================================
--- linux.orig/drivers/firewire/core-iso.c
+++ linux/drivers/firewire/core-iso.c
@@ -29,6 +29,7 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/vmalloc.h>
+#include <linux/module.h>
 
 #include <asm/byteorder.h>
 
Index: linux/drivers/firmware/google/gsmi.c
===================================================================
--- linux.orig/drivers/firmware/google/gsmi.c
+++ linux/drivers/firmware/google/gsmi.c
@@ -27,6 +27,7 @@
 #include <linux/kdebug.h>
 #include <linux/reboot.h>
 #include <linux/efi.h>
+#include <linux/module.h>
 
 #define GSMI_SHUTDOWN_CLEAN	0	/* Clean Shutdown */
 /* TODO(mikew@google.com): Tie in HARDLOCKUP_DETECTOR with NMIWDT */
Index: linux/drivers/firmware/sigma.c
===================================================================
--- linux.orig/drivers/firmware/sigma.c
+++ linux/drivers/firmware/sigma.c
@@ -12,6 +12,7 @@
 #include <linux/kernel.h>
 #include <linux/i2c.h>
 #include <linux/sigma.h>
+#include <linux/module.h>
 
 /* Return: 0==OK, <0==error, =1 ==no more actions */
 static int
Index: linux/drivers/gpio/74x164.c
===================================================================
--- linux.orig/drivers/gpio/74x164.c
+++ linux/drivers/gpio/74x164.c
@@ -15,6 +15,7 @@
 #include <linux/spi/74x164.h>
 #include <linux/gpio.h>
 #include <linux/slab.h>
+#include <linux/module.h>
 
 #define GEN_74X164_GPIO_COUNT	8
 
Index: linux/drivers/gpio/mc33880.c
===================================================================
--- linux.orig/drivers/gpio/mc33880.c
+++ linux/drivers/gpio/mc33880.c
@@ -26,6 +26,7 @@
 #include <linux/spi/mc33880.h>
 #include <linux/gpio.h>
 #include <linux/slab.h>
+#include <linux/module.h>
 
 #define DRIVER_NAME "mc33880"
 
Index: linux/drivers/gpio/mcp23s08.c
===================================================================
--- linux.orig/drivers/gpio/mcp23s08.c
+++ linux/drivers/gpio/mcp23s08.c
@@ -10,6 +10,7 @@
 #include <linux/spi/spi.h>
 #include <linux/spi/mcp23s08.h>
 #include <linux/slab.h>
+#include <linux/module.h>
 #include <asm/byteorder.h>
 
 /**
Index: linux/drivers/gpio/ml_ioh_gpio.c
===================================================================
--- linux.orig/drivers/gpio/ml_ioh_gpio.c
+++ linux/drivers/gpio/ml_ioh_gpio.c
@@ -17,6 +17,7 @@
 #include <linux/kernel.h>
 #include <linux/pci.h>
 #include <linux/gpio.h>
+#include <linux/module.h>
 
 #define PCI_VENDOR_ID_ROHM             0x10DB
 
Index: linux/drivers/gpio/pcf857x.c
===================================================================
--- linux.orig/drivers/gpio/pcf857x.c
+++ linux/drivers/gpio/pcf857x.c
@@ -23,6 +23,7 @@
 #include <linux/gpio.h>
 #include <linux/i2c.h>
 #include <linux/i2c/pcf857x.h>
+#include <linux/module.h>
 
 
 static const struct i2c_device_id pcf857x_id[] = {
Index: linux/drivers/gpio/pch_gpio.c
===================================================================
--- linux.orig/drivers/gpio/pch_gpio.c
+++ linux/drivers/gpio/pch_gpio.c
@@ -17,6 +17,7 @@
 #include <linux/kernel.h>
 #include <linux/pci.h>
 #include <linux/gpio.h>
+#include <linux/module.h>
 
 #define PCH_GPIO_ALL_PINS	0xfff /* Mask for GPIO pins 0 to 11 */
 #define GPIO_NUM_PINS	12	/* Specifies number of GPIO PINS GPIO0-GPIO11 */
Index: linux/drivers/gpu/drm/ttm/ttm_tt.c
===================================================================
--- linux.orig/drivers/gpu/drm/ttm/ttm_tt.c
+++ linux/drivers/gpu/drm/ttm/ttm_tt.c
@@ -30,6 +30,7 @@
 
 #include <linux/sched.h>
 #include <linux/highmem.h>
+#include <linux/module.h>
 #include <linux/pagemap.h>
 #include <linux/file.h>
 #include <linux/swap.h>
Index: linux/drivers/hid/hid-axff.c
===================================================================
--- linux.orig/drivers/hid/hid-axff.c
+++ linux/drivers/hid/hid-axff.c
@@ -31,6 +31,7 @@
 #include <linux/slab.h>
 #include <linux/usb.h>
 #include <linux/hid.h>
+#include <linux/module.h>
 
 #include "hid-ids.h"
 
Index: linux/drivers/hid/hid-dr.c
===================================================================
--- linux.orig/drivers/hid/hid-dr.c
+++ linux/drivers/hid/hid-dr.c
@@ -31,6 +31,7 @@
 #include <linux/slab.h>
 #include <linux/usb.h>
 #include <linux/hid.h>
+#include <linux/module.h>
 
 #include "hid-ids.h"
 
Index: linux/drivers/hid/hid-emsff.c
===================================================================
--- linux.orig/drivers/hid/hid-emsff.c
+++ linux/drivers/hid/hid-emsff.c
@@ -24,6 +24,7 @@
 #include <linux/hid.h>
 #include <linux/input.h>
 #include <linux/usb.h>
+#include <linux/module.h>
 
 #include "hid-ids.h"
 #include "usbhid/usbhid.h"
Index: linux/drivers/hid/hid-gaff.c
===================================================================
--- linux.orig/drivers/hid/hid-gaff.c
+++ linux/drivers/hid/hid-gaff.c
@@ -31,6 +31,7 @@
 #include <linux/slab.h>
 #include <linux/usb.h>
 #include <linux/hid.h>
+#include <linux/module.h>
 #include "hid-ids.h"
 
 #ifdef CONFIG_GREENASIA_FF
Index: linux/drivers/hid/hid-picolcd.c
===================================================================
--- linux.orig/drivers/hid/hid-picolcd.c
+++ linux/drivers/hid/hid-picolcd.c
@@ -33,6 +33,7 @@
 
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
+#include <linux/module.h>
 
 #include <linux/completion.h>
 #include <linux/uaccess.h>
Index: linux/drivers/hid/hid-roccat-common.c
===================================================================
--- linux.orig/drivers/hid/hid-roccat-common.c
+++ linux/drivers/hid/hid-roccat-common.c
@@ -12,6 +12,7 @@
  */
 
 #include <linux/slab.h>
+#include <linux/module.h>
 #include "hid-roccat-common.h"
 
 int roccat_common_receive(struct usb_device *usb_dev, uint usb_command,
Index: linux/drivers/hid/hid-roccat.c
===================================================================
--- linux.orig/drivers/hid/hid-roccat.c
+++ linux/drivers/hid/hid-roccat.c
@@ -27,6 +27,7 @@
 #include <linux/poll.h>
 #include <linux/sched.h>
 #include <linux/hid-roccat.h>
+#include <linux/module.h>
 
 #define ROCCAT_FIRST_MINOR 0
 #define ROCCAT_MAX_DEVICES 8
Index: linux/drivers/hid/hid-sjoy.c
===================================================================
--- linux.orig/drivers/hid/hid-sjoy.c
+++ linux/drivers/hid/hid-sjoy.c
@@ -30,6 +30,7 @@
 #include <linux/slab.h>
 #include <linux/usb.h>
 #include <linux/hid.h>
+#include <linux/module.h>
 #include "hid-ids.h"
 
 #ifdef CONFIG_SMARTJOYPLUS_FF
Index: linux/drivers/hid/hid-tmff.c
===================================================================
--- linux.orig/drivers/hid/hid-tmff.c
+++ linux/drivers/hid/hid-tmff.c
@@ -31,6 +31,7 @@
 #include <linux/input.h>
 #include <linux/slab.h>
 #include <linux/usb.h>
+#include <linux/module.h>
 
 #include "hid-ids.h"
 
Index: linux/drivers/hid/hid-zpff.c
===================================================================
--- linux.orig/drivers/hid/hid-zpff.c
+++ linux/drivers/hid/hid-zpff.c
@@ -25,6 +25,7 @@
 #include <linux/input.h>
 #include <linux/slab.h>
 #include <linux/usb.h>
+#include <linux/module.h>
 
 #include "hid-ids.h"
 
Index: linux/drivers/ide/cmd640.c
===================================================================
--- linux.orig/drivers/ide/cmd640.c
+++ linux/drivers/ide/cmd640.c
@@ -102,6 +102,7 @@
 
 #include <linux/types.h>
 #include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/ide.h>
 #include <linux/init.h>
Index: linux/drivers/ide/ide-acpi.c
===================================================================
--- linux.orig/drivers/ide/ide-acpi.c
+++ linux/drivers/ide/ide-acpi.c
@@ -9,6 +9,7 @@
 
 #include <linux/ata.h>
 #include <linux/delay.h>
+#include <linux/module.h>
 #include <linux/device.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
Index: linux/drivers/ide/ide-pnp.c
===================================================================
--- linux.orig/drivers/ide/ide-pnp.c
+++ linux/drivers/ide/ide-pnp.c
@@ -16,6 +16,7 @@
 
 #include <linux/init.h>
 #include <linux/pnp.h>
+#include <linux/module.h>
 #include <linux/ide.h>
 
 #define DRV_NAME "ide-pnp"
Index: linux/drivers/ide/tc86c001.c
===================================================================
--- linux.orig/drivers/ide/tc86c001.c
+++ linux/drivers/ide/tc86c001.c
@@ -10,6 +10,7 @@
 #include <linux/types.h>
 #include <linux/pci.h>
 #include <linux/ide.h>
+#include <linux/module.h>
 
 #define DRV_NAME "tc86c001"
 
Index: linux/drivers/idle/intel_idle.c
===================================================================
--- linux.orig/drivers/idle/intel_idle.c
+++ linux/drivers/idle/intel_idle.c
@@ -61,6 +61,7 @@
 #include <linux/sched.h>
 #include <linux/notifier.h>
 #include <linux/cpu.h>
+#include <linux/module.h>
 #include <asm/mwait.h>
 #include <asm/msr.h>
 
Index: linux/drivers/infiniband/hw/ipath/ipath_diag.c
===================================================================
--- linux.orig/drivers/infiniband/hw/ipath/ipath_diag.c
+++ linux/drivers/infiniband/hw/ipath/ipath_diag.c
@@ -45,6 +45,7 @@
 #include <linux/pci.h>
 #include <linux/vmalloc.h>
 #include <linux/fs.h>
+#include <linux/module.h>
 #include <asm/uaccess.h>
 
 #include "ipath_kernel.h"
Index: linux/drivers/infiniband/hw/ipath/ipath_file_ops.c
===================================================================
--- linux.orig/drivers/infiniband/hw/ipath/ipath_file_ops.c
+++ linux/drivers/infiniband/hw/ipath/ipath_file_ops.c
@@ -40,6 +40,8 @@
 #include <linux/highmem.h>
 #include <linux/io.h>
 #include <linux/jiffies.h>
+#include <linux/module.h>
+
 #include <asm/pgtable.h>
 
 #include "ipath_kernel.h"
Index: linux/drivers/infiniband/hw/ipath/ipath_sysfs.c
===================================================================
--- linux.orig/drivers/infiniband/hw/ipath/ipath_sysfs.c
+++ linux/drivers/infiniband/hw/ipath/ipath_sysfs.c
@@ -32,6 +32,7 @@
  */
 
 #include <linux/ctype.h>
+#include <linux/stat.h>
 
 #include "ipath_kernel.h"
 #include "ipath_verbs.h"
Index: linux/drivers/infiniband/hw/ipath/ipath_verbs.c
===================================================================
--- linux.orig/drivers/infiniband/hw/ipath/ipath_verbs.c
+++ linux/drivers/infiniband/hw/ipath/ipath_verbs.c
@@ -37,6 +37,7 @@
 #include <linux/slab.h>
 #include <linux/utsname.h>
 #include <linux/rculist.h>
+#include <linux/module.h>
 
 #include "ipath_kernel.h"
 #include "ipath_verbs.h"
Index: linux/drivers/infiniband/hw/qib/qib_diag.c
===================================================================
--- linux.orig/drivers/infiniband/hw/qib/qib_diag.c
+++ linux/drivers/infiniband/hw/qib/qib_diag.c
@@ -48,6 +48,7 @@
 #include <linux/vmalloc.h>
 #include <linux/fs.h>
 #include <linux/uaccess.h>
+#include <linux/module.h>
 
 #include "qib.h"
 #include "qib_common.h"
Index: linux/drivers/infiniband/hw/qib/qib_file_ops.c
===================================================================
--- linux.orig/drivers/infiniband/hw/qib/qib_file_ops.c
+++ linux/drivers/infiniband/hw/qib/qib_file_ops.c
@@ -43,6 +43,7 @@
 #include <linux/jiffies.h>
 #include <asm/pgtable.h>
 #include <linux/delay.h>
+#include <linux/module.h>
 
 #include "qib.h"
 #include "qib_common.h"
Index: linux/drivers/infiniband/hw/qib/qib_iba7220.c
===================================================================
--- linux.orig/drivers/infiniband/hw/qib/qib_iba7220.c
+++ linux/drivers/infiniband/hw/qib/qib_iba7220.c
@@ -38,6 +38,7 @@
 
 #include <linux/interrupt.h>
 #include <linux/pci.h>
+#include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/io.h>
 #include <rdma/ib_verbs.h>
Index: linux/drivers/infiniband/hw/qib/qib_iba7322.c
===================================================================
--- linux.orig/drivers/infiniband/hw/qib/qib_iba7322.c
+++ linux/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -37,6 +37,7 @@
 
 #include <linux/interrupt.h>
 #include <linux/pci.h>
+#include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/io.h>
 #include <linux/jiffies.h>
Index: linux/drivers/infiniband/hw/qib/qib_pcie.c
===================================================================
--- linux.orig/drivers/infiniband/hw/qib/qib_pcie.c
+++ linux/drivers/infiniband/hw/qib/qib_pcie.c
@@ -32,6 +32,7 @@
 
 #include <linux/pci.h>
 #include <linux/io.h>
+#include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/vmalloc.h>
 #include <linux/aer.h>
Index: linux/drivers/infiniband/hw/qib/qib_sd7220.c
===================================================================
--- linux.orig/drivers/infiniband/hw/qib/qib_sd7220.c
+++ linux/drivers/infiniband/hw/qib/qib_sd7220.c
@@ -38,6 +38,7 @@
 
 #include <linux/pci.h>
 #include <linux/delay.h>
+#include <linux/module.h>
 #include <linux/firmware.h>
 
 #include "qib.h"
Index: linux/drivers/infiniband/hw/qib/qib_verbs.c
===================================================================
--- linux.orig/drivers/infiniband/hw/qib/qib_verbs.c
+++ linux/drivers/infiniband/hw/qib/qib_verbs.c
@@ -38,6 +38,7 @@
 #include <linux/utsname.h>
 #include <linux/rculist.h>
 #include <linux/mm.h>
+#include <linux/module.h>
 
 #include "qib.h"
 #include "qib_common.h"
Index: linux/drivers/input/joystick/as5011.c
===================================================================
--- linux.orig/drivers/input/joystick/as5011.c
+++ linux/drivers/input/joystick/as5011.c
@@ -30,6 +30,7 @@
 #include <linux/delay.h>
 #include <linux/input/as5011.h>
 #include <linux/slab.h>
+#include <linux/module.h>
 
 #define DRIVER_DESC "Driver for Austria Microsystems AS5011 joystick"
 #define MODULE_DEVICE_ALIAS "as5011"
Index: linux/drivers/input/misc/ad714x.c
===================================================================
--- linux.orig/drivers/input/misc/ad714x.c
+++ linux/drivers/input/misc/ad714x.c
@@ -12,6 +12,7 @@
 #include <linux/interrupt.h>
 #include <linux/slab.h>
 #include <linux/input/ad714x.h>
+#include <linux/module.h>
 #include "ad714x.h"
 
 #define AD714X_PWR_CTRL           0x0
Index: linux/drivers/input/misc/adxl34x.c
===================================================================
--- linux.orig/drivers/input/misc/adxl34x.c
+++ linux/drivers/input/misc/adxl34x.c
@@ -16,6 +16,7 @@
 #include <linux/slab.h>
 #include <linux/workqueue.h>
 #include <linux/input/adxl34x.h>
+#include <linux/module.h>
 
 #include "adxl34x.h"
 
Index: linux/drivers/input/misc/ati_remote2.c
===================================================================
--- linux.orig/drivers/input/misc/ati_remote2.c
+++ linux/drivers/input/misc/ati_remote2.c
@@ -11,6 +11,7 @@
 
 #include <linux/usb/input.h>
 #include <linux/slab.h>
+#include <linux/module.h>
 
 #define DRIVER_DESC    "ATI/Philips USB RF remote driver"
 #define DRIVER_VERSION "0.3"
Index: linux/drivers/input/misc/cma3000_d0x.c
===================================================================
--- linux.orig/drivers/input/misc/cma3000_d0x.c
+++ linux/drivers/input/misc/cma3000_d0x.c
@@ -23,6 +23,7 @@
 #include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/input/cma3000.h>
+#include <linux/module.h>
 
 #include "cma3000_d0x.h"
 
Index: linux/drivers/input/touchscreen/ad7877.c
===================================================================
--- linux.orig/drivers/input/touchscreen/ad7877.c
+++ linux/drivers/input/touchscreen/ad7877.c
@@ -45,6 +45,7 @@
 #include <linux/slab.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/ad7877.h>
+#include <linux/module.h>
 #include <asm/irq.h>
 
 #define	TS_PEN_UP_TIMEOUT	msecs_to_jiffies(100)
Index: linux/drivers/input/touchscreen/ad7879-spi.c
===================================================================
--- linux.orig/drivers/input/touchscreen/ad7879-spi.c
+++ linux/drivers/input/touchscreen/ad7879-spi.c
@@ -9,6 +9,7 @@
 #include <linux/input.h>	/* BUS_SPI */
 #include <linux/pm.h>
 #include <linux/spi/spi.h>
+#include <linux/module.h>
 
 #include "ad7879.h"
 
Index: linux/drivers/input/touchscreen/ad7879.c
===================================================================
--- linux.orig/drivers/input/touchscreen/ad7879.c
+++ linux/drivers/input/touchscreen/ad7879.c
@@ -31,6 +31,7 @@
 #include <linux/spi/spi.h>
 #include <linux/i2c.h>
 #include <linux/gpio.h>
+#include <linux/module.h>
 
 #include <linux/spi/ad7879.h>
 #include "ad7879.h"
Index: linux/drivers/input/touchscreen/ads7846.c
===================================================================
--- linux.orig/drivers/input/touchscreen/ads7846.c
+++ linux/drivers/input/touchscreen/ads7846.c
@@ -31,6 +31,7 @@
 #include <linux/spi/spi.h>
 #include <linux/spi/ads7846.h>
 #include <linux/regulator/consumer.h>
+#include <linux/module.h>
 #include <asm/irq.h>
 
 /*
Index: linux/drivers/input/touchscreen/bu21013_ts.c
===================================================================
--- linux.orig/drivers/input/touchscreen/bu21013_ts.c
+++ linux/drivers/input/touchscreen/bu21013_ts.c
@@ -13,6 +13,7 @@
 #include <linux/input/bu21013.h>
 #include <linux/slab.h>
 #include <linux/regulator/consumer.h>
+#include <linux/module.h>
 
 #define PEN_DOWN_INTR	0
 #define MAX_FINGERS	2
Index: linux/drivers/isdn/capi/kcapi_proc.c
===================================================================
--- linux.orig/drivers/isdn/capi/kcapi_proc.c
+++ linux/drivers/isdn/capi/kcapi_proc.c
@@ -14,6 +14,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/init.h>
+#include <linux/module.h>
 
 static char *state2str(unsigned short state)
 {
Index: linux/drivers/leds/dell-led.c
===================================================================
--- linux.orig/drivers/leds/dell-led.c
+++ linux/drivers/leds/dell-led.c
@@ -13,6 +13,7 @@
 
 #include <linux/acpi.h>
 #include <linux/leds.h>
+#include <linux/module.h>
 #include <linux/slab.h>
 
 MODULE_AUTHOR("Louis Davis/Jim Dailey");
Index: linux/drivers/leds/leds-88pm860x.c
===================================================================
--- linux.orig/drivers/leds/leds-88pm860x.c
+++ linux/drivers/leds/leds-88pm860x.c
@@ -19,6 +19,7 @@
 #include <linux/workqueue.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/88pm860x.h>
+#include <linux/module.h>
 
 #define LED_PWM_SHIFT		(3)
 #define LED_PWM_MASK		(0x1F)
Index: linux/drivers/leds/leds-gpio.c
===================================================================
--- linux.orig/drivers/leds/leds-gpio.c
+++ linux/drivers/leds/leds-gpio.c
@@ -18,6 +18,7 @@
 #include <linux/of_gpio.h>
 #include <linux/slab.h>
 #include <linux/workqueue.h>
+#include <linux/module.h>
 
 #include <asm/gpio.h>
 
Index: linux/drivers/leds/leds-lm3530.c
===================================================================
--- linux.orig/drivers/leds/leds-lm3530.c
+++ linux/drivers/leds/leds-lm3530.c
@@ -17,6 +17,7 @@
 #include <linux/input.h>
 #include <linux/led-lm3530.h>
 #include <linux/types.h>
+#include <linux/module.h>
 
 #define LM3530_LED_DEV "lcd-backlight"
 #define LM3530_NAME "lm3530-led"
Index: linux/drivers/leds/leds-lt3593.c
===================================================================
--- linux.orig/drivers/leds/leds-lt3593.c
+++ linux/drivers/leds/leds-lt3593.c
@@ -18,6 +18,7 @@
 
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/leds.h>
 #include <linux/workqueue.h>
Index: linux/drivers/leds/leds-net48xx.c
===================================================================
--- linux.orig/drivers/leds/leds-net48xx.c
+++ linux/drivers/leds/leds-net48xx.c
@@ -12,6 +12,7 @@
 
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/leds.h>
 #include <linux/err.h>
Index: linux/drivers/leds/leds-net5501.c
===================================================================
--- linux.orig/drivers/leds/leds-net5501.c
+++ linux/drivers/leds/leds-net5501.c
@@ -10,6 +10,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/init.h>
 #include <linux/io.h>
 #include <linux/string.h>
Index: linux/drivers/leds/leds-wm831x-status.c
===================================================================
--- linux.orig/drivers/leds/leds-wm831x-status.c
+++ linux/drivers/leds/leds-wm831x-status.c
@@ -11,6 +11,7 @@
 
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/leds.h>
Index: linux/drivers/leds/leds-wm8350.c
===================================================================
--- linux.orig/drivers/leds/leds-wm8350.c
+++ linux/drivers/leds/leds-wm8350.c
@@ -11,6 +11,7 @@
 
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/leds.h>
 #include <linux/err.h>
Index: linux/drivers/leds/leds-wrap.c
===================================================================
--- linux.orig/drivers/leds/leds-wrap.c
+++ linux/drivers/leds/leds-wrap.c
@@ -12,6 +12,7 @@
 
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/leds.h>
 #include <linux/err.h>
Index: linux/drivers/lguest/lguest_device.c
===================================================================
--- linux.orig/drivers/lguest/lguest_device.c
+++ linux/drivers/lguest/lguest_device.c
@@ -9,6 +9,7 @@
 :*/
 #include <linux/init.h>
 #include <linux/bootmem.h>
+#include <linux/module.h>
 #include <linux/lguest_launcher.h>
 #include <linux/virtio.h>
 #include <linux/virtio_config.h>
Index: linux/drivers/md/dm-log-userspace-base.c
===================================================================
--- linux.orig/drivers/md/dm-log-userspace-base.c
+++ linux/drivers/md/dm-log-userspace-base.c
@@ -9,6 +9,7 @@
 #include <linux/dm-dirty-log.h>
 #include <linux/device-mapper.h>
 #include <linux/dm-log-userspace.h>
+#include <linux/module.h>
 
 #include "dm-log-userspace-transfer.h"
 
Index: linux/drivers/md/dm-raid.c
===================================================================
--- linux.orig/drivers/md/dm-raid.c
+++ linux/drivers/md/dm-raid.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/slab.h>
+#include <linux/module.h>
 
 #include "md.h"
 #include "raid5.h"
Index: linux/drivers/md/dm-service-time.c
===================================================================
--- linux.orig/drivers/md/dm-service-time.c
+++ linux/drivers/md/dm-service-time.c
@@ -12,6 +12,7 @@
 #include "dm-path-selector.h"
 
 #include <linux/slab.h>
+#include <linux/module.h>
 
 #define DM_MSG_PREFIX	"multipath service-time"
 #define ST_MIN_IO	1
Index: linux/drivers/md/dm-uevent.c
===================================================================
--- linux.orig/drivers/md/dm-uevent.c
+++ linux/drivers/md/dm-uevent.c
@@ -22,6 +22,7 @@
 #include <linux/slab.h>
 #include <linux/kobject.h>
 #include <linux/dm-ioctl.h>
+#include <linux/module.h>
 
 #include "dm.h"
 #include "dm-uevent.h"
Index: linux/drivers/media/common/saa7146_core.c
===================================================================
--- linux.orig/drivers/media/common/saa7146_core.c
+++ linux/drivers/media/common/saa7146_core.c
@@ -19,6 +19,7 @@
 */
 
 #include <media/saa7146.h>
+#include <linux/module.h>
 
 LIST_HEAD(saa7146_devices);
 DEFINE_MUTEX(saa7146_devices_lock);
Index: linux/drivers/media/common/saa7146_fops.c
===================================================================
--- linux.orig/drivers/media/common/saa7146_fops.c
+++ linux/drivers/media/common/saa7146_fops.c
@@ -1,4 +1,5 @@
 #include <media/saa7146_vv.h>
+#include <linux/module.h>
 
 /****************************************************************************/
 /* resource management functions, shamelessly stolen from saa7134 driver */
Index: linux/drivers/media/common/saa7146_hlp.c
===================================================================
--- linux.orig/drivers/media/common/saa7146_hlp.c
+++ linux/drivers/media/common/saa7146_hlp.c
@@ -1,4 +1,5 @@
 #include <linux/kernel.h>
+#include <linux/module.h>
 #include <media/saa7146_vv.h>
 
 static void calculate_output_format_register(struct saa7146_dev* saa, u32 palette, u32* clip_format)
Index: linux/drivers/media/common/saa7146_video.c
===================================================================
--- linux.orig/drivers/media/common/saa7146_video.c
+++ linux/drivers/media/common/saa7146_video.c
@@ -1,4 +1,5 @@
 #include <media/saa7146_vv.h>
+#include <linux/module.h>
 #include <media/v4l2-chip-ident.h>
 
 static int max_memory = 32;
Index: linux/drivers/media/common/tuners/tuner-types.c
===================================================================
--- linux.orig/drivers/media/common/tuners/tuner-types.c
+++ linux/drivers/media/common/tuners/tuner-types.c
@@ -5,6 +5,7 @@
  */
 
 #include <linux/i2c.h>
+#include <linux/module.h>
 #include <media/tuner.h>
 #include <media/tuner-types.h>
 
Index: linux/drivers/media/dvb/frontends/dibx000_common.c
===================================================================
--- linux.orig/drivers/media/dvb/frontends/dibx000_common.c
+++ linux/drivers/media/dvb/frontends/dibx000_common.c
@@ -1,4 +1,5 @@
 #include <linux/i2c.h>
+#include <linux/module.h>
 
 #include "dibx000_common.h"
 
Index: linux/drivers/media/dvb/siano/sms-cards.c
===================================================================
--- linux.orig/drivers/media/dvb/siano/sms-cards.c
+++ linux/drivers/media/dvb/siano/sms-cards.c
@@ -17,6 +17,7 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include <linux/module.h>
 #include "sms-cards.h"
 #include "smsir.h"
 
Index: linux/drivers/media/dvb/siano/smsendian.c
===================================================================
--- linux.orig/drivers/media/dvb/siano/smsendian.c
+++ linux/drivers/media/dvb/siano/smsendian.c
@@ -19,6 +19,7 @@
 
  ****************************************************************/
 
+#include <linux/module.h>
 #include <asm/byteorder.h>
 
 #include "smsendian.h"
Index: linux/drivers/media/dvb/siano/smssdio.c
===================================================================
--- linux.orig/drivers/media/dvb/siano/smssdio.c
+++ linux/drivers/media/dvb/siano/smssdio.c
@@ -39,6 +39,7 @@
 #include <linux/mmc/card.h>
 #include <linux/mmc/sdio_func.h>
 #include <linux/mmc/sdio_ids.h>
+#include <linux/module.h>
 
 #include "smscoreapi.h"
 #include "sms-cards.h"
Index: linux/drivers/media/dvb/siano/smsusb.c
===================================================================
--- linux.orig/drivers/media/dvb/siano/smsusb.c
+++ linux/drivers/media/dvb/siano/smsusb.c
@@ -24,6 +24,7 @@ along with this program.  If not, see <h
 #include <linux/usb.h>
 #include <linux/firmware.h>
 #include <linux/slab.h>
+#include <linux/module.h>
 
 #include "smscoreapi.h"
 #include "sms-cards.h"
Index: linux/drivers/media/media-device.c
===================================================================
--- linux.orig/drivers/media/media-device.c
+++ linux/drivers/media/media-device.c
@@ -23,6 +23,7 @@
 #include <linux/types.h>
 #include <linux/ioctl.h>
 #include <linux/media.h>
+#include <linux/module.h>
 
 #include <media/media-device.h>
 #include <media/media-devnode.h>
Index: linux/drivers/media/radio/radio-timb.c
===================================================================
--- linux.orig/drivers/media/radio/radio-timb.c
+++ linux/drivers/media/radio/radio-timb.c
@@ -17,6 +17,7 @@
  */
 
 #include <linux/version.h>
+#include <linux/module.h>
 #include <linux/io.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-device.h>
Index: linux/drivers/media/radio/radio-wl1273.c
===================================================================
--- linux.orig/drivers/media/radio/radio-wl1273.c
+++ linux/drivers/media/radio/radio-wl1273.c
@@ -23,6 +23,7 @@
 #include <linux/interrupt.h>
 #include <linux/mfd/wl1273-core.h>
 #include <linux/slab.h>
+#include <linux/module.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
Index: linux/drivers/media/radio/si4713-i2c.c
===================================================================
--- linux.orig/drivers/media/radio/si4713-i2c.c
+++ linux/drivers/media/radio/si4713-i2c.c
@@ -29,6 +29,7 @@
 #include <linux/slab.h>
 #include <linux/gpio.h>
 #include <linux/regulator/consumer.h>
+#include <linux/module.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-common.h>
Index: linux/drivers/media/radio/wl128x/fmdrv_v4l2.c
===================================================================
--- linux.orig/drivers/media/radio/wl128x/fmdrv_v4l2.c
+++ linux/drivers/media/radio/wl128x/fmdrv_v4l2.c
@@ -28,6 +28,7 @@
  *
  */
 
+#include <linux/module.h>
 #include "fmdrv.h"
 #include "fmdrv_v4l2.h"
 #include "fmdrv_common.h"
Index: linux/drivers/media/rc/ir-jvc-decoder.c
===================================================================
--- linux.orig/drivers/media/rc/ir-jvc-decoder.c
+++ linux/drivers/media/rc/ir-jvc-decoder.c
@@ -13,6 +13,7 @@
  */
 
 #include <linux/bitrev.h>
+#include <linux/module.h>
 #include "rc-core-priv.h"
 
 #define JVC_NBITS		16		/* dev(8) + func(8) */
Index: linux/drivers/media/rc/ir-lirc-codec.c
===================================================================
--- linux.orig/drivers/media/rc/ir-lirc-codec.c
+++ linux/drivers/media/rc/ir-lirc-codec.c
@@ -14,6 +14,7 @@
 
 #include <linux/sched.h>
 #include <linux/wait.h>
+#include <linux/module.h>
 #include <media/lirc.h>
 #include <media/lirc_dev.h>
 #include <media/rc-core.h>
Index: linux/drivers/media/rc/ir-nec-decoder.c
===================================================================
--- linux.orig/drivers/media/rc/ir-nec-decoder.c
+++ linux/drivers/media/rc/ir-nec-decoder.c
@@ -13,6 +13,7 @@
  */
 
 #include <linux/bitrev.h>
+#include <linux/module.h>
 #include "rc-core-priv.h"
 
 #define NEC_NBITS		32
Index: linux/drivers/media/rc/ir-raw.c
===================================================================
--- linux.orig/drivers/media/rc/ir-raw.c
+++ linux/drivers/media/rc/ir-raw.c
@@ -16,6 +16,7 @@
 #include <linux/mutex.h>
 #include <linux/sched.h>
 #include <linux/freezer.h>
+#include <linux/module.h>
 #include "rc-core-priv.h"
 
 /* Define the max number of pulse/space transitions to buffer */
Index: linux/drivers/media/rc/ir-rc5-decoder.c
===================================================================
--- linux.orig/drivers/media/rc/ir-rc5-decoder.c
+++ linux/drivers/media/rc/ir-rc5-decoder.c
@@ -21,6 +21,7 @@
  */
 
 #include "rc-core-priv.h"
+#include <linux/module.h>
 
 #define RC5_NBITS		14
 #define RC5X_NBITS		20
Index: linux/drivers/media/rc/ir-rc5-sz-decoder.c
===================================================================
--- linux.orig/drivers/media/rc/ir-rc5-sz-decoder.c
+++ linux/drivers/media/rc/ir-rc5-sz-decoder.c
@@ -21,6 +21,7 @@
  */
 
 #include "rc-core-priv.h"
+#include <linux/module.h>
 
 #define RC5_SZ_NBITS		15
 #define RC5_UNIT		888888 /* ns */
Index: linux/drivers/media/rc/ir-rc6-decoder.c
===================================================================
--- linux.orig/drivers/media/rc/ir-rc6-decoder.c
+++ linux/drivers/media/rc/ir-rc6-decoder.c
@@ -13,6 +13,7 @@
  */
 
 #include "rc-core-priv.h"
+#include <linux/module.h>
 
 /*
  * This decoder currently supports:
Index: linux/drivers/media/rc/ir-sony-decoder.c
===================================================================
--- linux.orig/drivers/media/rc/ir-sony-decoder.c
+++ linux/drivers/media/rc/ir-sony-decoder.c
@@ -13,6 +13,7 @@
  */
 
 #include <linux/bitrev.h>
+#include <linux/module.h>
 #include "rc-core-priv.h"
 
 #define SONY_UNIT		600000 /* ns */
Index: linux/drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c
+++ linux/drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /* ADS Tech Instant TV DVB-T PCI Remote */
 
Index: linux/drivers/media/rc/keymaps/rc-alink-dtu-m.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-alink-dtu-m.c
+++ linux/drivers/media/rc/keymaps/rc-alink-dtu-m.c
@@ -19,6 +19,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /* A-Link DTU(m) slim remote, 6 rows, 3 columns. */
 static struct rc_map_table alink_dtu_m[] = {
Index: linux/drivers/media/rc/keymaps/rc-anysee.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-anysee.c
+++ linux/drivers/media/rc/keymaps/rc-anysee.c
@@ -19,6 +19,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 static struct rc_map_table anysee[] = {
 	{ 0x0800, KEY_0 },
Index: linux/drivers/media/rc/keymaps/rc-apac-viewcomp.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-apac-viewcomp.c
+++ linux/drivers/media/rc/keymaps/rc-apac-viewcomp.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /* Attila Kondoros <attila.kondoros@chello.hu> */
 
Index: linux/drivers/media/rc/keymaps/rc-asus-pc39.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-asus-pc39.c
+++ linux/drivers/media/rc/keymaps/rc-asus-pc39.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /*
  * Marc Fargas <telenieko@telenieko.com>
Index: linux/drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c
+++ linux/drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /* ATI TV Wonder HD 600 USB
    Devin Heitmueller <devin.heitmueller@gmail.com>
Index: linux/drivers/media/rc/keymaps/rc-avermedia-a16d.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-avermedia-a16d.c
+++ linux/drivers/media/rc/keymaps/rc-avermedia-a16d.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 static struct rc_map_table avermedia_a16d[] = {
 	{ 0x20, KEY_LIST},
Index: linux/drivers/media/rc/keymaps/rc-avermedia-cardbus.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-avermedia-cardbus.c
+++ linux/drivers/media/rc/keymaps/rc-avermedia-cardbus.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /* Oldrich Jedlicka <oldium.pro@seznam.cz> */
 
Index: linux/drivers/media/rc/keymaps/rc-avermedia-dvbt.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-avermedia-dvbt.c
+++ linux/drivers/media/rc/keymaps/rc-avermedia-dvbt.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /* Matt Jesson <dvb@jesson.eclipse.co.uk */
 
Index: linux/drivers/media/rc/keymaps/rc-avermedia-m135a.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-avermedia-m135a.c
+++ linux/drivers/media/rc/keymaps/rc-avermedia-m135a.c
@@ -10,6 +10,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /*
  * Avermedia M135A with RM-JX and RM-K6 remote controls
Index: linux/drivers/media/rc/keymaps/rc-avermedia-m733a-rm-k6.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-avermedia-m733a-rm-k6.c
+++ linux/drivers/media/rc/keymaps/rc-avermedia-m733a-rm-k6.c
@@ -9,6 +9,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /*
  * Avermedia M733A with IR model RM-K6
Index: linux/drivers/media/rc/keymaps/rc-avermedia-rm-ks.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-avermedia-rm-ks.c
+++ linux/drivers/media/rc/keymaps/rc-avermedia-rm-ks.c
@@ -19,6 +19,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /* Initial keytable is from Jose Alberto Reguero <jareguero@telefonica.net>
    and Felipe Morales Moreno <felipe.morales.moreno@gmail.com> */
Index: linux/drivers/media/rc/keymaps/rc-avermedia.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-avermedia.c
+++ linux/drivers/media/rc/keymaps/rc-avermedia.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /* Alex Hermann <gaaf@gmx.net> */
 
Index: linux/drivers/media/rc/keymaps/rc-avertv-303.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-avertv-303.c
+++ linux/drivers/media/rc/keymaps/rc-avertv-303.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /* AVERTV STUDIO 303 Remote */
 
Index: linux/drivers/media/rc/keymaps/rc-azurewave-ad-tu700.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-azurewave-ad-tu700.c
+++ linux/drivers/media/rc/keymaps/rc-azurewave-ad-tu700.c
@@ -19,6 +19,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 static struct rc_map_table azurewave_ad_tu700[] = {
 	{ 0x0000, KEY_TAB },             /* Tab */
Index: linux/drivers/media/rc/keymaps/rc-behold-columbus.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-behold-columbus.c
+++ linux/drivers/media/rc/keymaps/rc-behold-columbus.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /* Beholder Intl. Ltd. 2008
  * Dmitry Belimov d.belimov@google.com
Index: linux/drivers/media/rc/keymaps/rc-behold.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-behold.c
+++ linux/drivers/media/rc/keymaps/rc-behold.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /*
  * Igor Kuznetsov <igk72@ya.ru>
Index: linux/drivers/media/rc/keymaps/rc-budget-ci-old.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-budget-ci-old.c
+++ linux/drivers/media/rc/keymaps/rc-budget-ci-old.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /*
  * From reading the following remotes:
Index: linux/drivers/media/rc/keymaps/rc-cinergy-1400.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-cinergy-1400.c
+++ linux/drivers/media/rc/keymaps/rc-cinergy-1400.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /* Cinergy 1400 DVB-T */
 
Index: linux/drivers/media/rc/keymaps/rc-cinergy.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-cinergy.c
+++ linux/drivers/media/rc/keymaps/rc-cinergy.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 static struct rc_map_table cinergy[] = {
 	{ 0x00, KEY_0 },
Index: linux/drivers/media/rc/keymaps/rc-dib0700-nec.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-dib0700-nec.c
+++ linux/drivers/media/rc/keymaps/rc-dib0700-nec.c
@@ -16,6 +16,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 static struct rc_map_table dib0700_nec_table[] = {
 	/* Key codes for the Pixelview SBTVD remote */
Index: linux/drivers/media/rc/keymaps/rc-em-terratec.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-em-terratec.c
+++ linux/drivers/media/rc/keymaps/rc-em-terratec.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 static struct rc_map_table em_terratec[] = {
 	{ 0x01, KEY_CHANNEL },
Index: linux/drivers/media/rc/keymaps/rc-encore-enltv-fm53.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-encore-enltv-fm53.c
+++ linux/drivers/media/rc/keymaps/rc-encore-enltv-fm53.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /* Encore ENLTV-FM v5.3
    Mauro Carvalho Chehab <mchehab@infradead.org>
Index: linux/drivers/media/rc/keymaps/rc-encore-enltv.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-encore-enltv.c
+++ linux/drivers/media/rc/keymaps/rc-encore-enltv.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /* Encore ENLTV-FM  - black plastic, white front cover with white glowing buttons
     Juan Pablo Sormani <sorman@gmail.com> */
Index: linux/drivers/media/rc/keymaps/rc-encore-enltv2.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-encore-enltv2.c
+++ linux/drivers/media/rc/keymaps/rc-encore-enltv2.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /* Encore ENLTV2-FM  - silver plastic - "Wand Media" written at the botton
     Mauro Carvalho Chehab <mchehab@infradead.org> */
Index: linux/drivers/media/rc/keymaps/rc-evga-indtube.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-evga-indtube.c
+++ linux/drivers/media/rc/keymaps/rc-evga-indtube.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /* EVGA inDtube
    Devin Heitmueller <devin.heitmueller@gmail.com>
Index: linux/drivers/media/rc/keymaps/rc-eztv.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-eztv.c
+++ linux/drivers/media/rc/keymaps/rc-eztv.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /* Alfons Geser <a.geser@cox.net>
  * updates from Job D. R. Borges <jobdrb@ig.com.br> */
Index: linux/drivers/media/rc/keymaps/rc-flydvb.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-flydvb.c
+++ linux/drivers/media/rc/keymaps/rc-flydvb.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 static struct rc_map_table flydvb[] = {
 	{ 0x01, KEY_ZOOM },		/* Full Screen */
Index: linux/drivers/media/rc/keymaps/rc-flyvideo.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-flyvideo.c
+++ linux/drivers/media/rc/keymaps/rc-flyvideo.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 static struct rc_map_table flyvideo[] = {
 	{ 0x0f, KEY_0 },
Index: linux/drivers/media/rc/keymaps/rc-fusionhdtv-mce.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-fusionhdtv-mce.c
+++ linux/drivers/media/rc/keymaps/rc-fusionhdtv-mce.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /* DViCO FUSION HDTV MCE remote */
 
Index: linux/drivers/media/rc/keymaps/rc-gadmei-rm008z.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-gadmei-rm008z.c
+++ linux/drivers/media/rc/keymaps/rc-gadmei-rm008z.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /* GADMEI UTV330+ RM008Z remote
    Shine Liu <shinel@foxmail.com>
Index: linux/drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c
+++ linux/drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /*
  * Remote control for the Genius TVGO A11MCE
Index: linux/drivers/media/rc/keymaps/rc-gotview7135.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-gotview7135.c
+++ linux/drivers/media/rc/keymaps/rc-gotview7135.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /* Mike Baikov <mike@baikov.com> */
 
Index: linux/drivers/media/rc/keymaps/rc-hauppauge.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-hauppauge.c
+++ linux/drivers/media/rc/keymaps/rc-hauppauge.c
@@ -17,6 +17,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /*
  * Hauppauge:the newer, gray remotes (seems there are multiple
Index: linux/drivers/media/rc/keymaps/rc-imon-mce.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-imon-mce.c
+++ linux/drivers/media/rc/keymaps/rc-imon-mce.c
@@ -10,6 +10,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /* mce-mode imon mce remote key table */
 static struct rc_map_table imon_mce[] = {
Index: linux/drivers/media/rc/keymaps/rc-imon-pad.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-imon-pad.c
+++ linux/drivers/media/rc/keymaps/rc-imon-pad.c
@@ -10,6 +10,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /*
  * standard imon remote key table, which isn't really entirely
Index: linux/drivers/media/rc/keymaps/rc-iodata-bctv7e.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-iodata-bctv7e.c
+++ linux/drivers/media/rc/keymaps/rc-iodata-bctv7e.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /* IO-DATA BCTV7E Remote */
 
Index: linux/drivers/media/rc/keymaps/rc-kaiomy.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-kaiomy.c
+++ linux/drivers/media/rc/keymaps/rc-kaiomy.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /* Kaiomy TVnPC U2
    Mauro Carvalho Chehab <mchehab@infradead.org>
Index: linux/drivers/media/rc/keymaps/rc-kworld-315u.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-kworld-315u.c
+++ linux/drivers/media/rc/keymaps/rc-kworld-315u.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /* Kworld 315U
  */
Index: linux/drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c
+++ linux/drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /* Kworld Plus TV Analog Lite PCI IR
    Mauro Carvalho Chehab <mchehab@infradead.org>
Index: linux/drivers/media/rc/keymaps/rc-leadtek-y04g0051.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-leadtek-y04g0051.c
+++ linux/drivers/media/rc/keymaps/rc-leadtek-y04g0051.c
@@ -19,6 +19,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 static struct rc_map_table leadtek_y04g0051[] = {
 	{ 0x0300, KEY_POWER2 },
Index: linux/drivers/media/rc/keymaps/rc-lirc.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-lirc.c
+++ linux/drivers/media/rc/keymaps/rc-lirc.c
@@ -10,6 +10,7 @@
  */
 
 #include <media/rc-core.h>
+#include <linux/module.h>
 
 static struct rc_map_table lirc[] = {
 	{ },
Index: linux/drivers/media/rc/keymaps/rc-lme2510.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-lme2510.c
+++ linux/drivers/media/rc/keymaps/rc-lme2510.c
@@ -10,6 +10,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 
 static struct rc_map_table lme2510_rc[] = {
Index: linux/drivers/media/rc/keymaps/rc-manli.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-manli.c
+++ linux/drivers/media/rc/keymaps/rc-manli.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /* Michael Tokarev <mjt@tls.msk.ru>
    keytable is used by MANLI MTV00[0x0c] and BeholdTV 40[13] at
Index: linux/drivers/media/rc/keymaps/rc-msi-digivox-ii.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-msi-digivox-ii.c
+++ linux/drivers/media/rc/keymaps/rc-msi-digivox-ii.c
@@ -19,6 +19,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 static struct rc_map_table msi_digivox_ii[] = {
 	{ 0x0002, KEY_2 },
Index: linux/drivers/media/rc/keymaps/rc-msi-digivox-iii.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-msi-digivox-iii.c
+++ linux/drivers/media/rc/keymaps/rc-msi-digivox-iii.c
@@ -19,6 +19,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /* MSI DIGIVOX mini III */
 /* Uses NEC extended 0x61d6. */
Index: linux/drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c
+++ linux/drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /*
   Keycodes for remote on the MSI TV@nywhere Plus. The controller IC on the card
Index: linux/drivers/media/rc/keymaps/rc-msi-tvanywhere.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-msi-tvanywhere.c
+++ linux/drivers/media/rc/keymaps/rc-msi-tvanywhere.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /* MSI TV@nywhere MASTER remote */
 
Index: linux/drivers/media/rc/keymaps/rc-nebula.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-nebula.c
+++ linux/drivers/media/rc/keymaps/rc-nebula.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 static struct rc_map_table nebula[] = {
 	{ 0x00, KEY_0 },
Index: linux/drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c
+++ linux/drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /* Terratec Cinergy Hybrid T USB XS FM
    Mauro Carvalho Chehab <mchehab@redhat.com>
Index: linux/drivers/media/rc/keymaps/rc-norwood.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-norwood.c
+++ linux/drivers/media/rc/keymaps/rc-norwood.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /* Norwood Micro (non-Pro) TV Tuner
    By Peter Naulls <peter@chocky.org>
Index: linux/drivers/media/rc/keymaps/rc-npgtech.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-npgtech.c
+++ linux/drivers/media/rc/keymaps/rc-npgtech.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 static struct rc_map_table npgtech[] = {
 	{ 0x1d, KEY_SWITCHVIDEOMODE },	/* switch inputs */
Index: linux/drivers/media/rc/keymaps/rc-pctv-sedna.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-pctv-sedna.c
+++ linux/drivers/media/rc/keymaps/rc-pctv-sedna.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /* Mapping for the 28 key remote control as seen at
    http://www.sednacomputer.com/photo/cardbus-tv.jpg
Index: linux/drivers/media/rc/keymaps/rc-pinnacle-color.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-pinnacle-color.c
+++ linux/drivers/media/rc/keymaps/rc-pinnacle-color.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 static struct rc_map_table pinnacle_color[] = {
 	{ 0x59, KEY_MUTE },
Index: linux/drivers/media/rc/keymaps/rc-pinnacle-grey.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-pinnacle-grey.c
+++ linux/drivers/media/rc/keymaps/rc-pinnacle-grey.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 static struct rc_map_table pinnacle_grey[] = {
 	{ 0x3a, KEY_0 },
Index: linux/drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c
+++ linux/drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /* Pinnacle PCTV HD 800i mini remote */
 
Index: linux/drivers/media/rc/keymaps/rc-pixelview-002t.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-pixelview-002t.c
+++ linux/drivers/media/rc/keymaps/rc-pixelview-002t.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /*
  * Keytable for 002-T IR remote provided together with Pixelview
Index: linux/drivers/media/rc/keymaps/rc-pixelview-mk12.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-pixelview-mk12.c
+++ linux/drivers/media/rc/keymaps/rc-pixelview-mk12.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /*
  * Keytable for MK-F12 IR remote provided together with Pixelview
Index: linux/drivers/media/rc/keymaps/rc-pixelview-new.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-pixelview-new.c
+++ linux/drivers/media/rc/keymaps/rc-pixelview-new.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /*
    Mauro Carvalho Chehab <mchehab@infradead.org>
Index: linux/drivers/media/rc/keymaps/rc-pixelview.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-pixelview.c
+++ linux/drivers/media/rc/keymaps/rc-pixelview.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 static struct rc_map_table pixelview[] = {
 
Index: linux/drivers/media/rc/keymaps/rc-powercolor-real-angel.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-powercolor-real-angel.c
+++ linux/drivers/media/rc/keymaps/rc-powercolor-real-angel.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /*
  * Remote control for Powercolor Real Angel 330
Index: linux/drivers/media/rc/keymaps/rc-proteus-2309.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-proteus-2309.c
+++ linux/drivers/media/rc/keymaps/rc-proteus-2309.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /* Michal Majchrowicz <mmajchrowicz@gmail.com> */
 
Index: linux/drivers/media/rc/keymaps/rc-purpletv.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-purpletv.c
+++ linux/drivers/media/rc/keymaps/rc-purpletv.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 static struct rc_map_table purpletv[] = {
 	{ 0x03, KEY_POWER },
Index: linux/drivers/media/rc/keymaps/rc-pv951.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-pv951.c
+++ linux/drivers/media/rc/keymaps/rc-pv951.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /* Mark Phalan <phalanm@o2.ie> */
 
Index: linux/drivers/media/rc/keymaps/rc-rc6-mce.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-rc6-mce.c
+++ linux/drivers/media/rc/keymaps/rc-rc6-mce.c
@@ -13,6 +13,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 static struct rc_map_table rc6_mce[] = {
 
Index: linux/drivers/media/rc/keymaps/rc-real-audio-220-32-keys.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-real-audio-220-32-keys.c
+++ linux/drivers/media/rc/keymaps/rc-real-audio-220-32-keys.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /* Zogis Real Audio 220 - 32 keys IR */
 
Index: linux/drivers/media/rc/keymaps/rc-streamzap.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-streamzap.c
+++ linux/drivers/media/rc/keymaps/rc-streamzap.c
@@ -10,6 +10,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 static struct rc_map_table streamzap[] = {
 /*
Index: linux/drivers/media/rc/keymaps/rc-tbs-nec.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-tbs-nec.c
+++ linux/drivers/media/rc/keymaps/rc-tbs-nec.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 static struct rc_map_table tbs_nec[] = {
 	{ 0x84, KEY_POWER2},		/* power */
Index: linux/drivers/media/rc/keymaps/rc-technisat-usb2.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-technisat-usb2.c
+++ linux/drivers/media/rc/keymaps/rc-technisat-usb2.c
@@ -30,6 +30,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 static struct rc_map_table technisat_usb2[] = {
 	{0x0a0c, KEY_POWER},
Index: linux/drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c
+++ linux/drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /* Terratec Cinergy Hybrid T USB XS
    Devin Heitmueller <dheitmueller@linuxtv.org>
Index: linux/drivers/media/rc/keymaps/rc-terratec-slim-2.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-terratec-slim-2.c
+++ linux/drivers/media/rc/keymaps/rc-terratec-slim-2.c
@@ -20,6 +20,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /*
  * TerraTec slim remote, 6 rows, 3 columns.
Index: linux/drivers/media/rc/keymaps/rc-terratec-slim.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-terratec-slim.c
+++ linux/drivers/media/rc/keymaps/rc-terratec-slim.c
@@ -19,6 +19,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /* TerraTec slim remote, 7 rows, 4 columns. */
 /* Uses NEC extended 0x02bd. */
Index: linux/drivers/media/rc/keymaps/rc-tevii-nec.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-tevii-nec.c
+++ linux/drivers/media/rc/keymaps/rc-tevii-nec.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 static struct rc_map_table tevii_nec[] = {
 	{ 0x0a, KEY_POWER2},
Index: linux/drivers/media/rc/keymaps/rc-tivo.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-tivo.c
+++ linux/drivers/media/rc/keymaps/rc-tivo.c
@@ -9,6 +9,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /*
  * Initial mapping is for the TiVo remote included in the Nero LiquidTV bundle,
Index: linux/drivers/media/rc/keymaps/rc-total-media-in-hand.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-total-media-in-hand.c
+++ linux/drivers/media/rc/keymaps/rc-total-media-in-hand.c
@@ -19,6 +19,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /* Uses NEC extended 0x02bd */
 static struct rc_map_table total_media_in_hand[] = {
Index: linux/drivers/media/rc/keymaps/rc-trekstor.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-trekstor.c
+++ linux/drivers/media/rc/keymaps/rc-trekstor.c
@@ -19,6 +19,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /* TrekStor DVB-T USB Stick remote controller. */
 /* Imported from af9015.h.
Index: linux/drivers/media/rc/keymaps/rc-tt-1500.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-tt-1500.c
+++ linux/drivers/media/rc/keymaps/rc-tt-1500.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /* for the Technotrend 1500 bundled remotes (grey and black): */
 
Index: linux/drivers/media/rc/keymaps/rc-twinhan1027.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-twinhan1027.c
+++ linux/drivers/media/rc/keymaps/rc-twinhan1027.c
@@ -1,4 +1,5 @@
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 static struct rc_map_table twinhan_vp1027[] = {
 	{ 0x16, KEY_POWER2 },
Index: linux/drivers/media/rc/keymaps/rc-videomate-m1f.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-videomate-m1f.c
+++ linux/drivers/media/rc/keymaps/rc-videomate-m1f.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 static struct rc_map_table videomate_m1f[] = {
 	{ 0x01, KEY_POWER },
Index: linux/drivers/media/rc/keymaps/rc-videomate-s350.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-videomate-s350.c
+++ linux/drivers/media/rc/keymaps/rc-videomate-s350.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 static struct rc_map_table videomate_s350[] = {
 	{ 0x00, KEY_TV},
Index: linux/drivers/media/rc/keymaps/rc-videomate-tv-pvr.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-videomate-tv-pvr.c
+++ linux/drivers/media/rc/keymaps/rc-videomate-tv-pvr.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 static struct rc_map_table videomate_tv_pvr[] = {
 	{ 0x14, KEY_MUTE },
Index: linux/drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c
+++ linux/drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /* Leadtek Winfast TV USB II Deluxe remote
    Magnus Alm <magnus.alm@gmail.com>
Index: linux/drivers/media/rc/keymaps/rc-winfast.c
===================================================================
--- linux.orig/drivers/media/rc/keymaps/rc-winfast.c
+++ linux/drivers/media/rc/keymaps/rc-winfast.c
@@ -11,6 +11,7 @@
  */
 
 #include <media/rc-map.h>
+#include <linux/module.h>
 
 /* Table for Leadtek Winfast Remote Controls - used by both bttv and cx88 */
 
Index: linux/drivers/media/rc/rc-main.c
===================================================================
--- linux.orig/drivers/media/rc/rc-main.c
+++ linux/drivers/media/rc/rc-main.c
@@ -18,6 +18,7 @@
 #include <linux/input.h>
 #include <linux/slab.h>
 #include <linux/device.h>
+#include <linux/module.h>
 #include "rc-core-priv.h"
 
 /* Sizes are in bytes, 256 bytes allows for 32 entries on x64 */
Index: linux/drivers/media/video/cpia2/cpia2_usb.c
===================================================================
--- linux.orig/drivers/media/video/cpia2/cpia2_usb.c
+++ linux/drivers/media/video/cpia2/cpia2_usb.c
@@ -31,6 +31,7 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/usb.h>
+#include <linux/module.h>
 
 #include "cpia2.h"
 
Index: linux/drivers/media/video/cx25840/cx25840-ir.c
===================================================================
--- linux.orig/drivers/media/video/cx25840/cx25840-ir.c
+++ linux/drivers/media/video/cx25840/cx25840-ir.c
@@ -23,6 +23,7 @@
 
 #include <linux/slab.h>
 #include <linux/kfifo.h>
+#include <linux/module.h>
 #include <media/cx25840.h>
 #include <media/rc-core.h>
 
Index: linux/drivers/media/video/hdpvr/hdpvr-i2c.c
===================================================================
--- linux.orig/drivers/media/video/hdpvr/hdpvr-i2c.c
+++ linux/drivers/media/video/hdpvr/hdpvr-i2c.c
@@ -16,6 +16,7 @@
 #if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
 
 #include <linux/i2c.h>
+#include <linux/module.h>
 #include <linux/slab.h>
 
 #include "hdpvr.h"
Index: linux/drivers/media/video/hexium_gemini.c
===================================================================
--- linux.orig/drivers/media/video/hexium_gemini.c
+++ linux/drivers/media/video/hexium_gemini.c
@@ -24,6 +24,7 @@
 #define DEBUG_VARIABLE debug
 
 #include <media/saa7146_vv.h>
+#include <linux/module.h>
 
 static int debug;
 module_param(debug, int, 0);
Index: linux/drivers/media/video/hexium_orion.c
===================================================================
--- linux.orig/drivers/media/video/hexium_orion.c
+++ linux/drivers/media/video/hexium_orion.c
@@ -24,6 +24,7 @@
 #define DEBUG_VARIABLE debug
 
 #include <media/saa7146_vv.h>
+#include <linux/module.h>
 
 static int debug;
 module_param(debug, int, 0);
Index: linux/drivers/media/video/imx074.c
===================================================================
--- linux.orig/drivers/media/video/imx074.c
+++ linux/drivers/media/video/imx074.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/delay.h>
+#include <linux/module.h>
 #include <linux/i2c.h>
 #include <linux/slab.h>
 #include <linux/videodev2.h>
Index: linux/drivers/media/video/mt9m001.c
===================================================================
--- linux.orig/drivers/media/video/mt9m001.c
+++ linux/drivers/media/video/mt9m001.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/videodev2.h>
+#include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/log2.h>
Index: linux/drivers/media/video/mt9m111.c
===================================================================
--- linux.orig/drivers/media/video/mt9m111.c
+++ linux/drivers/media/video/mt9m111.c
@@ -9,6 +9,7 @@
  */
 #include <linux/videodev2.h>
 #include <linux/slab.h>
+#include <linux/module.h>
 #include <linux/i2c.h>
 #include <linux/log2.h>
 #include <linux/gpio.h>
Index: linux/drivers/media/video/mt9t031.c
===================================================================
--- linux.orig/drivers/media/video/mt9t031.c
+++ linux/drivers/media/video/mt9t031.c
@@ -10,6 +10,7 @@
 
 #include <linux/device.h>
 #include <linux/i2c.h>
+#include <linux/module.h>
 #include <linux/log2.h>
 #include <linux/pm.h>
 #include <linux/slab.h>
Index: linux/drivers/media/video/mt9v011.c
===================================================================
--- linux.orig/drivers/media/video/mt9v011.c
+++ linux/drivers/media/video/mt9v011.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/i2c.h>
+#include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/videodev2.h>
 #include <linux/delay.h>
Index: linux/drivers/media/video/mt9v022.c
===================================================================
--- linux.orig/drivers/media/video/mt9v022.c
+++ linux/drivers/media/video/mt9v022.c
@@ -10,6 +10,7 @@
 
 #include <linux/videodev2.h>
 #include <linux/slab.h>
+#include <linux/module.h>
 #include <linux/i2c.h>
 #include <linux/delay.h>
 #include <linux/log2.h>
Index: linux/drivers/media/video/mxb.c
===================================================================
--- linux.orig/drivers/media/video/mxb.c
+++ linux/drivers/media/video/mxb.c
@@ -24,6 +24,7 @@
 #define DEBUG_VARIABLE debug
 
 #include <media/saa7146_vv.h>
+#include <linux/module.h>
 #include <media/tuner.h>
 #include <media/v4l2-common.h>
 #include <media/saa7115.h>
Index: linux/drivers/media/video/noon010pc30.c
===================================================================
--- linux.orig/drivers/media/video/noon010pc30.c
+++ linux/drivers/media/video/noon010pc30.c
@@ -14,6 +14,7 @@
  */
 
 #include <linux/delay.h>
+#include <linux/module.h>
 #include <linux/gpio.h>
 #include <linux/i2c.h>
 #include <linux/slab.h>
Index: linux/drivers/media/video/ov6650.c
===================================================================
--- linux.orig/drivers/media/video/ov6650.c
+++ linux/drivers/media/video/ov6650.c
@@ -26,6 +26,7 @@
 
 #include <linux/bitops.h>
 #include <linux/delay.h>
+#include <linux/module.h>
 #include <linux/i2c.h>
 #include <linux/slab.h>
 
Index: linux/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
===================================================================
--- linux.orig/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
+++ linux/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
@@ -20,6 +20,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/version.h>
 #include "pvrusb2-context.h"
Index: linux/drivers/media/video/rj54n1cb0c.c
===================================================================
--- linux.orig/drivers/media/video/rj54n1cb0c.c
+++ linux/drivers/media/video/rj54n1cb0c.c
@@ -10,6 +10,7 @@
 
 #include <linux/delay.h>
 #include <linux/i2c.h>
+#include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/videodev2.h>
 
Index: linux/drivers/media/video/sr030pc30.c
===================================================================
--- linux.orig/drivers/media/video/sr030pc30.c
+++ linux/drivers/media/video/sr030pc30.c
@@ -17,6 +17,7 @@
  */
 
 #include <linux/i2c.h>
+#include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <media/v4l2-device.h>
Index: linux/drivers/media/video/timblogiw.c
===================================================================
--- linux.orig/drivers/media/video/timblogiw.c
+++ linux/drivers/media/video/timblogiw.c
@@ -22,6 +22,7 @@
 
 #include <linux/version.h>
 #include <linux/platform_device.h>
+#include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/dmaengine.h>
 #include <linux/mfd/core.h>
Index: linux/drivers/media/video/tvp5150.c
===================================================================
--- linux.orig/drivers/media/video/tvp5150.c
+++ linux/drivers/media/video/tvp5150.c
@@ -9,6 +9,7 @@
 #include <linux/slab.h>
 #include <linux/videodev2.h>
 #include <linux/delay.h>
+#include <linux/module.h>
 #include <media/v4l2-device.h>
 #include <media/tvp5150.h>
 #include <media/v4l2-chip-ident.h>
Index: linux/drivers/media/video/usbvision/usbvision-cards.c
===================================================================
--- linux.orig/drivers/media/video/usbvision/usbvision-cards.c
+++ linux/drivers/media/video/usbvision/usbvision-cards.c
@@ -24,6 +24,7 @@
 
 
 #include <linux/list.h>
+#include <linux/module.h>
 #include <media/v4l2-dev.h>
 #include <media/tuner.h>
 #include "usbvision.h"
Index: linux/drivers/media/video/v4l2-ctrls.c
===================================================================
--- linux.orig/drivers/media/video/v4l2-ctrls.c
+++ linux/drivers/media/video/v4l2-ctrls.c
@@ -20,6 +20,7 @@
 
 #include <linux/ctype.h>
 #include <linux/slab.h>
+#include <linux/module.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
Index: linux/drivers/media/video/v4l2-device.c
===================================================================
--- linux.orig/drivers/media/video/v4l2-device.c
+++ linux/drivers/media/video/v4l2-device.c
@@ -25,6 +25,7 @@
 #include <linux/spi/spi.h>
 #endif
 #include <linux/videodev2.h>
+#include <linux/module.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
 
Index: linux/drivers/media/video/v4l2-event.c
===================================================================
--- linux.orig/drivers/media/video/v4l2-event.c
+++ linux/drivers/media/video/v4l2-event.c
@@ -28,6 +28,7 @@
 
 #include <linux/sched.h>
 #include <linux/slab.h>
+#include <linux/module.h>
 
 int v4l2_event_init(struct v4l2_fh *fh)
 {
Index: linux/drivers/media/video/v4l2-fh.c
===================================================================
--- linux.orig/drivers/media/video/v4l2-fh.c
+++ linux/drivers/media/video/v4l2-fh.c
@@ -24,6 +24,7 @@
 
 #include <linux/bitops.h>
 #include <linux/slab.h>
+#include <linux/module.h>
 #include <media/v4l2-dev.h>
 #include <media/v4l2-fh.h>
 #include <media/v4l2-event.h>
Index: linux/drivers/media/video/v4l2-int-device.c
===================================================================
--- linux.orig/drivers/media/video/v4l2-int-device.c
+++ linux/drivers/media/video/v4l2-int-device.c
@@ -26,6 +26,7 @@
 #include <linux/list.h>
 #include <linux/sort.h>
 #include <linux/string.h>
+#include <linux/module.h>
 
 #include <media/v4l2-int-device.h>
 
Index: linux/drivers/media/video/v4l2-subdev.c
===================================================================
--- linux.orig/drivers/media/video/v4l2-subdev.c
+++ linux/drivers/media/video/v4l2-subdev.c
@@ -24,6 +24,7 @@
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/videodev2.h>
+#include <linux/module.h>
 
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
Index: linux/drivers/memstick/core/memstick.c
===================================================================
--- linux.orig/drivers/memstick/core/memstick.c
+++ linux/drivers/memstick/core/memstick.c
@@ -17,6 +17,7 @@
 #include <linux/fs.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
+#include <linux/module.h>
 
 #define DRIVER_NAME "memstick"
 
Index: linux/drivers/memstick/core/mspro_block.c
===================================================================
--- linux.orig/drivers/memstick/core/mspro_block.c
+++ linux/drivers/memstick/core/mspro_block.c
@@ -20,6 +20,7 @@
 #include <linux/slab.h>
 #include <linux/mutex.h>
 #include <linux/memstick.h>
+#include <linux/module.h>
 
 #define DRIVER_NAME "mspro_block"
 
Index: linux/drivers/memstick/host/jmb38x_ms.c
===================================================================
--- linux.orig/drivers/memstick/host/jmb38x_ms.c
+++ linux/drivers/memstick/host/jmb38x_ms.c
@@ -17,6 +17,7 @@
 #include <linux/highmem.h>
 #include <linux/memstick.h>
 #include <linux/slab.h>
+#include <linux/module.h>
 
 #define DRIVER_NAME "jmb38x_ms"
 
Index: linux/drivers/memstick/host/tifm_ms.c
===================================================================
--- linux.orig/drivers/memstick/host/tifm_ms.c
+++ linux/drivers/memstick/host/tifm_ms.c
@@ -17,6 +17,7 @@
 #include <linux/highmem.h>
 #include <linux/scatterlist.h>
 #include <linux/log2.h>
+#include <linux/module.h>
 #include <asm/io.h>
 
 #define DRIVER_NAME "tifm_ms"
Index: linux/drivers/message/i2o/pci.c
===================================================================
--- linux.orig/drivers/message/i2o/pci.c
+++ linux/drivers/message/i2o/pci.c
@@ -31,6 +31,7 @@
 #include <linux/interrupt.h>
 #include <linux/slab.h>
 #include <linux/i2o.h>
+#include <linux/module.h>
 #include "core.h"
 
 #define OSM_DESCRIPTION	"I2O-subsystem"
Index: linux/drivers/mfd/ab3100-core.c
===================================================================
--- linux.orig/drivers/mfd/ab3100-core.c
+++ linux/drivers/mfd/ab3100-core.c
@@ -8,6 +8,7 @@
 
 #include <linux/i2c.h>
 #include <linux/mutex.h>
+#include <linux/module.h>
 #include <linux/list.h>
 #include <linux/notifier.h>
 #include <linux/slab.h>
Index: linux/drivers/mfd/ab3550-core.c
===================================================================
--- linux.orig/drivers/mfd/ab3550-core.c
+++ linux/drivers/mfd/ab3550-core.c
@@ -11,6 +11,7 @@
 
 #include <linux/i2c.h>
 #include <linux/mutex.h>
+#include <linux/module.h>
 #include <linux/err.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
Index: linux/drivers/mfd/ab8500-debugfs.c
===================================================================
--- linux.orig/drivers/mfd/ab8500-debugfs.c
+++ linux/drivers/mfd/ab8500-debugfs.c
@@ -7,6 +7,7 @@
 
 #include <linux/seq_file.h>
 #include <linux/uaccess.h>
+#include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/debugfs.h>
 #include <linux/platform_device.h>
Index: linux/drivers/mfd/ab8500-sysctrl.c
===================================================================
--- linux.orig/drivers/mfd/ab8500-sysctrl.c
+++ linux/drivers/mfd/ab8500-sysctrl.c
@@ -6,6 +6,7 @@
 
 #include <linux/err.h>
 #include <linux/platform_device.h>
+#include <linux/module.h>
 #include <linux/mfd/ab8500.h>
 #include <linux/mfd/abx500.h>
 #include <linux/mfd/ab8500/sysctrl.h>
Index: linux/drivers/mfd/abx500-core.c
===================================================================
--- linux.orig/drivers/mfd/abx500-core.c
+++ linux/drivers/mfd/abx500-core.c
@@ -7,6 +7,7 @@
 
 #include <linux/list.h>
 #include <linux/slab.h>
+#include <linux/module.h>
 #include <linux/err.h>
 #include <linux/mfd/abx500.h>
 
Index: linux/drivers/mfd/max8997.c
===================================================================
--- linux.orig/drivers/mfd/max8997.c
+++ linux/drivers/mfd/max8997.c
@@ -22,6 +22,7 @@
  */
 
 #include <linux/slab.h>
+#include <linux/module.h>
 #include <linux/i2c.h>
 #include <linux/pm_runtime.h>
 #include <linux/mutex.h>
Index: linux/drivers/mfd/mfd-core.c
===================================================================
--- linux.orig/drivers/mfd/mfd-core.c
+++ linux/drivers/mfd/mfd-core.c
@@ -13,6 +13,7 @@
 
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
+#include <linux/module.h>
 #include <linux/acpi.h>
 #include <linux/mfd/core.h>
 #include <linux/pm_runtime.h>
Index: linux/drivers/mfd/pcf50633-irq.c
===================================================================
--- linux.orig/drivers/mfd/pcf50633-irq.c
+++ linux/drivers/mfd/pcf50633-irq.c
@@ -16,6 +16,7 @@
 #include <linux/kernel.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
+#include <linux/module.h>
 
 #include <linux/mfd/pcf50633/core.h>
 
Index: linux/drivers/mfd/twl-core.c
===================================================================
--- linux.orig/drivers/mfd/twl-core.c
+++ linux/drivers/mfd/twl-core.c
@@ -33,6 +33,7 @@
 #include <linux/platform_device.h>
 #include <linux/clk.h>
 #include <linux/err.h>
+#include <linux/module.h>
 
 #include <linux/regulator/machine.h>
 
Index: linux/drivers/mfd/twl6030-irq.c
===================================================================
--- linux.orig/drivers/mfd/twl6030-irq.c
+++ linux/drivers/mfd/twl6030-irq.c
@@ -37,6 +37,7 @@
 #include <linux/kthread.h>
 #include <linux/i2c/twl.h>
 #include <linux/platform_device.h>
+#include <linux/module.h>
 
 #include "twl-core.h"
 
Index: linux/drivers/mfd/wl1273-core.c
===================================================================
--- linux.orig/drivers/mfd/wl1273-core.c
+++ linux/drivers/mfd/wl1273-core.c
@@ -22,6 +22,7 @@
 
 #include <linux/mfd/wl1273-core.h>
 #include <linux/slab.h>
+#include <linux/module.h>
 
 #define DRIVER_DESC "WL1273 FM Radio Core"
 
Index: linux/drivers/mfd/wm8400-core.c
===================================================================
--- linux.orig/drivers/mfd/wm8400-core.c
+++ linux/drivers/mfd/wm8400-core.c
@@ -19,6 +19,7 @@
 #include <linux/mfd/wm8400-private.h>
 #include <linux/mfd/wm8400-audio.h>
 #include <linux/slab.h>
+#include <linux/module.h>
 
 static struct {
 	u16  readable;    /* Mask of readable bits */
Index: linux/drivers/misc/bh1780gli.c
===================================================================
--- linux.orig/drivers/misc/bh1780gli.c
+++ linux/drivers/misc/bh1780gli.c
@@ -22,6 +22,8 @@
 #include <linux/mutex.h>
 #include <linux/platform_device.h>
 #include <linux/delay.h>
+#include <linux/stat.h>
+#include <linux/module.h>
 
 #define BH1780_REG_CONTROL	0x80
 #define BH1780_REG_PARTID	0x8A
Index: linux/drivers/misc/kgdbts.c
===================================================================
--- linux.orig/drivers/misc/kgdbts.c
+++ linux/drivers/misc/kgdbts.c
@@ -95,6 +95,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/kgdb.h>
 #include <linux/ctype.h>
 #include <linux/uaccess.h>
Index: linux/drivers/misc/ti-st/st_kim.c
===================================================================
--- linux.orig/drivers/misc/ti-st/st_kim.c
+++ linux/drivers/misc/ti-st/st_kim.c
@@ -32,6 +32,7 @@
 #include <linux/sched.h>
 #include <linux/sysfs.h>
 #include <linux/tty.h>
+#include <linux/module.h>
 
 #include <linux/skbuff.h>
 #include <linux/ti_wilink_st.h>
Index: linux/drivers/misc/tifm_7xx1.c
===================================================================
--- linux.orig/drivers/misc/tifm_7xx1.c
+++ linux/drivers/misc/tifm_7xx1.c
@@ -11,6 +11,7 @@
 
 #include <linux/tifm.h>
 #include <linux/dma-mapping.h>
+#include <linux/module.h>
 
 #define DRIVER_NAME "tifm_7xx1"
 #define DRIVER_VERSION "0.8"
Index: linux/drivers/misc/tifm_core.c
===================================================================
--- linux.orig/drivers/misc/tifm_core.c
+++ linux/drivers/misc/tifm_core.c
@@ -13,6 +13,7 @@
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/idr.h>
+#include <linux/module.h>
 
 #define DRIVER_NAME "tifm_core"
 #define DRIVER_VERSION "0.8"
Index: linux/drivers/mmc/card/mmc_test.c
===================================================================
--- linux.orig/drivers/mmc/card/mmc_test.c
+++ linux/drivers/mmc/card/mmc_test.c
@@ -11,6 +11,7 @@
 
 #include <linux/mmc/core.h>
 #include <linux/mmc/card.h>
+#include <linux/module.h>
 #include <linux/mmc/host.h>
 #include <linux/mmc/mmc.h>
 #include <linux/slab.h>
Index: linux/drivers/mmc/core/bus.c
===================================================================
--- linux.orig/drivers/mmc/core/bus.c
+++ linux/drivers/mmc/core/bus.c
@@ -15,6 +15,7 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/pm_runtime.h>
+#include <linux/module.h>
 
 #include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
Index: linux/drivers/mmc/core/debugfs.c
===================================================================
--- linux.orig/drivers/mmc/core/debugfs.c
+++ linux/drivers/mmc/core/debugfs.c
@@ -8,6 +8,7 @@
  * published by the Free Software Foundation.
  */
 #include <linux/debugfs.h>
+#include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
Index: linux/drivers/mmc/core/host.c
===================================================================
--- linux.orig/drivers/mmc/core/host.c
+++ linux/drivers/mmc/core/host.c
@@ -19,6 +19,7 @@
 #include <linux/leds.h>
 #include <linux/slab.h>
 #include <linux/suspend.h>
+#include <linux/module.h>
 
 #include <linux/mmc/host.h>
 #include <linux/mmc/card.h>
Index: linux/drivers/mmc/core/mmc.c
===================================================================
--- linux.orig/drivers/mmc/core/mmc.c
+++ linux/drivers/mmc/core/mmc.c
@@ -12,6 +12,7 @@
 
 #include <linux/err.h>
 #include <linux/slab.h>
+#include <linux/stat.h>
 
 #include <linux/mmc/host.h>
 #include <linux/mmc/card.h>
Index: linux/drivers/mmc/core/quirks.c
===================================================================
--- linux.orig/drivers/mmc/core/quirks.c
+++ linux/drivers/mmc/core/quirks.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/types.h>
+#include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/mmc/card.h>
 #include <linux/mod_devicetable.h>
Index: linux/drivers/mmc/core/sd.c
===================================================================
--- linux.orig/drivers/mmc/core/sd.c
+++ linux/drivers/mmc/core/sd.c
@@ -12,6 +12,7 @@
 
 #include <linux/err.h>
 #include <linux/slab.h>
+#include <linux/stat.h>
 
 #include <linux/mmc/host.h>
 #include <linux/mmc/card.h>
Index: linux/drivers/mmc/core/sd_ops.c
===================================================================
--- linux.orig/drivers/mmc/core/sd_ops.c
+++ linux/drivers/mmc/core/sd_ops.c
@@ -12,6 +12,7 @@
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/scatterlist.h>
+#include <linux/module.h>
 
 #include <linux/mmc/host.h>
 #include <linux/mmc/card.h>
Index: linux/drivers/mmc/core/sdio_bus.c
===================================================================
--- linux.orig/drivers/mmc/core/sdio_bus.c
+++ linux/drivers/mmc/core/sdio_bus.c
@@ -12,6 +12,7 @@
  */
 
 #include <linux/device.h>
+#include <linux/module.h>
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/pm_runtime.h>
Index: linux/drivers/mmc/core/sdio_io.c
===================================================================
--- linux.orig/drivers/mmc/core/sdio_io.c
+++ linux/drivers/mmc/core/sdio_io.c
@@ -10,6 +10,7 @@
  */
 
 #include <linux/mmc/host.h>
+#include <linux/module.h>
 #include <linux/mmc/card.h>
 #include <linux/mmc/sdio.h>
 #include <linux/mmc/sdio_func.h>
Index: linux/drivers/mmc/core/sdio_irq.c
===================================================================
--- linux.orig/drivers/mmc/core/sdio_irq.c
+++ linux/drivers/mmc/core/sdio_irq.c
@@ -14,6 +14,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/kthread.h>
 #include <linux/wait.h>
Index: linux/drivers/mmc/host/mmc_spi.c
===================================================================
--- linux.orig/drivers/mmc/host/mmc_spi.c
+++ linux/drivers/mmc/host/mmc_spi.c
@@ -32,6 +32,7 @@
 #include <linux/crc7.h>
 #include <linux/crc-itu-t.h>
 #include <linux/scatterlist.h>
+#include <linux/module.h>
 
 #include <linux/mmc/host.h>
 #include <linux/mmc/mmc.h>		/* for R1_SPI_* bit values */
Index: linux/drivers/mmc/host/sdhci-pci.c
===================================================================
--- linux.orig/drivers/mmc/host/sdhci-pci.c
+++ linux/drivers/mmc/host/sdhci-pci.c
@@ -18,6 +18,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/slab.h>
 #include <linux/device.h>
+#include <linux/module.h>
 
 #include <linux/mmc/host.h>
 
Index: linux/drivers/mmc/host/sdhci-pltfm.c
===================================================================
--- linux.orig/drivers/mmc/host/sdhci-pltfm.c
+++ linux/drivers/mmc/host/sdhci-pltfm.c
@@ -23,6 +23,7 @@
  */
 
 #include <linux/delay.h>
+#include <linux/module.h>
 #include <linux/highmem.h>
 #include <linux/mod_devicetable.h>
 #include <linux/platform_device.h>
Index: linux/drivers/mmc/host/sdhci.c
===================================================================
--- linux.orig/drivers/mmc/host/sdhci.c
+++ linux/drivers/mmc/host/sdhci.c
@@ -20,6 +20,7 @@
 #include <linux/slab.h>
 #include <linux/scatterlist.h>
 #include <linux/regulator/consumer.h>
+#include <linux/module.h>
 
 #include <linux/leds.h>
 
Index: linux/drivers/mmc/host/sdricoh_cs.c
===================================================================
--- linux.orig/drivers/mmc/host/sdricoh_cs.c
+++ linux/drivers/mmc/host/sdricoh_cs.c
@@ -29,6 +29,7 @@
 #include <linux/pci.h>
 #include <linux/ioport.h>
 #include <linux/scatterlist.h>
+#include <linux/module.h>
 
 #include <pcmcia/cistpl.h>
 #include <pcmcia/ds.h>
Index: linux/drivers/mmc/host/tifm_sd.c
===================================================================
--- linux.orig/drivers/mmc/host/tifm_sd.c
+++ linux/drivers/mmc/host/tifm_sd.c
@@ -16,6 +16,7 @@
 #include <linux/mmc/host.h>
 #include <linux/highmem.h>
 #include <linux/scatterlist.h>
+#include <linux/module.h>
 #include <asm/io.h>
 
 #define DRIVER_NAME "tifm_sd"
Index: linux/drivers/mmc/host/via-sdmmc.c
===================================================================
--- linux.orig/drivers/mmc/host/via-sdmmc.c
+++ linux/drivers/mmc/host/via-sdmmc.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/pci.h>
+#include <linux/module.h>
 #include <linux/dma-mapping.h>
 #include <linux/highmem.h>
 #include <linux/delay.h>
Index: linux/drivers/mtd/ar7part.c
===================================================================
--- linux.orig/drivers/mtd/ar7part.c
+++ linux/drivers/mtd/ar7part.c
@@ -22,6 +22,7 @@
 
 #include <linux/kernel.h>
 #include <linux/slab.h>
+#include <linux/module.h>
 
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
Index: linux/drivers/mtd/cmdlinepart.c
===================================================================
--- linux.orig/drivers/mtd/cmdlinepart.c
+++ linux/drivers/mtd/cmdlinepart.c
@@ -39,6 +39,7 @@
 
 #include <linux/kernel.h>
 #include <linux/slab.h>
+#include <linux/module.h>
 
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
Index: linux/drivers/mtd/lpddr/lpddr_cmds.c
===================================================================
--- linux.orig/drivers/mtd/lpddr/lpddr_cmds.c
+++ linux/drivers/mtd/lpddr/lpddr_cmds.c
@@ -25,6 +25,7 @@
  * Implement OTP support
  */
 #include <linux/mtd/pfow.h>
+#include <linux/module.h>
 #include <linux/mtd/qinfo.h>
 #include <linux/slab.h>
 
Index: linux/drivers/mtd/nand/cafe_nand.c
===================================================================
--- linux.orig/drivers/mtd/nand/cafe_nand.c
+++ linux/drivers/mtd/nand/cafe_nand.c
@@ -13,6 +13,7 @@
 #include <linux/device.h>
 #undef DEBUG
 #include <linux/mtd/mtd.h>
+#include <linux/module.h>
 #include <linux/mtd/nand.h>
 #include <linux/mtd/partitions.h>
 #include <linux/rslib.h>
Index: linux/drivers/mtd/nand/diskonchip.c
===================================================================
--- linux.orig/drivers/mtd/nand/diskonchip.c
+++ linux/drivers/mtd/nand/diskonchip.c
@@ -19,6 +19,7 @@
 
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/delay.h>
 #include <linux/rslib.h>
Index: linux/drivers/mtd/nand/nand_bbt.c
===================================================================
--- linux.orig/drivers/mtd/nand/nand_bbt.c
+++ linux/drivers/mtd/nand/nand_bbt.c
@@ -60,6 +60,7 @@
  */
 
 #include <linux/slab.h>
+#include <linux/module.h>
 #include <linux/types.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/nand.h>
Index: linux/drivers/mtd/nand/sm_common.c
===================================================================
--- linux.orig/drivers/mtd/nand/sm_common.c
+++ linux/drivers/mtd/nand/sm_common.c
@@ -7,6 +7,7 @@
  * published by the Free Software Foundation.
  */
 #include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/mtd/nand.h>
 #include "sm_common.h"
 
Index: linux/drivers/mtd/onenand/onenand_bbt.c
===================================================================
--- linux.orig/drivers/mtd/onenand/onenand_bbt.c
+++ linux/drivers/mtd/onenand/onenand_bbt.c
@@ -13,6 +13,7 @@
  */
 
 #include <linux/slab.h>
+#include <linux/module.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/onenand.h>
 
Index: linux/drivers/mtd/redboot.c
===================================================================
--- linux.orig/drivers/mtd/redboot.c
+++ linux/drivers/mtd/redboot.c
@@ -25,6 +25,7 @@
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/vmalloc.h>
+#include <linux/module.h>
 
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
Index: linux/drivers/mtd/rfd_ftl.c
===================================================================
--- linux.orig/drivers/mtd/rfd_ftl.c
+++ linux/drivers/mtd/rfd_ftl.c
@@ -18,6 +18,7 @@
 #include <linux/vmalloc.h>
 #include <linux/slab.h>
 #include <linux/jiffies.h>
+#include <linux/module.h>
 
 #include <asm/types.h>
 
Index: linux/drivers/mtd/ubi/vmt.c
===================================================================
--- linux.orig/drivers/mtd/ubi/vmt.c
+++ linux/drivers/mtd/ubi/vmt.c
@@ -24,6 +24,7 @@
  */
 
 #include <linux/err.h>
+#include <linux/module.h>
 #include <linux/math64.h>
 #include <linux/slab.h>
 #include "ubi.h"
Index: linux/drivers/net/phy/realtek.c
===================================================================
--- linux.orig/drivers/net/phy/realtek.c
+++ linux/drivers/net/phy/realtek.c
@@ -14,6 +14,7 @@
  *
  */
 #include <linux/phy.h>
+#include <linux/module.h>
 
 #define RTL821x_PHYSR		0x11
 #define RTL821x_PHYSR_DUPLEX	0x2000
Index: linux/drivers/pci/hotplug/pciehp_acpi.c
===================================================================
--- linux.orig/drivers/pci/hotplug/pciehp_acpi.c
+++ linux/drivers/pci/hotplug/pciehp_acpi.c
@@ -25,6 +25,7 @@
 
 #include <linux/acpi.h>
 #include <linux/pci.h>
+#include <linux/module.h>
 #include <linux/pci_hotplug.h>
 #include <linux/slab.h>
 #include "pciehp.h"
Index: linux/drivers/platform/x86/intel_scu_ipc.c
===================================================================
--- linux.orig/drivers/platform/x86/intel_scu_ipc.c
+++ linux/drivers/platform/x86/intel_scu_ipc.c
@@ -18,6 +18,7 @@
  */
 #include <linux/delay.h>
 #include <linux/errno.h>
+#include <linux/module.h>
 #include <linux/init.h>
 #include <linux/sysdev.h>
 #include <linux/pm.h>
Index: linux/drivers/platform/x86/msi-wmi.c
===================================================================
--- linux.orig/drivers/platform/x86/msi-wmi.c
+++ linux/drivers/platform/x86/msi-wmi.c
@@ -23,6 +23,7 @@
 
 #include <linux/kernel.h>
 #include <linux/input.h>
+#include <linux/module.h>
 #include <linux/input/sparse-keymap.h>
 #include <linux/acpi.h>
 #include <linux/backlight.h>
Index: linux/drivers/platform/x86/wmi.c
===================================================================
--- linux.orig/drivers/platform/x86/wmi.c
+++ linux/drivers/platform/x86/wmi.c
@@ -31,6 +31,7 @@
 
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/module.h>
 #include <linux/types.h>
 #include <linux/device.h>
 #include <linux/list.h>
Index: linux/drivers/power/max17042_battery.c
===================================================================
--- linux.orig/drivers/power/max17042_battery.c
+++ linux/drivers/power/max17042_battery.c
@@ -24,6 +24,7 @@
 
 #include <linux/init.h>
 #include <linux/slab.h>
+#include <linux/module.h>
 #include <linux/i2c.h>
 #include <linux/mod_devicetable.h>
 #include <linux/power_supply.h>
Index: linux/drivers/rapidio/switches/idt_gen2.c
===================================================================
--- linux.orig/drivers/rapidio/switches/idt_gen2.c
+++ linux/drivers/rapidio/switches/idt_gen2.c
@@ -14,6 +14,8 @@
 #include <linux/rio_drv.h>
 #include <linux/rio_ids.h>
 #include <linux/delay.h>
+#include <linux/stat.h>
+
 #include "../rio.h"
 
 #define LOCAL_RTE_CONF_DESTID_SEL	0x010070
Index: linux/drivers/regulator/ab8500.c
===================================================================
--- linux.orig/drivers/regulator/ab8500.c
+++ linux/drivers/regulator/ab8500.c
@@ -13,6 +13,7 @@
  */
 #include <linux/init.h>
 #include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/err.h>
 #include <linux/platform_device.h>
 #include <linux/mfd/ab8500.h>
Index: linux/drivers/regulator/bq24022.c
===================================================================
--- linux.orig/drivers/regulator/bq24022.c
+++ linux/drivers/regulator/bq24022.c
@@ -12,6 +12,7 @@
 
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/err.h>
 #include <linux/gpio.h>
Index: linux/drivers/regulator/da903x.c
===================================================================
--- linux.orig/drivers/regulator/da903x.c
+++ linux/drivers/regulator/da903x.c
@@ -11,6 +11,7 @@
 
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/module.h>
 #include <linux/err.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
Index: linux/drivers/regulator/dummy.c
===================================================================
--- linux.orig/drivers/regulator/dummy.c
+++ linux/drivers/regulator/dummy.c
@@ -17,6 +17,7 @@
 
 #include <linux/err.h>
 #include <linux/platform_device.h>
+#include <linux/module.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
 
Index: linux/drivers/regulator/fixed.c
===================================================================
--- linux.orig/drivers/regulator/fixed.c
+++ linux/drivers/regulator/fixed.c
@@ -20,6 +20,7 @@
 
 #include <linux/err.h>
 #include <linux/mutex.h>
+#include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/fixed.h>
Index: linux/drivers/regulator/lp3971.c
===================================================================
--- linux.orig/drivers/regulator/lp3971.c
+++ linux/drivers/regulator/lp3971.c
@@ -14,6 +14,7 @@
 
 #include <linux/bug.h>
 #include <linux/err.h>
+#include <linux/module.h>
 #include <linux/i2c.h>
 #include <linux/kernel.h>
 #include <linux/regulator/driver.h>
Index: linux/drivers/regulator/lp3972.c
===================================================================
--- linux.orig/drivers/regulator/lp3972.c
+++ linux/drivers/regulator/lp3972.c
@@ -11,6 +11,7 @@
 
 #include <linux/bug.h>
 #include <linux/err.h>
+#include <linux/module.h>
 #include <linux/i2c.h>
 #include <linux/kernel.h>
 #include <linux/regulator/driver.h>
Index: linux/drivers/regulator/max8925-regulator.c
===================================================================
--- linux.orig/drivers/regulator/max8925-regulator.c
+++ linux/drivers/regulator/max8925-regulator.c
@@ -10,6 +10,7 @@
  */
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/module.h>
 #include <linux/err.h>
 #include <linux/i2c.h>
 #include <linux/platform_device.h>
Index: linux/drivers/regulator/max8997.c
===================================================================
--- linux.orig/drivers/regulator/max8997.c
+++ linux/drivers/regulator/max8997.c
@@ -23,6 +23,7 @@
 
 #include <linux/bug.h>
 #include <linux/delay.h>
+#include <linux/module.h>
 #include <linux/err.h>
 #include <linux/gpio.h>
 #include <linux/slab.h>
Index: linux/drivers/regulator/mc13783-regulator.c
===================================================================
--- linux.orig/drivers/regulator/mc13783-regulator.c
+++ linux/drivers/regulator/mc13783-regulator.c
@@ -12,6 +12,7 @@
 
 #include <linux/mfd/mc13783.h>
 #include <linux/regulator/machine.h>
+#include <linux/module.h>
 #include <linux/regulator/driver.h>
 #include <linux/platform_device.h>
 #include <linux/kernel.h>
Index: linux/drivers/regulator/mc13892-regulator.c
===================================================================
--- linux.orig/drivers/regulator/mc13892-regulator.c
+++ linux/drivers/regulator/mc13892-regulator.c
@@ -12,6 +12,7 @@
 
 #include <linux/mfd/mc13892.h>
 #include <linux/regulator/machine.h>
+#include <linux/module.h>
 #include <linux/regulator/driver.h>
 #include <linux/platform_device.h>
 #include <linux/kernel.h>
Index: linux/drivers/regulator/mc13xxx-regulator-core.c
===================================================================
--- linux.orig/drivers/regulator/mc13xxx-regulator-core.c
+++ linux/drivers/regulator/mc13xxx-regulator-core.c
@@ -17,6 +17,7 @@
 
 #include <linux/mfd/mc13xxx.h>
 #include <linux/regulator/machine.h>
+#include <linux/module.h>
 #include <linux/regulator/driver.h>
 #include <linux/platform_device.h>
 #include <linux/kernel.h>
Index: linux/drivers/regulator/tps6586x-regulator.c
===================================================================
--- linux.orig/drivers/regulator/tps6586x-regulator.c
+++ linux/drivers/regulator/tps6586x-regulator.c
@@ -15,6 +15,7 @@
 
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/module.h>
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/platform_device.h>
Index: linux/drivers/regulator/userspace-consumer.c
===================================================================
--- linux.orig/drivers/regulator/userspace-consumer.c
+++ linux/drivers/regulator/userspace-consumer.c
@@ -18,6 +18,7 @@
 
 #include <linux/err.h>
 #include <linux/mutex.h>
+#include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/consumer.h>
 #include <linux/regulator/userspace-consumer.h>
Index: linux/drivers/regulator/virtual.c
===================================================================
--- linux.orig/drivers/regulator/virtual.c
+++ linux/drivers/regulator/virtual.c
@@ -13,6 +13,7 @@
 
 #include <linux/err.h>
 #include <linux/mutex.h>
+#include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/consumer.h>
 #include <linux/slab.h>
Index: linux/drivers/regulator/wm8400-regulator.c
===================================================================
--- linux.orig/drivers/regulator/wm8400-regulator.c
+++ linux/drivers/regulator/wm8400-regulator.c
@@ -14,6 +14,7 @@
 
 #include <linux/bug.h>
 #include <linux/err.h>
+#include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/regulator/driver.h>
 #include <linux/mfd/wm8400-private.h>
Index: linux/drivers/rtc/rtc-ds1305.c
===================================================================
--- linux.orig/drivers/rtc/rtc-ds1305.c
+++ linux/drivers/rtc/rtc-ds1305.c
@@ -10,6 +10,7 @@
  */
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/module.h>
 #include <linux/bcd.h>
 #include <linux/slab.h>
 #include <linux/rtc.h>
Index: linux/drivers/rtc/rtc-ds1511.c
===================================================================
--- linux.orig/drivers/rtc/rtc-ds1511.c
+++ linux/drivers/rtc/rtc-ds1511.c
@@ -16,6 +16,7 @@
 
 #include <linux/bcd.h>
 #include <linux/init.h>
+#include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/gfp.h>
 #include <linux/delay.h>
Index: linux/drivers/rtc/rtc-ds1553.c
===================================================================
--- linux.orig/drivers/rtc/rtc-ds1553.c
+++ linux/drivers/rtc/rtc-ds1553.c
@@ -10,6 +10,7 @@
 
 #include <linux/bcd.h>
 #include <linux/init.h>
+#include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/gfp.h>
 #include <linux/delay.h>
Index: linux/drivers/rtc/rtc-ds1672.c
===================================================================
--- linux.orig/drivers/rtc/rtc-ds1672.c
+++ linux/drivers/rtc/rtc-ds1672.c
@@ -11,6 +11,7 @@
 
 #include <linux/i2c.h>
 #include <linux/rtc.h>
+#include <linux/module.h>
 
 #define DRV_VERSION "0.4"
 
Index: linux/drivers/rtc/rtc-ds1742.c
===================================================================
--- linux.orig/drivers/rtc/rtc-ds1742.c
+++ linux/drivers/rtc/rtc-ds1742.c
@@ -14,6 +14,7 @@
 
 #include <linux/bcd.h>
 #include <linux/init.h>
+#include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/gfp.h>
 #include <linux/delay.h>
Index: linux/drivers/rtc/rtc-isl12022.c
===================================================================
--- linux.orig/drivers/rtc/rtc-isl12022.c
+++ linux/drivers/rtc/rtc-isl12022.c
@@ -13,6 +13,7 @@
 
 #include <linux/i2c.h>
 #include <linux/bcd.h>
+#include <linux/module.h>
 #include <linux/rtc.h>
 #include <linux/slab.h>
 
Index: linux/drivers/rtc/rtc-pcf2123.c
===================================================================
--- linux.orig/drivers/rtc/rtc-pcf2123.c
+++ linux/drivers/rtc/rtc-pcf2123.c
@@ -34,6 +34,7 @@
 
 #include <linux/bcd.h>
 #include <linux/delay.h>
+#include <linux/module.h>
 #include <linux/device.h>
 #include <linux/errno.h>
 #include <linux/init.h>
Index: linux/drivers/rtc/rtc-pcf8563.c
===================================================================
--- linux.orig/drivers/rtc/rtc-pcf8563.c
+++ linux/drivers/rtc/rtc-pcf8563.c
@@ -16,6 +16,7 @@
 
 #include <linux/i2c.h>
 #include <linux/bcd.h>
+#include <linux/module.h>
 #include <linux/rtc.h>
 #include <linux/slab.h>
 
Index: linux/drivers/rtc/rtc-rs5c348.c
===================================================================
--- linux.orig/drivers/rtc/rtc-rs5c348.c
+++ linux/drivers/rtc/rtc-rs5c348.c
@@ -14,6 +14,7 @@
 
 #include <linux/bcd.h>
 #include <linux/delay.h>
+#include <linux/module.h>
 #include <linux/device.h>
 #include <linux/errno.h>
 #include <linux/init.h>
Index: linux/drivers/rtc/rtc-rs5c372.c
===================================================================
--- linux.orig/drivers/rtc/rtc-rs5c372.c
+++ linux/drivers/rtc/rtc-rs5c372.c
@@ -12,6 +12,7 @@
 
 #include <linux/i2c.h>
 #include <linux/rtc.h>
+#include <linux/module.h>
 #include <linux/bcd.h>
 #include <linux/slab.h>
 
Index: linux/drivers/rtc/rtc-x1205.c
===================================================================
--- linux.orig/drivers/rtc/rtc-x1205.c
+++ linux/drivers/rtc/rtc-x1205.c
@@ -19,6 +19,7 @@
 
 #include <linux/i2c.h>
 #include <linux/bcd.h>
+#include <linux/module.h>
 #include <linux/rtc.h>
 #include <linux/delay.h>
 
Index: linux/drivers/scsi/aacraid/aachba.c
===================================================================
--- linux.orig/drivers/scsi/aacraid/aachba.c
+++ linux/drivers/scsi/aacraid/aachba.c
@@ -26,6 +26,7 @@
 
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/module.h>
 #include <linux/types.h>
 #include <linux/pci.h>
 #include <linux/spinlock.h>
Index: linux/drivers/scsi/bfa/bfad_debugfs.c
===================================================================
--- linux.orig/drivers/scsi/bfa/bfad_debugfs.c
+++ linux/drivers/scsi/bfa/bfad_debugfs.c
@@ -16,6 +16,7 @@
  */
 
 #include <linux/debugfs.h>
+#include <linux/module.h>
 
 #include "bfad_drv.h"
 #include "bfad_im.h"
Index: linux/drivers/scsi/bfa/bfad_im.c
===================================================================
--- linux.orig/drivers/scsi/bfa/bfad_im.c
+++ linux/drivers/scsi/bfa/bfad_im.c
@@ -21,6 +21,7 @@
 
 #include "bfad_drv.h"
 #include "bfad_im.h"
+#include <linux/module.h>
 #include "bfa_fcs.h"
 
 BFA_TRC_FILE(LDRV, IM);
Index: linux/drivers/scsi/device_handler/scsi_dh.c
===================================================================
--- linux.orig/drivers/scsi/device_handler/scsi_dh.c
+++ linux/drivers/scsi/device_handler/scsi_dh.c
@@ -22,6 +22,7 @@
  */
 
 #include <linux/slab.h>
+#include <linux/module.h>
 #include <scsi/scsi_dh.h>
 #include "../scsi_priv.h"
 
Index: linux/drivers/scsi/device_handler/scsi_dh_alua.c
===================================================================
--- linux.orig/drivers/scsi/device_handler/scsi_dh_alua.c
+++ linux/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -21,6 +21,7 @@
  */
 #include <linux/slab.h>
 #include <linux/delay.h>
+#include <linux/module.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_dh.h>
Index: linux/drivers/scsi/device_handler/scsi_dh_emc.c
===================================================================
--- linux.orig/drivers/scsi/device_handler/scsi_dh_emc.c
+++ linux/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -21,6 +21,7 @@
  * the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 #include <linux/slab.h>
+#include <linux/module.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_dh.h>
Index: linux/drivers/scsi/device_handler/scsi_dh_hp_sw.c
===================================================================
--- linux.orig/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ linux/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -22,6 +22,7 @@
  */
 
 #include <linux/slab.h>
+#include <linux/module.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_eh.h>
Index: linux/drivers/scsi/device_handler/scsi_dh_rdac.c
===================================================================
--- linux.orig/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ linux/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -23,6 +23,7 @@
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_dh.h>
 #include <linux/workqueue.h>
+#include <linux/module.h>
 #include <linux/slab.h>
 
 #define RDAC_NAME "rdac"
Index: linux/drivers/scsi/libfc/fc_disc.c
===================================================================
--- linux.orig/drivers/scsi/libfc/fc_disc.c
+++ linux/drivers/scsi/libfc/fc_disc.c
@@ -34,6 +34,7 @@
 
 #include <linux/timer.h>
 #include <linux/slab.h>
+#include <linux/module.h>
 #include <linux/err.h>
 #include <asm/unaligned.h>
 
Index: linux/drivers/scsi/libfc/fc_elsct.c
===================================================================
--- linux.orig/drivers/scsi/libfc/fc_elsct.c
+++ linux/drivers/scsi/libfc/fc_elsct.c
@@ -22,6 +22,7 @@
  */
 
 #include <asm/unaligned.h>
+#include <linux/module.h>
 #include <scsi/fc/fc_gs.h>
 #include <scsi/fc/fc_ns.h>
 #include <scsi/fc/fc_els.h>
Index: linux/drivers/scsi/libfc/fc_exch.c
===================================================================
--- linux.orig/drivers/scsi/libfc/fc_exch.c
+++ linux/drivers/scsi/libfc/fc_exch.c
@@ -25,6 +25,7 @@
 
 #include <linux/timer.h>
 #include <linux/slab.h>
+#include <linux/module.h>
 #include <linux/err.h>
 
 #include <scsi/fc/fc_fc2.h>
Index: linux/drivers/scsi/libfc/fc_libfc.c
===================================================================
--- linux.orig/drivers/scsi/libfc/fc_libfc.c
+++ linux/drivers/scsi/libfc/fc_libfc.c
@@ -19,6 +19,7 @@
 
 #include <linux/kernel.h>
 #include <linux/types.h>
+#include <linux/module.h>
 #include <linux/scatterlist.h>
 #include <linux/crc32.h>
 
Index: linux/drivers/scsi/libfc/fc_lport.c
===================================================================
--- linux.orig/drivers/scsi/libfc/fc_lport.c
+++ linux/drivers/scsi/libfc/fc_lport.c
@@ -89,6 +89,7 @@
 
 #include <linux/timer.h>
 #include <linux/slab.h>
+#include <linux/module.h>
 #include <asm/unaligned.h>
 
 #include <scsi/fc/fc_gs.h>
Index: linux/drivers/scsi/libsrp.c
===================================================================
--- linux.orig/drivers/scsi/libsrp.c
+++ linux/drivers/scsi/libsrp.c
@@ -20,6 +20,7 @@
  */
 #include <linux/err.h>
 #include <linux/slab.h>
+#include <linux/module.h>
 #include <linux/kfifo.h>
 #include <linux/scatterlist.h>
 #include <linux/dma-mapping.h>
Index: linux/drivers/scsi/lpfc/lpfc_debugfs.c
===================================================================
--- linux.orig/drivers/scsi/lpfc/lpfc_debugfs.c
+++ linux/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -20,6 +20,7 @@
 
 #include <linux/blkdev.h>
 #include <linux/delay.h>
+#include <linux/module.h>
 #include <linux/dma-mapping.h>
 #include <linux/idr.h>
 #include <linux/interrupt.h>
Index: linux/drivers/scsi/megaraid/megaraid_mbox.c
===================================================================
--- linux.orig/drivers/scsi/megaraid/megaraid_mbox.c
+++ linux/drivers/scsi/megaraid/megaraid_mbox.c
@@ -71,6 +71,7 @@
  */
 
 #include <linux/slab.h>
+#include <linux/module.h>
 #include "megaraid_mbox.h"
 
 static int megaraid_init(void);
Index: linux/drivers/scsi/osd/osd_initiator.c
===================================================================
--- linux.orig/drivers/scsi/osd/osd_initiator.c
+++ linux/drivers/scsi/osd/osd_initiator.c
@@ -40,6 +40,7 @@
  */
 
 #include <linux/slab.h>
+#include <linux/module.h>
 
 #include <scsi/osd_initiator.h>
 #include <scsi/osd_sec.h>
Index: linux/drivers/scsi/scsi_pm.c
===================================================================
--- linux.orig/drivers/scsi/scsi_pm.c
+++ linux/drivers/scsi/scsi_pm.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/pm_runtime.h>
+#include <linux/module.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
Index: linux/drivers/spi/dw_spi.c
===================================================================
--- linux.orig/drivers/spi/dw_spi.c
+++ linux/drivers/spi/dw_spi.c
@@ -19,6 +19,7 @@
 
 #include <linux/dma-mapping.h>
 #include <linux/interrupt.h>
+#include <linux/module.h>
 #include <linux/highmem.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
Index: linux/drivers/spi/dw_spi_pci.c
===================================================================
--- linux.orig/drivers/spi/dw_spi_pci.c
+++ linux/drivers/spi/dw_spi_pci.c
@@ -19,6 +19,7 @@
 
 #include <linux/interrupt.h>
 #include <linux/pci.h>
+#include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/spi/spi.h>
 
Index: linux/drivers/spi/pxa2xx_spi_pci.c
===================================================================
--- linux.orig/drivers/spi/pxa2xx_spi_pci.c
+++ linux/drivers/spi/pxa2xx_spi_pci.c
@@ -4,6 +4,7 @@
  */
 #include <linux/pci.h>
 #include <linux/platform_device.h>
+#include <linux/module.h>
 #include <linux/of_device.h>
 #include <linux/spi/pxa2xx_spi.h>
 
Index: linux/drivers/spi/spi.c
===================================================================
--- linux.orig/drivers/spi/spi.c
+++ linux/drivers/spi/spi.c
@@ -20,6 +20,7 @@
 
 #include <linux/kernel.h>
 #include <linux/device.h>
+#include <linux/module.h>
 #include <linux/init.h>
 #include <linux/cache.h>
 #include <linux/mutex.h>
Index: linux/drivers/spi/spi_altera.c
===================================================================
--- linux.orig/drivers/spi/spi_altera.c
+++ linux/drivers/spi/spi_altera.c
@@ -15,6 +15,7 @@
 
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/platform_device.h>
 #include <linux/spi/spi.h>
Index: linux/drivers/spi/spi_bitbang.c
===================================================================
--- linux.orig/drivers/spi/spi_bitbang.c
+++ linux/drivers/spi/spi_bitbang.c
@@ -18,6 +18,7 @@
 
 #include <linux/init.h>
 #include <linux/spinlock.h>
+#include <linux/module.h>
 #include <linux/workqueue.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
Index: linux/drivers/spi/spi_butterfly.c
===================================================================
--- linux.orig/drivers/spi/spi_butterfly.c
+++ linux/drivers/spi/spi_butterfly.c
@@ -19,6 +19,7 @@
  */
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/parport.h>
Index: linux/drivers/spi/spi_oc_tiny.c
===================================================================
--- linux.orig/drivers/spi/spi_oc_tiny.c
+++ linux/drivers/spi/spi_oc_tiny.c
@@ -17,6 +17,7 @@
 
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/platform_device.h>
 #include <linux/spi/spi.h>
Index: linux/drivers/spi/tle62x0.c
===================================================================
--- linux.orig/drivers/spi/tle62x0.c
+++ linux/drivers/spi/tle62x0.c
@@ -10,6 +10,7 @@
  */
 
 #include <linux/device.h>
+#include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
 
Index: linux/drivers/tty/serial/max3100.c
===================================================================
--- linux.orig/drivers/tty/serial/max3100.c
+++ linux/drivers/tty/serial/max3100.c
@@ -42,6 +42,7 @@
 
 #include <linux/delay.h>
 #include <linux/slab.h>
+#include <linux/module.h>
 #include <linux/device.h>
 #include <linux/serial_core.h>
 #include <linux/serial.h>
Index: linux/drivers/tty/serial/max3107-aava.c
===================================================================
--- linux.orig/drivers/tty/serial/max3107-aava.c
+++ linux/drivers/tty/serial/max3107-aava.c
@@ -28,6 +28,7 @@
  */
 
 #include <linux/delay.h>
+#include <linux/module.h>
 #include <linux/device.h>
 #include <linux/serial_core.h>
 #include <linux/serial.h>
Index: linux/drivers/tty/serial/max3107.c
===================================================================
--- linux.orig/drivers/tty/serial/max3107.c
+++ linux/drivers/tty/serial/max3107.c
@@ -29,6 +29,7 @@
 
 #include <linux/delay.h>
 #include <linux/device.h>
+#include <linux/module.h>
 #include <linux/serial_core.h>
 #include <linux/serial.h>
 #include <linux/gpio.h>
Index: linux/drivers/tty/serial/timbuart.c
===================================================================
--- linux.orig/drivers/tty/serial/timbuart.c
+++ linux/drivers/tty/serial/timbuart.c
@@ -22,6 +22,7 @@
 
 #include <linux/pci.h>
 #include <linux/interrupt.h>
+#include <linux/module.h>
 #include <linux/serial_core.h>
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
Index: linux/drivers/tty/serial/xilinx_uartps.c
===================================================================
--- linux.orig/drivers/tty/serial/xilinx_uartps.c
+++ linux/drivers/tty/serial/xilinx_uartps.c
@@ -13,6 +13,7 @@
 
 #include <linux/platform_device.h>
 #include <linux/serial_core.h>
+#include <linux/module.h>
 #include <linux/console.h>
 #include <linux/serial.h>
 #include <linux/irq.h>
Index: linux/drivers/uio/uio_pdrv.c
===================================================================
--- linux.orig/drivers/uio/uio_pdrv.c
+++ linux/drivers/uio/uio_pdrv.c
@@ -10,6 +10,7 @@
  */
 #include <linux/platform_device.h>
 #include <linux/uio_driver.h>
+#include <linux/module.h>
 #include <linux/stringify.h>
 #include <linux/slab.h>
 
Index: linux/drivers/uio/uio_pdrv_genirq.c
===================================================================
--- linux.orig/drivers/uio/uio_pdrv_genirq.c
+++ linux/drivers/uio/uio_pdrv_genirq.c
@@ -16,6 +16,7 @@
 
 #include <linux/platform_device.h>
 #include <linux/uio_driver.h>
+#include <linux/module.h>
 #include <linux/spinlock.h>
 #include <linux/bitops.h>
 #include <linux/interrupt.h>
Index: linux/drivers/usb/wusbcore/devconnect.c
===================================================================
--- linux.orig/drivers/usb/wusbcore/devconnect.c
+++ linux/drivers/usb/wusbcore/devconnect.c
@@ -88,6 +88,7 @@
 
 #include <linux/jiffies.h>
 #include <linux/ctype.h>
+#include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/workqueue.h>
 #include "wusbhc.h"
Index: linux/drivers/usb/wusbcore/mmc.c
===================================================================
--- linux.orig/drivers/usb/wusbcore/mmc.c
+++ linux/drivers/usb/wusbcore/mmc.c
@@ -38,6 +38,7 @@
  */
 #include <linux/usb/wusb.h>
 #include <linux/slab.h>
+#include <linux/module.h>
 #include "wusbhc.h"
 
 /* Initialize the MMCIEs handling mechanism */
Index: linux/drivers/usb/wusbcore/rh.c
===================================================================
--- linux.orig/drivers/usb/wusbcore/rh.c
+++ linux/drivers/usb/wusbcore/rh.c
@@ -70,6 +70,7 @@
  * wusbhc_rh_start_port_reset() ??? unimplemented
  */
 #include <linux/slab.h>
+#include <linux/module.h>
 #include "wusbhc.h"
 
 /*
Index: linux/drivers/usb/wusbcore/security.c
===================================================================
--- linux.orig/drivers/usb/wusbcore/security.c
+++ linux/drivers/usb/wusbcore/security.c
@@ -24,6 +24,7 @@
  */
 #include <linux/types.h>
 #include <linux/slab.h>
+#include <linux/module.h>
 #include <linux/usb/ch9.h>
 #include <linux/random.h>
 #include "wusbhc.h"
Index: linux/drivers/usb/wusbcore/wa-rpipe.c
===================================================================
--- linux.orig/drivers/usb/wusbcore/wa-rpipe.c
+++ linux/drivers/usb/wusbcore/wa-rpipe.c
@@ -60,6 +60,7 @@
 #include <linux/init.h>
 #include <asm/atomic.h>
 #include <linux/bitmap.h>
+#include <linux/module.h>
 #include <linux/slab.h>
 
 #include "wusbhc.h"
Index: linux/drivers/usb/wusbcore/wa-xfer.c
===================================================================
--- linux.orig/drivers/usb/wusbcore/wa-xfer.c
+++ linux/drivers/usb/wusbcore/wa-xfer.c
@@ -80,6 +80,7 @@
  *     rpipes, segment slots, etc), we go scheduling them. Painful.
  */
 #include <linux/init.h>
+#include <linux/module.h>
 #include <linux/spinlock.h>
 #include <linux/slab.h>
 #include <linux/hash.h>
Index: linux/drivers/uwb/est.c
===================================================================
--- linux.orig/drivers/uwb/est.c
+++ linux/drivers/uwb/est.c
@@ -41,6 +41,7 @@
  */
 #include <linux/spinlock.h>
 #include <linux/slab.h>
+#include <linux/module.h>
 
 #include "uwb-internal.h"
 
Index: linux/drivers/uwb/i1480/dfu/dfu.c
===================================================================
--- linux.orig/drivers/uwb/i1480/dfu/dfu.c
+++ linux/drivers/uwb/i1480/dfu/dfu.c
@@ -28,6 +28,7 @@
  */
 #include "i1480-dfu.h"
 #include <linux/errno.h>
+#include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/pci.h>
 #include <linux/device.h>
Index: linux/drivers/uwb/ie.c
===================================================================
--- linux.orig/drivers/uwb/ie.c
+++ linux/drivers/uwb/ie.c
@@ -25,6 +25,7 @@
  */
 
 #include <linux/slab.h>
+#include <linux/module.h>
 #include "uwb-internal.h"
 
 /**
Index: linux/drivers/uwb/lc-dev.c
===================================================================
--- linux.orig/drivers/uwb/lc-dev.c
+++ linux/drivers/uwb/lc-dev.c
@@ -24,6 +24,7 @@
  */
 #include <linux/kernel.h>
 #include <linux/slab.h>
+#include <linux/module.h>
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/kdev_t.h>
Index: linux/drivers/uwb/neh.c
===================================================================
--- linux.orig/drivers/uwb/neh.c
+++ linux/drivers/uwb/neh.c
@@ -83,6 +83,7 @@
  */
 #include <linux/kernel.h>
 #include <linux/timer.h>
+#include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/err.h>
 
Index: linux/drivers/uwb/pal.c
===================================================================
--- linux.orig/drivers/uwb/pal.c
+++ linux/drivers/uwb/pal.c
@@ -17,6 +17,7 @@
  */
 #include <linux/kernel.h>
 #include <linux/debugfs.h>
+#include <linux/module.h>
 #include <linux/uwb.h>
 
 #include "uwb-internal.h"
Index: linux/drivers/uwb/radio.c
===================================================================
--- linux.orig/drivers/uwb/radio.c
+++ linux/drivers/uwb/radio.c
@@ -17,6 +17,7 @@
  */
 #include <linux/kernel.h>
 #include <linux/uwb.h>
+#include <linux/module.h>
 
 #include "uwb-internal.h"
 
Index: linux/drivers/uwb/reset.c
===================================================================
--- linux.orig/drivers/uwb/reset.c
+++ linux/drivers/uwb/reset.c
@@ -30,6 +30,7 @@
  */
 #include <linux/kernel.h>
 #include <linux/err.h>
+#include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
 
Index: linux/drivers/uwb/rsv.c
===================================================================
--- linux.orig/drivers/uwb/rsv.c
+++ linux/drivers/uwb/rsv.c
@@ -17,6 +17,7 @@
  */
 #include <linux/kernel.h>
 #include <linux/uwb.h>
+#include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/random.h>
 
Index: linux/drivers/uwb/scan.c
===================================================================
--- linux.orig/drivers/uwb/scan.c
+++ linux/drivers/uwb/scan.c
@@ -36,6 +36,7 @@
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/slab.h>
+#include <linux/stat.h>
 #include "uwb-internal.h"
 
 
Index: linux/drivers/video/backlight/88pm860x_bl.c
===================================================================
--- linux.orig/drivers/video/backlight/88pm860x_bl.c
+++ linux/drivers/video/backlight/88pm860x_bl.c
@@ -11,6 +11,7 @@
 
 #include <linux/init.h>
 #include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/fb.h>
Index: linux/drivers/video/backlight/adp5520_bl.c
===================================================================
--- linux.orig/drivers/video/backlight/adp5520_bl.c
+++ linux/drivers/video/backlight/adp5520_bl.c
@@ -8,6 +8,7 @@
 
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/fb.h>
 #include <linux/backlight.h>
Index: linux/drivers/video/backlight/da903x_bl.c
===================================================================
--- linux.orig/drivers/video/backlight/da903x_bl.c
+++ linux/drivers/video/backlight/da903x_bl.c
@@ -14,6 +14,7 @@
 
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/fb.h>
 #include <linux/backlight.h>
Index: linux/drivers/video/backlight/l4f00242t03.c
===================================================================
--- linux.orig/drivers/video/backlight/l4f00242t03.c
+++ linux/drivers/video/backlight/l4f00242t03.c
@@ -13,6 +13,7 @@
 
 #include <linux/device.h>
 #include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/gpio.h>
 #include <linux/lcd.h>
Index: linux/drivers/video/backlight/ld9040.c
===================================================================
--- linux.orig/drivers/video/backlight/ld9040.c
+++ linux/drivers/video/backlight/ld9040.c
@@ -22,6 +22,7 @@
 
 #include <linux/wait.h>
 #include <linux/fb.h>
+#include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/gpio.h>
 #include <linux/spi/spi.h>
Index: linux/drivers/video/backlight/lms283gf05.c
===================================================================
--- linux.orig/drivers/video/backlight/lms283gf05.c
+++ linux/drivers/video/backlight/lms283gf05.c
@@ -10,6 +10,7 @@
 
 #include <linux/device.h>
 #include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/gpio.h>
Index: linux/drivers/video/backlight/max8925_bl.c
===================================================================
--- linux.orig/drivers/video/backlight/max8925_bl.c
+++ linux/drivers/video/backlight/max8925_bl.c
@@ -11,6 +11,7 @@
 
 #include <linux/init.h>
 #include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/fb.h>
 #include <linux/i2c.h>
Index: linux/drivers/video/backlight/s6e63m0.c
===================================================================
--- linux.orig/drivers/video/backlight/s6e63m0.c
+++ linux/drivers/video/backlight/s6e63m0.c
@@ -22,6 +22,7 @@
 
 #include <linux/wait.h>
 #include <linux/fb.h>
+#include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/gpio.h>
 #include <linux/spi/spi.h>
Index: linux/drivers/video/backlight/wm831x_bl.c
===================================================================
--- linux.orig/drivers/video/backlight/wm831x_bl.c
+++ linux/drivers/video/backlight/wm831x_bl.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/fb.h>
Index: linux/drivers/video/carminefb.c
===================================================================
--- linux.orig/drivers/video/carminefb.c
+++ linux/drivers/video/carminefb.c
@@ -8,6 +8,7 @@
  */
 #include <linux/delay.h>
 #include <linux/errno.h>
+#include <linux/module.h>
 #include <linux/fb.h>
 #include <linux/interrupt.h>
 #include <linux/pci.h>
Index: linux/drivers/video/mb862xx/mb862xxfb.c
===================================================================
--- linux.orig/drivers/video/mb862xx/mb862xxfb.c
+++ linux/drivers/video/mb862xx/mb862xxfb.c
@@ -16,6 +16,7 @@
 
 #include <linux/fb.h>
 #include <linux/delay.h>
+#include <linux/module.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/pci.h>
Index: linux/drivers/video/savage/savagefb_accel.c
===================================================================
--- linux.orig/drivers/video/savage/savagefb_accel.c
+++ linux/drivers/video/savage/savagefb_accel.c
@@ -10,6 +10,7 @@
  */
 #include <linux/kernel.h>
 #include <linux/string.h>
+#include <linux/module.h>
 #include <linux/fb.h>
 
 #include "savagefb.h"
Index: linux/drivers/video/via/via-gpio.c
===================================================================
--- linux.orig/drivers/video/via/via-gpio.c
+++ linux/drivers/video/via/via-gpio.c
@@ -7,6 +7,7 @@
 
 #include <linux/spinlock.h>
 #include <linux/gpio.h>
+#include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/via-core.h>
 #include <linux/via-gpio.h>
Index: linux/drivers/virtio/virtio.c
===================================================================
--- linux.orig/drivers/virtio/virtio.c
+++ linux/drivers/virtio/virtio.c
@@ -1,6 +1,7 @@
 #include <linux/virtio.h>
 #include <linux/spinlock.h>
 #include <linux/virtio_config.h>
+#include <linux/module.h>
 
 /* Unique numbering for virtio devices. */
 static unsigned int dev_index;
Index: linux/drivers/virtio/virtio_balloon.c
===================================================================
--- linux.orig/drivers/virtio/virtio_balloon.c
+++ linux/drivers/virtio/virtio_balloon.c
@@ -20,6 +20,7 @@
 //#define DEBUG
 #include <linux/virtio.h>
 #include <linux/virtio_balloon.h>
+#include <linux/module.h>
 #include <linux/swap.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
Index: linux/drivers/virtio/virtio_ring.c
===================================================================
--- linux.orig/drivers/virtio/virtio_ring.c
+++ linux/drivers/virtio/virtio_ring.c
@@ -18,6 +18,7 @@
  */
 #include <linux/virtio.h>
 #include <linux/virtio_ring.h>
+#include <linux/module.h>
 #include <linux/virtio_config.h>
 #include <linux/device.h>
 #include <linux/slab.h>
Index: linux/drivers/w1/w1_family.c
===================================================================
--- linux.orig/drivers/w1/w1_family.c
+++ linux/drivers/w1/w1_family.c
@@ -21,6 +21,7 @@
 
 #include <linux/spinlock.h>
 #include <linux/list.h>
+#include <linux/module.h>
 #include <linux/sched.h>	/* schedule_timeout() */
 #include <linux/delay.h>
 
Index: linux/drivers/xen/balloon.c
===================================================================
--- linux.orig/drivers/xen/balloon.c
+++ linux/drivers/xen/balloon.c
@@ -32,6 +32,7 @@
 
 #include <linux/kernel.h>
 #include <linux/sched.h>
+#include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/mm.h>
 #include <linux/bootmem.h>
Index: linux/drivers/xen/manage.c
===================================================================
--- linux.orig/drivers/xen/manage.c
+++ linux/drivers/xen/manage.c
@@ -3,6 +3,7 @@
  */
 #include <linux/kernel.h>
 #include <linux/err.h>
+#include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/reboot.h>
 #include <linux/sysrq.h>
Index: linux/drivers/xen/swiotlb-xen.c
===================================================================
--- linux.orig/drivers/xen/swiotlb-xen.c
+++ linux/drivers/xen/swiotlb-xen.c
@@ -34,6 +34,7 @@
  */
 
 #include <linux/bootmem.h>
+#include <linux/module.h>
 #include <linux/dma-mapping.h>
 #include <xen/swiotlb-xen.h>
 #include <xen/page.h>
Index: linux/fs/bio-integrity.c
===================================================================
--- linux.orig/fs/bio-integrity.c
+++ linux/fs/bio-integrity.c
@@ -25,6 +25,7 @@
 #include <linux/bio.h>
 #include <linux/workqueue.h>
 #include <linux/slab.h>
+#include <linux/module.h>
 
 struct integrity_slab {
 	struct kmem_cache *slab;
Index: linux/fs/exofs/super.c
===================================================================
--- linux.orig/fs/exofs/super.c
+++ linux/fs/exofs/super.c
@@ -37,6 +37,7 @@
 #include <linux/random.h>
 #include <linux/exportfs.h>
 #include <linux/slab.h>
+#include <linux/module.h>
 
 #include "exofs.h"
 
Index: linux/fs/gfs2/ops_fstype.c
===================================================================
--- linux.orig/fs/gfs2/ops_fstype.c
+++ linux/fs/gfs2/ops_fstype.c
@@ -18,6 +18,7 @@
 #include <linux/mount.h>
 #include <linux/gfs2_ondisk.h>
 #include <linux/quotaops.h>
+#include <linux/module.h>
 
 #include "gfs2.h"
 #include "incore.h"
Index: linux/fs/jfs/jfs_logmgr.c
===================================================================
--- linux.orig/fs/jfs/jfs_logmgr.c
+++ linux/fs/jfs/jfs_logmgr.c
@@ -71,6 +71,7 @@
 #include <linux/mutex.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
+#include <linux/module.h>
 #include "jfs_incore.h"
 #include "jfs_filsys.h"
 #include "jfs_metapage.h"
Index: linux/fs/logfs/super.c
===================================================================
--- linux.orig/fs/logfs/super.c
+++ linux/fs/logfs/super.c
@@ -16,6 +16,7 @@
 #include <linux/mtd/mtd.h>
 #include <linux/statfs.h>
 #include <linux/buffer_head.h>
+#include <linux/module.h>
 
 static DEFINE_MUTEX(emergency_mutex);
 static struct page *emergency_page;
Index: linux/include/linux/bcma/bcma.h
===================================================================
--- linux.orig/include/linux/bcma/bcma.h
+++ linux/include/linux/bcma/bcma.h
@@ -6,6 +6,7 @@
 
 #include <linux/bcma/bcma_driver_chipcommon.h>
 #include <linux/bcma/bcma_driver_pci.h>
+#include <linux/module.h>
 
 #include "bcma_regs.h"
 
Index: linux/include/linux/gameport.h
===================================================================
--- linux.orig/include/linux/gameport.h
+++ linux/include/linux/gameport.h
@@ -17,6 +17,7 @@
 #include <linux/device.h>
 #include <linux/timer.h>
 #include <linux/slab.h>
+#include <linux/module.h>
 
 struct gameport {
 
Index: linux/include/linux/ssb/ssb.h
===================================================================
--- linux.orig/include/linux/ssb/ssb.h
+++ linux/include/linux/ssb/ssb.h
@@ -8,6 +8,7 @@
 #include <linux/pci.h>
 #include <linux/mod_devicetable.h>
 #include <linux/dma-mapping.h>
+#include <linux/module.h>
 
 #include <linux/ssb/ssb_regs.h>
 
Index: linux/include/linux/uio_driver.h
===================================================================
--- linux.orig/include/linux/uio_driver.h
+++ linux/include/linux/uio_driver.h
@@ -16,6 +16,7 @@
 
 #include <linux/fs.h>
 #include <linux/interrupt.h>
+#include <linux/module.h>
 
 struct module;
 struct uio_map;
Index: linux/include/xen/xenbus.h
===================================================================
--- linux.orig/include/xen/xenbus.h
+++ linux/include/xen/xenbus.h
@@ -35,6 +35,7 @@
 #define _XEN_XENBUS_H
 
 #include <linux/device.h>
+#include <linux/module.h>
 #include <linux/notifier.h>
 #include <linux/mutex.h>
 #include <linux/completion.h>
Index: linux/kernel/debug/kdb/kdb_debugger.c
===================================================================
--- linux.orig/kernel/debug/kdb/kdb_debugger.c
+++ linux/kernel/debug/kdb/kdb_debugger.c
@@ -11,6 +11,7 @@
 #include <linux/kgdb.h>
 #include <linux/kdb.h>
 #include <linux/kdebug.h>
+#include <linux/module.h>
 #include "kdb_private.h"
 #include "../debug_core.h"
 
Index: linux/kernel/jump_label.c
===================================================================
--- linux.orig/kernel/jump_label.c
+++ linux/kernel/jump_label.c
@@ -13,6 +13,7 @@
 #include <linux/sort.h>
 #include <linux/err.h>
 #include <linux/jump_label.h>
+#include <linux/module.h>
 
 #ifdef HAVE_JUMP_LABEL
 
Index: linux/kernel/ksysfs.c
===================================================================
--- linux.orig/kernel/ksysfs.c
+++ linux/kernel/ksysfs.c
@@ -17,6 +17,7 @@
 #include <linux/profile.h>
 #include <linux/sched.h>
 #include <linux/capability.h>
+#include <linux/stat.h>
 
 #define KERNEL_ATTR_RO(_name) \
 static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
Index: linux/kernel/rcutorture.c
===================================================================
--- linux.orig/kernel/rcutorture.c
+++ linux/kernel/rcutorture.c
@@ -23,6 +23,7 @@
  * See also:  Documentation/RCU/torture.txt
  */
 #include <linux/types.h>
+#include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/export.h>
Index: linux/kernel/rcutree_trace.c
===================================================================
--- linux.orig/kernel/rcutree_trace.c
+++ linux/kernel/rcutree_trace.c
@@ -24,6 +24,7 @@
  *
  */
 #include <linux/types.h>
+#include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/spinlock.h>
Index: linux/kernel/trace/ftrace.c
===================================================================
--- linux.orig/kernel/trace/ftrace.c
+++ linux/kernel/trace/ftrace.c
@@ -23,6 +23,7 @@
 #include <linux/kthread.h>
 #include <linux/uaccess.h>
 #include <linux/ftrace.h>
+#include <linux/module.h>
 #include <linux/sysctl.h>
 #include <linux/slab.h>
 #include <linux/ctype.h>
Index: linux/kernel/trace/trace_syscalls.c
===================================================================
--- linux.orig/kernel/trace/trace_syscalls.c
+++ linux/kernel/trace/trace_syscalls.c
@@ -4,6 +4,8 @@
 #include <linux/kernel.h>
 #include <linux/ftrace.h>
 #include <linux/perf_event.h>
+#include <linux/module.h>
+
 #include <asm/syscall.h>
 
 #include "trace_output.h"
Index: linux/kernel/watchdog.c
===================================================================
--- linux.orig/kernel/watchdog.c
+++ linux/kernel/watchdog.c
@@ -23,6 +23,7 @@
 #include <linux/notifier.h>
 #include <linux/export.h>
 #include <linux/sysctl.h>
+#include <linux/module.h>
 
 #include <asm/irq_regs.h>
 #include <linux/perf_event.h>
Index: linux/lib/dma-debug.c
===================================================================
--- linux.orig/lib/dma-debug.c
+++ linux/lib/dma-debug.c
@@ -25,6 +25,7 @@
 #include <linux/debugfs.h>
 #include <linux/uaccess.h>
 #include <linux/device.h>
+#include <linux/module.h>
 #include <linux/types.h>
 #include <linux/sched.h>
 #include <linux/ctype.h>
Index: linux/mm/memory-failure.c
===================================================================
--- linux.orig/mm/memory-failure.c
+++ linux/mm/memory-failure.c
@@ -52,6 +52,7 @@
 #include <linux/swapops.h>
 #include <linux/hugetlb.h>
 #include <linux/memory_hotplug.h>
+#include <linux/module.h>
 #include "internal.h"
 
 int sysctl_memory_failure_early_kill __read_mostly = 0;
Index: linux/net/caif/cfpkt_skbuff.c
===================================================================
--- linux.orig/net/caif/cfpkt_skbuff.c
+++ linux/net/caif/cfpkt_skbuff.c
@@ -9,6 +9,8 @@
 #include <linux/string.h>
 #include <linux/skbuff.h>
 #include <linux/hardirq.h>
+#include <linux/module.h>
+
 #include <net/caif/cfpkt.h>
 
 #define PKT_PREFIX  48
Index: linux/net/netfilter/ipset/pfxlen.c
===================================================================
--- linux.orig/net/netfilter/ipset/pfxlen.c
+++ linux/net/netfilter/ipset/pfxlen.c
@@ -1,4 +1,5 @@
 #include <linux/netfilter/ipset/pfxlen.h>
+#include <linux/module.h>
 
 /*
  * Prefixlen maps for fast conversions, by Jan Engelhardt.
Index: linux/sound/core/jack.c
===================================================================
--- linux.orig/sound/core/jack.c
+++ linux/sound/core/jack.c
@@ -21,6 +21,7 @@
 
 #include <linux/input.h>
 #include <linux/slab.h>
+#include <linux/module.h>
 #include <sound/jack.h>
 #include <sound/core.h>
 
Index: linux/sound/core/rawmidi.c
===================================================================
--- linux.orig/sound/core/rawmidi.c
+++ linux/sound/core/rawmidi.c
@@ -28,6 +28,7 @@
 #include <linux/wait.h>
 #include <linux/mutex.h>
 #include <linux/moduleparam.h>
+#include <linux/module.h>
 #include <linux/delay.h>
 #include <sound/rawmidi.h>
 #include <sound/info.h>
Index: linux/sound/core/seq/seq_midi.c
===================================================================
--- linux.orig/sound/core/seq/seq_midi.c
+++ linux/sound/core/seq/seq_midi.c
@@ -32,6 +32,7 @@ Possible options for midisynth module:
 #include <linux/string.h>
 #include <linux/moduleparam.h>
 #include <linux/mutex.h>
+#include <linux/module.h>
 #include <sound/core.h>
 #include <sound/rawmidi.h>
 #include <sound/seq_kernel.h>
Index: linux/sound/core/seq/seq_midi_emul.c
===================================================================
--- linux.orig/sound/core/seq/seq_midi_emul.c
+++ linux/sound/core/seq/seq_midi_emul.c
@@ -32,6 +32,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/module.h>
 #include <sound/core.h>
 #include <sound/seq_kernel.h>
 #include <sound/seq_midi_emul.h>
Index: linux/sound/core/seq/seq_virmidi.c
===================================================================
--- linux.orig/sound/core/seq/seq_virmidi.c
+++ linux/sound/core/seq/seq_virmidi.c
@@ -46,6 +46,7 @@
 #include <sound/seq_kernel.h>
 #include <sound/seq_midi_event.h>
 #include <sound/seq_virmidi.h>
+#include <linux/module.h>
 
 MODULE_AUTHOR("Takashi Iwai <tiwai@suse.de>");
 MODULE_DESCRIPTION("Virtual Raw MIDI client on Sequencer");
Index: linux/sound/drivers/mpu401/mpu401.c
===================================================================
--- linux.orig/sound/drivers/mpu401/mpu401.c
+++ linux/sound/drivers/mpu401/mpu401.c
@@ -25,6 +25,7 @@
 #include <linux/err.h>
 #include <linux/platform_device.h>
 #include <linux/moduleparam.h>
+#include <linux/module.h>
 #include <sound/core.h>
 #include <sound/mpu401.h>
 #include <sound/initval.h>
Index: linux/sound/drivers/mpu401/mpu401_uart.c
===================================================================
--- linux.orig/sound/drivers/mpu401/mpu401_uart.c
+++ linux/sound/drivers/mpu401/mpu401_uart.c
@@ -35,6 +35,7 @@
 #include <linux/ioport.h>
 #include <linux/interrupt.h>
 #include <linux/errno.h>
+#include <linux/module.h>
 #include <sound/core.h>
 #include <sound/mpu401.h>
 
Index: linux/sound/drivers/mtpav.c
===================================================================
--- linux.orig/sound/drivers/mtpav.c
+++ linux/sound/drivers/mtpav.c
@@ -61,6 +61,7 @@
 #include <sound/initval.h>
 #include <sound/rawmidi.h>
 #include <linux/delay.h>
+#include <linux/module.h>
 
 /*
  *      globals
Index: linux/sound/drivers/mts64.c
===================================================================
--- linux.orig/sound/drivers/mts64.c
+++ linux/sound/drivers/mts64.c
@@ -24,6 +24,7 @@
 #include <linux/spinlock.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
+#include <linux/module.h>
 #include <sound/core.h>
 #include <sound/initval.h>
 #include <sound/rawmidi.h>
Index: linux/sound/drivers/opl3/opl3_lib.c
===================================================================
--- linux.orig/sound/drivers/opl3/opl3_lib.c
+++ linux/sound/drivers/opl3/opl3_lib.c
@@ -29,6 +29,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/ioport.h>
+#include <linux/module.h>
 #include <sound/minors.h>
 
 MODULE_AUTHOR("Jaroslav Kysela <perex@perex.cz>, Hannu Savolainen 1993-1996, Rob Hooft");
Index: linux/sound/drivers/opl3/opl3_oss.c
===================================================================
--- linux.orig/sound/drivers/opl3/opl3_oss.c
+++ linux/sound/drivers/opl3/opl3_oss.c
@@ -18,6 +18,8 @@
  *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
  */
 
+#include <linux/module.h>
+
 #include "opl3_voice.h"
 
 static int snd_opl3_open_seq_oss(struct snd_seq_oss_arg *arg, void *closure);
Index: linux/sound/drivers/opl3/opl3_seq.c
===================================================================
--- linux.orig/sound/drivers/opl3/opl3_seq.c
+++ linux/sound/drivers/opl3/opl3_seq.c
@@ -25,6 +25,7 @@
 #include "opl3_voice.h"
 #include <linux/init.h>
 #include <linux/moduleparam.h>
+#include <linux/module.h>
 #include <sound/initval.h>
 
 MODULE_AUTHOR("Uros Bizjak <uros@kss-loka.si>");
Index: linux/sound/drivers/opl3/opl3_synth.c
===================================================================
--- linux.orig/sound/drivers/opl3/opl3_synth.c
+++ linux/sound/drivers/opl3/opl3_synth.c
@@ -20,6 +20,7 @@
  */
 
 #include <linux/slab.h>
+#include <linux/module.h>
 #include <sound/opl3.h>
 #include <sound/asound_fm.h>
 
Index: linux/sound/drivers/opl4/opl4_lib.c
===================================================================
--- linux.orig/sound/drivers/opl4/opl4_lib.c
+++ linux/sound/drivers/opl4/opl4_lib.c
@@ -20,6 +20,7 @@
 #include "opl4_local.h"
 #include <sound/initval.h>
 #include <linux/ioport.h>
+#include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <asm/io.h>
Index: linux/sound/drivers/opl4/opl4_proc.c
===================================================================
--- linux.orig/sound/drivers/opl4/opl4_proc.c
+++ linux/sound/drivers/opl4/opl4_proc.c
@@ -19,6 +19,7 @@
 
 #include "opl4_local.h"
 #include <linux/vmalloc.h>
+#include <linux/module.h>
 #include <sound/info.h>
 
 #ifdef CONFIG_PROC_FS
Index: linux/sound/drivers/opl4/opl4_seq.c
===================================================================
--- linux.orig/sound/drivers/opl4/opl4_seq.c
+++ linux/sound/drivers/opl4/opl4_seq.c
@@ -33,6 +33,7 @@
 
 #include "opl4_local.h"
 #include <linux/init.h>
+#include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <sound/initval.h>
 
Index: linux/sound/drivers/portman2x4.c
===================================================================
--- linux.orig/sound/drivers/portman2x4.c
+++ linux/sound/drivers/portman2x4.c
@@ -43,6 +43,7 @@
 #include <linux/spinlock.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
+#include <linux/module.h>
 #include <sound/core.h>
 #include <sound/initval.h>
 #include <sound/rawmidi.h>
Index: linux/sound/drivers/serial-u16550.c
===================================================================
--- linux.orig/sound/drivers/serial-u16550.c
+++ linux/sound/drivers/serial-u16550.c
@@ -37,6 +37,7 @@
 #include <linux/slab.h>
 #include <linux/ioport.h>
 #include <linux/moduleparam.h>
+#include <linux/module.h>
 #include <sound/core.h>
 #include <sound/rawmidi.h>
 #include <sound/initval.h>
Index: linux/sound/drivers/virmidi.c
===================================================================
--- linux.orig/sound/drivers/virmidi.c
+++ linux/sound/drivers/virmidi.c
@@ -46,6 +46,7 @@
 #include <linux/err.h>
 #include <linux/platform_device.h>
 #include <linux/moduleparam.h>
+#include <linux/module.h>
 #include <sound/core.h>
 #include <sound/seq_kernel.h>
 #include <sound/seq_virmidi.h>
Index: linux/sound/firewire/iso-resources.c
===================================================================
--- linux.orig/sound/firewire/iso-resources.c
+++ linux/sound/firewire/iso-resources.c
@@ -12,6 +12,7 @@
 #include <linux/mutex.h>
 #include <linux/sched.h>
 #include <linux/spinlock.h>
+#include <linux/module.h>
 #include "iso-resources.h"
 
 /**
Index: linux/sound/firewire/packets-buffer.c
===================================================================
--- linux.orig/sound/firewire/packets-buffer.c
+++ linux/sound/firewire/packets-buffer.c
@@ -7,6 +7,7 @@
 
 #include <linux/firewire.h>
 #include <linux/slab.h>
+#include <linux/module.h>
 #include "packets-buffer.h"
 
 /**
Index: linux/sound/i2c/i2c.c
===================================================================
--- linux.orig/sound/i2c/i2c.c
+++ linux/sound/i2c/i2c.c
@@ -24,6 +24,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/errno.h>
+#include <linux/module.h>
 #include <sound/core.h>
 #include <sound/i2c.h>
 
Index: linux/sound/i2c/other/ak4xxx-adda.c
===================================================================
--- linux.orig/sound/i2c/other/ak4xxx-adda.c
+++ linux/sound/i2c/other/ak4xxx-adda.c
@@ -25,6 +25,7 @@
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/init.h>
+#include <linux/module.h>
 #include <sound/core.h>
 #include <sound/control.h>
 #include <sound/tlv.h>
Index: linux/sound/i2c/other/pt2258.c
===================================================================
--- linux.orig/sound/i2c/other/pt2258.c
+++ linux/sound/i2c/other/pt2258.c
@@ -19,6 +19,8 @@
  *
  */      
 
+#include <linux/module.h>
+
 #include <sound/core.h>
 #include <sound/control.h>
 #include <sound/tlv.h>
Index: linux/sound/i2c/other/tea575x-tuner.c
===================================================================
--- linux.orig/sound/i2c/other/tea575x-tuner.c
+++ linux/sound/i2c/other/tea575x-tuner.c
@@ -26,6 +26,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/version.h>
+#include <linux/module.h>
 #include <sound/core.h>
 #include <sound/tea575x-tuner.h>
 
Index: linux/sound/i2c/tea6330t.c
===================================================================
--- linux.orig/sound/i2c/tea6330t.c
+++ linux/sound/i2c/tea6330t.c
@@ -22,6 +22,7 @@
 
 #include <linux/init.h>
 #include <linux/slab.h>
+#include <linux/module.h>
 #include <sound/core.h>
 #include <sound/control.h>
 #include <sound/tea6330t.h>
Index: linux/sound/isa/sb/emu8000.c
===================================================================
--- linux.orig/sound/isa/sb/emu8000.c
+++ linux/sound/isa/sb/emu8000.c
@@ -21,6 +21,7 @@
  */
 
 #include <linux/wait.h>
+#include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/ioport.h>
Index: linux/sound/isa/sb/emu8000_callback.c
===================================================================
--- linux.orig/sound/isa/sb/emu8000_callback.c
+++ linux/sound/isa/sb/emu8000_callback.c
@@ -20,6 +20,7 @@
  */
 
 #include "emu8000_local.h"
+#include <linux/module.h>
 #include <sound/asoundef.h>
 
 /*
Index: linux/sound/isa/sb/emu8000_patch.c
===================================================================
--- linux.orig/sound/isa/sb/emu8000_patch.c
+++ linux/sound/isa/sb/emu8000_patch.c
@@ -22,6 +22,7 @@
 #include "emu8000_local.h"
 #include <asm/uaccess.h>
 #include <linux/moduleparam.h>
+#include <linux/module.h>
 
 static int emu8000_reset_addr;
 module_param(emu8000_reset_addr, int, 0444);
Index: linux/sound/isa/sb/emu8000_synth.c
===================================================================
--- linux.orig/sound/isa/sb/emu8000_synth.c
+++ linux/sound/isa/sb/emu8000_synth.c
@@ -22,6 +22,7 @@
 
 #include "emu8000_local.h"
 #include <linux/init.h>
+#include <linux/module.h>
 #include <sound/initval.h>
 
 MODULE_AUTHOR("Takashi Iwai, Steve Ratcliffe");
Index: linux/sound/isa/wavefront/wavefront_fx.c
===================================================================
--- linux.orig/sound/isa/wavefront/wavefront_fx.c
+++ linux/sound/isa/wavefront/wavefront_fx.c
@@ -18,6 +18,7 @@
 
 #include <asm/io.h>
 #include <linux/init.h>
+#include <linux/module.h>
 #include <linux/time.h>
 #include <linux/wait.h>
 #include <linux/slab.h>
Index: linux/sound/isa/wavefront/wavefront_synth.c
===================================================================
--- linux.orig/sound/isa/wavefront/wavefront_synth.c
+++ linux/sound/isa/wavefront/wavefront_synth.c
@@ -22,6 +22,7 @@
 
 #include <asm/io.h>
 #include <linux/interrupt.h>
+#include <linux/module.h>
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/time.h>
Index: linux/sound/pci/asihpi/hpioctl.c
===================================================================
--- linux.orig/sound/pci/asihpi/hpioctl.c
+++ linux/sound/pci/asihpi/hpioctl.c
@@ -33,6 +33,7 @@ Common Linux HPI ioctl and module probe/
 #include <asm/uaccess.h>
 #include <linux/pci.h>
 #include <linux/stringify.h>
+#include <linux/module.h>
 
 #ifdef MODULE_FIRMWARE
 MODULE_FIRMWARE("asihpi/dsp5000.bin");
Index: linux/sound/pci/ctxfi/xfi.c
===================================================================
--- linux.orig/sound/pci/ctxfi/xfi.c
+++ linux/sound/pci/ctxfi/xfi.c
@@ -12,6 +12,7 @@
 #include <linux/pci.h>
 #include <linux/moduleparam.h>
 #include <linux/pci_ids.h>
+#include <linux/module.h>
 #include <sound/core.h>
 #include <sound/initval.h>
 #include "ctatc.h"
Index: linux/sound/pci/oxygen/oxygen_io.c
===================================================================
--- linux.orig/sound/pci/oxygen/oxygen_io.c
+++ linux/sound/pci/oxygen/oxygen_io.c
@@ -19,6 +19,7 @@
 
 #include <linux/delay.h>
 #include <linux/sched.h>
+#include <linux/module.h>
 #include <sound/core.h>
 #include <sound/mpu401.h>
 #include <asm/io.h>
Index: linux/sound/synth/emux/emux.c
===================================================================
--- linux.orig/sound/synth/emux/emux.c
+++ linux/sound/synth/emux/emux.c
@@ -24,6 +24,7 @@
 #include <sound/core.h>
 #include <sound/emux_synth.h>
 #include <linux/init.h>
+#include <linux/module.h>
 #include "emux_voice.h"
 
 MODULE_AUTHOR("Takashi Iwai");
Index: linux/sound/synth/emux/emux_oss.c
===================================================================
--- linux.orig/sound/synth/emux/emux_oss.c
+++ linux/sound/synth/emux/emux_oss.c
@@ -25,6 +25,7 @@
 
 #ifdef CONFIG_SND_SEQUENCER_OSS
 
+#include <linux/module.h>
 #include <asm/uaccess.h>
 #include <sound/core.h>
 #include "emux_voice.h"
Index: linux/sound/synth/emux/emux_seq.c
===================================================================
--- linux.orig/sound/synth/emux/emux_seq.c
+++ linux/sound/synth/emux/emux_seq.c
@@ -21,6 +21,7 @@
 
 #include "emux_voice.h"
 #include <linux/slab.h>
+#include <linux/module.h>
 
 
 /* Prototypes for static functions */
Index: linux/sound/synth/emux/emux_synth.c
===================================================================
--- linux.orig/sound/synth/emux/emux_synth.c
+++ linux/sound/synth/emux/emux_synth.c
@@ -23,6 +23,7 @@
  */
 
 #include "emux_voice.h"
+#include <linux/module.h>
 #include <sound/asoundef.h>
 
 /*
Index: linux/sound/synth/emux/soundfont.c
===================================================================
--- linux.orig/sound/synth/emux/soundfont.c
+++ linux/sound/synth/emux/soundfont.c
@@ -27,6 +27,7 @@
  */
 #include <asm/uaccess.h>
 #include <linux/slab.h>
+#include <linux/module.h>
 #include <sound/core.h>
 #include <sound/soundfont.h>
 #include <sound/seq_oss_legacy.h>
Index: linux/sound/synth/util_mem.c
===================================================================
--- linux.orig/sound/synth/util_mem.c
+++ linux/sound/synth/util_mem.c
@@ -21,6 +21,7 @@
 #include <linux/mutex.h>
 #include <linux/init.h>
 #include <linux/slab.h>
+#include <linux/module.h>
 #include <sound/core.h>
 #include <sound/util_mem.h>
 
Index: linux/sound/usb/6fire/firmware.c
===================================================================
--- linux.orig/sound/usb/6fire/firmware.c
+++ linux/sound/usb/6fire/firmware.c
@@ -15,6 +15,7 @@
  */
 
 #include <linux/firmware.h>
+#include <linux/module.h>
 #include <linux/bitrev.h>
 
 #include "firmware.h"
Index: linux/sound/usb/midi.c
===================================================================
--- linux.orig/sound/usb/midi.c
+++ linux/sound/usb/midi.c
@@ -47,6 +47,7 @@
 #include <linux/usb.h>
 #include <linux/wait.h>
 #include <linux/usb/audio.h>
+#include <linux/module.h>
 
 #include <sound/core.h>
 #include <sound/control.h>
