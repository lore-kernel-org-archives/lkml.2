Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab1FHUKR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 16:10:17 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33100 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309Ab1FHUKP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 16:10:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=vOTkqs8RDIfMTjgXMHfSlJhv6lPgMASgLsoxKXKb2dSO9Q9L4+ncnHlaZ7OqL8wtM9
         nlqleN16W8kI7VodGzvtlDMRU/Omb6CLOfW3hPLM1FGFEz+ksizIIL6hjqSHuNg8cjhI
         FpK0QQS4+Vb1MxoW8pP8hgDxCsRP+SoLFW0nM=
MIME-Version: 1.0
In-Reply-To: <201105202102.p4KL28Io025077@hera.kernel.org>
References: <201105202102.p4KL28Io025077@hera.kernel.org>
Date: Wed, 8 Jun 2011 22:10:14 +0200
X-Google-Sender-Auth: C2WeN2CuWFuPifTUbeZtRyynExM
Message-ID: <BANLkTimLbj1FHy9j56ScRGwc2t6Ci+QhAw@mail.gmail.com>
Subject: Re: [SCSI] tcm_fc: Adding FC_FC4 provider (tcm_fc) for FCoE target
 (TCM - target core) support
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Joe Eykholt <jeykholt@cisco.com>, Kiran Patil <kiran.patil@intel.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>    [SCSI] tcm_fc: Adding FC_FC4 provider (tcm_fc) for FCoE target (TCM - target core) support
>
>    This is a comprehensive patch for FC-FC4 provider. tcm_fc is a FC-FC4
>    provider which glues target core (TCM) with Fiber channel library
>    (libfc). tcm_fc uses existing FC4 provider hooks from Fiber channel
>    library. This Fiber channel library is used by FCoE (transport - FC
>    over Ethernet) protocol driver as well.

> --- /dev/null
> +++ b/drivers/target/tcm_fc/tfc_conf.c

> +static int __init ft_init(void)
> +{
> +       if (ft_register_configfs())
> +               return -1;
> +       if (fc_fc4_register_provider(FC_TYPE_FCP, &ft_prov)) {
> +               ft_deregister_configfs();
> +               return -1;
> +       }
> +       blocking_notifier_chain_register(&fc_lport_notifier_head, &ft_notifier);
> +       fc_lport_iterate(ft_lport_add, NULL);
> +       return 0;
> +}
> +
> +static void __exit ft_exit(void)
> +{
> +       blocking_notifier_chain_unregister(&fc_lport_notifier_head,
> +                                          &ft_notifier);
> +       fc_fc4_deregister_provider(FC_TYPE_FCP, &ft_prov);
> +       fc_lport_iterate(ft_lport_del, NULL);
> +       ft_deregister_configfs();
> +       synchronize_rcu();
> +}
> +
> +#ifdef MODULE
> +MODULE_DESCRIPTION("FC TCM fabric driver " FT_VERSION);
> +MODULE_LICENSE("GPL");
> +module_init(ft_init);
> +module_exit(ft_exit);
> +#endif /* MODULE */

If CONFIG_TCM_FC=y, this gives:

| drivers/target/tcm_fc/tfc_conf.c:642: warning: ‘ft_init’ defined but not used

Shouldn't the #ifdef MODULE and #endif just be removed?

Who else initializes this module if it's builtin?
E.g. ft_register_configfs() is global, but not used outside this source file?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
