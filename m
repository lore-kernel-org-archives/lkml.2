Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886Ab1IVHTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 03:19:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:1766 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501Ab1IVHTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 03:19:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="52638981"
Message-ID: <4E7AE173.6000301@linux.intel.com>
Date: Thu, 22 Sep 2011 00:19:15 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: "lkml, " <linux-kernel@vger.kernel.org>
Subject: RFC: ksize.sh - kernel component size build summary report generator
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Build gurus and bit-misers,

As part of an effort to generate minimal configs as well as find areas that may
benefit from a size audit, I've written the following script to try and identify
how much each top level area contributes to the final vmlinux image. The goal is
different from the bloat-o-meter script in that I am not so much interested in
the delta between two kernels, but rather on the size of the individual
components of a single kernel.

It currently relies on the built-in.o hierarchy. This approach has some
(now-)obvious flaws in that it doesn't deal well with the couple *.a files, or
the .o files omitted from the arch/x86/built-in.o which are instead linked
directly into the vmlinux image during the final link step (presumably due to
some ordering requirement?). 

There are also some discrepancies I'd like to understand and hopefully account
for better. For example, the sum of arch/x86/*/built-in.o is larger than
arch/x86/built-in.o. I believe this is due mostly to things like
arch/x86/(lib|pci|power)/built-in.o not being linked into
arch/x86/built-in.o, but rather linked directly into vmlinux.

In other areas, a lot of the size comes from the *.o files at the same level as
the built-in.o. Summing these up can result in a much larger sum than the size
of the built-in.o. I have included the *.o size and count as an aid to
understanding the numbers, but it is lacking.

I strip vmlinux and 'find . -name "*.o"' before running the script.

It is still written in shell, but any additional complexity will likely cause
me to rewrite it in python.

I have included an example report from a fairly minimal atom .config after the
script.

Questions:
o Are there better ways to determine how much size each component contributes to
  vmlinux?
o Does anyone else find this useful?
o Does the format make sense?
o Would any additional data be useful to others?
o Would converting this into a make target make sense? We might be able to make
  use of make's knowledge of what gets linked where to improve how we group
  components.


#!/bin/sh
#
# Copyright (c) 2011, Intel Corporation.
# All rights reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
#
#
# Display details of the kernel build size, broken up by built-in.o. Sort
# the objects by size, omitting anything under 1k by default. Run from the
# top level kernel build directory.
#
# Author: Darren Hart <dvhart@linux.intel.com>
#

clean_up() {
	rm -f $TLDFILE
	rm -f $DFILE
	exit
}

# Uncomment or set in env to print objects under 1K in size
# VERBOSE=1
if [ -n "$VERBOSE" ]; then
	VERBOSE_LIMIT=0
else
	VERBOSE_LIMIT=1024
fi

if [ -z "$ARCH" ]; then
	ARCH="x86"
fi

# Check that we are in a Linux build directory
if [ ! -f vmlinux ]; then
	echo "ERROR: vmlinux not found"
	exit 1
fi

trap clean_up SIGHUP SIGINT SIGTERM

# format_stat() - Format the output of stat
# Print the size of the file in bytes, its name, an optional comment
# and a warning if the object has not been stripped.
# $1 file
# $2 comment
format_stat() {
	if [ ! -f $1 ]; then return; fi

	STRIP=""
	if [ "$(file $1 | grep -c 'not stripped')" != "0" ]; then
		STRIP="(not stripped)"
	fi
	SIZE="$(stat --printf='%s' $1)"
	if [ "$SIZE" -ge "$VERBOSE_LIMIT" ]; then
		stat --printf="%10s\t%n $2 $STRIP\n" $1
	fi
}

TLDFILE=$(mktemp ksize.tmp.XXXXXXXXXX)
DFILE=$(mktemp ksize.tmp.XXXXXXXXXX)

echo "Linux Kernel Images"
echo "======================================================================"
# FIXME: adapt for other architectures and image types
format_stat arch/$ARCH/boot/bzImage "(compressed)"
format_stat vmlinux "(uncompressed)"
echo ""

echo "Top Level Summary"
echo "======================================================================"
format_stat vmlinux "(uncompressed)"
echo "----------------------------------------------------------------------"
for O in arch/$ARCH/built-in.o */built-in.o .tmp_kallsyms2.o; do
	if [ -f "$O" ]; then
		format_stat $O
	fi
done | sort -gr | tee $TLDFILE
echo "----------------------------------------------------------------------"
BI_SUM=$(awk '{S += $1} END {print S}' $TLDFILE)
VM_SIZE=$(stat --printf="%s" vmlinux)
printf "%10d\tTotal from listed objects\n" $BI_SUM
printf "%10d\tTotal from unlisted object files\n" $(($VM_SIZE - $BI_SUM))
echo ""

echo "Detailed Breakdown"
echo "======================================================================"
for TB in $(cat $TLDFILE | awk '{print $2;}'); do
	# Skip files other than built-in.o (such as .tmp_kallsyms2.o)
	if [ ! $(basename "$TB") = "built-in.o"  ]; then continue; fi

	format_stat $TB
	BUILTINS=$(find $(dirname $TB) -maxdepth 2 -name built-in.o)

	# Print a heading line if we will be printing any lower level built-ins
	PRINT_TOTALS=false
	for B in $BUILTINS; do
		SIZE="$(stat --printf='%s' $B)"
		if [ "$B" != "$TB" -a  "$SIZE" -ge "$VERBOSE_LIMIT" ]; then
			echo "----------------------------------------------------------------------"
			PRINT_TOTALS=true
			break
		fi
	done

	# Print details of each built-in.o one level down
	for B in $BUILTINS; do
		if [ "$B" != "$TB" ]; then
			format_stat $B
		fi
	done | sort -gr | tee $DFILE

	if [ $PRINT_TOTALS = true ]; then
		echo "  --------------------------------------------------------------------"
		BI_SUM=$(awk '{S += $1} END {print S}' $DFILE)
		TL_SIZE=$(stat --printf="%s" $TB)
		O_SUM=$(stat --printf="%s %n\n" $(dirname $TB)/*.o | grep -v built-in.o | awk '{S += $1} END {print S}')
		O_CNT=$(ls $(dirname $TB)/*.o | grep -v built-in.o | wc -l)
		printf "%10d\tTotal from listed objects\n" $BI_SUM
		printf "%10d\tTotal from unlisted object files\n" $(($TL_SIZE - $BI_SUM))
		printf "%10d\tSum of $O_CNT top-level object files\n" $O_SUM
	fi
	echo ""
done

clean_up




Linux Kernel Images
======================================================================
   1052768	arch/x86/boot/bzImage (compressed) 
   2030932	vmlinux (uncompressed) 

Top Level Summary
======================================================================
   2030932	vmlinux (uncompressed) 
----------------------------------------------------------------------
    699652	drivers/built-in.o  
    357208	fs/built-in.o  
    258588	arch/x86/built-in.o  
    254256	kernel/built-in.o  
    164068	mm/built-in.o  
    144084	.tmp_kallsyms2.o  
     44100	block/built-in.o  
     29048	lib/built-in.o  
     14188	init/built-in.o  
      3644	security/built-in.o  
----------------------------------------------------------------------
   1968836	Total from listed objects
     62096	Total from unlisted object files

Detailed Breakdown
======================================================================
    699652	drivers/built-in.o  
----------------------------------------------------------------------
    233928	drivers/acpi/built-in.o  
    142644	drivers/tty/built-in.o  
     66372	drivers/pci/built-in.o  
     56048	drivers/mmc/built-in.o  
     45768	drivers/base/built-in.o  
     35880	drivers/input/built-in.o  
     26728	drivers/pnp/built-in.o  
      9408	drivers/char/built-in.o  
      8660	drivers/video/built-in.o  
      7188	drivers/thermal/built-in.o  
      6984	drivers/cpufreq/built-in.o  
      6892	drivers/cpuidle/built-in.o  
      6464	drivers/gpu/built-in.o  
      5440	drivers/firmware/built-in.o  
      4832	drivers/idle/built-in.o  
      4452	drivers/usb/built-in.o  
      4284	drivers/power/built-in.o  
      4172	drivers/spi/built-in.o  
      3048	drivers/clocksource/built-in.o  
  --------------------------------------------------------------------
    679192	Total from listed objects
     20460	Total from unlisted object files
         0	Sum of 0 top-level object files

    357208	fs/built-in.o  
----------------------------------------------------------------------
     78112	fs/ext3/built-in.o  
     44976	fs/proc/built-in.o  
     24000	fs/jbd/built-in.o  
     15108	fs/sysfs/built-in.o  
      9360	fs/partitions/built-in.o  
      3988	fs/nls/built-in.o  
      2872	fs/ramfs/built-in.o  
      2844	fs/devpts/built-in.o  
  --------------------------------------------------------------------
    181260	Total from listed objects
    175948	Total from unlisted object files
    215600	Sum of 48 top-level object files

    258588	arch/x86/built-in.o  
----------------------------------------------------------------------
    217484	arch/x86/kernel/built-in.o  
     42112	arch/x86/pci/built-in.o  
     31352	arch/x86/mm/built-in.o  
      6372	arch/x86/platform/built-in.o  
      5796	arch/x86/vdso/built-in.o  
      1648	arch/x86/power/built-in.o  
  --------------------------------------------------------------------
    304764	Total from listed objects
    -46176	Total from unlisted object files
         0	Sum of 0 top-level object files

    254256	kernel/built-in.o  
----------------------------------------------------------------------
     31828	kernel/events/built-in.o  
     28372	kernel/time/built-in.o  
     15368	kernel/irq/built-in.o  
      4164	kernel/power/built-in.o  
  --------------------------------------------------------------------
     79732	Total from listed objects
    174524	Total from unlisted object files
    217400	Sum of 56 top-level object files

    164068	mm/built-in.o  

     44100	block/built-in.o  

     29048	lib/built-in.o  

     14188	init/built-in.o  

      3644	security/built-in.o  

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
