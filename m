Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab1IVV3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 17:29:20 -0400
Received: from cobra.newdream.net ([66.33.216.30]:43121 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911Ab1IVV3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 17:29:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=newdream.net; h=date:from:to:cc
	:subject:in-reply-to:message-id:references:mime-version:
	content-type; q=dns; s=newdream.net; b=iH0EKEarGrfZkNmVmPJKv1owU
	twbOD7cTXbZMgEZYYY7U/W3YTrC08kPgEvl47a0h/NA1vnjHfFogOiE9r/yK84tF
	1BVjYK3NtTzVgaIWwghflg7TycwLiE0I+KEsgwEG8HMiSSXEAJUpZLx9sVEr/5Hz
	4C9dotBX9yh4o/m1Zs=
Date: Thu, 22 Sep 2011 14:29:14 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Noah Watkins <noahwatkins@gmail.com>
cc: ceph-devel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ceph: use kernel DNS resolver
In-Reply-To: <CAB2gnbVw2_FSWVVmUA1OobE1Ti9Q1w3AP_67=Vo4zwZtQ=gHYg@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1109221426310.19558@cobra.newdream.net>
References: <CAB2gnbVw2_FSWVVmUA1OobE1Ti9Q1w3AP_67=Vo4zwZtQ=gHYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Noah,

On Thu, 22 Sep 2011, Noah Watkins wrote:
> Change ceph_parse_ips to take either names given as
> IP addresses or standard hostnames (e.g. localhost).
> The DNS lookup is done using the dns_resolver facility
> similar to its use in AFS, NFS, and CIFS.

Currently the dns resolution is handled by mount.ceph and 'rbd map/unmap'.  
I don't think that will go away (at the very least need to support old 
kernels).  

Allowing this in the raw kernel interface would be nice, but I don't think 
we want make DNS_RESOLVER a strict dependency, since it's new, kind of 
kludgey, and a ripe target for compiling out of small or secure kernels.  
Can you make it build either with or without it?

Thanks!
sage


> 
> Signed-off-by: Noah Watkins <noahwatkins@gmail.com>
> ---
>  net/ceph/Kconfig     |    1 +
>  net/ceph/messenger.c |  106 ++++++++++++++++++++++++++++++++++++++++++++------
>  2 files changed, 95 insertions(+), 12 deletions(-)
> 
> diff --git a/net/ceph/Kconfig b/net/ceph/Kconfig
> index be683f2..aac5fc8 100644
> --- a/net/ceph/Kconfig
> +++ b/net/ceph/Kconfig
> @@ -5,6 +5,7 @@ config CEPH_LIB
>  	select CRYPTO_AES
>  	select CRYPTO
>  	select KEYS
> +	select DNS_RESOLVER
>  	default n
>  	help
>  	  Choose Y or M here to include cephlib, which provides the
> diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
> index c340e2e..c22aa58 100644
> --- a/net/ceph/messenger.c
> +++ b/net/ceph/messenger.c
> @@ -11,6 +11,7 @@
>  #include <linux/string.h>
>  #include <linux/bio.h>
>  #include <linux/blkdev.h>
> +#include <linux/dns_resolver.h>
>  #include <net/tcp.h>
> 
>  #include <linux/ceph/libceph.h>
> @@ -1078,6 +1079,93 @@ static void addr_set_port(struct
> sockaddr_storage *ss, int p)
>  }
> 
>  /*
> + * Unlike other *_pton function semantics, zero indicates success.
> + */
> +static int ceph_pton(const char *str, size_t len, struct sockaddr_storage *ss,
> +		char delim, const char **ipend)
> +{
> +	struct sockaddr_in *in4 = (void *)ss;
> +	struct sockaddr_in6 *in6 = (void *)ss;
> +
> +	memset(ss, 0, sizeof(*ss));
> +
> +	if (in4_pton(str, len, (u8 *)&in4->sin_addr.s_addr, delim, ipend)) {
> +		ss->ss_family = AF_INET;
> +		return 0;
> +	}
> +
> +	if (in6_pton(str, len, (u8 *)&in6->sin6_addr.s6_addr, delim, ipend)) {
> +		ss->ss_family = AF_INET6;
> +		return 0;
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +/*
> + * Extract hostname string and resolve using kernel DNS facility.
> + */
> +static int ceph_dns_resolve_name(const char *name, size_t namelen,
> +			struct sockaddr_storage *ss, char delim, const char **ipend)
> +{
> +	const char *end, *delim_p;
> +	char *colon_p, *ip_addr = NULL;
> +	int ip_len, ret;
> +
> +	/*
> +	 * The end of the hostname occurs immediately preceding the delimiter or
> +	 * the port marker (':') where the delimiter takes precedence.
> +	 */
> +	delim_p = memchr(name, delim, namelen);
> +	colon_p = memchr(name, ':', namelen);
> +
> +	if (delim_p && colon_p)
> +		end = delim_p < colon_p ? delim_p : colon_p;
> +	else if (!delim_p && colon_p)
> +		end = colon_p;
> +	else {
> +		end = delim_p;
> +		if (!end) /* case: hostname:/ */
> +			end = name + namelen;
> +	}
> +
> +	if (end <= name)
> +		return -EINVAL;
> +
> +	/* do dns_resolve upcall */
> +	ip_len = dns_query(NULL, name, end - name, NULL, &ip_addr, NULL);
> +	if (ip_len > 0)
> +		ret = ceph_pton(ip_addr, ip_len, ss, -1, NULL);
> +	else
> +		ret = -ESRCH;
> +
> +	kfree(ip_addr);
> +
> +	*ipend = end;
> +
> +	pr_info("resolve '%.*s' (ret=%d): %s\n", (int)(end - name), name,
> +			ret, ret ? "failed" : ceph_pr_addr(ss));
> +
> +	return ret;
> +}
> +
> +/*
> + * Parse a server name (IP or hostname). If a valid IP address is not found
> + * then try to extract a hostname to resolve using userspace DNS upcall.
> + */
> +static int ceph_parse_server_name(const char *name, size_t namelen,
> +			struct sockaddr_storage *ss, char delim, const char **ipend)
> +{
> +	int ret;
> +
> +	ret = ceph_pton(name, namelen, ss, delim, ipend);
> +	if (ret)
> +		ret = ceph_dns_resolve_name(name, namelen, ss, delim, ipend);
> +
> +	return ret;
> +}
> +
> +/*
>   * Parse an ip[:port] list into an addr array.  Use the default
>   * monitor port if a port isn't specified.
>   */
> @@ -1085,15 +1173,13 @@ int ceph_parse_ips(const char *c, const char *end,
>  		   struct ceph_entity_addr *addr,
>  		   int max_count, int *count)
>  {
> -	int i;
> +	int i, ret = -EINVAL;
>  	const char *p = c;
> 
>  	dout("parse_ips on '%.*s'\n", (int)(end-c), c);
>  	for (i = 0; i < max_count; i++) {
>  		const char *ipend;
>  		struct sockaddr_storage *ss = &addr[i].in_addr;
> -		struct sockaddr_in *in4 = (void *)ss;
> -		struct sockaddr_in6 *in6 = (void *)ss;
>  		int port;
>  		char delim = ',';
> 
> @@ -1102,15 +1188,11 @@ int ceph_parse_ips(const char *c, const char *end,
>  			p++;
>  		}
> 
> -		memset(ss, 0, sizeof(*ss));
> -		if (in4_pton(p, end - p, (u8 *)&in4->sin_addr.s_addr,
> -			     delim, &ipend))
> -			ss->ss_family = AF_INET;
> -		else if (in6_pton(p, end - p, (u8 *)&in6->sin6_addr.s6_addr,
> -				  delim, &ipend))
> -			ss->ss_family = AF_INET6;
> -		else
> +		ret = ceph_parse_server_name(p, end - p, ss, delim, &ipend);
> +		if (ret)
>  			goto bad;
> +		ret = -EINVAL;
> +
>  		p = ipend;
> 
>  		if (delim == ']') {
> @@ -1155,7 +1237,7 @@ int ceph_parse_ips(const char *c, const char *end,
> 
>  bad:
>  	pr_err("parse_ips bad ip '%.*s'\n", (int)(end - c), c);
> -	return -EINVAL;
> +	return ret;
>  }
>  EXPORT_SYMBOL(ceph_parse_ips);
> 
> -- 
> 1.7.6.1
> --
> To unsubscribe from this list: send the line "unsubscribe ceph-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
