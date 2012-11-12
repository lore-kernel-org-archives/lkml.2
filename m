Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab2KLVgj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 16:36:39 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:49045 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828Ab2KLVgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 16:36:35 -0500
Message-ID: <50A16BD3.5010707@us.ibm.com>
Date: Mon, 12 Nov 2012 13:36:19 -0800
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Mike Frysinger <vapier@gentoo.org>, Mikael Starvik <starvik@axis.com>,
        Hirokazu Takata <takata@linux-m32r.org>
Subject: Re: [PATCH V2 2/11] time: convert arch_gettimeoffset to a pointer
References: <1352753462-2915-1-git-send-email-swarren@wwwdotorg.org>
In-Reply-To: <1352753462-2915-1-git-send-email-swarren@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12111221-7182-0000-0000-00000329BFE5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2012 12:51 PM, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
>
> Currently, whenever CONFIG_ARCH_USES_GETTIMEOFFSET is enabled, each
> arch core provides a single implementation of arch_gettimeoffset(). In
> many cases, different sub-architectures, different machines, or
> different timer providers exist, and so the arch ends up implementing
> arch_gettimeoffset() as a call-through-pointer anyway. Examples are
> ARM, Cris, M68K, and it's arguable that the remaining architectures,
> M32R and Blackfin, should be doing this anyway.
>
> Modify arch_gettimeoffset so that it itself is a function pointer, which
> the arch initializes. This will allow later changes to move the
> initialization of this function into individual machine support or timer
> drivers. This is particularly useful for code in drivers/clocksource
> which should rely on an arch-independant mechanism to register their
> implementation of arch_gettimeoffset().
>
> This patch also converts the Cris architecture to set arch_gettimeoffset
> directly to the final implementation in time_init(), because Cris already
> had separate time_init() functions per sub-architecture. M68K and ARM
> are converted to set arch_gettimeoffset the final implementation in later
> patches, because they already have function pointers in place for this
> purpose.
>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Mike Frysinger <vapier@gentoo.org>
> Cc: Mikael Starvik <starvik@axis.com>
> Cc: Hirokazu Takata <takata@linux-m32r.org>
> Cc: John Stultz <johnstul@us.ibm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
> v2:
> * s/gettimeoffset/get_arch_timeoffset/ to make the name less generic
>    and more arch-specific.
>
> (Note: I've only reposted patch 2/11 this time around, and I still hope
> to take it through the arm-soc tree due to dependencies, so I'm not
> requesting this be applied by the timekeeping maintainers)

One last thing to watch out for: If you're trying to build a kernel that 
mixes clocksource support with get_arch_timeoffset, you'll need to 
rework the #ifdef in update_wall_time(), since we currently assume with 
get_arch_timeoffset() that you're using tick + interpolation, so every 
call to update_wall_time() only moves time forward by one jiffy.

Otherwise, thanks for the name tweak. Going through the arm-soc tree is 
fine with me.

Acked-by: John Stultz <johnstul@us.ibm.com>

thanks
-john

