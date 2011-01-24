Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522Ab1AXTup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 14:50:45 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55628 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab1AXTum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 14:50:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Ae7QD0VazjxS+4scW1tzyQoyBxXHkq63lcCBhunscsydf136ERCJRqsTm1TwBgwYcm
         vzj7D2aWXspNPYT1zTGOnM1dQrMRpY0cQ3MvswYvgrc/UEkDF1QBVgBMN/hqVnH7DEA6
         0k4Ab5/j4Yf00wp3JNQHfizZvq28oEB7tGeE0=
Message-ID: <4D3DD809.4060009@gmail.com>
Date: Mon, 24 Jan 2011 20:50:33 +0100
From: =?ISO-8859-1?Q?Nicolas_de_Peslo=FCan?= 
	<nicolas.2p.debian@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: Rob Landley <rlandley@parallels.com>
CC: Arnaud Lacombe <lacombar@gmail.com>, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>
Subject: Re: [PATCH] Replace scripts/headers_install.pl with a shell script.
References: <4D359E5C.1070002@parallels.com> <AANLkTinvJCiy7xxp=LKUtE+a6DOs9aQ5SNz8Kfj4CTPD@mail.gmail.com>
In-Reply-To: <AANLkTinvJCiy7xxp=LKUtE+a6DOs9aQ5SNz8Kfj4CTPD@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 24/01/2011 17:50, Arnaud Lacombe a écrit :
> Hi,
>
> On Tue, Jan 18, 2011 at 9:06 AM, Rob Landley<rlandley@parallels.com>  wrote:
>> From: Rob Landley<rlandley@parallels.com>
>>
>> Remove perl from make headers_install by replacing a perl script (doing
>> a simple regex search and replace) with a smaller and faster shell script
>> implementation.  The new shell script is a single for loop calling sed and
>> piping its output through unifdef to produce the target file.
>>
>> Change from last time: better error handling.  Split "sed | unifdef" into
>> two stages with a temp file because dash hasn't got PIPEFAIL.  Add check
>> for exit code, add trap handler to delete output when exiting prematurely.
>>
>> Signed-off-by: Rob Landley<rlandley@parallels.com>
>> ---
>>
>>   scripts/Makefile.headersinst |    6 ++--
>>   scripts/headers_install.pl   |   49 ---------------------------------
>>   scripts/headers_install.sh   |   39 ++++++++++++++++++++++++++
>>   3 files changed, 42 insertions(+), 52 deletions(-)
>>
>> diff -ruN linux-2.6.30.old/scripts/headers_install.sh linux-2.6.30/scripts/headers_install.sh
>> --- linux-2.6.30.old/scripts/headers_install.sh 1969-12-31 18:00:00.000000000 -0600
>> +++ linux-2.6.30/scripts/headers_install.sh     2009-06-22 16:21:23.000000000 -0500
>> @@ -0,0 +1,42 @@
>> +#!/bin/sh
>> +
>> +if [ $# -lt 2 ]
>> +then
>> +       echo "Usage: headers_install.sh INDIR OUTDIR [FILES...]
>> +       echo
>> +       echo "Prepares kernel header files for use by user space, by removing"
>> +       echo "all compiler.h definitions and #includes, removing any"
>> +       echo "#ifdef __KERNEL__ sections, and putting __underscores__ around"
>> +       echo "asm/inline/volatile keywords."
>> +       echo
>> +       echo "INDIR:  directory to read each kernel header FILE from."
>> +       echo "OUTDIR: directory to write each userspace header FILE to."
>> +       echo "FILES:  list of header files to operate on."
>> +
>> +       exit 1
>> +fi
>> +
>> +# Grab arguments
>> +
>> +INDIR="$1"
>> +shift
>> +OUTDIR="$1"
>> +shift

INDIR="$1"
OUTDIT="$2"
shift 2

>> +
>> +# Iterate through files listed on command line
>> +
>> +trap "rm -f $OUTDIR/$i $OUTDIR.sed" EXIT

Should be $OUTDIR/$i.sed instead of $OUTDIR.sed.

Also, should be :

trap 'rm -f "$OUTDIR/$i" "$OUTDIR/$i.sed"' EXIT

Else $i will be evaluated at the time the trap command is used, not at the time we exit, and you 
need to protect the filenames using "" everywhere.

And last but not least, doing so, you will only delete the files in the current loop iteration, not 
all the files build by this run.

>> +for i in "$@"
>> +do
>> +       sed -r \
> -r is not portable outside the GNU world.
>
>> +               -e 's/([ \t(])(__user|__force|__iomem)[ \t]/\1/g' \
> these regex are not portable either.
>
> If this perl is to be replaced by sed, I guess it should at least be
> POSIX-compliant (cf. [0]).
>
>   - Arnaud
>
> [0]: http://pubs.opengroup.org/onlinepubs/9699919799/utilities/sed.html
>
>> +               -e 's/__attribute_const__([ \t]|$)/\1/g' \
>> +               -e 's@^#include<linux/compiler.h>@@' \
>> +               -e 's/(^|[ \t])(inline|asm|volatile)([ \t(]|$)/\1__\2__\3/g' \
>> +               "$INDIR/$i">  "$OUTDIR/$i.sed" || exit 1
>> +       scripts/unifdef -U__KERNEL__ -D__EXPORTED_HEADERS__ "$OUTDIR/$i.sed" \
>> +>  "$OUTDIR/$i"
>> +       [ $? -gt 1 ]&&  exit 1
>> +       rm -f "$OUTDIR/$i.sed"
>> +done
>> +trap - EXIT
>> diff -ruN linux-2.6.30.old/scripts/Makefile.headersinst linux-2.6.30/scripts/Makefile.headersinst
>> --- linux-2.6.30.old/scripts/Makefile.headersinst       2009-06-09 22:05:27.000000000 -0500
>> +++ linux-2.6.30/scripts/Makefile.headersinst   2009-06-22 16:21:23.000000000 -0500
>> @@ -45,8 +45,8 @@
>>   quiet_cmd_install = INSTALL $(printdir) ($(words $(all-files))\
>>                              file$(if $(word 2, $(all-files)),s))
>>        cmd_install = \
>> -        $(PERL) $<  $(srctree)/$(obj) $(install) $(SRCARCH) $(header-y); \
>> -        $(PERL) $<  $(objtree)/$(obj) $(install) $(SRCARCH) $(objhdr-y); \
>> +      $(CONFIG_SHELL) $<  $(srctree)/$(obj) $(install) $(header-y); \
>> +      $(CONFIG_SHELL) $<  $(objtree)/$(obj) $(install) $(objhdr-y); \
>>          touch $@

Why did you removed $(SRCARCH) ?

Quoting the original: "arch is used to force a reinstallation when the arch hanges because kbuild 
then detect a command line change."

So, arch is not used by the script, but by the caller and apparently needs to be in the command line.

All that being said, I'm not sure that using the shell instead of perl will enhance anything. We 
face the risk to add many regression with this change.

	Nicolas.

>>   quiet_cmd_remove = REMOVE  $(unwanted)
>> @@ -69,7 +69,7 @@
>>         @:
>>
>>   targets += $(install-file)
>> -$(install-file): scripts/headers_install.pl $(input-files) FORCE
>> +$(install-file): scripts/headers_install.sh $(input-files) FORCE
>>         $(if $(unwanted),$(call cmd,remove),)
>>         $(if $(wildcard $(dir $@)),,$(shell mkdir -p $(dir $@)))
>>         $(call if_changed,install)
>> --- a/scripts/headers_install.pl
>> +++ /dev/null
>> @@ -1,57 +0,0 @@
>> -#!/usr/bin/perl -w
>> -#
>> -# headers_install prepare the listed header files for use in
>> -# user space and copy the files to their destination.
>> -#
>> -# Usage: headers_install.pl readdir installdir arch [files...]
>> -# readdir:    dir to open files
>> -# installdir: dir to install the files
>> -# arch:       current architecture
>> -#             arch is used to force a reinstallation when the arch
>> -#             changes because kbuild then detect a command line change.
>> -# files:      list of files to check
>> -#
>> -# Step in preparation for users space:
>> -# 1) Drop all use of compiler.h definitions
>> -# 2) Drop include of compiler.h
>> -# 3) Drop all sections defined out by __KERNEL__ (using unifdef)
>> -
>> -use strict;
>> -
>> -my ($readdir, $installdir, $arch, @files) = @ARGV;
>> -
>> -my $unifdef = "scripts/unifdef -U__KERNEL__ -D__EXPORTED_HEADERS__";
>> -
>> -foreach my $file (@files) {
>> -       my $tmpfile = "$installdir/$file.tmp";
>> -
>> -       open(my $in, '<', "$readdir/$file")
>> -           or die "$readdir/$file: $!\n";
>> -       open(my $out, '>', $tmpfile)
>> -           or die "$tmpfile: $!\n";
>> -       while (my $line =<$in>) {
>> -               $line =~ s/([\s(])__user\s/$1/g;
>> -               $line =~ s/([\s(])__force\s/$1/g;
>> -               $line =~ s/([\s(])__iomem\s/$1/g;
>> -               $line =~ s/\s__attribute_const__\s/ /g;
>> -               $line =~ s/\s__attribute_const__$//g;
>> -               $line =~ s/^#include<linux\/compiler.h>//;
>> -               $line =~ s/(^|\s)(inline)\b/$1__$2__/g;
>> -               $line =~ s/(^|\s)(asm)\b(\s|[(]|$)/$1__$2__$3/g;
>> -               $line =~ s/(^|\s|[(])(volatile)\b(\s|[(]|$)/$1__$2__$3/g;
>> -               printf {$out} "%s", $line;
>> -       }
>> -       close $out;
>> -       close $in;
>> -
>> -       system $unifdef . " $tmpfile>  $installdir/$file";
>> -       # unifdef will exit 0 on success, and will exit 1 when the
>> -       # file was processed successfully but no changes were made,
>> -       # so abort only when it's higher than that.
>> -       my $e = $?>>  8;
>> -       if ($e>  1) {
>> -               die "$tmpfile: $!\n";
>> -       }
>> -       unlink $tmpfile;
>> -}
>> -exit 0;
>> --
