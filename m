Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab0FRBfy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 21:35:54 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44789 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab0FRBfw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 21:35:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BTN3MxPMIhhZfA+4/Oer/RX1/sc+a29/BS3OWqO+93J6loSobsdFHhmAZRsa/aiA8V
         Yy+lCR0rt5rACgHhRxVwtRfdSur0Lirm/Vz6SSztFdTaCuYClYFbgVqOWHphiyHeL49e
         YMIbHNBp+ChSnRzdXIaA08VdgkTB7U0+sWOd0=
MIME-Version: 1.0
In-Reply-To: <1276818993.9661.82.camel@schen9-DESK>
References: <1276818993.9661.82.camel@schen9-DESK>
Date: Fri, 18 Jun 2010 10:35:51 +0900
Message-ID: <AANLkTikOpTsdxhjqE0G3oEv9qT2nRFp3y5fjDUqXlw4X@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] tmpfs: Make tmpfs scalable with percpu_counter for 
	used blocks
From: Minchan Kim <minchan.kim@gmail.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@linux.intel.com>, Hugh Dickins <hughd@google.com>,
       yanmin.zhang@intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.
The idea is good. :)

On Fri, Jun 18, 2010 at 8:56 AM, Tim Chen <tim.c.chen@linux.intel.com> wrote:
> The current implementation of tmpfs is not scalable.
> We found that stat_lock is contended by multiple threads
> when we need to get a new page, leading to useless spinning
> inside this spin lock.
>
> This patch makes use of the percpu_counter library to maintain local
> count of used blocks to speed up getting and returning
> of pages.  So the acquisition of stat_lock is unnecessary
> for getting and returning blocks, improving the performance
> of tmpfs on system with large number of cpus.  On a 4 socket
> 32 core NHM-EX system, we saw improvement of 270%.
>

Good enhancement. :)

> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
>  include/linux/shmem_fs.h |    3 ++-
>  mm/shmem.c               |   40 +++++++++++++++++-----------------------
>  2 files changed, 19 insertions(+), 24 deletions(-)
>
> diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
> index e164291..399be5a 100644
> --- a/include/linux/shmem_fs.h
> +++ b/include/linux/shmem_fs.h
> @@ -3,6 +3,7 @@
>
>  #include <linux/swap.h>
>  #include <linux/mempolicy.h>
> +#include <linux/percpu_counter.h>
>
>  /* inode in-kernel data */
>
> @@ -23,7 +24,7 @@ struct shmem_inode_info {
>
>  struct shmem_sb_info {
>        unsigned long max_blocks;   /* How many blocks are allowed */
> -       unsigned long free_blocks;  /* How many are left for allocation */
> +       struct percpu_counter used_blocks;  /* How many are allocated */

Just a nitpick.
Why do you change free_blocks and used_blocks?
I think we can use free_blocks following as.

ex)
if (percpu_counter_compare(&sbinfo->free_blocks, 0))

Do you have any reason?
Please, justify it.

Thanks, Tim.
-- 
Kind regards,
Minchan Kim
