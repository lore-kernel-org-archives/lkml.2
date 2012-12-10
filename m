Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445Ab2LJV2x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 16:28:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45221 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368Ab2LJV2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 16:28:51 -0500
Message-ID: <50C6537A.9090303@zytor.com>
Date: Mon, 10 Dec 2012 13:26:18 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] Enable A20 using KBC for some MSI laptops to fix S3
 resume
References: <201210261056.44225.zary@gsystems.sk> <201211052135.20009.linux@rainbow-software.org>
In-Reply-To: <201211052135.20009.linux@rainbow-software.org>
X-Enigmail-Version: 1.4.6
Content-Type: multipart/mixed;
 boundary="------------050400020700090403080108"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050400020700090403080108
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/05/2012 12:35 PM, Ondrej Zary wrote:
> On Friday 26 October 2012 10:56:44 Ondrej Zary wrote:
>> Some MSI laptop BIOSes are broken - INT 15h code uses port 92h to enable
>> A20 line but resume code assumes that KBC was used.
>> The laptop will not resume from S3 otherwise but powers off after a while
>> and then powers on again stuck with a blank screen.
>>
>> Fix it by enabling A20 using KBC. Affected laptop list and DMI data are
>> from bug reports at Ubuntu Launchpad.
>>
>> Also add kernel parameter to easily activate this quirk on any system.
>>
>> Only compile tested. The original patch was tested with EX600 and PR200.
>>
>> Fixes https://bugzilla.kernel.org/show_bug.cgi?id=12878
> 
> The bug was marked as RESOLVED CODE_FIX but I wonder what happened to this 
> patch. Was it applied? Or is someone working on a better way to fix this 
> problem?
> 

Sorry, I managed to forget about this.

Is there any way you could test this patch by any chance?

I would be a lot happier if this works as a general solution rather than
relying on a quirk...

	-hpa


--------------050400020700090403080108
Content-Type: text/x-patch;
 name="0001-x86-suspend-Run-A20-test-on-resume.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-x86-suspend-Run-A20-test-on-resume.patch"

>From 5513340abd845eaa28fe2394f7e0296599f2d9e7 Mon Sep 17 00:00:00 2001
From: "H. Peter Anvin" <hpa@linux.intel.com>
Date: Mon, 10 Dec 2012 13:17:48 -0800
Subject: [PATCH] x86, suspend: Run A20 test on resume

If A20 is disabled on resume, we may have to explicitly enable it.
Rather than creating a bunch of ad hoc code, use the same code we
would on system startup.

Note: the startup code implicitly assumes BIOS, specifically that int
$0x15 is enabled.  However, for non-BIOS platforms to have A20 closed
on resume seems extremely unlikely, since pretty much all non-BIOS
firmware run in 32- or 64-bit mode.

Reported-by: Ondrej Zary <linux@rainbow-software.org>
Link: http://lkml.kernel.org/r/201210240847.52417.linux@rainbow-software.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/realmode/rm/Makefile   | 2 +-
 arch/x86/realmode/rm/a20.c      | 1 +
 arch/x86/realmode/rm/wakemain.c | 3 +++
 3 files changed, 5 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/realmode/rm/a20.c

diff --git a/arch/x86/realmode/rm/Makefile b/arch/x86/realmode/rm/Makefile
index 8869287..7e2ff68 100644
--- a/arch/x86/realmode/rm/Makefile
+++ b/arch/x86/realmode/rm/Makefile
@@ -10,7 +10,7 @@
 always := realmode.bin realmode.relocs
 
 wakeup-objs	:= wakeup_asm.o wakemain.o video-mode.o
-wakeup-objs	+= copy.o bioscall.o regs.o
+wakeup-objs	+= copy.o bioscall.o regs.o a20.o
 # The link order of the video-*.o modules can matter.  In particular,
 # video-vga.o *must* be listed first, followed by video-vesa.o.
 # Hardware-specific drivers should follow in the order they should be
diff --git a/arch/x86/realmode/rm/a20.c b/arch/x86/realmode/rm/a20.c
new file mode 100644
index 0000000..e71d518
--- /dev/null
+++ b/arch/x86/realmode/rm/a20.c
@@ -0,0 +1 @@
+#include "../../boot/a20.c"
diff --git a/arch/x86/realmode/rm/wakemain.c b/arch/x86/realmode/rm/wakemain.c
index 91405d5..6e0d548 100644
--- a/arch/x86/realmode/rm/wakemain.c
+++ b/arch/x86/realmode/rm/wakemain.c
@@ -79,4 +79,7 @@ void main(void)
 		probe_cards(0);
 		set_mode(wakeup_header.video_mode);
 	}
+
+	/* If A20 is closed, fix now */
+	enable_a20();
 }
-- 
1.7.11.7


--------------050400020700090403080108--
