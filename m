Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab1LDRIo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 12:08:44 -0500
Received: from netrider.rowland.org ([192.131.102.5]:34508 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752861Ab1LDRIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 12:08:42 -0500
Date: Sun, 4 Dec 2011 12:08:41 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Namjae Jeon <linkinjeon@gmail.com>
cc: akpm@linux-foundation.org, <linux-kernel@vger.kernel.org>,
        Ashish Sangwan <ashishsangwan2@gmail.com>
Subject: Re: [PATCH] nls: add surrogate pair support in nls utf8.
In-Reply-To: <1322997454-22955-1-git-send-email-linkinjeon@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1112041201371.32730-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Dec 2011, Namjae Jeon wrote:

> It allows surrogate pair in nls utf8.

That's a pretty brief description.

> --- a/fs/nls/nls_utf8.c
> +++ b/fs/nls/nls_utf8.c
> @@ -30,13 +30,24 @@ static int char2uni(const unsigned char *rawstring, int boundlen, wchar_t *uni)
>  {
>  	int n;
>  	unicode_t u;
> +	u16 *op;
>  
> +	op = uni;
>  	n = utf8_to_utf32(rawstring, boundlen, &u);
> -	if (n < 0 || u > MAX_WCHAR_T) {
> +	if (n < 0 || u > UNICODE_MAX) {
>  		*uni = 0x003f;	/* ? */
>  		return -EINVAL;
>  	}
> -	*uni = (wchar_t) u;
> +
> +	if (u >= PLANE_SIZE) {
> +		u -= PLANE_SIZE;
> +		*op++ = (wchar_t) (SURROGATE_PAIR |
> +		((u >> 10) & SURROGATE_BITS));
> +		*op++ = (wchar_t) (SURROGATE_PAIR |
> +		SURROGATE_LOW | (u & SURROGATE_BITS));
> +		} else
> +			*op++ = (wchar_t) u;
> +
>  	return n;
>  }

Firstly, have you checked whether the callers of this function expect 
to receive back more than one 16-bit value?  Maybe you will overrun 
their buffers by doing this.

Secondly, you shouldn't have to make all these changes.  Just call 
utf8s_to_utf16s(); then all you have to worry about is changing an 
invalid character to a '?'.

Alan Stern

