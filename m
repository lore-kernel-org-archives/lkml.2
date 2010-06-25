Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581Ab0FYKRO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 06:17:14 -0400
Received: from n3-vm0.bullet.mail.gq1.yahoo.com ([67.195.23.156]:36345 "HELO
	n3-vm0.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752406Ab0FYKRN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 06:17:13 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 475357.49324.bm@omp124.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=5eg/uPk3kyZWqqaZdFeEkpV5iMVJBXDepCs8F5B74qTajf7U/G1d/JgKZ3doQnMiSKo6pg4TY/lUz3YW915PxmBJWAhO5TJ5wZZ6DhGuAkNyj87n5aTc+19K+aDdH75GTMkw5oSBU4mE8w9Ra7c+oxfgQMXQ2zmajGbljGlYF+M=;
Message-ID: <352874.17151.qm@web180303.mail.gq1.yahoo.com>
X-YMail-OSG: StFoQYoVM1m5_se7TAlsEgVZDzXRQKiSzNjWcNMJrOUkbIo
 smTIrIvXoM4wINjmfa0WrphyICfJFrd6oGAikFZR6G38IOuVW7axbcDsAmfp
 h_aZbh9448um81l1Z5AfV48JsrFyN3QKqt9YRh7hIIW3T1r4w1Ijk3AT2gzf
 eyCn1.G5raO0IUm89VWtv.nNl.gc0W7XwAoaVyTqLLdhCTOMlttPodnt_caY
 hzEny4tPduWBgVkpTByXiapp11S62HocwnUIDdjui.2AJJ4_h1cZu5Dy2wks
 fAOSaIOKUuQJ4Wq5dFDUeVQ6sY872mKdI3HqXQgF4N5fatZgvoSMAEOmPtSm
 ilJzQinH2wgcbjQJo2IuM9zqtdwA-
X-Mailer: YahooMailClassic/11.1.4 YahooMailWebService/0.8.104.274457
Date: Fri, 25 Jun 2010 03:17:11 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] pcf857x: support working w/o platform data
To: linux-kernel@vger.kernel.org,
       Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>
In-Reply-To: <1276778870-1065-1-git-send-email-dbaryshkov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Thu, 6/17/10, Dmitry Eremin-Solenikov <dbaryshkov@gmail.com> wrote:

> Provide sane defaults for pcf857x, so
> the driver can be used w/o
> providing platform data (and thus can be simply bound via OF tree).


Maybe we can get an ack from some OF folk
who are using it in that way?



> Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> ---
>  drivers/gpio/pcf857x.c |    9 ++++-----
>  1 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/gpio/pcf857x.c
> b/drivers/gpio/pcf857x.c
> index 29f19ce..879b473 100644
> --- a/drivers/gpio/pcf857x.c
> +++ b/drivers/gpio/pcf857x.c
> @@ -190,7 +190,6 @@ static int pcf857x_probe(struct
> i2c_client *client,
>      pdata = client->dev.platform_data;
>      if (!pdata) {
>         
> dev_dbg(&client->dev, "no platform data\n");
> -        return -EINVAL;
>      }
>  
>      /* Allocate, initialize, and register
> this gpio_chip. */
> @@ -200,7 +199,7 @@ static int pcf857x_probe(struct
> i2c_client *client,
>  
>      mutex_init(&gpio->lock);
>  
> -    gpio->chip.base =
> pdata->gpio_base;
> +    gpio->chip.base = pdata ?
> pdata->gpio_base : -1;
>      gpio->chip.can_sleep = 1;
>      gpio->chip.dev =
> &client->dev;
>      gpio->chip.owner = THIS_MODULE;
> @@ -278,7 +277,7 @@ static int pcf857x_probe(struct
> i2c_client *client,
>       * to zero, our software copy
> of the "latch" then matches the chip's
>       * all-ones reset
> state.  Otherwise it flags pins to be driven low.
>       */
> -    gpio->out = ~pdata->n_latch;
> +    gpio->out = pdata ?
> ~pdata->n_latch : ~0;
>  
>      status =
> gpiochip_add(&gpio->chip);
>      if (status < 0)
> @@ -299,7 +298,7 @@ static int pcf857x_probe(struct
> i2c_client *client,
>      /* Let platform code set up the GPIOs
> and their users.
>       * Now is the first time
> anyone could use them.
>       */
> -    if (pdata->setup) {
> +    if (pdata && pdata->setup)
> {
>          status =
> pdata->setup(client,
>             
>     gpio->chip.base, gpio->chip.ngpio,
>             
>     pdata->context);
> @@ -322,7 +321,7 @@ static int pcf857x_remove(struct
> i2c_client *client)
>      struct pcf857x   
>         *gpio =
> i2c_get_clientdata(client);
>      int   
>            
> status = 0;
>  
> -    if (pdata->teardown) {
> +    if (pdata &&
> pdata->teardown) {
>          status =
> pdata->teardown(client,
>             
>     gpio->chip.base, gpio->chip.ngpio,
>             
>     pdata->context);
> -- 
> 1.7.1
> 
> 

