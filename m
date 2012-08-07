Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab2HGKr6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 06:47:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697Ab2HGKr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 06:47:57 -0400
Date: Tue, 7 Aug 2012 06:47:52 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Frediano Ziglio <frediano.ziglio@citrix.com>
Cc: "sfrench@samba.org" <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] Convert properly UTF-8 to UTF-16
Message-ID: <20120807064752.22e0da81@corrin.poochiereds.net>
In-Reply-To: <7CE799CC0E4DE04B88D5FDF226E18AC2CDFFB08D16@LONPMAILBOX01.citrite.net>
References: <7CE799CC0E4DE04B88D5FDF226E18AC2CDFFB08D16@LONPMAILBOX01.citrite.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Aug 2012 10:33:03 +0100
Frediano Ziglio <frediano.ziglio@citrix.com> wrote:

> 
> wchar_t is currently 16bit so converting a utf8 encoded characters not
> in plane 0 (>= 0x10000) to wchar_t (that is calling char2uni) lead to a
> -EINVAL return. This patch detect utf8 in cifs_strtoUTF16 and add special
> code calling utf8s_to_utf16s.
> 
> Signed-off-by: Frediano Ziglio <frediano.ziglio@citrix.com>
> ---
>  fs/cifs/cifs_unicode.c |   22 ++++++++++++++++++++++
>  1 files changed, 22 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
> index 7dab9c0..1166b95 100644
> --- a/fs/cifs/cifs_unicode.c
> +++ b/fs/cifs/cifs_unicode.c
> @@ -203,6 +203,27 @@ cifs_strtoUTF16(__le16 *to, const char *from, int len,
>  	int i;
>  	wchar_t wchar_to; /* needed to quiet sparse */
>  
> +	/* special case for utf8 to handle no plane0 chars */
> +	if (!strcmp(codepage->charset, "utf8")) {
> +		/*
> +		 * convert utf8 -> utf16, we assume we have enough space
> +		 * as caller should have assumed conversion does not overflow
> +		 * in destination len is length in wchar_t units (16bits)
> +		 */
> +		i  = utf8s_to_utf16s(from, len, UTF16_LITTLE_ENDIAN,
> +				       (wchar_t *) to, len);
> +
> +		/* if success terminate and exit */
> +		if (i >= 0)
> +			goto success;
> +		/*
> +		 * if fails fall back to UCS encoding as this
> +		 * function should not return negative values
> +		 * currently can fail only if source contains
> +		 * invalid encoded characters
> +		 */
> +	}
> +
>  	for (i = 0; len && *from; i++, from += charlen, len -= charlen) {
>  		charlen = codepage->char2uni(from, len, &wchar_to);
>  		if (charlen < 1) {
> @@ -215,6 +236,7 @@ cifs_strtoUTF16(__le16 *to, const char *from, int len,
>  		put_unaligned_le16(wchar_to, &to[i]);
>  	}
>  
> +success:
>  	put_unaligned_le16(0, &to[i]);
>  	return i;
>  }

Looks reasonable...

Acked-by: Jeff Layton <jlayton@redhat.com>
