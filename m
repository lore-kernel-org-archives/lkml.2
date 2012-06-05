Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034Ab2FEIMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 04:12:19 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:45220 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755114Ab2FEIMQ convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Tue, 5 Jun 2012 04:12:16 -0400
Message-Id: <4FCDDB7D0200007800088390@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 05 Jun 2012 09:12:13 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Don Zickus" <dzickus@redhat.com>
Cc: <x86@kernel.org>, "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86,nmi: Fix section mismatch warnings on 32-bit
References: <1338839763-11140-1-git-send-email-dzickus@redhat.com>
In-Reply-To: <1338839763-11140-1-git-send-email-dzickus@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 04.06.12 at 21:56, Don Zickus <dzickus@redhat.com> wrote:
> It was reported that compiling for 32-bit caused a bunch of section
> mismatch warnings:
> 
>  VDSOSYM arch/x86/vdso/vdso32-syms.lds
>   LD      arch/x86/vdso/built-in.o
>   LD      arch/x86/built-in.o
> WARNING: arch/x86/built-in.o(.data+0x5af0): Section mismatch in reference 
> from the variable
> test_nmi_ipi_callback_na.10451 to the function 

Did you check what this (compiler introduced) variable actually
represents? The problem clearly is that the compiler has no way
of knowing that data it generates referencing an __init function
would actually need to go into .init.data or alike.

But otoh maybe the compiler is trying to be too clever, and
should instead avoid inventing variables?

If we start with working around compiler behavior like this
(assuming that it's valid in the first place), we may well end
up having to discard the entire __init/__initdata etc logic.

> .init.text:test_nmi_ipi_callback()
> The variable test_nmi_ipi_callback_na.10451 references
> the function __init test_nmi_ipi_callback()
> If the reference is valid then annotate the
> variable with __init* or __refdata (see linux/init.h) or name the variable:
> *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console
> 
> WARNING: arch/x86/built-in.o(.data+0x5b04): Section mismatch in reference 
> from the variable
> nmi_unk_cb_na.10399 to the function .init.text:nmi_unk_cb()
> The variable nmi_unk_cb_na.10399 references
> the function __init nmi_unk_cb()
> If the reference is valid then annotate the
> variable with __init* or __refdata (see linux/init.h) or name the variable:
> *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console
> 
> Both of these are attributed to the callback functions of this self 
> contained
> test.  It seems this happened when the function added new __init sections in
> commit f0ba662.
> 
> I fixed this by converting the callback functions from __init to __ref.  The 
> file compiles and boots on my machine for 32-bit and 64-bit.
> 
> Not sure why 64-bit never showed this warning.  Nor am I entirely sure why 
> this warning popped up to begin with.

So before applying a change like this, I'd really like to understand
the issue itself. Could you simply attach the nmi_selftest.o file
that you get without your patch here (and indicate which
upstream version or revision the corresponding source file was
from, to be able to re-construct what the compiler actually did)?

Jan

> Let me know if there is a better way to fix this.
> 
> Reported-by: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
> Cc: Jan Beulich <JBeulich@suse.com>
> Signed-off-by: Don Zickus <dzickus@redhat.com>
> ---
>  arch/x86/kernel/nmi_selftest.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/nmi_selftest.c b/arch/x86/kernel/nmi_selftest.c
> index e31bf8d..692e453 100644
> --- a/arch/x86/kernel/nmi_selftest.c
> +++ b/arch/x86/kernel/nmi_selftest.c
> @@ -33,7 +33,7 @@ static int __initdata expected_testcase_failures;
>  static int __initdata unexpected_testcase_failures;
>  static int __initdata unexpected_testcase_unknowns;
>  
> -static int __init nmi_unk_cb(unsigned int val, struct pt_regs *regs)
> +static int __ref nmi_unk_cb(unsigned int val, struct pt_regs *regs)
>  {
>  	unexpected_testcase_unknowns++;
>  	return NMI_HANDLED;
> @@ -50,7 +50,7 @@ static void __init cleanup_nmi_testsuite(void)
>  	unregister_nmi_handler(NMI_UNKNOWN, "nmi_selftest_unk");
>  }
>  
> -static int __init test_nmi_ipi_callback(unsigned int val, struct pt_regs 
> *regs)
> +static int __ref test_nmi_ipi_callback(unsigned int val, struct pt_regs 
> *regs)
>  {
>          int cpu = raw_smp_processor_id();
>  
> -- 
> 1.7.7.6



