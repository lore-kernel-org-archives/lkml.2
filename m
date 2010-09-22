Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237Ab0IVFaV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 01:30:21 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48243 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab0IVFaU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 01:30:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FWcYOC1K8WW84lKSm+grXqqsMyytV0Aaf+8szm4F+3Na28rNl5NIqoMzlgUPAtaX1B
         9QrmS6z1/M+lGVs21bDebiUmwFkJ+ruJpdPDwSxHdSvJwOu1bdcdnabQcG/awcyR1liQ
         3RQaMDwch5HK9l2URBiuaRusvEQFVdxlVrvOo=
MIME-Version: 1.0
In-Reply-To: <1285090202.19131.77.camel@morgan.silverblock.net>
References: <1284987540.2242.29.camel@morgan.silverblock.net>
	<AANLkTikj4biBS7wQsRM6o3kEmyaPNMaSUBEktMmmOy89@mail.gmail.com>
	<1285023750.30856.99.camel@morgan.silverblock.net>
	<AANLkTi=RCJcQMSWMm6pQgJnJZT9TyfGyFtWmeu8GKHA-@mail.gmail.com>
	<1285090202.19131.77.camel@morgan.silverblock.net>
Date: Wed, 22 Sep 2010 01:30:18 -0400
Message-ID: <AANLkTi=h=9mvdLMcZZAtg3_eu7wD2Yj0Dn2iWjhF7BiL@mail.gmail.com>
Subject: Re: [PATCH] drm/sysfs: Provide per connector control of DRM KMS polling
From: Alex Deucher <alexdeucher@gmail.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>,
        Dave Airlie <airlied@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Jon Smirl <jonsmirl@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 21, 2010 at 1:30 PM, Andy Walls <awalls@md.metrocast.net> wrote:
> On Tue, 2010-09-21 at 00:26 -0400, Alex Deucher wrote:
>> 2010/9/20 Andy Walls <awalls@md.metrocast.net>:
>> > On Mon, 2010-09-20 at 20:29 +0200, Rafał Miłecki wrote:
>> >> 2010/9/20 Andy Walls <awalls@md.metrocast.net>:
>> >> > DRM KMS polling of connections providing errant EDID responses, or
>> >> > polling of "connectors" that have chips responding on DDC I2C bus
>> >> > address 0xA0/0xA1 with no actual physical connector nor EDID EEPROM,
>> >> > will create perpetual noise in dmesg and the system log every 10
>> >> > seconds.  Currently the user has apparently little recourse to silence
>> >> > these messages aside from replacing the offending cable, monitor, or
>> >> > graphics adapter.  That recourse is impossible for an unused DVI-D
>> >> > "connector" of an internal graphics processor on a motherboard that
>> >> > provides no physical DVI-D connector.
>> >> >
>> >> > This change allows the root user to disable (and re-enable) DRM KMS
>> >> > connector polling on a per connector basis via sysfs, like so:
>> >>
>> >> Huh, I didn't imagine solution of this issue that way.
>> >
>> > The problems with my initial patch, and related approaches, were:
>> >
>> > 1. They didn't get rid of all the spam in the logs, just the most
>> > verbose portion of it.
>> >
>> > 2. They didn't deal with the root cause of the log spam and all the
>> > related, but unneeded, I/O and processing that was still occurring.
>> >
>> >
>> >
>> >>  AFAIR previous
>> >> thread, something else was suggested, it was about storing the fact
>> >> that user already received warning/info about error.
>> >
>> > Yes, that was the discussion.
>> >
>> > I went with this patch because:
>> >
>> > 1. It deals with the root cause: unneeded DRM KMS connector polling
>> >
>> > 2. It eliminates all my DRM KMS connector polling related log spam, not
>> > just the hex dump.
>> >
>> > 3. The existing sysfs structure was already exposing 'struct
>> > drm_connector' members to user-space at per connector granularity
>> >
>> >
>> > The real root cause of the polling spew is that the radeon module, based
>> > on the best information it has (BIOS connector tables, I2C bus probes,
>> > etc.), makes a decision on if a connector should be polled and how it
>> > should be polled.
>> >
>> > Given incorrect BIOS tables, and strange I2C setups, the radeon module
>> > is bound to make the wrong decision about polling in some cases.  This
>> > change is a way for the human to step in a correct things, when the
>> > radeon driver gets it wrong.
>> >
>>
>> I'd rather fix the bug for real rather than providing users with an
>> out so that the bug never gets reported.
>
> There is already "an out" on it's way upstream:
>
> http://lkml.org/lkml/2010/9/6/375
> http://git.kernel.org/?p=linux/kernel/git/airlied/drm-2.6.git;a=commit;h=e58f637bb96d5a0ae0919b9998b891d1ba7e47c9
>
> I noticed it after I submitted this patch.  If I'm reading it right, the
> module parameter fix is very coarse: it applies to all drm adapters and
> connectors in the system.
>
>>   What's the actual problem
>> you have?
>
> The actual problem I have is that the radeon driver reports three
> connectors (HDMI, DVI-D, and VGA) on the motherboard, but there is only
> one physical connector (VGA).  Polling of the HDMI appears to be
> inhibited by the radeon module code.  Polling of the (non-existent?)
> DVI-D interface yields a lot of log messages and useless I2C
> transactions.
>
> My precise gripe is with this code path
>
> http://git.kernel.org/?p=linux/kernel/git/airlied/drm-2.6.git;a=blob;f=drivers/gpu/drm/radeon/radeon_connectors.c;h=ecc1a8fafbfd3eb3c12c0c4d45b4b091a1bee03b;hb=refs/heads/drm-fixes#l772
>
> which is being polled every 10 seconds.  It is bad for me because this
> function is noisy:
>
> http://git.kernel.org/?p=linux/kernel/git/airlied/drm-2.6.git;a=blob;f=drivers/gpu/drm/drm_edid.c;h=96e96310822513bfd9c984054a913eac7b5acc50;hb=refs/heads/drm-fixes#l136
>
> and this (insane?) loop multiplies the noise by a factor of 4:
>
> http://git.kernel.org/?p=linux/kernel/git/airlied/drm-2.6.git;a=blob;f=drivers/gpu/drm/drm_edid.c;h=96e96310822513bfd9c984054a913eac7b5acc50;hb=refs/heads/drm-fixes#l264
>
>
> In a different user's operational context, all that noise may be
> beneficial.
>
>
> The real problem to me is that the radeon and drm modules have a single,
> standard way of dealing with EDID errors.  However, EDID errors can
> happen due to a number of different causes, some of which are external
> (i.e. in the LCD or CRT monitor).  Given that, there really is no "right
> thing" the drivers can do without input from the user on what the policy
> should be when a bad EDID is detected.
>
>
>
>
>>   Do you just want to turn polling off for an unused
>> connecter,
>
> Yes, that's what I would use my proposed patch for.
>
> (If a solution that avoids sysfs is required, I can work up a patch
> using DRM_IOCTL_MODE_GETPROPERTY & DRM_IOCTL_MODE_SETPROPERTY along with
> a patch for some utility like xrandr.)
>
>
> In a larger sense it's about user policy for error reporting by the drm
> and radeon drivers, and error response by both the drivers and the user.
>
> In the face of EDID errors, a user may want to take the following
> actions:
>
>        ignore the errors
>        supress the errors
>        continue to monitor the errors for a time
>        replace cables
>        replace graphics adapter
>        replace monitor
>        report a bug
>
> All of those end user actions are possible right now, except the one to
> supress the errors (and the I2C transactions associated with them).
>
> A monitor, cable, and graphics adapter set that is currently
> experiencing EDID errors, may be otherwise working just fine.
>
> "Because we want to ensure people report bugs," does not seem like a
> good reason to prevent a user from turning off bogus error messages, for
> an otherwise working monitor that is providing broken EDID data.  What
> is the resolution of a bug report for a monitor providing bad EDID data
> going to look like?

I wasn't talking about the broken EDID messages, I was talking about
the bogus connector table entries on your board.  Those should be
properly quirked in the driver in which case, which would avoid the
problem all together in your case.

>
>
>>  or does the board have a bug in the connector table?
>
> I have not dug into the BIOS connector table bits and bytes to verify,
> but I'm assuming the connector table is incorrect.
>

It appears to be incorrect.  If you send me a copy of the vbios, I can
easily add a quirk. I suspect your board oem may offer several boards
with different output configurations and neglected to update the table
in some configurations.

>
>>   If
>> it's a bug, we can add a quirk so that it's properly handled.
>
> I don't see how a quirk table is going to cover the situations different
> from mine, that also provide bad EDID data in the code path I pointed
> out.  I know how one can add quirks for a connected DVI-D monitor that
> provides bad EDID data or none at all.
>
> The radeon module already has a connector_table module parameter for
> quirks.  That module option provides some hard-coded connector tables.
> I had considered adding more to that, but it seemed like a band-aid.
> Also, IIRC, the connector_table parameter currently applies globally to
> all radeon graphics adapters in the system, so it doesn't scale to
> multiple radeon adapters in the system.
>

It's best to just add a quirk for your board.  The connector_table
option is just an override for r1xx-r3xx mac and sun cards that do not
have useable vbios tables.  It's not really directly applicable to
atom-based systems like yours.

>
>
>>   What
>> physical connectors does the board have what does the driver report in
>> dmesg?
>
> The board only has a physical VGA connector.  The graphics adapter is an
> IGP on an MSI K9A2GM V2/V3 series motherboard (MS-7302).  Here are the
> PCI IDs on the graphics adapter:
>
> 01:05.0 VGA compatible controller [0300]:
>        ATI Technologies Inc Radeon 2100 [1002:796e] (prog-if 00 [VGA controller])
>        Subsystem: Micro-Star International Co., Ltd. Device [1462:7302]
>
>
> Below is the dmesg output from the unmodified drm and radeon modules
> which includes samples of drm module log spam for the first 30 seconds
> or so after boot.
>
> Regards,
> Andy
>
> Linux version 2.6.32.19-163.fc12.x86_64 (mockbuild@x86-05.phx2.fedoraproject.org) (gcc version 4.4.4 20100630 (Red Hat 4.4.4-10) (GCC) ) #1 SMP Wed Aug 18 11:38:54 UTC 2010
> [snip!]
> [drm] Initialized drm 1.1.0 20060810
> [drm] radeon defaulting to kernel modesetting.
> [drm] radeon kernel modesetting enabled.
> radeon 0000:01:05.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
> [drm] radeon: Initializing kernel modesetting.
> [drm] register mmio base: 0xFE7F0000
> [drm] register mmio size: 65536
> ATOM BIOS: ATI
> [drm] GPU reset succeed (RBBM_STATUS=0x10000140)
> [drm] radeon: VRAM 128M
> [drm] radeon: VRAM from 0x78000000 to 0x7FFFFFFF
> [drm] radeon: GTT 512M
> [drm] radeon: GTT from 0x80000000 to 0x9FFFFFFF
>  alloc irq_desc for 28 on node 0
>  alloc kstat_irqs on node 0
> radeon 0000:01:05.0: irq 28 for MSI/MSI-X
> [drm] radeon: using MSI.
> [drm] radeon: irq initialized.
> [drm] Detected VRAM RAM=128M, BAR=128M
> [drm] RAM width 128bits DDR
> [TTM] Zone  kernel: Available graphics memory: 963036 kiB.
> [drm] radeon: 128M of VRAM memory ready
> [drm] radeon: 512M of GTT memory ready.
> [drm] GART: num cpu pages 131072, num gpu pages 131072
> [drm] radeon: 1 quad pipes, 1 z pipes initialized.
> [drm] radeon: cp idle (0x10000C03)
> [drm] Loading RS690/RS740 Microcode
> platform radeon_cp.0: firmware: requesting radeon/RS690_cp.bin
> [drm] radeon: ring at 0x0000000080000000
> [drm] ring test succeeded in 1 usecs
> [drm] radeon: ib pool ready.
> [drm] ib test succeeded in 0 usecs
> [drm] Radeon Display Connectors
> [drm] Connector 0:
> [drm]   VGA
> [drm]   DDC: 0x7e50 0x7e40 0x7e54 0x7e44 0x7e58 0x7e48 0x7e5c 0x7e4c
> [drm]   Encoders:
> [drm]     CRT1: INTERNAL_KLDSCP_DAC1
> [drm] Connector 1:
> [drm]   DVI-D
> [drm]   HPD2
> [drm]   DDC: 0x7e40 0x7e60 0x7e44 0x7e64 0x7e48 0x7e68 0x7e4c 0x7e6c
> [drm]   Encoders:
> [drm]     DFP2: INTERNAL_DDI
> [drm] Connector 2:
> [drm]   HDMI-A
> [drm]   DDC: 0x7e40 0x7e50 0x7e44 0x7e54 0x7e48 0x7e58 0x7e4c 0x7e5c
> [drm]   Encoders:
> [drm]     DFP3: INTERNAL_LVTM1

FWIW, it's actually the HDMI connector that is generating the errors
due to the lack of a hpd pin assignment.


> [drm:drm_edid_is_valid] *ERROR* Raw EDID:
> <3>00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> <3>00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> <3>00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> <3>00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> <3>00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> <3>00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> <3>00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> <3>00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>

Alex
