Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656Ab1HaXbN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 19:31:13 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58286 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab1HaXbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 19:31:10 -0400
Message-ID: <4E5EC3FE.10307@gmail.com>
Date: Thu, 01 Sep 2011 09:30:06 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Mark Salter <msalter@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        ming.lei@canonical.com, stern@rowland.harvard.edu
Subject: Re: [PATCH 01/24] fix default __strnlen_user macro
References: <1314826019-22330-1-git-send-email-msalter@redhat.com> <1314826019-22330-2-git-send-email-msalter@redhat.com>
In-Reply-To: <1314826019-22330-2-git-send-email-msalter@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/11 07:26, Mark Salter wrote:
> The existing __strnlen_user macro simply resolved to strnlen. However, the
> count returned by strnlen_user should include the NULL byte. This patch
> fixes the __strnlen_user macro to include the NULL byte in the count.
>
> Signed-off-by: Mark Salter<msalter@redhat.com>
> ---
>   include/asm-generic/uaccess.h |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/include/asm-generic/uaccess.h b/include/asm-generic/uaccess.h
> index ac68c99..1d0fdf8 100644
> --- a/include/asm-generic/uaccess.h
> +++ b/include/asm-generic/uaccess.h
> @@ -289,7 +289,7 @@ strncpy_from_user(char *dst, const char __user *src, long count)
>    * Return 0 on exception, a value greater than N if too long
>    */
>   #ifndef __strnlen_user
> -#define __strnlen_user strnlen
> +#define __strnlen_user(s, n) (strnlen((s), (n)) + 1)
>   #endif

I don't think this is correct because if you hit maxlen you will add one 
to it. e.g. __strnlen_user("abcd\0", 3) would return 4 instead of 3.

It should probably be something like this:

#define __strnlen_user(s, n) ({		\
	size_t k = strnlen(s, n);	\
	k<  n ? k + 1 : n; })


I wonder if this change will break anything since it has been incorrect 
(according to the comment in uaccess.h at least) for a while. Why does 
__strnlen_user have different semantics to strnlen anway?

~Ryan


