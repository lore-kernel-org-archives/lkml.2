Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab0I2GG7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 02:06:59 -0400
Received: from mail.vyatta.com ([76.74.103.46]:48264 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801Ab0I2GG6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 02:06:58 -0400
Date: Wed, 29 Sep 2010 15:06:45 +0900
From: Stephen Hemminger <shemminger@vyatta.com>
To: =?ISO-8859-1?B?QW3pcmljbw==?= Wang <xiyou.wangcong@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] namespace.pl: fix source tree name mangling
Message-ID: <20100929150645.75b7e390@s6510>
In-Reply-To: <20100929060427.GD5169@cr0.nay.redhat.com>
References: <20100928084400.997539242@vyatta.com>
	<20100928084528.884369764@vyatta.com>
	<20100929043112.GB5169@cr0.nay.redhat.com>
	<20100929141153.551a4851@s6510>
	<20100929060427.GD5169@cr0.nay.redhat.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Sep 2010 14:04:27 +0800
Américo Wang <xiyou.wangcong@gmail.com> wrote:

> On Wed, Sep 29, 2010 at 02:11:53PM +0900, Stephen Hemminger wrote:
> >On Wed, 29 Sep 2010 12:31:12 +0800
> >Américo Wang <xiyou.wangcong@gmail.com> wrote:
> >
> >> On Tue, Sep 28, 2010 at 05:44:02PM +0900, Stephen Hemminger wrote:
> >> >The current namespace.pl script does not find source files correctly.
> >> >The problem is that the current directory is not the base of the kernel
> >> >tree at the point where it calls objdump.
> >> >
> >> >Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
> >> >
> >> >--- a/scripts/namespace.pl	2010-09-27 17:53:29.919433444 +0900
> >> >+++ b/scripts/namespace.pl	2010-09-28 09:24:36.891552993 +0900
> >> >@@ -167,8 +167,10 @@ sub do_nm
> >> > 		printf STDERR "$fullname is not an object file\n";
> >> > 		return;
> >> > 	}
> >> >-	($source = $fullname) =~ s/\.o$//;
> >> >-	if (-e "$objtree$source.c" || -e "$objtree$source.S") {
> >> >+	$fullname =~ s/\.o$//;
> >> >+	$source = $basename;
> >> >+	$source =~ s/\.o$//;
> >> 
> >> With your patch applied, $source will be the basename of
> >> an obj path with .o stripped.
> >> 
> >> >+	if (-e "$objtree$fullname.c" || -e "$objtree$fullname.S") {
> >> > 		$source = "$objtree$source";
> >> > 	} else {
> >> > 		$source = "$srctree$source";
> >> >
> >> 
> >> So here we will get a non-exist path stored in $source.
> >> 
> >> Are you serious? What problem did you meet? I see no problem
> >> with the original code here.
> >
> >The original script is broken, if you run it on a compiled
> >kernel tree.
> >
> >No source file found for arch/x86/boot/a20.o
> >No source file found for arch/x86/boot/bioscall.o
> >No source file found for arch/x86/boot/cmdline.o
> >No source file found for arch/x86/boot/copy.o
> >No source file found for arch/x86/boot/cpucheck.o
> >No source file found for arch/x86/boot/early_serial_console.o
> >No source file found for arch/x86/boot/edd.o
> >No source file found for arch/x86/boot/main.o
> >No source file found for arch/x86/boot/mca.o
> >No source file found for arch/x86/boot/memory.o
> >No source file found for arch/x86/boot/pm.o
> >No source file found for arch/x86/boot/pmjump.o
> >No source file found for arch/x86/boot/printf.o
> >
> >...
> >
> >Running under perl debugger shows that the script has
> >done chdir prior to the failing test:
> >
> 
> I see, the docs of Find module said it will do chdir. :)
> But I think your patch is still not right, how about the
> one below?

Please be more precise about "not right"? It makes the code
work.

Externally defined symbols with no external references
  arch/x86/boot/copy
    memcpy
  arch/x86/boot/header
    _start
    bootsect_start
    realmode_swtch
  arch/x86/boot/pmjump
    in_pm32
  arch/x86/boot/string
    atou
  arch/x86/crypto/aes_glue
    crypto_aes_decrypt_x86
    crypto_aes_encrypt_x86
  arch/x86/kernel/acpi/boot
    mp_config_acpi_legacy_irqs
    mp_override_legacy_irq
    mp_register_gsi
  arch/x86/kernel/acpi/realmode/copy
    memcpy
  arch/x86/kernel/acpi/realmode/wakeup
    _start
  arch/x86/kernel/acpi/wakeup_32
    saved_eip
  arch/x86/kernel/apic/apic
    apic_disable
    enable_IR
    max_physical_apicid
    setup_APIC_eilvt_mce


...
