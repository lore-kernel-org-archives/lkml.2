Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757882Ab2BHXvw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 18:51:52 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49921 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757700Ab2BHXvv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 18:51:51 -0500
MIME-Version: 1.0
In-Reply-To: <1328734113-3608-1-git-send-email-prarit@redhat.com>
References: <1328734113-3608-1-git-send-email-prarit@redhat.com>
Date: Wed, 8 Feb 2012 15:51:50 -0800
X-Google-Sender-Auth: js4LsQNTQ4mnA-Cj_Bs81lZp6E0
Message-ID: <CAE9FiQUbVVwN8s+fT84bOvz0xo93Pp9G58RecKYbyNKyXiEAKA@mail.gmail.com>
Subject: Re: [PATCH] Use NUMA node cpu mask in irq affinity
From: Yinghai Lu <yinghai@kernel.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 8, 2012 at 12:48 PM, Prarit Bhargava <prarit@redhat.com> wrote:
> The irq affinity files (/proc/irq/.../smp_affinity) contain a mask that is used
> to "pin" an irq to a set of cpus.  On boot this set is currently all cpus.
> This can be incorrect as ACPI SRAT may tell us that a specific device or
> bus is attached to a particular node and it's cpus.
>
> When setting up the irq affinity we should take into account the NUMA node
> cpu mask by and'ing it into the irq's affinity mask.
>
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>
> ---
>  kernel/irq/manage.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index a9a9dbe..2fb3469 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -301,6 +301,8 @@ setup_affinity(unsigned int irq, struct irq_desc *desc, struct cpumask *mask)
>        }
>
>        cpumask_and(mask, cpu_online_mask, set);
> +       if (desc->irq_data.node != -1)
> +               cpumask_and(mask, mask, cpumask_of_node(desc->irq_data.node));
>        ret = chip->irq_set_affinity(&desc->irq_data, mask, false);
>        switch (ret) {
>        case IRQ_SET_MASK_OK:
> --

How about all cpus on that node get offlined?

Yinghai
