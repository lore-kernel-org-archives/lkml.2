Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751193Ab0KDM32 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 08:29:28 -0400
Received: from mail.asbjorn.biz ([217.195.185.3]:33689 "EHLO mail.asbjorn.biz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999Ab0KDM31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 08:29:27 -0400
Message-ID: <4CD2A725.7030809@asbjorn.biz>
Date: Thu, 04 Nov 2010 12:29:25 +0000
From: =?ISO-8859-1?Q?Asbj=F8rn_Sloth_T=F8nnesen?= <asbjorn@asbjorn.biz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101030 Icedove/3.0.10
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, debian-kernel@lists.debian.org
Subject: Re: [PATCH] kbuild, deb-pkg: fix Architecture field when cross	compiling
References: <4CD22ACF.1000407@asbjorn.it> <1288842244-6863-1-git-send-email-asbjorn@asbjorn.biz> <20101104055800.GA11781@merkur.ravnborg.org>
In-Reply-To: <20101104055800.GA11781@merkur.ravnborg.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2010 05:58 AM, Sam Ravnborg wrote:
> On Thu, Nov 04, 2010 at 03:44:04AM +0000, Asbjoern Sloth Toennesen wrote:
>> [...]
>> +	# Attempt to find the correct Debian architecture
>> +	local forcearch="" debarch=""
>> +	case "$ARCH" in
>> +	i386|ia64)
>> +		debarch="$ARCH" ;;
>> +	x86_64)
>> +		debarch="amd64" ;;
> 
> On the commandline I can say ARCH=x86 - will it do the right thing then?

No, not if you are cross compiling since ARCH=x86 isn't specific to
either, we would have to look at the config. In that case it is better
to do something like:

x86|i386|x86_64)
	debarch=$(grep -q CONFIG_64BIT=y .config &&
			echo amd64 || echo i386) ;;

>> +	*)
>> +		grep -q CONFIG_ARM=y .config &&
>> +			debarch=arm$(grep -q CONFIG_AEABI=y .config && echo el)
>> +	esac
> 
> sparc may be know as sparc32, sparc64 and sparc these days.
> I recall that at least in the past debian supported sparc.

I only included the major Debian architectures in my patch since, I
don't know enough about all the smaller architectures and there config
dependencies. I have however added mips as it seemed straight forward.

AFAICT there are some problems surrounding sparc, since sparc in debian
uses 64-bit kernels, 32-bit userland, and the new sparc64 port uses
64-kernels and 64-bit userland, so we have no way of knowing if the
64-bit sparc kernel should have the Architecture field set to sparc or
sparc64.

For now I will just set it to sparc, as that is a release candidate for
squeeze, where sparc64 isn't nearly that far along.

sparc*)
	debarch=sparc ;;
mips)
	debarch=mips$(grep -q CPU_LITTLE_ENDIAN && echo el) ;;


I will sum these up in a new revision of the patch, when I get an ack
from Michal or a Debian kernel team member.
