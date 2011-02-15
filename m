Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab1BOJUo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 04:20:44 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55962 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454Ab1BOJUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 04:20:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=xqhXL2H21psuPxfJx9QfDDhwuB5eQ9SY28zohq+4/5z8KLYkm8tjtM9aT4pFY24ZN9
         p2/2YOC3/OTMkiHow2719/s+zuosHYs9kBsLka2xLBwvIlTPkJ0/XDN96E6wQWPgXwfD
         rPFB16CdCuK25/GGbzolA5GaEvCfBtg55mGNk=
Message-ID: <4D5A4565.5030501@gmail.com>
Date: Tue, 15 Feb 2011 10:20:37 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: "K. Y. Srinivasan" <kys@microsoft.com>
CC: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Subject: Re: [PATCH 2/3]: Staging: hv: Use native wait primitives
References: <1297447183-21807-1-git-send-email-kys@microsoft.com>
In-Reply-To: <1297447183-21807-1-git-send-email-kys@microsoft.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2011 06:59 PM, K. Y. Srinivasan wrote:
> In preperation for getting rid of the osd layer; change
> the code to use native wait interfaces. As part of this,
> fixed the buggy implementation in the osd_wait_primitive
> where the condition was cleared potentially after the 
> condition was signalled.
...
> @@ -566,7 +567,11 @@ int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
>  
>  		}
>  	}
> -	osd_waitevent_wait(msginfo->waitevent);
> +	wait_event_timeout(msginfo->waitevent,
> +				msginfo->wait_condition,
> +				msecs_to_jiffies(1000));
> +	BUG_ON(msginfo->wait_condition == 0);

The added BUG_ONs all over the code look scary. These shouldn't be
BUG_ONs at all. You should maybe warn and bail out, but not kill the
whole machine.

And looking at the code, more appropriate would be completion instead of
wait events.

And msecs_to_jiffies(1000) == HZ.

> @@ -689,7 +693,8 @@ static void vmbus_ongpadl_torndown(
>  				memcpy(&msginfo->response.gpadl_torndown,
>  				       gpadl_torndown,
>  				       sizeof(struct vmbus_channel_gpadl_torndown));
> -				osd_waitevent_set(msginfo->waitevent);
> +				msginfo->wait_condition = 1;
> +				wake_up(&msginfo->waitevent);
>  				break;
>  			}
>  		}
> @@ -730,7 +735,8 @@ static void vmbus_onversion_response(
>  			memcpy(&msginfo->response.version_response,
>  			      version_response,
>  			      sizeof(struct vmbus_channel_version_response));
> -			osd_waitevent_set(msginfo->waitevent);
> +			msginfo->wait_condition = 1;
> +			wake_up(&msginfo->waitevent);
>  		}
>  	}
>  	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);

regards,
-- 
js
