Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab2D1WRf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 18:17:35 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49938 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab2D1WRd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 18:17:33 -0400
MIME-Version: 1.0
In-Reply-To: <20120428221003.49fb248d@pyramind.ukuu.org.uk>
References: <1335645928-30993-1-git-send-email-alexander.tarasikov@gmail.com>
	<1335645928-30993-2-git-send-email-alexander.tarasikov@gmail.com>
	<20120428221003.49fb248d@pyramind.ukuu.org.uk>
Date: Sun, 29 Apr 2012 02:17:32 +0400
Message-ID: <CAMChaFwhgrQN864=q6-dKD=b8y9=1HJL+qpdSHFn4ts2rW7omA@mail.gmail.com>
Subject: Re: [PATCH] drivers:gpu:vga_switcheroo: Work around dramatic power
 drain in laptops
From: Alexander Tarasikov <alexander.tarasikov@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, airlied@linux.ie
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/4/29 Alan Cox <alan@lxorguk.ukuu.org.uk>:
> The module parameter is probably the wrong long term option. Do you know
> if the problem is general or specific to some laptops. If it's the latter
> then it might also be worth implementing a DMI and/or PCI detection
> routine to match the laptops you know are afflicted and automatically
> enabled it.
> Alan

I agree that module parameter is not a good idea, but I have seen a
lot of reports
of the problem and no patches were proposed, so I tried to do what I could. It
could be a good temporary solution until we make sure it does not break
any configurations. I am unsure how muxless/muxed cards may differ in
behaviour.

I suspect that the problem is specific to all laptops with
intel+radeon combination.
So far I have found these reports of radeon eating battery

[2010] Acer TravelMate Timeline 8371
[2012] Hp Envy 14 https://bugs.launchpad.net/ubuntu/+source/linux/+bug/909337
[2012] Thinkpad T400 https://bbs.archlinux.org/viewtopic.php?id=133329
[2012] Sony Vaio SE15 (VPCSE1v9E)
http://blog.ejbca.org/2012/02/ubuntu-gnulinux-1204-precise-on-sony.html

The current solution involves doing an ON-OFF cycle and radeon hangs
on echoing ON to switcheroo for a minute. This if, of course, very
annoying and is not ready for daily usage.
I and other users get the messages like

[drm:atom_op_jump] *ERROR* atombios stuck in loop for more than 1sec aborting
[drm:atom_execute_table_locked] *ERROR* atombios stuck executing CAE2
(len 62, WS 0, PS 0) @ 0xCAFE

A possible solution might be to simply remove the "if
(vgasr_priv.clients[i].pwr_state == VGA_SWITCHEROO_ON)"
check. However, that would still mean some userland app will have to echo "OFF"
on each resume. I find this behaviour unacceptable because I believe power
management must be done by kernel and things that are likely to cause hardware
damage (i.e., overheating) must be kept off userland. Overall, the
drivers only do this enable-disable stuff
during probe/remove, but when suspending, we're handing the control
over to the proprietary BIOS/bootloader
and the hardware is left in the undeterminate state. It might be a
good idea to force power reinit on suspend/resume.

Therefore I think we should get people having problems (and those not
having problems) to test the patch
to see if it fixes power drain and does not break other machines
(i.e., whether we can enable aggressive
powersaving for everyone). Maybe it's better to notify downstream
(ubuntu, fedora) but I guess everyone
reads LKML.

-- 
Regards, Alexander
