Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192Ab2DDNLq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 09:11:46 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43898 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756214Ab2DDNLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 09:11:45 -0400
Date: Wed, 4 Apr 2012 15:11:40 +0200
From: Borislav Petkov <bp@alien8.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, Alessandro Rubini <rubini@cvml.unipv.it>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: psmouse serio4: bad data from KBC - timeout
Message-ID: <20120404131139.GA3277@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-input@vger.kernel.org,
	Alessandro Rubini <rubini@ipvvis.unipv.it>,
	LKML <linux-kernel@vger.kernel.org>
References: <20120403094324.GA3346@gere.osrc.amd.com>
 <20120403170659.GF24832@core.coreip.homeip.net>
 <20120404045440.GB28344@liondog.tnic>
 <20120404064053.GA26093@core.coreip.homeip.net>
 <20120404104643.GA5193@x1.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120404104643.GA5193@x1.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2012 at 12:46:43PM +0200, Borislav Petkov wrote:
> On Tue, Apr 03, 2012 at 11:40:53PM -0700, Dmitry Torokhov wrote:
> > As I said I would start at the latest ACPI and PM merges and try
> > reverting them - i8042 may interact in funny ways with embedded
> > controller since it is usually the same piece of firmware.
> > 
> > I assume it works fine in 3.3, right?
> 
> Yes, it does.
> 
> Let me checkout git trees before those merges to see whether it makes
> any difference.

Well, what do you know, I checked out the commit before Len's ACPI pull request:

git checkout a335750b9a039a9d4cd727cdccacfb90fd63c4e8~1

I.e., the tree I'm currently testing has

commit 10f3cb41d48ab30f5c754b30eea557371892b4c2
Merge: 919c840167ec 867646f246de
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri Mar 30 16:24:38 2012 -0700

    Merge git://git.samba.org/sfrench/cifs-2.6

at its top and the mux controller resumes fine:

[    0.922202] i8042: PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
[    0.924542] i8042: Detected active multiplexing controller, rev 1.1
[    0.927501] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.928161] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    0.928426] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    0.928682] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    0.928963] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    0.968243] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    2.080993] psmouse serio4: synaptics: Touchpad model: 1, fw: 8.0, id: 0x1e2b1, caps: 0xd001a3/0x940300/0x121c00
[    2.081224] psmouse serio4: synaptics: serio: Synaptics pass-through port at isa0060/serio4/input0
[    2.125315] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/input1
[    7.850636] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio4/serio5/input/input2
[  511.028833] psmouse serio4: TouchPad at isa0060/serio4/input0 lost sync at byte 1
[  511.033921] psmouse serio4: TouchPad at isa0060/serio4/input0 lost sync at byte 1
[  511.035284] psmouse serio4: TouchPad at isa0060/serio4/input0 lost sync at byte 1
[  511.036719] psmouse serio4: TouchPad at isa0060/serio4/input0 lost sync at byte 1
[  511.047286] psmouse serio4: TouchPad at isa0060/serio4/input0 - driver resynced.

IOW, I've cut off the tree before the merge commit below, now I have to
go over those patches and see which one is the offender. Stay tuned.

commit a335750b9a039a9d4cd727cdccacfb90fd63c4e8
Merge: 10f3cb41d48a d326f44e5f22
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri Mar 30 16:45:38 2012 -0700

    Merge branch 'release' of git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux
    
    Pull ACPI & Power Management changes from Len Brown:
     - ACPI 5.0 after-ripples, ACPICA/Linux divergence cleanup
     - cpuidle evolving, more ARM use
     - thermal sub-system evolving, ditto
     - assorted other PM bits
    
    Fix up conflicts in various cpuidle implementations due to ARM cpuidle
    cleanups (ARM at91 self-refresh and cpu idle code rewritten into
    "standby" in asm conflicting with the consolidation of cpuidle time
    keeping), trivial SH include file context conflict and RCU tracing fixes
    in generic code.

-- 
Regards/Gruss,
Boris.
