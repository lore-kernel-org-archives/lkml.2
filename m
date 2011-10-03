Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab1JCEPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 00:15:54 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55143 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab1JCEPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 00:15:51 -0400
Message-ID: <4E8936F4.5060506@lwfinger.net>
Date: Sun, 02 Oct 2011 23:15:48 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110922 Thunderbird/7.0
MIME-Version: 1.0
To: Jonathan Nieder <jrnieder@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, git@vger.kernel.org
Subject: Re: unable to resolve reference refs/tags/v3.1-rc8: Success (Re:
 git problem)
References: <4E892483.7070605@lwfinger.net> <20111003035907.GA17134@elie>
In-Reply-To: <20111003035907.GA17134@elie>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2011 10:59 PM, Jonathan Nieder wrote:
> Hi,
>
> Larry Finger wrote:
>
>> I had my system freeze when doing a pull from Linus's repo. Since then,
>> every pull results in the following errors:
>>
>> ~>  git pull
>> error: unable to resolve reference refs/tags/v3.1-rc8: Success
>>  From git://github.com/torvalds/linux
>>   ! [new tag]         v3.1-rc8   ->  v3.1-rc8  (unable to update local ref)
>
> Could you try pulling again with
> "/path/to/git/sources/bin-wrappers/git pull" after applying this
> patch?
>
> Thanks,
>
> diff --git i/refs.c w/refs.c
> index a615043b..b15f78a4 100644
> --- i/refs.c
> +++ w/refs.c
> @@ -493,12 +493,15 @@ const char *resolve_ref(const char *ref, unsigned char *sha1, int reading, int *
>   		char *buf;
>   		int fd;
>
> -		if (--depth<  0)
> +		if (--depth<  0) {
> +			errno = ELOOP;
>   			return NULL;
> +		}
>
>   		git_snpath(path, sizeof(path), "%s", ref);
>   		/* Special case: non-existing file. */
>   		if (lstat(path,&st)<  0) {
> +			int saved_errno = errno;
>   			struct ref_list *list = get_packed_refs(NULL);
>   			while (list) {
>   				if (!strcmp(ref, list->name)) {
> @@ -509,6 +512,7 @@ const char *resolve_ref(const char *ref, unsigned char *sha1, int reading, int *
>   				}
>   				list = list->next;
>   			}
> +			errno = saved_errno;
>   			if (reading || errno != ENOENT)
>   				return NULL;
>   			hashclr(sha1);
> @@ -562,7 +566,8 @@ const char *resolve_ref(const char *ref, unsigned char *sha1, int reading, int *
>   			*flag |= REF_ISSYMREF;
>   	}
>   	if (len<  40 || get_sha1_hex(buffer, sha1))
> -		return NULL;
> +		die("ref %s is corrupt: length=%d, content=%.*s", ref,
> +		    (int) len, (int) len, buffer);
>   	return ref;
>   }

After applying that patch, I get

finger@larrylap:~/linux-2.6> ~/git/git pull
fatal: ref refs/tags/v3.1-rc8 is corrupt: length=41, content=

Larry
