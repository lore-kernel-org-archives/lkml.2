Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab1EFOoA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 10:44:00 -0400
Received: from mx1.vsecurity.com ([209.67.252.12]:64383 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab1EFOn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 10:43:59 -0400
Subject: Re: [PATCH] dccp: handle invalid feature options length
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: Gerrit Renker <gerrit@erg.abdn.ac.uk>
Cc: davem@davemloft.net, dccp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, security@kernel.org
In-Reply-To: <20110506135345.GA3434@gerrit.erg.abdn.ac.uk>
References: <1304688438.29544.16.camel@dan>
	 <20110506135345.GA3434@gerrit.erg.abdn.ac.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 May 2011 10:43:52 -0400
Message-ID: <1304693032.1849.2.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Can you please check again: did you experience this condition, to me it 
> seems the patch is based on reading this code.
> 

I saw this while reading the code.

> In this case, please consider the condition before the switch statement:
> 
>                 /* Check if this isn't a single byte option */
>                 if (opt > DCCPO_MAX_RESERVED) {
>                         if (opt_ptr == opt_end)
>                                 goto out_nonsensical_length;
> 
>                         len = *opt_ptr++;
>                         if (len < 2)
>                                 goto out_nonsensical_length;
>                          
> The described range (DCCPO_CHANGE_L = 32 ... DCCPO_CONFIRM_R = 35) is after DCCPO_MAX_RESERVED = 31,
> so that the above test applies.
> 
> Hence for these option types the len is always at least 1, so that (len - 1) >= 0.
> 

You just missed the important part:

                        if (len < 2)
                                goto out_nonsensical_length;
                        /*
                         * Remove the type and len fields, leaving
                         * just the value size
                         */
                        len     -= 2;

If the len is 2, this check will pass, and the resulting len will be 0,
causing the underflow.

Regards,
Dan

> | --- a/net/dccp/options.c
> | +++ b/net/dccp/options.c
> | @@ -123,6 +123,8 @@ int dccp_parse_options(struct sock *sk, struct dccp_request_sock *dreq,
> |  		case DCCPO_CHANGE_L ... DCCPO_CONFIRM_R:
> |  			if (pkt_type == DCCP_PKT_DATA)      /* RFC 4340, 6 */
> |  				break;
> | +			if (len == 0)
> | +				goto out_invalid_option;
> |  			rc = dccp_feat_parse_options(sk, dreq, mandatory, opt,
> |  						    *value, value + 1, len - 1);
> |  			if (rc)
> | 
> | 
> 
> -- 


