Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543Ab1GWBCb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 21:02:31 -0400
Received: from adelie.canonical.com ([91.189.90.139]:59484 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940Ab1GWBCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 21:02:25 -0400
Message-ID: <4E2A1D9A.2090704@canonical.com>
Date: Fri, 22 Jul 2011 18:02:18 -0700
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: djkurtz@chromium.org
CC: dmitry.torokhov@gmail.com, rydberg@euromail.se, rubini@cvml.unipv.it,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        derek.foreman@collabora.co.uk, daniel.stone@collabora.co.uk,
        olofj@chromium.org
Subject: Re: [PATCH 9/9 v2] Input: synaptics - process finger (<=5) transitions
References: <1311169146-20066-1-git-send-email-djkurtz@chromium.org> <1311169146-20066-10-git-send-email-djkurtz@chromium.org>
In-Reply-To: <1311169146-20066-10-git-send-email-djkurtz@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2011 06:39 AM, djkurtz@chromium.org wrote:
> From: Daniel Kurtz <djkurtz@chromium.org>
> 
> Synaptics image sensor touchpads track up to 5 fingers, but only report 2.
> They use a special "TYPE=2" (AGM-CONTACT) packet type that reports
> the number of tracked fingers and which finger is reported in the SGM
> and AGM packets.
> 
> With this new packet type, it is possible to tell userspace when 4 or 5
> fingers are touching.

Maybe I'm blind, but I don't see where the QUADTAP and QUINTAP values
are set in the events. I see where the bits are set during
initialization, but not during use.

> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> ---
>  drivers/input/mouse/synaptics.c |   44 ++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 43 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
> index 893e567..2a1e05f 100644
> --- a/drivers/input/mouse/synaptics.c
> +++ b/drivers/input/mouse/synaptics.c
> @@ -729,6 +729,10 @@ static void synaptics_image_sensor_1f(struct synaptics_data *priv,
>  		synaptics_mt_state_set(mt_state, 0, -1, -1);
>  		priv->mt_state_lost = true;
>  		break;
> +	case 4:
> +	case 5:
> +		/* mt_state was updated by AGM-CONTACT packet */
> +		break;
>  	}
>  }
>  
> @@ -775,6 +779,10 @@ static void synaptics_image_sensor_2f(struct synaptics_data *priv,
>  		synaptics_mt_state_set(mt_state, 0, -1, -1);
>  		priv->mt_state_lost = true;
>  		break;
> +	case 4:
> +	case 5:
> +		/* mt_state was updated by AGM-CONTACT packet */
> +		break;
>  	}
>  }
>  
> @@ -803,6 +811,22 @@ static void synaptics_image_sensor_3f(struct synaptics_data *priv,
>  		break;
>  	case 2:
>  		/*
> +		 * If the AGM previously contained slot 3 or higher, then the
> +		 * newly touching finger is in the lowest available slot.
> +		 *
> +		 * If SGM was previously 1 or higher, then the new SGM is
> +		 * now slot 0 (with a new finger), otherwise, the new finger
> +		 * is now in a hidden slot between 0 and AGM's slot.
> +		 *
> +		 * In all such cases, the SGM now contains slot 0, and the AGM
> +		 * continues to contain the same slot as before.
> +		 */
> +		if (old->agm >= 3) {
> +			synaptics_mt_state_set(mt_state, 3, 0, old->agm);
> +			break;
> +		}
> +
> +		/*
>  		 * After some 3->1 and all 3->2 transitions, we lose track
>  		 * of which slot is reported by sgm and agm.
>  		 *
> @@ -836,9 +860,22 @@ static void synaptics_image_sensor_3f(struct synaptics_data *priv,
>  		 * received AGM-CONTACT packet.
>  		 */
>  		break;
> +
> +	case 4:
> +	case 5:
> +		/* mt_state was updated by AGM-CONTACT packet */
> +		break;
>  	}
>  }
>  
> +/* Handle case where mt_state->count = 4, or = 5 */
> +static void synaptics_image_sensor_45f(struct synaptics_data *priv,
> +				       struct synaptics_mt_state *mt_state)
> +{
> +	/* mt_state was updated correctly by AGM-CONTACT packet */
> +	priv->mt_state_lost = false;
> +}
> +
>  static void synaptics_image_sensor_process(struct psmouse *psmouse,
>  					   struct synaptics_hw_state *sgm)
>  {
> @@ -858,8 +895,10 @@ static void synaptics_image_sensor_process(struct psmouse *psmouse,
>  		synaptics_image_sensor_1f(priv, &mt_state);
>  	else if (sgm->w == 0)
>  		synaptics_image_sensor_2f(priv, &mt_state);
> -	else if (sgm->w == 1)
> +	else if (sgm->w == 1 && mt_state.count <= 3)
>  		synaptics_image_sensor_3f(priv, &mt_state);
> +	else
> +		synaptics_image_sensor_45f(priv, &mt_state);
>  
>  	/* Send resulting input events to user space */
>  	synaptics_report_mt(psmouse, &mt_state, sgm);
> @@ -1078,6 +1117,9 @@ static void set_input_params(struct input_dev *dev, struct synaptics_data *priv)
>  		input_set_abs_params(dev, ABS_MT_PRESSURE, 0, 255, 0, 0);
>  		/* Image sensors can sometimes report per-contact width */
>  		input_set_abs_params(dev, ABS_MT_TOUCH_MAJOR, 4, 15, 0, 0);
> +		/* Image sensors can signal 4 and 5 finger clicks */
> +		__set_bit(BTN_TOOL_QUADTAP, dev->keybit);
> +		__set_bit(BTN_TOOL_QUINTTAP, dev->keybit);
>  	} else if (SYN_CAP_ADV_GESTURE(priv->ext_cap_0c)) {
>  		/* Non-image sensors with AGM use semi-mt */
>  		__set_bit(INPUT_PROP_SEMI_MT, dev->propbit);

