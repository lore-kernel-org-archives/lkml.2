Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760269Ab2FUUvj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 16:51:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36192 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760246Ab2FUUvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 16:51:38 -0400
Date: Thu, 21 Jun 2012 13:51:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Devendra Naga <devendra.aaru@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
        Anatolij Gustschin <agust@denx.de>,
        Andreas Dumberger <andreas.dumberger@tqs.de>,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtc/r9701: avoid second call to the rtc_valid_tm
Message-Id: <20120621135136.1e2ff338.akpm@linux-foundation.org>
In-Reply-To: <1340262280-15096-1-git-send-email-devendra.aaru@gmail.com>
References: <1340262280-15096-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2012 12:34:40 +0530
Devendra Naga <devendra.aaru@gmail.com> wrote:

> r9701_get_datetime will call the rtc_valid_tm and it returns the
> value returned by rtc_valid_tm, which anyway can be used in the if
> 
> so calling rtc_valid_tm is not required.
> 
> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
> ---
> 
> 
> This change is compiled tested only using gcc (Ubuntu/Linaro 4.6.3-1ubuntu5) 4.6.3 on x86_64 (intel core i3).
> 
>  drivers/rtc/rtc-r9701.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/rtc/rtc-r9701.c b/drivers/rtc/rtc-r9701.c
> index 33b6ba0..e6c34c0 100644
> --- a/drivers/rtc/rtc-r9701.c
> +++ b/drivers/rtc/rtc-r9701.c
> @@ -138,8 +138,7 @@ static int __devinit r9701_probe(struct spi_device *spi)
>  	 * contain invalid values. If so, try to write a default date:
>  	 * 2000/1/1 00:00:00
>  	 */
> -	r9701_get_datetime(&spi->dev, &dt);
> -	if (rtc_valid_tm(&dt)) {
> +	if (r9701_get_datetime(&spi->dev, &dt)) {
>  		dev_info(&spi->dev, "trying to repair invalid date/time\n");
>  		dt.tm_sec  = 0;
>  		dt.tm_min  = 0;

Looks OK.


I think the driver would be better if we were to do this:


From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/rtc/rtc-r9701.c: check that r9701_set_datetime() succeeded

When the driver detects that the clock time is invalid, it attempts to
write a sane time into the hardware.  We curently assume that everything
is OK is those writes succeeded.  But it is better to re-read the time
from the hardware to ensure that the new settings got there OK.

Cc: Devendra Naga <devendra.aaru@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Anatolij Gustschin <agust@denx.de>
Cc: Andreas Dumberger <andreas.dumberger@tqs.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-r9701.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-r9701.c~a drivers/rtc/rtc-r9701.c
--- a/drivers/rtc/rtc-r9701.c~a
+++ a/drivers/rtc/rtc-r9701.c
@@ -147,7 +147,8 @@ static int __devinit r9701_probe(struct 
 		dt.tm_mon  = 0;
 		dt.tm_year = 100;
 
-		if (r9701_set_datetime(&spi->dev, &dt)) {
+		if (r9701_set_datetime(&spi->dev, &dt) ||
+				r9701_get_datetime(&spi->dev, &dt)) {
 			dev_err(&spi->dev, "cannot repair RTC register\n");
 			return -ENODEV;
 		}
_


But I can't test this :(
