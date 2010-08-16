Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab0HPOhg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 10:37:36 -0400
Received: from 207-172-69-77.c3-0.smr-ubr3.sbo-smr.ma.static.cable.rcn.com ([207.172.69.77]:48569
	"EHLO thaum.luto.us" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab0HPOhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 10:37:35 -0400
X-Greylist: delayed 615 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Aug 2010 10:37:35 EDT
Message-ID: <4C694ABF.6020505@mit.edu>
Date: Mon, 16 Aug 2010 10:27:11 -0400
From: Andy Lutomirski <luto@mit.edu>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        intel-gfx@lists.freedesktop.org
Subject: Re: Intel graphics CPU usage - SDVO detect bogosity?
References: <AANLkTi=NFpeyo7Q31yMfqKSP2c-2OS2ccqa=Q9CQ8bpk@mail.gmail.com>	<4C68B92B.3080406@myrealbox.com> <AANLkTinfYBC0=DOzWaGD0DrGH8+M_rFRtuzHrM4yjRxx@mail.gmail.com>
In-Reply-To: <AANLkTinfYBC0=DOzWaGD0DrGH8+M_rFRtuzHrM4yjRxx@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[cc: intel-gfx]

Linus Torvalds wrote:
 > On Sun, Aug 15, 2010 at 9:06 PM, Andy Lutomirski <luto@myrealbox.com> wrote:
 >> You might be hitting the infamous hotplug storm [1].  The symptoms vary by
 >> kernel version.
 >
 > Hmm. I don't think it's a storm. The drm.debug=4 thing shows things
 > just every 10 seconds. That seems pretty controlled.

OK, probably not the hotplug storm.  That's always been at least once per
second and sometimes several for me.

 >
 > Of course, it seems to be several milliseconds worth of work then, so
 > it's not _too_ controlled. I must be missing some detail.
 >
 >> If I'm right, the outputs of intel_bios_dumper and intel_bios_reader could
 >> be instructive (both are in intel-gpu-tools).
 >
 > My version of intel-gpu-tools must be old (fedora 12). It has
 > intel_gpu_dump and intel_reg_write and some other apps, but not the
 > bios-dumper/reader.
 >
 > Not that I could read the output of them anyway, I bet ;)
 >
 >> You could also try intel_reg_write 0x61110 0x0 and see if the problem stops
 >> (at least until a suspend/resume cycle).  That command turns off output
 >> hotplug on the card, which has the side effect that the kernel will stop
 >> acting on bogus interrupts.
 >
 >   # intel_reg_write 0x61110 0x0
 >   Value before: 0x4000220
 >   Value after: 0x0
 >
 > but it doesn't seem to change any behavior. Still that sdvo probe
 > every 10 s, and still 1% of CPU for kworker in top. But that kworker
 > thing definitely has to be separate from the 10-second sdvo probe,
 > because it shows up all the time (ie top updates every second).

Almost certainly not the hotplug storm bug.

The 10 seconds is probably the timer in output_poll_execute (drm_crtc_helper.c):

#define DRM_OUTPUT_POLL_PERIOD (10*HZ)

The code in output_poll_execute (which is in your perf output) looks wrong:

         list_for_each_entry(connector, &dev->mode_config.connector_list, head) {

                 /* if this is HPD or polled don't check it -
                    TV out for instance */
                 if (!connector->polled)
                         continue;

                 else if (connector->polled & (DRM_CONNECTOR_POLL_CONNECT | DRM_CONNECTOR_POLL_DISCONNECT))
                         repoll = true;

[ so if we have DRM_CONNECTOR_POLL_CONNECT set we requeue the *entire*
   work item.  or if we have DRM_CONNECTOR_POLL_DISCONNECT and it's not
   even connected, we still poll. ]

                 old_status = connector->status;
                 /* if we are connected and don't want to poll for disconnect
                    skip it */
                 if (old_status == connector_status_connected &&
                     !(connector->polled & DRM_CONNECTOR_POLL_DISCONNECT) &&
                     !(connector->polled & DRM_CONNECTOR_POLL_HPD))
                         continue;

[ but if the status isn't connector_status_connected, we poll it even if we're
   only in here due to a *different* connector ]

                 status = connector->funcs->detect(connector);

[ ->detect is the expensive part ]

                 if (old_status != status)
                         changed = true;
         }

But that's really the problem, because intel_sdvo_dvi_init contains:

         connector->polled = DRM_CONNECTOR_POLL_CONNECT | DRM_CONNECTOR_POLL_DISCONNECT;

I don't know if SDVO is supposed to send hotplug interrupts because that section of the docs is incomplete.

--Andy
