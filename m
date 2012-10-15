Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969Ab2JOJ6F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 05:58:05 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:31028 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab2JOJ6D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 05:58:03 -0400
X-Authority-Analysis: v=2.0 cv=EOyEIilC c=1 sm=0 a=YPDeGStqRoQnMAluW+pq4Q==:17 a=65KWcu232dMA:10 a=h9GbcFHyNoYA:10 a=DpEkYpXRGzUA:10 a=05ChyHeVI94A:10 a=8nJEP1OIZ-IA:10 a=ayC55rCoAAAA:8 a=nULq49Tkjo8A:10 a=-2DtkfXt_sO_AtlXuDQA:9 a=wPNLvfGTeEIA:10 a=YPDeGStqRoQnMAluW+pq4Q==:117
X-Cloudmark-Score: 0
X-Originating-IP: 50.89.247.146
Message-ID: <507BDE28.30907@cfl.rr.com>
Date: Mon, 15 Oct 2012 05:58:00 -0400
From: Mark Hounschell <dmarkh@cfl.rr.com>
Reply-To: dmarkh@cfl.rr.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
CC: markh@compro.net, linux-kernel@vger.kernel.org,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Subject: Re: Intel graphics drm issue?
References: <507812E8.3060607@compro.net> <20121012231459.166e29fd@neptune.home> <5079B97C.7020401@cfl.rr.com> <5079BE5C.8020401@cfl.rr.com> <20121014104138.7e8a9c59@neptune.home> <507A997D.7070508@cfl.rr.com> <20121014130323.06f0225d@neptune.home> <507AEE4A.1000907@cfl.rr.com> <20121014192253.5a7517ef@neptune.home> <507AFE69.70405@cfl.rr.com> <20121014201941.22284249@neptune.home> <507B0B16.4010900@cfl.rr.com> <20121014224057.2033a769@neptune.home>
In-Reply-To: <20121014224057.2033a769@neptune.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2012 04:40 PM, Bruno Prémont wrote:
> On Sun, 14 October 2012 Mark Hounschell <dmarkh@cfl.rr.com> wrote:
>> I gave it a try. I don't think it liked my kernel cmdline. dmesg attached.
>> There is a lot more in there now that nomodeset is gone and the debug is
>> turned on.
>>
>> # ls -al /lib/firmware/edid/lg42lb9df.edid
>> -rw-r--r-- 1 root root 1024 Oct 14  2012 /lib/firmware/edid/lg42lb9df.edid
>>
>> ## cat /proc/cmdline
>> root=/dev/disk/by-id/ata-INTEL_SSDSC2CW060A3_CVCV205106EB060AGN-part4
>> noresume splash=silent quiet apm=off vga=normal drm.debug=0xe irqpoll
>> drm_kms_helper.edid_firmware=edid/lg42lb9df.edid
>>
>>
>> from attached dmesg:
>> 1.833032] drm_kms_helper: Unknown parameter `edid'
>
> As your drm drivers seem to all be built-in (according to kernel timings)
> you will have to build the EDID firmware into the kernel as well (see
> CONFIG_EXTRA_FIRMWARE), otherwise it probably can't be loaded (unless Linus'
> firmware loading patch is already in 3.6.2 and root filesystem/initrd is
> ready at that time).
>
> Did you set CONFIG_DRM_LOAD_EDID_FIRMWARE?
> If not, that may be the reason for unknown parameter `edid' error.
>
>
> But I saw I mis-remembered side of EDID blobs, they are just 128 bytes
> per block, not 512 (seems I was thinking disk sector sizes),
> thus you should just get 256 bytes output.
>
> Just truncating the file to 256 bytes will do. You may also
> change your .c file to have
>    uint8_t firmware[] = {
>       ...
>    };
>    ...
>    fwrite(firmware, sizeof(firmware), 1, fd);
>    ...
>
> that way compiler gets numbers right :)
>
> Kernel code rejects edid with unexpected size! Thus it would have
> complained if it had tried to load it with a size of 1k.
>

Good morning Bruno.

Still no luck here. I must be doing something wrong.

geexbox:/usr/src/linux-3.6.2 # grep -rn CONFIG_EXTRA_FIRMWARE .config
1406:CONFIG_EXTRA_FIRMWARE="edid/lg42lb9df.edid"
1407:CONFIG_EXTRA_FIRMWARE_DIR="firmware"

geexbox:/usr/src/linux-3.6.2 # grep CONFIG_DRM_LOAD_EDID_FIRMWARE .config
CONFIG_DRM_LOAD_EDID_FIRMWARE=y

geexbox:/usr/src/linux-3.6.2 # ls -al firmware/edid/
-rw-r--r-- 1 root root  256 Oct 14 19:18 firmware/edid/lg42lb9df.edid


I believe the the drm modules are modules and in initrd.
geexbox:/boot # mkinitrd -i initrd-3.6.2 -k vmlinuz-3.6.2

Kernel image:   /boot/vmlinuz-3.6.2
Initrd image:   /boot/initrd-3.6.2
KMS drivers:     i915
Root device: 
/dev/disk/by-id/ata-INTEL_SSDSC2CW060A3_CVCV205106EB060AGN-part4 
(/dev/sda4) (mounted on / as ext4)
Kernel Modules: thermal fan scsi_dh scsi_dh_emc scsi_dh_rdac scsi_dh_alua 
scsi_dh_hp_sw crc16 jbd2 ext4 video button i2c-algo-bit drm drm_kms_helper 
i915 xhci-hcd hid-logitech-dj hid-generic
Features:       acpi kms plymouth block usb resume.userspace resume.kernel


After the kernel build, I have these in /usr/src/linux-3.6.2/firmware/edid/

geexbox:/usr/src/linux-3.6.2 # ls -al firmware/edid/
lg42lb9df.edid             lg42lb9df.edid.gen.o 
.lg42lb9df.edid.gen.o.cmd  lg42lb9df.edid.gen.S
geexbox:/usr/src/linux-3.6.2 # ls -al firmware/edid/*
-rw-r--r-- 1 root root  256 Oct 14 19:18 firmware/edid/lg42lb9df.edid
-rw-r--r-- 1 root root 1104 Oct 15 00:52 firmware/edid/lg42lb9df.edid.gen.o
-rw-r--r-- 1 root root  475 Oct 15 00:52 firmware/edid/lg42lb9df.edid.gen.S


After boot, from dmesg:

[    0.000000] Kernel command line: 
root=/dev/disk/by-id/ata-INTEL_SSDSC2CW060A3_CVCV205106EB060AGN-part4 
noresume splash=silent quiet apm=off vga=normal irqpoll 
drm_kms_helper.edid_firmware=card0-HDMI-A-1:edid/lg42lb9df.edid,card0-HDMI-A-3:edid/lg42lb9df.edid,card0-HDMI-A-3:edid/lg42lb9df.edid

[    1.835741] drm_kms_helper: Unknown parameter `edid'


Regards
Mark

