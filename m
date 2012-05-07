Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757174Ab2EGQPP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 12:15:15 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45240 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756665Ab2EGQPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 12:15:14 -0400
Message-ID: <4FA7F50D.1060906@gmail.com>
Date: Mon, 07 May 2012 10:15:09 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] perf, tool: Fix endianity trick for adds_features
 bitmask
References: <1336390149-2970-1-git-send-email-jolsa@redhat.com> <1336390149-2970-6-git-send-email-jolsa@redhat.com>
In-Reply-To: <1336390149-2970-6-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/7/12 5:29 AM, Jiri Olsa wrote:
> Addons bitmask is stored as array of unsigned long values. The size
> of the unsigned long is same as pointer size for architecture, so it
> could differ for each architecture.
>
> To handle the endianity for adds_features bitmask, we first swap the
> bitmaks as u64 values and check for HEADER_HOSTNAME bit. If not set we
> want to unswap the u64 values and swap the adds_features as u32 values.
>
> This is currently buggy, since we swap just first 32bits of each u64
> value. Adding swap of the next 32 bits as well.  Also adding&  using
> BITS_TO_U64 instead of BITS_TO_LONGS as counter max due to the different
> size of unsigned longs per architecture.
>
> Note, running following to test perf endianity handling:
>    - origin system:
>      # perf record -a -- sleep 10 (any perf record will do)
>      # perf report>  report.origin
>      # perf archive perf.data
>
>    - copy the perf.data, report.origin and perf.data.tar.bz2
>      to a target system and run:
>      # tar xjvf perf.data.tar.bz2 -C ~/.debug
>      # perf report>  report.target
>      # diff -u report.origin report.target
>
>    - the diff should produce no output
>      (besides some white space stuff and possibly different
>       date/TZ output)

Did you cross bitness and architectures in your test? When I added the 
code you are modifying I verified it worked by analyzing 32-bit PPC 
files on 64-bit x86 and 32-bit x86.

Did you also test old versus new perf commands? perf data collected with 
older command and analyzed with a newer version with this patch? Be sure 
to add the -I switch to get all the processing of the feature mask.

David

>
> Signed-off-by: Jiri Olsa<jolsa@redhat.com>
> ---
>   tools/perf/util/header.c               |   20 +++++++++++++++-----
>   tools/perf/util/include/linux/bitops.h |    1 +
>   2 files changed, 16 insertions(+), 5 deletions(-)
>
> diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> index c0b70c6..a56db7e 100644
> --- a/tools/perf/util/header.c
> +++ b/tools/perf/util/header.c
> @@ -1963,13 +1963,23 @@ int perf_file_header__read(struct perf_file_header *header,
>   		 * file), punt and fallback to the original behavior --
>   		 * clearing all feature bits and setting buildid.
>   		 */
> -		for (i = 0; i<  BITS_TO_LONGS(HEADER_FEAT_BITS); ++i)
> -			header->adds_features[i] = bswap_64(header->adds_features[i]);
> +
> +		mem_bswap_64(&header->adds_features,
> +			     BITS_TO_U64(HEADER_FEAT_BITS));
>
>   		if (!test_bit(HEADER_HOSTNAME, header->adds_features)) {
> -			for (i = 0; i<  BITS_TO_LONGS(HEADER_FEAT_BITS); ++i) {
> -				header->adds_features[i] = bswap_64(header->adds_features[i]);
> -				header->adds_features[i] = bswap_32(header->adds_features[i]);
> +			u64 *v = (u64 *)&header->adds_features;
> +
> +			for (i = 0; i<  BITS_TO_U64(HEADER_FEAT_BITS); ++i) {
> +				union {
> +					u64 val64;
> +					u32 val32[2];
> +				} u;
> +
> +				u.val64 = *v++;
> +				u.val64 = bswap_64(u.val64);
> +				u.val32[0] = bswap_32(u.val32[0]);
> +				u.val32[1] = bswap_32(u.val32[1]);
>   			}
>   		}
>
> diff --git a/tools/perf/util/include/linux/bitops.h b/tools/perf/util/include/linux/bitops.h
> index f1584833..10096cb 100644
> --- a/tools/perf/util/include/linux/bitops.h
> +++ b/tools/perf/util/include/linux/bitops.h
> @@ -8,6 +8,7 @@
>   #define BITS_PER_LONG __WORDSIZE
>   #define BITS_PER_BYTE           8
>   #define BITS_TO_LONGS(nr)       DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(long))
> +#define BITS_TO_U64(nr)         DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(u64))
>
>   #define for_each_set_bit(bit, addr, size) \
>   	for ((bit) = find_first_bit((addr), (size));		\

