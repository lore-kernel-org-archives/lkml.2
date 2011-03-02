Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578Ab1CBA4q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 19:56:46 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42344 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757501Ab1CBA4m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 19:56:42 -0500
MIME-Version: 1.0
In-Reply-To: <1299021304-4703-1-git-send-email-ddaney@caviumnetworks.com>
References: <1299021304-4703-1-git-send-email-ddaney@caviumnetworks.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 1 Mar 2011 17:56:22 -0700
X-Google-Sender-Auth: RYFtSpmIUrgSUlogq9x6ZVYdcEU
Message-ID: <AANLkTikUWwO_7-GFXJtvDmrib5LawVjgAqKmaGU=gJ75@mail.gmail.com>
Subject: Re: [PATCH] of: Make of_find_node_by_path() traverse /aliases for
 relative paths.
To: David Daney <ddaney@caviumnetworks.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 1, 2011 at 4:15 PM, David Daney <ddaney@caviumnetworks.com> wrote:
> Currently all paths passed to of_find_node_by_path() must begin with a
> '/', indicating a full path to the desired node.
>
> Augment the look-up code so that if a path does *not* begin with '/',
> the path is used as the name of an /aliases property.  The value of
> this alias is then used as the full node path to be found.

Nice, thanks David!

However, there is one more use case that this patch needs to handle.
Right now it will support:

"/full/path/to/node"
and
"alias"

but in OF terms it is also valid to specify:

"alias/relative/path/to/child"

How I would handle this is to split on the first '/', use the front
half to look up the path to the alias, and then concatenate the alias
path with the child node relative path before doing the full lookup.
Although that might not be the best way since it requires doing a copy
to a temporary buffer.

Alternately, it could be implemented with a multi test loop that does
something like:

for (; np; np = np->allnext) {
        int len = strlen(alias_path);
        if (np->full_name &&
            (strncmp(np->full_name, alias_path, len) == 0) &&
            (np->full_name[len] == '/') &&
            (strncmp(&np->full_name[len+1], relative_path,
strlen(relative_path)) == 0)) {
                of_node_get(np);
                goto out;
        }
}


[...]
> +
> +       if (path[0] != '/') {
> +               aliases = of_find_node_by_path("/aliases");
> +               if (!aliases)
> +                       goto out;
> +               path = of_get_property(aliases, path, NULL);
> +               /*
> +                * The alias must begin with '/', otherwise we could
> +                * get stuck in an endless loop and blow out the
> +                * stack.
> +                */

I don't think this is true (the endless loop part).  I don't see how
this would enter into a recursive set of calls other than the call
of_find_node_by_path("/aliases") which is hard coded with a '/' in the
first character.  The test for path[0] != '/' looks unnecessary, or am
I missing something?

> +               if (!path || path[0] != '/')
> +                       goto out;
> +       }
> +
>        for (; np; np = np->allnext) {
>                if (np->full_name && (of_node_cmp(np->full_name, path) == 0)
>                    && of_node_get(np))
>                        break;
>        }
> +out:
> +       if (aliases)
> +               of_node_put(aliases);

Since there is only one error path that needs to do this
of_node_put(), I'd put it right into the error path and save one test.

g.
