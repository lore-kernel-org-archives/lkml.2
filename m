Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896Ab1EQQEF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 12:04:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:51314 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408Ab1EQQED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 12:04:03 -0400
X-Authority-Analysis: v=1.1 cv=NmbQexcdgr4rtO3OwYGrP5Q3rTMpacrTPhuaXkv4uP8= c=1 sm=0 a=UWMw6JNi2FwA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=jPdDbiqNBxnkieFs-lQA:9 a=c9a7DDp1T8GM78utMG0A:7 a=QEXdDO2ut3YA:10 a=MSl-tDqOz04A:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] x86, ftrace: Fix compiler warning in ftrace.c
From: Steven Rostedt <rostedt@goodmis.org>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: hpa@zytor.com, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <1305221620.7986.4.camel@localhost.localdomain>
References: <1305221620.7986.4.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 May 2011 12:04:01 -0400
Message-ID: <1305648241.5456.743.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-12 at 23:33 +0600, Rakib Mullick wrote:
> Due to commit dc326fca2b64 (x86, cpu: Clean up and unify the NOP selection infrastructure), we get the following warning:
> 
> arch/x86/kernel/ftrace.c: In function ‘ftrace_make_nop’:
> arch/x86/kernel/ftrace.c:308:6: warning: assignment discards qualifiers from pointer target type
> arch/x86/kernel/ftrace.c: In function ‘ftrace_make_call’:
> arch/x86/kernel/ftrace.c:318:6: warning: assignment discards qualifiers from pointer target type
>  
> ftrace_nop_replace() now returns const unsigned char *, so change its associated function/variable to its compatible type to keep compiler clam.
> 
> 
> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
> ---
> 
> diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> index 0ba15a6..d2d82cf 100644
> --- a/arch/x86/kernel/ftrace.c
> +++ b/arch/x86/kernel/ftrace.c
> @@ -266,8 +266,8 @@ static const unsigned char *ftrace_nop_replace(void)
>  }
>  
>  static int
> -ftrace_modify_code(unsigned long ip, unsigned char *old_code,
> -		   unsigned char *new_code)
> +ftrace_modify_code(unsigned long ip, unsigned const char *old_code,
> +		   unsigned const char *new_code)
>  {
>  	unsigned char replaced[MCOUNT_INSN_SIZE];
>  
> @@ -290,7 +290,7 @@ ftrace_modify_code(unsigned long ip, unsigned char *old_code,
>  		return -EINVAL;
>  
>  	/* replace the text with the new text */
> -	if (do_ftrace_mod_code(ip, new_code))
> +	if (do_ftrace_mod_code(ip, (void *)new_code))

Instead of typecasting, why not make new_code const void *?

This would probably trickle down to change __probe_kernel_write() which
would not be a bad thing.

-- Steve

>  		return -EPERM;
>  
>  	sync_core();
> @@ -301,7 +301,7 @@ ftrace_modify_code(unsigned long ip, unsigned char *old_code,
>  int ftrace_make_nop(struct module *mod,
>  		    struct dyn_ftrace *rec, unsigned long addr)
>  {
> -	unsigned char *new, *old;
> +	unsigned const char *new, *old;
>  	unsigned long ip = rec->ip;
>  
>  	old = ftrace_call_replace(ip, addr);
> @@ -312,7 +312,7 @@ int ftrace_make_nop(struct module *mod,
>  
>  int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
>  {
> -	unsigned char *new, *old;
> +	unsigned const char *new, *old;
>  	unsigned long ip = rec->ip;
>  
>  	old = ftrace_nop_replace();
> 


