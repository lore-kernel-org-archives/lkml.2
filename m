Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333Ab1HOWzf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 18:55:35 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:41136
	"EHLO AM1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751091Ab1HOWzd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 18:55:33 -0400
X-SpamScore: -12
X-BigFish: VS-12(zz9371K1432N98dKzz1202hzzz2dh2a8h668h839h8e2h8e3h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Tabi Timur-B04825 <B04825@freescale.com>
To: Julia Lawall <julia@diku.dk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kumar Gala <galak@kernel.crashing.org>
CC: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 8/9] arch/powerpc/sysdev/ehv_pic.c: add missing kfree
Thread-Topic: [PATCH 8/9] arch/powerpc/sysdev/ehv_pic.c: add missing kfree
Thread-Index: AQHMVbzpcXnSfWNej0qPWJW3FUvaz5Ue5Q4A
Date: Mon, 15 Aug 2011 22:55:00 +0000
Message-ID: <CAOZdJXX_BS7GMtmyqiS91QByhrjANtKpbqrstR8g-L80r_N8qg@mail.gmail.com>
References: <1312802283-9107-8-git-send-email-julia@diku.dk>
In-Reply-To: <1312802283-9107-8-git-send-email-julia@diku.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [174.129.36.64]
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <C1BD117AA95FC74B86848765DD286164@freescale.net>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 8, 2011 at 7:18 AM, Julia Lawall <julia@diku.dk> wrote:

> diff --git a/arch/powerpc/sysdev/ehv_pic.c b/arch/powerpc/sysdev/ehv_pic.c
> index af1a5df..b6731e4 100644
> --- a/arch/powerpc/sysdev/ehv_pic.c
> +++ b/arch/powerpc/sysdev/ehv_pic.c
> @@ -280,6 +280,7 @@ void __init ehv_pic_init(void)
>
>        if (!ehv_pic->irqhost) {
>                of_node_put(np);
> +               kfree(ehv_pic);
>                return;
>        }

Although the fix is correct, I think there is another bug in this
function.  'np' is not released when the function finishes
successfully.   I've looked at other functions that use
irq_alloc_host(), and most of them do the same thing: they don't call
of_node_put() on the device node pointer.  The only exception I've
found is mpc5121_ads_cpld_pic_init().

Ben, Kumar: am I missing something?  irq_alloc_host() calls of_node_get():

	host->of_node = of_node_get(of_node);

so doesn't that mean that the caller of irq_alloc_host() should
release the device node pointer?

-- 
Timur Tabi
Linux kernel developer at Freescale
