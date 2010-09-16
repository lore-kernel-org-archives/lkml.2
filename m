Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191Ab0IPUXg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 16:23:36 -0400
Received: from imta-38.everyone.net ([216.200.145.38]:54473 "EHLO
	imta-38.everyone.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309Ab0IPUXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 16:23:34 -0400
X-Eon-Dm: dm0104
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Message-Id: <20100916132303.DD13223@resin14.mta.everyone.net>
Date: Thu, 16 Sep 2010 13:23:03 -0700
From: "Denis Kaganovich" <root@eu.by>
Reply-To: <mahatma@eu.by>
To: "Rusty Russell" <rusty@rustcorp.com.au>
Cc: <linux-kernel@vger.kernel.org>, <jeremy@goop.org>,
        <dmitry.torokhov@gmail.com>, <akpm@linux-foundation.org>
Subject: Re: #2 (Re: More modaliases + patchtool)
X-Eon-Sig: AQGpYklMknyo600g6QEAAAAF,4ffdb9982f6de338e1de7a43ac70e53b
X-Originating-Ip: 178.168.136.46
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 phishscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=6.0.2-1004200000 definitions=main-1009160097
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- rusty@rustcorp.com.au wrote:

This one, too, seems to make sense.

[ Remaining 2/3 of patch cut here ].

I think the best way to split this patch is by bus type.  Drop the 
#ifdef's
if you think it's a good idea, do some compile testing, then forward to 
the
specific maintainers for each type.  I'm happy to do that for you if you
want (though these kind of patches are Morton-worthy IMHO).

Cheers,
Rusty.
===

I just seen your messages, sorry, may be not forwarded to work...
OK, I will make hand-checks and splitting, etc. About "#ifdef" ;) I add 
it only after one (NOW not remember) driver from OF bus and think that 
for AUTO-mode good to be always "#ifdef". I will remove ifdef's for 
drivers, hardly related from its buses (this is dummy for scripting, but 
easy for human).

PS Preview (or solution?), sorry attachment disabled here - this version of script with "--diff" flag will generate (in current dir) patches for BUS.patch (upcase - ifdef) and bus.patch (lowcase - no ifdef). On first look (just compile test) only OF need ifdef. Say me if there are solution, else I will post hand-verifyed results a bit later.

#!/bin/bash
## (c) Denis Kaganovich
## v6
## grep-pcre required

#BUS="pci"
BUS="\w+"

STR="^(?:static\s+)?(?:const\s+)?struct\s+"

_sed(){
	local n="$1"
	shift
	$diff && sed "${@}" <$i |diff -pruN $i - >>$n.patch
	$fix && $first && {
		first=false
		sed -i "${@}" $i
	}
}

fnd(){
local msg="Fixing:"
$fix || msg="Need to fix:"
grep -Prhl "${STR}${BUS}_device_id\s+" $1 --include="*.c" | while read i ; do
	local bus=`grep -Prho "${STR}${BUS}_device_id.*\s+" $i`
	bus="${bus#*struct }"
	local n="${bus%%[*}"
	n="${n%%=*}"
	n="${n##*device_id }"
	n="${n// }"
	bus="${bus%%_device_id*}"
	grep -Pq "^module_init\s*\(" $i || continue
	grep -q "MODULE_DEVICE_TABLE" $i && continue
	local ii="${i#$1}"
	ii="${ii#/}"

#	case $ii in
#	*/mdio-gpio.c)
#		echo "BROKEN: $bus: $ii"
#		continue
#	;;
#	esac

	bus="${bus%%_*}"
	local BU
	case "$bus" in
	sdio)BU=MMC;;
	*)BU="${bus^^}";;
	esac
	local first=true
	if grep -Prq "^\s*(?:menu)?config\s+$BU(?:\s.*)?$" $1 --include="Kconfig*"; then
		echo "$msg $BU: ($n) $ii"
		_sed $BU -e 's/^\(module_init.*\)$/\n#ifdef CONFIG_'"$BU"'\nMODULE_DEVICE_TABLE('"$bus, $n"');\n#endif\n\n\1/'
		$diff || continue
	fi
	echo "$msg $bus: ($n) $ii"
	_sed $bus -e 's/^\(module_init.*\)$/\nMODULE_DEVICE_TABLE('"$bus, $n"');\n\n\1/'
done
}

p=""
fix=false
diff=false
while [[ -n "$*" ]]; do
	case "$1" in
	--fix)fix=true;;
	--diff)diff=true;;
	*)p="$p $1";;
	esac
	shift
done
[[ -z "$p" ]] && echo "$0 [--fix] <path_to_kernel>
(grep+pcre required)" && exit 1

fnd $p

