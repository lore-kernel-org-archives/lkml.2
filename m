Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab1BKM7Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 07:59:24 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64883 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab1BKM7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 07:59:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=prA7ErjMgcJCV94GhKXwyz5qR/HmJvi6K/R46AJvTq859rC1lCNydeHlWbY22K5FPV
         Bl/tch/XJc/jW/4U7Wp0MVsDSQP1wCpaob25lQDl83NMDmNn6k7iuLajo5FzfqZ8uya7
         LGk6HVFfSjvc7b7PnjzLFIbsnKmH3sTWsB3ig=
From: Wang Lei <f3d27b@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>
Subject: Re: [SOUND] SBx00 sound card using snd_hda_codec_analog auto mutes
References: <s5h39nwdk4u.wl%tiwai@suse.de>
	<4d552a5a.03368e0a.5890.2b59@mx.google.com>
	<s5hlj1mburb.wl%tiwai@suse.de>
Date: Fri, 11 Feb 2011 20:58:49 +0800
In-Reply-To: <s5hlj1mburb.wl%tiwai@suse.de> (Takashi Iwai's message of "Fri,
	11 Feb 2011 13:50:16 +0100")
Message-ID: <4d5532aa.0ae9640a.3773.316b@mx.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai <tiwai@suse.de> writes:

> At Fri, 11 Feb 2011 20:23:21 +0800,
> Wang Lei wrote:
>> 
>> Thanks for your reply!
>> 
>> Takashi Iwai <tiwai@suse.de> writes:
>> 
>> > At Thu, 10 Feb 2011 20:49:51 +0800,
>> > Wang Lei wrote:
>> >> 
>> >> On my laptop, the sound card auto mutes some seconds after i enable it.
>> >> And play a audio file can't make sound. This is not a powersave feature,
>> >> because i haven't enable it. I guess it's a driver problem. It occurs
>> >> since 2.6.36.X. Please help.
>> >
>> > Then a possible cause would be the badly working interrupts.
>> > Or, I remember vaguely some reports mentioning conflicts with radeon
>> > driver.
>> >
>> > Anyway, try to reproduce without the graphic interface first.
>> >
>> 
>> I have reproduced it without the graphic interface.
>> 
>> > Also, try to pass enable_msi=0 or 1.  AMD controllers tend to unstable
>> > regarding MSI.
>> >
>> 
>> And pass enable_msi=0 or 1 to snd_hda_intel, or even add boot parameter
>> pci=nomsi (i actually don't know whether this is reasonable), the
>> problem occurs.
>> 
>> I have forgot to mention this, when passing apci=off to the boot kernel,
>> there is no this problem.
>
> Then check whether the interrupt is properly generated during PCM
> playback by watching /proc/interrupts.  If not, it's likely an ACPI or
> BIOS problem.
>

I hope i did the right thing. I `cat /proc/interrupts > 1', then use
alsamixer increase the PCM channel, then `cat /proc/interrupts >2'.

This is the diff output:
--------------------
[~]$ diff -u 1 2
--- 1	2011-02-11 20:54:29.205759305 +0800
+++ 2	2011-02-11 20:54:35.912611712 +0800
@@ -1,21 +1,21 @@
            CPU0       CPU1       
-  0:      11355    9074412   IO-APIC-edge      timer
-  1:         28       7111   IO-APIC-edge      i8042
+  0:      11355    9081104   IO-APIC-edge      timer
+  1:         28       7141   IO-APIC-edge      i8042
   7:          1          0   IO-APIC-edge    
   8:          0          0   IO-APIC-edge      rtc0
   9:          1         49   IO-APIC-fasteoi   acpi
  12:       4193    1186548   IO-APIC-edge      i8042
  14:          1         52   IO-APIC-edge      pata_atiixp
  15:          0          0   IO-APIC-edge      pata_atiixp
- 16:        760     271833   IO-APIC-fasteoi   ahci, hda_intel
+ 16:        760     271846   IO-APIC-fasteoi   ahci, hda_intel
  17:        344      84956   IO-APIC-fasteoi   ohci_hcd:usb3, ohci_hcd:usb4, ohci_hcd:usb5, ohci_hcd:usb6
  23:          1          7   IO-APIC-fasteoi   ehci_hcd:usb1, ohci_hcd:usb2
 NMI:          0          0   Non-maskable interrupts
-LOC:    9074392      11170   Local timer interrupts
+LOC:    9081084      11170   Local timer interrupts
 SPU:          0          0   Spurious interrupts
 PMI:          0          0   Performance monitoring interrupts
 IWI:          0          0   IRQ work interrupts
-RES:     833684     997760   Rescheduling interrupts
+RES:     834075     998023   Rescheduling interrupts
 CAL:         16          6   Function call interrupts
 TLB:      21213      18762   TLB shootdowns
 THR:          0          0   Threshold APIC interrupts
[~]$
--------------------

>
> Takashi
