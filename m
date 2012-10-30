Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759578Ab2J3PFV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 11:05:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12594 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527Ab2J3PFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 11:05:19 -0400
X-Authority-Analysis: v=2.0 cv=NLdXCjGg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=V3PaAaPhDywA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=MpoW4NFLMuQA:10 a=r_1tXGB3AAAA:8 a=XsRqRBKgiBNC042Nv44A:9 a=PUjeQqilurYA:10 a=EDSpbFuiShEA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1351609517.8467.85.camel@gandalf.local.home>
Subject: Re: [PATCH] scripts/recordmcount.pl: Support build with
 -ffunction-sections.
From: Steven Rostedt <rostedt@goodmis.org>
To: Will Newton <will.newton@gmail.com>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Tue, 30 Oct 2012 11:05:17 -0400
In-Reply-To: <CAFbHwiRtBaHkpZqTm6VZ=fCJcyu+dsdpo_kxMHy1egce=rTuyA@mail.gmail.com>
References: <CAFbHwiRtBaHkpZqTm6VZ=fCJcyu+dsdpo_kxMHy1egce=rTuyA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-30 at 14:51 +0000, Will Newton wrote:
> Scan any text section whose name begins with ".text." so
> we will find all the functions in a kernel built with
> -ffunction-sections.

A couple of things.

First, I'm very paranoid about a blanket "ok" on sections. We must
guarantee that all sections that starts with ".text" never is freed. And
if it is freed, that it must inform ftrace that it's about to free it
before it does. If we can not guarantee this, then we can't do it.

Second, most archs today do not use recordmcount.pl. They use the new
recordmcount.c file.

-- Steve

> 
> Signed-off-by: Will Newton <will.newton@imgtec.com>
> ---
>  scripts/recordmcount.pl |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
> index b33446c..89461c4 100755
> --- a/scripts/recordmcount.pl
> +++ b/scripts/recordmcount.pl
> @@ -135,9 +135,13 @@ my %text_sections = (
>       ".spinlock.text" => 1,
>       ".irqentry.text" => 1,
>       ".kprobes.text" => 1,
> -     ".text.unlikely" => 1,
>  );
> 
> +sub is_valid_section
> +{
> +    return defined($text_sections{$1}) || $1 =~ m/^\.text\./;
> +}
> +
>  # Note: we are nice to C-programmers here, thus we skip the '||='-idiom.
>  $objdump = 'objdump' if (!$objdump);
>  $objcopy = 'objcopy' if (!$objcopy);
> @@ -502,7 +506,7 @@ while (<IN>) {
>  	$read_headers = 0;
> 
>  	# Only record text sections that we know are safe
> -	$read_function = defined($text_sections{$1});
> +	$read_function = is_valid_section($1);
>  	# print out any recorded offsets
>  	update_funcs();
> 


