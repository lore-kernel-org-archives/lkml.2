Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752Ab1K2VBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 16:01:33 -0500
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:33129 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756694Ab1K2VBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 16:01:30 -0500
Message-ID: <4ED555E4.4000006@xenotime.net>
Date: Tue, 29 Nov 2011 14:00:04 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Paul Moore <pmoore@redhat.com>
CC: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] netlabel: Fix build problems when IPv6 is not enabled
References: <20111129201054.20141.86401.stgit@sifl>
In-Reply-To: <20111129201054.20141.86401.stgit@sifl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2011 12:10 PM, Paul Moore wrote:
> A recent fix to the the NetLabel code caused build problem with
> configurations that did not have IPv6 enabled; see below:
> 
>  netlabel_kapi.c: In function 'netlbl_cfg_unlbl_map_add':
>  netlabel_kapi.c:165:4:
>   error: implicit declaration of function 'netlbl_af6list_add'
> 
> This patch fixes this problem by making the IPv6 specific code conditional
> on the IPv6 configuration flags as we done in the rest of NetLabel and the
> network stack as a whole.  We have to move some variable declarations
> around as a result so things may not be quite as pretty, but at least it
> builds cleanly now.
> 
> Some additional IPv6 conditionals were added to the NetLabel code as well
> for the sake of consistency.
> 
> Reported-by: Randy Dunlap <rdunlap@xenotime.net>
> Signed-off-by: Paul Moore <pmoore@redhat.com>

Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

> ---
>  net/netlabel/netlabel_kapi.c |   22 ++++++++++++++--------
>  1 files changed, 14 insertions(+), 8 deletions(-)
> 
> diff --git a/net/netlabel/netlabel_kapi.c b/net/netlabel/netlabel_kapi.c
> index 3735297..5952237 100644
> --- a/net/netlabel/netlabel_kapi.c
> +++ b/net/netlabel/netlabel_kapi.c
> @@ -111,8 +111,6 @@ int netlbl_cfg_unlbl_map_add(const char *domain,
>  	struct netlbl_domaddr_map *addrmap = NULL;
>  	struct netlbl_domaddr4_map *map4 = NULL;
>  	struct netlbl_domaddr6_map *map6 = NULL;
> -	const struct in_addr *addr4, *mask4;
> -	const struct in6_addr *addr6, *mask6;
>  
>  	entry = kzalloc(sizeof(*entry), GFP_ATOMIC);
>  	if (entry == NULL)
> @@ -133,9 +131,9 @@ int netlbl_cfg_unlbl_map_add(const char *domain,
>  		INIT_LIST_HEAD(&addrmap->list6);
>  
>  		switch (family) {
> -		case AF_INET:
> -			addr4 = addr;
> -			mask4 = mask;
> +		case AF_INET: {
> +			const struct in_addr *addr4 = addr;
> +			const struct in_addr *mask4 = mask;
>  			map4 = kzalloc(sizeof(*map4), GFP_ATOMIC);
>  			if (map4 == NULL)
>  				goto cfg_unlbl_map_add_failure;
> @@ -148,9 +146,11 @@ int netlbl_cfg_unlbl_map_add(const char *domain,
>  			if (ret_val != 0)
>  				goto cfg_unlbl_map_add_failure;
>  			break;
> -		case AF_INET6:
> -			addr6 = addr;
> -			mask6 = mask;
> +			}
> +#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
> +		case AF_INET6: {
> +			const struct in6_addr *addr6 = addr;
> +			const struct in6_addr *mask6 = mask;
>  			map6 = kzalloc(sizeof(*map6), GFP_ATOMIC);
>  			if (map6 == NULL)
>  				goto cfg_unlbl_map_add_failure;
> @@ -167,6 +167,8 @@ int netlbl_cfg_unlbl_map_add(const char *domain,
>  			if (ret_val != 0)
>  				goto cfg_unlbl_map_add_failure;
>  			break;
> +			}
> +#endif /* IPv6 */
>  		default:
>  			goto cfg_unlbl_map_add_failure;
>  			break;
> @@ -225,9 +227,11 @@ int netlbl_cfg_unlbl_static_add(struct net *net,
>  	case AF_INET:
>  		addr_len = sizeof(struct in_addr);
>  		break;
> +#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
>  	case AF_INET6:
>  		addr_len = sizeof(struct in6_addr);
>  		break;
> +#endif /* IPv6 */
>  	default:
>  		return -EPFNOSUPPORT;
>  	}
> @@ -266,9 +270,11 @@ int netlbl_cfg_unlbl_static_del(struct net *net,
>  	case AF_INET:
>  		addr_len = sizeof(struct in_addr);
>  		break;
> +#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
>  	case AF_INET6:
>  		addr_len = sizeof(struct in6_addr);
>  		break;
> +#endif /* IPv6 */
>  	default:
>  		return -EPFNOSUPPORT;
>  	}
> 


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
