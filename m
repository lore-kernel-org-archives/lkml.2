Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650Ab0EKBrN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 21:47:13 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:40239 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756794Ab0EKBrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 21:47:08 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: cpumask: fix compat getaffinity
Cc: kosaki.motohiro@jp.fujitsu.com, Arnd Bergmann <arnd@arndb.de>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Andi Kleen <andi@firstfloor.org>, Ken Werner <ken.werner@web.de>
In-Reply-To: <201005110913.49162.rusty@rustcorp.com.au>
References: <201005081111.08720.arnd@arndb.de> <201005110913.49162.rusty@rustcorp.com.au>
Message-Id: <20100511104334.E572.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 11 May 2010 10:47:03 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> How's this?
> 
> cpumask: use nr_cpu_ids for printing and parsing cpumasks
> 
> Commit a45185d2d "cpumask: convert kernel/compat.c" broke
> libnuma, which abuses sched_getaffinity to find out NR_CPUS
> in order to parse /sys/devices/system/node/node*/cpumap.
> 
> However, the result now returned reflects nr_cpu_ids, and
> cpumask_scnprintf et al. use nr_cpumask_bits which is NR_CPUS (for
> CONFIG_CPUMASK_OFFSTACK=n) or nr_cpu_ids (for
> CONFIG_CPUMASK_OFFSTACK=y).
> 
> We should use nr_cpu_ids consistently.
>
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Cc: stable@kernel.org

Well, This patch seems to have ABI change. please don't send abi-change to -stable.

note: I'm not against this patch itself.


> 
> diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
> --- a/include/linux/cpumask.h
> +++ b/include/linux/cpumask.h
> @@ -529,7 +529,7 @@ static inline void cpumask_copy(struct c
>  static inline int cpumask_scnprintf(char *buf, int len,
>  				    const struct cpumask *srcp)
>  {
> -	return bitmap_scnprintf(buf, len, cpumask_bits(srcp), nr_cpumask_bits);
> +	return bitmap_scnprintf(buf, len, cpumask_bits(srcp), nr_cpu_ids);
>  }
>  
>  /**
> @@ -543,7 +543,7 @@ static inline int cpumask_scnprintf(char
>  static inline int cpumask_parse_user(const char __user *buf, int len,
>  				     struct cpumask *dstp)
>  {
> -	return bitmap_parse_user(buf, len, cpumask_bits(dstp), nr_cpumask_bits);
> +	return bitmap_parse_user(buf, len, cpumask_bits(dstp), nr_cpu_ids);
>  }
>  
>  /**
> @@ -558,8 +558,7 @@ static inline int cpumask_parse_user(con
>  static inline int cpulist_scnprintf(char *buf, int len,
>  				    const struct cpumask *srcp)
>  {
> -	return bitmap_scnlistprintf(buf, len, cpumask_bits(srcp),
> -				    nr_cpumask_bits);
> +	return bitmap_scnlistprintf(buf, len, cpumask_bits(srcp), nr_cpu_ids);
>  }
>  
>  /**
> @@ -572,7 +571,7 @@ static inline int cpulist_scnprintf(char
>   */
>  static inline int cpulist_parse(const char *buf, struct cpumask *dstp)
>  {
> -	return bitmap_parselist(buf, cpumask_bits(dstp), nr_cpumask_bits);
> +	return bitmap_parselist(buf, cpumask_bits(dstp), nr_cpu_ids);
>  }
>  
>  /**
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



