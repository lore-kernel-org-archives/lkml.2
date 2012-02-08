Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab2BHOEH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 09:04:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8986 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538Ab2BHOEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 09:04:04 -0500
Message-ID: <4F3280C7.1030401@redhat.com>
Date: Wed, 08 Feb 2012 09:03:51 -0500
From: Adam Jackson <ajax@redhat.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, arnd@arndb.de, gregkh@linuxfoundation.org
Subject: Re: [PATCH 1/2] char/mem: Add /dev/io (v2)
References: <1328623901-20628-1-git-send-email-ajax@redhat.com> <1328657985-13942-1-git-send-email-ajax@redhat.com> <20120208001724.7e5c7be4@pyramind.ukuu.org.uk> <4F31C417.30502@redhat.com> <20120208092611.49ada8c5@pyramind.ukuu.org.uk>
In-Reply-To: <20120208092611.49ada8c5@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/8/12 4:26 AM, Alan Cox wrote:

>> Yeah, I'll be sure to do that right as soon as I can stop supporting the
>> vesa driver.  Until that time I don't really have any choice but to
>> expose the whole of I/O port space, since I have no idea what the video
>> BIOS is going to touch.
>
> I would be surprised if you couldn't make a very good guess, and many
> things it might want to touch are things that need blocking/emulating
> anyway.

I will be happy to write the code to emulate or block those ports in the 
kernel if it's necessary, rather than needing to replicate them across 
every userspace display server that wants to support vesa.  We already 
have a fair bit of it in xserver's int10 harness.

In the meantime, can I please have kernel services that work?

>> I don't disagree with wanting to limit access to these services, but
>> /dev/io is at least somewhat containable, whereas iopl is insane.
>
> They are both equally insane and have effectively identical security
> semntics. Continuing to use iopl is both faster and avoids adding a kernel
> API however. Even better it's x86 specific so that piece of manure
> doesn't escape onto other platforms without the legacy vesa mess.

Every point in this paragraph is at best misleading, if not outright wrong.

iopl does not have identical security semantics to ioperm.  iopl lets my 
X server disable interrupts.  /dev/io would not, and would let me add a 
per-port filter if desired.  Code I am happy to write, for the record, 
although since CAP_SYS_RAWIO is required regardless of filesystem 
permissions it'd not do much besides prevent root from nuking the machine.

Your definition of "faster" is spurious.  VBE calls are not a 
performance path and system call overhead is negligible compared to I/O 
serialization.  If anything /dev/io can be _faster_ in the mainline case 
because we'll no longer need to handle the ioperm bitmask on every 
context switch.

The current patch set results in a net gain of zero kernel interfaces, 
once /dev/port is put down in a year.  I will admit that the current 
/dev/port is probably not a meaningfully used API, seeing how it's been 
broken since literally kernel 0.10.  But it's there and enabled by 
default.  I would like it to work, please.

Invoking architecture-specificity is spurious.  Competent architectures 
have a usable framebuffer interface from the firmware, so vesa never 
comes up.  x86 does not.  x86 has vesa, which is a support reality for 
at _least_ the next three years of new hardware.  Alternatively, x86 has 
UEFI, a travesty from its very inception.  Until that travesty has 
managed to successfully infect every bootable x86 machine on the planet 
vesa continues to be a thing I have to support.

Basically what I'm hearing here is "don't bother doing this well since 
you already have a way you're doing it badly".  That's crap.  I've 
written the code to do it well.  I've signed up for the support cost. 
Can I please have something good instead of something bad?  I sort of 
thought "good" was the whole point of what we're doing here.

- ajax
