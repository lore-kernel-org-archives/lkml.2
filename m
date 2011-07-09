Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664Ab1GINck (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 09:32:40 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:48906 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372Ab1GINci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 09:32:38 -0400
X-AuditID: b753bd60-a0a78ba0000050a4-64-4e18587354ce
X-AuditID: b753bd60-a0a78ba0000050a4-64-4e18587354ce
Message-ID: <4E18586F.501@hitachi.com>
Date: Sat, 09 Jul 2011 22:32:31 +0900
From: Nao Nishijima <nao.nishijima.xt@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        James.Bottomley@HansenPartnership.com, kay.sievers@vrfy.org,
        jcm@redhat.com, greg@kroah.com, dle-develop@lists.sourceforge.net,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com, dgilbert@interlog.com,
        stefanr@s5r6.in-berlin.de, hare@suse.de
Subject: Re: [PATCH] scsi: Make functions out of logging macros.
References: <20110708084547.2091.55262.stgit@ltc197.sdl.hitachi.co.jp>	 <20110708084610.2091.8405.stgit@ltc197.sdl.hitachi.co.jp> <1310190175.3848.5.camel@Joe-Laptop>
In-Reply-To: <1310190175.3848.5.camel@Joe-Laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Joe

Thank you for looking at this patch.
Your patch sounds great. I will test the patch.

Best regards,

(2011/07/09 14:42), Joe Perches wrote:
> Reduce size of code and text of scmd_printk and sd_printk
> macros by converting to the macros to functions and using
> vsprintf extension %pV.  This moves the code out-of-line
> and centralizes the code used to emit additional arguments.
> 
> Save ~32KB of space in an x86 allyesconfig.
> 
> $ size drivers/scsi/built-in.o*
>    text	   data	    bss	    dec	    hex	filename
> 5860439	 135396	1393024	7388859	 70bebb	drivers/scsi/built-in.o.new
> 5882368	 135396	1395848	7413612	 711f6c	drivers/scsi/built-in.o.old
> 5887100	 135396	1397264	7419760	 713770	drivers/scsi/built-in.o.with_patch_1_and_2
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> ---
> 
> Re: [RFC PATCH 2/4] sd: modify printk for alias_name
> 
> On Fri, 2011-07-08 at 17:46 +0900, Nao Nishijima wrote: 
>> This patch modify sd_printk() and scmd_printk() to use alias_name. If user set
>> an alias_name, those print an alias_name instead of a disk_name.
>  
> Instead of larding more function/macros into these
> relatively heavily used logging macros, how about
> converting the logging macros into functions?
> 
>  drivers/scsi/scsi_lib.c    |   26 ++++++++++++++++++++++++++
>  drivers/scsi/sd.c          |   23 +++++++++++++++++++++++
>  drivers/scsi/sd.h          |    8 +++-----
>  include/scsi/scsi_device.h |    8 +++-----
>  4 files changed, 55 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index ec1803a..249c54c 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -2571,3 +2571,29 @@ void scsi_kunmap_atomic_sg(void *virt)
>  	kunmap_atomic(virt, KM_BIO_SRC_IRQ);
>  }
>  EXPORT_SYMBOL(scsi_kunmap_atomic_sg);
> +
> +/* Logging utilities */
> +
> +int scmd_printk(const char *prefix, const struct scsi_cmnd *scmd,
> +		const char *format, ...)
> +{
> +	struct va_format vaf;
> +	va_list args;
> +	int r;
> +
> +	va_start(args, format);
> +
> +	vaf.fmt = format;
> +	vaf.va = &args;
> +
> +	if (scmd->request->rq_disk)
> +		r = sdev_printk(prefix, scmd->device, "[%s] %pV",
> +				alias_name(scmd->request->rq_disk), &vaf);
> +	else
> +		r = sdev_printk(prefix, scmd->device, "%pV", &vaf);
> +
> +	va_end(args);
> +
> +	return r;
> +}
> +EXPORT_SYMBOL(scmd_printk);
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 953773c..2251e01 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2888,3 +2888,26 @@ static void sd_print_result(struct scsi_disk *sdkp, int result)
>  	scsi_show_result(result);
>  }
>  
> +int sd_printk(const char *prefix, const struct scsi_disk *sdsk,
> +	      const char *format, ...)
> +{
> +	struct va_format vaf;
> +	va_list args;
> +	int r;
> +
> +	va_start(args, format);
> +
> +	vaf.fmt = format;
> +	vaf.va = &args;
> +
> +	if (sdsk->disk)
> +		r = sdev_printk(prefix, sdsk->device, "[%s] %pV",
> +				alias_name(sdsk->disk), &vaf);
> +	else
> +		r = sdev_printk(prefix, sdsk->device, "%pV", &vaf);
> +
> +	va_end(args);
> +
> +	return r;
> +}
> +EXPORT_SYMBOL(sd_printk);
> diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
> index 6ad798b..46aa748 100644
> --- a/drivers/scsi/sd.h
> +++ b/drivers/scsi/sd.h
> @@ -88,11 +88,9 @@ static inline struct scsi_disk *scsi_disk(struct gendisk *disk)
>  	return container_of(disk->private_data, struct scsi_disk, driver);
>  }
>  
> -#define sd_printk(prefix, sdsk, fmt, a...)				\
> -        (sdsk)->disk ?							\
> -	sdev_printk(prefix, (sdsk)->device, "[%s] " fmt,		\
> -		    (sdsk)->disk->disk_name, ##a) :			\
> -	sdev_printk(prefix, (sdsk)->device, fmt, ##a)
> +extern __attribute__((format (printf, 3, 4)))
> +int sd_printk(const char *prefix, const struct scsi_disk *sdsk,
> +	      const char *format, ...);
>  
>  /*
>   * A DIF-capable target device can be formatted with different
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index dd82e02..c79631b 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -216,11 +216,9 @@ struct scsi_dh_data {
>  #define sdev_printk(prefix, sdev, fmt, a...)	\
>  	dev_printk(prefix, &(sdev)->sdev_gendev, fmt, ##a)
>  
> -#define scmd_printk(prefix, scmd, fmt, a...)				\
> -        (scmd)->request->rq_disk ?					\
> -	sdev_printk(prefix, (scmd)->device, "[%s] " fmt,		\
> -		    (scmd)->request->rq_disk->disk_name, ##a) :		\
> -	sdev_printk(prefix, (scmd)->device, fmt, ##a)
> +extern __attribute__((format (printf, 3, 4)))
> +int scmd_printk(const char *prefix, const struct scsi_cmnd *scmd,
> +		const char *format, ...);
>  
>  enum scsi_target_state {
>  	STARGET_CREATED = 1,


-- 
Nao NISHIJIMA
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., YOKOHAMA Research  Laboratory
Email： nao.nishijima.xt@hitachi.com
