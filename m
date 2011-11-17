Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab1KQBnW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 20:43:22 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35413 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855Ab1KQBnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 20:43:20 -0500
MIME-Version: 1.0
In-Reply-To: <7182ad277085740c360a17865326058779b101de.1321492611.git.david.decotigny@google.com>
References: <cover.1321492611.git.david.decotigny@google.com> <7182ad277085740c360a17865326058779b101de.1321492611.git.david.decotigny@google.com>
From: David Decotigny <david.decotigny@google.com>
Date: Wed, 16 Nov 2011 17:42:57 -0800
Message-ID: <CAG88wWYbHoz759rGpPLAdiZUAU+gLwSSCBUjqDbucftXcGr77A@mail.gmail.com>
Subject: Re: [PATCH FIX net v1] net-e1000e: Fix default interrupt throttle
 rate not set in NIC HW
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        David Decotigny <david.decotigny@google.com>,
        Ying Cai <ycai@google.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pAH1hWV7001598

Sorry, I realized that the same fix could be applied to e1000. Sending
an updated v2 patch shortly...

--
David Decotigny



On Wed, Nov 16, 2011 at 5:18 PM, David Decotigny
<david.decotigny@google.com> wrote:
> From: Ying Cai <ycai@google.com>
>
> This change ensures that the itr/itr_setting adjustment logic is used,
> even for the default/compiled-in value.
>
> Context:
>  When we changed the default InterruptThrottleRate value from default
>  (3 = dynamic mode) to 8000 for example, only adapter->itr_setting
>  (which controls interrupt coalescing mode) was set to 8000, but
>  adapter->itr (which controls the value set in NIC register) was not
>  updated accordingly. So from ethtool, it seemed the interrupt
>  throttling is enabled at 8000 intr/s, but the NIC actually was
>  running in dynamic mode which has lower CPU efficiency especially
>  when throughput is not high.
>
>
>
> Signed-off-by: David Decotigny <david.decotigny@google.com>
> ---
>  drivers/net/ethernet/intel/e1000e/param.c |   98 +++++++++++++++-------------
>  1 files changed, 52 insertions(+), 46 deletions(-)
>
> diff --git a/drivers/net/ethernet/intel/e1000e/param.c b/drivers/net/ethernet/intel/e1000e/param.c
> index 20e93b0..41937e5 100644
> --- a/drivers/net/ethernet/intel/e1000e/param.c
> +++ b/drivers/net/ethernet/intel/e1000e/param.c
> @@ -106,7 +106,7 @@ E1000_PARAM(RxAbsIntDelay, "Receive Absolute Interrupt Delay");
>  /*
>  * Interrupt Throttle Rate (interrupts/sec)
>  *
> - * Valid Range: 100-100000 (0=off, 1=dynamic, 3=dynamic conservative)
> + * Valid Range: 100-100000 or one of: 0=off, 1=dynamic, 3=dynamic conservative
>  */
>  E1000_PARAM(InterruptThrottleRate, "Interrupt Throttling Rate");
>  #define DEFAULT_ITR 3
> @@ -335,53 +335,59 @@ void __devinit e1000e_check_options(struct e1000_adapter *adapter)
>
>                if (num_InterruptThrottleRate > bd) {
>                        adapter->itr = InterruptThrottleRate[bd];
> -                       switch (adapter->itr) {
> -                       case 0:
> -                               e_info("%s turned off\n", opt.name);
> -                               break;
> -                       case 1:
> -                               e_info("%s set to dynamic mode\n", opt.name);
> -                               adapter->itr_setting = adapter->itr;
> -                               adapter->itr = 20000;
> -                               break;
> -                       case 3:
> -                               e_info("%s set to dynamic conservative mode\n",
> -                                       opt.name);
> -                               adapter->itr_setting = adapter->itr;
> -                               adapter->itr = 20000;
> -                               break;
> -                       case 4:
> -                               e_info("%s set to simplified (2000-8000 ints) "
> -                                      "mode\n", opt.name);
> -                               adapter->itr_setting = 4;
> -                               break;
> -                       default:
> -                               /*
> -                                * Save the setting, because the dynamic bits
> -                                * change itr.
> -                                */
> -                               if (e1000_validate_option(&adapter->itr, &opt,
> -                                                         adapter) &&
> -                                   (adapter->itr == 3)) {
> -                                       /*
> -                                        * In case of invalid user value,
> -                                        * default to conservative mode.
> -                                        */
> -                                       adapter->itr_setting = adapter->itr;
> -                                       adapter->itr = 20000;
> -                               } else {
> -                                       /*
> -                                        * Clear the lower two bits because
> -                                        * they are used as control.
> -                                        */
> -                                       adapter->itr_setting =
> -                                               adapter->itr & ~3;
> -                               }
> -                               break;
> -                       }
> +
> +                       /* Make sure a message is printed for
> +                        * non-special values. And in case of an
> +                        * invalid option, display warning, use
> +                        * default and go through itr/itr_setting
> +                        * adjustment logic below */
> +                       if ((adapter->itr < 0 || adapter->itr > 4)
> +                           && e1000_validate_option(&adapter->itr, &opt,
> +                                                    adapter))
> +                               adapter->itr = opt.def;
>                } else {
> -                       adapter->itr_setting = opt.def;
> +                       /* if no option specified, use default value
> +                          and go through the logic below to adjust
> +                          itr/itr_setting */
> +                       adapter->itr = opt.def;
> +
> +                       /* Make sure a message is printed for
> +                        * non-special default values */
> +                       if (adapter->itr < 0 || adapter->itr > 4)
> +                               e_info("%s set to default %d\n",
> +                                      opt.name, adapter->itr);
> +               }
> +
> +
> +
> +               adapter->itr_setting = adapter->itr;
> +               switch (adapter->itr) {
> +               case 0:
> +                       e_info("%s turned off\n", opt.name);
> +                       break;
> +               case 1:
> +                       e_info("%s set to dynamic mode\n", opt.name);
> +                       adapter->itr = 20000;
> +                       break;
> +               case 3:
> +                       e_info("%s set to dynamic conservative mode\n",
> +                              opt.name);
>                        adapter->itr = 20000;
> +                       break;
> +               case 4:
> +                       e_info("%s set to simplified (2000-8000 ints) "
> +                              "mode\n", opt.name);
> +                       break;
> +               default:
> +                       /*
> +                        * Save the setting, because the dynamic bits
> +                        * change itr.
> +                        *
> +                        * Clear the lower two bits because
> +                        * they are used as control.
> +                        */
> +                       adapter->itr_setting &= ~3;
> +                       break;
>                }
>        }
>        { /* Interrupt Mode */
> --
> 1.7.3.1
>
>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
