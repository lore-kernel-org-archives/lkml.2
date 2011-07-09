Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318Ab1GIP6V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 11:58:21 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:39656 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab1GIP6U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 11:58:20 -0400
MIME-Version: 1.0
In-Reply-To: <20110708225119.722174548@clark.kroah.org>
References: <20110708225343.GA14402@kroah.com>
	<20110708225119.722174548@clark.kroah.org>
Date: Sat, 9 Jul 2011 11:58:18 -0400
X-Google-Sender-Auth: ZypXcxBzatdlAEbdEW_FKZ6ZD3Q
Message-ID: <CAP=VYLredMdZBA6uBbBqVL5p6FxCK2SqVGsJohG-nwiMtVxtVQ@mail.gmail.com>
Subject: Re: [09/35] ath9k: Fix suspend/resume when no interface is UP
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 8, 2011 at 6:49 PM, Greg KH <gregkh@suse.de> wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let us know.
>
> ------------------
>
> From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
>
> commit c31eb8e926835582cd186b33a7a864880a4c0c79 upstream.
>
> When no interface has been brought up, the chip's power
> state continued as AWAKE. So during resume, the chip never
> been powered up.
>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>
> ---
>  drivers/net/wireless/ath/ath9k/pci.c |    6 ++++++
>  1 file changed, 6 insertions(+)
>
> --- a/drivers/net/wireless/ath/ath9k/pci.c
> +++ b/drivers/net/wireless/ath/ath9k/pci.c
> @@ -276,6 +276,12 @@ static int ath_pci_resume(struct pci_dev

This might warrant a double check.   The original was patching the
fullsleep into pci_suspend, not pci_resume, as is shown above here.

Paul.

>                            AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
>        ath9k_hw_set_gpio(sc->sc_ah, sc->sc_ah->led_pin, 1);
>
> +       /* The device has to be moved to FULLSLEEP forcibly.
> +        * Otherwise the chip never moved to full sleep,
> +        * when no interface is up.
> +        */
> +       ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_FULL_SLEEP);
> +
>        return 0;
>  }
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
