Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138Ab2JIJx2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 05:53:28 -0400
Received: from ams-iport-3.cisco.com ([144.254.224.146]:61824 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519Ab2JIJxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 05:53:24 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av8EAEXzc1CQ/khM/2dsb2JhbABFhhG5HYEIgiABAQEDARIBEFYFCwsYAgImAgJXBhMbB4ddBpsEjRuCO5A0gSGKGIUBgRIDlWqORYFrgm8
X-IronPort-AV: E=Sophos;i="4.80,560,1344211200"; 
   d="scan'208";a="8629915"
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
Subject: Re: [PATCH v2 1/6] Add header files and Kbuild plumbing for SI476x MFD core
Date: Tue, 9 Oct 2012 11:53:00 +0200
User-Agent: KMail/1.13.7 (Linux/3.5-0.slh.1-aptosid-amd64; KDE/4.8.4; x86_64; ; )
Cc: andrey.smrinov@convergeddevices.net, mchehab@redhat.com,
        sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com,
        perex@perex.cz, tiwai@suse.de, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1349488502-11293-1-git-send-email-andrey.smirnov@convergeddevices.net> <201210081043.15644.hverkuil@xs4all.nl> <50731D89.40007@convergeddevices.net>
In-Reply-To: <50731D89.40007@convergeddevices.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201210091153.00324.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 8 October 2012 20:38:01 Andrey Smirnov wrote:
> On 10/08/2012 01:43 AM, Hans Verkuil wrote:
> > On Sat October 6 2012 03:54:57 Andrey Smirnov wrote:
> >> This patch adds all necessary header files and Kbuild plumbing for the
> >> core driver for Silicon Laboratories Si476x series of AM/FM tuner
> >> chips.
> >>
> >> The driver as a whole is implemented as an MFD device and this patch
> >> adds a core portion of it that provides all the necessary
> >> functionality to the two other drivers that represent radio and audio
> >> codec subsystems of the chip.
> >>
> >> Signed-off-by: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
> >> ---
> >>  drivers/mfd/Kconfig             |   14 ++
> >>  drivers/mfd/Makefile            |    3 +
> >>  include/linux/mfd/si476x-core.h |  529 +++++++++++++++++++++++++++++++++++++++
> >>  include/media/si476x.h          |  449 +++++++++++++++++++++++++++++++++
> >>  4 files changed, 995 insertions(+)
> >>  create mode 100644 include/linux/mfd/si476x-core.h
> >>  create mode 100644 include/media/si476x.h
> >>

<snip>

> >> diff --git a/include/linux/mfd/si476x-core.h b/include/linux/mfd/si476x-core.h
> >> new file mode 100644
> >> index 0000000..eb6f52a
> >> --- /dev/null
> >> +++ b/include/linux/mfd/si476x-core.h

<snip>

> >> +#define SI476X_IOC_GET_RSQ		_IOWR('V', BASE_VIDIOC_PRIVATE + 0, \
> >> +					      struct si476x_rsq_status_report)
> >> +
> >> +#define SI476X_IOC_SET_PHDIV_MODE	_IOW('V', BASE_VIDIOC_PRIVATE + 1, \
> >> +					     enum si476x_phase_diversity_mode)
> >> +
> >> +#define SI476X_IOC_GET_PHDIV_STATUS	_IOWR('V', BASE_VIDIOC_PRIVATE + 2, \
> >> +					      int)
> >> +
> >> +#define SI476X_IOC_GET_RSQ_PRIMARY	_IOWR('V', BASE_VIDIOC_PRIVATE + 3, \
> >> +					      struct si476x_rsq_status_report)
> >> +
> >> +#define SI476X_IOC_GET_ACF		_IOWR('V', BASE_VIDIOC_PRIVATE + 4, \
> >> +					      struct si476x_acf_status_report)
> >> +
> >> +#define SI476X_IOC_GET_AGC		_IOWR('V', BASE_VIDIOC_PRIVATE + 5, \
> >> +					      struct si476x_agc_status_report)
> >> +
> >> +#define SI476X_IOC_GET_RDS_BLKCNT	_IOWR('V', BASE_VIDIOC_PRIVATE + 6, \
> >> +					    struct si476x_rds_blockcount_report)
> > There is no documentation at all for these private ioctls. At the very least
> > these should be documentated (both the ioctl and the structs they receive).
> >
> > More importantly, are these ioctls really needed? 
> 
> I apologize for not writing the documentation for those ioctls. I
> thought I at least did so for all data structures returned by those
> calls, I guess I never got around to doing it. I'll document all the
> ioctls in the next version of the patch.
> 
> SI476X_IOC_SET_PHDIV_MODE, SI476X_IOC_GET_PHDIV_STATUS are definitely
> needed since they are used to control antenna phase diversity modes of
> the tuners. In that mode two Si4764 chips connected to different
> antennas can act as a single tuner and use both signal to improve
> sensibility.

Interesting. But I wonder if this can be implemented as controls? That seems
to me to be a better fit.
 
> The rest is useful to get different radio signal parameters from the
> chip. We used it for during RF performance evaluation of the
> boards(probably using it in EOL testing).
> 
> > If the purpose is to return
> > status information for debugging, then you should consider implementing
> > VIDIOC_LOG_STATUS instead.
> 
> For me, the problem with using VIDIOC_LOG_STATUS is that it dumps all
> the debugging information in kernel log buffer, meaning that if one
> wants to pass that information to some other application they would have
> to resort to screen-scraping of the output of dmesg. Unfortunately the
> people who were using this driver/as a part of a software suite during
> aforementioned RF performance testing are not Linux-savvy enough to be
> asked to use dmesg and they want a GUI solution. That small test utility
> was written and it uses those those ioctls to gather and display all
> signal related information. I guess the other solution for that problem
> would be to create corresponding files in sysfs, but I'm not sure if
> creating multitude of files in sysfs tree is a better option.

Definitely not, although using debugfs might be a good idea.

> Since this version of the driver has not been integrated into our
> software package the we install on laptops to do all the board testing I
> guess I can remove those 'ioctl', but I would love to find acceptable
> solution so that later I would be able to integrate upstream driver int
> our package and not use "special" version of the driver for our purposes.

Can you split off the implementation of these ioctls from the rest of the
driver? And I think you should look into debugfs to see if that isn't a better
fit then custom ioctls. debugfs has the advantage that you can make changes
later as it isn't considered to be a public API. And this is used primarily
for debugging/testing after all.

But I think it is best to split this off and concentrate on getting the driver
itself in first. In general we don't like custom ioctls unless there is a
really good reason for it. They tend to be poorly maintained and documented
and can become a bit of a nuisance over time.

Regards,

	Hans
