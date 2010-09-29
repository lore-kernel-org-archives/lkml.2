Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528Ab0I2FME (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 01:12:04 -0400
Received: from mail.vyatta.com ([76.74.103.46]:48815 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077Ab0I2FMC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 01:12:02 -0400
Date: Wed, 29 Sep 2010 14:11:53 +0900
From: Stephen Hemminger <shemminger@vyatta.com>
To: =?ISO-8859-1?B?QW3pcmljbw==?= Wang <xiyou.wangcong@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] namespace.pl: fix source tree name mangling
Message-ID: <20100929141153.551a4851@s6510>
In-Reply-To: <20100929043112.GB5169@cr0.nay.redhat.com>
References: <20100928084400.997539242@vyatta.com>
	<20100928084528.884369764@vyatta.com>
	<20100929043112.GB5169@cr0.nay.redhat.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Sep 2010 12:31:12 +0800
Américo Wang <xiyou.wangcong@gmail.com> wrote:

> On Tue, Sep 28, 2010 at 05:44:02PM +0900, Stephen Hemminger wrote:
> >The current namespace.pl script does not find source files correctly.
> >The problem is that the current directory is not the base of the kernel
> >tree at the point where it calls objdump.
> >
> >Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
> >
> >--- a/scripts/namespace.pl	2010-09-27 17:53:29.919433444 +0900
> >+++ b/scripts/namespace.pl	2010-09-28 09:24:36.891552993 +0900
> >@@ -167,8 +167,10 @@ sub do_nm
> > 		printf STDERR "$fullname is not an object file\n";
> > 		return;
> > 	}
> >-	($source = $fullname) =~ s/\.o$//;
> >-	if (-e "$objtree$source.c" || -e "$objtree$source.S") {
> >+	$fullname =~ s/\.o$//;
> >+	$source = $basename;
> >+	$source =~ s/\.o$//;
> 
> With your patch applied, $source will be the basename of
> an obj path with .o stripped.
> 
> >+	if (-e "$objtree$fullname.c" || -e "$objtree$fullname.S") {
> > 		$source = "$objtree$source";
> > 	} else {
> > 		$source = "$srctree$source";
> >
> 
> So here we will get a non-exist path stored in $source.
> 
> Are you serious? What problem did you meet? I see no problem
> with the original code here.

The original script is broken, if you run it on a compiled
kernel tree.

No source file found for arch/x86/boot/a20.o
No source file found for arch/x86/boot/bioscall.o
No source file found for arch/x86/boot/cmdline.o
No source file found for arch/x86/boot/copy.o
No source file found for arch/x86/boot/cpucheck.o
No source file found for arch/x86/boot/early_serial_console.o
No source file found for arch/x86/boot/edd.o
No source file found for arch/x86/boot/main.o
No source file found for arch/x86/boot/mca.o
No source file found for arch/x86/boot/memory.o
No source file found for arch/x86/boot/pm.o
No source file found for arch/x86/boot/pmjump.o
No source file found for arch/x86/boot/printf.o

...

Running under perl debugger shows that the script has
done chdir prior to the failing test:

	if (! -e "$source.c" && ! -e "$source.S") {
		# No obvious source, exclude the object if it is conglomerate
>>	   open(my $objdumpdata, "$objdump $basename|")
		    or die "$objdump $fullname failed $!\n";

For the first error:
DB<3> x $source
0  'arch/x86/boot/a20'
  DB<4> !!pwd
/home/shemminger/kernel/net-next-2.6/arch/x86/boot
  DB<5> x $fullname
0  'arch/x86/boot/a20.o'
  DB<6> x $basename
0  'a20.o'

Therefore the problem was that $source was full path not the base
of the file name 'a20'
