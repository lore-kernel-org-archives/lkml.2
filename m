Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766Ab1BXRdu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 12:33:50 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:54590 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243Ab1BXRdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 12:33:45 -0500
Date: Thu, 24 Feb 2011 09:33:41 -0800
From: Andres Salomon <dilinger@queued.net>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: dsd@laptop.org, sparclinux@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net
Subject: Re: [PATCH v5] of/promtree: allow DT device matching by fixing
 'name' brokenness
Message-ID: <20110224093341.5a809a13@queued.net>
In-Reply-To: <20110224165917.3760.24493.stgit@localhost6.localdomain6>
References: <20110224165917.3760.24493.stgit@localhost6.localdomain6>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Feb 2011 10:04:41 -0700
Grant Likely <grant.likely@secretlab.ca> wrote:

> From: Andres Salomon <dilinger@queued.net>
> 
> Commit e2f2a93b, "of/promtree: add package-to-path support to pdt"
> changed dp->name from using the 'name' property to using
> package-to-path.  This fixed /proc/device-tree creation by eliminating
> conflicts between names (the 'name' property provides names like
> 'battery', whereas package-to-path provides names like
> '/foo/bar/battery@0', which we stripped to 'battery@0').  However, it
> also breaks of_device_id table matching.
> 
> The fix that we _really_ wanted was to keep dp->name based upon
> the name property ('battery'), but based dp->full_name upon
> package-to-path ('battery@0').  This patch does just that.
> 
> This changes all users (except SPARC) of promtree to use the full
> result from package-to-path for full_name, rather than stripping the
> directory out.  In practice, the strings end up being exactly the
> same; this change saves time, code, and memory.
> 
> SPARC continues to use the existing build_path_component() code.
> 
> v2: combine two patches and revert of_pdt_node_name to original
> version v3: use dp->phandle instead of passing around node
> v4: warn/bail out for non-sparc archs if pkg2path is not set
> v5: split of_pdt_build_full_name into sparc & non-sparc versions
>     BUG() when pkg2path doesn't work.
> 
> Signed-off-by: Andres Salomon <dilinger@queued.net>
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---
> 
> Hi Andres,
> 
> This is what I think the patch should really look like.  The
> of_pdt_node_name() stuff really doesn't make sense to keep around
> because what we *really* care about is the full name, not the path
> component name.  Therefore I reorganized it so SPARC continues to use
> it's build_path_component() to build up the full path; but everyone
> else *must* provide a working mechanism to obtain the full path; be it
> an actual call to OFW pkg2path, or something else.
> 
> Please take a look at let me know what you think.
> 
> g.
> 
>  drivers/of/pdt.c |  110
> ++++++++++++++++++++---------------------------------- 1 files
> changed, 40 insertions(+), 70 deletions(-)
> 
> diff --git a/drivers/of/pdt.c b/drivers/of/pdt.c
> index 28295d0..ab54819 100644
> --- a/drivers/of/pdt.c
> +++ b/drivers/of/pdt.c
> @@ -36,19 +36,53 @@ unsigned int of_pdt_unique_id __initdata;
>  	(p)->unique_id = of_pdt_unique_id++; \
>  } while (0)
>  
> -static inline const char *of_pdt_node_name(struct device_node *dp)
> +static char * __init of_pdt_build_full_name(struct device_node *dp)
>  {
> -	return dp->path_component_name;
> +	int len, ourlen, plen;
> +	char *n;
> +
> +	dp->path_component_name = build_path_component(dp);
> +
> +	plen = strlen(dp->parent->full_name);
> +	ourlen = strlen(dp->path_component_name);
> +	len = ourlen + plen + 2;
> +
> +	n = prom_early_alloc(len);
> +	strcpy(n, dp->parent->full_name);
> +	if (!of_node_is_root(dp->parent)) {
> +		strcpy(n + plen, "/");
> +		plen++;
> +	}
> +	strcpy(n + plen, dp->path_component_name);
> +
> +	return n;
>  }

Sure, this part is fine.  The reason why this was originally in 2
separate patches (and what I'd been attempting to do all along) was to
keep the bugfix portion of it to a minimal size, and to have a separate
generic cleanup patch that changed around more stuff.


>  
> -#else
> +#else /* CONFIG_SPARC */
>  
>  static inline void of_pdt_incr_unique_id(void *p) { }
>  static inline void irq_trans_init(struct device_node *dp) { }
>  
> -static inline const char *of_pdt_node_name(struct device_node *dp)
> +static char * __init of_pdt_build_full_name(struct device_node *dp)
>  {
> -	return dp->name;
> +	char *buf;
> +	int len;
> +
> +	if (!of_pdt_prom_ops->pkg2path)
> +		BUG();

I'd rather see WARN_ON() here.  Our options if any of
this fail are to BUG (causing bootup to fail, most likely), WARN and
return NULL (causing the DT creation to not happen, which may affect
things differently depending upon what the DT is being used for), or
WARN and return dp->name (which would cause the DT to be created,
albeit not correctly.  The more I think about it, the more I like that
last option.  If the DT is being used for booting, that option would
provide the best attempt at actually booting up.



> +
> +	if (of_pdt_prom_ops->pkg2path(dp->phandle, buf, 0, &len))
> +		BUG();

Well, no, if pkg2path fails, we shouldn't really BUG().  There may be
some reason why the call fails for only a particular node (for
example, perhaps an invalid phandle gets passed, or there's a bug in
the firmware for that particular node).  I'd rather disable the DT or
just disable the node and have the machine at least bring up a
framebuffer console with kernel logs showing some kind of warning/error
message.



> +
> +	buf = prom_early_alloc(len + 1);
> +	if (!buf)
> +		BUG();

Ditto.

> +
> +	if (of_pdt_prom_ops->pkg2path(dp->phandle, buf, len, &len)) {
> +		pr_err("%s: package-to-path failed\n", __func__);
> +		BUG();
> +	}
> +	return buf;
>  }
>  
>  #endif /* !CONFIG_SPARC */
> @@ -132,47 +166,6 @@ static char * __init
> of_pdt_get_one_property(phandle node, const char *name) return buf;
>  }
>  
> -static char * __init of_pdt_try_pkg2path(phandle node)
> -{
> -	char *res, *buf = NULL;
> -	int len;
> -
> -	if (!of_pdt_prom_ops->pkg2path)
> -		return NULL;
> -
> -	if (of_pdt_prom_ops->pkg2path(node, buf, 0, &len))
> -		return NULL;
> -	buf = prom_early_alloc(len + 1);
> -	if (of_pdt_prom_ops->pkg2path(node, buf, len, &len)) {
> -		pr_err("%s: package-to-path failed\n", __func__);
> -		return NULL;
> -	}
> -
> -	res = strrchr(buf, '/');
> -	if (!res) {
> -		pr_err("%s: couldn't find / in %s\n", __func__, buf);
> -		return NULL;
> -	}
> -	return res+1;
> -}
> -
> -/*
> - * When fetching the node's name, first try using package-to-path; if
> - * that fails (either because the arch hasn't supplied a PROM
> callback,
> - * or some other random failure), fall back to just looking at the
> node's
> - * 'name' property.
> - */
> -static char * __init of_pdt_build_name(phandle node)
> -{
> -	char *buf;
> -
> -	buf = of_pdt_try_pkg2path(node);
> -	if (!buf)
> -		buf = of_pdt_get_one_property(node, "name");
> -
> -	return buf;
> -}
> -
>  static struct device_node * __init of_pdt_create_node(phandle node,
>  						    struct
> device_node *parent) {
> @@ -187,7 +180,7 @@ static struct device_node * __init
> of_pdt_create_node(phandle node, 
>  	kref_init(&dp->kref);
>  
> -	dp->name = of_pdt_build_name(node);
> +	dp->name = of_pdt_get_one_property(node, "name");
>  	dp->type = of_pdt_get_one_property(node, "device_type");
>  	dp->phandle = node;
>  
> @@ -198,26 +191,6 @@ static struct device_node * __init
> of_pdt_create_node(phandle node, return dp;
>  }
>  
> -static char * __init of_pdt_build_full_name(struct device_node *dp)
> -{
> -	int len, ourlen, plen;
> -	char *n;
> -
> -	plen = strlen(dp->parent->full_name);
> -	ourlen = strlen(of_pdt_node_name(dp));
> -	len = ourlen + plen + 2;
> -
> -	n = prom_early_alloc(len);
> -	strcpy(n, dp->parent->full_name);
> -	if (!of_node_is_root(dp->parent)) {
> -		strcpy(n + plen, "/");
> -		plen++;
> -	}
> -	strcpy(n + plen, of_pdt_node_name(dp));
> -
> -	return n;
> -}
> -
>  static struct device_node * __init of_pdt_build_tree(struct
> device_node *parent, phandle node,
>  						   struct
> device_node ***nextp) @@ -240,9 +213,6 @@ static struct device_node *
> __init of_pdt_build_tree(struct device_node *parent, *(*nextp) = dp;
>  		*nextp = &dp->allnext;
>  
> -#if defined(CONFIG_SPARC)
> -		dp->path_component_name = build_path_component(dp);
> -#endif

I do like moving this out of here.

>  		dp->full_name = of_pdt_build_full_name(dp);
>  
>  		dp->child = of_pdt_build_tree(dp,
> 
