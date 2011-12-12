Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378Ab1LLXKx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 18:10:53 -0500
Received: from cdptpa-bc-oedgelb.mail.rr.com ([75.180.133.32]:33305 "EHLO
	cdptpa-bc-oedgelb.mail.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752765Ab1LLXKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 18:10:50 -0500
Authentication-Results: cdptpa-bc-oedgelb.mail.rr.com smtp.user=rpearson@systemfabricworks.com; auth=pass (LOGIN)
X-Authority-Analysis: v=2.0 cv=NJpXCjGg c=1 sm=0 a=7U2oT3z54tbHUG4/vyWVBw==:17 a=mXccnhe_cfsA:10 a=ozIaqLvjkoIA:10 a=kj9zAlcOel0A:10 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8 a=B_v9yzLCQeNa7XhVUvkA:9 a=PP8C4Xu-z_kaIxVF0u0A:7 a=CjuIK1q_8ugA:10 a=sYFsTtuSgLM4OlmY:21 a=U0lsNp7LUs7OD5rr:21 a=7U2oT3z54tbHUG4/vyWVBw==:117
X-Cloudmark-Score: 0
X-Originating-IP: 64.134.157.105
From: "Bob Pearson" <rpearson@systemfabricworks.com>
To: <djwong@us.ibm.com>, "'Herbert Xu'" <herbert@gondor.hengli.com.au>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Theodore Tso'" <tytso@mit.edu>,
        "'Joakim Tjernlund'" <joakim.tjernlund@transmode.se>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'Andreas Dilger'" <adilger.kernel@dilger.ca>,
        "'linux-crypto'" <linux-crypto@vger.kernel.org>,
        "'linux-fsdevel'" <linux-fsdevel@vger.kernel.org>,
        "'Mingming Cao'" <cmm@us.ibm.com>, <linux-ext4@vger.kernel.org>
References: <20111201201341.5876.83743.stgit@elm3c44.beaverton.ibm.com> <20111201201517.5876.39207.stgit@elm3c44.beaverton.ibm.com> <20111202002505.GB19842@gondor.apana.org.au> <20111203023646.GB16577@tux1.beaverton.ibm.com> <20111212225857.GM7137@tux1.beaverton.ibm.com>
In-Reply-To: <20111212225857.GM7137@tux1.beaverton.ibm.com>
Subject: RE: [PATCH 14/14] crc32: Select an algorithm via kconfig
Date: Mon, 12 Dec 2011 17:10:45 -0600
Message-ID: <02ea01ccb923$48193ff0$d84bbfd0$@systemfabricworks.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQIhSfLZfbg3NjKDloxa89FoxpUzpAKwiovlAdUNqLkCTzOuIAJkGy/HlOXq7wA=
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That choice was for Joakim who measured better performance on his 32 bit PPC
platform with "by 4".

> -----Original Message-----
> From: Darrick J. Wong [mailto:djwong@us.ibm.com]
> Sent: Monday, December 12, 2011 4:59 PM
> To: Herbert Xu; Bob Pearson
> Cc: Andrew Morton; Theodore Tso; Joakim Tjernlund; linux-kernel; Andreas
> Dilger; linux-crypto; linux-fsdevel; Mingming Cao;
linux-ext4@vger.kernel.org
> Subject: Re: [PATCH 14/14] crc32: Select an algorithm via kconfig
> 
> On Fri, Dec 02, 2011 at 06:36:46PM -0800, Darrick J. Wong wrote:
> > On Fri, Dec 02, 2011 at 08:25:05AM +0800, Herbert Xu wrote:
> > > On Thu, Dec 01, 2011 at 12:15:17PM -0800, Darrick J. Wong wrote:
> > > > Allow the kernel builder to choose a crc32* algorithm for the
kernel.
> > > >
> > > > Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> > >
> > > I don't like this at all.  How do you expect distros or indeed
> > > anyone to make this choice? For generic C implementations like
> > > this we should only have one, and not many.
> >
> > Slice-by-8 should be picked automatically if the builder doesn't
explicitly
> > pick another one.  The other choices are provided for people who want a
> slimmer
> > cache footprint.  I guess I could make the Kconfig file a bit more
explicit
> > about slice-by-8 being default, or I guess we could just ignore this one
> patch
> > and thereby keeping us with the old method where anyone who wants the
> slimmer
> > implementations patches the #defines.
> 
> Ok, here's a patch that makes it more explicit that sliceby8 is the
default.
> I expect distros and anyone else to simply hit <Enter>.  The only people
who
> should do otherwise are people who know they are building for machines
> that
> have small cache sizes such that the crc table fights for cache lines with
the
> data being checksummed.
> 
> I made a quick survey of CPU L1 cache quantities:
> 
> All Intel CPUs since the Pentium MMX have > 8KiB of L1.
> All AMD CPUs since the K5 have had > 8KiB of L1.
> Most SPARC64 CPUs except the UltraSparc T1 and T2 CPUs have > 8KiB of L1.
> Most PowerPC CPUs since the 601 seem to have > 8KiB of L1.
> All IBM POWER CPUs since at least the POWER2 have had > 8KiB of L1.
> There are too many different ARM cores for me to track.   My smartphones
> and
> embedded ARM controllers all have > 8KIB of L1, but that's not enough to
> generalize.
> 
> While I might've been tempted to agree with Herbert and hardwire the code
> to
> use slice by 8, there are enough CPUs out there that *could* have
too-small
> L1
> caches that I'm not comfortable with _removing_ the Kconfig option to use
a
> slimmer algorithm.  I can't gate the decision on 64-bitness either, since
I've
> seen plenty of i386 CPUs that benefit from slice by 8, and the UltraSparc
T2 is
> a 64-bit processor that seems likely to suffer cache thrashing.
> 
> I think having a configurable menu that steers people towards slice by 8
is
> fine.  Bob, was there a reason for picking slice by 4 for 32-bit machines?
> 
> D
> ---
> Allow the kernel builder to choose a crc32* algorithm for the kernel.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> 
>  lib/Kconfig     |   43 +++++++++++++++++++++++++++++++++++++++++++
>  lib/crc32defs.h |   18 ++++++++++++++++++
>  2 files changed, 61 insertions(+), 0 deletions(-)
> 
> diff --git a/lib/Kconfig b/lib/Kconfig
> index cfddafc..029c0e3 100644
> --- a/lib/Kconfig
> +++ b/lib/Kconfig
> @@ -70,6 +70,49 @@ config CRC32_SELFTEST
>  	  and crc32_be over byte strings with random alignment and length
>  	  and computes the total elapsed time and number of bytes
> processed.
> 
> +choice
> +	prompt "CRC32 implementation"
> +	depends on CRC32
> +	default CRC32_SLICEBY8
> +
> +config CRC32_SLICEBY8
> +	bool "Slice by 8 bytes"
> +	help
> +	  Calculate checksum 8 bytes at a time with a clever slicing
algorithm.
> +	  This is the fastest algorithm, but comes with a 8KiB lookup table.
> +	  Most modern processors have enough cache to hold this table
> without
> +	  thrashing the cache.
> +
> +	  This is the default implementation choice.  Choose this one unless
> +	  you have a good reason not to.
> +
> +config CRC32_SLICEBY4
> +	bool "Slice by 4 bytes"
> +	help
> +	  Calculate checksum 4 bytes at a time with a clever slicing
algorithm.
> +	  This is a bit slower than slice by 8, but has a smaller 4KiB
lookup
> +	  table.
> +
> +	  Only choose this option if you know what you are doing.
> +
> +config CRC32_SARWATE
> +	bool "Sarwate's Algorithm (one byte at a time)"
> +	help
> +	  Calculate checksum a byte at a time using Sarwate's algorithm.
This
> +	  is not particularly fast, but has a small 256 byte lookup table.
> +
> +	  Only choose this option if you know what you are doing.
> +
> +config CRC32_BIT
> +	bool "Classic Algorithm (one bit at a time)"
> +	help
> +	  Calculate checksum one bit at a time.  This is VERY slow, but has
> +	  no lookup table.  This is provided as a debugging option.
> +
> +	  Only choose this option if you are debugging crc32.
> +
> +endchoice
> +
>  config CRC7
>  	tristate "CRC7 functions"
>  	help
> diff --git a/lib/crc32defs.h b/lib/crc32defs.h
> index 6fd1917..64cba2c 100644
> --- a/lib/crc32defs.h
> +++ b/lib/crc32defs.h
> @@ -13,6 +13,24 @@
>   */
>  #define CRC32C_POLY_LE 0x82F63B78
> 
> +/* Try to choose an implementation variant via Kconfig */
> +#ifdef CONFIG_CRC32_SLICEBY8
> +# define CRC_LE_BITS 64
> +# define CRC_BE_BITS 64
> +#endif
> +#ifdef CONFIG_CRC32_SLICEBY4
> +# define CRC_LE_BITS 32
> +# define CRC_BE_BITS 32
> +#endif
> +#ifdef CONFIG_CRC32_SARWATE
> +# define CRC_LE_BITS 8
> +# define CRC_BE_BITS 8
> +#endif
> +#ifdef CONFIG_CRC32_BIT
> +# define CRC_LE_BITS 1
> +# define CRC_BE_BITS 1
> +#endif
> +
>  /*
>   * How many bits at a time to use.  Valid values are 1, 2, 4, 8, 32 and
64.
>   * For less performance-sensitive, use 4 or 8 to save table size.

