Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522Ab2GYPww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 11:52:52 -0400
Received: from osrc3.amd.com ([217.9.48.20]:36411 "EHLO mail.x86-64.org"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755275Ab2GYPwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 11:52:50 -0400
Date: Wed, 25 Jul 2012 17:52:44 +0200
From: Borislav Petkov <bp@amd64.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 07/13] driver core: firmware loader: introduce
 cache_firmware and uncache_firmware
Message-ID: <20120725155244.GI11152@aftab.osrc.amd.com>
References: <1343149213-10160-1-git-send-email-ming.lei@canonical.com>
 <1343149213-10160-8-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1343149213-10160-8-git-send-email-ming.lei@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 01:00:07AM +0800, Ming Lei wrote:
> This patches introduce two kernel APIs of cache_firmware and
> uncache_firmware, both of which take the firmware file name
> as the only parameter.
> 
> So any drivers can call cache_firmware to cache the specified
> firmware file into kernel memory, and can use the cached firmware
> in situations which can't request firmware from user space.
> 
> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> ---
>  drivers/base/firmware_class.c |   79 +++++++++++++++++++++++++++++++++++++++++
>  include/linux/firmware.h      |   12 +++++++
>  2 files changed, 91 insertions(+)
> 
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index 225898e..674cb11 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -168,6 +168,22 @@ static int fw_lookup_and_alloate_buf(const char *fw_name,
>  	return tmp ? 0 : -1;
>  }
>  
> +static struct firmware_buf *fw_lookup_buf(const char *fw_name)
> +{
> +	struct firmware_buf *tmp;
> +	struct firmware_cache *fwc = &fw_cache;
> +
> +	spin_lock(&fwc->lock);
> +	list_for_each_entry(tmp, &fwc->head, list)
> +		if (!strcmp(tmp->fw_id, fw_name)) {
> +			spin_unlock(&fwc->lock);
> +			return tmp;
> +		}
> +	spin_unlock(&fwc->lock);
> +
> +	return NULL;
> +}

You have similar functionality in fw_lookup_and_alloate_buf() above.
Can't you reuse it instead of defining a new function?

> +
>  static void __fw_free_buf(struct kref *ref)
>  {
>  	struct firmware_buf *buf = to_fwbuf(ref);
> @@ -833,6 +849,67 @@ request_firmware_nowait(
>  	return 0;
>  }
>  
> +/**
> + * cache_firmware - cache one firmware image in kernel memory space
> + * @fw_name: the firmware image name
> + *
> + * Cache firmware in kernel memory so that drivers can use the firmware

								s/the firmware/it/

> + * when system isn't ready for drivers to request firmware image from

				s/drivers/them/

> + * userspace. Once returns successfully, driver can use request_firmware*

		    it

> + * to get the cached firmware without any interacting with user space

							s/user space/userspace/

> + *
> + * Return 0 if the firmware image has been cached successfully
> + * Return !0 if it is not successfully

	Return !0 otherwise.

> + *
> + */
> +int cache_firmware(const char *fw_name)
> +{
> +	int ret;
> +	const struct firmware *fw;
> +
> +	pr_debug("%s: %s\n", __func__, fw_name);
> +
> +	ret = request_firmware(&fw, fw_name, NULL);
> +

stray newline

> +	if (!ret)
> +		kfree(fw);
> +
> +	pr_debug("%s: %s ret=%d\n", __func__, fw_name, ret);
> +
> +	return ret;
> +}
> +
> +/**
> + * uncache_firmware - remove one cached firmware image
> + *

stray newline

> + * @fw_name: the firmware image name
> + *
> + * Uncache one firmware image which has been cached successfully
> + * before.
> + *
> + * Return 0 if the firmware cache has been removed successfully
> + * Return !0 if it is not successfully

Return !0 otherwise

> + *
> + */
> +int uncache_firmware(const char *fw_name)
> +{
> +	struct firmware_buf *buf;
> +	struct firmware fw;
> +
> +	pr_debug("%s: %s\n", __func__, fw_name);
> +
> +	if (fw_get_builtin_firmware(&fw, fw_name))
> +		return 0;
> +
> +	buf = fw_lookup_buf(fw_name);
> +	if (buf) {
> +		fw_free_buf(buf);
> +		return 0;
> +	}
> +
> +	return -EINVAL;

[ … ]

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
