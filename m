Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760714Ab2FVABx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 20:01:53 -0400
Received: from gate.crashing.org ([63.228.1.57]:49579 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760682Ab2FVABw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 20:01:52 -0400
Message-ID: <1340323284.16104.4.camel@pasglop>
Subject: Re: [PATCH 1/1] of: reform prom_update_property function
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Dong Aisheng <aisheng.dong@freescale.com>
Cc: Rob Herring <robherring2@gmail.com>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Date: Fri, 22 Jun 2012 10:01:24 +1000
In-Reply-To: <20120621093702.GE21231@shlinux2.ap.freescale.net>
References: <1340171647-2815-1-git-send-email-b29396@freescale.com>
	 <4FE1CB2C.5040208@gmail.com> <1340237796.28143.207.camel@pasglop>
	 <20120621093702.GE21231@shlinux2.ap.freescale.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-21 at 17:37 +0800, Dong Aisheng wrote:
> Maybe we could change it as as follows.
> It looks then the code follow is the same as before.
> Do you think if it's ok?
> 
> diff --git a/arch/powerpc/platforms/pseries/reconfig.c b/arch/powerpc/platforms/pseries/reconfig.c
> index 7b3bf76..4c237f4 100644
> --- a/arch/powerpc/platforms/pseries/reconfig.c
> +++ b/arch/powerpc/platforms/pseries/reconfig.c
> @@ -443,6 +443,9 @@ static int do_update_property(char *buf, size_t bufsize)
>         if (!next_prop)
>                 return -EINVAL;
> 
> +       if (!strlen(name)
> +               return -ENODEV;
> +
>         newprop = new_property(name, length, value, NULL);
>         if (!newprop)
>                 return -ENOMEM;
> @@ -450,13 +453,6 @@ static int do_update_property(char *buf, size_t bufsize)
>         if (!strcmp(name, "slb-size") || !strcmp(name, "ibm,slb-size"))
>                 slb_set_size(*(int *)value);
> 
> -       oldprop = of_find_property(np, name,NULL);
> -       if (!oldprop) {
> -               if (strlen(name))
> -                       return prom_add_property(np, newprop);
> -               return -ENODEV;
> -       }

No:

IE. Old code did:

	if (property doesn't exist) {
		if (has a name)
			create_it()
		return -ENODEV;
	}

What you propose is:

	if (!has_a_name)
		return -ENODEV;

Not at all the same semantic.

 .../...
 
> > IE. The allocation of the "old" property isn't disposed of. It can't
> > because today we don't know whether any of those pointers was
> > dynamically allocated or not. IE they could point to the fdt

> Hmm, i did not see static allocated property before.
> Where can we see an exist case?

Almost all your property names and values. They are pointers to the
original fdt block, so you can't free them. But dynamically added
propreties will have kmalloc'ed pointers which should be freed. We need
to add flags to indicate that if we want to avoid leaking memory in very
dynamic environments.

> If we really have this issue, it seems of_node_release also has the same issue,
> since it frees the property without distinguish whether the property is allocated
> dynamically.

Well, actually we do have a flag:

        if (!of_node_check_flag(node, OF_DYNAMIC))
                return;

So we use that. Good. So if update property uses that flag it should be
able to know when to free or not. I forgot we had that :-)

> > string list, data block, or could be bootmem ... or could be
> > actual kernel memory.
> > 
> > We might want to extend the struct property to contain indications of
> > the allocation type so we can kfree dynamic properties properly.
> > 
> I wonder the simplest way may be not allow static allocated property, like dt
> node does i guess.

No way. We generate the device-tree way before we have an allocator
available.

> > But then there's the question of the lifetime of a property... since
> > they aren't reference counted like nodes are.
> > 
> Yes, that's a real exist problem.
> 
> Anyway, i guess we could do that work of this problem in another patch
> rather than have to in this patch series.

Cheers,
Ben.


