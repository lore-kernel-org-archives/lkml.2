Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab2E2RSp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 13:18:45 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52356 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386Ab2E2RSo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 13:18:44 -0400
MIME-Version: 1.0
In-Reply-To: <aabb3c7d-1c1a-4558-805a-b6d8478d1494@default>
References: <aabb3c7d-1c1a-4558-805a-b6d8478d1494@default>
Date: Tue, 29 May 2012 10:18:43 -0700
X-Google-Sender-Auth: 8sOnI4FZ6C55wL0YGN59bCkhoUQ
Message-ID: <CAE9FiQV1ckyhy+cWVZC+=rU9s2nrBO6qV0Yt5xkYuv_gS9ZSWQ@mail.gmail.com>
Subject: Re: [PATCH] Fix an overflow in range_to_mtrr func
From: Yinghai Lu <yinghai@kernel.org>
To: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Cc: mingo@redhat.com, x86@kernel.org, tglx@linutronix.de, hpa@zytor.com,
        Feng Jin <joe.jin@oracle.com>, ethan.zhao@oracle.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2012 at 5:29 AM, Zhenzhong Duan
<zhenzhong.duan@oracle.com> wrote:
> When boot x86_64 kernel on sun G5+ with 4T mem, see an overflow in mtrr cleanup as below.
>
> *BAD*gran_size: 2G      chunk_size: 2G  num_reg: 10     lose cover RAM:
> -18014398505283592M
>
> This is because 1<<31 sign extended.
> Use explicit type conversion to force a 64bit constant to fix it.
> Useful for mem larger than or equal to 4T.
>
> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
> ---
>  arch/x86/kernel/cpu/mtrr/cleanup.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/mtrr/cleanup.c b/arch/x86/kernel/cpu/mtrr/cleanup.c
> index ac140c7..853a4c6 100644
> --- a/arch/x86/kernel/cpu/mtrr/cleanup.c
> +++ b/arch/x86/kernel/cpu/mtrr/cleanup.c
> @@ -266,7 +266,7 @@ range_to_mtrr(unsigned int reg, unsigned long range_startk,
>                if (align > max_align)
>                        align = max_align;
>
> -               sizek = 1 << align;
> +               sizek = (unsigned long)1 << align;

how about

            sizek = 1UL << align;


>                if (debug_print) {
>                        char start_factor = 'K', size_factor = 'K';
>                        unsigned long start_base, size_base;
> --
> 1.7.3
>
