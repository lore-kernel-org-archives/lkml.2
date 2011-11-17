Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746Ab1KQXFw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 18:05:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40584 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab1KQXFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 18:05:51 -0500
Date: Thu, 17 Nov 2011 15:05:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrei Warkentin <andreiw@vmware.com>
Cc: linux-kernel@vger.kernel.org, Rolf Eike Beer <eike-kernel@sf-tec.de>,
        opensuse-kernel@opensuse.org, Sergiu Iordache <sergiu@chromium.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Eddie Wai <eddie.wai@broadcom.com>,
        Jayamohan Kallickal <jayamohan.kallickal@emulex.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] include/log2.h: Fix rounddown_pow_of_two(1)
Message-Id: <20111117150549.15528e81.akpm@linux-foundation.org>
In-Reply-To: <1321473366-31053-1-git-send-email-andreiw@vmware.com>
References: <1321473366-31053-1-git-send-email-andreiw@vmware.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Nov 2011 14:56:06 -0500
Andrei Warkentin <andreiw@vmware.com> wrote:

> 1 is a power of two, therefore rounddown_pow_of_two(1) should return 1. It does
> in case the argument is a variable but in case it's a constant it behaves
> wrong and returns 0. Probably nobody ever did it so this was never noticed,
> however net/drivers/vmxnet3 with latest GCC does and breaks on unicpu systems.
> 
> This is similar to Rolf's patch to roundup_pow_of_two(1).
> 
> Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>
> Cc: opensuse-kernel@opensuse.org
> Reviewed-by: Jesper Juhl <jj@chaosbits.net>
> Signed-off-by: Andrei Warkentin <andreiw@vmware.com>
> ---
>  include/linux/log2.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/log2.h b/include/linux/log2.h
> index 25b8086..ccda848 100644
> --- a/include/linux/log2.h
> +++ b/include/linux/log2.h
> @@ -185,7 +185,7 @@ unsigned long __rounddown_pow_of_two(unsigned long n)
>  #define rounddown_pow_of_two(n)			\
>  (						\
>  	__builtin_constant_p(n) ? (		\
> -		(n == 1) ? 0 :			\
> +		(n == 1) ? 1 :			\
>  		(1UL << ilog2(n))) :		\
>  	__rounddown_pow_of_two(n)		\
>   )

I assume that nobody has gone off and checked whether all current
callers will survive this change.  If they had, they'd have looked in
drivers/char/ramoops.c and seen:

	rounddown_pow_of_two(pdata->mem_size);
	rounddown_pow_of_two(pdata->record_size);

These operations are no-ops.  It should be

	pdata->mem_size = rounddown_pow_of_two(pdata->mem_size);
	pdata->record_size = rounddown_pow_of_two(pdata->record_size);

Marco or Sergio: please fix, test and send it over sometime?


drivers/scsi/bnx2i/bnx2i_hwi.c does

                if (!is_power_of_2(hba->max_sqes))
                        hba->max_sqes = rounddown_pow_of_two(hba->max_sqes);

                if (!is_power_of_2(hba->max_rqes))
                        hba->max_rqes = rounddown_pow_of_two(hba->max_rqes);


Both the "if" statements can and should be removed.  I would blame upon
inadequate documentation of rounddown_pow_of_two().


drivers/scsi/be2iscsi/be_main.c does

	if (curr_alloc_size - rounddown_pow_of_two(curr_alloc_size))
		curr_alloc_size = rounddown_pow_of_two(curr_alloc_size);

which is a strange way of doing

	if (!is_power_of_2(curr_alloc_size))
		curr_alloc_size = rounddown_pow_of_two(curr_alloc_size);

which is equivalent to doing

	curr_alloc_size = rounddown_pow_of_two(curr_alloc_size);

but there's an `else' clause to that `if' which I am presently finding
incomprehensible.


drivers/mmc/host/sh_mmcif.c unnecessarily uses __rounddown_pow_of_two()
then feeds the result into ilog2() in an apparent attempt to
reimplement fls().



That we have this many warts using these interfaces is an indication
that the interfaces aren't very good.  Poorly documented, at least.

