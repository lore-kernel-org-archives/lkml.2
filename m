Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759367Ab2EPRtz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 13:49:55 -0400
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:51898 "HELO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752607Ab2EPRtx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 13:49:53 -0400
MIME-Version: 1.0
In-Reply-To: <1337034597-1826-1-git-send-email-pshelar@nicira.com>
References: <1337034597-1826-1-git-send-email-pshelar@nicira.com>
Date: Wed, 16 May 2012 10:49:52 -0700
Message-ID: <CALnjE+pbsS3W8G7yN82fdnchmXDxGkTo+Gy2b4kj6DkuQ=Z+wQ@mail.gmail.com>
Subject: Re: [PATCH v2] mm: Fix slab->page _count corruption.
From: Pravin Shelar <pshelar@nicira.com>
To: cl@linux.com, penberg@kernel.org, mpm@selenic.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jesse@nicira.com,
        abhide@nicira.com, Pravin B Shelar <pshelar@nicira.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,
Can you comment on this patch. I have changed it according to your comments.

Thanks,
Pravin.

On Mon, May 14, 2012 at 3:29 PM, Pravin B Shelar <pshelar@nicira.com> wrote:
> On arches that do not support this_cpu_cmpxchg_double slab_lock is used
> to do atomic cmpxchg() on double word which contains page->_count.
> page count can be changed from get_page() or put_page() without taking
> slab_lock. That corrupts page counter.
>
> Following patch fixes it by moving page->_count out of cmpxchg_double
> data. So that slub does no change it while updating slub meta-data in
> struct page.
>
> Reported-by: Amey Bhide <abhide@nicira.com>
> Signed-off-by: Pravin B Shelar <pshelar@nicira.com>
> ---
>  include/linux/mm_types.h |    8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index dad95bd..5f558dc 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -57,8 +57,16 @@ struct page {
>                };
>
>                union {
> +#if defined(CONFIG_HAVE_CMPXCHG_DOUBLE) && \
> +    defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
>                        /* Used for cmpxchg_double in slub */
>                        unsigned long counters;
> +#else
> +                       /* Keep _count separate from slub cmpxchg_double data,
> +                        * As rest of double word is protected by slab_lock
> +                        * but _count is not. */
> +                       unsigned counters;
> +#endif
>
>                        struct {
>
> --
> 1.7.10
>
