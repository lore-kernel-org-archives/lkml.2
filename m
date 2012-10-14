Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355Ab2JNUl7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 16:41:59 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:53877 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036Ab2JNUl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 16:41:58 -0400
Date: Sun, 14 Oct 2012 22:40:57 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: dmarkh@cfl.rr.com
Cc: markh@compro.net, linux-kernel@vger.kernel.org,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Subject: Re: Intel graphics drm issue?
Message-ID: <20121014224057.2033a769@neptune.home>
In-Reply-To: <507B0B16.4010900@cfl.rr.com>
References: <507812E8.3060607@compro.net>
	<20121012231459.166e29fd@neptune.home>
	<5079B97C.7020401@cfl.rr.com>
	<5079BE5C.8020401@cfl.rr.com>
	<20121014104138.7e8a9c59@neptune.home>
	<507A997D.7070508@cfl.rr.com>
	<20121014130323.06f0225d@neptune.home>
	<507AEE4A.1000907@cfl.rr.com>
	<20121014192253.5a7517ef@neptune.home>
	<507AFE69.70405@cfl.rr.com>
	<20121014201941.22284249@neptune.home>
	<507B0B16.4010900@cfl.rr.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.12; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 October 2012 Mark Hounschell <dmarkh@cfl.rr.com> wrote:
> I gave it a try. I don't think it liked my kernel cmdline. dmesg attached. 
> There is a lot more in there now that nomodeset is gone and the debug is 
> turned on.
> 
> # ls -al /lib/firmware/edid/lg42lb9df.edid
> -rw-r--r-- 1 root root 1024 Oct 14  2012 /lib/firmware/edid/lg42lb9df.edid
> 
> ## cat /proc/cmdline
> root=/dev/disk/by-id/ata-INTEL_SSDSC2CW060A3_CVCV205106EB060AGN-part4 
> noresume splash=silent quiet apm=off vga=normal drm.debug=0xe irqpoll 
> drm_kms_helper.edid_firmware=edid/lg42lb9df.edid
> 
> 
> from attached dmesg:
> 1.833032] drm_kms_helper: Unknown parameter `edid'

As your drm drivers seem to all be built-in (according to kernel timings)
you will have to build the EDID firmware into the kernel as well (see
CONFIG_EXTRA_FIRMWARE), otherwise it probably can't be loaded (unless Linus'
firmware loading patch is already in 3.6.2 and root filesystem/initrd is
ready at that time).

Did you set CONFIG_DRM_LOAD_EDID_FIRMWARE?
If not, that may be the reason for unknown parameter `edid' error.


But I saw I mis-remembered side of EDID blobs, they are just 128 bytes
per block, not 512 (seems I was thinking disk sector sizes),
thus you should just get 256 bytes output.

Just truncating the file to 256 bytes will do. You may also
change your .c file to have
  uint8_t firmware[] = {
     ...
  };
  ...
  fwrite(firmware, sizeof(firmware), 1, fd);
  ...

that way compiler gets numbers right :)

Kernel code rejects edid with unexpected size! Thus it would have
complained if it had tried to load it with a size of 1k.

Bruno
