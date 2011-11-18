Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797Ab1KRWRI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 17:17:08 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:53805 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756249Ab1KRWRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 17:17:06 -0500
Date: Fri, 18 Nov 2011 14:15:58 -0800
From: Matt Helsley <matthltc@us.ibm.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, kbuild@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, "H.J. Lu" <hjl.tools@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Michal Marek <mmarek@suse.cz>,
        Sam Ravnborg <sam@ravnborg.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 6/8] x86: Machine-readable syscall tables and scripts to
 process them
Message-ID: <20111118221558.GA6408@count0.beaverton.ibm.com>
References: <1321569446-20433-1-git-send-email-hpa@linux.intel.com>
 <1321569446-20433-7-git-send-email-hpa@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321569446-20433-7-git-send-email-hpa@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11111822-5930-0000-0000-000001E9DD54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 02:37:24PM -0800, H. Peter Anvin wrote:

<snip>

> diff --git a/arch/x86/syscalls/syscallhdr.sh b/arch/x86/syscalls/syscallhdr.sh
> new file mode 100644
> index 0000000..0d473ff
> --- /dev/null
> +++ b/arch/x86/syscalls/syscallhdr.sh
> @@ -0,0 +1,36 @@
> +#!/bin/sh
> +
> +in="$1"
> +out="$2"
> +my_abis=`echo "$3" | tr ',' ' '`

I think you can remove in_list() and just use grep to get your
selected abis:

my_abis=`echo "($3)" | tr ',' '|'`

> +prefix="$4"
> +offset="$5"
> +
> +fileguard=_ASM_X86_`basename "$out" | sed \
> +    -e 'y/abcdefghijklmnopqrstuvwxyz/ABCDEFGHIJKLMNOPQRSTUVWXYZ/' \
> +    -e 's/[^A-Z0-9_]/_/g' -e 's/__/_/g'`
> +
> +in_list () {
> +    local x
> +    for x in $1; do
> +	if [ x"$x" = x"$2" ]; then
> +	    return 0
> +	fi
> +    done
> +    return 1
> +}
> +
> +grep '^[0-9]' "$in" | sort -n | (

grep "^[0-9]$my_abis" "$in" | sort -n | (

> +    echo "#ifndef ${fileguard}"
> +    echo "#define ${fileguard} 1"
> +    echo ""
> +
> +    while read nr abi name entry ; do
> +	if in_list "$my_abis" "$abi"; then
> +	    echo "#define __NR_${prefix}${name}" $((nr+offset))
> +        fi

nanoscale nit: whitespace

> +    done

And finally this becomes:

while read nr abi name entry ; do
    echo "#define __NR_${prefix}${name}" $((nr+offset))
done

