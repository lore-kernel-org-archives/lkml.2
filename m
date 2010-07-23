Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760195Ab0GWRsX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 13:48:23 -0400
Received: from mail.perches.com ([173.55.12.10]:2069 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756586Ab0GWRsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 13:48:20 -0400
Subject: Re: [patch -next] ath5k: snprintf() returns largish values
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <error27@gmail.com>
Cc: Bruno Randolf <br1@einfach.org>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Jiri Slaby <jirislaby@gmail.com>, Bob Copeland <me@bobcopeland.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100723095252.GA26313@bicker>
References: <20100722085202.GV17585@bicker>
	 <201007231744.14922.br1@einfach.org>  <20100723095252.GA26313@bicker>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Jul 2010 10:48:17 -0700
Message-ID: <1279907297.24768.1678.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-23 at 12:04 +0200, Dan Carpenter wrote:
> This is a smatch thing.  I suppose someday I will fix smatch to
> evaulate the strings themselves and verify that the buffer is large
> enough.  But for now it's nice to be able to automatically check that
> the buffers don't overflow.  

There are also many repeated uses of snprintf in kernel sources
that could similarly be a problem.

	bar += snprintf(foo + bar, ...)
	bar += snprintf(foo + bar, ...)
or
	foo += snprintf(foo, ...)
	foo += snprintf(foo, ...)

For instance:

$ grep -P -n -A 4 -m 3 "\+=\s*snprintf" drivers/net/wireless/ath/ath5k/debug.c
210:	len += snprintf(buf+len, sizeof(buf)-len,
211-		"%-24s0x%08x\tintval: %d\tTIM: 0x%x\n",
212-		"AR5K_BEACON", v, v & AR5K_BEACON_PERIOD,
213-		(v & AR5K_BEACON_TIM) >> AR5K_BEACON_TIM_S);
214-
215:	len += snprintf(buf+len, sizeof(buf)-len, "%-24s0x%08x\n",
216-		"AR5K_LAST_TSTP", ath5k_hw_reg_read(sc->ah, AR5K_LAST_TSTP));
217-
218:	len += snprintf(buf+len, sizeof(buf)-len, "%-24s0x%08x\n\n",
219-		"AR5K_BEACON_CNT", ath5k_hw_reg_read(sc->ah, AR5K_BEACON_CNT));
220-

A conversion from snprintf to scnprintf might be appropriate
for those patterns.

