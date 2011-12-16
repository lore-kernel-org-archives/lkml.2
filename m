Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759691Ab1LPOtP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 09:49:15 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64265 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119Ab1LPOtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 09:49:09 -0500
Message-ID: <4EEB5A60.3090101@lwfinger.net>
Date: Fri, 16 Dec 2011 08:49:04 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Arend van Spriel <arend@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Linville <linville@tuxdriver.com>
Subject: Re: unexpected taint message
References: <4EEB0EFC.5000302@broadcom.com>  (sfid-20111216_102800_182196_AFD2D6CF) <1324038636.3429.1.camel@jlt3.sipsolutions.net>  <4EEB4D61.80602@lwfinger.net>  (sfid-20111216_145414_221850_EED1E4DE) <1324043939.3429.2.camel@jlt3.sipsolutions.net>  <4EEB521A.70602@lwfinger.net> (sfid-20111216_151411_303937_12579E4F) <1324045233.3429.3.camel@jlt3.sipsolutions.net>
In-Reply-To: <1324045233.3429.3.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2011 08:20 AM, Johannes Berg wrote:
> On Fri, 2011-12-16 at 08:13 -0600, Larry Finger wrote:
>
>>> Hmm. I wish OOT didn't disable lockdep, we do a lot of development with
>>> modules OOT because the turnaround is faster/easier (for not so
>>> experienced developers). Worst case we can patch it out of the base
>>> kernel I guess...
>>
>> Me too. Now I understand John's patch entitled "[RFC] modpost: add option to
>> allow external modules to avoid taint". I doubt that it will be allowed
>> upstream, but I think that I will add it as a local commit.
>
> I was thinking more along the lines of this:
>
> --- wireless-testing.orig/kernel/panic.c	2011-12-10 17:32:26.000000000 +0100
> +++ wireless-testing/kernel/panic.c	2011-12-16 15:19:49.000000000 +0100
> @@ -240,8 +240,16 @@ void add_taint(unsigned flag)
>   	 * Also we want to keep up lockdep for staging development and
>   	 * post-warning case.
>   	 */
> -	if (flag != TAINT_CRAP&&  flag != TAINT_WARN&&  __debug_locks_add_taint

off())
> -		printk(KERN_WARNING "Disabling lock debugging due to kernel taint\n");
> +	switch (flag) {
> +	case TAINT_CRAP:
> +	case TAINT_WARN:
> +	case TAINT_OOT_MODULE:
> +		break;
> +	default:
> +		if (__debug_locks_off())
> +			printk(KERN_WARNING
> +			       "Disabling lock debugging due to kernel taint\n");
> +	}
>
>   	set_bit(flag,&tainted_mask);
>   }

Yes. I like this patch a lot. Unfortunately, VirtualBox was a part of the 
decision to add the OOT taint. At least for that reason, this patch would not be 
accepted upstream. It is too bad that the Oracle people fought so hard to keep 
their module from setting TAINT_CRAP the way that GregKH wanted. That would have 
had fewer side effects for me.

Larry
