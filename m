Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734Ab2EVVqh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 17:46:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25084 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab2EVVqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 17:46:36 -0400
X-Authority-Analysis: v=2.0 cv=OMylLFmB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=wom5GMh1gUkA:10 a=8ShOI8NZQckA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=NKvrZGXA9ZW157HRUsIA:9 a=Y26gPgCbpSZD8nsu_3EA:7 a=CjuIK1q_8ugA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Date: Tue, 22 May 2012 17:46:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Ingo Molnar <mingo@elte.hu>, Masami Hiramatsu <mhiramat@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Use test_and_clear_bit() instead atomic_dec_and_test()
 for stop_machine
Message-ID: <20120522214633.GB30024@home.goodmis.org>
References: <87likkt7u6.fsf@devron.myhome.or.jp>
 <87ehqct7a3.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ehqct7a3.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 03:11:48AM +0900, OGAWA Hirofumi wrote:
> [forgot to Cc: lkml, resend]
> 
> Hi,
> 
> Maybe, nobody using debug patch in atomic_dec_and_test()...  Well,
> anyway, how about this?

What debug patch?

> 
> 
> 
> stop_machine_first is just to see if it is first one or not.  So, there
> is no reason to use atomic_dec_and_test(), and makes the value below 0.
> 
> I think it is not desirable, because this usage only triggers
> atomic_dec_and_test() underflow debug patch. (the patch tests result
> of atomic_dec_and_test() is < 0)

Well it should only underflow if you have a box with more than 2 billion
CPUs.

> 
> So, this uses test_and_clear_bit() instead.
> 
> Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> ---
> 
>  arch/x86/kernel/alternative.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff -puN arch/x86/kernel/alternative.c~stop_machine-use-test_and_set_bit arch/x86/kernel/alternative.c
> --- linux/arch/x86/kernel/alternative.c~stop_machine-use-test_and_set_bit	2012-05-23 02:48:01.000000000 +0900
> +++ linux-hirofumi/arch/x86/kernel/alternative.c	2012-05-23 02:48:01.000000000 +0900
> @@ -650,7 +650,7 @@ void *__kprobes text_poke(void *addr, co
>   * Cross-modifying kernel text with stop_machine().
>   * This code originally comes from immediate value.
>   */
> -static atomic_t stop_machine_first;
> +static unsigned long stop_machine_first;

The down side to this is that it adds 4 more bytes on a 64bit
machine. (sizeof(unsigned log) == 8 and sizeof(atomic_t) == 4)

You could probably also set it to -1, and do a atomic_inc_and_test(),
would that also cause the debug to trigger too?

-- Steve

>  static int wrote_text;
>  
>  struct text_poke_params {
> @@ -664,7 +664,7 @@ static int __kprobes stop_machine_text_p
>  	struct text_poke_param *p;
>  	int i;
>  
> -	if (atomic_dec_and_test(&stop_machine_first)) {
> +	if (test_and_clear_bit(0, &stop_machine_first)) {
>  		for (i = 0; i < tpp->nparams; i++) {
>  			p = &tpp->params[i];
>  			text_poke(p->addr, p->opcode, p->len);
> @@ -714,7 +714,7 @@ void *__kprobes text_poke_smp(void *addr
>  	p.len = len;
>  	tpp.params = &p;
>  	tpp.nparams = 1;
> -	atomic_set(&stop_machine_first, 1);
> +	stop_machine_first = 1;
>  	wrote_text = 0;
>  	/* Use __stop_machine() because the caller already got online_cpus. */
>  	__stop_machine(stop_machine_text_poke, (void *)&tpp, cpu_online_mask);
> @@ -736,7 +736,7 @@ void __kprobes text_poke_smp_batch(struc
>  {
>  	struct text_poke_params tpp = {.params = params, .nparams = n};
>  
> -	atomic_set(&stop_machine_first, 1);
> +	stop_machine_first = 1;
>  	wrote_text = 0;
>  	__stop_machine(stop_machine_text_poke, (void *)&tpp, cpu_online_mask);
>  }
