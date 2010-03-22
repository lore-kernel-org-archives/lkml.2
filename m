Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab0CVHGH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 03:06:07 -0400
Received: from mail-yx0-f182.google.com ([209.85.210.182]:41207 "EHLO
	mail-yx0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009Ab0CVHGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 03:06:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=W6uDQud6hQGgWz49deRz1Zlrs1bEjQnreY32hzoDWH4hM5ZfA4YD3xZEYR7x30RAq1
         9n8wK381z7KYvo8N/xvqMAC7fhhcMHbnTf6DPZXeJxEU1676u9PWFRHWWqwB9FVDNE7e
         KaofKLe/J9egMuk1MG/0nFiO4zV+4Dl5NCB8A=
Message-ID: <4BA716E5.2060800@gmail.com>
Date: Mon, 22 Mar 2010 00:06:13 -0700
From: "Justin P. mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Zbigniew Luszpinski <zbiggy@go2.pl>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.32 help needed with reverting APIC patches.
References: <201003220123.37341.zbiggy@go2.pl>
In-Reply-To: <201003220123.37341.zbiggy@go2.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2010 05:23 PM, Zbigniew Luszpinski wrote:
> Hello,
>
> I'm investigating why my Nvidia MCP78S chipset needs noapic or acpi=noirq to protect USB OHCI against hanging at random time.
> (both kernel parameters turns off APIC and fall back to PIC). Asrock K10N78FullHD-hSLI R3.0 mainboard.
> The OHCI USB controller integrated in chipset is the only device which hangs in APIC mode.
> The bug does not exist on Windows XP SP3 and OpenSolaris 2009.6 so I'm focused on APIC handling differences between those systems and Linux.
>
> First it looks like those systems use classical handling with interrupt masking. Linux abandoned this between 2.6.20 and 2.6.21:
> http://www.mail-archive.com/linux-net@vger.kernel.org/msg01535.html
> (the bug described at this link is identical to mine except it talks about network cards not usb ohci)
> That is why I would like to revert those patches and do the test.
> I tried to revert these 2 patches in vanilla kernel 2.6.32.8 I use but failed because IRQ_DELAYED_DISABLE flag and supporting code vanished away.
> It is problematic to reinsert it back because of this:
> 2.6.20:
> #define IRQ_DELAYED_DISABLE    0x00100000      /* IRQ disable (masking) happens delayed. */
> 2.6.32:
> #define IRQ_WAKEUP             0x00100000      /* IRQ triggers system wakeup */
> I tried to revert these 2 patches and workaround missing IRQ_DELAYED_DISABLE but this resulted in black screen and kernel unable to boot.
>
> So I tried to boot 2.6.20 kernel distro - boot failed because MCP78S AHCI is too new for 2.6.20. Backporting PCI IDs did nothing.
> Kernel still can not mount VFS and access SATA hdd or CD - kernel can not correctly talk to AHCI controller.
> IDE compatibility mode is even worse. So 2.6.20 or older is not an option for me.
>
> Second they use Level triggered interrupts when Linux uses fasteoi.
> AFAIR kernel 2.6.18 uses Level triggered IRQs. It seems RHEL5 still uses kernel 2.6.18 but it is custom patched and will not be reliable for checking.
> If someone is APIC guru and would like to make a patch which brings back level triggered IRQs to 2.6.32.8 I would be happy to do the test.
>
> Third: it may be bug in ACPI - Linux uses ACPI to enable APIC.
> I browsed the ACPI tables code but did not find any traps prepared for Linux so it looks clean. But to be sure it would be cool to use APIC without ACPI.
> If you know how to patch kernel to force APIC use with acpi=off let me know. My mainboard has no MPS tables - everything is done via ACPI.
> The ACPI tables in bios are not syntax and hw clean - I fixed all ACPI bugs but this not changed anything.
>
> I believe the #1 solution will be the one I look for without the need for testing solutions #2 and #3.
> If someone will help me reverting:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=76d2160147f43f982dfe881404cfde9fd0a9da21
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d7e25f3394ba05a6d64cb2be42c2765fe72ea6b2
> in kernel 2.6.32 or 2.6.33 I could start testing and excluding possible bug sources.
>
> Here is my bugreport:
> https://bugzilla.kernel.org/show_bug.cgi?id=13405
>
> have a nice day,
> Zbigniew Luszpinski
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


best would be todo a bisect. but if your for sure these
are the commits, then you probably wont need too.

if your doing git revert xxxx
and the commit reverts for you then your good,
but if there's too much happening(big merge), then
a git rebase probably is the best bet(but could be wrong).

hope this helps.

Justin P. Mattock
