Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab0H3EuL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 00:50:11 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33168 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543Ab0H3EuJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 00:50:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GPDaB1oXO4e0Z07kfamcQqi/6hF6lCf8n8HdbH18bd7PPwIMvhOweKyYLhlFMZh+0h
         SGSiRNW3cShURWXgwZMFW4kuX4C+2FvthifxCM9rAJ+tOmo7jXiiN1JHR56a6AXhXaoV
         Py0reL8Eg+Jp4h4lbv+yJPPZRO/CU3mGp7MbU=
MIME-Version: 1.0
In-Reply-To: <4C7AE4FE.4090801@kernel.org>
References: <AANLkTinRRiW1VUzS+3T82=q8PsoRn78Cgn_X8gSduM0U@mail.gmail.com>
	<AANLkTi=652CHVZz8TAqCOiOLO2XyUHd6_i3vWNgbVzKA@mail.gmail.com>
	<4C7AE4FE.4090801@kernel.org>
Date: Mon, 30 Aug 2010 06:50:07 +0200
Message-ID: <AANLkTinA2vvuHg2aWqGjraR155Gav7NcR5k94ONhddT6@mail.gmail.com>
Subject: Re: Linux 2.6.36-rc3
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30, 2010 at 12:53 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> On 08/29/2010 12:24 PM, Torsten Kaiser wrote:
>> I'm still seeing the regression from -rc1 that the start of the early
>> serial output only contains garbage.
[snip]
> this one should fix the problem.
>
> please check

Yes, this fixes it:
Aug 30 06:44:19 treogen syslog-ng[2940]: syslog-ng shutting down;
version='3.1.2'
[ 1232.914095] Restarting system.

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Linux version 2.6.36-rc3 (root@treogen) (gcc version
4.4.4 (Gentoo 4.4.4-r1 p1.0, pie-0.4.5) ) #1 SMP Sun Aug 29 19:03:00
CEST 2010
[    0.000000] Command line: fastboot earlyprintk=serial,ttyS0,115200
console=ttyS0,115200 console=tty1 crypt_root=/dev/md3 radeon.modeset=1
video=1280x1024
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)

Thanks!

> [PATCH] x86, setup: fix earlyprint=serial,ttyS0...
>
> Torsten reported that there is garbage output,
> after commit 8fee13a48e4879fba57725f6d9513df4bfa8e9f3 (x86,
> setup: enable early console output from the decompressor)
>
> it turns out we missed the offset for that case.
>
> Reported-by: Torsten Kaiser <just.for.lkml@googlemail.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>
> Index: linux-2.6/arch/x86/boot/early_serial_console.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/boot/early_serial_console.c
> +++ linux-2.6/arch/x86/boot/early_serial_console.c
> @@ -58,7 +58,7 @@ static void parse_earlyprintk(void)
>                if (arg[pos] == ',')
>                        pos++;
>
> -               if (!strncmp(arg, "ttyS", 4)) {
> +               if (!strncmp(arg + pos, "ttyS", 4)) {
>                        static const int bases[] = { 0x3f8, 0x2f8 };
>                        int idx = 0;
>
>
>
