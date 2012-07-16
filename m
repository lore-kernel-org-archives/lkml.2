Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593Ab2GPPyv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 11:54:51 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46533 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab2GPPys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 11:54:48 -0400
MIME-Version: 1.0
In-Reply-To: <1342284188-19176-6-git-send-email-Julia.Lawall@lip6.fr>
References: <1342284188-19176-1-git-send-email-Julia.Lawall@lip6.fr> <1342284188-19176-6-git-send-email-Julia.Lawall@lip6.fr>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 16 Jul 2012 09:54:26 -0600
Message-ID: <CAErSpo5FKNXEWOps3YmEP0WVZURb0cVghaTaxEJqEioNxoywQw@mail.gmail.com>
Subject: Re: [PATCH 5/6] drivers/pci/hotplug: ensure a consistent return value
 in error case
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 14, 2012 at 10:43 AM, Julia Lawall <Julia.Lawall@lip6.fr> wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>
> Typically, the return value desired for the failure of a function with an
> integer return value is a negative integer.  In these cases, the return
> value is sometimes a negative integer and sometimes 0, due to a subsequent
> initialization of the return variable within the loop.
>
> A simplified version of the semantic match that finds this problem is:
> (http://coccinelle.lip6.fr/)
>
> //<smpl>
> @r exists@
> identifier ret;
> position p;
> constant C;
> expression e1,e3,e4;
> statement S;
> @@
>
> ret = -C
> ... when != ret = e3
>     when any
> if@p (...) S
> ... when any
> if (\(ret != 0\|ret < 0\|ret > 0\) || ...) { ... return ...; }
> ... when != ret = e3
>     when any
> *if@p (...)
> {
>   ... when != ret = e4
>   return ret;
> }
> //</smpl>
>
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>
> ---
>  drivers/pci/hotplug/cpqphp_core.c    |   14 ++++++++++----
>  drivers/pci/hotplug/pcihp_skeleton.c |   14 ++++++++++----
>  drivers/pci/hotplug/shpchp_core.c    |   14 ++++++++++----
>  3 files changed, 30 insertions(+), 12 deletions(-)

I squashed this patch and patch [1/6] (for the same problem in
drivers/pci/hotplug/cpci_hotplug_core.c) and applied it to my "next"
branch.  Thanks!

> diff --git a/drivers/pci/hotplug/cpqphp_core.c b/drivers/pci/hotplug/cpqphp_core.c
> index 187a199..c8eaeb4 100644
> --- a/drivers/pci/hotplug/cpqphp_core.c
> +++ b/drivers/pci/hotplug/cpqphp_core.c
> @@ -611,7 +611,7 @@ static int ctrl_slot_setup(struct controller *ctrl,
>         u32 tempdword;
>         char name[SLOT_NAME_SIZE];
>         void __iomem *slot_entry= NULL;
> -       int result = -ENOMEM;
> +       int result;
>
>         dbg("%s\n", __func__);
>
> @@ -623,19 +623,25 @@ static int ctrl_slot_setup(struct controller *ctrl,
>
>         while (number_of_slots) {
>                 slot = kzalloc(sizeof(*slot), GFP_KERNEL);
> -               if (!slot)
> +               if (!slot) {
> +                       result = -ENOMEM;
>                         goto error;
> +               }
>
>                 slot->hotplug_slot = kzalloc(sizeof(*(slot->hotplug_slot)),
>                                                 GFP_KERNEL);
> -               if (!slot->hotplug_slot)
> +               if (!slot->hotplug_slot) {
> +                       result = -ENOMEM;
>                         goto error_slot;
> +               }
>                 hotplug_slot = slot->hotplug_slot;
>
>                 hotplug_slot->info = kzalloc(sizeof(*(hotplug_slot->info)),
>                                                         GFP_KERNEL);
> -               if (!hotplug_slot->info)
> +               if (!hotplug_slot->info) {
> +                       result = -ENOMEM;
>                         goto error_hpslot;
> +               }
>                 hotplug_slot_info = hotplug_slot->info;
>
>                 slot->ctrl = ctrl;
> diff --git a/drivers/pci/hotplug/pcihp_skeleton.c b/drivers/pci/hotplug/pcihp_skeleton.c
> index b20ceaa..1f00b93 100644
> --- a/drivers/pci/hotplug/pcihp_skeleton.c
> +++ b/drivers/pci/hotplug/pcihp_skeleton.c
> @@ -252,7 +252,7 @@ static int __init init_slots(void)
>         struct slot *slot;
>         struct hotplug_slot *hotplug_slot;
>         struct hotplug_slot_info *info;
> -       int retval = -ENOMEM;
> +       int retval;
>         int i;
>
>         /*
> @@ -261,17 +261,23 @@ static int __init init_slots(void)
>          */
>         for (i = 0; i < num_slots; ++i) {
>                 slot = kzalloc(sizeof(*slot), GFP_KERNEL);
> -               if (!slot)
> +               if (!slot) {
> +                       retval = -ENOMEM;
>                         goto error;
> +               }
>
>                 hotplug_slot = kzalloc(sizeof(*hotplug_slot), GFP_KERNEL);
> -               if (!hotplug_slot)
> +               if (!hotplug_slot) {
> +                       retval = -ENOMEM;
>                         goto error_slot;
> +               }
>                 slot->hotplug_slot = hotplug_slot;
>
>                 info = kzalloc(sizeof(*info), GFP_KERNEL);
> -               if (!info)
> +               if (!info) {
> +                       retval = -ENOMEM;
>                         goto error_hpslot;
> +               }
>                 hotplug_slot->info = info;
>
>                 slot->number = i;
> diff --git a/drivers/pci/hotplug/shpchp_core.c b/drivers/pci/hotplug/shpchp_core.c
> index 7414fd9..b6de307 100644
> --- a/drivers/pci/hotplug/shpchp_core.c
> +++ b/drivers/pci/hotplug/shpchp_core.c
> @@ -99,22 +99,28 @@ static int init_slots(struct controller *ctrl)
>         struct hotplug_slot *hotplug_slot;
>         struct hotplug_slot_info *info;
>         char name[SLOT_NAME_SIZE];
> -       int retval = -ENOMEM;
> +       int retval;
>         int i;
>
>         for (i = 0; i < ctrl->num_slots; i++) {
>                 slot = kzalloc(sizeof(*slot), GFP_KERNEL);
> -               if (!slot)
> +               if (!slot) {
> +                       retval = -ENOMEM;
>                         goto error;
> +               }
>
>                 hotplug_slot = kzalloc(sizeof(*hotplug_slot), GFP_KERNEL);
> -               if (!hotplug_slot)
> +               if (!hotplug_slot) {
> +                       retval = -ENOMEM;
>                         goto error_slot;
> +               }
>                 slot->hotplug_slot = hotplug_slot;
>
>                 info = kzalloc(sizeof(*info), GFP_KERNEL);
> -               if (!info)
> +               if (!info) {
> +                       retval = -ENOMEM;
>                         goto error_hpslot;
> +               }
>                 hotplug_slot->info = info;
>
>                 slot->hp_slot = i;
>
