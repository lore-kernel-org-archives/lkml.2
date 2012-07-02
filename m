Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab2GBNpJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 09:45:09 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63355 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab2GBNpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 09:45:07 -0400
MIME-Version: 1.0
In-Reply-To: <20120628235518.GA26283@core.coreip.homeip.net>
References: <CAMPhdO92C=t8hDYAkk5rG0ZNHnLiZQ2WY3SP+LGJ=VNJL=Unaw@mail.gmail.com>
 <20120628235518.GA26283@core.coreip.homeip.net>
From: Eric Miao <eric.miao@canonical.com>
Date: Mon, 2 Jul 2012 21:44:46 +0800
X-Google-Sender-Auth: GlDAVscG9paRMczm-SqjTjXLGrU
Message-ID: <CAMPhdO_sks4=xH+aCUdACtBhjcrL2w6PDv0J-SbERuxWnuB22A@mail.gmail.com>
Subject: Re: [PATCH RFC] input: fix weird issue of synaptics psmouse sync lost
 after resume
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org,
        Ayan George <ayan.george@canonical.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2012 at 7:55 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> Hi Eric,
>
> On Sun, Jun 24, 2012 at 11:32:38PM +0800, Eric Miao wrote:
>> All,
>>
>> BugLink: https://bugs.launchpad.net/bugs/717970
>>
>> So in summary, the symptom is intermittent key events lost after resume
>> on some machines with synaptics touchpad (seems this is synaptics _only_),
>> and key events loss is due to serio port reconnect after psmouse sync lost.
>> Removing psmouse and inserting it back during the suspend/resume process
>> is able to work around the issue, so the difference between psmouse_connect()
>> and psmouse_reconnect() is the key to the root cause of this problem.
>>
>> After comparing the two different paths, synaptics driver has its own
>> implementation of synaptics_reconnect(), and the missing psmouse_probe()
>> seems significant, the patch below added psmouse_probe() to the reconnect
>> process, and has been verified many times that the issue could not be reliably
>> reproduced.
>>
>> There are two PS/2 commands in psmouse_probe():
>>
>>   1. PSMOUSE_CMD_GETID
>>   2. PSMOUSE_CMD_RESET_DIS
>>
>> The weird thing is, the PSMOUSE_CMD_GETID seems to be significant, and the
>> PSMOUSE_CMD_RESET_DIS is irrelevant to this issue after trying several times.
>> Now it's rather difficult to form a sane theory. So this patch is
>> really for RFC.
>
> Hmm, murky and unknown to us EC/KBC firmware code and uglies are hidden
> there...

Hi Dmitry,

Sorry for late reply. I've been searching bugs.launchpad.net for more of
the similar issues, and come down to the affected models listed below
(all synaptics with firmware and model info from the kernel dmesg):

Dell V13:	- Synaptics Touchpad, model: 1, fw: 7.2, id: 0x1c0b1, caps:
0xd04733/0xa40000/0xa0000
Lenovo L520:	- Synaptics Touchpad, model: 1, fw: 7.2, id: 0x1c0b1,
caps: 0xd047b3/0xb40000/0xa0000
Lenovo Edge 11	- Synaptics Touchpad, model: 1, fw: 7.4, id: 0x1e0b1,
caps: 0xd047b3/0xb40000/0xa0000
HP Pavilion dm1	- synaptics: Touchpad model: 1, fw: 7.4, id: 0x1e0b1,
caps: 0xd04773/0xe40000/0x5a0400

So far, this only seems to happen only with synaptics touchpad with
firmware version greater than 7.2. I'm not really sure if this would be
applicable to other touchpads, although it does seem to be harmless
for a simple GETID after resume.

Another finding is about commit 8521478f:

  Input: synaptics - fix touchpad not working after S2R on Vostro V13

This doesn't seem to be related to my testing machine (HP Pavilion dm1),
although it did solve the touchpad not working issue on Vostro V13. On
my machine, the ssleep(1) is never called, which basically means the
synaptics_detect() works correctly right after a RESET command is
issued.

>
> I issuing PSMOUSE_CMD_GETID bis fine if it makes some firmware happy and
> we probably should do it for all protocols, not only Synaptics. Could
> you please try moving calls to psmouse_reset() and psmouse_probe() in
> psmouse_reconnect() up, before we check if we have protocol specific
> reconnect handler?

Hmm.... there are indeed many drivers sharing almost the same process,
however, considering a complicate case such as synaptics, the reset()
could be tried multiple times (not in other cases), and that in some
other cases, psmouse_reset() is not being called at all (possibly to
save a bit time if it's known to work after resume), it looks like a
bit a brutely if we move psmouse_reset() and psmouse_probe() up to
the psmouse_reconnect().
