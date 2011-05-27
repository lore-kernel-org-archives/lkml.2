Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733Ab1E0CsG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 22:48:06 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:43723 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab1E0CsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 22:48:03 -0400
Date: Thu, 26 May 2011 20:48:00 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: David Daney <ddaney@caviumnetworks.com>
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v4 2/6] of: Make of_find_node_by_path() traverse
 /aliases for relative paths.
Message-ID: <20110527024800.GE5032@ponder.secretlab.ca>
References: <1305930343-31259-1-git-send-email-ddaney@caviumnetworks.com>
 <1305930343-31259-3-git-send-email-ddaney@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305930343-31259-3-git-send-email-ddaney@caviumnetworks.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 03:25:39PM -0700, David Daney wrote:
> Currently all paths passed to of_find_node_by_path() must begin with a
> '/', indicating a full path to the desired node.
> 
> Augment the look-up code so that if a path does *not* begin with '/',
> the path is used as the name of an /aliases property.  The value of
> this alias is then used as the full node path to be found.
> 
> Signed-off-by: David Daney <ddaney@caviumnetworks.com>
> ---
>  drivers/of/base.c |   48 +++++++++++++++++++++++++++++++++++++++++++++---
>  1 files changed, 45 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index 632ebae..279134b 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -340,22 +340,64 @@ EXPORT_SYMBOL(of_get_next_child);
>  
>  /**
>   *	of_find_node_by_path - Find a node matching a full OF path
> - *	@path:	The full path to match
> + *	@path: Either the full path to match, or if the path does not
> + *	       start with '/', the name of a property of the /aliases
> + *	       node (an alias).  In the case of an alias, the node
> + *	       matching the alias' value will be returned.
>   *
>   *	Returns a node pointer with refcount incremented, use
>   *	of_node_put() on it when done.
>   */
>  struct device_node *of_find_node_by_path(const char *path)
>  {
> -	struct device_node *np = allnodes;
> +	struct device_node *np = NULL;
> +	struct device_node *aliases = NULL;
> +	char *alias = NULL;
> +	char *new_path = NULL;
>  
>  	read_lock(&devtree_lock);
> -	for (; np; np = np->allnext) {
> +
> +	if (path[0] != '/') {
> +		const char *ps;
> +		aliases = of_find_node_by_path("/aliases");
> +		if (!aliases)
> +			goto out;

Hmmm, we should probably cache the pointer to this node.

> +
> +		ps = strchr(path, '/');
> +		if (ps) {
> +			size_t len = ps - path;
> +			alias = kstrndup(path, len, GFP_KERNEL);
> +			if (!alias)
> +				goto out;
> +			path = of_get_property(aliases, alias, NULL);
> +			if (!path)
> +				goto out;
> +
> +			len = strlen(path) + strlen(ps) + 1;
> +			new_path = kmalloc(len, GFP_KERNEL);
> +			if (!new_path)
> +				goto out;
> +			strcpy(new_path, path);
> +			strcat(new_path, ps);
> +			path = new_path;
> +		} else {
> +			path = of_get_property(aliases, path, NULL);
> +		}
> +		if (!path)
> +			goto out;
> +	}

Looks about right, but I think it can be a bit more elegant and I think it
should be better documented.  Perhaps something like this?

	/*
	 * The following code has three possibilities:
	 * 1) '/' at start of string; path == ps; (based at root)
	 * 2) '/' at offset in string; path < ps; (relative to alias)
	 * 3) '/' not found; ps == NULL; (alias only)
	 *
	 * If ps != path, then it is either a pure alias (ps == NULL), or an
	 * alias with a relative path (path < ps).  Either way, look up the path
	 * pointed to by the alias.
	 */
	ps = strchr(path, '/');
	if (path != ps) {
		aliases = of_find_node_by_path("/aliases");
		if (!aliases)
			goto out;

		/* Duplicate the alias part of the string so it can be NULL terminated */
		alias = kstrndup(path, ps ? (ps - path) : strlen(path), GFP_KERNEL);
		if (!alias)
			goto out;
		path = of_get_property(aliases, alias, NULL);
		if (!path || path[0] != '/')
			goto out;

		/* If ps is not NULL, then there is a relative path to append */
		if (ps) {
			path = new_path = kzalloc(strlen(path) + strlen(ps) + 1, GFP_KERNEL);
			if (!path)
				goto out;
			sprintf(new_path, "%s%s", path, ps);
		}
	}

	/*
	 * At this point, path now points to the full unaliased path to a node,
	 * regardless of whether or not it started with an alias
	 */

What do you think?

g.

> +
> +	for (np = allnodes; np; np = np->allnext) {
>  		if (np->full_name && (of_node_cmp(np->full_name, path) == 0)
>  		    && of_node_get(np))
>  			break;
>  	}
> +out:
> +	if (aliases)
> +		of_node_put(aliases);
>  	read_unlock(&devtree_lock);
> +	kfree(alias);
> +	kfree(new_path);
>  	return np;
>  }
>  EXPORT_SYMBOL(of_find_node_by_path);
> -- 
> 1.7.2.3
> 
