Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461Ab1IPMx1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 08:53:27 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:33339 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805Ab1IPMx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 08:53:26 -0400
Date: Fri, 16 Sep 2011 14:53:27 +0200
From: Borislav Petkov <bp@amd64.org>
To: Han Pingtian <phan@redhat.com>
Cc: mchehab@redhat.com, linux-kernel@vger.kernel.org,
        edac-devel <linux-edac@vger.kernel.org>
Subject: Re: [PATCH] Fix EDAC sdram_scrub_rate read failure
Message-ID: <20110916125326.GA1957@gere.osrc.amd.com>
References: <20110916105856.GA13253@hpt.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110916105856.GA13253@hpt.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 16, 2011 at 06:58:56PM +0800, Han Pingtian wrote:
> If sdram scrubbing rate ins't implemented on current system, read it
> will cause an error:
> 
> cat: /sys/devices/system/edac/mc//mc0/sdram_scrub_rate: Invalid argument
> 
> The eba042a81edd6baaff44831b2d719b14a6d21e58 let it returning -EINVAL,

Can you please add the patch author to CC next time, out of courtesy?
Thanks.

> but according to the document, it should show -1:
> 
> dram memory scrubbing rate:
> 
>         'sdram_scrub_rate'
> 
>         Read/Write attribute file that controls memory scrubbing. The scrubbing
>         rate is set by writing a minimum bandwidth in bytes/sec to the attribute
>         file. The rate will be translated to an internal value that gives at
>         least the specified rate.
> 
>         Reading the file will return the actual scrubbing rate employed.
> 
>         If configuration fails or memory scrubbing is not implemented, the value
>         of the attribute file will be -1.
> 
> Signed-off-by: Han Pingtian <phan@redhat.com>
> ---
>  drivers/edac/edac_mc_sysfs.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
> index 29ffa35..602fdcf 100644
> --- a/drivers/edac/edac_mc_sysfs.c
> +++ b/drivers/edac/edac_mc_sysfs.c
> @@ -475,7 +475,7 @@ static ssize_t mci_sdram_scrub_rate_show(struct mem_ctl_info *mci, char *data)
>  	int bandwidth = 0;
>  
>  	if (!mci->get_sdram_scrub_rate)
> -		return -EINVAL;
> +		return sprintf(date, "%d\n", -1);

Have you even build-tested your patch:

drivers/edac/edac_mc_sysfs.c: In function ‘mci_sdram_scrub_rate_show’:
drivers/edac/edac_mc_sysfs.c:478: error: ‘date’ undeclared (first use in this function)
drivers/edac/edac_mc_sysfs.c:478: error: (Each undeclared identifier is reported only once
drivers/edac/edac_mc_sysfs.c:478: error: for each function it appears in.)
make[2]: *** [drivers/edac/edac_mc_sysfs.o] Error 1
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [drivers/edac] Error 2
make[1]: *** Waiting for unfinished jobs....
make: *** [drivers] Error 2
make: *** Waiting for unfinished jobs....

>  
>  	bandwidth = mci->get_sdram_scrub_rate(mci);
>  	if (bandwidth < 0) {

Anyway, the EDAC document says that sdram_scrub_rate is
read/write and when writing you have to write -1 too. Care to fix
mci_sdram_scrub_rate_store too, test your patch properly and resend?

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
