Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab2JCNXB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 09:23:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:43438 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185Ab2JCNW7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 09:22:59 -0400
Message-ID: <1349270537.7780.47.camel@twins>
Subject: Re: [PATCHv4] perf x86_64: Fix rsp register for system call fast
 path
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>
Date: Wed, 03 Oct 2012 15:22:17 +0200
In-Reply-To: <20121003131344.GC945@krava.brq.redhat.com>
References: <1349112712-2590-1-git-send-email-jolsa@redhat.com>
	 <1349174644.7780.23.camel@twins>
	 <20121002145815.GH6379@krava.brq.redhat.com>
	 <20121002154914.GC10605@somewhere>
	 <20121002160626.GA26598@krava.brq.redhat.com>
	 <20121002161633.GF10605@somewhere>
	 <20121003122947.GB945@krava.brq.redhat.com>
	 <20121003123448.GA637@somewhere>
	 <20121003131344.GC945@krava.brq.redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-03 at 15:13 +0200, Jiri Olsa wrote:
> @@ -1190,8 +1191,8 @@ static inline void perf_sample_data_init(struct
> perf_sample_data *data,
>         data->raw  = NULL;
>         data->br_stack = NULL;
>         data->period = period;
> -       data->regs_user.abi = PERF_SAMPLE_REGS_ABI_NONE;
> -       data->regs_user.regs = NULL;
> +       /* Sets abi to PERF_SAMPLE_REGS_ABI_NONE. */
> +       memset(&data->regs_user, 0, sizeof(data->regs_user));
>         data->stack_user_size = 0;
>  } 

Hmm, this will slow down all events, regardless of whether they use any
of that stuff or not. Since the one user actually does something like:

  data->regs_user = *pt_regs;

except it does a memcpy() for some obscure reason, it really doesn't
matter what is in there when uninitialized, right?
