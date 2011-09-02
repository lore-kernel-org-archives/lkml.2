Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517Ab1IBUB7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 16:01:59 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53400 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755306Ab1IBUBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 16:01:55 -0400
Date: Fri, 2 Sep 2011 17:01:47 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, peterz@infradead.org, fweisbec@gmail.com,
        paulus@samba.org, tglx@linutronix.de, anton@samba.org
Subject: Re: [PATCH v2] perf tool: fix endianness handling of u32 data in
 samples
Message-ID: <20110902200147.GF17970@ghostprotocols.net>
References: <1314979426-29356-1-git-send-email-dsahern@gmail.com>
 <20110902181818.GD17970@ghostprotocols.net>
 <4E612A9E.5000807@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E612A9E.5000807@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Sep 02, 2011 at 01:12:30PM -0600, David Ahern escreveu:
> On 09/02/2011 12:18 PM, Arnaldo Carvalho de Melo wrote:
> > Em Fri, Sep 02, 2011 at 10:03:46AM -0600, David Ahern escreveu:
> >>  	if (type & PERF_SAMPLE_RAW) {
> >> -		u32 *p = (u32 *)array;
> >> +		u.val64 = *array;
> >> +		if (swapped) {
> >> +			static bool show_warn = true;
> >> +
> >> +			/* undo swap of u64, then swap on individual u32s */
> >> +			u.val64 = bswap_64(u.val64);
> >> +			u.val32[0] = bswap_32(u.val32[0]);
> >> +			u.val32[1] = bswap_32(u.val32[1]);
> >> +
> >> +			if (show_warn) {
> >> +				pr_warning("Endianness of raw data not corrected!\n");
> >> +				show_warn = false;
> >> +			}
> >> +		}
> > 
> > Can you use WARN_ONCE? Would become:
> > 	
> > 		if (WARN_ONCE(swapped, "Endianness of raw data not corrected!\n")) {
> > 			/* undo swap of u64, then swap on individual u32s */
> > 			u.val64 = bswap_64(u.val64);
> > 			u.val32[0] = bswap_32(u.val32[0]);
> > 			u.val32[1] = bswap_32(u.val32[1]);
> > 		}
> 
> That's not quite what we need. The bswap's happen all the time; the warn
> once is to tell the user one time that samples in the file contain raw
> data and those cannot be programmatically adjusted for endianness.
> 
> ie., more like:
>     WARN_ONCE(swapped, "Endianness of raw data not corrected!\n");
> and no action taken (the 'if (WARN_ONCE())'part).

Look again:

#define WARN_ONCE(condition, format...) ({                      \
        static bool __warned;                                   \
        int __ret_warn_once = !!(condition);                    \
                                                                \
        if (unlikely(__ret_warn_once))                          \
                if (WARN(!__warned, format))                    \
                        __warned = true;                        \
        unlikely(__ret_warn_once);                              \
}) 


See that ({ }) construct? It evaluates to what is in its last statement,
which is...

	unlikely(__ret_warn_once);

Forget about the unlikely, __ret_warn_once is:

	!!condition

I.e. it always evaluates to what is passed as condition, so in fact it
could be seen as:

             if (swapped) {
                     /* undo swap of u64, then swap on individual
                     u32s */
                     u.val64 = bswap_64(u.val64);
                     u.val32[0] = bswap_32(u.val32[0]);
                     u.val32[1] = bswap_32(u.val32[1]);
             }

The rest is the boilerplate needed to warn the user the first time
condition is true.

- Arnaldo
