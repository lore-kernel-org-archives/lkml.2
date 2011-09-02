Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719Ab1IBUDH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 16:03:07 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63077 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755441Ab1IBUDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 16:03:04 -0400
Date: Fri, 2 Sep 2011 17:02:55 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, peterz@infradead.org, fweisbec@gmail.com,
        paulus@samba.org, tglx@linutronix.de, anton@samba.org
Subject: Re: [PATCH] perf tool: fix endianness handling of u32 data in samples
Message-ID: <20110902200255.GG17970@ghostprotocols.net>
References: <1314992511-1235-1-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314992511-1235-1-git-send-email-dsahern@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Sep 02, 2011 at 01:41:51PM -0600, David Ahern escreveu:
> @@ -423,18 +449,25 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
>  	}
>  
>  	if (type & PERF_SAMPLE_RAW) {
> -		u32 *p = (u32 *)array;
> +		u.val64 = *array;
> +		if (swapped) {
> +			/* undo swap of u64, then swap on individual u32s */
> +			u.val64 = bswap_64(u.val64);
> +			u.val32[0] = bswap_32(u.val32[0]);
> +			u.val32[1] = bswap_32(u.val32[1]);
> +
> +			WARN_ONCE(swapped, "Endianness of raw data not corrected!\n");
> +		}

That works too, but then we'll be always testing swapped two times :-)

- Arnaldo
