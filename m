Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab1C2GQD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 02:16:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39089 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552Ab1C2GQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 02:16:01 -0400
Date: Tue, 29 Mar 2011 08:15:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andy Lutomirski <luto@MIT.EDU>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/6] x86-64: Don't generate cmov in vread_tsc
Message-ID: <20110329061546.GA27398@elte.hu>
References: <cover.1301324270.git.luto@mit.edu>
 <6921987c30552b781bd96c58451169a6074f2c96.1301324270.git.luto@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6921987c30552b781bd96c58451169a6074f2c96.1301324270.git.luto@mit.edu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andy Lutomirski <luto@MIT.EDU> wrote:

> -	/* This doesn't multiply 'zero' by anything, which *should*
> -	 * generate nicer code, except that gcc cleverly embeds the
> -	 * dereference into the cmp and the cmovae.  Oh, well.
> +	/* This doesn't multiply 'zero' by anything, which generates
> +	 * very slightly nicer code than multiplying it by 8.
>  	 */
>  	last = *( (cycle_t *)
>  		  ((char *)&__vsyscall_gtod_data.clock.cycle_last + zero) );
>  
> -	return ret >= last ? ret : last;
> +	if (likely(ret >= last))
> +		return ret;
> +
> +	/* GCC likes to generate cmov here, but this branch is extremely
> +	   predictable (it's just a funciton of time and the likely is
> +	   very likely) and there's a data dependence, so force GCC
> +	   to generate a branch instead. */
> +	asm volatile ("");

barrier() would do the same, right?

Also, a nit, please use the customary (multi-line) comment style:

  /*
   * Comment .....
   * ...... goes here.
   */

specified in Documentation/CodingStyle.

Thanks,

        Ingo
