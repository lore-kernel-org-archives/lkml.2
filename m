Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425Ab0JEBNO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 21:13:14 -0400
Received: from mail.vyatta.com ([76.74.103.46]:43566 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546Ab0JEBNN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 21:13:13 -0400
Date: Tue, 5 Oct 2010 10:13:04 +0900
From: Stephen Hemminger <shemminger@vyatta.com>
To: =?ISO-8859-1?B?xnZhciBBcm5mavZy8A==?= Bjarmason <avarab@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] namespace.pl : update file exclusion list
Message-ID: <20101005101304.1aedcec8@s6510>
In-Reply-To: <AANLkTimtuXbNpXezj8C46KcxRJMYAgRAd2UuqrF2Op_7@mail.gmail.com>
References: <20100928084400.997539242@vyatta.com>
	<20100928084528.970713277@vyatta.com>
	<AANLkTimtuXbNpXezj8C46KcxRJMYAgRAd2UuqrF2Op_7@mail.gmail.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Oct 2010 03:29:43 +0000
Ævar Arnfjörð Bjarmason <avarab@gmail.com> wrote:

> On Tue, Sep 28, 2010 at 08:44, Stephen Hemminger <shemminger@vyatta.com> wrote:
> > The list of exceptions in kernel tree was out of date. Convert
> > the long list of if clauses to a hashes which is more efficient
> > and more common in perl.
> >
> > Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
> >
> > --- a/scripts/namespace.pl      2010-09-28 09:28:52.251563058 +0900
> > +++ b/scripts/namespace.pl      2010-09-28 15:13:38.092073114 +0900
> > @@ -84,6 +84,58 @@ my %ksymtab = ();    # names that appear in
> >  my %ref = ();          # $ref{$name} exists if there is a true external reference to $name
> >  my %export = ();       # $export{$name} exists if there is an EXPORT_... of $name
> >
> > +my %nmexception = (
> > +    'fs/ext3/bitmap'                   => 1,
> > +    'fs/ext4/bitmap'                   => 1,
> > +    'arch/x86/lib/thunk_32'            => 1,
> > +    'arch/x86/lib/cmpxchg'             => 1,
> > +    'arch/x86/vdso/vdso32/note'                => 1,
> > +    'lib/irq_regs'                     => 1,
> > +    'usr/initramfs_data'               => 1,
> > +    'drivers/scsi/aic94xx/aic94xx_dump'        => 1,
> > +    'drivers/scsi/libsas/sas_dump'     => 1,
> > +    'lib/dec_and_lock'                 => 1,
> > +    'drivers/ide/ide-probe-mini'       => 1,
> > +    'usr/initramfs_data'               => 1,
> > +    'drivers/acpi/acpia/exdump'                => 1,
> > +    'drivers/acpi/acpia/rsdump'                => 1,
> > +    'drivers/acpi/acpia/nsdumpdv'      => 1,
> > +    'drivers/acpi/acpia/nsdump'                => 1,
> > +    'arch/ia64/sn/kernel/sn2/io'       => 1,
> > +    'arch/ia64/kernel/gate-data'       => 1,
> > +    'security/capability'              => 1,
> > +    'fs/ntfs/sysctl'                   => 1,
> > +    'fs/jfs/jfs_debug'                 => 1,
> > +);
> > +
> > +my %nameexception = (
> > +    'mod_use_count_'    => 1,
> > +    '__initramfs_end'  => 1,
> > +    '__initramfs_start'        => 1,
> > +    '_einittext'       => 1,
> > +    '_sinittext'       => 1,
> > +    'kallsyms_names'   => 1,
> > +    'kallsyms_num_syms'        => 1,
> > +    'kallsyms_addresses'=> 1,
> > +    '__this_module'    => 1,
> > +    '_etext'           => 1,
> > +    '_edata'           => 1,
> > +    '_end'             => 1,
> > +    '__bss_start'      => 1,
> > +    '_text'            => 1,
> > +    '_stext'           => 1,
> > +    '__gp'             => 1,
> > +    'ia64_unw_start'   => 1,
> > +    'ia64_unw_end'     => 1,
> > +    '__init_begin'     => 1,
> > +    '__init_end'       => 1,
> > +    '__bss_stop'       => 1,
> > +    '__nosave_begin'   => 1,
> > +    '__nosave_end'     => 1,
> > +    'pg0'              => 1,
> > +);
> > +
> > +
> >  &find(\&linux_objects, '.');   # find the objects and do_nm on them
> >  &list_multiply_defined();
> >  &resolve_external_references();
> > @@ -272,27 +324,9 @@ sub do_nm
> >        close($nmdata);
> >
> >        if ($#nmdata < 0) {
> > -               if (
> > -                       $fullname ne "lib/brlock.o"
> > -                       && $fullname ne "lib/dec_and_lock.o"
> > -                       && $fullname ne "fs/xfs/xfs_macros.o"
> > -                       && $fullname ne "drivers/ide/ide-probe-mini.o"
> > -                       && $fullname ne "usr/initramfs_data.o"
> > -                       && $fullname ne "drivers/acpi/executer/exdump.o"
> > -                       && $fullname ne "drivers/acpi/resources/rsdump.o"
> > -                       && $fullname ne "drivers/acpi/namespace/nsdumpdv.o"
> > -                       && $fullname ne "drivers/acpi/namespace/nsdump.o"
> > -                       && $fullname ne "arch/ia64/sn/kernel/sn2/io.o"
> > -                       && $fullname ne "arch/ia64/kernel/gate-data.o"
> > -                       && $fullname ne "drivers/ieee1394/oui.o"
> > -                       && $fullname ne "security/capability.o"
> > -                       && $fullname ne "sound/core/wrappers.o"
> > -                       && $fullname ne "fs/ntfs/sysctl.o"
> > -                       && $fullname ne "fs/jfs/jfs_debug.o"
> > -               ) {
> > -                       printf "No nm data for $fullname\n";
> > -               }
> > -               return;
> > +           printf "No nm data for $fullname\n"
> > +               unless $nmexception{$fullname};
> > +           return;
> 
> 
> This would be more readable and easier to update:
> 
>     my @nmexception = qw(
>         fs/ext3/bitmap
>         fs/ext4/bitmap
>         arch/x86/lib/thunk_32
>         arch/x86/lib/cmpxchg
>         arch/x86/vdso/vdso32/note
>         lib/irq_regs
>         usr/initramfs_data
>         drivers/scsi/aic94xx/aic94xx_dump
>         drivers/scsi/libsas/sas_dump
>         lib/dec_and_lock
>         drivers/ide/ide-probe-mini
>         usr/initramfs_data
>         drivers/acpi/acpia/exdump
>         drivers/acpi/acpia/rsdump
>         drivers/acpi/acpia/nsdumpdv
>         drivers/acpi/acpia/nsdump
>         arch/ia64/sn/kernel/sn2/io
>         arch/ia64/kernel/gate-data
>         security/capability
>         fs/ntfs/sysctl
>         fs/jfs/jfs_debug
>     );
> 
>     my @nameexception = qw(
>         mod_use_count_
>         __initramfs_end
>         __initramfs_start
>         _einittext
>         _sinittext
>         kallsyms_names
>         kallsyms_num_syms
>         kallsyms_addresses
>         __this_module
>         _etext
>         _edata
>         _end
>         __bss_start
>         _text
>         _stext
>         __gp
>         ia64_unw_start
>         ia64_unw_end
>         __init_begin
>         __init_end
>         __bss_stop
>         __nosave_begin
>         __nosave_end
>         pg0
>     );
> 
>     my (%nmexception, %nameexception);
>     @nmexception{@nmexception} = ();
>     @nameexception{@nameexception} = ();
> 
> Then later:
> 
>     print "No nm data for $fullname\n"
>         unless exists $nmexception{$fullname};
> 
> I.e. use print (not printf) and exists().

But the kernel developers are often not perl wizards
and like things written out.

Maybe use map to simplify?

my %nmexception = map { $_ => 1 } qw (
);

