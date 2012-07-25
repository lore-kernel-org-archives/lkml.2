Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756417Ab2GYQNI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 12:13:08 -0400
Received: from osrc3.amd.com ([217.9.48.20]:36559 "EHLO mail.x86-64.org"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755788Ab2GYQNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 12:13:07 -0400
Date: Wed, 25 Jul 2012 18:13:01 +0200
From: Borislav Petkov <bp@amd64.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 06/13] driver core: firmware loader: always let
 firmware_buf own the pages buffer
Message-ID: <20120725161301.GL11152@aftab.osrc.amd.com>
References: <1343149213-10160-1-git-send-email-ming.lei@canonical.com>
 <1343149213-10160-7-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1343149213-10160-7-git-send-email-ming.lei@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 01:00:06AM +0800, Ming Lei wrote:
> This patch always let firmware_buf own the pages buffer allocated
> inside firmware_data_write, also add all instances of firmware_buf
> into the firmware cache global list. Also introduce one private field
> in 'struct firmware', so release_firmware will see the instance of
> firmware_buf associated with one firmware instance, then just 'free'
> the instance of firmware_buf.
> 
> The firmware_buf instance represents one pages buffer for one
> firmware image, so lots of firmware loading requests can share
> the same firmware_buf instance if they request the same firmware
> image file.
> 
> This patch will make introducing cache_firmware/uncache_firmware
> easily.
> 
> In fact, the patch improves request_formware/release_firmware:
> 
>         - only request userspace to write firmware image once if
> 	several devices share one same firmware image and its drivers
> 	call request_firmware concurrently.
> 
> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> ---
>  drivers/base/firmware_class.c |  222 ++++++++++++++++++++++++++++-------------
>  include/linux/firmware.h      |    3 +
>  2 files changed, 157 insertions(+), 68 deletions(-)
> 
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index 986d9df..225898e 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -21,6 +21,7 @@
>  #include <linux/firmware.h>
>  #include <linux/slab.h>
>  #include <linux/sched.h>
> +#include <linux/list.h>
>  
>  MODULE_AUTHOR("Manuel Estrada Sainz");
>  MODULE_DESCRIPTION("Multi purpose firmware loading support");
> @@ -85,13 +86,18 @@ static inline long firmware_loading_timeout(void)
>  	return loading_timeout > 0 ? loading_timeout * HZ : MAX_SCHEDULE_TIMEOUT;
>  }
>  
> -/* fw_lock could be moved to 'struct firmware_priv' but since it is just
> - * guarding for corner cases a global lock should be OK */
> -static DEFINE_MUTEX(fw_lock);
> +struct firmware_cache {
> +

Stray newline. Sorry I missed it the first time.

> +	/* firmware_buf instance will be added into the below list */
> +	spinlock_t lock;
> +	struct list_head head;
> +};

[ … ]

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
