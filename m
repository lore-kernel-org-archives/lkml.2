Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366Ab0I2F75 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 01:59:57 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:33596 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab0I2F74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 01:59:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=N8H8W4NVafTmY+kU39OnW9vDhDsPn+vz8WRPn9vkrJu8Kt/qTaPgTuKvmV0eSTsjAb
         rYQdgq9avYxfs6TWmpBW5h8juXQAw9DqJxVgeKvxvorFxJz+KBJOnf4BetRkXTJJGble
         dt+T+iWG5ABJc3uHuge/BVwDHVLsT/PaO7XyA=
Date: Wed, 29 Sep 2010 14:04:27 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] namespace.pl: fix source tree name mangling
Message-ID: <20100929060427.GD5169@cr0.nay.redhat.com>
References: <20100928084400.997539242@vyatta.com>
 <20100928084528.884369764@vyatta.com>
 <20100929043112.GB5169@cr0.nay.redhat.com>
 <20100929141153.551a4851@s6510>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100929141153.551a4851@s6510>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 02:11:53PM +0900, Stephen Hemminger wrote:
>On Wed, 29 Sep 2010 12:31:12 +0800
>Américo Wang <xiyou.wangcong@gmail.com> wrote:
>
>> On Tue, Sep 28, 2010 at 05:44:02PM +0900, Stephen Hemminger wrote:
>> >The current namespace.pl script does not find source files correctly.
>> >The problem is that the current directory is not the base of the kernel
>> >tree at the point where it calls objdump.
>> >
>> >Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
>> >
>> >--- a/scripts/namespace.pl	2010-09-27 17:53:29.919433444 +0900
>> >+++ b/scripts/namespace.pl	2010-09-28 09:24:36.891552993 +0900
>> >@@ -167,8 +167,10 @@ sub do_nm
>> > 		printf STDERR "$fullname is not an object file\n";
>> > 		return;
>> > 	}
>> >-	($source = $fullname) =~ s/\.o$//;
>> >-	if (-e "$objtree$source.c" || -e "$objtree$source.S") {
>> >+	$fullname =~ s/\.o$//;
>> >+	$source = $basename;
>> >+	$source =~ s/\.o$//;
>> 
>> With your patch applied, $source will be the basename of
>> an obj path with .o stripped.
>> 
>> >+	if (-e "$objtree$fullname.c" || -e "$objtree$fullname.S") {
>> > 		$source = "$objtree$source";
>> > 	} else {
>> > 		$source = "$srctree$source";
>> >
>> 
>> So here we will get a non-exist path stored in $source.
>> 
>> Are you serious? What problem did you meet? I see no problem
>> with the original code here.
>
>The original script is broken, if you run it on a compiled
>kernel tree.
>
>No source file found for arch/x86/boot/a20.o
>No source file found for arch/x86/boot/bioscall.o
>No source file found for arch/x86/boot/cmdline.o
>No source file found for arch/x86/boot/copy.o
>No source file found for arch/x86/boot/cpucheck.o
>No source file found for arch/x86/boot/early_serial_console.o
>No source file found for arch/x86/boot/edd.o
>No source file found for arch/x86/boot/main.o
>No source file found for arch/x86/boot/mca.o
>No source file found for arch/x86/boot/memory.o
>No source file found for arch/x86/boot/pm.o
>No source file found for arch/x86/boot/pmjump.o
>No source file found for arch/x86/boot/printf.o
>
>...
>
>Running under perl debugger shows that the script has
>done chdir prior to the failing test:
>

I see, the docs of Find module said it will do chdir. :)
But I think your patch is still not right, how about the
one below?

------------------>

File::Find will do chdir, so using a relative patch is
not correct. Use an absolute patch instead.


Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

diff --git a/scripts/namespace.pl b/scripts/namespace.pl
index 361d0f7..fb4e245 100755
--- a/scripts/namespace.pl
+++ b/scripts/namespace.pl
@@ -167,11 +167,11 @@ sub do_nm
 		printf STDERR "$fullname is not an object file\n";
 		return;
 	}
-	($source = $fullname) =~ s/\.o$//;
-	if (-e "$objtree$source.c" || -e "$objtree$source.S") {
-		$source = "$objtree$source";
+	($source = $basename) =~ s/\.o$//;
+	if (-e "$source.c" || -e "$source.S") {
+		$source = "$objtree$File::Find::dir/$source";
 	} else {
-		$source = "$srctree$source";
+		$source = "$srctree$File::Find::dir/$source";
 	}
 	if (! -e "$source.c" && ! -e "$source.S") {
 		# No obvious source, exclude the object if it is conglomerate

