Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab2JUTTW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 15:19:22 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:52029 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189Ab2JUTTV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 15:19:21 -0400
Date: Sun, 21 Oct 2012 21:18:17 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: dmarkh@cfl.rr.com
Cc: linux-kernel@vger.kernel.org,
        "markh@compro.net >> Mark Hounschell" <markh@compro.net>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Subject: Re: [Intel-gfx] drm_kms_helper problems
Message-ID: <20121021211817.58c6ccaf@neptune.home>
In-Reply-To: <50843C83.8040801@cfl.rr.com>
References: <508409FC.6080805@cfl.rr.com>
	<20121021165802.578d6d6b@neptune.home>
	<50843C83.8040801@cfl.rr.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.12; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Sun, 21 October 2012 Mark Hounschell <dmarkh@cfl.rr.com> wrote:
> On 10/21/2012 10:58 AM, Bruno Prémont wrote:
> > On Sun, 21 October 2012 Mark Hounschell <dmarkh@cfl.rr.com> wrote:
> >> I have a TV that appears to not provide proper EDID info to the HDMI or DVI
> >> ports of my Intel DH77DF motherboard. I received some pointers from this
> >> list that pointed me in the direction of creating my own EDID file and I
> >> now have a binary blob that matches what the service manual says is the
> >> proper EDID info.
> >>
> >> But I am unable to get the drm_kms_helper module to load and use this file.
> >> My relevant kernel config options are.
> >>
> >> CONFIG_DRM_KMS_HELPER=m
> >> CONFIG_DRM_LOAD_EDID_FIRMWARE=y
> >>
> >> my relevant kernel command line contains:
> >>
> >> video=card0-HDMI-A-1:e
> >> drm_kms_helper.edid_firmware=card0-HDMI-A-1:edid/lg42lb9df_hdmi1.edid
> >
> > The variant without card0- should be the right one.
> >
> 
> OK. Changed it. What if I had more than one video card?

Two connectors from two distinct card should not get the same suffix number
even if they use same technology, so it should work. (unless something was
changed recently)

> >> The edid file:
> >> # ls -al /lib/firmware/edid/lg42lb9df_hdmi1.edid
> >> -rw-r--r-- 1 root root 256 Oct 16 05:46 /lib/firmware/edid/lg42lb9df_hdmi1.edid
> >>
> >> connector info from /sys/class/drm/
> >>
> >> card0  card0-DP-1  card0-DP-2  card0-DP-3  card0-HDMI-A-1  card0-HDMI-A-2
> >> card0-HDMI-A-3  card0-VGA-1  controlD64  version
> >>
> 
> Which should I use? HDMI-A-1, HDMI-A-2, or  HDMI-A-3? Why re there 3??
> 
> >> And I don't really understand why I have 3 entries for the one hdmi port?
> >> Nor do I really understand _exactly_ how to define the connector in my
> >> kernel command line or which of the 3 connectors from /sys I should be
> >> using. I've tried different variants. Ie. card0-HDMI-A-1and HDMI-A-1.
> >>
> >> The results in the kernel log file remain:
> >>
> >> [    1.879654] drm_kms_helper: Unknown parameter `edid'
> >
> > As your drm_kms_helper is built modular, did you try not putting that
> > parameter on kernel cmdline but rather put it in modprobe's configuration
> > for that module? (may doing the whole loading manually).
> >
> 
> I've created a /etc/modprobe.d/20-drm_kms_helper.conf with:
> options drm_kms_helper edid_firmware=HDMI-A-1:edid/lg42lb9df_hdmi1.edid
> and now I'm getting something different. It looks like it's trying. In fact 
> I actually get a screen on the TV now. It's not 1920x1080 but 1024x768 at 
> 60hz.

As things get slightly better now, check what kernel detected:
- /sys/module/drm_kms_helper/parameters/edid_firmware
  (should contain the path to firmware file)

Make sure both the firmware and modprobe config get included in your initrd
if you're using one.

> [    1.883124] load_module: Calling parse_args for module = drm_kms_helper 
> args = edid_firmware=HDMI-A-1:edid/lg42lb9df_hdmi1.edid
> [    1.883126]
> [    1.883126] parse_args: (1) Entered for drm_kms_helper
> [    1.883127]
> [    1.883127] parse_args: (2) Entered for drm_kms_helper
> [    1.883127] parse_args: doing = drm_kms_helper
> [    1.883128] parse_args: args  = 
> edid_firmware=HDMI-A-1:edid/lg42lb9df_hdmi1.edid
> F\xffffffc9\xfffffff8h\xffffff89\xffffff86\xffffffc0\xffffff80\xffffffff\xffffffff\xffffffd4R\xffffffc9\xfffffff8TF\xffffffc9\xfffffff88\xffffff89\xffffff86\xffffffc0\xffffffa4\xffffffff\xffffffffdF\xffffffc9\xfffffff8
> [    1.883129] parse_args: num = 2
> [    1.883130] parse_args: min_level = -32768
> [    1.883131] parse_args: max_level = 32767
> [    1.883132]
> F\xffffffc9\xfffffff8h\xffffff89\xffffff86\xffffffc0\xffffff80\xffffffff\xffffffff\xffffffd4R\xffffffc9\xfffffff8TF\xffffffc9\xfffffff88\xffffff89\xffffff86\xffffffc0\xffffffa4\xffffffff\xffffffffdF\xffffffc9\xfffffff8, 
> num=2, min_level=-32768, max_level=32767
> [    1.886855]
> .
> .
> .
> [    2.132749] [drm] forcing HDMI-A-1 connector ON
> [    2.132752] [drm] forcing HDMI-A-2 connector ON
> [    2.132753] [drm] forcing HDMI-A-3 connector ON
> 
> [    2.189769] [drm:edid_load] *ERROR* Requesting EDID firmware 
> "edid/lg42lb9df_hdmi1.edid" failed (err=-2)

Interesting, kernel/udev can't find the edid file but know what file
to look for... Is the edid file available at that time (initrd?)?

> I get a couple of the above messages.
> 
> 
> [    2.388623] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, 
> remainder is 130
> [    2.388631] Raw EDID:
> [    2.388635]          00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff

That's as ago with getting edid from hardware.

> > # modprobe drm_kms_helper edid_firmware=HDMI-A-1:edid/lg42lb9df_hdmi1.edid
> >
> 
> I can't seem to rm the modules already loaded to try this.

There are multiple steps needed to be able to rmmod those modules:
- stop DRM users (e.g. X)
- disable fbcon
  echo 1 > /sys/class/vtcon0/bind
  echo 0 > /sys/class/vtcon1/bind
  (assuming vtcon1 is fbcon, vtcon0 is VGA console)
- rmmod i915
- rmmod drm_kms_helper

Note that at time of modprobing i915 connectors will have different names!
(probably HDMI-A-4, HDMI-A-5, HDMI-A-6)

Alternatively you could blacklist all drm modules so they don't get loaded
automatically and you can load them manually one at a time when system has
booted.

> > I have no idea why it fails for you, here on the systems I have it works
> > fine (on one where everything is built into the kernel I did set the cmdline
> > arguments via CONFIG_CMDLINE="..." (having CONFIG_CMDLINE_BOOL=y).
> >
> >> I assume I am doing something wrong but I have put some debug printks in
> >> kernel/params.c that shows me every call made to it and it's params. It is
> >> entered many times and I see a sequence to in the log file. As an example,
> >> the last one to call with params before drm_kms_helper is "late" and here
> >> are my debug prints for it:
> >
> > Did you check that your bootloader get things right, e.g. if results are the
> > same no matter in which order you put the kernel parameters (and if there are
> > some non-ASCII values in there).
> > As you have quite some length of parameters there could be some buffer size
> > issue.
> > (take this as just wild guessing)
> >
> 
> The bootloader file is clean. Want me to send a complete dmesg again?

Not needed for now.

Bruno
