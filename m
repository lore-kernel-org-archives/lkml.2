Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165Ab2IKSYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 14:24:18 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:46806 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757980Ab2IKSYN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 14:24:13 -0400
MIME-Version: 1.0
In-Reply-To: <1347386432-12954-1-git-send-email-peter.senna@gmail.com>
References: <1347386432-12954-1-git-send-email-peter.senna@gmail.com>
Date: Tue, 11 Sep 2012 15:24:11 -0300
Message-ID: <CAH0vN5Jd9LY6dx0qeA0irP+Z6gaPcouZuVYtd35YO-smnYgThg@mail.gmail.com>
Subject: Re: [PATCH] drivers/media: Removes useless kfree()
From: Marcos Souza <marcos.souza.org@gmail.com>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/9/11 Peter Senna Tschudin <peter.senna@gmail.com>:
> From: Peter Senna Tschudin <peter.senna@gmail.com>
>
> The semantic patch that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
>
> // <smpl>
> @r exists@
> position p1,p2;
> expression x;
> @@
>
> if (x@p1 == NULL) { ... kfree@p2(x); ... return ...; }
>
> @unchanged exists@
> position r.p1,r.p2;
> expression e <= r.x,x,e1;
> iterator I;
> statement S;
> @@
>
> if (x@p1 == NULL) { ... when != I(x,...) S
>                         when != e = e1
>                         when != e += e1
>                         when != e -= e1
>                         when != ++e
>                         when != --e
>                         when != e++
>                         when != e--
>                         when != &e
>    kfree@p2(x); ... return ...; }
>
> @ok depends on unchanged exists@
> position any r.p1;
> position r.p2;
> expression x;
> @@
>
> ... when != true x@p1 == NULL
> kfree@p2(x);
>
> @depends on !ok && unchanged@
> position r.p2;
> expression x;
> @@
>
> *kfree@p2(x);
> // </smpl>
>
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
>
> ---
>  drivers/media/dvb-frontends/dvb_dummy_fe.c |   21 ++++++---------------
>  drivers/media/dvb-frontends/lg2160.c       |    1 -
>  drivers/media/dvb-frontends/s5h1432.c      |    6 +-----
>  drivers/media/dvb-frontends/s921.c         |    7 +------
>  drivers/media/dvb-frontends/stb6100.c      |    6 +-----
>  drivers/media/dvb-frontends/tda665x.c      |    6 +-----
>  drivers/media/platform/davinci/vpbe.c      |    1 -
>  drivers/media/tuners/mt2063.c              |    6 +-----
>  8 files changed, 11 insertions(+), 43 deletions(-)
>
> diff --git a/drivers/media/dvb-frontends/dvb_dummy_fe.c b/drivers/media/dvb-frontends/dvb_dummy_fe.c
> index dcfc902..465068f 100644
> --- a/drivers/media/dvb-frontends/dvb_dummy_fe.c
> +++ b/drivers/media/dvb-frontends/dvb_dummy_fe.c
> @@ -121,16 +121,13 @@ struct dvb_frontend* dvb_dummy_fe_ofdm_attach(void)
>
>         /* allocate memory for the internal state */
>         state = kzalloc(sizeof(struct dvb_dummy_fe_state), GFP_KERNEL);
> -       if (state == NULL) goto error;
> +       if (state == NULL)
> +               return NULL;

I know that is not the scope here but, what do you think to change

if (state == NULL)

for

if (!state)

?

maybe you can send another patch for simplify these.

Just my 2 cents :)

>         /* create dvb_frontend */
>         memcpy(&state->frontend.ops, &dvb_dummy_fe_ofdm_ops, sizeof(struct dvb_frontend_ops));
>         state->frontend.demodulator_priv = state;
>         return &state->frontend;
> -
> -error:
> -       kfree(state);
> -       return NULL;
>  }
>
>  static struct dvb_frontend_ops dvb_dummy_fe_qpsk_ops;
> @@ -141,16 +138,13 @@ struct dvb_frontend *dvb_dummy_fe_qpsk_attach(void)
>
>         /* allocate memory for the internal state */
>         state = kzalloc(sizeof(struct dvb_dummy_fe_state), GFP_KERNEL);
> -       if (state == NULL) goto error;
> +       if (state == NULL)
> +               return NULL;
>
>         /* create dvb_frontend */
>         memcpy(&state->frontend.ops, &dvb_dummy_fe_qpsk_ops, sizeof(struct dvb_frontend_ops));
>         state->frontend.demodulator_priv = state;
>         return &state->frontend;
> -
> -error:
> -       kfree(state);
> -       return NULL;
>  }
>
>  static struct dvb_frontend_ops dvb_dummy_fe_qam_ops;
> @@ -161,16 +155,13 @@ struct dvb_frontend *dvb_dummy_fe_qam_attach(void)
>
>         /* allocate memory for the internal state */
>         state = kzalloc(sizeof(struct dvb_dummy_fe_state), GFP_KERNEL);
> -       if (state == NULL) goto error;
> +       if (state == NULL)
> +               return NULL;
>
>         /* create dvb_frontend */
>         memcpy(&state->frontend.ops, &dvb_dummy_fe_qam_ops, sizeof(struct dvb_frontend_ops));
>         state->frontend.demodulator_priv = state;
>         return &state->frontend;
> -
> -error:
> -       kfree(state);
> -       return NULL;
>  }
>
>  static struct dvb_frontend_ops dvb_dummy_fe_ofdm_ops = {
> diff --git a/drivers/media/dvb-frontends/lg2160.c b/drivers/media/dvb-frontends/lg2160.c
> index cc11260..748da5d 100644
> --- a/drivers/media/dvb-frontends/lg2160.c
> +++ b/drivers/media/dvb-frontends/lg2160.c
> @@ -1451,7 +1451,6 @@ struct dvb_frontend *lg2160_attach(const struct lg2160_config *config,
>         return &state->frontend;
>  fail:
>         lg_warn("unable to detect LG216x hardware\n");
> -       kfree(state);
>         return NULL;
>  }
>  EXPORT_SYMBOL(lg2160_attach);
> diff --git a/drivers/media/dvb-frontends/s5h1432.c b/drivers/media/dvb-frontends/s5h1432.c
> index 8352ce1..24a8c75 100644
> --- a/drivers/media/dvb-frontends/s5h1432.c
> +++ b/drivers/media/dvb-frontends/s5h1432.c
> @@ -352,7 +352,7 @@ struct dvb_frontend *s5h1432_attach(const struct s5h1432_config *config,
>         /* allocate memory for the internal state */
>         state = kmalloc(sizeof(struct s5h1432_state), GFP_KERNEL);
>         if (state == NULL)
> -               goto error;
> +               return NULL;
>
>         /* setup the state */
>         state->config = config;
> @@ -367,10 +367,6 @@ struct dvb_frontend *s5h1432_attach(const struct s5h1432_config *config,
>         state->frontend.demodulator_priv = state;
>
>         return &state->frontend;
> -
> -error:
> -       kfree(state);
> -       return NULL;
>  }
>  EXPORT_SYMBOL(s5h1432_attach);
>
> diff --git a/drivers/media/dvb-frontends/s921.c b/drivers/media/dvb-frontends/s921.c
> index cd2288c..5766512 100644
> --- a/drivers/media/dvb-frontends/s921.c
> +++ b/drivers/media/dvb-frontends/s921.c
> @@ -489,7 +489,7 @@ struct dvb_frontend *s921_attach(const struct s921_config *config,
>         dprintk("\n");
>         if (state == NULL) {
>                 rc("Unable to kzalloc\n");
> -               goto rcor;
> +               return NULL;
>         }
>
>         /* setup the state */
> @@ -502,11 +502,6 @@ struct dvb_frontend *s921_attach(const struct s921_config *config,
>         state->frontend.demodulator_priv = state;
>
>         return &state->frontend;
> -
> -rcor:
> -       kfree(state);
> -
> -       return NULL;
>  }
>  EXPORT_SYMBOL(s921_attach);
>
> diff --git a/drivers/media/dvb-frontends/stb6100.c b/drivers/media/dvb-frontends/stb6100.c
> index 2e93e65..1147e61 100644
> --- a/drivers/media/dvb-frontends/stb6100.c
> +++ b/drivers/media/dvb-frontends/stb6100.c
> @@ -576,7 +576,7 @@ struct dvb_frontend *stb6100_attach(struct dvb_frontend *fe,
>
>         state = kzalloc(sizeof (struct stb6100_state), GFP_KERNEL);
>         if (state == NULL)
> -               goto error;
> +               return NULL;
>
>         state->config           = config;
>         state->i2c              = i2c;
> @@ -587,10 +587,6 @@ struct dvb_frontend *stb6100_attach(struct dvb_frontend *fe,
>
>         printk("%s: Attaching STB6100 \n", __func__);
>         return fe;
> -
> -error:
> -       kfree(state);
> -       return NULL;
>  }
>
>  static int stb6100_release(struct dvb_frontend *fe)
> diff --git a/drivers/media/dvb-frontends/tda665x.c b/drivers/media/dvb-frontends/tda665x.c
> index 2c1c759..58ba534 100644
> --- a/drivers/media/dvb-frontends/tda665x.c
> +++ b/drivers/media/dvb-frontends/tda665x.c
> @@ -229,7 +229,7 @@ struct dvb_frontend *tda665x_attach(struct dvb_frontend *fe,
>
>         state = kzalloc(sizeof(struct tda665x_state), GFP_KERNEL);
>         if (state == NULL)
> -               goto exit;
> +               return NULL;
>
>         state->config           = config;
>         state->i2c              = i2c;
> @@ -246,10 +246,6 @@ struct dvb_frontend *tda665x_attach(struct dvb_frontend *fe,
>         printk(KERN_DEBUG "%s: Attaching TDA665x (%s) tuner\n", __func__, info->name);
>
>         return fe;
> -
> -exit:
> -       kfree(state);
> -       return NULL;
>  }
>  EXPORT_SYMBOL(tda665x_attach);
>
> diff --git a/drivers/media/platform/davinci/vpbe.c b/drivers/media/platform/davinci/vpbe.c
> index c4a82a1..1125a87 100644
> --- a/drivers/media/platform/davinci/vpbe.c
> +++ b/drivers/media/platform/davinci/vpbe.c
> @@ -771,7 +771,6 @@ static int vpbe_initialize(struct device *dev, struct vpbe_device *vpbe_dev)
>         return 0;
>
>  vpbe_fail_amp_register:
> -       kfree(vpbe_dev->amp);
>  vpbe_fail_sd_register:
>         kfree(vpbe_dev->encoders);
>  vpbe_fail_v4l2_device:
> diff --git a/drivers/media/tuners/mt2063.c b/drivers/media/tuners/mt2063.c
> index 0ed9091..1a91215 100644
> --- a/drivers/media/tuners/mt2063.c
> +++ b/drivers/media/tuners/mt2063.c
> @@ -2250,7 +2250,7 @@ struct dvb_frontend *mt2063_attach(struct dvb_frontend *fe,
>
>         state = kzalloc(sizeof(struct mt2063_state), GFP_KERNEL);
>         if (state == NULL)
> -               goto error;
> +               return NULL;
>
>         state->config = config;
>         state->i2c = i2c;
> @@ -2261,10 +2261,6 @@ struct dvb_frontend *mt2063_attach(struct dvb_frontend *fe,
>
>         printk(KERN_INFO "%s: Attaching MT2063\n", __func__);
>         return fe;
> -
> -error:
> -       kfree(state);
> -       return NULL;
>  }
>  EXPORT_SYMBOL_GPL(mt2063_attach);
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Att,

Marcos Paulo de Souza
Acadêmico de Ciencia da Computação - FURB - SC
"Uma vida sem desafios é uma vida sem razão"
"A life without challenges, is a non reason life"
