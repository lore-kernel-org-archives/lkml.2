Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab1AGEI6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 23:08:58 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36361 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957Ab1AGEI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 23:08:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=aUTDfsgQxqAP5omYjJp5VAc4T7or1STiDkXjK6Cp2DqS+3G86llD+Ui/OfB4CRBwf+
         25P4d1EtieUtpftrsQYf386KkCJjZxLCsDfDd/0c44UuRXkOGCb4umixneqWtUIEbg3D
         xb20lBy1fGwRleZC3MtDzRCtvMW8K0AA0qkMs=
Message-ID: <4D2691D4.3060304@gmail.com>
Date: Thu, 06 Jan 2011 23:08:52 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eric Dumazet <eric.dumazet@gmail.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [058/152] tcp: protect sysctl_tcp_cookie_size reads
References: <20110106002302.141581701@clark.site>
In-Reply-To: <20110106002302.141581701@clark.site>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for bringing this to my attention.  There's been quite a few
changes in the 18 months since this function was originally written.

The overall purpose of the patch seems OK, although most of the patch
has nothing to do with the purported fix.

That is, somebody preferred to alter conditions and remove braces.  Seems
harder to read to me!  I'm surprised that this passed checkpatch.pl?


On 1/5/11 7:22 PM, Greg KH wrote:
> 2.6.36-stable review patch.  If anyone has any objections, please let us know.
>
> ------------------
>
>
> From: Eric Dumazet<eric.dumazet@gmail.com>
>
> [ Upstream commit f19872575ff7819a3723154657a497d9bca66b33 ]
>
> Make sure sysctl_tcp_cookie_size is read once in
> tcp_cookie_size_check(), or we might return an illegal value to caller
> if sysctl_tcp_cookie_size is changed by another cpu.
>
> Signed-off-by: Eric Dumazet<eric.dumazet@gmail.com>
> Cc: Ben Hutchings<bhutchings@solarflare.com>
> Cc: William Allen Simpson<william.allen.simpson@gmail.com>
> Signed-off-by: David S. Miller<davem@davemloft.net>
> Signed-off-by: Greg Kroah-Hartman<gregkh@suse.de>
> ---
>   net/ipv4/tcp_output.c |   27 +++++++++++++++------------
>   1 file changed, 15 insertions(+), 12 deletions(-)
>
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -391,27 +391,30 @@ struct tcp_out_options {
>    */
>   static u8 tcp_cookie_size_check(u8 desired)
>   {
> -	if (desired>  0) {
> +	int cookie_size;
> +
> +	if (desired>  0)
>   		/* previously specified */
>   		return desired;
> -	}
> -	if (sysctl_tcp_cookie_size<= 0) {
> +
> +	cookie_size = ACCESS_ONCE(sysctl_tcp_cookie_size);
> +	if (cookie_size<= 0)
>   		/* no default specified */
>   		return 0;
> -	}
> -	if (sysctl_tcp_cookie_size<= TCP_COOKIE_MIN) {
> +
> +	if (cookie_size<= TCP_COOKIE_MIN)
>   		/* value too small, specify minimum */
>   		return TCP_COOKIE_MIN;
> -	}
> -	if (sysctl_tcp_cookie_size>= TCP_COOKIE_MAX) {
> +
> +	if (cookie_size>= TCP_COOKIE_MAX)
>   		/* value too large, specify maximum */
>   		return TCP_COOKIE_MAX;
> -	}
> -	if (0x1&  sysctl_tcp_cookie_size) {
> +
> +	if (cookie_size&  1)
>   		/* 8-bit multiple, illegal, fix it */
> -		return (u8)(sysctl_tcp_cookie_size + 0x1);
> -	}
> -	return (u8)sysctl_tcp_cookie_size;
> +		cookie_size++;
> +
> +	return (u8)cookie_size;
>   }
>
>   /* Write previously computed TCP options to the packet.
>
>
>

