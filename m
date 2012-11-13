Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab2KMIDK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 03:03:10 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:47738 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753247Ab2KMIDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 03:03:08 -0500
Message-ID: <1352793790.24230.18.camel@joe-AO722>
Subject: Re: [patch] ALSA: es1968: precedence bug in
 snd_es1968_tea575x_get_pins()
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ondrej Zary <linux@rainbow-software.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Tue, 13 Nov 2012 00:03:10 -0800
In-Reply-To: <20121113074454.GB13198@elgon.mountain>
References: <20121113074454.GB13198@elgon.mountain>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-11-13 at 10:44 +0300, Dan Carpenter wrote:
> I don't think this works as intended.  '|' higher precedence than ?: so
> the bitwize OR "0 | (val & STR_MOST)" is a no-op.
> 
> I have re-written it to be more clear.
[]
> diff --git a/sound/pci/es1968.c b/sound/pci/es1968.c
[]
> @@ -2581,9 +2581,14 @@ static u8 snd_es1968_tea575x_get_pins(struct snd_tea575x *tea)
>  	struct es1968 *chip = tea->private_data;
>  	unsigned long io = chip->io_port + GPIO_DATA;
>  	u16 val = inw(io);
> -
> -	return  (val & STR_DATA) ? TEA575X_DATA : 0 |
> -		(val & STR_MOST) ? TEA575X_MOST : 0;
> +	u8 ret;
> +
> +	ret = 0;
> +	if (val & STR_DATA)
> +		ret |= TEA575X_DATA;
> +	if (val & STR_MOST)
> +		ret |= TEA575X_MOST;
> +	return ret;

Cute.  smatch I presume?  Tools are useful.

Moving the close parentheses is a pretty common style too

	return  (val & STR_DATA ? TEA575X_DATA : 0) |
		(val & STR_MOST ? TEA575X_MOST : 0);


