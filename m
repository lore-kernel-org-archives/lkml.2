Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933030Ab0LTSa3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 13:30:29 -0500
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:33860 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932742Ab0LTSa2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 13:30:28 -0500
MIME-Version: 1.0
In-Reply-To: <1292865120-24020-1-git-send-email-felipe.contreras@nokia.com>
References: <1292865120-24020-1-git-send-email-felipe.contreras@nokia.com>
Date: Mon, 20 Dec 2010 12:30:27 -0600
Message-ID: <AANLkTi=C4hvf9t9j51TE3JNdygHbjf-vAQBvdf+Oimfh@mail.gmail.com>
Subject: Re: [PATCH] staging: tidspbridge: protect dmm_map properly
From: "Kanigeri, Hari" <h-kanigeri2@ti.com>
To: Felipe Contreras <felipe.contreras@nokia.com>
Cc: linux-main <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Omar Ramirez Luna <omar.ramirez@ti.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Nishanth Menon <nm@ti.com>, Ameya Palande <ameya.palande@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe,

On Mon, Dec 20, 2010 at 11:12 AM, Felipe Contreras
<felipe.contreras@nokia.com> wrote:
> We need to protect not only the dmm_map list, but the individual
> map_obj's, otherwise, we might be building the scatter-gather list with
> garbage. So, use the existing proc_lock for that.
>
> I observed race conditions which caused kernel panics while running
> stress tests. This patch fixes those.
>
> Signed-off-by: Felipe Contreras <felipe.contreras@nokia.com>
> ---
>  drivers/staging/tidspbridge/rmgr/proc.c |   18 ++++++++++++++----
>  1 files changed, 14 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/staging/tidspbridge/rmgr/proc.c b/drivers/staging/tidspbridge/rmgr/proc.c
> index b47d7aa..21052e3 100644
> --- a/drivers/staging/tidspbridge/rmgr/proc.c
> +++ b/drivers/staging/tidspbridge/rmgr/proc.c
> @@ -781,12 +781,14 @@ int proc_begin_dma(void *hprocessor, void *pmpu_addr, u32 ul_size,
>                                                        (u32)pmpu_addr,
>                                                        ul_size, dir);
>
> +       mutex_lock(&proc_lock);

May be you should use mutex_lock_interruptable instead of  mutex_lock.

> +
>        /* find requested memory are in cached mapping information */
>        map_obj = find_containing_mapping(pr_ctxt, (u32) pmpu_addr, ul_size);
>        if (!map_obj) {
>                pr_err("%s: find_containing_mapping failed\n", __func__);
>                status = -EFAULT;
> -               goto err_out;
> +               goto no_map;
>        }
>
>        if (memory_give_ownership(map_obj, (u32) pmpu_addr, ul_size, dir)) {
> @@ -795,6 +797,8 @@ int proc_begin_dma(void *hprocessor, void *pmpu_addr, u32 ul_size,
>                status = -EFAULT;
>        }
>
> +no_map:
> +       mutex_unlock(&proc_lock);
>  err_out:
>
>        return status;
> @@ -819,12 +823,14 @@ int proc_end_dma(void *hprocessor, void *pmpu_addr, u32 ul_size,
>                                                        (u32)pmpu_addr,
>                                                        ul_size, dir);
>
> +       mutex_lock(&proc_lock);
> +
>        /* find requested memory are in cached mapping information */
>        map_obj = find_containing_mapping(pr_ctxt, (u32) pmpu_addr, ul_size);
>        if (!map_obj) {
>                pr_err("%s: find_containing_mapping failed\n", __func__);
>                status = -EFAULT;
> -               goto err_out;
> +               goto no_map;
>        }
>
>        if (memory_regain_ownership(map_obj, (u32) pmpu_addr, ul_size, dir)) {
> @@ -834,6 +840,8 @@ int proc_end_dma(void *hprocessor, void *pmpu_addr, u32 ul_size,
>                goto err_out;

Mutex is not released in this case as it is released only at no_map.


>        }
>
> +no_map:
> +       mutex_unlock(&proc_lock);
>  err_out:
>        return status;
>  }
> @@ -1726,9 +1734,8 @@ int proc_un_map(void *hprocessor, void *map_addr,
>                    (p_proc_object->hbridge_context, va_align, size_align);
>        }
>
> -       mutex_unlock(&proc_lock);
>        if (status)
> -               goto func_end;
> +               goto unmap_failed;
>
>        /*
>         * A successful unmap should be followed by removal of map_obj
> @@ -1737,6 +1744,9 @@ int proc_un_map(void *hprocessor, void *map_addr,
>         */
>        remove_mapping_information(pr_ctxt, (u32) map_addr, size_align);
>
> +unmap_failed:
> +       mutex_unlock(&proc_lock);
> +
>  func_end:
>        dev_dbg(bridge, "%s: hprocessor: 0x%p map_addr: 0x%p status: 0x%x\n",
>                __func__, hprocessor, map_addr, status);
> --
> 1.7.3.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Thank you,
Best regards,
Hari Kanigeri
