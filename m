Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634Ab1EFOR0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 10:17:26 -0400
Received: from dee.erg.abdn.ac.uk ([139.133.204.82]:53607 "EHLO erg.abdn.ac.uk"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751074Ab1EFORZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 10:17:25 -0400
X-Greylist: delayed 725 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 May 2011 10:17:24 EDT
Date: Fri, 6 May 2011 15:53:45 +0200
From: Gerrit Renker <gerrit@erg.abdn.ac.uk>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: davem@davemloft.net, dccp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, security@kernel.org
Subject: Re: [PATCH] dccp: handle invalid feature options length
Message-ID: <20110506135345.GA3434@gerrit.erg.abdn.ac.uk>
Mail-Followup-To: Gerrit Renker <gerrit@erg.abdn.ac.uk>,
	Dan Rosenberg <drosenberg@vsecurity.com>, davem@davemloft.net,
	dccp@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, security@kernel.org
References: <1304688438.29544.16.camel@dan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304688438.29544.16.camel@dan>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ERG-MailScanner: Found to be clean
X-ERG-MailScanner-From: gerrit@erg.abdn.ac.uk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Dan Rosenberg:
| A length of zero (after subtracting two for the type and len fields) for
| the DCCPO_{CHANGE,CONFIRM}_{L,R} options will cause an underflow due to
| the subtraction.  The subsequent code may read past the end of the
| options value buffer when parsing.  I'm unsure of what the consequences
| of this might be, but it's probably not good.
| 
Can you please check again: did you experience this condition, to me it 
seems the patch is based on reading this code.

In this case, please consider the condition before the switch statement:

                /* Check if this isn't a single byte option */
                if (opt > DCCPO_MAX_RESERVED) {
                        if (opt_ptr == opt_end)
                                goto out_nonsensical_length;

                        len = *opt_ptr++;
                        if (len < 2)
                                goto out_nonsensical_length;
                         
The described range (DCCPO_CHANGE_L = 32 ... DCCPO_CONFIRM_R = 35) is after DCCPO_MAX_RESERVED = 31,
so that the above test applies.

Hence for these option types the len is always at least 1, so that (len - 1) >= 0.

| --- a/net/dccp/options.c
| +++ b/net/dccp/options.c
| @@ -123,6 +123,8 @@ int dccp_parse_options(struct sock *sk, struct dccp_request_sock *dreq,
|  		case DCCPO_CHANGE_L ... DCCPO_CONFIRM_R:
|  			if (pkt_type == DCCP_PKT_DATA)      /* RFC 4340, 6 */
|  				break;
| +			if (len == 0)
| +				goto out_invalid_option;
|  			rc = dccp_feat_parse_options(sk, dreq, mandatory, opt,
|  						    *value, value + 1, len - 1);
|  			if (rc)
| 
| 

-- 
