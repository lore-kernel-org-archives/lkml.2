Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438Ab2BXPdu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 10:33:50 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:55656 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757077Ab2BXPds convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 10:33:48 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of just.for.lkml@googlemail.com designates 10.182.222.74 as permitted sender) smtp.mail=just.for.lkml@googlemail.com; dkim=pass header.i=just.for.lkml@googlemail.com
MIME-Version: 1.0
In-Reply-To: <20120219142911.12300.7497.stgit@zurg>
References: <20120219142911.12300.7497.stgit@zurg>
Date: Fri, 24 Feb 2012 16:33:48 +0100
Message-ID: <CAPVoSvSimdFfkxSqtW3Gzf+J-sPPzVuyyUEf7Zxo4HLmBx9kxw@mail.gmail.com>
Subject: Re: [PATCH] percpu: fix generic definition of __this_cpu_add_and_return()
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 19, 2012 at 3:29 PM, Konstantin Khlebnikov
<khlebnikov@openvz.org> wrote:
> This patch adds missed "__" into function prefix.
> Otherwise on all archectures (except x86) it expands to irq/preemtion-safe
> variant: _this_cpu_generic_add_return(), which do extra irq-save/irq-restore.
> Optimal generic implementation is __this_cpu_generic_add_return().
>
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> ---
>  include/linux/percpu.h |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/include/linux/percpu.h b/include/linux/percpu.h
> index 32cd1f6..3b609eb 100644
> --- a/include/linux/percpu.h
> +++ b/include/linux/percpu.h
> @@ -718,7 +718,8 @@ do {                                                                        \
>  # ifndef __this_cpu_add_return_8
>  #  define __this_cpu_add_return_8(pcp, val)    __this_cpu_generic_add_return(pcp, val)
>  # endif
> -# define __this_cpu_add_return(pcp, val)       __pcpu_size_call_return2(this_cpu_add_return_, pcp, val)
> +# define __this_cpu_add_return(pcp, val)       \
> +       __pcpu_size_call_return2(__this_cpu_add_return_, pcp, val)
>  #endif
>
>  #define __this_cpu_sub_return(pcp, val)        this_cpu_add_return(pcp, -(val))

I think, the same fix should be applied to the lines following this patch:
#define __this_cpu_sub_return(pcp, val) this_cpu_add_return(pcp, -(val))
#define __this_cpu_inc_return(pcp)      this_cpu_add_return(pcp, 1)
#define __this_cpu_dec_return(pcp)      this_cpu_add_return(pcp, -1)

Shouldn't these other operations also only give the __ relaxed guarantees?

HTH

Torsten
