Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730Ab2ANGVY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 01:21:24 -0500
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:60794 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab2ANGVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 01:21:22 -0500
Message-ID: <1326522056.14979.55.camel@x61.thuisdomein>
Subject: Re: [PATCH 2/2] kconfig/streamline-config.pl: Fix parsing Makefile
 with variables
From: Paul Bolle <pebolle@tiscali.nl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Lange <thomas-lange2@gmx.de>,
        Arend van Spriel <arend@broadcom.com>, stable@vger.kernel.org
Date: Sat, 14 Jan 2012 07:20:56 +0100
In-Reply-To: <20120113232419.155439516@goodmis.org>
References: <20120113231158.364436936@goodmis.org>
	 <20120113232419.155439516@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven,

A few remarks follow. (Mainly suggesting to add a some comments.)

On Fri, 2012-01-13 at 18:12 -0500, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> Thomas Lange reported that when he did a 'make localmodconfig', his
> config was missing the brcmsmac driver, even though he had the module
> loaded.
> 
> Looking into this, I found the file:
> drivers/net/wireless/brcm80211/brcmsmac/Makefile
> had the following in the Makefile:
> 
> MODULEPFX := brcmsmac
> 
> obj-$(CONFIG_BRCMSMAC)  += $(MODULEPFX).o
> 
> The way streamline-config.pl works, is parsing all the
>  obj-$(CONFIG_FOO) += foo.o
> lines to find that CONFIG_FOO belongs to the module foo.ko.
> 
> But in this case, the brcmsmac.o was not used, but a variable in its place.
> 
> By changing streamline-config.pl to remember defined variables in Makefiles
> and substituting them when they are used in the obj-X lines, allows
> Thomas (and others) to have their brcmsmac module stay configured
> when it is loaded and running "make localmodconfig".
> 
> Reported-by: Thomas Lange <thomas-lange2@gmx.de>
> Tested-by: Thomas Lange <thomas-lange2@gmx.de>
> Cc: Arend van Spriel <arend@broadcom.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  scripts/kconfig/streamline_config.pl |   29 +++++++++++++++++++++++++++++
>  1 files changed, 29 insertions(+), 0 deletions(-)
> 
> diff --git a/scripts/kconfig/streamline_config.pl b/scripts/kconfig/streamline_config.pl
> index 42ef5ea..bccf07d 100644
> --- a/scripts/kconfig/streamline_config.pl
> +++ b/scripts/kconfig/streamline_config.pl
> @@ -250,10 +250,33 @@ if ($kconfig) {
>      read_kconfig($kconfig);
>  }
>  
> +sub convert_vars {
> +    my ($line, %vars) = @_;
> +
> +    my $process = "";
> +
> +    while ($line =~ s/^(.*?)(\$\((.*?)\))//) {

I know just enough perl to be dangerous. But I'm guessing that even
people more familiar with perl (and regexes) wouldn't mind a short
comment here. Perhaps something like
    # handle all occurrences of "$(VAR)" in this line 

> +	my $start = $1;
> +	my $variable = $2;
> +	my $var = $3;

Using both "$variable" and "$var" is a bit awkward. Perhaps "$name"
instead of "$var"?
 
> +
> +	if (defined($vars{$var})) {
> +	    $process .= $start . $vars{$var};
> +	} else {

Add
             # Unknown variable, just put it back

here (or something similar)?

> +	    $process .= $start . $variable;
> +	}
> +    }
> +
> +    $process .= $line;
> +
> +    return $process;
> +}
> +
>  # Read all Makefiles to map the configs to the objects
>  foreach my $makefile (@makefiles) {
>  
>      my $line = "";
> +    my %make_vars;
>  
>      open(MIN,$makefile) || die "Can't open $makefile";
>      while (<MIN>) {
> @@ -270,10 +293,16 @@ foreach my $makefile (@makefiles) {
>  
>  	my $objs;
>  
> +	$_ = convert_vars($_, %make_vars);
> +
>  	# collect objects after obj-$(CONFIG_FOO_BAR)
>  	if (/obj-\$\((CONFIG_[^\)]*)\)\s*[+:]?=\s*(.*)/) {

This is unrelated to this patch, but anyhow. Doing
    git grep -n "obj-" $(git ls-files "*Makefile*") | grep CONFIG | grep -v "obj-\$(CONFIG"

generated three types of possible corner cases here. Some examples:
0) "obj-pci-$(CONFIG_ARCH_IXDP4XX)		+= ixdp425-pci.o"
   (there are about a dozen of these)
and
   "obj-pvrusb2-sysfs-$(CONFIG_VIDEO_PVRUSB2_SYSFS) := pvrusb2-sysfs.o"
   (three times)
Are these relevant for this script?

1) "obj-${CONFIG_EISA_PCI_EISA}     += pci_eisa.o"
   (three times)

The braces look a bit odd. Shouldn't that be parentheses, at least to be
consistent? Michal?

2) "obj-$(subst m,y,$(CONFIG_VLAN_8021Q))	+= vlan_core.o"
   (about a dozen times)
I do not know what subst actually does here, but this might be missed by
this script too. Relevant?

Do these corner cases merit further attention?

>  	    $var = $1;
>  	    $objs = $2;
> +
> +	# check if variables are set

"[...] and safe them for future substitution"?

> +	} elsif (/^\s*(\S+)\s*[:]?=\s*(.*\S)/) {
> +	    $make_vars{$1} = $2;
>  	}
>  	if (defined($objs)) {
>  	    foreach my $obj (split /\s+/,$objs) {


Paul Bolle

